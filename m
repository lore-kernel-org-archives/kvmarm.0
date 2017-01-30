From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC v2 03/10] KVM: arm/arm64: Decouple kvm timer functions from
 virtual timer
Date: Mon, 30 Jan 2017 15:49:04 +0100
Message-ID: <20170130144904.GB16459@cbox>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-4-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1153340190
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 09:48:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7eTzHjl81z4h for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 09:48:49 -0500 (EST)
Received: from mail-lf0-f43.google.com (mail-lf0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BFD64018B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 09:48:49 -0500 (EST)
Received: by mail-lf0-f43.google.com with SMTP id z134so195595811lff.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 06:49:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1485479100-4966-4-git-send-email-jintack@cs.columbia.edu>
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

On Thu, Jan 26, 2017 at 08:04:53PM -0500, Jintack Lim wrote:
> Now that we have a separate structure for timer context, make functions
> general so that they can work with any timer context, not just the
> virtual timer context.  This does not change the virtual timer
> functionality.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/arm/kvm/arm.c           |  2 +-
>  include/kvm/arm_arch_timer.h |  3 ++-
>  virt/kvm/arm/arch_timer.c    | 55 ++++++++++++++++++++++----------------------
>  3 files changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 9d74464..9a34a3c 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -301,7 +301,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_timer_should_fire(vcpu);
> +	return kvm_timer_should_fire(vcpu, vcpu_vtimer(vcpu));
>  }
>  
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 1b9c988..d921d20 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -67,7 +67,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  u64 kvm_arm_timer_get_reg(struct kvm_vcpu *, u64 regid);
>  int kvm_arm_timer_set_reg(struct kvm_vcpu *, u64 regid, u64 value);
>  
> -bool kvm_timer_should_fire(struct kvm_vcpu *vcpu);
> +bool kvm_timer_should_fire(struct kvm_vcpu *vcpu,
> +			   struct arch_timer_context *timer_ctx);
>  void kvm_timer_schedule(struct kvm_vcpu *vcpu);
>  void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
>  
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index fa4c042..f72005a 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -98,13 +98,13 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
>  	kvm_vcpu_kick(vcpu);
>  }
>  
> -static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu)
> +static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu,
> +				   struct arch_timer_context *timer_ctx)

do you need the vcpu parameter here?

>  {
>  	u64 cval, now;
> -	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  
> -	cval = vtimer->cnt_cval;
> -	now = kvm_phys_timer_read() - vtimer->cntvoff;
> +	cval = timer_ctx->cnt_cval;
> +	now = kvm_phys_timer_read() - timer_ctx->cntvoff;
>  
>  	if (now < cval) {
>  		u64 ns;
> @@ -133,7 +133,7 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
>  	 * PoV (NTP on the host may have forced it to expire
>  	 * early). If we should have slept longer, restart it.
>  	 */
> -	ns = kvm_timer_compute_delta(vcpu);
> +	ns = kvm_timer_compute_delta(vcpu, vcpu_vtimer(vcpu));
>  	if (unlikely(ns)) {
>  		hrtimer_forward_now(hrt, ns_to_ktime(ns));
>  		return HRTIMER_RESTART;
> @@ -143,42 +143,40 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
>  	return HRTIMER_NORESTART;
>  }
>  
> -static bool kvm_timer_irq_can_fire(struct kvm_vcpu *vcpu)
> +static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
>  {
> -	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> -
> -	return !(vtimer->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
> -		(vtimer->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
> +	return !(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
> +		(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
>  }
>  
> -bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
> +bool kvm_timer_should_fire(struct kvm_vcpu *vcpu,
> +			   struct arch_timer_context *timer_ctx)

do you need the vcpu parameter here?

>  {
> -	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  	u64 cval, now;
>  
> -	if (!kvm_timer_irq_can_fire(vcpu))
> +	if (!kvm_timer_irq_can_fire(timer_ctx))
>  		return false;
>  
> -	cval = vtimer->cnt_cval;
> -	now = kvm_phys_timer_read() - vtimer->cntvoff;
> +	cval = timer_ctx->cnt_cval;
> +	now = kvm_phys_timer_read() - timer_ctx->cntvoff;
>  
>  	return cval <= now;
>  }
>  
> -static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
> +static void kvm_timer_update_mapped_irq(struct kvm_vcpu *vcpu, bool new_level,
> +					struct arch_timer_context *timer_ctx)
>  {
>  	int ret;
> -	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  
>  	BUG_ON(!vgic_initialized(vcpu->kvm));
>  
> -	vtimer->active_cleared_last = false;
> -	vtimer->irq.level = new_level;
> -	trace_kvm_timer_update_irq(vcpu->vcpu_id, vtimer->irq.irq,
> -				   vtimer->irq.level);
> +	timer_ctx->active_cleared_last = false;
> +	timer_ctx->irq.level = new_level;
> +	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
> +				   timer_ctx->irq.level);
>  	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
> -					 vtimer->irq.irq,
> -					 vtimer->irq.level);
> +					 timer_ctx->irq.irq,
> +					 timer_ctx->irq.level);
>  	WARN_ON(ret);
>  }
>  
> @@ -200,8 +198,8 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  	if (!vgic_initialized(vcpu->kvm) || !timer->enabled)
>  		return -ENODEV;
>  
> -	if (kvm_timer_should_fire(vcpu) != vtimer->irq.level)
> -		kvm_timer_update_irq(vcpu, !vtimer->irq.level);
> +	if (kvm_timer_should_fire(vcpu, vtimer) != vtimer->irq.level)
> +		kvm_timer_update_mapped_irq(vcpu, !vtimer->irq.level, vtimer);
>  
>  	return 0;
>  }
> @@ -214,6 +212,7 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  
>  	BUG_ON(timer_is_armed(timer));
>  
> @@ -222,18 +221,18 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>  	 * already expired, because kvm_vcpu_block will return before putting
>  	 * the thread to sleep.
>  	 */
> -	if (kvm_timer_should_fire(vcpu))
> +	if (kvm_timer_should_fire(vcpu, vtimer))
>  		return;
>  
>  	/*
>  	 * If the timer is not capable of raising interrupts (disabled or
>  	 * masked), then there's no more work for us to do.
>  	 */
> -	if (!kvm_timer_irq_can_fire(vcpu))
> +	if (!kvm_timer_irq_can_fire(vtimer))
>  		return;
>  
>  	/*  The timer has not yet expired, schedule a background timer */
> -	timer_arm(timer, kvm_timer_compute_delta(vcpu));
> +	timer_arm(timer, kvm_timer_compute_delta(vcpu, vtimer));
>  }
>  
>  void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
> -- 
> 1.9.1
> 
> 
