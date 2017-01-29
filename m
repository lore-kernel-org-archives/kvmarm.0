From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v2 05/10] KVM: arm/arm64: Initialize the emulated EL1
 physical timer
Date: Sun, 29 Jan 2017 12:07:48 +0000
Message-ID: <86wpde83xn.fsf@arm.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-6-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7933B40284
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 07:08:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JGdf4+fVDm0b for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Jan 2017 07:08:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45B2D40187
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 07:08:01 -0500 (EST)
In-Reply-To: <1485479100-4966-6-git-send-email-jintack@cs.columbia.edu>
 (Jintack Lim's message of "Thu, 26 Jan 2017 20:04:55 -0500")
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

On Fri, Jan 27 2017 at 01:04:55 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
> Initialize the emulated EL1 physical timer with the default irq number.
>
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
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

At some point, we'll have to make that discoverable/configurable. Maybe
the time for a discoverable arch timer has come (see below).

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
> index 69f648b..a364593 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -59,7 +59,8 @@ struct arch_timer_cpu {
>  int kvm_timer_enable(struct kvm_vcpu *vcpu);
>  void kvm_timer_init(struct kvm *kvm);
>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> -			 const struct kvm_irq_level *irq);
> +			 const struct kvm_irq_level *virt_irq,
> +			 const struct kvm_irq_level *phys_irq);
>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
>  void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
>  void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index f72005a..0f6e935 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -329,9 +329,11 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
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
> @@ -339,7 +341,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  	 * kvm_vcpu_set_target(). To handle this, we determine
>  	 * vcpu timer irq number when the vcpu is reset.
>  	 */
> -	vtimer->irq.irq = irq->irq;
> +	vtimer->irq.irq = virt_irq->irq;
> +	ptimer->irq.irq = phys_irq->irq;
>  
>  	/*
>  	 * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
> @@ -348,6 +351,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  	 * the ARMv7 architecture.
>  	 */
>  	vtimer->cnt_ctl = 0;
> +	ptimer->cnt_ctl = 0;
>  	kvm_timer_update_state(vcpu);
>  
>  	return 0;
> @@ -369,6 +373,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  
>  	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
> +	vcpu_ptimer(vcpu)->cntvoff = 0;

This is quite contentious, IMHO. Do we really want to expose the delta
between the virtual and physical counters? That's a clear indication to
the guest that it is virtualized. I"m not sure it matters, but I think
we should at least make a conscious choice, and maybe give the
opportunity to userspace to select the desired behaviour.

>  
>  	INIT_WORK(&timer->expired, kvm_timer_inject_irq_work);
>  	hrtimer_init(&timer->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
