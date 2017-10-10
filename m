From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 16/20] KVM: arm/arm64: Use kvm_arm_timer_set/get_reg for guest register traps
Date: Tue, 10 Oct 2017 10:12:03 +0100
Message-ID: <87efqbwen0.fsf@on-the-bus.cambridge.arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
        <20170923004207.22356-17-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170923004207.22356-17-cdall@linaro.org> (Christoffer Dall's
        message of "Sat, 23 Sep 2017 02:42:03 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Sep 23 2017 at  2:42:03 am BST, Christoffer Dall <cdall@linaro.org> wrote:
> When trapping on a guest access to one of the timer registers, we were
> messing with the internals of the timer state from the sysregs handling
> code, and that logic was about to receive more added complexity when
> optimizing the timer handling code.
>
> Therefore, since we already have timer register access functions (to
> access registers from userspace), reuse those for the timer register
> traps from a VM and let the timer code maintain its own consistency.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 41 ++++++++++++++---------------------------
>  1 file changed, 14 insertions(+), 27 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2e070d3..bb0e41b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -841,13 +841,16 @@ static bool access_cntp_tval(struct kvm_vcpu *vcpu,
>  		struct sys_reg_params *p,
>  		const struct sys_reg_desc *r)
>  {
> -	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  	u64 now = kvm_phys_timer_read();
> +	u64 cval;
>  
> -	if (p->is_write)
> -		ptimer->cnt_cval = p->regval + now;
> -	else
> -		p->regval = ptimer->cnt_cval - now;
> +	if (p->is_write) {
> +		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL,
> +				      p->regval + now);
> +	} else {
> +		cval = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL);
> +		p->regval = cval - now;
> +	}
>  
>  	return true;
>  }
> @@ -856,24 +859,10 @@ static bool access_cntp_ctl(struct kvm_vcpu *vcpu,
>  		struct sys_reg_params *p,
>  		const struct sys_reg_desc *r)
>  {
> -	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> -
> -	if (p->is_write) {
> -		/* ISTATUS bit is read-only */
> -		ptimer->cnt_ctl = p->regval & ~ARCH_TIMER_CTRL_IT_STAT;
> -	} else {
> -		u64 now = kvm_phys_timer_read();
> -
> -		p->regval = ptimer->cnt_ctl;
> -		/*
> -		 * Set ISTATUS bit if it's expired.
> -		 * Note that according to ARMv8 ARM Issue A.k, ISTATUS bit is
> -		 * UNKNOWN when ENABLE bit is 0, so we chose to set ISTATUS bit
> -		 * regardless of ENABLE bit for our implementation convenience.
> -		 */
> -		if (ptimer->cnt_cval <= now)
> -			p->regval |= ARCH_TIMER_CTRL_IT_STAT;
> -	}
> +	if (p->is_write)
> +		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CTL, p->regval);
> +	else
> +		p->regval = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CTL);
>  
>  	return true;
>  }
> @@ -882,12 +871,10 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
>  		struct sys_reg_params *p,
>  		const struct sys_reg_desc *r)
>  {
> -	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> -
>  	if (p->is_write)
> -		ptimer->cnt_cval = p->regval;
> +		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL, p->regval);
>  	else
> -		p->regval = ptimer->cnt_cval;
> +		p->regval = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL);
>  
>  	return true;
>  }

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead, it just smell funny.
