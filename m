From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 06/27] arm64/sve: System register and exception syndrome definitions
Date: Mon, 21 Aug 2017 13:34:38 +0100
Message-ID: <8760dh5cbl.fsf@linaro.org>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com> <1502280338-23002-7-git-send-email-Dave.Martin@arm.com> <87a82t5kos.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-reply-to: <87a82t5kos.fsf@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


Alex Bennée <alex.bennee@linaro.org> writes:

> Dave Martin <Dave.Martin@arm.com> writes:
>
>> The SVE architecture adds some system registers, ID register fields
>> and a dedicated ESR exception class.
>>
>> This patch adds the appropriate definitions that will be needed by
>> the kernel.
>>
>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>> ---
>>  arch/arm64/include/asm/esr.h     |  3 ++-
>>  arch/arm64/include/asm/kvm_arm.h |  1 +
>>  arch/arm64/include/asm/sysreg.h  | 16 ++++++++++++++++
>>  arch/arm64/kernel/traps.c        |  1 +
>>  4 files changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
>> index 8cabd57..813629e 100644
>> --- a/arch/arm64/include/asm/esr.h
>> +++ b/arch/arm64/include/asm/esr.h
>> @@ -43,7 +43,8 @@
>>  #define ESR_ELx_EC_HVC64	(0x16)
>>  #define ESR_ELx_EC_SMC64	(0x17)
>>  #define ESR_ELx_EC_SYS64	(0x18)
>> -/* Unallocated EC: 0x19 - 0x1E */
>> +#define ESR_ELx_EC_SVE		(0x19)
>> +/* Unallocated EC: 0x1A - 0x1E */
>>  #define ESR_ELx_EC_IMP_DEF	(0x1f)
>>  #define ESR_ELx_EC_IABT_LOW	(0x20)
>>  #define ESR_ELx_EC_IABT_CUR	(0x21)
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index 61d694c..dbf0537 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -185,6 +185,7 @@
>>  #define CPTR_EL2_TCPAC	(1 << 31)
>>  #define CPTR_EL2_TTA	(1 << 20)
>>  #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
>> +#define CPTR_EL2_TZ	(1 << 8)
>>  #define CPTR_EL2_DEFAULT	0x000033ff
>>
>>  /* Hyp Debug Configuration Register bits */
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index 248339e..2d259e8 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -145,6 +145,7 @@
>>
>>  #define SYS_ID_AA64PFR0_EL1		sys_reg(3, 0, 0, 4, 0)
>>  #define SYS_ID_AA64PFR1_EL1		sys_reg(3, 0, 0, 4, 1)
>> +#define SYS_ID_AA64ZFR0_EL1		sys_reg(3, 0, 0, 4, 4)
>>
>>  #define SYS_ID_AA64DFR0_EL1		sys_reg(3, 0, 0, 5, 0)
>>  #define SYS_ID_AA64DFR1_EL1		sys_reg(3, 0, 0, 5, 1)
>> @@ -160,6 +161,8 @@
>>  #define SYS_ACTLR_EL1			sys_reg(3, 0, 1, 0, 1)
>>  #define SYS_CPACR_EL1			sys_reg(3, 0, 1, 0, 2)
>>
>> +#define SYS_ZCR_EL1			sys_reg(3, 0, 1, 2, 0)
>> +
>
> I'll have to take these on trust. They are mentioned in both the ARM ARM
> and the SVE supplement but I can't see any actual definitions of them.
>
>>  #define SYS_TTBR0_EL1			sys_reg(3, 0, 2, 0, 0)
>>  #define SYS_TTBR1_EL1			sys_reg(3, 0, 2, 0, 1)
>>  #define SYS_TCR_EL1			sys_reg(3, 0, 2, 0, 2)
>> @@ -250,6 +253,8 @@
>>
>>  #define SYS_PMCCFILTR_EL0		sys_reg (3, 3, 14, 15, 7)
>>
>> +#define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
>> +

OK no I'm working directly from the unpacked ZIP file with the rest of
the details I think this should be:

  #define SYS_ZCR_EL2			sys_reg(3, 5, 1, 2, 0)

e.g. op1 = 101 / 5

>>  #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
>>  #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
>>  #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
>> @@ -331,6 +336,7 @@
>>  #define ID_AA64ISAR1_JSCVT_SHIFT	12
>>
>>  /* id_aa64pfr0 */
>> +#define ID_AA64PFR0_SVE_SHIFT		32
>>  #define ID_AA64PFR0_GIC_SHIFT		24
>>  #define ID_AA64PFR0_ASIMD_SHIFT		20
>>  #define ID_AA64PFR0_FP_SHIFT		16
>> @@ -339,6 +345,7 @@
>>  #define ID_AA64PFR0_EL1_SHIFT		4
>>  #define ID_AA64PFR0_EL0_SHIFT		0
>>
>> +#define ID_AA64PFR0_SVE			0x1
>>  #define ID_AA64PFR0_FP_NI		0xf
>>  #define ID_AA64PFR0_FP_SUPPORTED	0x0
>>  #define ID_AA64PFR0_ASIMD_NI		0xf
>> @@ -440,6 +447,15 @@
>>  #endif
>>
>>
>> +#define ZCR_ELx_LEN_SHIFT	0
>> +#define ZCR_ELx_LEN_SIZE	9
>> +#define ZCR_ELx_LEN_MASK	0x1ff
>> +

LEN should be 0/4/0xf

LEN, bits [3:0]

Constrains the scalable vector register length for EL1 and EL0 to (LEN+1)x128 bits.


>> +#define CPACR_EL1_ZEN_EL1EN	(1 << 16)
>> +#define CPACR_EL1_ZEN_EL0EN	(1 << 17)
>> +#define CPACR_EL1_ZEN		(CPACR_EL1_ZEN_EL1EN |
>> CPACR_EL1_ZEN_EL0EN)
>
> This is a little weird as it is a 2 bit field in which 00 and 11 are not
> simply the sum of their bits. If the code wrote CPACR_EL1_ZEN_EL0EN |
> CPACR_EL1_ZEN_EL1EN to the CPACR_EL1 you wouldn't get the expected behaviour.
>
>> +
>> +
>>  /* Safe value for MPIDR_EL1: Bit31:RES1, Bit30:U:0, Bit24:MT:0 */
>>  #define SYS_MPIDR_SAFE_VAL		(1UL << 31)
>>
>> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
>> index 0f047e9..8964795 100644
>> --- a/arch/arm64/kernel/traps.c
>> +++ b/arch/arm64/kernel/traps.c
>> @@ -621,6 +621,7 @@ static const char *esr_class_str[] = {
>>  	[ESR_ELx_EC_HVC64]		= "HVC (AArch64)",
>>  	[ESR_ELx_EC_SMC64]		= "SMC (AArch64)",
>>  	[ESR_ELx_EC_SYS64]		= "MSR/MRS (AArch64)",
>> +	[ESR_ELx_EC_SVE]		= "SVE",
>>  	[ESR_ELx_EC_IMP_DEF]		= "EL3 IMP DEF",
>>  	[ESR_ELx_EC_IABT_LOW]		= "IABT (lower EL)",
>>  	[ESR_ELx_EC_IABT_CUR]		= "IABT (current EL)",
