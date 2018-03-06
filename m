From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v6] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Tue, 6 Mar 2018 13:52:06 +0000
Message-ID: <902fc09f-d226-f039-5fce-52cc4341e0fd@arm.com>
References: <1519877640-11944-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519877640-11944-1-git-send-email-shankerd@codeaurora.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Shanker Donthineni <shankerd@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vikram Sethi <vikrams@codeaurora.org>, Philip Elcan <pelcan@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/03/18 04:14, Shanker Donthineni wrote:
[...]
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 2985a06..0b64b55 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -199,12 +199,12 @@ static int __init register_cpu_hwcaps_dumper(void)
>   };
>   
>   static const struct arm64_ftr_bits ftr_ctr[] = {
> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1),		/* RES1 */

Nit: you may as well leave this line as-is...

> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 29, 1, 1),	/* DIC */
> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 28, 1, 1),	/* IDC */
> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, 24, 4, 0),	/* CWG */
> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, 20, 4, 0),	/* ERG */
> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 16, 4, 1),	/* DminLine */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1),                    /* RES1 */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DIC_SHIFT, 1, 1),    /* DIC */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_IDC_SHIFT, 1, 1),    /* IDC */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, CTR_CWG_SHIFT, 4, 0),   /* CWG */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, CTR_ERG_SHIFT, 4, 0),   /* ERG */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DMLINE_SHIFT, 4, 1), /* DminLine */

...because with properly-named macros the rest of these comments no 
longer add anything that isn't already obvious - best to just remove them.

Robin.
