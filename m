From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v2 06/10] KVM: arm/arm64: Update the physical timer
 interrupt level
Date: Sun, 29 Jan 2017 15:21:06 +0000
Message-ID: <86sho199jx.fsf@arm.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-7-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E70E540625
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 10:21:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cQ2B9VOGxkyj for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Jan 2017 10:21:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE56F40194
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 10:21:49 -0500 (EST)
In-Reply-To: <1485479100-4966-7-git-send-email-jintack@cs.columbia.edu>
 (Jintack Lim's message of "Thu, 26 Jan 2017 20:04:56 -0500")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 27 2017 at 01:04:56 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
> Now that we maintain the EL1 physical timer register states of VMs,
> update the physical timer interrupt level along with the virtual one.
>
> Note that the emulated EL1 physical timer is not mapped to any hardware
> timer, so we call a proper vgic function.
>
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  virt/kvm/arm/arch_timer.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 0f6e935..3b6bd50 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -180,6 +180,21 @@ static void kvm_timer_update_mapped_irq(struct kvm_vcpu *vcpu, bool new_level,
>  	WARN_ON(ret);
>  }
>  
> +static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
> +				 struct arch_timer_context *timer)
> +{
> +	int ret;
> +
> +	BUG_ON(!vgic_initialized(vcpu->kvm));

Although I've added my fair share of BUG_ON() in the code base, I've
since reconsidered my position. If we get in a situation where the vgic
is not initialized, maybe it would be better to just WARN_ON and return
early rather than killing the whole box. Thoughts?

> +
> +	timer->irq.level = new_level;
> +	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
> +				   timer->irq.level);
> +	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, timer->irq.irq,
> +				  timer->irq.level);
> +	WARN_ON(ret);
> +}
> +
>  /*
>   * Check if there was a change in the timer state (should we raise or lower
>   * the line level to the GIC).
> @@ -188,6 +203,7 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> +	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  
>  	/*
>  	 * If userspace modified the timer registers via SET_ONE_REG before
> @@ -201,6 +217,10 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  	if (kvm_timer_should_fire(vcpu, vtimer) != vtimer->irq.level)
>  		kvm_timer_update_mapped_irq(vcpu, !vtimer->irq.level, vtimer);
>  
> +	/* The emulated EL1 physical timer irq is not mapped to hardware */

Maybe a slightly better comment would be saying that we're using a
purely virtual interrupt, unrelated to the hardware interrupt.

> +	if (kvm_timer_should_fire(vcpu, ptimer) != ptimer->irq.level)
> +		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
> +
>  	return 0;
>  }

Otherwise looks good.

          M.
-- 
Jazz is not dead. It just smells funny.
