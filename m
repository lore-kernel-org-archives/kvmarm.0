From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 03/28] arm64: efi: Add missing Kconfig dependency on
 KERNEL_MODE_NEON
Date: Wed, 11 Oct 2017 15:16:47 +0100
Message-ID: <20171011141647.gh24vjwgc6vvrtoy@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-4-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-4-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:20PM +0100, Dave P Martin wrote:
> The EFI runtime services ABI permits calls to EFI to clobber
> certain FPSIMD/NEON registers, as per the AArch64 procedure call
> standard.
> 
> Saving/restoring the clobbered registers around such calls needs
> KERNEL_MODE_NEON, but the dependency is missing from Kconfig.
> 
> This patch adds the missing dependency.
> 
> This will aid bisection of the patches implementing support for the
> ARM Scalable Vector Extension (SVE).
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  arch/arm64/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 0df64a6..ca711ac 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1063,6 +1063,7 @@ config EFI_STUB
>  config EFI
>  	bool "UEFI runtime support"
>  	depends on OF && !CPU_BIG_ENDIAN
> +	depends on KERNEL_MODE_NEON
>  	select LIBFDT
>  	select UCS2_STRING
>  	select EFI_PARAMS_FROM_FDT

We could've used select KERNEL_MODE_NEON since it's a feature needed by
EFI but this works for me as well as KERNEL_MODE_NEON is def_bool y
already. Either way:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
