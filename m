From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 04/11] KVM: arm: common infrastructure for handling
 AArch32 CP14/CP15
Date: Mon, 29 Jun 2015 21:43:34 +0200
Message-ID: <20150629194334.GN11332@cbox>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
 <1434969694-7432-5-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434969694-7432-5-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 22, 2015 at 06:41:27PM +0800, Zhichao Huang wrote:
> As we're about to trap a bunch of CP14 registers, let's rework
> the CP15 handling so it can be generalized and work with multiple
> tables.
> 
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> ---
>  arch/arm/kvm/coproc.c          | 176 ++++++++++++++++++++++++++---------------
>  arch/arm/kvm/interrupts_head.S |   2 +-
>  2 files changed, 112 insertions(+), 66 deletions(-)
> 
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index 9d283d9..d23395b 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -375,6 +375,9 @@ static const struct coproc_reg cp15_regs[] = {
>  	{ CRn(15), CRm( 0), Op1( 4), Op2( 0), is32, access_cbar},
>  };
>  
> +static const struct coproc_reg cp14_regs[] = {
> +};
> +
>  /* Target specific emulation tables */
>  static struct kvm_coproc_target_table *target_tables[KVM_ARM_NUM_TARGETS];
>  
> @@ -424,47 +427,75 @@ static const struct coproc_reg *find_reg(const struct coproc_params *params,
>  	return NULL;
>  }
>  
> -static int emulate_cp15(struct kvm_vcpu *vcpu,
> -			const struct coproc_params *params)
> +/*
> + * emulate_cp --  tries to match a cp14/cp15 access in a handling table,
> + *                and call the corresponding trap handler.
> + *
> + * @params: pointer to the descriptor of the access
> + * @table: array of trap descriptors
> + * @num: size of the trap descriptor array
> + *
> + * Return 0 if the access has been handled, and -1 if not.
> + */
> +static int emulate_cp(struct kvm_vcpu *vcpu,
> +			const struct coproc_params *params,
> +			const struct coproc_reg *table,
> +			size_t num)
>  {
> -	size_t num;
> -	const struct coproc_reg *table, *r;
> -
> -	trace_kvm_emulate_cp15_imp(params->Op1, params->Rt1, params->CRn,
> -				   params->CRm, params->Op2, params->is_write);
> +	const struct coproc_reg *r;
>  
> -	table = get_target_table(vcpu->arch.target, &num);
> +	if (!table)
> +		return -1;	/* Not handled */
>  
> -	/* Search target-specific then generic table. */
>  	r = find_reg(params, table, num);
> -	if (!r)
> -		r = find_reg(params, cp15_regs, ARRAY_SIZE(cp15_regs));
>  
> -	if (likely(r)) {
> +	if (r) {
>  		/* If we don't have an accessor, we should never get here! */
>  		BUG_ON(!r->access);
>  
>  		if (likely(r->access(vcpu, params, r))) {
>  			/* Skip instruction, since it was emulated */
>  			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> -			return 1;
>  		}
> -		/* If access function fails, it should complain. */
> -	} else {
> -		kvm_err("Unsupported guest CP15 access at: %08lx\n",
> -			*vcpu_pc(vcpu));
> -		print_cp_instr(params);
> +
> +		/* Handled */
> +		return 0;
>  	}
> +
> +	/* Not handled */
> +	return -1;
> +}
> +
> +static void unhandled_cp_access(struct kvm_vcpu *vcpu,
> +				const struct coproc_params *params)
> +{
> +	u8 hsr_ec = kvm_vcpu_trap_get_class(vcpu);
> +	int cp;
> +
> +	switch (hsr_ec) {
> +	case HSR_EC_CP15_32:
> +	case HSR_EC_CP15_64:
> +		cp = 15;
> +		break;
> +	case HSR_EC_CP14_MR:
> +	case HSR_EC_CP14_64:
> +		cp = 14;
> +		break;
> +	default:
> +		WARN_ON((cp = -1));
> +	}
> +
> +	kvm_err("Unsupported guest CP%d access at: %08lx\n",
> +		cp, *vcpu_pc(vcpu));
> +	print_cp_instr(params);
>  	kvm_inject_undefined(vcpu);
> -	return 1;
>  }
>  
> -/**
> - * kvm_handle_cp15_64 -- handles a mrrc/mcrr trap on a guest CP15 access
> - * @vcpu: The VCPU pointer
> - * @run:  The kvm_run struct
> - */
> -int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
> +			const struct coproc_reg *global,
> +			size_t nr_global,
> +			const struct coproc_reg *target_specific,
> +			size_t nr_specific)
>  {
>  	struct coproc_params params;
>  
> @@ -478,7 +509,13 @@ int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	params.Rt2 = (kvm_vcpu_get_hsr(vcpu) >> 10) & 0xf;
>  	params.CRm = 0;
>  
> -	return emulate_cp15(vcpu, &params);
> +	if (!emulate_cp(vcpu, &params, target_specific, nr_specific))
> +		return 1;
> +	if (!emulate_cp(vcpu, &params, global, nr_global))
> +		return 1;
> +
> +	unhandled_cp_access(vcpu, &params);
> +	return 1;
>  }
>  
>  static void reset_coproc_regs(struct kvm_vcpu *vcpu,
> @@ -491,12 +528,11 @@ static void reset_coproc_regs(struct kvm_vcpu *vcpu,
>  			table[i].reset(vcpu, &table[i]);
>  }
>  
> -/**
> - * kvm_handle_cp15_32 -- handles a mrc/mcr trap on a guest CP15 access
> - * @vcpu: The VCPU pointer
> - * @run:  The kvm_run struct
> - */
> -int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
> +			const struct coproc_reg *global,
> +			size_t nr_global,
> +			const struct coproc_reg *target_specific,
> +			size_t nr_specific)
>  {
>  	struct coproc_params params;
>  
> @@ -510,33 +546,57 @@ int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	params.Op2 = (kvm_vcpu_get_hsr(vcpu) >> 17) & 0x7;
>  	params.Rt2 = 0;
>  
> -	return emulate_cp15(vcpu, &params);
> +	if (!emulate_cp(vcpu, &params, target_specific, nr_specific))
> +		return 1;
> +	if (!emulate_cp(vcpu, &params, global, nr_global))
> +		return 1;
> +
> +	unhandled_cp_access(vcpu, &params);
> +	return 1;
>  }
>  
>  /**
> - * kvm_handle_cp14_64 -- handles a mrrc/mcrr trap on a guest CP14 access
> + * kvm_handle_cp15_64 -- handles a mrrc/mcrr trap on a guest CP15 access
>   * @vcpu: The VCPU pointer
>   * @run:  The kvm_run struct
>   */
> -int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
> -	struct coproc_params params;
> +	const struct coproc_reg *target_specific;
> +	size_t num;
>  
> -	params.CRn = (kvm_vcpu_get_hsr(vcpu) >> 1) & 0xf;
> -	params.Rt1 = (kvm_vcpu_get_hsr(vcpu) >> 5) & 0xf;
> -	params.is_write = ((kvm_vcpu_get_hsr(vcpu) & 1) == 0);
> -	params.is_64bit = true;
> +	target_specific = get_target_table(vcpu->arch.target, &num);
> +	return kvm_handle_cp_64(vcpu,
> +				cp15_regs, ARRAY_SIZE(cp15_regs),
> +				target_specific, num);
> +}
>  
> -	params.Op1 = (kvm_vcpu_get_hsr(vcpu) >> 16) & 0xf;
> -	params.Op2 = 0;
> -	params.Rt2 = (kvm_vcpu_get_hsr(vcpu) >> 10) & 0xf;
> -	params.CRm = 0;
> +/**
> + * kvm_handle_cp15_32 -- handles a mrc/mcr trap on a guest CP15 access
> + * @vcpu: The VCPU pointer
> + * @run:  The kvm_run struct
> + */
> +int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	const struct coproc_reg *target_specific;
> +	size_t num;
>  
> -	(void)trap_raz_wi(vcpu, &params, NULL);
> +	target_specific = get_target_table(vcpu->arch.target, &num);
> +	return kvm_handle_cp_32(vcpu,
> +				cp15_regs, ARRAY_SIZE(cp15_regs),
> +				target_specific, num);
> +}
>  
> -	/* handled */
> -	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> -	return 1;
> +/**
> + * kvm_handle_cp14_64 -- handles a mrrc/mcrr trap on a guest CP14 access
> + * @vcpu: The VCPU pointer
> + * @run:  The kvm_run struct
> + */
> +int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	return kvm_handle_cp_64(vcpu,
> +				cp14_regs, ARRAY_SIZE(cp14_regs),
> +				NULL, 0);
>  }
>  
>  /**
> @@ -546,23 +606,9 @@ int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
>   */
>  int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
> -	struct coproc_params params;
> -
> -	params.CRm = (kvm_vcpu_get_hsr(vcpu) >> 1) & 0xf;
> -	params.Rt1 = (kvm_vcpu_get_hsr(vcpu) >> 5) & 0xf;
> -	params.is_write = ((kvm_vcpu_get_hsr(vcpu) & 1) == 0);
> -	params.is_64bit = false;
> -
> -	params.CRn = (kvm_vcpu_get_hsr(vcpu) >> 10) & 0xf;
> -	params.Op1 = (kvm_vcpu_get_hsr(vcpu) >> 14) & 0x7;
> -	params.Op2 = (kvm_vcpu_get_hsr(vcpu) >> 17) & 0x7;
> -	params.Rt2 = 0;
> -
> -	(void)trap_raz_wi(vcpu, &params, NULL);
> -
> -	/* handled */
> -	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> -	return 1;
> +	return kvm_handle_cp_32(vcpu,
> +				cp14_regs, ARRAY_SIZE(cp14_regs),
> +				NULL, 0);
>  }
>  
>  /******************************************************************************
> diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
> index f85c447..a20b9ad 100644
> --- a/arch/arm/kvm/interrupts_head.S
> +++ b/arch/arm/kvm/interrupts_head.S
> @@ -618,7 +618,7 @@ ARM_BE8(rev	r6, r6  )
>   * (hardware reset value is 0) */
>  .macro set_hdcr operation
>  	mrc	p15, 4, r2, c1, c1, 1
> -	ldr	r3, =(HDCR_TPM|HDCR_TPMCR|HDCR_TDRA|HDCR_TDOSA|HDCR_TDA)
> +	ldr	r3, =(HDCR_TPM|HDCR_TPMCR)

why do we stop trapping accesses here?

-Christoffer

>  	.if \operation == vmentry
>  	orr	r2, r2, r3		@ Trap some perfmon accesses
>  	.else
> -- 
> 1.7.12.4
> 
