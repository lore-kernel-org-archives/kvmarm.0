From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 08/27] arm64/sve: Kconfig update and conditional compilation support
Date: Mon, 21 Aug 2017 11:12:36 +0100
Message-ID: <877exx5iwb.fsf@linaro.org>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com> <1502280338-23002-9-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-reply-to: <1502280338-23002-9-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


Dave Martin <Dave.Martin@arm.com> writes:

> This patch adds CONFIG_ARM64_SVE to control building of SVE support
> into the kernel, and adds a stub predicate system_supports_sve() to
> control conditional compilation and runtime SVE support.
>
> system_supports_sve() just returns false for now: it will be
> replaced with a non-trivial implementation in a later patch, once
> SVE support is complete enough to be enabled safely.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Reviewed-by: Alex Bennée <alex.bennee@linaro.org>

> ---
>  arch/arm64/Kconfig                  | 11 +++++++++++
>  arch/arm64/include/asm/cpufeature.h |  5 +++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index fdc302e..fbf7a5c 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -962,6 +962,17 @@ config ARM64_UAO
>
>  endmenu
>
> +config ARM64_SVE
> +	bool "ARM Scalable Vector Extension support"
> +	default y
> +	help
> +	  The Scalable Vector Extension (SVE) is an extension to the AArch64
> +	  execution state which complements and extends the SIMD functionality
> +	  of the base architecture to support much larger vectors and to enable
> +	  additional vectorisation opportunities.
> +
> +	  To enable use of this extension on CPUs that implement it, say Y.
> +
>  config ARM64_MODULE_CMODEL_LARGE
>  	bool
>
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 428ee1f..4ea3441 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -262,6 +262,11 @@ static inline bool system_uses_ttbr0_pan(void)
>  		!cpus_have_const_cap(ARM64_HAS_PAN);
>  }
>
> +static inline bool system_supports_sve(void)
> +{
> +	return false;
> +}
> +
>  #endif /* __ASSEMBLY__ */
>
>  #endif
