From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: vgic-new: Removel harmful BUG_ON
Date: Thu, 2 Jun 2016 11:52:01 +0200
Message-ID: <20160602095201.GA20310@cbox>
References: <1464855846-1625-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464855846-1625-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 02, 2016 at 09:24:06AM +0100, Marc Zyngier wrote:
> When changing the active bit from an MMIO trap, we decide to
> explode if the intid is that of a private interrupt.
> 
> This really looks like a leftover from a previous version, as
> the callers explicitly check for private interrupts and handle
> them correctly. I've managed to reproduce it using a custom
> guest.

Actually this was me mistakingly thinking that kvm_vcpu_kick() would be
synchronous and we therefore would have an assurance that we're back
from running the VCPU, but this is clearly not the case, so dropping the
BUG_ON is indeed the right thing to do.

> 
> Dropping the BUG_ON seems like the right thing to do.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Applied, thanks.

-Christoffer

> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 059595e..9f6fab7 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -191,10 +191,8 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  	 * other thread sync back the IRQ.
>  	 */
>  	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
> -	       irq->vcpu->cpu != -1) { /* VCPU thread is running */
> -		BUG_ON(irq->intid < VGIC_NR_PRIVATE_IRQS);
> +	       irq->vcpu->cpu != -1) /* VCPU thread is running */
>  		cond_resched_lock(&irq->irq_lock);
> -	}
>  
>  	irq->active = new_active_state;
>  	if (new_active_state)
> -- 
> 2.1.4
> 
