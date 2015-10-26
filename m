From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 2/3] KVM: arm/arm64: Merge vgic_set_lr() and
 vgic_sync_lr_elrsr()
Date: Mon, 26 Oct 2015 16:22:38 +0100
Message-ID: <20151026152238.GD20298@cbox>
References: <cover.1445849885.git.p.fedin@samsung.com>
 <31bc5d39898f4a51f8d75d338229856ff49c097e.1445849885.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <31bc5d39898f4a51f8d75d338229856ff49c097e.1445849885.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 26, 2015 at 12:00:29PM +0300, Pavel Fedin wrote:
> Now we see that vgic_set_lr() and vgic_sync_lr_elrsr() are always used
> together. Merge them into one function, saving from second vgic_ops
> dereferencing every time.
> 
> Additionally, remove unnecessary vgic_set_lr() and LR_STATE_PENDING check
> in vgic_unqueue_irqs(), because all these things are now done by the
> following vgic_retire_lr().
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  include/kvm/arm_vgic.h |  1 -
>  virt/kvm/arm/vgic-v2.c |  5 -----
>  virt/kvm/arm/vgic-v3.c |  5 -----
>  virt/kvm/arm/vgic.c    | 33 ++++-----------------------------
>  4 files changed, 4 insertions(+), 40 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 3936bf8..f62addc 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -112,7 +112,6 @@ struct vgic_vmcr {
>  struct vgic_ops {
>  	struct vgic_lr	(*get_lr)(const struct kvm_vcpu *, int);
>  	void	(*set_lr)(struct kvm_vcpu *, int, struct vgic_lr);
> -	void	(*sync_lr_elrsr)(struct kvm_vcpu *, int, struct vgic_lr);
>  	u64	(*get_elrsr)(const struct kvm_vcpu *vcpu);
>  	u64	(*get_eisr)(const struct kvm_vcpu *vcpu);
>  	void	(*clear_eisr)(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
> index c0f5d7f..ff02f08 100644
> --- a/virt/kvm/arm/vgic-v2.c
> +++ b/virt/kvm/arm/vgic-v2.c
> @@ -79,11 +79,7 @@ static void vgic_v2_set_lr(struct kvm_vcpu *vcpu, int lr,
>  		lr_val |= (lr_desc.source << GICH_LR_PHYSID_CPUID_SHIFT);
>  
>  	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = lr_val;
> -}
>  
> -static void vgic_v2_sync_lr_elrsr(struct kvm_vcpu *vcpu, int lr,
> -				  struct vgic_lr lr_desc)
> -{
>  	if (!(lr_desc.state & LR_STATE_MASK))
>  		vcpu->arch.vgic_cpu.vgic_v2.vgic_elrsr |= (1ULL << lr);
>  	else
> @@ -167,7 +163,6 @@ static void vgic_v2_enable(struct kvm_vcpu *vcpu)
>  static const struct vgic_ops vgic_v2_ops = {
>  	.get_lr			= vgic_v2_get_lr,
>  	.set_lr			= vgic_v2_set_lr,
> -	.sync_lr_elrsr		= vgic_v2_sync_lr_elrsr,
>  	.get_elrsr		= vgic_v2_get_elrsr,
>  	.get_eisr		= vgic_v2_get_eisr,
>  	.clear_eisr		= vgic_v2_clear_eisr,
> diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
> index 92003cb..487d635 100644
> --- a/virt/kvm/arm/vgic-v3.c
> +++ b/virt/kvm/arm/vgic-v3.c
> @@ -112,11 +112,7 @@ static void vgic_v3_set_lr(struct kvm_vcpu *vcpu, int lr,
>  	}
>  
>  	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[LR_INDEX(lr)] = lr_val;
> -}
>  
> -static void vgic_v3_sync_lr_elrsr(struct kvm_vcpu *vcpu, int lr,
> -				  struct vgic_lr lr_desc)
> -{
>  	if (!(lr_desc.state & LR_STATE_MASK))
>  		vcpu->arch.vgic_cpu.vgic_v3.vgic_elrsr |= (1U << lr);
>  	else
> @@ -212,7 +208,6 @@ static void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  static const struct vgic_ops vgic_v3_ops = {
>  	.get_lr			= vgic_v3_get_lr,
>  	.set_lr			= vgic_v3_set_lr,
> -	.sync_lr_elrsr		= vgic_v3_sync_lr_elrsr,
>  	.get_elrsr		= vgic_v3_get_elrsr,
>  	.get_eisr		= vgic_v3_get_eisr,
>  	.clear_eisr		= vgic_v3_clear_eisr,
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 265a410..43f2564 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -717,28 +717,13 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
>  		 * interrupt then move the active state to the
>  		 * distributor tracking bit.
>  		 */
> -		if (lr.state & LR_STATE_ACTIVE) {
> +		if (lr.state & LR_STATE_ACTIVE)
>  			vgic_irq_set_active(vcpu, lr.irq);
> -			lr.state &= ~LR_STATE_ACTIVE;
> -		}
>  
>  		/*
>  		 * Reestablish the pending state on the distributor and the
> -		 * CPU interface.  It may have already been pending, but that
> -		 * is fine, then we are only setting a few bits that were
> -		 * already set.
> -		 */
> -		if (lr.state & LR_STATE_PENDING) {
> -			vgic_dist_irq_set_pending(vcpu, lr.irq);

this looks wrong: You should still be setting the pending state on the
distributor, perhaps this is an ordering issue with the last patch?

-Christoffer

