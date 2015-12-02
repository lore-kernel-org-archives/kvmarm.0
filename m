From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 19/21] arm64: KVM: Turn system register numbers to
 an enum
Date: Wed, 02 Dec 2015 15:26:28 +0000
Message-ID: <565F0DA4.8040604@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com> <1448650215-15218-20-git-send-email-marc.zyngier@arm.com> <20151202115121.GE18376@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151202115121.GE18376@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 02/12/15 11:51, Christoffer Dall wrote:
> On Fri, Nov 27, 2015 at 06:50:13PM +0000, Marc Zyngier wrote:
>> Having the system register numbers as #defines has been a pain
>> since day one, as the ordering is pretty fragile, and moving
>> things around leads to renumbering and epic conflict resolutions.
>>
>> Now that we're mostly acessing the sysreg file in C, an enum is
>> a much better type to use, and we can clean things up a bit.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_asm.h     | 76 ---------------------------------
>>  arch/arm64/include/asm/kvm_emulate.h |  1 -
>>  arch/arm64/include/asm/kvm_host.h    | 81 +++++++++++++++++++++++++++++++++++-
>>  arch/arm64/include/asm/kvm_mmio.h    |  1 -
>>  arch/arm64/kernel/asm-offsets.c      |  1 +
>>  arch/arm64/kvm/guest.c               |  1 -
>>  arch/arm64/kvm/handle_exit.c         |  1 +
>>  arch/arm64/kvm/hyp/debug-sr.c        |  1 +
>>  arch/arm64/kvm/hyp/entry.S           |  3 +-
>>  arch/arm64/kvm/hyp/sysreg-sr.c       |  1 +
>>  arch/arm64/kvm/sys_regs.c            |  1 +
>>  virt/kvm/arm/vgic-v3.c               |  1 +
>>  12 files changed, 87 insertions(+), 82 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>> index 5e37710..52b777b 100644
>> --- a/arch/arm64/include/asm/kvm_asm.h
>> +++ b/arch/arm64/include/asm/kvm_asm.h
>> @@ -20,82 +20,6 @@
>>  
>>  #include <asm/virt.h>
>>  
>> -/*
>> - * 0 is reserved as an invalid value.
>> - * Order *must* be kept in sync with the hyp switch code.
>> - */
>> -#define	MPIDR_EL1	1	/* MultiProcessor Affinity Register */
>> -#define	CSSELR_EL1	2	/* Cache Size Selection Register */
>> -#define	SCTLR_EL1	3	/* System Control Register */
>> -#define	ACTLR_EL1	4	/* Auxiliary Control Register */
>> -#define	CPACR_EL1	5	/* Coprocessor Access Control */
>> -#define	TTBR0_EL1	6	/* Translation Table Base Register 0 */
>> -#define	TTBR1_EL1	7	/* Translation Table Base Register 1 */
>> -#define	TCR_EL1		8	/* Translation Control Register */
>> -#define	ESR_EL1		9	/* Exception Syndrome Register */
>> -#define	AFSR0_EL1	10	/* Auxilary Fault Status Register 0 */
>> -#define	AFSR1_EL1	11	/* Auxilary Fault Status Register 1 */
>> -#define	FAR_EL1		12	/* Fault Address Register */
>> -#define	MAIR_EL1	13	/* Memory Attribute Indirection Register */
>> -#define	VBAR_EL1	14	/* Vector Base Address Register */
>> -#define	CONTEXTIDR_EL1	15	/* Context ID Register */
>> -#define	TPIDR_EL0	16	/* Thread ID, User R/W */
>> -#define	TPIDRRO_EL0	17	/* Thread ID, User R/O */
>> -#define	TPIDR_EL1	18	/* Thread ID, Privileged */
>> -#define	AMAIR_EL1	19	/* Aux Memory Attribute Indirection Register */
>> -#define	CNTKCTL_EL1	20	/* Timer Control Register (EL1) */
>> -#define	PAR_EL1		21	/* Physical Address Register */
>> -#define MDSCR_EL1	22	/* Monitor Debug System Control Register */
>> -#define MDCCINT_EL1	23	/* Monitor Debug Comms Channel Interrupt Enable Reg */
>> -
>> -/* 32bit specific registers. Keep them at the end of the range */
>> -#define	DACR32_EL2	24	/* Domain Access Control Register */
>> -#define	IFSR32_EL2	25	/* Instruction Fault Status Register */
>> -#define	FPEXC32_EL2	26	/* Floating-Point Exception Control Register */
>> -#define	DBGVCR32_EL2	27	/* Debug Vector Catch Register */
>> -#define	NR_SYS_REGS	28
>> -
>> -/* 32bit mapping */
>> -#define c0_MPIDR	(MPIDR_EL1 * 2)	/* MultiProcessor ID Register */
>> -#define c0_CSSELR	(CSSELR_EL1 * 2)/* Cache Size Selection Register */
>> -#define c1_SCTLR	(SCTLR_EL1 * 2)	/* System Control Register */
>> -#define c1_ACTLR	(ACTLR_EL1 * 2)	/* Auxiliary Control Register */
>> -#define c1_CPACR	(CPACR_EL1 * 2)	/* Coprocessor Access Control */
>> -#define c2_TTBR0	(TTBR0_EL1 * 2)	/* Translation Table Base Register 0 */
>> -#define c2_TTBR0_high	(c2_TTBR0 + 1)	/* TTBR0 top 32 bits */
>> -#define c2_TTBR1	(TTBR1_EL1 * 2)	/* Translation Table Base Register 1 */
>> -#define c2_TTBR1_high	(c2_TTBR1 + 1)	/* TTBR1 top 32 bits */
>> -#define c2_TTBCR	(TCR_EL1 * 2)	/* Translation Table Base Control R. */
>> -#define c3_DACR		(DACR32_EL2 * 2)/* Domain Access Control Register */
>> -#define c5_DFSR		(ESR_EL1 * 2)	/* Data Fault Status Register */
>> -#define c5_IFSR		(IFSR32_EL2 * 2)/* Instruction Fault Status Register */
>> -#define c5_ADFSR	(AFSR0_EL1 * 2)	/* Auxiliary Data Fault Status R */
>> -#define c5_AIFSR	(AFSR1_EL1 * 2)	/* Auxiliary Instr Fault Status R */
>> -#define c6_DFAR		(FAR_EL1 * 2)	/* Data Fault Address Register */
>> -#define c6_IFAR		(c6_DFAR + 1)	/* Instruction Fault Address Register */
>> -#define c7_PAR		(PAR_EL1 * 2)	/* Physical Address Register */
>> -#define c7_PAR_high	(c7_PAR + 1)	/* PAR top 32 bits */
>> -#define c10_PRRR	(MAIR_EL1 * 2)	/* Primary Region Remap Register */
>> -#define c10_NMRR	(c10_PRRR + 1)	/* Normal Memory Remap Register */
>> -#define c12_VBAR	(VBAR_EL1 * 2)	/* Vector Base Address Register */
>> -#define c13_CID		(CONTEXTIDR_EL1 * 2)	/* Context ID Register */
>> -#define c13_TID_URW	(TPIDR_EL0 * 2)	/* Thread ID, User R/W */
>> -#define c13_TID_URO	(TPIDRRO_EL0 * 2)/* Thread ID, User R/O */
>> -#define c13_TID_PRIV	(TPIDR_EL1 * 2)	/* Thread ID, Privileged */
>> -#define c10_AMAIR0	(AMAIR_EL1 * 2)	/* Aux Memory Attr Indirection Reg */
>> -#define c10_AMAIR1	(c10_AMAIR0 + 1)/* Aux Memory Attr Indirection Reg */
>> -#define c14_CNTKCTL	(CNTKCTL_EL1 * 2) /* Timer Control Register (PL1) */
>> -
>> -#define cp14_DBGDSCRext	(MDSCR_EL1 * 2)
>> -#define cp14_DBGBCR0	(DBGBCR0_EL1 * 2)
>> -#define cp14_DBGBVR0	(DBGBVR0_EL1 * 2)
>> -#define cp14_DBGBXVR0	(cp14_DBGBVR0 + 1)
>> -#define cp14_DBGWCR0	(DBGWCR0_EL1 * 2)
>> -#define cp14_DBGWVR0	(DBGWVR0_EL1 * 2)
>> -#define cp14_DBGDCCINT	(MDCCINT_EL1 * 2)
>> -
>> -#define NR_COPRO_REGS	(NR_SYS_REGS * 2)
>> -
>>  #define ARM_EXCEPTION_IRQ	  0
>>  #define ARM_EXCEPTION_TRAP	  1
>>  
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 3ca894e..170e17d 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -26,7 +26,6 @@
>>  
>>  #include <asm/esr.h>
>>  #include <asm/kvm_arm.h>
>> -#include <asm/kvm_asm.h>
>>  #include <asm/kvm_mmio.h>
>>  #include <asm/ptrace.h>
>>  #include <asm/cputype.h>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index a35ce72..2fae2d4 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -25,7 +25,6 @@
>>  #include <linux/types.h>
>>  #include <linux/kvm_types.h>
>>  #include <asm/kvm.h>
>> -#include <asm/kvm_asm.h>
>>  #include <asm/kvm_mmio.h>
>>  
>>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>> @@ -85,6 +84,86 @@ struct kvm_vcpu_fault_info {
>>  	u64 hpfar_el2;		/* Hyp IPA Fault Address Register */
>>  };
>>  
>> +/*
>> + * 0 is reserved as an invalid value.
>> + * Order *must* be kept in sync with the hyp switch code.
> 
> do we still have such an ordering requirement?

Hmmm. Not as strong as it was before. For performance, it is better to
keep it in order (prefetcher, silly things like that), but this is in no
way an absolute requirement.

I'll amend the comment (or even drop it).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
