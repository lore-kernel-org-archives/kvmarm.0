From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v1 1/4] KVM: arm64: Use macro to replace hard number
Date: Fri, 22 Feb 2019 11:40:13 +0000
Message-ID: <20190222114013.GB42419@lakrids.cambridge.arm.com>
References: <20190222082327.3312-1-leo.yan@linaro.org>
 <20190222082327.3312-2-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190222082327.3312-2-leo.yan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Leo Yan <leo.yan@linaro.org>
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Andre Przywara <andre.przywara@arm.com>, Jun Yao <yaojun8558363@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 22, 2019 at 04:23:23PM +0800, Leo Yan wrote:
> Use macro for ID_AA64MMFR1_EL1.VH bits shift instead of 8 directly.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>

It's always nice to get rid of magic numbers, and this is correct
AFAICT. FWIW:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kernel/head.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 4471f570a295..3ac377e9fd28 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -490,7 +490,7 @@ ENTRY(el2_setup)
>  	 * kernel is intended to run at EL2.
>  	 */
>  	mrs	x2, id_aa64mmfr1_el1
> -	ubfx	x2, x2, #8, #4
> +	ubfx	x2, x2, #ID_AA64MMFR1_VHE_SHIFT, #4
>  #else
>  	mov	x2, xzr
>  #endif
> -- 
> 2.17.1
> 
