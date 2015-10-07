From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 03/20] KVM: ARM64: Add offset defines for PMU registers
Date: Wed, 07 Oct 2015 09:25:42 +0100
Message-ID: <5614D706.9000106@arm.com>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org> <1443133885-3366-4-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443133885-3366-4-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, wei@redhat.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 24/09/15 23:31, Shannon Zhao wrote:
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
> index 67fa0de..0a4dfcc 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -48,14 +48,36 @@
>  #define MDSCR_EL1	22	/* Monitor Debug System Control Register */
>  #define MDCCINT_EL1	23	/* Monitor Debug Comms Channel Interrupt Enable Reg */
>  
> +/* Performance Monitors Registers */
> +#define PMCR_EL0	24	/* Control Register */
> +#define PMOVSSET_EL0	25	/* Overflow Flag Status Set Register */
> +#define PMOVSCLR_EL0	26	/* Overflow Flag Status Clear Register */
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
> +#define PMCNTENSET_EL0	96	/* Count Enable Set Register */
> +#define PMCNTENCLR_EL0	97	/* Count Enable Clear Register */
> +#define PMINTENSET_EL1	98	/* Interrupt Enable Set Register */
> +#define PMINTENCLR_EL1	99	/* Interrupt Enable Clear Register */
> +#define PMUSERENR_EL0	100	/* User Enable Register */
> +#define PMSWINC_EL0	101	/* Software Increment Register */
> +
>  /* 32bit specific registers. Keep them at the end of the range */
> -#define	DACR32_EL2	24	/* Domain Access Control Register */
> -#define	IFSR32_EL2	25	/* Instruction Fault Status Register */
> -#define	FPEXC32_EL2	26	/* Floating-Point Exception Control Register */
> -#define	DBGVCR32_EL2	27	/* Debug Vector Catch Register */
> -#define	TEECR32_EL1	28	/* ThumbEE Configuration Register */
> -#define	TEEHBR32_EL1	29	/* ThumbEE Handler Base Register */
> -#define	NR_SYS_REGS	30
> +#define	DACR32_EL2	102	/* Domain Access Control Register */
> +#define	IFSR32_EL2	103	/* Instruction Fault Status Register */
> +#define	FPEXC32_EL2	104	/* Floating-Point Exception Control Register */
> +#define	DBGVCR32_EL2	105	/* Debug Vector Catch Register */
> +#define	TEECR32_EL1	106	/* ThumbEE Configuration Register */
> +#define	TEEHBR32_EL1	107	/* ThumbEE Handler Base Register */
> +#define	NR_SYS_REGS	108

This will need some rebasing - some of the registers have already
changed or disappeared. I really need to find a way to make this mess
more manageable...

	M.
-- 
Jazz is not dead. It just smells funny...
