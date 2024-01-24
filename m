Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792BD7E76E
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 16:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706114897; cv=none; b=qtrxQNFmzUsvtvtjCScIn4JbTgeO7nLmaG/XMRDlG8iHk97MWiPyTKuvjLosu7g7NJqXOCsNXobg0foVEGOP2JL7eWOHbTHdEqAPGAqaNP5lMZEdr78LuNxcTKhfuOMyrLd264ho45mAego1k6Q+gyINjcvg5oa211gsOoiElyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706114897; c=relaxed/simple;
	bh=cSJtwZOZ13W7i/rzqRV5EIL7GLTfm/3+dOu0Gg7NPkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bedWk+tIm7ZmwiWun7A9BY9SMAPD272XrvEgAIa3HYH7QXP4WtYuOwMgNLWBiy/UmSHyriVvez2O8KsQ/tHrzaj1H1Bo8l01JN4IgRh250oSiejQkhvNLn7CzcTducBNuaj6ZuF/vT4g/FE+00dPyrZJ+HRiMKAOV2rs8Zj7uvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F2541FB;
	Wed, 24 Jan 2024 08:48:58 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 79DD73F762;
	Wed, 24 Jan 2024 08:48:12 -0800 (PST)
Date: Wed, 24 Jan 2024 16:48:10 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 15/25] KVM: arm64: Use the xarray as the primary
 sysreg/sysinsn walker
Message-ID: <20240124164810.GK1283334@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-16-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-16-maz@kernel.org>

On Mon, Jan 22, 2024 at 08:18:42PM +0000, Marc Zyngier wrote:
> Since we always start sysreg/sysinsn handling by searching the
> xarray, use it as the source of the index in the correct sys_reg_desc
> array.
> 
> This allows some cleanup, such as moving the handling of unknown
> sysregs in a single location.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h |  2 +-
>  arch/arm64/kvm/emulate-nested.c     | 36 +++++++++++-----
>  arch/arm64/kvm/sys_regs.c           | 64 +++++++++--------------------
>  3 files changed, 46 insertions(+), 56 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 4882905357f4..68465f87d308 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -60,7 +60,7 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
>  	return ttbr0 & ~GENMASK_ULL(63, 48);
>  }
>  
> -extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
> +extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu, int *sr_idx);
>  
>  int kvm_init_nv_sysregs(struct kvm *kvm);
>  
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 342d43b66fda..54ab4d240fc6 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2001,7 +2001,7 @@ static bool check_fgt_bit(struct kvm *kvm, bool is_read,
>  	return !(kvm_get_sysreg_res0(kvm, sr) & BIT(tc.bit));
>  }
>  
> -bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
> +bool __check_nv_sr_forward(struct kvm_vcpu *vcpu, int *sr_index)
>  {
>  	union trap_config tc;
>  	enum trap_behaviour b;
> @@ -2009,9 +2009,6 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  	u32 sysreg;
>  	u64 esr, val;
>  
> -	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> -		return false;
> -
>  	esr = kvm_vcpu_get_esr(vcpu);
>  	sysreg = esr_sys64_to_sysreg(esr);
>  	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
> @@ -2022,13 +2019,16 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  	 * A value of 0 for the whole entry means that we know nothing
>  	 * for this sysreg, and that it cannot be re-injected into the
>  	 * nested hypervisor. In this situation, let's cut it short.
> -	 *
> -	 * Note that ultimately, we could also make use of the xarray
> -	 * to store the index of the sysreg in the local descriptor
> -	 * array, avoiding another search... Hint, hint...
>  	 */
>  	if (!tc.val)
> -		return false;
> +		goto local;
> +
> +	/*
> +	 * If we're not nesting, immediately return to the caller, with the
> +	 * sysreg index, should we have it.
> +	 */
> +	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> +		goto local;
>  
>  	switch ((enum fgt_group_id)tc.fgt) {
>  	case __NO_FGT_GROUP__:
> @@ -2070,7 +2070,7 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  	case __NR_FGT_GROUP_IDS__:
>  		/* Something is really wrong, bail out */
>  		WARN_ONCE(1, "__NR_FGT_GROUP_IDS__");
> -		return false;
> +		goto local;
>  	}
>  
>  	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(vcpu->kvm, is_read,
> @@ -2083,6 +2083,22 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  	    ((b & BEHAVE_FORWARD_WRITE) && !is_read))
>  		goto inject;
>  
> +local:
> +	if (!tc.msr) {
> +		struct sys_reg_params params;
> +
> +		params = esr_sys64_to_params(esr);
> +
> +		// IMPDEF range. See ARM DDI 0487E.a, section D12.3.2

I know you're just moving this code, but can we update the reference? It's
DDI0487 J.a, D18.3.2 Reserved encodings for IMPLEMENTATION DEFINED registers
now. Feel free to drop the title of the section if it looks too long!

> +		if (!(params.Op0 == 3 && (params.CRn & 0b1011) == 0b1011))
> +			print_sys_reg_msg(&params,
> +					  "Unsupported guest access at: %lx\n",
> +					  *vcpu_pc(vcpu));
> +		kvm_inject_undefined(vcpu);
> +		return true;
> +	}
> +
> +	*sr_index = tc.msr - 1;
>  	return false;
>  
>  inject:
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 65319193e443..794d1f8c9bfe 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3397,12 +3397,6 @@ int kvm_handle_cp14_32(struct kvm_vcpu *vcpu)
>  	return kvm_handle_cp_32(vcpu, &params, cp14_regs, ARRAY_SIZE(cp14_regs));
>  }
>  
> -static bool is_imp_def_sys_reg(struct sys_reg_params *params)
> -{
> -	// See ARM DDI 0487E.a, section D12.3.2
> -	return params->Op0 == 3 && (params->CRn & 0b1011) == 0b1011;
> -}
> -
>  /**
>   * emulate_sys_reg - Emulate a guest access to an AArch64 system register
>   * @vcpu: The VCPU pointer
> @@ -3411,44 +3405,22 @@ static bool is_imp_def_sys_reg(struct sys_reg_params *params)
>   * Return: true if the system register access was successful, false otherwise.
>   */
>  static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
> -			   struct sys_reg_params *params)
> +			    struct sys_reg_params *params)
>  {
>  	const struct sys_reg_desc *r;
>  
>  	r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> -
>  	if (likely(r)) {
>  		perform_access(vcpu, params, r);
>  		return true;
>  	}
>  
> -	if (is_imp_def_sys_reg(params)) {
> -		kvm_inject_undefined(vcpu);
> -	} else {
> -		print_sys_reg_msg(params,
> -				  "Unsupported guest sys_reg access at: %lx [%08lx]\n",
> -				  *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
> -		kvm_inject_undefined(vcpu);
> -	}
> -	return false;
> -}
> -
> -static int emulate_sys_instr(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
> -{
> -	const struct sys_reg_desc *r;
> -
> -	/* Search from the system instruction table. */
> -	r = find_reg(p, sys_insn_descs, ARRAY_SIZE(sys_insn_descs));
> +	print_sys_reg_msg(params,
> +			  "Unsupported guest sys_reg access at: %lx [%08lx]\n",
> +			  *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
> +	kvm_inject_undefined(vcpu);
>  
> -	if (likely(r)) {
> -		perform_access(vcpu, p, r);
> -	} else {
> -		kvm_err("Unsupported guest sys instruction at: %lx\n",
> -			*vcpu_pc(vcpu));
> -		print_sys_reg_instr(p);
> -		kvm_inject_undefined(vcpu);
> -	}
> -	return 1;
> +	return false;
>  }
>  
>  static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
> @@ -3504,31 +3476,33 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>   */
>  int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
>  {
> +	const struct sys_reg_desc *desc = NULL;
>  	struct sys_reg_params params;
>  	unsigned long esr = kvm_vcpu_get_esr(vcpu);
>  	int Rt = kvm_vcpu_sys_get_rt(vcpu);
> +	int sr_idx;
>  
>  	trace_kvm_handle_sys_reg(esr);
>  
> -	if (__check_nv_sr_forward(vcpu))
> +	if (__check_nv_sr_forward(vcpu, &sr_idx))
>  		return 1;
>  
>  	params = esr_sys64_to_params(esr);
>  	params.regval = vcpu_get_reg(vcpu, Rt);
>  
> -	/* System register? */
> -	if (params.Op0 == 2 || params.Op0 == 3) {
> -		if (!emulate_sys_reg(vcpu, &params))
> -			return 1;
> +	if (params.Op0 == 2 || params.Op0 == 3)
> +		desc = &sys_reg_descs[sr_idx];
> +	else
> +		desc = &sys_insn_descs[sr_idx];
>  
> -		if (!params.is_write)
> -			vcpu_set_reg(vcpu, Rt, params.regval);
> +	perform_access(vcpu, &params, desc);
>  
> -		return 1;
> -	}
> +	/* Read from system register? */
> +	if (!params.is_write &&
> +	    (params.Op0 == 2 || params.Op0 == 3))
> +		vcpu_set_reg(vcpu, Rt, params.regval);
>  
> -	/* Hints, PSTATE (Op0 == 0) and System instructions (Op0 == 1) */
> -	return emulate_sys_instr(vcpu, &params);
> +	return 1;
>  }
>  
>  /******************************************************************************

Other than the ref update:

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
