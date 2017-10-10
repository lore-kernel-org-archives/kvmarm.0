From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 18/20] KVM: arm/arm64: Avoid phys timer emulation in vcpu entry/exit
Date: Tue, 10 Oct 2017 10:45:15 +0100
Message-ID: <8760bnwd3o.fsf@on-the-bus.cambridge.arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
        <20170923004207.22356-19-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170923004207.22356-19-cdall@linaro.org> (Christoffer Dall's
        message of "Sat, 23 Sep 2017 02:42:05 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Sep 23 2017 at  2:42:05 am BST, Christoffer Dall <cdall@linaro.org> wrote:
> There is no need to schedule and cancel a hrtimer when entering and
> exiting the guest, because we know when the physical timer is going to
> fire when the guest programs it, and we can simply program the hrtimer
> at that point.
>
> Now when the register modifications from the guest go through the
> kvm_arm_timer_set/get_reg functions, which always call
> kvm_timer_update_state(), we can simply consider the timer state in this
> function and schedule and cancel the timers as needed.
>
> This avoids looking at the physical timer emulation state when entering
> and exiting the VCPU, allowing for faster servicing of the VM when
> needed.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/arch_timer.c | 75 ++++++++++++++++++++++++++++++++---------------
>  1 file changed, 51 insertions(+), 24 deletions(-)
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 1f82c21..aa18a5d 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -199,7 +199,27 @@ static enum hrtimer_restart kvm_bg_timer_expire(struct hrtimer *hrt)
>  
>  static enum hrtimer_restart kvm_phys_timer_expire(struct hrtimer *hrt)
>  {
> -	WARN(1, "Timer only used to ensure guest exit - unexpected event.");
> +	struct arch_timer_context *ptimer;
> +	struct arch_timer_cpu *timer;
> +	struct kvm_vcpu *vcpu;
> +	u64 ns;
> +
> +	timer = container_of(hrt, struct arch_timer_cpu, phys_timer);
> +	vcpu = container_of(timer, struct kvm_vcpu, arch.timer_cpu);
> +	ptimer = vcpu_ptimer(vcpu);
> +
> +	/*
> +	 * Check that the timer has really expired from the guest's
> +	 * PoV (NTP on the host may have forced it to expire
> +	 * early). If not ready, schedule for a later time.
> +	 */
> +	ns = kvm_timer_compute_delta(ptimer);
> +	if (unlikely(ns)) {
> +		hrtimer_forward_now(hrt, ns_to_ktime(ns));
> +		return HRTIMER_RESTART;
> +	}

Don't we already have a similar logic for the background timer (I must
admit I've lost track of how we changed things in this series)? If so,
can we make this common code?

> +
> +	kvm_timer_update_irq(vcpu, true, ptimer);
>  	return HRTIMER_NORESTART;
>  }
>  
> @@ -253,24 +273,28 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>  }
>  
>  /* Schedule the background timer for the emulated timer. */
> -static void phys_timer_emulate(struct kvm_vcpu *vcpu,
> -			      struct arch_timer_context *timer_ctx)
> +static void phys_timer_emulate(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  
> -	if (kvm_timer_should_fire(timer_ctx))
> -		return;
> -
> -	if (!kvm_timer_irq_can_fire(timer_ctx))
> +	/*
> +	 * If the timer can fire now we have just raised the IRQ line and we
> +	 * don't need to have a soft timer scheduled for the future.  If the
> +	 * timer cannot fire at all, then we also don't need a soft timer.
> +	 */
> +	if (kvm_timer_should_fire(ptimer) || !kvm_timer_irq_can_fire(ptimer)) {
> +		soft_timer_cancel(&timer->phys_timer, NULL);
>  		return;
> +	}
>  
> -	/*  The timer has not yet expired, schedule a background timer */
> -	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(timer_ctx));
> +	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(ptimer));
>  }
>  
>  /*
> - * Check if there was a change in the timer state (should we raise or lower
> - * the line level to the GIC).
> + * Check if there was a change in the timer state, so that we should either
> + * raise or lower the line level to the GIC or schedule a background timer to
> + * emulate the physical timer.
>   */
>  static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  {
> @@ -292,6 +316,8 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  
>  	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
>  		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
> +
> +	phys_timer_emulate(vcpu);
>  }
>  
>  static void vtimer_save_state(struct kvm_vcpu *vcpu)
> @@ -445,6 +471,9 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>  
>  	if (has_vhe())
>  		disable_el1_phys_timer_access();
> +
> +	/* Set the background timer for the physical timer emulation. */
> +	phys_timer_emulate(vcpu);
>  }
>  
>  bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
> @@ -480,12 +509,6 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>  
>  	if (unlikely(!timer->enabled))
>  		return;
> -
> -	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
> -		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
> -
> -	/* Set the background timer for the physical timer emulation. */
> -	phys_timer_emulate(vcpu, vcpu_ptimer(vcpu));
>  }
>  
>  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
> @@ -500,6 +523,17 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>  
>  	vtimer_save_state(vcpu);
>  
> +	/*
> +	 * Cancel the physical timer emulation, because the only case where we
> +	 * need it after a vcpu_put is in the context of a sleeping VCPU, and
> +	 * in that case we already factor in the deadline for the physical
> +	 * timer when scheduling the bg_timer.
> +	 *
> +	 * In any case, we re-schedule the hrtimer for the physical timer when
> +	 * coming back to the VCPU thread in kvm_timer_vcpu_load().
> +	 */
> +	soft_timer_cancel(&timer->phys_timer, NULL);
> +
>  	set_cntvoff(0);
>  }
>  
> @@ -536,16 +570,9 @@ static void unmask_vtimer_irq(struct kvm_vcpu *vcpu)
>   */
>  void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
> -	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  
>  	/*
> -	 * This is to cancel the background timer for the physical timer
> -	 * emulation if it is set.
> -	 */
> -	soft_timer_cancel(&timer->phys_timer, NULL);
> -
> -	/*
>  	 * If we entered the guest with the vtimer output asserted we have to
>  	 * check if the guest has modified the timer so that we should lower
>  	 * the line at this point.

Otherwise:

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead, it just smell funny.
