From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC 7/8] KVM: arm/arm64: Set up a background timer for the
 physical timer emulation
Date: Mon, 9 Jan 2017 13:13:26 +0100
Message-ID: <20170109121326.GE4348@cbox>
References: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
 <1482772326-29110-8-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3991403F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 07:11:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g+oSaMtspUaC for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 07:11:47 -0500 (EST)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4ADAF400FC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 07:11:47 -0500 (EST)
Received: by mail-lf0-f42.google.com with SMTP id m78so71888866lfg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Jan 2017 04:13:29 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1482772326-29110-8-git-send-email-jintack@cs.columbia.edu>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 26, 2016 at 12:12:05PM -0500, Jintack Lim wrote:
> Set a background timer for the EL1 physical timer emulation while VMs are
> running, so that VMs get interrupts for the physical timer in a timely
> manner.
> 
> We still use just one background timer. When a VM is runnable, we use
> the background timer for the physical timer emulation.  When the VM is
> about to be blocked, we use the background timer to wake up the vcpu at
> the earliest timer expiration among timers the VM is using.
> 
> As a result, the assumption that the background timer is not armed while
> VMs are running does not hold any more. So, remove BUG_ON()s and
> WARN_ON()s accordingly.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  virt/kvm/arm/arch_timer.c | 42 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 31 insertions(+), 11 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index aa7e243..be8d953 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -91,9 +91,6 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
>  	vcpu = container_of(work, struct kvm_vcpu, arch.timer_cpu.expired);
>  	vcpu->arch.timer_cpu.armed = false;
>  
> -	WARN_ON(!kvm_timer_should_fire(vcpu, vcpu_vtimer(vcpu)) &&
> -		!kvm_timer_should_fire(vcpu, vcpu_ptimer(vcpu)));
> -

This seems misplaced and has been addressed here:
https://lists.cs.columbia.edu/pipermail/kvmarm/2017-January/022933.html

When you respin you can benefit from basing on that (assuming it gets
acked and goes int).

>  	/*
>  	 * If the vcpu is blocked we want to wake it up so that it will see
>  	 * the timer has expired when entering the guest.
> @@ -139,7 +136,6 @@ static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
>  
>  /*
>   * Returns minimal timer expiration time in ns among guest timers.
> - * Note that it will return inf time if none of timers can fire.
>   */
>  static u64 kvm_timer_min_block(struct kvm_vcpu *vcpu)
>  {
> @@ -153,7 +149,9 @@ static u64 kvm_timer_min_block(struct kvm_vcpu *vcpu)
>  	if (kvm_timer_irq_can_fire(ptimer))
>  		min_phys = kvm_timer_compute_delta(vcpu, ptimer);
>  
> -	WARN_ON((min_virt == ULLONG_MAX) && (min_phys == ULLONG_MAX));
> +	/* If none of timers can fire, then return 0 */
> +	if ((min_virt == ULLONG_MAX) && (min_phys == ULLONG_MAX))
> +		return 0;

Why didn't you have this semantics in the previous patch?

>  
>  	return min(min_virt, min_phys);
>  }
> @@ -257,6 +255,26 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  }
>  
>  /*
> + * Schedule the background timer for the emulated timer. The background timer
> + * runs whenever vcpu is runnable and the timer is not expired.
> + */
> +static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
> +		       struct arch_timer_context *timer_ctx)
> +{
> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +
> +	if (kvm_timer_should_fire(vcpu, timer_ctx))
> +		return;
> +
> +	if (!kvm_timer_irq_can_fire(timer_ctx))
> +		return;
> +
> +	/*  The timer has not yet expired, schedule a background timer */
> +	timer_disarm(timer);
> +	timer_arm(timer, kvm_timer_compute_delta(vcpu, timer_ctx));

I'm wondering what the effect of this thing really is.  Isn't the soft
timer programmed in timer_arm() based on Linux's own timekeeping
schedule, such that the physical timer will be programmed to the next
tick, regardless of what you program here, so all you have to do is
check if you need to inject the phys timer on entry to the VM?

On the other hand, if this can cause Linux to program the phys timer to
expire sooner, then I guess it makes sense.  Thinking about it, would
that be the case on a tickless system?

> +}
> +
> +/*
>   * Schedule the background timer before calling kvm_vcpu_block, so that this
>   * thread is removed from its waitqueue and made runnable when there's a timer
>   * interrupt to handle.
> @@ -267,8 +285,6 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  
> -	BUG_ON(timer_is_armed(timer));
> -
>  	/*
>  	 * No need to schedule a background timer if any guest timer has
>  	 * already expired, because kvm_vcpu_block will return before putting
> @@ -290,13 +306,21 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>  	 * The guest timers have not yet expired, schedule a background timer.
>  	 * Pick smaller expiration time between phys and virt timer.
>  	 */
> +	timer_disarm(timer);
>  	timer_arm(timer, kvm_timer_min_block(vcpu));
>  }
>  
>  void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +
>  	timer_disarm(timer);
> +
> +	/*
> +	 * Now we return from the blocking. If we have any timer to emulate,
> +	 * and it's not expired, set the background timer for it.
> +	 */
> +	kvm_timer_emulate(vcpu, vcpu_ptimer(vcpu));

hmm, this is only called when returning from the kvm_vcpu_block() path.
What about when you do vcpu_load/put, don't you need to schedule/cancel
it there too?

Maybe it's simpler to just program the soft timer during flush_hwstate
and cancel the timer during sync_hwstate.  Does that work?

>  }
>  
>  /**
> @@ -375,10 +399,6 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>   */
>  void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
> -	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> -
> -	BUG_ON(timer_is_armed(timer));
> -
>  	/*
>  	 * The guest could have modified the timer registers or the timer
>  	 * could have expired, update the timer state.
> -- 
> 1.9.1
> 
> 

Thanks,
-Christoffer
