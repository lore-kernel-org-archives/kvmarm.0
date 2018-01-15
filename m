From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 09/19] arm64: cpufeatures: Drop the
 ARM64_HYP_OFFSET_LOW feature flag
Date: Mon, 15 Jan 2018 12:48:27 +0100
Message-ID: <20180115114827.GJ21403@cbox>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-10-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180104184334.16571-10-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 04, 2018 at 06:43:24PM +0000, Marc Zyngier wrote:
> Now that we can dynamically compute the kernek/hyp VA mask, there

nit: s/kernek/kernel/

> is need for a feature flag to trigger the alternative patching.

is *no* need?

> Let's drop the flag and everything that depends on it.

Otherwise:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/cpucaps.h |  2 +-
>  arch/arm64/kernel/cpufeature.c   | 19 -------------------
>  2 files changed, 1 insertion(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index 2ff7c5e8efab..f130f35dca3c 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -32,7 +32,7 @@
>  #define ARM64_HAS_VIRT_HOST_EXTN		11
>  #define ARM64_WORKAROUND_CAVIUM_27456		12
>  #define ARM64_HAS_32BIT_EL0			13
> -#define ARM64_HYP_OFFSET_LOW			14
> +/* #define ARM64_UNALLOCATED_ENTRY			14 */
>  #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
>  #define ARM64_HAS_NO_FPSIMD			16
>  #define ARM64_WORKAROUND_REPEAT_TLBI		17
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index a73a5928f09b..b99f8b1688c3 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -825,19 +825,6 @@ static bool runs_at_el2(const struct arm64_cpu_capabilities *entry, int __unused
>  	return is_kernel_in_hyp_mode();
>  }
>  
> -static bool hyp_offset_low(const struct arm64_cpu_capabilities *entry,
> -			   int __unused)
> -{
> -	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
> -
> -	/*
> -	 * Activate the lower HYP offset only if:
> -	 * - the idmap doesn't clash with it,
> -	 * - the kernel is not running at EL2.
> -	 */
> -	return idmap_addr > GENMASK(VA_BITS - 2, 0) && !is_kernel_in_hyp_mode();
> -}
> -
>  static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unused)
>  {
>  	u64 pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> @@ -926,12 +913,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.field_pos = ID_AA64PFR0_EL0_SHIFT,
>  		.min_field_value = ID_AA64PFR0_EL0_32BIT_64BIT,
>  	},
> -	{
> -		.desc = "Reduced HYP mapping offset",
> -		.capability = ARM64_HYP_OFFSET_LOW,
> -		.def_scope = SCOPE_SYSTEM,
> -		.matches = hyp_offset_low,
> -	},
>  	{
>  		/* FP/SIMD is not implemented */
>  		.capability = ARM64_HAS_NO_FPSIMD,
> -- 
> 2.14.2
> 
