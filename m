From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Wed, 28 Feb 2018 17:48:26 +0000
Message-ID: <20180228174826.dgfxu75iqq2y3qsr@lakrids.cambridge.arm.com>
References: <1519474193-25973-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1519474193-25973-1-git-send-email-shankerd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>, Robin Murphy <robin.murphy@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Vikram Sethi <vikrams@codeaurora.org>, Philip Elcan <pelcan@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Sat, Feb 24, 2018 at 06:09:53AM -0600, Shanker Donthineni wrote:
> +config ARM64_SKIP_CACHE_POU
> +	bool "Enable support to skip cache POU operations"

Nit: s/POU/PoU/ in text

> +	default y
> +	help
> +	  Explicit point of unification cache operations can be eliminated
> +	  in software if the hardware handles transparently. The new bits in
> +	  CTR_EL0, CTR_EL0.DIC and CTR_EL0.IDC indicates the hardware
> +	  capabilities of ICache and DCache POU requirements.

Likewise, s/POU/PoU/.

> +
> +	  Selecting this feature will allow the kernel to optimize the POU
> +	  cache maintaince operations where it requires 'D{I}C C{I}VAU'

The instruction expansion here is a bit odd. It'd probably be best to
just say:

  Selecting this feature will allow the kernel to optimize cache
  maintenance to the PoU.

[...]

> diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
> index ea9bb4e..e22178b 100644
> --- a/arch/arm64/include/asm/cache.h
> +++ b/arch/arm64/include/asm/cache.h
> @@ -20,8 +20,13 @@
>  
>  #define CTR_L1IP_SHIFT		14
>  #define CTR_L1IP_MASK		3
> +#define CTR_DMLINE_SHIFT	16
> +#define CTR_ERG_SHIFT		20
>  #define CTR_CWG_SHIFT		24
>  #define CTR_CWG_MASK		15
> +#define CTR_IDC_SHIFT		28
> +#define CTR_DIC_SHIFT		29
> +#define CTR_B31_SHIFT		31

I think the CTR_B31_SHIFT define is gratuitous...

[...]

>  static const struct arm64_ftr_bits ftr_ctr[] = {
> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1),		/* RES1 */

... and we can/should leave this line as-is.

> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 29, 1, 1),	/* DIC */
> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 28, 1, 1),	/* IDC */
> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, 24, 4, 0),	/* CWG */
> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, 20, 4, 0),	/* ERG */
> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 16, 4, 1),	/* DminLine */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, CTR_B31_SHIFT, 1, 1),         /* RES1 */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DIC_SHIFT, 1, 1),    /* DIC */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_IDC_SHIFT, 1, 1),    /* IDC */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, CTR_CWG_SHIFT, 4, 0),   /* CWG */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, CTR_ERG_SHIFT, 4, 0),   /* ERG */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DMLINE_SHIFT, 4, 1), /* DminLine */

... though the other changes are fine by me.

[...]


> +static bool has_cache_idc(const struct arm64_cpu_capabilities *entry,
> +			  int __unused)
> +{
> +	return (read_sanitised_ftr_reg(SYS_CTR_EL0) & (1UL << CTR_IDC_SHIFT));
> +}

This can be:

	return read_sanitised_ftr_reg(SYS_CTR_EL0) & BIT(CTR_IDC_SHIFT);

> +static bool has_cache_dic(const struct arm64_cpu_capabilities *entry,
> +			  int __unused)
> +{
> +	return (read_sanitised_ftr_reg(SYS_CTR_EL0) & (1UL << CTR_DIC_SHIFT));
> +}

Likewise:

	return read_sanitised_ftr_reg(SYS_CTR_EL0) & BIT(CTR_DIC_SHIFT);

Otherwise, this looks good to me.

Thanks,
Mark.
