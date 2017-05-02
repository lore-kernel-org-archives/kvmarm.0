From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 3/5] KVM: arm/arm64: vgic-v2: Do not use Active+Pending
 state for a HW interrupt
Date: Tue, 2 May 2017 22:56:35 +0200
Message-ID: <20170502205635.GA4421@cbox>
References: <20170502133041.10980-1-marc.zyngier@arm.com>
 <20170502133041.10980-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170502133041.10980-4-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 02, 2017 at 02:30:39PM +0100, Marc Zyngier wrote:
> When an interrupt is injected with the HW bit set (indicating that
> deactivation should be propagated to the physical distributor),
> special care must be taken so that we never mark the corresponding
> LR with the Active+Pending state (as the pending state is kept in
> the physycal distributor).
> 
> Cc: stable@vger.kernel.org
> Fixes: 140b086dd197 ("KVM: arm/arm64: vgic-new: Add GICv2 world switch backend")
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
>  virt/kvm/arm/vgic/vgic-v2.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index a65757aab6d3..504b4bd0d651 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -149,6 +149,13 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>  	if (irq->hw) {
>  		val |= GICH_LR_HW;
>  		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
> +		/*
> +		 * Never set pending+active on a HW interrupt, as the
> +		 * pending state is kept at the physical distributor
> +		 * level.
> +		 */
> +		if (irq->active && irq_is_pending(irq))
> +			val &= ~GICH_LR_PENDING_BIT;
>  	} else {
>  		if (irq->config == VGIC_CONFIG_LEVEL)
>  			val |= GICH_LR_EOI;
> -- 
> 2.11.0
> 
