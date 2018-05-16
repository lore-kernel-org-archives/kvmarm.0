From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 09/14] ARM: spectre-v2: add PSCI based hardening
Date: Wed, 16 May 2018 18:01:56 +0100
Message-ID: <8e37dcf9-faa6-d903-6633-1322891c20d4@arm.com>
References: <20180516105949.GJ16141@n2100.armlinux.org.uk>
 <E1fIuBP-0003qE-DZ@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <E1fIuBP-0003qE-DZ@rmk-PC.armlinux.org.uk>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King <rmk+kernel@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

[updating Christoffer's email address]

On 16/05/18 12:01, Russell King wrote:
> Add PSCI based hardening for cores that require more complex handling in
> firmware.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  arch/arm/mm/proc-v7-bugs.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mm/proc-v7.S      | 21 +++++++++++++++++++
>  2 files changed, 71 insertions(+)
> 
> diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
> index 65a9b8141f86..81de4a8e74c6 100644
> --- a/arch/arm/mm/proc-v7-bugs.c
> +++ b/arch/arm/mm/proc-v7-bugs.c
> @@ -1,9 +1,12 @@
>  // SPDX-License-Identifier: GPL-2.0
> +#include <linux/arm-smccc.h>
>  #include <linux/kernel.h>
> +#include <linux/psci.h>
>  #include <linux/smp.h>
>  
>  #include <asm/cp15.h>
>  #include <asm/cputype.h>
> +#include <asm/proc-fns.h>
>  #include <asm/system_misc.h>
>  
>  void cpu_v7_bugs_init(void);
> @@ -39,6 +42,9 @@ void cpu_v7_ca15_ibe(void)
>  #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
>  void (*harden_branch_predictor)(void);
>  
> +extern void cpu_v7_smc_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
> +extern void cpu_v7_hvc_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
> +
>  static void harden_branch_predictor_bpiall(void)
>  {
>  	write_sysreg(0, BPIALL);
> @@ -49,6 +55,18 @@ static void harden_branch_predictor_iciallu(void)
>  	write_sysreg(0, ICIALLU);
>  }
>  
> +#ifdef CONFIG_ARM_PSCI
> +static void call_smc_arch_workaround_1(void)
> +{
> +	arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
> +}
> +
> +static void call_hvc_arch_workaround_1(void)
> +{
> +	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
> +}
> +#endif
> +
>  void cpu_v7_bugs_init(void)
>  {
>  	const char *spectre_v2_method = NULL;
> @@ -73,6 +91,38 @@ void cpu_v7_bugs_init(void)
>  		spectre_v2_method = "ICIALLU";
>  		break;
>  	}
> +
> +#ifdef CONFIG_ARM_PSCI
> +	if (psci_ops.smccc_version != SMCCC_VERSION_1_0) {
> +		struct arm_smccc_res res;
> +
> +		switch (psci_ops.conduit) {
> +		case PSCI_CONDUIT_HVC:
> +			arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
> +					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
> +			if ((int)res.a0 < 0)
> +				break;
> +			harden_branch_predictor = call_hvc_arch_workaround_1;
> +			processor.switch_mm = cpu_v7_hvc_switch_mm;
> +			spectre_v2_method = "hypervisor PSCI";

nit: strictly speaking, this is not provided by PSCI, but by
ARCH_WORKAROUND_1. We just use the same conduit as PSCI to discover it.

> +			break;
> +
> +		case PSCI_CONDUIT_SMC:
> +			arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
> +					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
> +			if ((int)res.a0 < 0)
> +				break;
> +			harden_branch_predictor = call_smc_arch_workaround_1;
> +			processor.switch_mm = cpu_v7_smc_switch_mm;
> +			spectre_v2_method = "firmware PSCI";
> +			break;
> +
> +		default:
> +			break;
> +		}
> +	}
> +#endif
> +
>  	if (spectre_v2_method)
>  		pr_info("CPU: Spectre v2: using %s workaround\n",
>  			spectre_v2_method);
> diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
> index 989864676f8b..7e6719a0eada 100644
> --- a/arch/arm/mm/proc-v7.S
> +++ b/arch/arm/mm/proc-v7.S
> @@ -9,6 +9,7 @@
>   *
>   *  This is the "shell" of the ARMv7 processor support.
>   */
> +#include <linux/arm-smccc.h>
>  #include <linux/init.h>
>  #include <linux/linkage.h>
>  #include <asm/assembler.h>
> @@ -93,6 +94,26 @@ ENTRY(cpu_v7_dcache_clean_area)
>  	ret	lr
>  ENDPROC(cpu_v7_dcache_clean_area)
>  
> +#ifdef CONFIG_ARM_PSCI
> +	.arch_extension sec
> +ENTRY(cpu_v7_smc_switch_mm)
> +	stmfd	sp!, {r0 - r3}
> +	movw	r0, #:lower16:ARM_SMCCC_ARCH_WORKAROUND_1
> +	movt	r0, #:upper16:ARM_SMCCC_ARCH_WORKAROUND_1
> +	smc	#0
> +	ldmfd	sp!, {r0 - r3}
> +	b	cpu_v7_switch_mm
> +ENDPROC(cpu_v7_smc_switch_mm)
> +	.arch_extension virt
> +ENTRY(cpu_v7_hvc_switch_mm)
> +	stmfd	sp!, {r0 - r3}
> +	movw	r0, #:lower16:ARM_SMCCC_ARCH_WORKAROUND_1
> +	movt	r0, #:upper16:ARM_SMCCC_ARCH_WORKAROUND_1
> +	hvc	#0
> +	ldmfd	sp!, {r0 - r3}
> +	b	cpu_v7_switch_mm
> +ENDPROC(cpu_v7_smc_switch_mm)
> +#endif
>  ENTRY(cpu_v7_iciallu_switch_mm)
>  	mov	r3, #0
>  	mcr	p15, 0, r3, c7, c5, 0		@ ICIALLU
> 

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
