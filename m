From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [RFC PATCH 09/45] KVM: arm/arm64: vgic-new: Add GICv2 IRQ
 sync/flush
Date: Tue, 5 Apr 2016 18:57:57 +0100
Message-ID: <5703FCA5.5020409@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-10-git-send-email-andre.przywara@arm.com>
 <20160330135330.GI4126@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DF24407A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Apr 2016 13:56:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ATVyKD5lT0Ja for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Apr 2016 13:56:25 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A3540402
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Apr 2016 13:56:25 -0400 (EDT)
In-Reply-To: <20160330135330.GI4126@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 30/03/16 14:53, Christoffer Dall wrote:
> On Fri, Mar 25, 2016 at 02:04:32AM +0000, Andre Przywara wrote:
>> From: Marc Zyngier <marc.zyngier@arm.com>
>>
>> Implement the functionality for syncing IRQs between our emulation
>> and the list registers, which represent the guest's view of IRQs.
>> This is done in kvm_vgic_flush_hwstate and kvm_vgic_sync_hwstate,
>> which gets called on guest entry and exit.
> 
> I thought we agreed to split this up in a generic part and then GICv2
> and GICv3 parts following, but ok, I'll look through this code, but I
> strongly suggest splitting it up for the next posting.

Right, I guess I missed this one. I abandoned the idea of splitting the
patch _series_ between a v2 and a v3 series (to avoid agreeing on the v2
implementation too early without taking the v3 requirements into
account), so I guess I skipped the comment about this patch split.
I will try to split off the generic part of the code.

>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  include/kvm/vgic/vgic.h     |   4 +
>>  virt/kvm/arm/vgic/vgic-v2.c | 161 ++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.c    | 204 ++++++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h    |   4 +
>>  4 files changed, 373 insertions(+)
>>
>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
>> index f32b284..986f23f 100644
>> --- a/include/kvm/vgic/vgic.h
>> +++ b/include/kvm/vgic/vgic.h
>> @@ -187,6 +187,10 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>>  #define vgic_valid_spi(k,i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
>>  			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
>>  
>> +bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
>> +void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
>> +void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
>> +
>>  /**
>>   * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
>>   *
>> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
>> index 0bf6f27..1cec423 100644
>> --- a/virt/kvm/arm/vgic/vgic-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-v2.c
>> @@ -14,11 +14,172 @@
>>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>   */
>>  
>> +#include <linux/irqchip/arm-gic.h>
>>  #include <linux/kvm.h>
>>  #include <linux/kvm_host.h>
>>  
>>  #include "vgic.h"
>>  
>> +/*
>> + * Call this function to convert a u64 value to an unsigned long * bitmask
>> + * in a way that works on both 32-bit and 64-bit LE and BE platforms.
>> + *
>> + * Warning: Calling this function may modify *val.
>> + */
>> +static unsigned long *u64_to_bitmask(u64 *val)
>> +{
>> +#if defined(CONFIG_CPU_BIG_ENDIAN) && BITS_PER_LONG == 32
>> +	*val = (*val >> 32) | (*val << 32);
>> +#endif
>> +	return (unsigned long *)val;
>> +}
>> +
>> +void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
>> +
>> +	if (cpuif->vgic_misr & GICH_MISR_EOI) {
>> +		u64 eisr = cpuif->vgic_eisr;
>> +		unsigned long *eisr_bmap = u64_to_bitmask(&eisr);
>> +		int lr;
>> +
>> +		for_each_set_bit(lr, eisr_bmap, vcpu->arch.vgic_cpu.nr_lr) {
>> +			struct vgic_irq *irq;
>> +			u32 intid = cpuif->vgic_lr[lr] & GICH_LR_VIRTUALID;
>> +
>> +			irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
>> +
>> +			WARN_ON(irq->config == VGIC_CONFIG_EDGE);
>> +			WARN_ON(cpuif->vgic_lr[lr] & GICH_LR_STATE);
>> +
>> +			kvm_notify_acked_irq(vcpu->kvm, 0,
>> +					     intid - VGIC_NR_PRIVATE_IRQS);
>> +
>> +			cpuif->vgic_lr[lr] &= ~GICH_LR_STATE; /* Useful?? */
> 
> we just had a warning above if the LR state was set, so how do we
> expect this to be modified in the mean time?

I guess the warning is just a warning, so code execution continues in
this case, right?

> The following line caters for the famous hardware race, right?  If so, I think it deserved a comment:
> 
> /*
>  * The hardware doesn't guarantee that the LR's bit is set in the ELRSR
>  * despite the virtual interrupt being EOIed and generating a
>  * maintenance interrupt.  Force the bit to be set.
>  */
> 
>> +			cpuif->vgic_elrsr |= 1ULL << lr;
>> +		}
>> +	}
>> +
>> +	/* check and disable underflow maintenance IRQ */
> 
> s/check and d/D/
> 
>> +	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
> 
> I think the above should be moved to fold_lr_state
> 
>> +
>> +	/*
>> +	 * In the next iterations of the vcpu loop, if we sync the
>> +	 * vgic state after flushing it, but before entering the guest
>> +	 * (this happens for pending signals and vmid rollovers), then
>> +	 * make sure we don't pick up any old maintenance interrupts
>> +	 * here.
>> +	 */
>> +	cpuif->vgic_eisr = 0;
>> +}
>> +
>> +void vgic_v2_set_underflow(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
>> +
>> +	cpuif->vgic_hcr |= GICH_HCR_UIE;
>> +}
>> +
>> +/*
>> + * transfer the content of the LRs back into the corresponding ap_list:
>> + * - active bit is transferred as is
>> + * - pending bit is
>> + *   - transferred as is in case of edge sensitive IRQs
>> + *   - set to the line-level (resample time) for level sensitive IRQs
>> + */
>> +void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
>> +	int lr;
>> +
>> +	for (lr = 0; lr < vcpu->arch.vgic_cpu.used_lrs; lr++) {
>> +		u32 val = cpuif->vgic_lr[lr];
>> +		u32 intid = val & GICH_LR_VIRTUALID;
>> +		struct vgic_irq *irq;
>> +
>> +		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
>> +
>> +		spin_lock(&irq->irq_lock);
>> +
>> +		/* Always preserve the active bit */
>> +		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
>> +
>> +		/* Edge is the only case where we preserve the pending bit */
>> +		if (irq->config == VGIC_CONFIG_EDGE &&
>> +		    (val & GICH_LR_PENDING_BIT)) {
>> +			irq->pending = true;
>> +
>> +			if (intid < VGIC_NR_SGIS) {
>> +				u32 cpuid = val & GICH_LR_PHYSID_CPUID;
>> +
>> +				cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
> 
> Are we happy with relying on all the remaining bits being 0 here or
> should we define a proper CPUID mask?

Not sure which remaining bits you mean? GICH_LR_PHYSID_CPUID is a mask
(admittedly a bit misnamed).
Or what do I miss here?

>> +				irq->source |= (1 << cpuid);
>> +			}
>> +		}
>> +
>> +		/* Clear soft pending state when level IRQs have been acked */
>> +		if (irq->config == VGIC_CONFIG_LEVEL &&
>> +		    !(val & GICH_LR_PENDING_BIT)) {
>> +			irq->soft_pending = false;
>> +			irq->pending = irq->line_level;
>> +		}
>> +
>> +		spin_unlock(&irq->irq_lock);
>> +	}
>> +}
>> +
>> +/*
>> + * Populates the particular LR with the state of a given IRQ:
>> + * - for an edge sensitive IRQ the pending state is reset in the struct
> 
> s/reset/cleared/
> s/the struct/the vgic_irq struct/
> 
>> + * - for a level sensitive IRQ the pending state value is unchanged;
>> + *   it will be resampled on deactivation
> 
> s/
> it will be resampled on deactivation/
> it is dictated directly by the input level/
> 
>> + *
>> + * If irq is not NULL, the irq_lock must be hold already by the caller.
> 
> s/hold/held/
> 
>> + * If irq is NULL, the respective LR gets cleared.
> 
> If @irq describes an SGI with multiple sources, we choose the
> lowest-numbered source VCPU and clear that bit in the source bitmap.
> 
>> + */
>> +void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>> +{
>> +	u32 val;
>> +
>> +	if (!irq) {
>> +		val = 0;
>> +		goto out;
>> +	}
> 
> I'm not convinced about keeping this functionality in this function.
> 
> Wouldn't it be much more clear to have vgic_clear_lr() as a separate
> function?

Yeah, I agree. Also found it cumbersome to explicitly call this function
with a NULL argument to clear it.

>> +
>> +	val = irq->intid;
>> +
>> +	if (irq->pending) {
>> +		val |= GICH_LR_PENDING_BIT;
>> +
>> +		if (irq->config == VGIC_CONFIG_EDGE)
>> +			irq->pending = false;
>> +
>> +		if (irq->intid < VGIC_NR_SGIS) {
>> +			u32 src = ffs(irq->source);
> 
> can't you do src = __ffs(irq->source) here to avoid the (src - 1) below?
> 
>> +
>> +			BUG_ON(!src);
>> +			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
>> +			irq->source &= ~(1 << (src - 1));
>> +			if (irq->source)
>> +				irq->pending = true;
>> +		}
>> +	}
>> +
>> +	if (irq->active)
>> +		val |= GICH_LR_ACTIVE_BIT;
>> +
>> +	if (irq->hw) {
>> +		val |= GICH_LR_HW;
>> +		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
>> +	} else {
>> +		if (irq->config == VGIC_CONFIG_LEVEL)
>> +			val |= GICH_LR_EOI;
>> +	}
>> +
>> +out:
>> +	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = val;
>> +}
>> +
>>  void vgic_v2_irq_change_affinity(struct kvm *kvm, u32 intid, u8 new_targets)
>>  {
>>  	struct vgic_dist *dist = &kvm->arch.vgic;
>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>> index 29c753e..90a85bf 100644
>> --- a/virt/kvm/arm/vgic/vgic.c
>> +++ b/virt/kvm/arm/vgic/vgic.c
>> @@ -273,3 +273,207 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>>  	vgic_update_irq_pending(kvm, vcpu, intid, level);
>>  	return 0;
>>  }
>> +
>> +/**
>> + * vgic_prune_ap_list - Remove non-relevant interrupts from the list
>> + *
>> + * @vcpu: The VCPU pointer
>> + *
>> + * Go over the list of "interesting" interrupts, and prune those that we
>> + * won't have to consider in the near future.
>> + */
>> +static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	struct vgic_irq *irq, *tmp;
>> +
>> +retry:
>> +	spin_lock(&vgic_cpu->ap_list_lock);
>> +
>> +	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
>> +		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
>> +
>> +		spin_lock(&irq->irq_lock);
>> +
>> +		BUG_ON(vcpu != irq->vcpu);
>> +
>> +		target_vcpu = vgic_target_oracle(irq);
>> +
>> +		if (!target_vcpu) {
>> +			/*
>> +			 * We don't need to process this interrupt any
>> +			 * further, move it off the list.
>> +			 */
>> +			list_del_init(&irq->ap_list);
> 
> why list_del_init and not list_del here?  do we ever do list_empty() on
> the &irq->ap_list ?

Why not? I think we discussed the usage of list_empty() for determining
if the VCPU is ready to run.
What is your concern about list_del_init? Is that too costly?

>> +			irq->vcpu = NULL;
>> +			spin_unlock(&irq->irq_lock);
>> +			continue;
>> +		}
>> +
>> +		if (target_vcpu == vcpu) {
>> +			/* We're on the right CPU */
>> +			spin_unlock(&irq->irq_lock);
>> +			continue;
>> +		}
>> +
>> +		/* This interrupt looks like it has to be migrated. */
>> +
>> +		spin_unlock(&irq->irq_lock);
>> +		spin_unlock(&vgic_cpu->ap_list_lock);
>> +
>> +		/*
>> +		 * Ensure locking order by always locking the smallest
>> +		 * ID first.
>> +		 */
>> +		if (vcpu->vcpu_id < target_vcpu->vcpu_id) {
>> +			vcpuA = vcpu;
>> +			vcpuB = target_vcpu;
>> +		} else {
>> +			vcpuA = target_vcpu;
>> +			vcpuB = vcpu;
>> +		}
>> +
>> +		spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
>> +		spin_lock(&vcpuB->arch.vgic_cpu.ap_list_lock);
>> +		spin_lock(&irq->irq_lock);
>> +
>> +		/*
>> +		 * If the affinity has been preserved, move the
>> +		 * interrupt around. Otherwise, it means things have
>> +		 * changed while the interrupt was unlocked, and we
>> +		 * need to replay this.
>> +		 *
>> +		 * In all cases, we cannot trust the list not to have
>> +		 * changed, so we restart from the beginning.
>> +		 */
>> +		if (target_vcpu == vgic_target_oracle(irq)) {
>> +			struct vgic_cpu *new_cpu = &target_vcpu->arch.vgic_cpu;
>> +
>> +			list_del_init(&irq->ap_list);
> 
> again, why list_del_init and not just list_del ?
> 
>> +			irq->vcpu = target_vcpu;
>> +			list_add_tail(&irq->ap_list, &new_cpu->ap_list_head);
>> +		}
>> +
>> +		spin_unlock(&irq->irq_lock);
>> +		spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
>> +		spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
>> +		goto retry;
>> +	}
>> +
>> +	spin_unlock(&vgic_cpu->ap_list_lock);
>> +}
>> +
>> +static inline void vgic_process_maintenance_interrupt(struct kvm_vcpu *vcpu)
>> +{
>> +	if (kvm_vgic_global_state.type == VGIC_V2)
>> +		vgic_v2_process_maintenance(vcpu);
>> +	else
>> +		WARN(1, "GICv3 Not Implemented\n");
>> +}
>> +
>> +static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
>> +{
>> +	if (kvm_vgic_global_state.type == VGIC_V2)
>> +		vgic_v2_fold_lr_state(vcpu);
>> +	else
>> +		WARN(1, "GICv3 Not Implemented\n");
>> +}
>> +
>> +/*
>> + * Requires the ap_lock to be held.
>> + * If irq is not NULL, requires the IRQ lock to be held as well.
>> + * If irq is NULL, the list register gets cleared.
>> + */
>> +static inline void vgic_populate_lr(struct kvm_vcpu *vcpu,
>> +				    struct vgic_irq *irq, int lr)
>> +{
>> +	if (kvm_vgic_global_state.type == VGIC_V2)
>> +		vgic_v2_populate_lr(vcpu, irq, lr);
>> +	else
>> +		WARN(1, "GICv3 Not Implemented\n");
>> +}
>> +
>> +static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
>> +{
>> +	if (kvm_vgic_global_state.type == VGIC_V2)
>> +		vgic_v2_set_underflow(vcpu);
>> +	else
>> +		WARN(1, "GICv3 Not Implemented\n");
>> +}
>> +
>> +static int compute_ap_list_depth(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	struct vgic_irq *irq;
>> +	int count = 0;
>> +
>> +	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
>> +		spin_lock(&irq->irq_lock);
>> +		/* GICv2 SGIs can count for more than one... */
>> +		if (irq->intid < VGIC_NR_SGIS && irq->source)
> 
> how can we have an SGI on an AP list without the irq->source field set?
> 
> Is the irq->source check to cater for GICv3?

Yes, in the v3 case irq->source is 0, so the hweight is zero as well.

>> +			count += hweight8(irq->source);
>> +		else
>> +			count++;
>> +		spin_unlock(&irq->irq_lock);
>> +	}
>> +	return count;
> 
> this does feel like an awful lot of code on each entry.

Is this really a lot of code? I count two comparisons and an inc, or the
hweight8 in case of SGIs. The latter implementation doesn't look to bad
either (given that it all happens in a register).
Or is there some code I missed?

> I'm wondering
> if we should have a count on each vgic_cpu containing the length of the
> AP list which is then adjusted via the queue and removal functions?

That sounds like some work to make sure we cover all the cases. Also we
would need to care about the consistency of this.

>> +}
>> +
>> +/* requires the vcpu ap_lock to be held */
> 
> s/ap_lock/ap_list_lock/
> 
>> +static void vgic_populate_lrs(struct kvm_vcpu *vcpu)
> 
> I'm not in love with the fact that we have two separate functions named:
> 
>   vgic_populate_lrs  and
>   vgic_populate_lr
> 
> perhaps this could be changed to 'vgic_flush_ap_list' ?

Agreed.

> 
>> +{
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
>> +	struct vgic_irq *irq;
>> +	int count = 0;
>> +
>> +	if (compute_ap_list_depth(vcpu) > vcpu->arch.vgic_cpu.nr_lr) {
>> +		vgic_set_underflow(vcpu);
>> +		vgic_sort_ap_list(vcpu);
>> +	}
>> +
>> +	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
>> +		spin_lock(&irq->irq_lock);
>> +
>> +		if (unlikely(vgic_target_oracle(irq) != vcpu))
>> +			goto next;
>> +
>> +		/*
>> +		 * If we get an SGI with multiple sources, try to get
>> +		 * them in all at once.
>> +		 */
>> +		if (model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
>> +		    irq->intid < VGIC_NR_SGIS) {
> 
> I wonder if a lot of this code would be more readable if we added and
> used the following primitives:
> vgic_irq_is_sgi()
> vgic_irq_is_ppi()
> vgic_irq_is_spi()

If that doesn't break 80 characters ... ;-)

>> +			while (irq->source && count < vcpu->arch.vgic_cpu.nr_lr)
>> +				vgic_populate_lr(vcpu, irq, count++);
>> +		} else {
>> +			vgic_populate_lr(vcpu, irq, count++);
>> +		}
> 
> this stuff about the SGIs is really dense, so I'm wondering if it's more
> clean to make it even more dense and rewrite the whole if-statement to:
> 
> 	do {
> 		vgic_populate(vcpu, irq, count++);
> 	} while (irq->source && count < vgic.nr_lr);
> 
> (btw. I believe all these places referencing the nr_lr in the vgic_cpu
> struct could use the global state structure instead).

Good point. We should convert all the places where this is easily doable
already.

> 
>> +
>> +next:
>> +		spin_unlock(&irq->irq_lock);
>> +
>> +		if (count == vcpu->arch.vgic_cpu.nr_lr)
>> +			break;
>> +	}
>> +
>> +	vcpu->arch.vgic_cpu.used_lrs = count;
>> +
>> +	/* Nuke remaining LRs */
>> +	for ( ; count < vcpu->arch.vgic_cpu.nr_lr; count++)
>> +		vgic_populate_lr(vcpu, NULL, count);
> 
> should we not change this to adhere to the optimizations Marc
> implemented for the current VGIC (i.e. clear the LRs on sync+init, and
> only write what you need here)?

Those optimizations were not in the branch I based this series on.
I will take a look with the new series being based on 4.6-rc (added
live_lrs already).

Cheers,
Andre.

BTW: Thanks for the thorough review. I agree and will change all your
comments I didn't explicitly replied on.

> 
>> +}
>> +
>> +void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>> +{
>> +	vgic_process_maintenance_interrupt(vcpu);
>> +	vgic_fold_lr_state(vcpu);
>> +	vgic_prune_ap_list(vcpu);
>> +}
>> +
>> +void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>> +{
>> +	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
>> +	vgic_populate_lrs(vcpu);
>> +	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
>> +}
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index b2faf00..95ef3cf 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -21,5 +21,9 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>>  bool vgic_queue_irq(struct kvm *kvm, struct vgic_irq *irq);
>>  
>>  void vgic_v2_irq_change_affinity(struct kvm *kvm, u32 intid, u8 target);
>> +void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu);
>> +void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
>> +void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>> +void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
>>  
>>  #endif
>> -- 
>> 2.7.3
>>
> 
> Thanks,
> -Christoffer
> 
