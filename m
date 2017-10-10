From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 20/20] KVM: arm/arm64: Rework kvm_timer_should_fire
Date: Tue, 10 Oct 2017 10:59:12 +0100
Message-ID: <87wp43uxvz.fsf@on-the-bus.cambridge.arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
        <20170923004207.22356-21-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170923004207.22356-21-cdall@linaro.org> (Christoffer Dall's
        message of "Sat, 23 Sep 2017 02:42:07 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Sep 23 2017 at  2:42:07 am BST, Christoffer Dall <cdall@linaro.org> wrote:
> kvm_timer_should_fire() can be called in two different situations from
> the kvm_vcpu_block().
>
> The first case is before calling kvm_timer_schedule(), used for wait
> polling, and in this case the VCPU thread is running and the timer state
> is loaded onto the hardware so all we have to do is check if the virtual
> interrupt lines are asserted, becasue the timer interrupt handler
> functions will raise those lines as appropriate.
>
> The second case is inside the wait loop of kvm_vcpu_block(), where we
> have already called kvm_timer_schedule() and therefore the hardware will
> be disabled and the software view of the timer state is up to date
> (timer->loaded is false), and so we can simply check if the timer should
> fire by looking at the software state.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  include/kvm/arm_arch_timer.h |  3 ++-
>  virt/kvm/arm/arch_timer.c    | 22 +++++++++++++++++++++-
>  virt/kvm/arm/arm.c           |  3 +--
>  3 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index af29563..250db34 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -73,7 +73,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  
> -bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
> +bool kvm_timer_is_pending(struct kvm_vcpu *vcpu);
> +
>  void kvm_timer_schedule(struct kvm_vcpu *vcpu);
>  void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
>  
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index f92459a..1d0cd3a 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -49,6 +49,7 @@ static const struct kvm_irq_level default_vtimer_irq = {
>  static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx);
>  static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>  				 struct arch_timer_context *timer_ctx);
> +static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
>  
>  u64 kvm_phys_timer_read(void)
>  {
> @@ -223,7 +224,7 @@ static enum hrtimer_restart kvm_phys_timer_expire(struct hrtimer *hrt)
>  	return HRTIMER_NORESTART;
>  }
>  
> -bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
> +static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
>  {
>  	u64 cval, now;
>  
> @@ -236,6 +237,25 @@ bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
>  	return cval <= now;
>  }
>  
> +bool kvm_timer_is_pending(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> +	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> +
> +	if (vtimer->irq.level || ptimer->irq.level)
> +		return true;
> +
> +	/*
> +	 * When this is called from withing the wait loop of kvm_vcpu_block(),
> +	 * the software view of the timer state is up to date (timer->loaded
> +	 * is false), and so we can simply check if the timer should fire now.
> +	 */
> +	if (!vtimer->loaded && kvm_timer_should_fire(vtimer))
> +		return true;
> +
> +	return kvm_timer_should_fire(ptimer);
> +}
> +
>  /*
>   * Reflect the timer output level into the kvm_run structure
>   */
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 14c50d1..bc126fb 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -307,8 +307,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_timer_should_fire(vcpu_vtimer(vcpu)) ||
> -	       kvm_timer_should_fire(vcpu_ptimer(vcpu));
> +	return kvm_timer_is_pending(vcpu);
>  }
>  
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead, it just smell funny.
