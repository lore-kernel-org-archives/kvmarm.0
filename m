From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC v3 05/10] KVM: arm/arm64: Initialize the emulated EL1
 physical timer
Date: Thu, 2 Feb 2017 11:15:21 +0100
Message-ID: <20170202101521.GD27852@cbox>
References: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
 <1485970990-13775-6-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68B38408E9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 05:15:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xu5ekS7WWsAz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Feb 2017 05:15:04 -0500 (EST)
Received: from mail-lf0-f45.google.com (mail-lf0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E57540194
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 05:15:03 -0500 (EST)
Received: by mail-lf0-f45.google.com with SMTP id n124so5897562lfd.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Feb 2017 02:15:26 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1485970990-13775-6-git-send-email-jintack@cs.columbia.edu>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 01, 2017 at 12:43:05PM -0500, Jintack Lim wrote:
> Initialize the emulated EL1 physical timer with the default irq number.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>

We really need to do something about that IRQ number thing.  I'll add
this to my todo list.

Since this is no worse than what we already do and doesn't place any
restrictions on future ABI to let userspace decide on the IRQ numbers:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  arch/arm/kvm/reset.c         | 9 ++++++++-
>  arch/arm64/kvm/reset.c       | 9 ++++++++-
>  include/kvm/arm_arch_timer.h | 3 ++-
>  virt/kvm/arm/arch_timer.c    | 9 +++++++--
>  4 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/kvm/reset.c b/arch/arm/kvm/reset.c
> index 4b5e802..1da8b2d 100644
> --- a/arch/arm/kvm/reset.c
> +++ b/arch/arm/kvm/reset.c
> @@ -37,6 +37,11 @@
>  	.usr_regs.ARM_cpsr = SVC_MODE | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT,
>  };
>  
> +static const struct kvm_irq_level cortexa_ptimer_irq = {
> +	{ .irq = 30 },
> +	.level = 1,
> +};
> +
>  static const struct kvm_irq_level cortexa_vtimer_irq = {
>  	{ .irq = 27 },
>  	.level = 1,
> @@ -58,6 +63,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_regs *reset_regs;
>  	const struct kvm_irq_level *cpu_vtimer_irq;
> +	const struct kvm_irq_level *cpu_ptimer_irq;
>  
>  	switch (vcpu->arch.target) {
>  	case KVM_ARM_TARGET_CORTEX_A7:
> @@ -65,6 +71,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  		reset_regs = &cortexa_regs_reset;
>  		vcpu->arch.midr = read_cpuid_id();
>  		cpu_vtimer_irq = &cortexa_vtimer_irq;
> +		cpu_ptimer_irq = &cortexa_ptimer_irq;
>  		break;
>  	default:
>  		return -ENODEV;
> @@ -77,5 +84,5 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	kvm_reset_coprocs(vcpu);
>  
>  	/* Reset arch_timer context */
> -	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
> +	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq, cpu_ptimer_irq);
>  }
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index e95d4f6..d9e9697 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -46,6 +46,11 @@
>  			COMPAT_PSR_I_BIT | COMPAT_PSR_F_BIT),
>  };
>  
> +static const struct kvm_irq_level default_ptimer_irq = {
> +	.irq	= 30,
> +	.level	= 1,
> +};
> +
>  static const struct kvm_irq_level default_vtimer_irq = {
>  	.irq	= 27,
>  	.level	= 1,
> @@ -104,6 +109,7 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	const struct kvm_irq_level *cpu_vtimer_irq;
> +	const struct kvm_irq_level *cpu_ptimer_irq;
>  	const struct kvm_regs *cpu_reset;
>  
>  	switch (vcpu->arch.target) {
> @@ -117,6 +123,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  		}
>  
>  		cpu_vtimer_irq = &default_vtimer_irq;
> +		cpu_ptimer_irq = &default_ptimer_irq;
>  		break;
>  	}
>  
> @@ -130,5 +137,5 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	kvm_pmu_vcpu_reset(vcpu);
>  
>  	/* Reset timer */
> -	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
> +	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq, cpu_ptimer_irq);
>  }
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 6445a3d..f1d2fba0 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -58,7 +58,8 @@ struct arch_timer_cpu {
>  int kvm_timer_hyp_init(void);
>  int kvm_timer_enable(struct kvm_vcpu *vcpu);
>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> -			 const struct kvm_irq_level *irq);
> +			 const struct kvm_irq_level *virt_irq,
> +			 const struct kvm_irq_level *phys_irq);
>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
>  void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
>  void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index c42bca5..ae38703 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -327,9 +327,11 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
>  }
>  
>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> -			 const struct kvm_irq_level *irq)
> +			 const struct kvm_irq_level *virt_irq,
> +			 const struct kvm_irq_level *phys_irq)
>  {
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> +	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  
>  	/*
>  	 * The vcpu timer irq number cannot be determined in
> @@ -337,7 +339,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  	 * kvm_vcpu_set_target(). To handle this, we determine
>  	 * vcpu timer irq number when the vcpu is reset.
>  	 */
> -	vtimer->irq.irq = irq->irq;
> +	vtimer->irq.irq = virt_irq->irq;
> +	ptimer->irq.irq = phys_irq->irq;
>  
>  	/*
>  	 * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
> @@ -346,6 +349,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  	 * the ARMv7 architecture.
>  	 */
>  	vtimer->cnt_ctl = 0;
> +	ptimer->cnt_ctl = 0;
>  	kvm_timer_update_state(vcpu);
>  
>  	return 0;
> @@ -369,6 +373,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  
>  	/* Synchronize cntvoff across all vtimers of a VM. */
>  	update_vtimer_cntvoff(vcpu->kvm, kvm_phys_timer_read());
> +	vcpu_ptimer(vcpu)->cntvoff = 0;
>  
>  	INIT_WORK(&timer->expired, kvm_timer_inject_irq_work);
>  	hrtimer_init(&timer->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
> -- 
> 1.9.1
> 
> 
