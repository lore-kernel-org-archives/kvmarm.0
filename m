From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/9] arm/arm64: KVM: arch_timer: Only schedule soft timer
 on vcpu_block
Date: Thu, 03 Sep 2015 15:43:19 +0100
Message-ID: <55E85C87.8060704@arm.com>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org> <1440942866-23802-3-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-3-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/08/15 14:54, Christoffer Dall wrote:
> We currently schedule a soft timer every time we exit the guest if the
> timer did not expire while running the guest.  This is really not
> necessary, because the only work we do in the timer work function is to
> kick the vcpu.
> 
> Kicking the vcpu does two things:
> (1) If the vpcu thread is on a waitqueue, make it runnable and remove it
> from the waitqueue.
> (2) If the vcpu is running on a different physical CPU from the one
> doing the kick, it sends a reschedule IPI.
> 
> The second case cannot happen, because the soft timer is only ever
> scheduled when the vcpu is not running.  The first case is only relevant
> when the vcpu thread is on a waitqueue, which is only the case when the
> vcpu thread has called kvm_vcpu_block().
> 
> Therefore, we only need to make sure a timer is scheduled for
> kvm_vcpu_block(), which we do by encapsulating all calls to
> kvm_vcpu_block() with kvm_timer_{un}schedule calls.
> 
> Additionally, we only schedule a soft timer if the timer is enabled and
> unmasked, since it is useless otherwise.
> 
> Note that theoretically userspace can use the SET_ONE_REG interface to
> change registers that should cause the timer to fire, even if the vcpu
> is blocked without a scheduled timer, but this case was not supported
> before this patch and we leave it for future work for now.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm/include/asm/kvm_host.h   |  3 --
>  arch/arm/kvm/arm.c                | 10 +++++
>  arch/arm64/include/asm/kvm_host.h |  3 --
>  include/kvm/arm_arch_timer.h      |  2 +
>  virt/kvm/arm/arch_timer.c         | 89 +++++++++++++++++++++++++--------------
>  5 files changed, 70 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 86fcf6e..dcba0fa 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -236,7 +236,4 @@ static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
>  
> -static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> -
>  #endif /* __ARM_KVM_HOST_H__ */
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index ce404a5..bdf8871 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -271,6 +271,16 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>  	return kvm_timer_should_fire(vcpu);
>  }
>  
> +void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> +{
> +	kvm_timer_schedule(vcpu);
> +}
> +
> +void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
> +{
> +	kvm_timer_unschedule(vcpu);
> +}
> +
>  int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  {
>  	/* Force users to call KVM_ARM_VCPU_INIT */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index dd143f5..415938d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -257,7 +257,4 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
>  
> -static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> -
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index e1e4d7c..ef14cc1 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -71,5 +71,7 @@ u64 kvm_arm_timer_get_reg(struct kvm_vcpu *, u64 regid);
>  int kvm_arm_timer_set_reg(struct kvm_vcpu *, u64 regid, u64 value);
>  
>  bool kvm_timer_should_fire(struct kvm_vcpu *vcpu);
> +void kvm_timer_schedule(struct kvm_vcpu *vcpu);
> +void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
>  
>  #endif
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 76e38d2..018f3d6 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -111,14 +111,21 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
>  	return HRTIMER_NORESTART;
>  }
>  
> +static bool kvm_timer_irq_enabled(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +
> +	return !(timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
> +		(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE) &&
> +		!kvm_vgic_get_phys_irq_active(timer->map);
> +}

Nit: To me, this is not a predicate for "IRQ enabled", but "IRQ can
fire" instead, which seems to complement the kvm_timer_should_fire just
below.

> +
>  bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	cycle_t cval, now;
>  
> -	if ((timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) ||
> -	    !(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE) ||
> -	    kvm_vgic_get_phys_irq_active(timer->map))
> +	if (!kvm_timer_irq_enabled(vcpu))
>  		return false;
>  
>  	cval = timer->cntv_cval;
> @@ -127,24 +134,59 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
>  	return cval <= now;
>  }
>  
> -/**
> - * kvm_timer_flush_hwstate - prepare to move the virt timer to the cpu
> - * @vcpu: The vcpu pointer
> - *
> - * Disarm any pending soft timers, since the world-switch code will write the
> - * virtual timer state back to the physical CPU.
> +/*
> + * Schedule the background timer before calling kvm_vcpu_block, so that this
> + * thread is removed from its waitqueue and made runnable when there's a timer
> + * interrupt to handle.
>   */
> -void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
> +void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +	u64 ns;
> +	cycle_t cval, now;
> +
> +	/*
> +	 * No need to schedule a background timer if the guest timer has
> +	 * already expired, because kvm_vcpu_block will return before putting
> +	 * the thread to sleep.
> +	 */
> +	if (kvm_timer_should_fire(vcpu))
> +		return;
>  
>  	/*
> -	 * We're about to run this vcpu again, so there is no need to
> -	 * keep the background timer running, as we're about to
> -	 * populate the CPU timer again.
> +	 * If the timer is either not capable of raising interrupts (disabled
> +	 * or masked) or if we already have a background timer, then there's
> +	 * no more work for us to do.
>  	 */
> +	if (!kvm_timer_irq_enabled(vcpu) || timer_is_armed(timer))
> +		return;

Do we need to retest kvm_timer_irq_enabled here? It is already implied
by kvm_timer_should_fire...

> +
> +	/*  The timer has not yet expired, schedule a background timer */
> +	cval = timer->cntv_cval;
> +	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
> +
> +	ns = cyclecounter_cyc2ns(timecounter->cc,
> +				 cval - now,
> +				 timecounter->mask,
> +				 &timecounter->frac);
> +	timer_arm(timer, ns);
> +}
> +
> +void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	timer_disarm(timer);
> +}
>  
> +/**
> + * kvm_timer_flush_hwstate - prepare to move the virt timer to the cpu
> + * @vcpu: The vcpu pointer
> + *
> + * Check if the virtual timer has expired while we were running in the host,
> + * and inject an interrupt if that was the case.
> + */
> +void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
> +{
>  	/*
>  	 * If the timer expired while we were not scheduled, now is the time
>  	 * to inject it.
> @@ -157,32 +199,17 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>   * kvm_timer_sync_hwstate - sync timer state from cpu
>   * @vcpu: The vcpu pointer
>   *
> - * Check if the virtual timer was armed and either schedule a corresponding
> - * soft timer or inject directly if already expired.
> + * Check if the virtual timer has expired while we werer running in the guest,

s/werer/were/

> + * and inject an interrupt if that was the case.
>   */
>  void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> -	cycle_t cval, now;
> -	u64 ns;
>  
>  	BUG_ON(timer_is_armed(timer));
>  
> -	if (kvm_timer_should_fire(vcpu)) {
> -		/*
> -		 * Timer has already expired while we were not
> -		 * looking. Inject the interrupt and carry on.
> -		 */
> +	if (kvm_timer_should_fire(vcpu))
>  		kvm_timer_inject_irq(vcpu);
> -		return;
> -	}
> -
> -	cval = timer->cntv_cval;
> -	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
> -
> -	ns = cyclecounter_cyc2ns(timecounter->cc, cval - now, timecounter->mask,
> -				 &timecounter->frac);
> -	timer_arm(timer, ns);
>  }
>  
>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> 

Apart from the few comments above, looks pretty good.

	M.
-- 
Jazz is not dead. It just smells funny...
