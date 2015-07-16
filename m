From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 03/18] KVM: ARM64: Add offset defines for PMU registers
Date: Thu, 16 Jul 2015 20:45:09 +0200
Message-ID: <20150716184509.GC14024@cbox>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
 <1436149068-3784-4-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436149068-3784-4-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: shannon.zhao@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 06, 2015 at 10:17:33AM +0800, shannon.zhao@linaro.org wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> We are about to trap and emulate acccesses to each PMU register
> individually. This adds the context offsets for the AArch64 PMU
> registers and their AArch32 counterparts.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h | 59 +++++++++++++++++++++++++++++++++++-----
>  1 file changed, 52 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 3c5fe68..21b5d3b 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -56,14 +56,36 @@
>  #define DBGWVR15_EL1	86
>  #define MDCCINT_EL1	87	/* Monitor Debug Comms Channel Interrupt Enable Reg */
>  
> +/* Performance Monitors Registers */
> +#define PMCR_EL0	88	/* Control Register */
> +#define PMOVSSET_EL0	89	/* Overflow Flag Status Set Register */
> +#define PMOVSCLR_EL0	90	/* Overflow Flag Status Clear Register */
> +#define PMCCNTR_EL0	91	/* Cycle Counter Register */
> +#define PMSELR_EL0	92	/* Event Counter Selection Register */
> +#define PMCEID0_EL0	93	/* Common Event Identification Register 0 */
> +#define PMCEID1_EL0	94	/* Common Event Identification Register 1 */
> +#define PMEVCNTR0_EL0	95	/* Event Counter Register (0-30) */

why do we need these when we trap-and-emulate and we have the kvm_pmc
structs?  Is that because the kvm_pmc structs are only used when we
actually have an active counter running and registered with perf?

> +#define PMEVTYPER0_EL0	96	/* Event Type Register (0-30) */
> +#define PMEVCNTR30_EL0	155
> +#define PMEVTYPER30_EL0	156
> +#define PMXEVCNTR_EL0	157	/* Selected Event Count Register */
> +#define PMXEVTYPER_EL0	158	/* Selected Event Type Register */
> +#define PMCNTENSET_EL0	159	/* Count Enable Set Register */
> +#define PMCNTENCLR_EL0	160	/* Count Enable Clear Register */
> +#define PMINTENSET_EL1	161	/* Interrupt Enable Set Register */
> +#define PMINTENCLR_EL1	162	/* Interrupt Enable Clear Register */
> +#define PMUSERENR_EL0	163	/* User Enable Register */
> +#define PMCCFILTR_EL0	164	/* Cycle Count Filter Register */
> +#define PMSWINC_EL0	165	/* Software Increment Register */
> +
>  /* 32bit specific registers. Keep them at the end of the range */
> -#define	DACR32_EL2	88	/* Domain Access Control Register */
> -#define	IFSR32_EL2	89	/* Instruction Fault Status Register */
> -#define	FPEXC32_EL2	90	/* Floating-Point Exception Control Register */
> -#define	DBGVCR32_EL2	91	/* Debug Vector Catch Register */
> -#define	TEECR32_EL1	92	/* ThumbEE Configuration Register */
> -#define	TEEHBR32_EL1	93	/* ThumbEE Handler Base Register */
> -#define	NR_SYS_REGS	94
> +#define	DACR32_EL2	166	/* Domain Access Control Register */
> +#define	IFSR32_EL2	167	/* Instruction Fault Status Register */
> +#define	FPEXC32_EL2	168	/* Floating-Point Exception Control Register */
> +#define	DBGVCR32_EL2	169	/* Debug Vector Catch Register */
> +#define	TEECR32_EL1	170	/* ThumbEE Configuration Register */
> +#define	TEEHBR32_EL1	171	/* ThumbEE Handler Base Register */
> +#define	NR_SYS_REGS	172
>  
>  /* 32bit mapping */
>  #define c0_MPIDR	(MPIDR_EL1 * 2)	/* MultiProcessor ID Register */
> @@ -85,6 +107,24 @@
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
> @@ -96,6 +136,11 @@
>  #define c10_AMAIR1	(c10_AMAIR0 + 1)/* Aux Memory Attr Indirection Reg */
>  #define c14_CNTKCTL	(CNTKCTL_EL1 * 2) /* Timer Control Register (PL1) */
>  
> +/* Performance Monitors*/
> +#define c14_PMEVCNTR0  (PMEVCNTR0_EL0 * 2)
> +#define c14_PMEVTYPR0  (PMEVTYPER0_EL0 * 2)
> +#define c14_PMCCFILTR  (PMCCFILTR_EL0 * 2)
> +
>  #define cp14_DBGDSCRext	(MDSCR_EL1 * 2)
>  #define cp14_DBGBCR0	(DBGBCR0_EL1 * 2)
>  #define cp14_DBGBVR0	(DBGBVR0_EL1 * 2)
> -- 
> 2.1.0
> 
