From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 03/21] KVM: ARM64: Add offset defines for PMU registers
Date: Mon, 07 Dec 2015 14:06:46 +0000
Message-ID: <56659276.6060403@arm.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com> <1449123091-20252-4-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449123091-20252-4-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 03/12/15 06:11, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> We are about to trap and emulate acccesses to each PMU register

s/acccesses/accesses/

> individually. This adds the context offsets for the AArch64 PMU
> registers and their AArch32 counterparts.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h | 55 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 5e37710..4f804c1 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -48,12 +48,34 @@
>  #define MDSCR_EL1	22	/* Monitor Debug System Control Register */
>  #define MDCCINT_EL1	23	/* Monitor Debug Comms Channel Interrupt Enable Reg */
>  

Coming back to this patch, it gives a clear view of where you have state
duplication.

> +/* Performance Monitors Registers */
> +#define PMCR_EL0	24	/* Control Register */
> +#define PMOVSSET_EL0	25	/* Overflow Flag Status Set Register */
> +#define PMOVSCLR_EL0	26	/* Overflow Flag Status Clear Register */

This should only be a single state. You don't even have to represent it
in the sysreg array, to be honest.

> +#define PMSELR_EL0	27	/* Event Counter Selection Register */
> +#define PMCEID0_EL0	28	/* Common Event Identification Register 0 */
> +#define PMCEID1_EL0	29	/* Common Event Identification Register 1 */
> +#define PMEVCNTR0_EL0	30	/* Event Counter Register (0-30) */
> +#define PMEVCNTR30_EL0	60
> +#define PMCCNTR_EL0	61	/* Cycle Counter Register */
> +#define PMEVTYPER0_EL0	62	/* Event Type Register (0-30) */
> +#define PMEVTYPER30_EL0	92
> +#define PMCCFILTR_EL0	93	/* Cycle Count Filter Register */
> +#define PMXEVCNTR_EL0	94	/* Selected Event Count Register */
> +#define PMXEVTYPER_EL0	95	/* Selected Event Type Register */

These "select" registers aren't real ones, but just a way to pick the
real register. They should be removed.

> +#define PMCNTENSET_EL0	96	/* Count Enable Set Register */
> +#define PMCNTENCLR_EL0	97	/* Count Enable Clear Register */
> +#define PMINTENSET_EL1	98	/* Interrupt Enable Set Register */
> +#define PMINTENCLR_EL1	99	/* Interrupt Enable Clear Register */

Same for these. They are just convenient accessors for the HW register.

> +#define PMUSERENR_EL0	100	/* User Enable Register */
> +#define PMSWINC_EL0	101	/* Software Increment Register */
> +
>  /* 32bit specific registers. Keep them at the end of the range */
> -#define	DACR32_EL2	24	/* Domain Access Control Register */
> -#define	IFSR32_EL2	25	/* Instruction Fault Status Register */
> -#define	FPEXC32_EL2	26	/* Floating-Point Exception Control Register */
> -#define	DBGVCR32_EL2	27	/* Debug Vector Catch Register */
> -#define	NR_SYS_REGS	28
> +#define	DACR32_EL2	102	/* Domain Access Control Register */
> +#define	IFSR32_EL2	103	/* Instruction Fault Status Register */
> +#define	FPEXC32_EL2	104	/* Floating-Point Exception Control Register */
> +#define	DBGVCR32_EL2	105	/* Debug Vector Catch Register */
> +#define	NR_SYS_REGS	106
>  
>  /* 32bit mapping */
>  #define c0_MPIDR	(MPIDR_EL1 * 2)	/* MultiProcessor ID Register */
> @@ -75,6 +97,24 @@
>  #define c6_IFAR		(c6_DFAR + 1)	/* Instruction Fault Address Register */
>  #define c7_PAR		(PAR_EL1 * 2)	/* Physical Address Register */
>  #define c7_PAR_high	(c7_PAR + 1)	/* PAR top 32 bits */
> +
> +/* Performance Monitors*/
> +#define c9_PMCR		(PMCR_EL0 * 2)
> +#define c9_PMOVSSET	(PMOVSSET_EL0 * 2)
> +#define c9_PMOVSCLR	(PMOVSCLR_EL0 * 2)
> +#define c9_PMCCNTR	(PMCCNTR_EL0 * 2)
> +#define c9_PMSELR	(PMSELR_EL0 * 2)
> +#define c9_PMCEID0	(PMCEID0_EL0 * 2)
> +#define c9_PMCEID1	(PMCEID1_EL0 * 2)
> +#define c9_PMXEVCNTR	(PMXEVCNTR_EL0 * 2)
> +#define c9_PMXEVTYPER	(PMXEVTYPER_EL0 * 2)
> +#define c9_PMCNTENSET	(PMCNTENSET_EL0 * 2)
> +#define c9_PMCNTENCLR	(PMCNTENCLR_EL0 * 2)
> +#define c9_PMINTENSET	(PMINTENSET_EL1 * 2)
> +#define c9_PMINTENCLR	(PMINTENCLR_EL1 * 2)
> +#define c9_PMUSERENR	(PMUSERENR_EL0 * 2)
> +#define c9_PMSWINC	(PMSWINC_EL0 * 2)
> +
>  #define c10_PRRR	(MAIR_EL1 * 2)	/* Primary Region Remap Register */
>  #define c10_NMRR	(c10_PRRR + 1)	/* Normal Memory Remap Register */
>  #define c12_VBAR	(VBAR_EL1 * 2)	/* Vector Base Address Register */
> @@ -86,6 +126,11 @@
>  #define c10_AMAIR1	(c10_AMAIR0 + 1)/* Aux Memory Attr Indirection Reg */
>  #define c14_CNTKCTL	(CNTKCTL_EL1 * 2) /* Timer Control Register (PL1) */
>  
> +/* Performance Monitors*/
> +#define c14_PMEVCNTR0	(PMEVCNTR0_EL0 * 2)
> +#define c14_PMEVTYPER0	(PMEVTYPER0_EL0 * 2)
> +#define c14_PMCCFILTR	(PMCCFILTR_EL0 * 2)
> +
>  #define cp14_DBGDSCRext	(MDSCR_EL1 * 2)
>  #define cp14_DBGBCR0	(DBGBCR0_EL1 * 2)
>  #define cp14_DBGBVR0	(DBGBVR0_EL1 * 2)
> 

In my branch, I've moved all of this to kvm_host.h since that's where
all the sysregs have moved with the new world-switch. Don't bother doing
that in your next version, I'll take care of the merging issues.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
