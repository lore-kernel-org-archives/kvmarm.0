From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 2/2] arm64: Support systems without FP/ASIMD
Date: Mon, 14 Nov 2016 11:48:58 +0000
Message-ID: <20161114114858.GB3096@e104818-lin.cambridge.arm.com>
References: <1478613381-5718-1-git-send-email-suzuki.poulose@arm.com>
 <1478613381-5718-3-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEE5E40460
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2016 06:48:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 65IV24d8loBQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Nov 2016 06:48:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EBB6402EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2016 06:48:34 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1478613381-5718-3-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On Tue, Nov 08, 2016 at 01:56:21PM +0000, Suzuki K. Poulose wrote:
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index 87b4465..4174f09 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -34,7 +34,8 @@
>  #define ARM64_HAS_32BIT_EL0			13
>  #define ARM64_HYP_OFFSET_LOW			14
>  #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
> +#define ARM64_HAS_NO_FPSIMD			16
>  
> -#define ARM64_NCAPS				16
> +#define ARM64_NCAPS				17
>  
>  #endif /* __ASM_CPUCAPS_H */
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 9890d20..ce45770 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -213,6 +213,11 @@ static inline bool system_supports_mixed_endian_el0(void)
>  	return id_aa64mmfr0_mixed_endian_el0(read_system_reg(SYS_ID_AA64MMFR0_EL1));
>  }
>  
> +static inline bool system_supports_fpsimd(void)
> +{
> +	return !cpus_have_const_cap(ARM64_HAS_NO_FPSIMD);
> +}

Any particular reason why using negation instead of a ARM64_HAS_FPSIMD?
A potential problem would be the default cpus_have_const_cap()
implementation and the default static key having a slight performance
impact.

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index fc2bd19..f89385d 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -746,6 +746,14 @@ static bool hyp_offset_low(const struct arm64_cpu_capabilities *entry,
>  	return idmap_addr > GENMASK(VA_BITS - 2, 0) && !is_kernel_in_hyp_mode();
>  }
>  
> +static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unused)
> +{
> +	u64 pfr0 = read_system_reg(SYS_ID_AA64PFR0_EL1);
> +
> +	return cpuid_feature_extract_signed_field(pfr0,
> +					ID_AA64PFR0_FP_SHIFT) < 0;
> +}
> +
>  static const struct arm64_cpu_capabilities arm64_features[] = {
>  	{
>  		.desc = "GIC system register CPU interface",
> @@ -829,6 +837,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.def_scope = SCOPE_SYSTEM,
>  		.matches = hyp_offset_low,
>  	},
> +	{
> +		/* FP/SIMD is not implemented */
> +		.capability = ARM64_HAS_NO_FPSIMD,
> +		.def_scope = SCOPE_SYSTEM,
> +		.min_field_value = 0,
> +		.matches = has_no_fpsimd,
> +	},

If we go for negation, I don't think we need a min_field_value at all,
the matching is done by the has_no_fpsimd() function.

-- 
Catalin
