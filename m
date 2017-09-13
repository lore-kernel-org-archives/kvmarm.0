From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 06/28] arm64/sve: System register and exception syndrome definitions
Date: Wed, 13 Sep 2017 15:48:59 +0100
Message-ID: <87o9qeac2s.fsf@linaro.org>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com> <1504198860-12951-7-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-reply-to: <1504198860-12951-7-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


Dave Martin <Dave.Martin@arm.com> writes:

> The SVE architecture adds some system registers, ID register fields
> and a dedicated ESR exception class.
>
> This patch adds the appropriate definitions that will be needed by
> the kernel.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Alex Bennée <alex.bennee@linaro.org>

Reviewed-by: Alex Bennée <alex.bennee@linaro.org>

>
> ---
>
> Changes since v1
> ----------------
>
> Requested by Alex Bennée:
>
> * Add comments to clarify CPACR_EL1_ZEN_ELxEN bit meanings.
> * Add comment clarifying the status of the LEN field expansion bits.
> ---
>  arch/arm64/include/asm/esr.h     |  3 ++-
>  arch/arm64/include/asm/kvm_arm.h |  1 +
>  arch/arm64/include/asm/sysreg.h  | 21 +++++++++++++++++++++
>  arch/arm64/kernel/traps.c        |  1 +
>  4 files changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 66ed8b6..014d7d8 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -43,7 +43,8 @@
>  #define ESR_ELx_EC_HVC64	(0x16)
>  #define ESR_ELx_EC_SMC64	(0x17)
>  #define ESR_ELx_EC_SYS64	(0x18)
> -/* Unallocated EC: 0x19 - 0x1E */
> +#define ESR_ELx_EC_SVE		(0x19)
> +/* Unallocated EC: 0x1A - 0x1E */
>  #define ESR_ELx_EC_IMP_DEF	(0x1f)
>  #define ESR_ELx_EC_IABT_LOW	(0x20)
>  #define ESR_ELx_EC_IABT_CUR	(0x21)
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 61d694c..dbf0537 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -185,6 +185,7 @@
>  #define CPTR_EL2_TCPAC	(1 << 31)
>  #define CPTR_EL2_TTA	(1 << 20)
>  #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
> +#define CPTR_EL2_TZ	(1 << 8)
>  #define CPTR_EL2_DEFAULT	0x000033ff
>
>  /* Hyp Debug Configuration Register bits */
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 480ecd6..36fe2ae 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -145,6 +145,7 @@
>
>  #define SYS_ID_AA64PFR0_EL1		sys_reg(3, 0, 0, 4, 0)
>  #define SYS_ID_AA64PFR1_EL1		sys_reg(3, 0, 0, 4, 1)
> +#define SYS_ID_AA64ZFR0_EL1		sys_reg(3, 0, 0, 4, 4)
>
>  #define SYS_ID_AA64DFR0_EL1		sys_reg(3, 0, 0, 5, 0)
>  #define SYS_ID_AA64DFR1_EL1		sys_reg(3, 0, 0, 5, 1)
> @@ -163,6 +164,8 @@
>  #define SYS_ACTLR_EL1			sys_reg(3, 0, 1, 0, 1)
>  #define SYS_CPACR_EL1			sys_reg(3, 0, 1, 0, 2)
>
> +#define SYS_ZCR_EL1			sys_reg(3, 0, 1, 2, 0)
> +
>  #define SYS_TTBR0_EL1			sys_reg(3, 0, 2, 0, 0)
>  #define SYS_TTBR1_EL1			sys_reg(3, 0, 2, 0, 1)
>  #define SYS_TCR_EL1			sys_reg(3, 0, 2, 0, 2)
> @@ -253,6 +256,8 @@
>
>  #define SYS_PMCCFILTR_EL0		sys_reg (3, 3, 14, 15, 7)
>
> +#define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
> +
>  #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
>  #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
>  #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
> @@ -335,6 +340,7 @@
>  #define ID_AA64ISAR1_DPB_SHIFT		0
>
>  /* id_aa64pfr0 */
> +#define ID_AA64PFR0_SVE_SHIFT		32
>  #define ID_AA64PFR0_GIC_SHIFT		24
>  #define ID_AA64PFR0_ASIMD_SHIFT		20
>  #define ID_AA64PFR0_FP_SHIFT		16
> @@ -343,6 +349,7 @@
>  #define ID_AA64PFR0_EL1_SHIFT		4
>  #define ID_AA64PFR0_EL0_SHIFT		0
>
> +#define ID_AA64PFR0_SVE			0x1
>  #define ID_AA64PFR0_FP_NI		0xf
>  #define ID_AA64PFR0_FP_SUPPORTED	0x0
>  #define ID_AA64PFR0_ASIMD_NI		0xf
> @@ -444,6 +451,20 @@
>  #endif
>
>
> +/*
> + * The ZCR_ELx_LEN_* definitions intentionally include bits [8:4] which
> + * are reserved by the SVE architecture for future expansion of the LEN
> + * field, with compatible semantics.
> + */
> +#define ZCR_ELx_LEN_SHIFT	0
> +#define ZCR_ELx_LEN_SIZE	9
> +#define ZCR_ELx_LEN_MASK	0x1ff
> +
> +#define CPACR_EL1_ZEN_EL1EN	(1 << 16) /* enable EL1 access */
> +#define CPACR_EL1_ZEN_EL0EN	(1 << 17) /* enable EL0 access, if EL1EN set */
> +#define CPACR_EL1_ZEN		(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
> +
> +
>  /* Safe value for MPIDR_EL1: Bit31:RES1, Bit30:U:0, Bit24:MT:0 */
>  #define SYS_MPIDR_SAFE_VAL		(1UL << 31)
>
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 5ea4b85..f202932 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -603,6 +603,7 @@ static const char *esr_class_str[] = {
>  	[ESR_ELx_EC_HVC64]		= "HVC (AArch64)",
>  	[ESR_ELx_EC_SMC64]		= "SMC (AArch64)",
>  	[ESR_ELx_EC_SYS64]		= "MSR/MRS (AArch64)",
> +	[ESR_ELx_EC_SVE]		= "SVE",
>  	[ESR_ELx_EC_IMP_DEF]		= "EL3 IMP DEF",
>  	[ESR_ELx_EC_IABT_LOW]		= "IABT (lower EL)",
>  	[ESR_ELx_EC_IABT_CUR]		= "IABT (current EL)",
