From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: arch_timer: Mark physical interrupt
 active when a virtual interrupt is pending
Date: Tue, 12 Feb 2019 17:41:38 +0100
Message-ID: <20190212164138.GB4530@e113682-lin.lund.arm.com>
References: <20190208144300.75299-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBAE949F94
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Feb 2019 11:41:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QxK0ahfhoXx4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Feb 2019 11:41:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 851F240A52
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Feb 2019 11:41:41 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190208144300.75299-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 08, 2019 at 02:43:00PM +0000, Marc Zyngier wrote:
> When a guest gets scheduled, KVM performs a "load" operation,
> which for the timer includes evaluating the virtual "active" state
> of the interrupt, and replicating it on the physical side. This
> ensures that the deactivation in the guest will also take place
> in the physical GIC distributor.
> 
> If the interrupt is not yet active, we flag it as inactive on the
> physical side.  This means that on restoring the timer registers,
> if the timer has expired, we'll immediately take an interrupt.
> That's absolutely fine, as the interrupt will then be flagged as
> active on the physical side. What this assumes though is that we'll
> enter the guest right after having taken the interrupt, and that
> the guest will quickly ACK the interrupt, making it active at on
> the virtual side.
> 
> It turns out that quite often, this assumption doesn't really hold.
> The guest may be preempted on the back on this interrupt, either
> from kernel space or whilst running at EL1 when a host interrupt
> fires. When this happens, we repeat the whole sequence on the
> next load (interrupt marked as inactive, timer registers restored,
> interrupt fires). And if it takes a really long time for a guest
> to activate the interrupt (as it does with nested virt), we end-up
> with many such events in quick succession, leading to the guest only
> making very slow progress.
> 
> This can also be seen with the number of virtual timer interrupt on the
> host being far greater than the same number in the guest.
> 
> An easy way to fix this is to evaluate the timer state when performing
> the "load" operation, just like we do when the interrupt actually fires.
> If the timer has a pending virtual interrupt at this stage, then we
> can safely flag the physical interrupt as being active, which prevents
> spurious exits.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/arch_timer.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 7449651ae2e5..70c18479ccd5 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -487,12 +487,21 @@ static inline void set_timer_irq_phys_active(struct arch_timer_context *ctx, boo
>  static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
>  {
>  	struct kvm_vcpu *vcpu = ctx->vcpu;
> -	bool phys_active;
> +	bool phys_active = false;
> +
> +	/*
> +	 * Update the timer output so that it is likely to match the
> +	 * state we're about to restore. If the timer expires between
> +	 * this point and the register restoration, we'll take the
> +	 * interrupt anyway.
> +	 */
> +	kvm_timer_update_irq(ctx->vcpu, kvm_timer_should_fire(ctx), ctx);
>  
>  	if (irqchip_in_kernel(vcpu->kvm))
>  		phys_active = kvm_vgic_map_is_active(vcpu, ctx->irq.irq);
> -	else
> -		phys_active = ctx->irq.level;
> +
> +	phys_active |= ctx->irq.level;
> +
>  	set_timer_irq_phys_active(ctx, phys_active);
>  }
>  
> -- 
> 2.20.1
> 
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
