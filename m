Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209AD7CF22
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 16:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706113391; cv=none; b=c+JHV8m8u7+vFYBN76fl6YdDNzirqXCUJHusOgFgKIvS2owWcejAcxmVT5spyn+nJNdMkniiEl2uBybAEvNjuz0/z2auQkN+hg1gpuGxGD7mzaU/a5PAtIm1RA7yk9Gb5WGRXKplLGtqX4s5++2zrQb3rO8lqRCQSFtpvaBi4eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706113391; c=relaxed/simple;
	bh=DdsLKmQI4FNqBapVet/LQ/lk8V1yfEgBqkL7Iv7h/P4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wa55DX4P40JS57vyDCeZHBcmqYaN/nCfc3Q6DSuDk5RFg8fzyOQEhZPzRS8c0L2DDgX3ZA190L0oZt+3bnoWPcj195XZPeAn/q/rPsm8NInG8EeINqW2Be+CdaGbxZ6oiq/2dI1sgKOPfoS+91jVDOhVD/3BmTMkd5z792a/4S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B5611FB;
	Wed, 24 Jan 2024 08:23:53 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33E613F762;
	Wed, 24 Jan 2024 08:23:07 -0800 (PST)
Date: Wed, 24 Jan 2024 16:23:05 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 12/25] KVM: arm64: nv: Move system instructions to their
 own sys_reg_desc array
Message-ID: <20240124162305.GH1283334@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-13-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-13-maz@kernel.org>

Salut,

On Mon, Jan 22, 2024 at 08:18:39PM +0000, Marc Zyngier wrote:
> As NV results in a bunch of system instructions being trapped, it makes
> sense to pull the system instructions into their own little array, where
> they will eventually be joined by AT, TLBI and a bunch of other CMOs.
> 
> Based on an initial patch by Jintack Lim.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 59 +++++++++++++++++++++++++++++----------
>  1 file changed, 44 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 041b11825578..501de653beb5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2197,16 +2197,6 @@ static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>   * guest...
>   */
>  static const struct sys_reg_desc sys_reg_descs[] = {
> -	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
> -	{ SYS_DESC(SYS_DC_IGSW), access_dcgsw },
> -	{ SYS_DESC(SYS_DC_IGDSW), access_dcgsw },
> -	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
> -	{ SYS_DESC(SYS_DC_CGSW), access_dcgsw },
> -	{ SYS_DESC(SYS_DC_CGDSW), access_dcgsw },
> -	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
> -	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
> -	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
> -
>  	DBG_BCR_BVR_WCR_WVR_EL1(0),
>  	DBG_BCR_BVR_WCR_WVR_EL1(1),
>  	{ SYS_DESC(SYS_MDCCINT_EL1), trap_debug_regs, reset_val, MDCCINT_EL1, 0 },
> @@ -2738,6 +2728,18 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
>  };
>  
> +static struct sys_reg_desc sys_insn_descs[] = {
> +	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
> +	{ SYS_DESC(SYS_DC_IGSW), access_dcgsw },
> +	{ SYS_DESC(SYS_DC_IGDSW), access_dcgsw },
> +	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
> +	{ SYS_DESC(SYS_DC_CGSW), access_dcgsw },
> +	{ SYS_DESC(SYS_DC_CGDSW), access_dcgsw },
> +	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
> +	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
> +	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
> +};
> +
>  static const struct sys_reg_desc *first_idreg;
>  
>  static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
> @@ -3431,6 +3433,24 @@ static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
>  	return false;
>  }
>  
> +static int emulate_sys_instr(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
> +{
> +	const struct sys_reg_desc *r;
> +
> +	/* Search from the system instruction table. */
> +	r = find_reg(p, sys_insn_descs, ARRAY_SIZE(sys_insn_descs));
> +
> +	if (likely(r)) {
> +		perform_access(vcpu, p, r);
> +	} else {
> +		kvm_err("Unsupported guest sys instruction at: %lx\n",
> +			*vcpu_pc(vcpu));
> +		print_sys_reg_instr(p);
> +		kvm_inject_undefined(vcpu);
> +	}
> +	return 1;
> +}
> +
>  static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
>  {
>  	const struct sys_reg_desc *idreg = first_idreg;
> @@ -3478,7 +3498,8 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>  }
>  
>  /**
> - * kvm_handle_sys_reg -- handles a mrs/msr trap on a guest sys_reg access
> + * kvm_handle_sys_reg -- handles a system instruction or mrs/msr instruction
> + *			 trap on a guest execution
>   * @vcpu: The VCPU pointer
>   */
>  int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
> @@ -3495,12 +3516,19 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
>  	params = esr_sys64_to_params(esr);
>  	params.regval = vcpu_get_reg(vcpu, Rt);
>  
> -	if (!emulate_sys_reg(vcpu, &params))
> +	/* System register? */

Can you put a reference here, DDI487 J.a C5.1.2? (2 and 3 look magic otherwise)

> +	if (params.Op0 == 2 || params.Op0 == 3) {
> +		if (!emulate_sys_reg(vcpu, &params))
> +			return 1;
> +
> +		if (!params.is_write)
> +			vcpu_set_reg(vcpu, Rt, params.regval);
> +
>  		return 1;
> +	}
>  
> -	if (!params.is_write)
> -		vcpu_set_reg(vcpu, Rt, params.regval);
> -	return 1;
> +	/* Hints, PSTATE (Op0 == 0) and System instructions (Op0 == 1) */
> +	return emulate_sys_instr(vcpu, &params);
>  }
>  
>  /******************************************************************************
> @@ -3954,6 +3982,7 @@ int __init kvm_sys_reg_table_init(void)
>  	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true);
>  	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true);
>  	valid &= check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false);
> +	valid &= check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs), false);
>  
>  	if (!valid)
>  		return -EINVAL;

Otherwise,

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

