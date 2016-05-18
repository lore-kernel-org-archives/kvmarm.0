From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 16/56] KVM: arm/arm64: vgic-new: Implement virtual IRQ
 injection
Date: Wed, 18 May 2016 16:14:27 +0200
Message-ID: <20160518141427.GA6666@cbox>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-17-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDDC2412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 10:10:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D2ftExXScoh2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2016 10:10:24 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8887740F90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 10:10:24 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id r12so36929567wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 07:13:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1463392481-26583-17-git-send-email-andre.przywara@arm.com>
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

On Mon, May 16, 2016 at 10:53:04AM +0100, Andre Przywara wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Provide a vgic_queue_irq_unlock() function which decides whether a
> given IRQ needs to be queued to a VCPU's ap_list.
> This should be called whenever an IRQ becomes pending or enabled,
> either as a result of userspace injection, from in-kernel emulated
> devices like the architected timer or from MMIO accesses to the
> distributor emulation.
> Also provides the necessary functions to allow userland to inject an
> IRQ to a guest.
> Since this is the first code that starts using our locking mechanism, we
> add some (hopefully) clear documentation of our locking strategy and
> requirements along with this patch.
> 
> [Andre: refactor out vgic_queue_irq_unlock()]
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog RFC..v1:
> - add spinlock checks protected by CONFIG_DEBUG_SPINLOCK
> - add more comments to vgic_target_oracle
> - remove BUG_ON() if IRQ is neither edge or level
> - rename vgic_queue_irq() to vgic_queue_irq_unlock()
> - simplify initial check in vgic_queue_irq_unlock()
> - extend retry loop to ask the oracle again
> - minor comment fixes
> 
> Changelog v1 .. v2:
> - move most IRQ injection code into vgic_update_irq_pending()
> 
> Changelog v3 .. v4:
> - simplify vgic_queue_irq_unlock() to allow reusage later
> 
>  include/kvm/vgic/vgic.h  |   3 +
>  virt/kvm/arm/vgic/vgic.c | 211 +++++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h |   1 +
>  3 files changed, 215 insertions(+)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 6ca0781..7b6ca90 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -181,6 +181,9 @@ struct vgic_cpu {
>  	u64 live_lrs;
>  };
>  
> +int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> +			bool level);
> +
>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>  #define vgic_initialized(k)	(false)
>  #define vgic_ready(k)		((k)->arch.vgic.ready)
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index fb45537..62fede6 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -19,8 +19,31 @@
>  
>  #include "vgic.h"
>  
> +#define CREATE_TRACE_POINTS
> +#include "../trace.h"
> +
> +#ifdef CONFIG_DEBUG_SPINLOCK
> +#define DEBUG_SPINLOCK_BUG_ON(p) BUG_ON(p)
> +#else
> +#define DEBUG_SPINLOCK_BUG_ON(p)
> +#endif
> +
>  struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
>  
> +/*
> + * Locking order is always:
> + *   vgic_cpu->ap_list_lock
> + *     vgic_irq->irq_lock
> + *
> + * (that is, always take the ap_list_lock before the struct vgic_irq lock).
> + *
> + * When taking more than one ap_list_lock at the same time, always take the
> + * lowest numbered VCPU's ap_list_lock first, so:
> + *   vcpuX->vcpu_id < vcpuY->vcpu_id:
> + *     spin_lock(vcpuX->arch.vgic_cpu.ap_list_lock);
> + *     spin_lock(vcpuY->arch.vgic_cpu.ap_list_lock);
> + */
> +
>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  			      u32 intid)
>  {
> @@ -39,3 +62,191 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  	WARN(1, "Looking up struct vgic_irq for reserved INTID");
>  	return NULL;
>  }
> +
> +/**
> + * kvm_vgic_target_oracle - compute the target vcpu for an irq
> + *
> + * @irq:	The irq to route. Must be already locked.
> + *
> + * Based on the current state of the interrupt (enabled, pending,
> + * active, vcpu and target_vcpu), compute the next vcpu this should be
> + * given to. Return NULL if this shouldn't be injected at all.
> + *
> + * Requires the IRQ lock to be held.
> + */
> +static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
> +{
> +	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
> +
> +	/* If the interrupt is active, it must stay on the current vcpu */
> +	if (irq->active)
> +		return irq->vcpu;
> +
> +	/*
> +	 * If the IRQ is not active but enabled and pending, we should direct
> +	 * it to its configured target VCPU.
> +	 * If the distributor is disabled, pending interrupts shouldn't be
> +	 * forwarded.
> +	 */
> +	if (irq->enabled && irq->pending) {
> +		if (unlikely(irq->target_vcpu &&
> +			     !irq->target_vcpu->kvm->arch.vgic.enabled))
> +			return NULL;
> +
> +		return irq->target_vcpu;
> +	}
> +
> +	/* If neither active nor pending and enabled, then this IRQ should not
> +	 * be queued to any VCPU.
> +	 */
> +	return NULL;
> +}
> +
> +/*
> + * Only valid injection if changing level for level-triggered IRQs or for a
> + * rising edge.
> + */
> +static bool vgic_validate_injection(struct vgic_irq *irq, bool level)
> +{
> +	switch (irq->config) {
> +	case VGIC_CONFIG_LEVEL:
> +		return irq->line_level != level;
> +	case VGIC_CONFIG_EDGE:
> +		return level;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Check whether an IRQ needs to (and can) be queued to a VCPU's ap list.
> + * Do the queuing if necessary, taking the right locks in the right order.
> + * Returns true when the IRQ was queued, false otherwise.
> + *
> + * Needs to be entered with the IRQ lock already held, but will return
> + * with all locks dropped.
> + */
> +bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
> +{
> +	struct kvm_vcpu *vcpu;
> +
> +	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
> +
> +retry:
> +	vcpu = vgic_target_oracle(irq);
> +	if (irq->vcpu || !vcpu) {
> +		/*
> +		 * If this IRQ is already on a VCPU's ap_list, then it
> +		 * cannot be moved or modified and there is no more work for
> +		 * us to do.
> +		 *
> +		 * Otherwise, if the irq is not pending and enabled, it does
> +		 * not need to be inserted into an ap_list and there is also
> +		 * no more work for us to do.
> +		 */
> +		spin_unlock(&irq->irq_lock);
> +		return false;
> +	}
> +
> +	/*
> +	 * We must unlock the irq lock to take the ap_list_lock where
> +	 * we are going to insert this new pending interrupt.
> +	 */
> +	spin_unlock(&irq->irq_lock);
> +
> +	/* someone can do stuff here, which we re-check below */
> +
> +	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
> +	spin_lock(&irq->irq_lock);
> +
> +	/*
> +	 * Did something change behind our backs?
> +	 *
> +	 * There are two cases:
> +	 * 1) The irq lost its pending state or was disabled behind our
> +	 *    backs and/or it was queued to another VCPU's ap_list.
> +	 *    Then drop the locks and return.
> +	 * 2) Someone changed the affinity on this irq behind our
> +	 *    backs and we are now holding the wrong ap_list_lock.
> +	 *    Then drop the locks and try the new VCPU.

nit: get rid of the 'Then drop the locks and return' from clause (1) and
write, 'In both cases, drop the locks and retry' as a separate paragraph
in the end.

> +	 */
> +
> +	if (unlikely(irq->vcpu || vcpu != vgic_target_oracle(irq))) {
> +		spin_unlock(&irq->irq_lock);
> +		spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
> +
> +		spin_lock(&irq->irq_lock);
> +		goto retry;
> +	}
> +
> +	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
> +	irq->vcpu = vcpu;
> +
> +	spin_unlock(&irq->irq_lock);
> +	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
> +
> +	kvm_vcpu_kick(vcpu);
> +
> +	return true;
> +}
> +
> +static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
> +				   unsigned int intid, bool level,
> +				   bool mapped_irq)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct vgic_irq *irq;
> +	int ret;
> +
> +	trace_vgic_update_irq_pending(cpuid, intid, level);
> +
> +	vcpu = kvm_get_vcpu(kvm, cpuid);
> +	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
> +		return -EINVAL;
> +
> +	irq = vgic_get_irq(kvm, vcpu, intid);
> +	if (!irq)
> +		return -EINVAL;
> +
> +	if (irq->hw != mapped_irq)
> +		return -EINVAL;
> +
> +	spin_lock(&irq->irq_lock);
> +
> +	if (!vgic_validate_injection(irq, level)) {
> +		/* Nothing to see here, move along... */
> +		spin_unlock(&irq->irq_lock);
> +		return 0;
> +	}
> +
> +	if (irq->config == VGIC_CONFIG_LEVEL) {
> +		irq->line_level = level;
> +		irq->pending = level || irq->soft_pending;
> +	} else {
> +		irq->pending = true;
> +	}
> +
> +	vgic_queue_irq_unlock(kvm, irq);
> +
> +	return 0;
> +}
> +
> +/**
> + * kvm_vgic_inject_irq - Inject an IRQ from a device to the vgic
> + * @kvm:     The VM structure pointer
> + * @cpuid:   The CPU for PPIs
> + * @intid:   The INTID to inject a new state to.
> + * @level:   Edge-triggered:  true:  to trigger the interrupt
> + *			      false: to ignore the call
> + *	     Level-sensitive  true:  raise the input signal
> + *			      false: lower the input signal
> + *
> + * The VGIC is not concerned with devices being active-LOW or active-HIGH for
> + * level-sensitive interrupts.  You can think of the level parameter as 1
> + * being HIGH and 0 being LOW and all devices being active-HIGH.
> + */
> +int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> +			bool level)
> +{
> +	return vgic_update_irq_pending(kvm, cpuid, intid, level, false);
> +}
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 61b8d22..c625767 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -18,5 +18,6 @@
>  
>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  			      u32 intid);
> +bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
>  
>  #endif
> -- 
> 2.8.2
> 

Besides the comment nit:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
