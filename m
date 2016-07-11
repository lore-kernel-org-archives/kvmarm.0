From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v8 15/17] KVM: arm64: implement ITS command queue command
 handlers
Date: Mon, 11 Jul 2016 18:47:54 +0100
Message-ID: <3d954003-6fcd-5d2b-264b-c7eda68dadb0@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-16-andre.przywara@arm.com> <5783D4AD.30206@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E71DE49B80
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2016 13:41:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JZH-uVVDJ52Q for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jul 2016 13:41:19 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9580C49B7F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2016 13:41:19 -0400 (EDT)
In-Reply-To: <5783D4AD.30206@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Diana Madalina Craciun <diana.craciun@nxp.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 11/07/16 18:17, Marc Zyngier wrote:
> On 05/07/16 12:23, Andre Przywara wrote:
>> The connection between a device, an event ID, the LPI number and the
>> allocated CPU is stored in in-memory tables in a GICv3, but their
>> format is not specified by the spec. Instead software uses a command
>> queue in a ring buffer to let the ITS implementation use their own
>> format.
>> Implement handlers for the various ITS commands and let them store
>> the requested relation into our own data structures. Those data
>> structures are protected by the its_lock mutex.
>> Our internal ring buffer read and write pointers are protected by the
>> its_cmd mutex, so that at most one VCPU per ITS can handle commands at
>> any given time.
>> Error handling is very basic at the moment, as we don't have a good
>> way of communicating errors to the guest (usually a SError).
>> The INT command handler is missing at this point, as we gain the
>> capability of actually injecting MSIs into the guest only later on.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 609 ++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 605 insertions(+), 4 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 5de71bd..432daed 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -58,6 +58,43 @@ out_unlock:
>>  	return irq;
>>  }
>>  
>> +/*
>> + * Creates a new (reference to a) struct vgic_irq for a given LPI.
>> + * If this LPI is already mapped on another ITS, we increase its refcount
>> + * and return a pointer to the existing structure.
>> + * If this is a "new" LPI, we allocate and initialize a new struct vgic_irq.
>> + * This function returns a pointer to the _unlocked_ structure.
>> + */
>> +static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
>> +{
>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>> +	struct vgic_irq *irq = vgic_its_get_lpi(kvm, intid);
> 
> So this thing doesn't return with any lock held...
> 
>> +
>> +	/* In this case there is no put, since we keep the reference. */
>> +	if (irq)
>> +		return irq;
>> +
>> +	irq = kzalloc(sizeof(struct vgic_irq), GFP_KERNEL);
>> +
>> +	if (!irq)
>> +		return NULL;
>> +
>> +	INIT_LIST_HEAD(&irq->lpi_entry);
>> +	INIT_LIST_HEAD(&irq->ap_list);
>> +	spin_lock_init(&irq->irq_lock);
>> +
>> +	irq->config = VGIC_CONFIG_EDGE;
>> +	kref_init(&irq->refcount);
>> +	irq->intid = intid;
> 
> which means that two callers can allocate their own irq structure...

In practise this will never happen, because the only caller
(handle_mapi) takes the its_lock mutex. But I see that this is fragile
and not safe. I guess I can search the list again after having taken the
lock.

>> +
>> +	spin_lock(&dist->lpi_list_lock);
>> +	list_add_tail(&irq->lpi_entry, &dist->lpi_list_head);
>> +	dist->lpi_list_count++;
>> +	spin_unlock(&dist->lpi_list_lock);
> 
> and insert it. Not too bad if they are different LPIs, but leading to
> Armageddon if they are the same. You absolutely need to check for the
> the presence of the interrupt in this list *while holding the lock*.
> 
>> +
>> +	return irq;
>> +}
>> +
>>  struct its_device {
>>  	struct list_head dev_list;
>>  

....

>> +/*
>> + * The INVALL command requests flushing of all IRQ data in this collection.
>> + * Find the VCPU mapped to that collection, then iterate over the VM's list
>> + * of mapped LPIs and update the configuration for each IRQ which targets
>> + * the specified vcpu. The configuration will be read from the in-memory
>> + * configuration table.
>> + */
>> +static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
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
>> +	irq_count = vgic_its_copy_lpi_list(kvm, &intids);
>> +	if (irq_count < 0)
>> +		return irq_count;
>> +
>> +	for (i = 0; i < irq_count; i++) {
>> +		irq = vgic_get_irq(kvm, NULL, intids[i]);
>> +		if (!irq)
>> +			continue;
>> +		update_lpi_config_filtered(kvm, irq, vcpu);
>> +		vgic_put_irq_locked(kvm, irq);
> 
> Where is the lpi_list_lock taken?

Argh, good catch!

> And why would we need it since we've
> copied everything already? By the look of it, this vgic_put_irq_locked
> should not exist at all, as the only other use case is quite dubious.

Possibly, I don't like it either. Let me check if I can kill that sucker.

Cheers,
Andre.

> 
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
>> + */
>> +static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>> +				  u64 *its_cmd)
>> +{
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
>> +static int vgic_its_handle_command(struct kvm *kvm, struct vgic_its *its,
>>  			       u64 *its_cmd)
>>  {
>> -	return -ENODEV;
>> +	u8 cmd = its_cmd_get_command(its_cmd);
>> +	int ret = -ENODEV;
>> +
>> +	switch (cmd) {
>> +	case GITS_CMD_MAPD:
>> +		ret = vgic_its_cmd_handle_mapd(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_MAPC:
>> +		ret = vgic_its_cmd_handle_mapc(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_MAPI:
>> +		ret = vgic_its_cmd_handle_mapi(kvm, its, its_cmd, cmd);
>> +		break;
>> +	case GITS_CMD_MAPTI:
>> +		ret = vgic_its_cmd_handle_mapi(kvm, its, its_cmd, cmd);
>> +		break;
>> +	case GITS_CMD_MOVI:
>> +		ret = vgic_its_cmd_handle_movi(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_DISCARD:
>> +		ret = vgic_its_cmd_handle_discard(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_CLEAR:
>> +		ret = vgic_its_cmd_handle_clear(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_MOVALL:
>> +		ret = vgic_its_cmd_handle_movall(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_INV:
>> +		ret = vgic_its_cmd_handle_inv(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_INVALL:
>> +		ret = vgic_its_cmd_handle_invall(kvm, its, its_cmd);
>> +		break;
>> +	case GITS_CMD_SYNC:
>> +		/* we ignore this command: we are in sync all of the time */
>> +		ret = 0;
>> +		break;
>> +	}
> 
> Given that most commands do take the its mutex, it would make a lot of
> sense to move the locking here, and remove it from all of the other
> commands. This will streamline the code.
> 
>> +
>> +	return ret;
>>  }
>>  
>>  static u64 vgic_sanitise_its_baser(u64 reg)
>> @@ -403,7 +1004,7 @@ static void vgic_mmio_write_its_cwriter(struct kvm *kvm, struct vgic_its *its,
>>  		 * We just ignore that command then.
>>  		 */
>>  		if (!ret)
>> -			vits_handle_command(kvm, its, cmd_buf);
>> +			vgic_its_handle_command(kvm, its, cmd_buf);
> 
> Care to solve this function renaming nit?
> 
>>  
>>  		its->creadr += ITS_CMD_SIZE;
>>  		if (its->creadr == ITS_CMD_BUFFER_SIZE(its->cbaser))
>>
> 
> Thanks,
> 
> 	M.
> 
