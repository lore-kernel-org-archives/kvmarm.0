From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 2/3] arm64: Add hypervisor safe helper for checking
 constant capabilities
Date: Tue, 1 Nov 2016 14:03:59 +0000
Message-ID: <20161101140359.GF22791@arm.com>
References: <1477929825-5907-1-git-send-email-suzuki.poulose@arm.com>
 <1477929825-5907-3-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477929825-5907-3-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, catalin.marinas@arm.com, mark.rutland@arm.com, marc.zyngier@arm.com, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 31, 2016 at 04:03:44PM +0000, Suzuki K Poulose wrote:
> The hypervisor may not have full access to the kernel data structures
> and hence cannot safely use cpus_have_cap() helper for checking the
> system capability. Add a safe helper for hypervisors to check a constant
> system capability, which *doesn't* fall back to checking the bitmap
> maintained by the kernel.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/cpufeature.h | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 758d74f..ae5e994 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -9,8 +9,6 @@
>  #ifndef __ASM_CPUFEATURE_H
>  #define __ASM_CPUFEATURE_H
>  
> -#include <linux/jump_label.h>
> -
>  #include <asm/hwcap.h>
>  #include <asm/sysreg.h>
>  
> @@ -45,6 +43,8 @@
>  
>  #ifndef __ASSEMBLY__
>  
> +#include <linux/bug.h>
> +#include <linux/jump_label.h>
>  #include <linux/kernel.h>
>  
>  /* CPU feature register tracking */
> @@ -122,6 +122,16 @@ static inline bool cpu_have_feature(unsigned int num)
>  	return elf_hwcap & (1UL << num);
>  }
>  
> +/* System capability check for constant caps */
> +static inline bool cpus_have_const_cap(int num)
> +{
> +	if (__builtin_constant_p(num))
> +		return static_branch_unlikely(&cpu_hwcap_keys[num]);
> +	BUILD_BUG();

I think you'll already get a build failure if you pass a non-const num
to static_branch_unlikely, so this seems unnecessary. Furthermore, if
we're going to introduce a "const-only" version of this function, maybe
it's best to kill the __builtin_constant_p checks altogether, including
in the existing cpus_have_cap code? That way, the caller can make the
decision about whether or not they want to use static keys.

> +	/* unreachable */
> +	return false;
> +}
> +
>  static inline bool cpus_have_cap(unsigned int num)
>  {
>  	if (num >= ARM64_NCAPS)

It seems odd to check aginst ARM64_NCAPS here, but not in your new function.
Is the check actually necessary in either case? If so, we should probably
duplicate it for consistency.

Will
