From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v7 15/17] KVM: arm64: implement ITS command queue command
 handlers
Date: Thu, 30 Jun 2016 15:06:02 +0100
Message-ID: <07a2ba5c-b835-a695-b686-94b9886cffc0@arm.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
 <20160628123230.26255-16-andre.przywara@arm.com>
 <HE1PR04MB13217EC32E3B56C2F0178222FF240@HE1PR04MB1321.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61D6649B42
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 10:00:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 60UlwvOVHOOa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 10:00:06 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD71249B2C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 10:00:06 -0400 (EDT)
In-Reply-To: <HE1PR04MB13217EC32E3B56C2F0178222FF240@HE1PR04MB1321.eurprd04.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Diana Madalina Craciun <diana.craciun@nxp.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Diana,

thanks for having such an elaborate look!

On 30/06/16 12:22, Diana Madalina Craciun wrote:
> Hi Andre,
> 
> On 06/28/2016 03:32 PM, Andre Przywara wrote:

...

>> +/* The MAPC command maps collection IDs to redistributors. */
>> +static int vits_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
>> +				u64 *its_cmd)
>> +{
>> +	u16 coll_id;
>> +	u32 target_addr;
>> +	struct its_collection *collection;
>> +	bool valid;
>> +	int ret = 0;
>> +
>> +	valid = its_cmd_get_validbit(its_cmd);
>> +	coll_id = its_cmd_get_collection(its_cmd);
>> +	target_addr = its_cmd_get_target_addr(its_cmd);
>> +
>> +	if (target_addr >= atomic_read(&kvm->online_vcpus))
>> +		return E_ITS_MAPC_PROCNUM_OOR;
>> +
>> +	mutex_lock(&its->its_lock);
>> +
>> +	collection = find_collection(its, coll_id);
>> +
>> +	if (!valid) {
>> +		struct its_device *device;
>> +		struct its_itte *itte;
>> +		/*
>> +		 * Clearing the mapping for that collection ID removes the
>> +		 * entry from the list. If there wasn't any before, we can
>> +		 * go home early.
>> +		 */
>> +		if (!collection)
>> +			goto out_unlock;
>> +
>> +		for_each_lpi_its(device, itte, its)
>> +			if (itte->collection &&
>> +			    itte->collection->collection_id == coll_id)
>> +				itte->collection = NULL;
>> +
>> +		list_del(&collection->coll_list);
>> +		kfree(collection);
>> +	} else {
>> +		if (!collection) {
>> +			collection = kzalloc(sizeof(struct its_collection),
>> +					     GFP_KERNEL);
>> +			if (!collection) {
>> +				ret = -ENOMEM;
>> +				goto out_unlock;
>> +			}
>> +		}
>> +
>> +		vits_init_collection(its, collection, coll_id);
>> +		collection->target_addr = target_addr;
> 
> Why initializing the collection also in the case it was previously
> found? Can't we end up adding a collection with the same ID twice to the
> collection list?

Oh right, the vits_init_collection() call has to move inside the if
clause. Good catch!

>> +		update_affinity_collection(kvm, its, collection);
> 
> In case the collection was newly allocated it has no interrupts mapped.
> So, I guess, it is no use iterating through the ITTE list because we
> will not find any interrupt.

Yes, though it doesn't hurt to do it anyway. I will try to create an
else clause and see how that looks like.

>> +	}
>> +
>> +out_unlock:
>> +	mutex_unlock(&its->its_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +/* The CLEAR command removes the pending state for a particular LPI. */
>> +static int vits_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
>> +				 u64 *its_cmd)
>> +{
>> +	u32 device_id;
>> +	u32 event_id;
>> +	struct its_itte *itte;
>> +	int ret = 0;
>> +
>> +	device_id = its_cmd_get_deviceid(its_cmd);
>> +	event_id = its_cmd_get_id(its_cmd);
>> +
>> +	mutex_lock(&its->its_lock);
>> +
>> +	itte = find_itte(its, device_id, event_id);
>> +	if (!itte) {
>> +		ret = E_ITS_CLEAR_UNMAPPED_INTERRUPT;
>> +		goto out_unlock;
>> +	}
>> +
>> +	itte->irq->pending = false;
>> +
>> +out_unlock:
>> +	mutex_unlock(&its->its_lock);
>> +	return ret;
>> +}
>> +
>> +/* The INV command syncs the configuration bits from the memory table. */
>> +static int vits_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
>> +			       u64 *its_cmd)
>> +{
>> +	u32 device_id;
>> +	u32 event_id;
>> +	struct its_itte *itte;
>> +	int ret;
>> +
>> +	device_id = its_cmd_get_deviceid(its_cmd);
>> +	event_id = its_cmd_get_id(its_cmd);
>> +
>> +	mutex_lock(&its->its_lock);
>> +
>> +	itte = find_itte(its, device_id, event_id);
>> +	if (!itte) {
>> +		ret = E_ITS_INV_UNMAPPED_INTERRUPT;
>> +		goto out_unlock;
>> +	}
>> +
>> +	ret = update_lpi_config(kvm, itte->irq);
>> +
>> +out_unlock:
>> +	mutex_unlock(&its->its_lock);
>> +	return ret;
>> +}
>> +
>> +/*
>> + * The INVALL command requests flushing of all IRQ data in this collection.
>> + * Find the VCPU mapped to that collection, then iterate over the VM's list
>> + * of mapped LPIs and update the configuration for each IRQ which targets
>> + * the specified vcpu. The configuration will be read from the in-memory
>> + * configuration table.
>> + */
>> +static int vits_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
>> +				  u64 *its_cmd)
>> +{
>> +	u32 coll_id = its_cmd_get_collection(its_cmd);
>> +	struct its_collection *collection;
>> +	struct kvm_vcpu *vcpu;
>> +	struct vgic_irq *irq;
>> +	u32 *intids;
>> +	int irq_count, i;
>> +
>> +	mutex_lock(&its->its_lock);
>> +
>> +	collection = find_collection(its, coll_id);
>> +	if (!its_is_collection_mapped(collection))
>> +		return E_ITS_INVALL_UNMAPPED_COLLECTION;
>> +
>> +	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>> +
>> +	irq_count = vits_copy_lpi_list(kvm, &intids);
>> +	if (irq_count < 0)
>> +		return irq_count;
>> +
>> +	for (i = 0; i < irq_count; i++) {
>> +		irq = vgic_get_irq(kvm, NULL, intids[i]);
>> +		if (!irq)
>> +			continue;
>> +		update_lpi_config_filtered(kvm, irq, vcpu);
>> +		vgic_put_irq_locked(kvm, irq);
>> +	}
>> +
>> +	kfree(intids);
>> +
>> +	mutex_unlock(&its->its_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * The MOVALL command moves the pending state of all IRQs targeting one
>> + * redistributor to another. We don't hold the pending state in the VCPUs,
>> + * but in the IRQs instead, so there is really not much to do for us here.
>> + * However the spec says that no IRQ must target the old redistributor
>> + * afterwards, so we make sure that no LPI is using the associated target_vcpu.
>> + * This command affects all LPIs in the system.
> 
> I am not sure I understand what "This command affects all LPIs in the
> system" means. Only the LPIs that are targeting redistributor 1 are
> affected.

Yes, but not only those LPIs that are mapped on _this_ ITS - that's why
we have to iterate the per-VM LPI list instead of just the ITS data
structures.
I think I will refine the comment, thanks for mentioning this.

> 
>> + */
>> +static int vits_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>> +				  u64 *its_cmd)
>> +{
> 
> I am not sure I understand the spec correctly. So, after the movall
> instruction the target for all the interrupts targeting redistributor 1
> changed. However, what happens with the collection the interrupts are
> mapped to? I see that the target CPU for the collection does not change.
> The spec says: "In particular, an implementation might choose to remap
> all affected collections to RDbase2 ." I guess that the user should use
> mapc - movall combination for mapping the collection to another
> redistributor. Is my understanding correct?

Yes, movall alone is not sufficient to move LPIs from one redist to
another, it's just meant to move the _pending state_. The spec is indeed
not very clear about it, for instance "pending state" is only mentioned
in the pseudo code (that's why I also got it wrong in v5). And indeed I
was also reading the sentence you mentioned when implementing v5.
Frankly I am not sure we actually need this moving in our
implementation, but as the spec explicitly mentions this I thought it
would be a good idea to be sure of that.

Thanks again to the review!

Cheers,
Andre.

>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>> +	u32 target1_addr = its_cmd_get_target_addr(its_cmd);
>> +	u32 target2_addr = its_cmd_mask_field(its_cmd, 3, 16, 32);
>> +	struct kvm_vcpu *vcpu1, *vcpu2;
>> +	struct vgic_irq *irq;
>> +
>> +	if (target1_addr >= atomic_read(&kvm->online_vcpus) ||
>> +	    target2_addr >= atomic_read(&kvm->online_vcpus))
>> +		return E_ITS_MOVALL_PROCNUM_OOR;
>> +
>> +	if (target1_addr == target2_addr)
>> +		return 0;
>> +
>> +	vcpu1 = kvm_get_vcpu(kvm, target1_addr);
>> +	vcpu2 = kvm_get_vcpu(kvm, target2_addr);
>> +
>> +	spin_lock(&dist->lpi_list_lock);
>> +
>> +	list_for_each_entry(irq, &dist->lpi_list_head, lpi_entry) {
>> +		spin_lock(&irq->irq_lock);
>> +
>> +		if (irq->target_vcpu == vcpu1)
>> +			irq->target_vcpu = vcpu2;
>> +
>> +		spin_unlock(&irq->irq_lock);
>> +	}
>> +
>> +	spin_unlock(&dist->lpi_list_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * This function is called with the its_cmd lock held, but the ITS data
>> + * structure lock dropped. It is within the responsibility of the actual
>> + * command handlers to take care of proper locking when needed.
>> + */
>>  static int vits_handle_command(struct kvm *kvm, struct vgic_its *its,
>>  			       u64 *its_cmd)
>>  {
>> -	return -ENODEV;
>> +	u8 cmd = its_cmd_get_command(its_cmd);
>> +	int ret = -ENODEV;
>> +
>> +	switch (cmd) {
>> +	case GITS_CMD_MAPD:
>> +		ret = vits_cmd_handle_mapd(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_MAPC:
>> +		ret = vits_cmd_handle_mapc(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_MAPI:
>> +		ret = vits_cmd_handle_mapi(kvm, its, its_cmd, cmd);
>> +		break;
>> +	case GITS_CMD_MAPTI:
>> +		ret = vits_cmd_handle_mapi(kvm, its, its_cmd, cmd);
>> +		break;
>> +	case GITS_CMD_MOVI:
>> +		ret = vits_cmd_handle_movi(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_DISCARD:
>> +		ret = vits_cmd_handle_discard(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_CLEAR:
>> +		ret = vits_cmd_handle_clear(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_MOVALL:
>> +		ret = vits_cmd_handle_movall(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_INV:
>> +		ret = vits_cmd_handle_inv(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_INVALL:
>> +		ret = vits_cmd_handle_invall(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_SYNC:
>> +		/* we ignore this command: we are in sync all of the time */
>> +		ret = 0;
>> +		break;
>> +	}
>> +
>> +	return ret;
>>  }
>>  
>>  static u64 vgic_sanitise_its_baser(u64 reg)
> 
> Thanks,
> 
> Diana
> 
> 
> 
