From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v2 10/10] KVM: arm/arm64: Emulate the EL1 phys timer
 register access
Date: Sun, 29 Jan 2017 15:44:35 +0000
Message-ID: <86lgtt98gs.fsf@arm.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-11-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 871D44093E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 10:45:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oD7zGoQYgwih for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Jan 2017 10:45:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6511840692
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 10:45:55 -0500 (EST)
In-Reply-To: <1485479100-4966-11-git-send-email-jintack@cs.columbia.edu>
 (Jintack Lim's message of "Thu, 26 Jan 2017 20:05:00 -0500")
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

On Fri, Jan 27 2017 at 01:05:00 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
> Emulate read and write operations to CNTP_TVAL, CNTP_CVAL and CNTP_CTL.
> Now VMs are able to use the EL1 physical timer.
>
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/arm64/kvm/sys_regs.c    | 32 +++++++++++++++++++++++++++++---
>  include/kvm/arm_arch_timer.h |  2 ++
>  virt/kvm/arm/arch_timer.c    |  2 +-
>  3 files changed, 32 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index fd9e747..adf009f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -824,7 +824,14 @@ static bool access_cntp_tval(struct kvm_vcpu *vcpu,
>  		struct sys_reg_params *p,
>  		const struct sys_reg_desc *r)
>  {
> -	kvm_inject_undefined(vcpu);
> +	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> +	u64 now = kvm_phys_timer_read();
> +
> +	if (p->is_write)
> +		ptimer->cnt_cval = p->regval + now;
> +	else
> +		p->regval = ptimer->cnt_cval - now;
> +
>  	return true;
>  }
>  
> @@ -832,7 +839,20 @@ static bool access_cntp_ctl(struct kvm_vcpu *vcpu,
>  		struct sys_reg_params *p,
>  		const struct sys_reg_desc *r)
>  {
> -	kvm_inject_undefined(vcpu);
> +	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> +
> +	if (p->is_write) {
> +		/* ISTATUS bit is read-only */
> +		ptimer->cnt_ctl = p->regval & ~ARCH_TIMER_CTRL_IT_STAT;
> +	} else {
> +		u64 now = kvm_phys_timer_read();
> +
> +		p->regval = ptimer->cnt_ctl;
> +		/* Set ISTATUS bit if it's expired */
> +		if (ptimer->cnt_cval <= now)
> +			p->regval |= ARCH_TIMER_CTRL_IT_STAT;
> +	}

Shouldn't we take the ENABLE bit into account? The ARMv8 ARM version I
have at hand (version h) seems to indicate that we should, but we should
check with the latest and greatest...

> +
>  	return true;
>  }
>  
> @@ -840,7 +860,13 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
>  		struct sys_reg_params *p,
>  		const struct sys_reg_desc *r)
>  {
> -	kvm_inject_undefined(vcpu);
> +	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> +
> +	if (p->is_write)
> +		ptimer->cnt_cval = p->regval;
> +	else
> +		p->regval = ptimer->cnt_cval;
> +
>  	return true;
>  }
>  
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index a364593..fec99f2 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -74,6 +74,8 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu,
>  void kvm_timer_schedule(struct kvm_vcpu *vcpu);
>  void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
>  
> +u64 kvm_phys_timer_read(void);
> +
>  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
>  
>  void kvm_timer_init_vhe(void);
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index b366bb2..9eec063 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -40,7 +40,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>  	vcpu_vtimer(vcpu)->active_cleared_last = false;
>  }
>  
> -static u64 kvm_phys_timer_read(void)
> +u64 kvm_phys_timer_read(void)
>  {
>  	return timecounter->cc->read(timecounter->cc);
>  }

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
