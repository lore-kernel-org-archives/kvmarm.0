From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v1 3/4] KVM: arm/arm64: Define TCR_EL2_T0SZ_MASK as
 TCR_T0SZ_MASK
Date: Fri, 22 Feb 2019 11:43:49 +0000
Message-ID: <20190222114348.GC42419@lakrids.cambridge.arm.com>
References: <20190222082327.3312-1-leo.yan@linaro.org>
 <20190222082327.3312-4-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190222082327.3312-4-leo.yan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Leo Yan <leo.yan@linaro.org>
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Andre Przywara <andre.przywara@arm.com>, Jun Yao <yaojun8558363@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 22, 2019 at 04:23:25PM +0800, Leo Yan wrote:
> Define macro TCR_EL2_T0SZ_MASK as TCR_T0SZ_MASK, so can remove the hard
> number 0x3f.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>

Given we do this for the other TCR fields, and the value is correct
AFAICT, this makes sense to me. FWIW:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/include/asm/kvm_arm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 6f602af5263c..d945a787f36e 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -99,7 +99,7 @@
>  #define TCR_EL2_SH0_MASK	TCR_SH0_MASK
>  #define TCR_EL2_ORGN0_MASK	TCR_ORGN0_MASK
>  #define TCR_EL2_IRGN0_MASK	TCR_IRGN0_MASK
> -#define TCR_EL2_T0SZ_MASK	0x3f
> +#define TCR_EL2_T0SZ_MASK	TCR_T0SZ_MASK
>  #define TCR_EL2_MASK	(TCR_EL2_TG0_MASK | TCR_EL2_SH0_MASK | \
>  			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK | TCR_EL2_T0SZ_MASK)
>  
> -- 
> 2.17.1
> 
