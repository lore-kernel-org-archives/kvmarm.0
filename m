From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 10/45] KVM: arm/arm64: vgic-new: Add GICv3 world
 switch backend
Date: Wed, 30 Mar 2016 22:40:12 +0200
Message-ID: <20160330204012.GN4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-11-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA56241267
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2016 16:39:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MVjtI8ype1Km for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Mar 2016 16:39:11 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3606E4011D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2016 16:39:10 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id 20so86951916wmh.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2016 13:40:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1458871508-17279-11-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 25, 2016 at 02:04:33AM +0000, Andre Przywara wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> As the GICv3 virtual interface registers differ from their GICv2
> siblings, we need different handlers for processing maintenance
> interrupts and reading/writing to the LRs.
> Also as we store an IRQ's affinity directly as a MPIDR, we need a
> separate change_affinity() implementation too.

not sure why we embed the vgic_v3_irq_change_affinity in this patch here
and had a stand-alone patch for v2?

I think it would be better to split them up and again have one patch to
introduce the infrastructure for some piece of functionality, followed
by 2 patches, one plugging in the v2 part, the other plugging in the v3
part.


> Implement the respective handler functions and connect them to
> existing code to be called if the host is using a GICv3.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v3.c | 191 ++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.c    |   8 +-
>  virt/kvm/arm/vgic/vgic.h    |  30 +++++++
>  3 files changed, 225 insertions(+), 4 deletions(-)
>  create mode 100644 virt/kvm/arm/vgic/vgic-v3.c
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> new file mode 100644
> index 0000000..71b4bad
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -0,0 +1,191 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program. If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/irqchip/arm-gic-v3.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <linux/irqchip/arm-gic.h>
> +
> +#include "vgic.h"
> +
> +void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
> +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> +
> +	if (cpuif->vgic_misr & ICH_MISR_EOI) {
> +		unsigned long eisr_bmap = cpuif->vgic_eisr;
> +		int lr;
> +
> +		for_each_set_bit(lr, &eisr_bmap, vcpu->arch.vgic_cpu.nr_lr) {
> +			u32 intid;
> +			u64 val = cpuif->vgic_lr[lr];
> +
> +			if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
> +				intid = val & ICH_LR_VIRTUAL_ID_MASK;
> +			else
> +				intid = val & GICH_LR_VIRTUALID;
> +
> +			/*
> +			 * kvm_notify_acked_irq calls kvm_set_irq()
> +			 * to reset the IRQ level, which grabs the dist->lock
> +			 * so we call this before taking the dist->lock.
> +			 */

this comment clearly doesn't apply anymore.

also, looking at the similarities here with the v2 code, we should
probably have another look at sharing some more code between v2 and v3.

> +			kvm_notify_acked_irq(vcpu->kvm, 0,
> +					     intid - VGIC_NR_PRIVATE_IRQS);
> +
> +			cpuif->vgic_lr[lr] &= ~ICH_LR_STATE; /* Useful?? */

here you don't have the WARN that you had in v2, so does this mean we
can actually come here with the LR state field having some value?

> +			cpuif->vgic_elrsr |= 1ULL << lr;
> +		}
> +
> +		/*
> +		 * In the next iterations of the vcpu loop, if we sync
> +		 * the vgic state after flushing it, but before
> +		 * entering the guest (this happens for pending
> +		 * signals and vmid rollovers), then make sure we
> +		 * don't pick up any old maintenance interrupts here.
> +		 */
> +		cpuif->vgic_eisr = 0;
> +	}
> +
> +	cpuif->vgic_hcr &= ~ICH_HCR_UIE;

like in the v2 case, I think this should be moved out of the process
maintenance function.

> +}
> +
> +void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	cpuif->vgic_hcr |= ICH_HCR_UIE;
> +}
> +
> +void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
> +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> +	int lr;
> +
> +	/* Assumes ap_list_lock held */
> +
> +	for (lr = 0; lr < vcpu->arch.vgic_cpu.used_lrs; lr++) {
> +		u64 val = cpuif->vgic_lr[lr];
> +		u32 intid;
> +		struct vgic_irq *irq;
> +
> +		if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
> +			intid = val & ICH_LR_VIRTUAL_ID_MASK;
> +		else
> +			intid = val & GICH_LR_VIRTUALID;
> +		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
> +
> +		spin_lock(&irq->irq_lock);
> +
> +		/* Always preserve the active bit */
> +		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
> +
> +		/* Edge is the only case where we preserve the pending bit */
> +		if (irq->config == VGIC_CONFIG_EDGE &&
> +		    (val & ICH_LR_PENDING_BIT)) {
> +			irq->pending = true;
> +
> +			if (intid < VGIC_NR_SGIS &&
> +			    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
> +				u32 cpuid = val & GICH_LR_PHYSID_CPUID;
> +
> +				cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
> +				irq->source |= (1 << cpuid);
> +			}
> +		}
> +
> +		/* Clear soft pending state when level irqs have been acked */
> +		if (irq->config == VGIC_CONFIG_LEVEL &&
> +		    !(val & ICH_LR_PENDING_BIT)) {
> +			irq->soft_pending = false;
> +			irq->pending = irq->line_level;
> +		}
> +
> +		spin_unlock(&irq->irq_lock);
> +	}
> +}
> +
> +/* Requires the irq to be locked already */
> +void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
> +{
> +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> +	u64 val;
> +
> +	if (!irq) {
> +		val = 0;
> +		goto out;
> +	}
> +
> +	val = irq->intid;
> +
> +	if (irq->pending) {
> +		val |= ICH_LR_PENDING_BIT;
> +
> +		if (irq->config == VGIC_CONFIG_EDGE)
> +			irq->pending = false;
> +
> +		if (irq->intid < VGIC_NR_SGIS &&
> +		    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
> +			u32 src = ffs(irq->source);
> +
> +			BUG_ON(!src);
> +			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
> +			irq->source &= ~(1 << (src - 1));
> +			if (irq->source)
> +				irq->pending = true;
> +		}
> +	}
> +
> +	if (irq->active)
> +		val |= ICH_LR_ACTIVE_BIT;
> +
> +	if (irq->hw) {
> +		val |= ICH_LR_HW;
> +		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
> +	} else {
> +		if (irq->config == VGIC_CONFIG_LEVEL)
> +			val |= ICH_LR_EOI;
> +	}

indeed this code looks very much like the v2 code, so maybe Marc had a
point when he argued for this being more shared between v2 and v3.  Is
there a nice way to do that without an intermediate LR representation?

> +
> +	/*
> +	 * Currently all guest IRQs are Group1, as Group0 would result
> +	 * in a FIQ in the guest, which it wouldn't expect.
> +	 * Eventually we want to make this configurable, so we may
> +	 * revisit this in the future.

I know we have something similar in the current code, but I actually
don't understand this.  If the IRQ is programmed to be group0, then the
guest *would* expect an FIQ, or?

Why is this not a matter of reading which group this IRQ is configured
to be?

> +	 */
> +	if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
> +		val |= ICH_LR_GROUP;
> +
> +out:
> +	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = val;
> +}
> +
> +void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid, u64 mpidr)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_irq *irq;
> +	struct kvm_vcpu *vcpu;
> +
> +	BUG_ON(intid <= VGIC_MAX_PRIVATE || intid > 1019);
> +	BUG_ON(dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3);

do we need the last BUG_ON?

> +
> +	irq = vgic_get_irq(kvm, NULL, intid);
> +	vcpu = kvm_mpidr_to_vcpu(kvm, mpidr);
> +
> +	spin_lock(&irq->irq_lock);
> +	irq->target_vcpu = vcpu;
> +	spin_unlock(&irq->irq_lock);
> +}


> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 90a85bf..9eb031e8 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -368,7 +368,7 @@ static inline void vgic_process_maintenance_interrupt(struct kvm_vcpu *vcpu)
>  	if (kvm_vgic_global_state.type == VGIC_V2)
>  		vgic_v2_process_maintenance(vcpu);
>  	else
> -		WARN(1, "GICv3 Not Implemented\n");
> +		vgic_v3_process_maintenance(vcpu);
>  }
>  
>  static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
> @@ -376,7 +376,7 @@ static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
>  	if (kvm_vgic_global_state.type == VGIC_V2)
>  		vgic_v2_fold_lr_state(vcpu);
>  	else
> -		WARN(1, "GICv3 Not Implemented\n");
> +		vgic_v3_fold_lr_state(vcpu);
>  }
>  
>  /*
> @@ -390,7 +390,7 @@ static inline void vgic_populate_lr(struct kvm_vcpu *vcpu,
>  	if (kvm_vgic_global_state.type == VGIC_V2)
>  		vgic_v2_populate_lr(vcpu, irq, lr);
>  	else
> -		WARN(1, "GICv3 Not Implemented\n");
> +		vgic_v3_populate_lr(vcpu, irq, lr);
>  }
>  
>  static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
> @@ -398,7 +398,7 @@ static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
>  	if (kvm_vgic_global_state.type == VGIC_V2)
>  		vgic_v2_set_underflow(vcpu);
>  	else
> -		WARN(1, "GICv3 Not Implemented\n");
> +		vgic_v3_set_underflow(vcpu);
>  }
>  
>  static int compute_ap_list_depth(struct kvm_vcpu *vcpu)
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 95ef3cf..53730ba 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -26,4 +26,34 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>  void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
>  
> +#ifdef CONFIG_KVM_ARM_VGIC_V3
> +void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid, u64 mpidr);
> +void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
> +void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
> +void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
> +void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
> +#else
> +static inline void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid,
> +					       u64 mpidr)
> +{
> +}
> +
> +static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline void vgic_v3_populate_lr(struct kvm_vcpu *vcpu,
> +				       struct vgic_irq *irq, int lr)
> +{
> +}
> +
> +static inline void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
> +{
> +}
> +#endif
> +
>  #endif
> -- 
> 2.7.3
> 
