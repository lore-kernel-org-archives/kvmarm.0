Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B113F43154
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 15:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706111634; cv=none; b=FxCRLzZm2Lh6nPK9K+BdGtig2VNpx1tx2FCsxwtrx3X9cfzT9yU9lvgE6LU92s0RssM8EAhNt4yGZoZZX/rIx9euYjwbYWAORi/URObqFE/jQyeluS/Shnjb1tuS4Ez4cNOidTIOCQehVuK0F46kMm9p/EWZaB3pKnvKltUFd7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706111634; c=relaxed/simple;
	bh=kXE5W+6Y3dlRfSgMon6lacOQeIjVu2mhg0cJ2n/s4XE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tbav0IGieE5DzFAWrIcw2CIcii51ej0cEgbWhzTHw1gPKzEz0o7srGKf7yBKMSrvkLpXMoj6P3ubBp8c397WYEicu63F/Cj+eoGUH3oUpUfnH+c+W7yHdaxNzmVCmUOEGtF1h2RhjRwa+QLs9ipPIca1q+F3Fyx+y/lkaouK3H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19C2C1FB;
	Wed, 24 Jan 2024 07:54:37 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C69F53F762;
	Wed, 24 Jan 2024 07:53:50 -0800 (PST)
Date: Wed, 24 Jan 2024 15:53:48 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 18/25] KVM: arm64: Propagate and handle Fine-Grained
 UNDEF bits
Message-ID: <20240124155348.GF1283334@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-19-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-19-maz@kernel.org>

Hello,

On Mon, Jan 22, 2024 at 08:18:45PM +0000, Marc Zyngier wrote:
> In order to correctly honor our FGU bits, they must be converted
> into a set of FGT bits. They get merged as part of the existing
> FGT setting.
> 
> Similarly, the UNDEF injection phase takes place when handling
> the trap.
> 
> This results in a bit of rework in the FGT macros in order to
> help with the code generation, as burying per-CPU accesses in
> macros results in a lot of expansion, not to mention the vcpu->kvm
> access on nvhe (kern_hyp_va() is not optimisation-friendly).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

> ---
>  arch/arm64/kvm/emulate-nested.c         | 11 ++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 81 +++++++++++++++++++------
>  2 files changed, 72 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 539b3913628d..f64d1809fe79 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2011,6 +2011,17 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
>  	if (!tc.val)
>  		goto local;
>  
> +	/*
> +	 * If a sysreg can be trapped using a FGT, first check whether we
> +	 * trap for the purpose of forbidding the feature. In that case,
> +	 * inject an UNDEF.
> +	 */
> +	if (tc.fgt != __NO_FGT_GROUP__ &&
> +	    (vcpu->kvm->arch.fgu[tc.fgt] & BIT(tc.bit))) {
> +		kvm_inject_undefined(vcpu);
> +		return true;
> +	}
> +
>  	/*
>  	 * If we're not nesting, immediately return to the caller, with the
>  	 * sysreg index, should we have it.
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index a038320cdb08..a09149fd91ed 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -79,14 +79,48 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>  		clr |= ~hfg & __ ## reg ## _nMASK; 			\
>  	} while(0)
>  
> -#define update_fgt_traps_cs(vcpu, reg, clr, set)			\
> +#define reg_to_fgt_group_id(reg)					\
> +	({								\
> +		enum fgt_group_id id;					\
> +		switch(reg) {						\
> +		case HFGRTR_EL2:					\
> +		case HFGWTR_EL2:					\
> +			id = HFGxTR_GROUP;				\
> +			break;						\
> +		case HFGITR_EL2:					\
> +			id = HFGITR_GROUP;				\
> +			break;						\
> +		case HDFGRTR_EL2:					\
> +		case HDFGWTR_EL2:					\
> +			id = HDFGRTR_GROUP;				\
> +			break;						\
> +		case HAFGRTR_EL2:					\
> +			id = HAFGRTR_GROUP;				\
> +			break;						\
> +		default:						\
> +			BUILD_BUG_ON(1);				\
> +		}							\
> +									\
> +		id;							\
> +	})
> +
> +#define compute_undef_clr_set(vcpu, kvm, reg, clr, set)			\
> +	do {								\
> +		u64 hfg = kvm->arch.fgu[reg_to_fgt_group_id(reg)];	\
> +		set |= hfg & __ ## reg ## _MASK;			\
> +		clr |= hfg & __ ## reg ## _nMASK; 			\
> +	} while(0)
> +
> +#define update_fgt_traps_cs(hctxt, vcpu, kvm, reg, clr, set)		\
>  	do {								\
> -		struct kvm_cpu_context *hctxt =				\
> -			&this_cpu_ptr(&kvm_host_data)->host_ctxt;	\
>  		u64 c = 0, s = 0;					\
>  									\
>  		ctxt_sys_reg(hctxt, reg) = read_sysreg_s(SYS_ ## reg);	\
> -		compute_clr_set(vcpu, reg, c, s);			\
> +		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))		\
> +			compute_clr_set(vcpu, reg, c, s);		\
> +									\
> +		compute_undef_clr_set(vcpu, kvm, reg, c, s);		\
> +									\
>  		s |= set;						\
>  		c |= clr;						\
>  		if (c || s) {						\
> @@ -97,8 +131,8 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>  		}							\
>  	} while(0)
>  
> -#define update_fgt_traps(vcpu, reg)		\
> -	update_fgt_traps_cs(vcpu, reg, 0, 0)
> +#define update_fgt_traps(hctxt, vcpu, kvm, reg)		\
> +	update_fgt_traps_cs(hctxt, vcpu, kvm, reg, 0, 0)
>  
>  /*
>   * Validate the fine grain trap masks.
> @@ -122,6 +156,7 @@ static inline bool cpu_has_amu(void)
>  static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> +	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
>  	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
>  	u64 r_val, w_val;
>  
> @@ -157,6 +192,9 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  		compute_clr_set(vcpu, HFGWTR_EL2, w_clr, w_set);
>  	}
>  
> +	compute_undef_clr_set(vcpu, kvm, HFGRTR_EL2, r_clr, r_set);
> +	compute_undef_clr_set(vcpu, kvm, HFGWTR_EL2, w_clr, w_set);
> +
>  	/* The default to trap everything not handled or supported in KVM. */
>  	tmp = HFGxTR_EL2_nAMAIR2_EL1 | HFGxTR_EL2_nMAIR2_EL1 | HFGxTR_EL2_nS2POR_EL1 |
>  	      HFGxTR_EL2_nPOR_EL1 | HFGxTR_EL2_nPOR_EL0 | HFGxTR_EL2_nACCDATA_EL1;
> @@ -172,20 +210,26 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  	write_sysreg_s(r_val, SYS_HFGRTR_EL2);
>  	write_sysreg_s(w_val, SYS_HFGWTR_EL2);
>  
> -	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> -		return;
> -
> -	update_fgt_traps(vcpu, HFGITR_EL2);
> -	update_fgt_traps(vcpu, HDFGRTR_EL2);
> -	update_fgt_traps(vcpu, HDFGWTR_EL2);
> +	update_fgt_traps(hctxt, vcpu, kvm, HFGITR_EL2);
> +	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR_EL2);
> +	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR_EL2);
>  
>  	if (cpu_has_amu())
> -		update_fgt_traps(vcpu, HAFGRTR_EL2);
> +		update_fgt_traps(hctxt, vcpu, kvm, HAFGRTR_EL2);
>  }
>  
> +#define __deactivate_fgt(htcxt, vcpu, kvm, reg)				\
> +	do {								\
> +		if ((vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) ||	\
> +		    kvm->arch.fgu[reg_to_fgt_group_id(reg)])		\
> +			write_sysreg_s(ctxt_sys_reg(hctxt, reg),	\
> +				       SYS_ ## reg);			\
> +	} while(0)
> +
>  static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> +	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
>  
>  	if (!cpus_have_final_cap(ARM64_HAS_FGT))
>  		return;
> @@ -193,15 +237,12 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  	write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
>  	write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
>  
> -	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> -		return;
> -
> -	write_sysreg_s(ctxt_sys_reg(hctxt, HFGITR_EL2), SYS_HFGITR_EL2);
> -	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGRTR_EL2), SYS_HDFGRTR_EL2);
> -	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGWTR_EL2), SYS_HDFGWTR_EL2);
> +	__deactivate_fgt(hctxt, vcpu, kvm, HFGITR_EL2);
> +	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR_EL2);
> +	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR_EL2);
>  
>  	if (cpu_has_amu())
> -		write_sysreg_s(ctxt_sys_reg(hctxt, HAFGRTR_EL2), SYS_HAFGRTR_EL2);
> +		__deactivate_fgt(hctxt, vcpu, kvm, HAFGRTR_EL2);
>  }
>  
>  static inline void __activate_traps_common(struct kvm_vcpu *vcpu)

