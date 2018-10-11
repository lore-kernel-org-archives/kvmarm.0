From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v5 01/17] arm64: add pointer authentication register bits
Date: Thu, 11 Oct 2018 17:28:14 +0100
Message-ID: <20181011162814.GC17000@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-2-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181005084754.20950-2-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 05, 2018 at 09:47:38AM +0100, Kristina Martsenko wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> The ARMv8.3 pointer authentication extension adds:
> 
> * New fields in ID_AA64ISAR1 to report the presence of pointer
>   authentication functionality.
> 
> * New control bits in SCTLR_ELx to enable this functionality.
> 
> * New system registers to hold the keys necessary for this
>   functionality.
> 
> * A new ESR_ELx.EC code used when the new instructions are affected by
>   configurable traps
> 
> This patch adds the relevant definitions to <asm/sysreg.h> and
> <asm/esr.h> for these, to be used by subsequent patches.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/esr.h    |  3 ++-
>  arch/arm64/include/asm/sysreg.h | 30 ++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index ce70c3ffb993..022785162281 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -30,7 +30,8 @@
>  #define ESR_ELx_EC_CP14_LS	(0x06)
>  #define ESR_ELx_EC_FP_ASIMD	(0x07)
>  #define ESR_ELx_EC_CP10_ID	(0x08)
> -/* Unallocated EC: 0x09 - 0x0B */
> +#define ESR_ELx_EC_PAC		(0x09)

Really minor nit: but shouldn't this be ESR_EL2_EC_PAC, since this trap
can't occur at EL1 afaict?

Rest of the patch looks good:

Reviewed-by: Will Deacon <will.deacon@arm.com>

Will
