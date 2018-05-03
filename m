From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 05/17] arm64: Helper for parange to PASize
Date: Thu, 3 May 2018 15:39:20 +0100
Message-ID: <b44930d9-b25d-acd4-9676-6f779e2c590a@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
 <1522156531-28348-6-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-6-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

Nit: KVM in the subject line?

On 27/03/18 14:15, Suzuki K Poulose wrote:
> Add a helper to convert ID_AA64MMFR0_EL1:PARange to they physical
> size shift. Limit the size to the maximum supported by the kernel.
> We are about to move the user of this code and this helps to
> keep the changes cleaner.

> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index fbf0aab..1f2a5dd 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -311,6 +311,22 @@ static inline u64 read_zcr_features(void)
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
> +	/* Report 48 bit if the kernel doesn't support 52bit */
> +	default:
> +	case 5: return 48;
> +#ifdef CONFIG_ARM64_PA_BITS_52
> +	case 6: return 52;
> +#endif

Eeew. I thought 'default' had to appear at the end of the list, but evidently
not! If the last three bit value ever gets used this is going to look really weird.

Can't we have a helper that just does the mapping, then apply the clamping with
something like:
| parange = min(CONFIG_ARM64_PA_BITS, parange);


Its odd that the helper has the id-register in the name, but expects you do the
shift and mask for it...

(and for this patch, KVM has already done the 52bit clamping with:
| 	if (parange > ID_AA64MMFR0_PARANGE_MAX)
|		parange = ID_AA64MMFR0_PARANGE_MAX;
)


> diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
> index 603e1ee..b1129c8 100644
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

Nit: Why change the variable you put this in, if its all removed again in patch 11?


Thanks,

James
