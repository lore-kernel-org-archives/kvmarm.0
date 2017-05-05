From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v6 15/24] KVM: arm64: vgic-its: Read config and pending
 bit in add_lpi()
Date: Fri, 5 May 2017 16:50:01 +0200
Message-ID: <ab5950dd-61a6-a6c2-1828-3df79e07296d@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-16-git-send-email-eric.auger@redhat.com>
 <20170505095708.GB1419@lvm> <54aa52bb-dd92-e5a8-5c5c-353fc206d203@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <54aa52bb-dd92-e5a8-5c5c-353fc206d203@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: peter.maydell@linaro.org, drjones@redhat.com, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, vijayak@caviumnetworks.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 05/05/2017 14:50, Marc Zyngier wrote:
> On 05/05/17 10:57, Christoffer Dall wrote:
>> On Thu, May 04, 2017 at 01:44:35PM +0200, Eric Auger wrote:
>>> When creating the lpi we now ask the redistributor what is the state
>>> of the LPI (priority, enabled, pending).
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>
>>> ---
>>>
>>> v6: creation
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 35 ++++++++++++++++++++++++-----------
>>>  1 file changed, 24 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index f43ea30c..3ad615a 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -38,6 +38,8 @@
>>>  
>>>  static int vgic_its_set_abi(struct vgic_its *its, int rev);
>>>  static const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its);
>>> +static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>>> +			     struct kvm_vcpu *filter_vcpu);
>>>  
>>>  /*
>>>   * Creates a new (reference to a) struct vgic_irq for a given LPI.
>>> @@ -46,10 +48,12 @@ static const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its);
>>>   * If this is a "new" LPI, we allocate and initialize a new struct vgic_irq.
>>>   * This function returns a pointer to the _unlocked_ structure.
>>>   */
>>> -static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
>>> +static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>>> +				     struct kvm_vcpu *vcpu)
>>>  {
>>>  	struct vgic_dist *dist = &kvm->arch.vgic;
>>>  	struct vgic_irq *irq = vgic_get_irq(kvm, NULL, intid), *oldirq;
>>> +	int ret;
>>>  
>>>  	/* In this case there is no put, since we keep the reference. */
>>>  	if (irq)
>>> @@ -66,6 +70,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
>>>  	irq->config = VGIC_CONFIG_EDGE;
>>>  	kref_init(&irq->refcount);
>>>  	irq->intid = intid;
>>> +	irq->target_vcpu = vcpu;
>>>  
>>>  	spin_lock(&dist->lpi_list_lock);
>>>  
>>> @@ -97,6 +102,19 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
>>>  out_unlock:
>>>  	spin_unlock(&dist->lpi_list_lock);
>>>  
>>> +	/*
>>> +	 * We "cache" the configuration table entries in out struct vgic_irq's.
>>
>> s/out/our/ ?
>>
>>> +	 * However we only have those structs for mapped IRQs, so we read in
>>> +	 * the respective config data from memory here upon mapping the LPI.
>>> +	 */
>>> +	ret = update_lpi_config(kvm, irq, NULL);
>>> +	if (ret)
>>> +		return ERR_PTR(ret);
>>> +
>>> +	ret = vgic_v3_lpi_sync_pending_status(kvm, irq);
>>> +	if (ret)
>>> +		return ERR_PTR(ret);
>>> +
>>>  	return irq;
>>>  }
>>>  
>>> @@ -769,6 +787,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>>>  	u32 event_id = its_cmd_get_id(its_cmd);
>>>  	u32 coll_id = its_cmd_get_collection(its_cmd);
>>>  	struct its_ite *ite;
>>> +	struct kvm_vcpu *vcpu = NULL;
>>>  	struct its_device *device;
>>>  	struct its_collection *collection, *new_coll = NULL;
>>>  	int lpi_nr;
>>> @@ -814,7 +833,10 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>>>  	ite->collection = collection;
>>>  	ite->lpi = lpi_nr;
>>>  
>>> -	irq = vgic_add_lpi(kvm, lpi_nr);
>>> +	if (its_is_collection_mapped(collection))
>>> +		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>>> +
>>> +	irq = vgic_add_lpi(kvm, lpi_nr, vcpu);
>>
>> So, if we don't have the collection and therefore end up with irq->vcpu
>> == NULL, how do we ever read the pending bit from memory as the affinity
>> may later change?
>>
>> Is this a problem with our idea of only looking at the pending bit on
>> vgic_add_lpi, or does it just mean that we should sample the pending bit
>> whenever we move LPIs around to VCPUs and if the bit is set, then also
>> set the pennding_latch (if not already set), or what should happen here?
> 
> It means that we would need to sample that bit on MOVI and maybe MOVALL
> as well, but this feels a bit odd. How did that bit land there the first
> place?

Without talking about save/restore, before this series the pending table
was sync'ed on RDIST LPI enable only and that's all. This is kept.

Now talking about save/restore, if we restore an LPI whose collection is
not attached to any RDIST, we can't sync at that time. The problem
exists if we check the pending bit on vgic_add_lpi or later, ie. at the
end of the ITS table restore process (as I did before). I don't see in
the spec we are supposed to read the pending table on MAPTI or MAPC.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
