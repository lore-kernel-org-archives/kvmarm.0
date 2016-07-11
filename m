From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 15/17] KVM: arm64: implement ITS command queue command
 handlers
Date: Mon, 11 Jul 2016 18:52:10 +0100
Message-ID: <5783DCCA.6070208@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-16-andre.przywara@arm.com> <5783D4AD.30206@arm.com>
 <3d954003-6fcd-5d2b-264b-c7eda68dadb0@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D4FA49B81
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2016 13:46:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n-S7-GDL+-RW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jul 2016 13:46:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30F8249B7F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2016 13:46:26 -0400 (EDT)
In-Reply-To: <3d954003-6fcd-5d2b-264b-c7eda68dadb0@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Diana Madalina Craciun <diana.craciun@nxp.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/07/16 18:47, Andre Przywara wrote:
> Hi,
> 
> On 11/07/16 18:17, Marc Zyngier wrote:
>> On 05/07/16 12:23, Andre Przywara wrote:
>>> The connection between a device, an event ID, the LPI number and the
>>> allocated CPU is stored in in-memory tables in a GICv3, but their
>>> format is not specified by the spec. Instead software uses a command
>>> queue in a ring buffer to let the ITS implementation use their own
>>> format.
>>> Implement handlers for the various ITS commands and let them store
>>> the requested relation into our own data structures. Those data
>>> structures are protected by the its_lock mutex.
>>> Our internal ring buffer read and write pointers are protected by the
>>> its_cmd mutex, so that at most one VCPU per ITS can handle commands at
>>> any given time.
>>> Error handling is very basic at the moment, as we don't have a good
>>> way of communicating errors to the guest (usually a SError).
>>> The INT command handler is missing at this point, as we gain the
>>> capability of actually injecting MSIs into the guest only later on.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 609 ++++++++++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 605 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index 5de71bd..432daed 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -58,6 +58,43 @@ out_unlock:
>>>  	return irq;
>>>  }
>>>  
>>> +/*
>>> + * Creates a new (reference to a) struct vgic_irq for a given LPI.
>>> + * If this LPI is already mapped on another ITS, we increase its refcount
>>> + * and return a pointer to the existing structure.
>>> + * If this is a "new" LPI, we allocate and initialize a new struct vgic_irq.
>>> + * This function returns a pointer to the _unlocked_ structure.
>>> + */
>>> +static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
>>> +{
>>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>>> +	struct vgic_irq *irq = vgic_its_get_lpi(kvm, intid);
>>
>> So this thing doesn't return with any lock held...
>>
>>> +
>>> +	/* In this case there is no put, since we keep the reference. */
>>> +	if (irq)
>>> +		return irq;
>>> +
>>> +	irq = kzalloc(sizeof(struct vgic_irq), GFP_KERNEL);
>>> +
>>> +	if (!irq)
>>> +		return NULL;
>>> +
>>> +	INIT_LIST_HEAD(&irq->lpi_entry);
>>> +	INIT_LIST_HEAD(&irq->ap_list);
>>> +	spin_lock_init(&irq->irq_lock);
>>> +
>>> +	irq->config = VGIC_CONFIG_EDGE;
>>> +	kref_init(&irq->refcount);
>>> +	irq->intid = intid;
>>
>> which means that two callers can allocate their own irq structure...
> 
> In practise this will never happen, because the only caller
> (handle_mapi) takes the its_lock mutex. But I see that this is fragile

Given that the its_lock is per ITS, and that we're dealing with global
objects, this doesn't protect against anything. I can have two VCPUs
firing MAPIs on two ITSs, and hit that path with reasonable chances of
creating mayhem.

> and not safe. I guess I can search the list again after having taken the
> lock.

Please do.

> 
>>> +
>>> +	spin_lock(&dist->lpi_list_lock);
>>> +	list_add_tail(&irq->lpi_entry, &dist->lpi_list_head);
>>> +	dist->lpi_list_count++;
>>> +	spin_unlock(&dist->lpi_list_lock);
>>
>> and insert it. Not too bad if they are different LPIs, but leading to
>> Armageddon if they are the same. You absolutely need to check for the
>> the presence of the interrupt in this list *while holding the lock*.
>>
>>> +
>>> +	return irq;
>>> +}
>>> +
>>>  struct its_device {
>>>  	struct list_head dev_list;
>>>  
> 
> ....
> 
>>> +/*
>>> + * The INVALL command requests flushing of all IRQ data in this collection.
>>> + * Find the VCPU mapped to that collection, then iterate over the VM's list
>>> + * of mapped LPIs and update the configuration for each IRQ which targets
>>> + * the specified vcpu. The configuration will be read from the in-memory
>>> + * configuration table.
>>> + */
>>> +static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
>>> +				  u64 *its_cmd)
>>> +{
>>> +	u32 coll_id = its_cmd_get_collection(its_cmd);
>>> +	struct its_collection *collection;
>>> +	struct kvm_vcpu *vcpu;
>>> +	struct vgic_irq *irq;
>>> +	u32 *intids;
>>> +	int irq_count, i;
>>> +
>>> +	mutex_lock(&its->its_lock);
>>> +
>>> +	collection = find_collection(its, coll_id);
>>> +	if (!its_is_collection_mapped(collection))
>>> +		return E_ITS_INVALL_UNMAPPED_COLLECTION;
>>> +
>>> +	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>>> +
>>> +	irq_count = vgic_its_copy_lpi_list(kvm, &intids);
>>> +	if (irq_count < 0)
>>> +		return irq_count;
>>> +
>>> +	for (i = 0; i < irq_count; i++) {
>>> +		irq = vgic_get_irq(kvm, NULL, intids[i]);
>>> +		if (!irq)
>>> +			continue;
>>> +		update_lpi_config_filtered(kvm, irq, vcpu);
>>> +		vgic_put_irq_locked(kvm, irq);
>>
>> Where is the lpi_list_lock taken?
> 
> Argh, good catch!
> 
>> And why would we need it since we've
>> copied everything already? By the look of it, this vgic_put_irq_locked
>> should not exist at all, as the only other use case is quite dubious.
> 
> Possibly, I don't like it either. Let me check if I can kill that sucker.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
