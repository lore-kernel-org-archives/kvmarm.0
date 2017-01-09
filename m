From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC 2/8] KVM: arm/arm64: Decouple kvm timer functions from
 virtual timer
Date: Mon, 9 Jan 2017 12:59:26 +0100
Message-ID: <20170109115926.GC4348@cbox>
References: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
 <1482772326-29110-3-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C324440539
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 06:57:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Unrj6Obtyjh5 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 06:57:48 -0500 (EST)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BEB52404F1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 06:57:47 -0500 (EST)
Received: by mail-lf0-f42.google.com with SMTP id k86so93103002lfi.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Jan 2017 03:59:29 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1482772326-29110-3-git-send-email-jintack@cs.columbia.edu>
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

On Mon, Dec 26, 2016 at 12:12:00PM -0500, Jintack Lim wrote:
> Now that we have a separate structure for timer context, make functions
> general so that they can work on any timer context, not just the virtual
> timer context.  This does not change the virtual timer functionality.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/arm/kvm/arm.c           |  2 +-
>  include/kvm/arm_arch_timer.h |  3 +-
>  virt/kvm/arm/arch_timer.c    | 65 +++++++++++++++++++++++++-------------------
>  3 files changed, 40 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 19b5f5c..37d1623 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -295,7 +295,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_timer_should_fire(vcpu);
> +	return kvm_timer_should_fire(vcpu, vcpu_vtimer(vcpu));
>  }
>  
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 7dabe56..cf84145 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -69,7 +69,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
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
> index 30a64df..3bd6063 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -91,7 +91,7 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
>  	vcpu = container_of(work, struct kvm_vcpu, arch.timer_cpu.expired);
>  	vcpu->arch.timer_cpu.armed = false;
>  
> -	WARN_ON(!kvm_timer_should_fire(vcpu));
> +	WARN_ON(!kvm_timer_should_fire(vcpu, vcpu_vtimer(vcpu)));
>  
>  	/*
>  	 * If the vcpu is blocked we want to wake it up so that it will see
> @@ -100,12 +100,22 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
>  	kvm_vcpu_kick(vcpu);
>  }
>  
> -static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu)
> +static u64 kvm_timer_cntvoff(struct kvm_vcpu *vcpu,
> +			     struct arch_timer_context *timer_ctx)
> +{
> +	if (timer_ctx == vcpu_vtimer(vcpu))
> +		return vcpu->kvm->arch.timer.cntvoff;
> +
> +	return 0;
> +}
> +
> +static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu,
> +				   struct arch_timer_context *timer_ctx)
>  {
>  	cycle_t cval, now;
>  
> -	cval = vcpu_vtimer(vcpu)->cnt_cval;
> -	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
> +	cval = timer_ctx->cnt_cval;
> +	now = kvm_phys_timer_read() - kvm_timer_cntvoff(vcpu, timer_ctx);
>  
>  	if (now < cval) {
>  		u64 ns;
> @@ -134,7 +144,7 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
>  	 * PoV (NTP on the host may have forced it to expire
>  	 * early). If we should have slept longer, restart it.
>  	 */
> -	ns = kvm_timer_compute_delta(vcpu);
> +	ns = kvm_timer_compute_delta(vcpu, vcpu_vtimer(vcpu));
>  	if (unlikely(ns)) {
>  		hrtimer_forward_now(hrt, ns_to_ktime(ns));
>  		return HRTIMER_RESTART;
> @@ -144,42 +154,40 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
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
>  {
> -	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  	cycle_t cval, now;
>  
> -	if (!kvm_timer_irq_can_fire(vcpu))
> +	if (!kvm_timer_irq_can_fire(timer_ctx))
>  		return false;
>  
> -	cval = vtimer->cnt_cval;
> -	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
> +	cval = timer_ctx->cnt_cval;
> +	now = kvm_phys_timer_read() - kvm_timer_cntvoff(vcpu, timer_ctx);
>  

I'm wondering if we should move the cntvoff field to the
arch_timer_context struct so that all these functions can just take
the timer_ctx pointer without a vcpu pointer?

(That would pave the way for ever doing adjustments of the cntvoff on a
per-CPU basis if that should ever make sense, which it maybe won't but
still...)

The challenge would be to ensure that the cntvoff stays in sync between
all the contexts when being modified from userspace and during init.

Thoughts?

Thanks,
-Christoffer
