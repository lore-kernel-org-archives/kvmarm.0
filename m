From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 08/10] KVM: arm/arm64: vgic: Handle unshared mapped
 interrupts
Date: Fri, 2 Jun 2017 15:33:01 +0200
Message-ID: <20170602133301.GD397@cbox>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
 <1495656803-28011-9-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A151E40C07
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 09:29:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mXcCFi-DRQwu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jun 2017 09:29:19 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0A1C40BE3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 09:29:18 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id n195so27144883wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Jun 2017 06:33:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1495656803-28011-9-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 24, 2017 at 10:13:21PM +0200, Eric Auger wrote:
> Virtual interrupts directly mapped to physical interrupts require
> some special care. Their pending and active state must be observed
> at distributor level and not in the list register.

This is not entirely true.  There's a dependency, but there is also
separate virtual vs. physical state, see below.

> 
> Also a level sensitive interrupt's level is not toggled down by any
> maintenance IRQ handler as the EOI is not trapped.
> 
> This patch adds an host_irq field in vgic_irq struct to easily
> get the irqchip state of the host irq. We also handle the
> physical IRQ case in vgic_validate_injection and add helpers to
> get the line level and active state.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  include/kvm/arm_vgic.h    |  4 +++-
>  virt/kvm/arm/arch_timer.c |  3 ++-
>  virt/kvm/arm/vgic/vgic.c  | 44 ++++++++++++++++++++++++++++++++++++++------
>  virt/kvm/arm/vgic/vgic.h  |  9 ++++++++-
>  4 files changed, 51 insertions(+), 9 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index ef71858..695ebc7 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -112,6 +112,7 @@ struct vgic_irq {
>  	bool hw;			/* Tied to HW IRQ */
>  	struct kref refcount;		/* Used for LPIs */
>  	u32 hwintid;			/* HW INTID number */
> +	unsigned int host_irq;		/* linux irq corresponding to hwintid */
>  	union {
>  		u8 targets;			/* GICv2 target VCPUs mask */
>  		u32 mpidr;			/* GICv3 target VCPU */
> @@ -301,7 +302,8 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			bool level);
>  int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			       bool level);
> -int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq);
> +int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> +			  u32 virt_irq, u32 phys_irq);
>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>  
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 5976609..45f4779 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -651,7 +651,8 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  	 * Tell the VGIC that the virtual interrupt is tied to a
>  	 * physical interrupt. We do that once per VCPU.
>  	 */
> -	ret = kvm_vgic_map_phys_irq(vcpu, vtimer->irq.irq, phys_irq);
> +	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq,
> +				    vtimer->irq.irq, phys_irq);
>  	if (ret)
>  		return ret;
>  
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 83b24d2..aa0618c 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -137,6 +137,28 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  	kfree(irq);
>  }
>  
> +bool irq_line_level(struct vgic_irq *irq)
> +{
> +	bool line_level = irq->line_level;
> +
> +	if (unlikely(is_unshared_mapped(irq)))
> +		WARN_ON(irq_get_irqchip_state(irq->host_irq,
> +					      IRQCHIP_STATE_PENDING,
> +					      &line_level));
> +	return line_level;
> +}

This really looks fishy.  When do we need this exactly?

I feel like we should treat this more like everything else and set the
line_level on the irq even for forwarded interrupts, and then you don't
need changes to validate injection.

The challenge, then, is how to re-sample the line and lower the
line_level field when necessary.  Can't we simply do this in
vgic_fold_lr_state(), and if you have a forwarded interrupt which is
level triggered and the level is high, then notify the one who injected
this and tell it to adjust its line level (lower it if it changed).

That would follow our existing path very closely.

Am I missing something?

> +
> +bool irq_is_active(struct vgic_irq *irq)
> +{
> +	bool is_active = irq->active;
> +
> +	if (unlikely(is_unshared_mapped(irq)))
> +		WARN_ON(irq_get_irqchip_state(irq->host_irq,
> +					      IRQCHIP_STATE_ACTIVE,
> +					      &is_active));
> +	return is_active;
> +}

Why do we need this?

The active state of a virtual IRQ is independent from the underlying
physical state, as I see it.

For example, when the interrupt is initially injected to the VGIC, it
will be ACTIVE on the physical distributor, but PENDING on the VGIC.


Thanks,
-Christoffer

> +
>  /**
>   * kvm_vgic_target_oracle - compute the target vcpu for an irq
>   *
> @@ -153,7 +175,7 @@ static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
>  	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
>  
>  	/* If the interrupt is active, it must stay on the current vcpu */
> -	if (irq->active)
> +	if (irq_is_active(irq))
>  		return irq->vcpu ? : irq->target_vcpu;
>  
>  	/*
> @@ -195,14 +217,18 @@ static int vgic_irq_cmp(void *priv, struct list_head *a, struct list_head *b)
>  {
>  	struct vgic_irq *irqa = container_of(a, struct vgic_irq, ap_list);
>  	struct vgic_irq *irqb = container_of(b, struct vgic_irq, ap_list);
> +	bool activea, activeb;
>  	bool penda, pendb;
>  	int ret;
>  
>  	spin_lock(&irqa->irq_lock);
>  	spin_lock_nested(&irqb->irq_lock, SINGLE_DEPTH_NESTING);
>  
> -	if (irqa->active || irqb->active) {
> -		ret = (int)irqb->active - (int)irqa->active;
> +	activea = irq_is_active(irqa);
> +	activeb = irq_is_active(irqb);
> +
> +	if (activea || activeb) {
> +		ret = (int)activeb - (int)activea;
>  		goto out;
>  	}
>  
> @@ -234,13 +260,17 @@ static void vgic_sort_ap_list(struct kvm_vcpu *vcpu)
>  
>  /*
>   * Only valid injection if changing level for level-triggered IRQs or for a
> - * rising edge.
> + * rising edge. Injection of virtual interrupts associated to physical
> + * interrupts always is valid.
>   */
>  static bool vgic_validate_injection(struct vgic_irq *irq, bool level)
>  {
>  	switch (irq->config) {
>  	case VGIC_CONFIG_LEVEL:
> -		return irq->line_level != level;
> +		if (unlikely(is_unshared_mapped(irq)))
> +			return true;
> +		else
> +			return irq->line_level != level;
>  	case VGIC_CONFIG_EDGE:
>  		return level;
>  	}
> @@ -392,7 +422,8 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  	return 0;
>  }
>  
> -int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
> +int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> +			  u32 virt_irq, u32 phys_irq)
>  {
>  	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
>  
> @@ -402,6 +433,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
>  
>  	irq->hw = true;
>  	irq->hwintid = phys_irq;
> +	irq->host_irq = host_irq;
>  
>  	spin_unlock(&irq->irq_lock);
>  	vgic_put_irq(vcpu->kvm, irq);
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index da83e4c..dc4972b 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -17,6 +17,7 @@
>  #define __KVM_ARM_VGIC_NEW_H__
>  
>  #include <linux/irqchip/arm-gic-common.h>
> +#include <linux/interrupt.h>
>  
>  #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
>  #define IMPLEMENTER_ARM		0x43b
> @@ -96,14 +97,20 @@
>  /* we only support 64 kB translation table page size */
>  #define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
>  
> +bool irq_line_level(struct vgic_irq *irq);
> +bool irq_is_active(struct vgic_irq *irq);
> +
>  static inline bool irq_is_pending(struct vgic_irq *irq)
>  {
>  	if (irq->config == VGIC_CONFIG_EDGE)
>  		return irq->pending_latch;
>  	else
> -		return irq->pending_latch || irq->line_level;
> +		return irq->pending_latch || irq_line_level(irq);
>  }
>  
> +#define is_unshared_mapped(i) \
> +((i)->hw && (i)->intid >= VGIC_NR_PRIVATE_IRQS && (i)->intid < 1020)
> +
>  /*
>   * This struct provides an intermediate representation of the fields contained
>   * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC
> -- 
> 2.5.5
> 
