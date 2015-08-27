From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: BUG FIX: Do not inject spurious
 interrupts
Date: Thu, 27 Aug 2015 14:44:42 +0200
Message-ID: <20150827124442.GD29439@cbox>
References: <1440676282-2152-1-git-send-email-p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1440676282-2152-1-git-send-email-p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Aug 27, 2015 at 02:51:22PM +0300, Pavel Fedin wrote:
> Commit 71760950bf3dc796e5e53ea3300dec724a09f593
> ("arm/arm64: KVM: add a common vgic_queue_irq_to_lr fn") introduced
> vgic_queue_irq_to_lr() function with additional vgic_dist_irq_is_pending()
> check before setting LR_STATE_PENDING bit. In some cases it started
> causing the following situation if the userland quickly drops the IRQ back
> to inactive state for some reason:
> 1. Userland injects an IRQ with level == 1, this ends up in
>    vgic_update_irq_pending(), which in turn calls vgic_dist_irq_set_pending()
>    for this IRQ.
> 2. vCPU gets kicked. But kernel does not manage to reschedule it quickly
>    (!!!)
> 3. Userland quickly resets the IRQ to level == 0. vgic_update_irq_pending()
>    in this case will call vgic_dist_irq_clear_pending() and reset the
>    pending flag.
> 4. vCPU finally wakes up. It succesfully rolls through through
>    __kvm_vgic_flush_hwstate(), which populates vGIC registers. However,
>    since neither pending nor active flags are now set for this IRQ,
>    vgic_queue_irq_to_lr() does not set any state bits on this LR at all.
>    Since this is level-sensitive IRQ, we end up in LR containing only
>    LR_EOI_INT bit, causing unnecessary immediate exit from the guest.
> 
> This patch fixes the problem by adding forgotten vgic_cpu_irq_clear().
> This causes the IRQ not to be included into any lists, if it has been
> picked up after getting dropped to inactive level. Since this is a
> level-sensitive IRQ, this is correct behavior.
> 
> The bug was caught on ARM64 kernel v4.1.6, running qemu "virt" guest,
> where it was caused by emulated pl011.

It's a bit weird to just sned this as a new patch without replying to my
mail from yesterday with feedback, explaining changes from what I did
etc.  Anyway.

> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  virt/kvm/arm/vgic.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 34dad3c..bf155e3 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1111,7 +1111,8 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>  		kvm_debug("Set active, clear distributor: 0x%x\n", vlr.state);
>  		vgic_irq_clear_active(vcpu, irq);
>  		vgic_update_state(vcpu->kvm);
> -	} else if (vgic_dist_irq_is_pending(vcpu, irq)) {
> +	} else {
> +		WARN_ON(!vgic_dist_irq_is_pending(vcpu, irq));
>  		vlr.state |= LR_STATE_PENDING;
>  		kvm_debug("Set pending: 0x%x\n", vlr.state);
>  	}
> @@ -1567,8 +1568,10 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
>  	} else {
>  		if (level_triggered) {
>  			vgic_dist_irq_clear_level(vcpu, irq_num);
> -			if (!vgic_dist_irq_soft_pend(vcpu, irq_num))
> +			if (!vgic_dist_irq_soft_pend(vcpu, irq_num)) {
>  				vgic_dist_irq_clear_pending(vcpu, irq_num);
> +				vgic_cpu_irq_clear(vcpu, irq_num);

I think you're missing a potential change to the irq_pending_on_cpu
field here, which you have to compute by calling vgic_update_state()
like we do elsewhere when we change status bits (note that this is
different from the incorrect approach I suggested yesterday where we
always just clear the bit for that vcpu).

> +			}
>  		}
>  
>  		ret = false;
> -- 
> 2.4.4
> 

-Christoffer
