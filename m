From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 15/17] KVM: arm64: implement ITS command queue
 command handlers
Date: Thu, 14 Jul 2016 17:33:00 +0100
Message-ID: <20160714173300.0ae8618e@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
 <20160713015909.28793-16-andre.przywara@arm.com> <57876B90.9050905@arm.com>
 <ef296d17-c24e-142a-761f-cf9ae0f44be5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <ef296d17-c24e-142a-761f-cf9ae0f44be5@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 14/07/16 16:35, Andre Przywara wrote:
> Hi Marc,
> 
> On 14/07/16 11:38, Marc Zyngier wrote:
>> On 13/07/16 02:59, Andre Przywara wrote:
>>> The connection between a device, an event ID, the LPI number and the
>>> associated CPU is stored in in-memory tables in a GICv3, but their
>>> format is not specified by the spec. Instead software uses a command
>>> queue in a ring buffer to let an ITS implementation use its own
>>> format.
>>> Implement handlers for the various ITS commands and let them store
>>> the requested relation into our own data structures. Those data
>>> structures are protected by the its_lock mutex.
>>> Our internal ring buffer read and write pointers are protected by the
>>> its_cmd mutex, so that only one VCPU per ITS can handle commands at
>>> any given time.
>>> Error handling is very basic at the moment, as we don't have a good
>>> way of communicating errors to the guest (usually an SError).
>>> The INT command handler is missing from this patch, as we gain the
>>> capability of actually injecting MSIs into the guest only later on.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 599 ++++++++++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 598 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index 60108f8..28abfcd 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
> 
> [...]
> 
>>>  
>>>  /*
>>> + * Promotes the ITS view of affinity of an ITTE (which redistributor this LPI
>>> + * is targeting) to the VGIC's view, which deals with target VCPUs.
>>> + * Needs to be called whenever either the collection for a LPIs has
>>> + * changed or the collection itself got retargeted.
>>> + */
>>> +static void update_affinity_itte(struct kvm *kvm, struct its_itte *itte)
>>> +{
>>> +	struct kvm_vcpu *vcpu;
>>> +
>>> +	vcpu = kvm_get_vcpu(kvm, itte->collection->target_addr);
>>
>> What happens if the collection hasn't been mapped yet? It is probably
>> worth checking before blindly assigning a NULL pointer, which would
>> corrupt the state set by another ITS.
> 
> OK, I can add an "if (!itte->collection) return;" for sanity. But this
> is an internal function, intended to promote a new mapping to the struct
> vgic_irqs, so both callers explicitly check for a mapped collection just
> before calling this function. So This check would be a bit redundant.
> Shall I instead add a comment documenting the requirement of the
> collection already being mapped?

This is not the way I read it. In vgic_its_cmd_handle_mapi:

	if (!collection) {
		collection = new_coll;
		vgic_its_init_collection(its, collection, coll_id);
	}

	itte->collection = collection;
	itte->lpi = lpi_nr;
	itte->irq = vgic_add_lpi(kvm, lpi_nr);
	update_affinity_itte(kvm, itte);

If new_coll has never been mapped, you end up with the exact situation I
described, and I don't see how you make it work without checking for
target_addr being a valid vcpu index.

> 
>>> +
>>> +	spin_lock(&itte->irq->irq_lock);
>>> +	itte->irq->target_vcpu = vcpu;
>>> +	spin_unlock(&itte->irq->irq_lock);
>>> +}
> 
> [...]
> 
>>> +
>>> +/*
>>> + * The MAPTI and MAPI commands map LPIs to ITTEs.
>>> + * Must be called with its_lock mutex held.
>>> + */
>>> +static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>>> +				    u64 *its_cmd, u8 subcmd)
>>> +{
>>> +	u32 device_id = its_cmd_get_deviceid(its_cmd);
>>> +	u32 event_id = its_cmd_get_id(its_cmd);
>>> +	u32 coll_id = its_cmd_get_collection(its_cmd);
>>> +	struct its_itte *itte;
>>> +	struct its_device *device;
>>> +	struct its_collection *collection, *new_coll = NULL;
>>> +	int lpi_nr;
>>> +
>>> +	device = find_its_device(its, device_id);
>>> +	if (!device)
>>> +		return E_ITS_MAPTI_UNMAPPED_DEVICE;
>>> +
>>> +	collection = find_collection(its, coll_id);
>>
>> Don't you need to check the range of the collection ID, and whether it
>> would fit in the collection table?
> 
> We support the full range of 16 bits for the collection ID, and we can't
> get more than 16 bits out of this field, so it always fits.
> Does that sound right?

Let's try it. Collections are "stored" in the collection table, which
can contain at most TableSize/EntrySize entries, which is determined by
how many pages the guest has allocated. Eventually, we'll be able to
migrate the guest, and will need to write this into the allocated
memory.

To be able to map all 2^16 collections, at 8 bytes per entry, you'd need
512kB. Linux will only allocate 64kB for example.

So to answer your question: No, this doesn't sound right at all.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
