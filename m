From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: vgic: Disallow Active+Pending for
 level interrupts
Date: Tue, 20 Mar 2018 15:25:10 +0100
Message-ID: <4be5cde8-ce15-a6e5-385d-b30288f51e5c@redhat.com>
References: <20180316143015.32055-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA77849EAD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Mar 2018 10:17:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eoDwz+DVErrk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Mar 2018 10:17:25 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BABE49D6B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Mar 2018 10:17:24 -0400 (EDT)
In-Reply-To: <20180316143015.32055-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <Andre.Przywara@arm.com>, Shunyong Yang <shunyong.yang@hxt-semitech.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 16/03/18 15:30, Marc Zyngier wrote:
> It was recently reported that VFIO mediated devices, and anything
> that VFIO exposes as level interrupts, do no strictly follow the
> expected logic of such interrupts as it only lowers the input
> line when the guest has EOId the interrupt at the GIC level, rather
> than when it Acked the interrupt at the device level.
> 
> THe GIC's Active+Pending state is fundamentally incompatible with
> this behaviour, as it prevents KVM from observing the EOI, and in
> turn results in VFIO never dropping the line. This results in an
> interrupt storm in the guest, which it really never expected.
> 
> As we cannot really change VFIO to follow the strict rules of level
> signalling, let's forbid the A+P state altogether, as it is in the
> end only an optimization. It ensures that we will transition via
> an invalid state, which we can use to notify VFIO of the EOI.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
with mdev tty device

Thanks

Eric
> ---
> - From v1:
>   * Only clear the latch when going via an invalid state
> 
>  virt/kvm/arm/vgic/vgic-v2.c | 54 +++++++++++++++++++++++++--------------------
>  virt/kvm/arm/vgic/vgic-v3.c | 54 +++++++++++++++++++++++++--------------------
>  2 files changed, 60 insertions(+), 48 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 29556f71b691..8427586760fc 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -105,12 +105,9 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>  
>  		/*
>  		 * Clear soft pending state when level irqs have been acked.
> -		 * Always regenerate the pending state.
>  		 */
> -		if (irq->config == VGIC_CONFIG_LEVEL) {
> -			if (!(val & GICH_LR_PENDING_BIT))
> -				irq->pending_latch = false;
> -		}
> +		if (irq->config == VGIC_CONFIG_LEVEL && !(val & GICH_LR_STATE))
> +			irq->pending_latch = false;
>  
>  		/*
>  		 * Level-triggered mapped IRQs are special because we only
> @@ -153,8 +150,35 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>  {
>  	u32 val = irq->intid;
> +	bool allow_pending = true;
> +
> +	if (irq->active)
> +		val |= GICH_LR_ACTIVE_BIT;
> +
> +	if (irq->hw) {
> +		val |= GICH_LR_HW;
> +		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
> +		/*
> +		 * Never set pending+active on a HW interrupt, as the
> +		 * pending state is kept at the physical distributor
> +		 * level.
> +		 */
> +		if (irq->active)
> +			allow_pending = false;
> +	} else {
> +		if (irq->config == VGIC_CONFIG_LEVEL) {
> +			val |= GICH_LR_EOI;
>  
> -	if (irq_is_pending(irq)) {
> +			/*
> +			 * Software resampling doesn't work very well
> +			 * if we allow P+A, so let's not do that.
> +			 */
> +			if (irq->active)
> +				allow_pending = false;
> +		}
> +	}
> +
> +	if (allow_pending && irq_is_pending(irq)) {
>  		val |= GICH_LR_PENDING_BIT;
>  
>  		if (irq->config == VGIC_CONFIG_EDGE)
> @@ -171,24 +195,6 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>  		}
>  	}
>  
> -	if (irq->active)
> -		val |= GICH_LR_ACTIVE_BIT;
> -
> -	if (irq->hw) {
> -		val |= GICH_LR_HW;
> -		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
> -		/*
> -		 * Never set pending+active on a HW interrupt, as the
> -		 * pending state is kept at the physical distributor
> -		 * level.
> -		 */
> -		if (irq->active && irq_is_pending(irq))
> -			val &= ~GICH_LR_PENDING_BIT;
> -	} else {
> -		if (irq->config == VGIC_CONFIG_LEVEL)
> -			val |= GICH_LR_EOI;
> -	}
> -
>  	/*
>  	 * Level-triggered mapped IRQs are special because we only observe
>  	 * rising edges as input to the VGIC.  We therefore lower the line
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 0ff2006f3781..dd984f726805 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -96,12 +96,9 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>  
>  		/*
>  		 * Clear soft pending state when level irqs have been acked.
> -		 * Always regenerate the pending state.
>  		 */
> -		if (irq->config == VGIC_CONFIG_LEVEL) {
> -			if (!(val & ICH_LR_PENDING_BIT))
> -				irq->pending_latch = false;
> -		}
> +		if (irq->config == VGIC_CONFIG_LEVEL && !(val & ICH_LR_STATE))
> +			irq->pending_latch = false;
>  
>  		/*
>  		 * Level-triggered mapped IRQs are special because we only
> @@ -135,8 +132,35 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>  {
>  	u32 model = vcpu->kvm->arch.vgic.vgic_model;
>  	u64 val = irq->intid;
> +	bool allow_pending = true;
> +
> +	if (irq->active)
> +		val |= ICH_LR_ACTIVE_BIT;
> +
> +	if (irq->hw) {
> +		val |= ICH_LR_HW;
> +		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
> +		/*
> +		 * Never set pending+active on a HW interrupt, as the
> +		 * pending state is kept at the physical distributor
> +		 * level.
> +		 */
> +		if (irq->active)
> +			allow_pending = false;
> +	} else {
> +		if (irq->config == VGIC_CONFIG_LEVEL) {
> +			val |= ICH_LR_EOI;
>  
> -	if (irq_is_pending(irq)) {
> +			/*
> +			 * Software resampling doesn't work very well
> +			 * if we allow P+A, so let's not do that.
> +			 */
> +			if (irq->active)
> +				allow_pending = false;
> +		}
> +	}
> +
> +	if (allow_pending && irq_is_pending(irq)) {
>  		val |= ICH_LR_PENDING_BIT;
>  
>  		if (irq->config == VGIC_CONFIG_EDGE)
> @@ -154,24 +178,6 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>  		}
>  	}
>  
> -	if (irq->active)
> -		val |= ICH_LR_ACTIVE_BIT;
> -
> -	if (irq->hw) {
> -		val |= ICH_LR_HW;
> -		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
> -		/*
> -		 * Never set pending+active on a HW interrupt, as the
> -		 * pending state is kept at the physical distributor
> -		 * level.
> -		 */
> -		if (irq->active && irq_is_pending(irq))
> -			val &= ~ICH_LR_PENDING_BIT;
> -	} else {
> -		if (irq->config == VGIC_CONFIG_LEVEL)
> -			val |= ICH_LR_EOI;
> -	}
> -
>  	/*
>  	 * Level-triggered mapped IRQs are special because we only observe
>  	 * rising edges as input to the VGIC.  We therefore lower the line
> 
