From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v9 15/17] KVM: arm64: implement ITS command queue command
 handlers
Date: Thu, 14 Jul 2016 16:35:57 +0100
Message-ID: <ef296d17-c24e-142a-761f-cf9ae0f44be5@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
 <20160713015909.28793-16-andre.przywara@arm.com> <57876B90.9050905@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 399EC48529
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2016 11:29:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OZ8MO4q830Xu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2016 11:29:15 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C407441390
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2016 11:29:15 -0400 (EDT)
In-Reply-To: <57876B90.9050905@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 14/07/16 11:38, Marc Zyngier wrote:
> On 13/07/16 02:59, Andre Przywara wrote:
>> The connection between a device, an event ID, the LPI number and the
>> associated CPU is stored in in-memory tables in a GICv3, but their
>> format is not specified by the spec. Instead software uses a command
>> queue in a ring buffer to let an ITS implementation use its own
>> format.
>> Implement handlers for the various ITS commands and let them store
>> the requested relation into our own data structures. Those data
>> structures are protected by the its_lock mutex.
>> Our internal ring buffer read and write pointers are protected by the
>> its_cmd mutex, so that only one VCPU per ITS can handle commands at
>> any given time.
>> Error handling is very basic at the moment, as we don't have a good
>> way of communicating errors to the guest (usually an SError).
>> The INT command handler is missing from this patch, as we gain the
>> capability of actually injecting MSIs into the guest only later on.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 599 ++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 598 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 60108f8..28abfcd 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c

[...]

>>  
>>  /*
>> + * Promotes the ITS view of affinity of an ITTE (which redistributor this LPI
>> + * is targeting) to the VGIC's view, which deals with target VCPUs.
>> + * Needs to be called whenever either the collection for a LPIs has
>> + * changed or the collection itself got retargeted.
>> + */
>> +static void update_affinity_itte(struct kvm *kvm, struct its_itte *itte)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +
>> +	vcpu = kvm_get_vcpu(kvm, itte->collection->target_addr);
> 
> What happens if the collection hasn't been mapped yet? It is probably
> worth checking before blindly assigning a NULL pointer, which would
> corrupt the state set by another ITS.

OK, I can add an "if (!itte->collection) return;" for sanity. But this
is an internal function, intended to promote a new mapping to the struct
vgic_irqs, so both callers explicitly check for a mapped collection just
before calling this function. So This check would be a bit redundant.
Shall I instead add a comment documenting the requirement of the
collection already being mapped?

>> +
>> +	spin_lock(&itte->irq->irq_lock);
>> +	itte->irq->target_vcpu = vcpu;
>> +	spin_unlock(&itte->irq->irq_lock);
>> +}

[...]

>> +
>> +/*
>> + * The MAPTI and MAPI commands map LPIs to ITTEs.
>> + * Must be called with its_lock mutex held.
>> + */
>> +static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>> +				    u64 *its_cmd, u8 subcmd)
>> +{
>> +	u32 device_id = its_cmd_get_deviceid(its_cmd);
>> +	u32 event_id = its_cmd_get_id(its_cmd);
>> +	u32 coll_id = its_cmd_get_collection(its_cmd);
>> +	struct its_itte *itte;
>> +	struct its_device *device;
>> +	struct its_collection *collection, *new_coll = NULL;
>> +	int lpi_nr;
>> +
>> +	device = find_its_device(its, device_id);
>> +	if (!device)
>> +		return E_ITS_MAPTI_UNMAPPED_DEVICE;
>> +
>> +	collection = find_collection(its, coll_id);
> 
> Don't you need to check the range of the collection ID, and whether it
> would fit in the collection table?

We support the full range of 16 bits for the collection ID, and we can't
get more than 16 bits out of this field, so it always fits.
Does that sound right?

Cheers,
Andre.
