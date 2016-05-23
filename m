From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 4/7] KVM: arm/arm64: vgic-v3: Always resample level
 interrupts
Date: Mon, 23 May 2016 16:19:56 +0200
Message-ID: <20160523141956.GB9625@lvm>
References: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
 <1464007023-11736-5-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464007023-11736-5-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 23, 2016 at 01:37:00PM +0100, Marc Zyngier wrote:
> When reading back from the list registers, we need to perform
> two actions for level interrupts:
> 1) clear the soft-pending bit if the interrupt is not pending
>    anymore *in the list register*
> 2) resample the line level and propagate it to the pending state
> 
> But these two actions linked, and we should *always* resample
> the line level, no matter what state is in the list register.
> Otherwise, we may end-up injecting spurious interrupts that
> have been already retired.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v3.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 336a461..63b8bae 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -101,10 +101,13 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>  			}
>  		}
>  
> -		/* Clear soft pending state when level irqs have been acked */
> -		if (irq->config == VGIC_CONFIG_LEVEL &&
> -		    !(val & ICH_LR_PENDING_BIT)) {
> -			irq->soft_pending = false;
> +		/*
> +		 * Clear soft pending state when level irqs have been acked.
> +		 * Always resample the line level.
> +		 */
> +		if (irq->config == VGIC_CONFIG_LEVEL) {
> +			if (!(val & ICH_LR_PENDING_BIT))
> +				irq->soft_pending = false;
>  			irq->pending = irq->line_level;

same question as previous patch
