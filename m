From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v1 05/16] arm64: Helper for parange to PASize
Date: Thu, 8 Feb 2018 12:00:42 +0100
Message-ID: <20180208110042.GH29286@cbox>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-6-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180109190414.4017-6-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 09, 2018 at 07:04:00PM +0000, Suzuki K Poulose wrote:
> Add a helper to convert ID_AA64MMFR0_EL1:PARange to they physical
                                                      *the*
> size shift. Limit the size to the maximum supported by the kernel.

Is this just a cleanup or are we actually going to need this feature in
the subsequent patches?  That would be nice to motivate in the commit
letter.

> 
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/cpufeature.h | 16 ++++++++++++++++
>  arch/arm64/kvm/hyp/s2-setup.c       | 28 +++++-----------------------
>  2 files changed, 21 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index ac67cfc2585a..0564e14616eb 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -304,6 +304,22 @@ static inline u64 read_zcr_features(void)
>  	return zcr;
>  }
>  
> +static inline u32 id_aa64mmfr0_parange_to_phys_shift(int parange)
> +{
> +	switch (parange) {
> +	case 0: return 32;
> +	case 1: return 36;
> +	case 2: return 40;
> +	case 3: return 42;
> +	case 4: return 44;
> +
> +	default:

What is the case we want to cater for with making parange == 5 the
default for unrecognized values?

(I have a feeling that default label comes from making the compiler
happy about potentially uninitialized values once upon a time before a
lot of refactoring happened here.)

> +	case 5: return 48;
> +#ifdef CONFIG_ARM64_PA_BITS_52
> +	case 6: return 52;
> +#endif
> +	}
> +}
>  #endif /* __ASSEMBLY__ */
>  
>  #endif
> diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
> index 603e1ee83e89..b1129c83c531 100644
> --- a/arch/arm64/kvm/hyp/s2-setup.c
> +++ b/arch/arm64/kvm/hyp/s2-setup.c
> @@ -19,11 +19,13 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_hyp.h>
> +#include <asm/cpufeature.h>
>  
>  u32 __hyp_text __init_stage2_translation(void)
>  {
>  	u64 val = VTCR_EL2_FLAGS;
>  	u64 parange;
> +	u32 phys_shift;
>  	u64 tmp;
>  
>  	/*
> @@ -37,27 +39,7 @@ u32 __hyp_text __init_stage2_translation(void)
>  	val |= parange << 16;
>  
>  	/* Compute the actual PARange... */
> -	switch (parange) {
> -	case 0:
> -		parange = 32;
> -		break;
> -	case 1:
> -		parange = 36;
> -		break;
> -	case 2:
> -		parange = 40;
> -		break;
> -	case 3:
> -		parange = 42;
> -		break;
> -	case 4:
> -		parange = 44;
> -		break;
> -	case 5:
> -	default:
> -		parange = 48;
> -		break;
> -	}
> +	phys_shift = id_aa64mmfr0_parange_to_phys_shift(parange);
>  
>  	/*
>  	 * ... and clamp it to 40 bits, unless we have some braindead
> @@ -65,7 +47,7 @@ u32 __hyp_text __init_stage2_translation(void)
>  	 * return that value for the rest of the kernel to decide what
>  	 * to do.
>  	 */
> -	val |= 64 - (parange > 40 ? 40 : parange);
> +	val |= 64 - (phys_shift > 40 ? 40 : phys_shift);
>  
>  	/*
>  	 * Check the availability of Hardware Access Flag / Dirty Bit
> @@ -86,5 +68,5 @@ u32 __hyp_text __init_stage2_translation(void)
>  
>  	write_sysreg(val, vtcr_el2);
>  
> -	return parange;
> +	return phys_shift;
>  }
> -- 
> 2.13.6
> 

Could you fold this change into the commit as well:

diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
index 603e1ee83e89..eea2fbd68b8a 100644
--- a/arch/arm64/kvm/hyp/s2-setup.c
+++ b/arch/arm64/kvm/hyp/s2-setup.c
@@ -29,7 +29,8 @@ u32 __hyp_text __init_stage2_translation(void)
 	/*
 	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS
 	 * bits in VTCR_EL2. Amusingly, the PARange is 4 bits, while
-	 * PS is only 3. Fortunately, bit 19 is RES0 in VTCR_EL2...
+	 * PS is only 3. Fortunately, only three bits is actually used to
+	 * enode the supported PARange values.
 	 */
 	parange = read_sysreg(id_aa64mmfr0_el1) & 7;
 	if (parange > ID_AA64MMFR0_PARANGE_MAX)


Thanks,
-Christoffer
