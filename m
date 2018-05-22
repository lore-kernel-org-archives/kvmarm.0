From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 09/14] ARM: spectre-v2: add PSCI based hardening
Date: Tue, 22 May 2018 18:24:13 +0100
Message-ID: <35edb3df-fed4-b6e6-be0c-ee758618c92e@arm.com>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjFT-00064F-Bs@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <E1fKjFT-00064F-Bs@rmk-PC.armlinux.org.uk>
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

On 21/05/18 12:45, Russell King wrote:
> Add PSCI based hardening for cores that require more complex handling in
> firmware.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/mm/proc-v7-bugs.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mm/proc-v7.S      | 21 +++++++++++++++++++
>  2 files changed, 71 insertions(+)
> 
> diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
> index 65a9b8141f86..0c37e6a2830d 100644
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

I just realised that there is a small, but significant difference
between this and the arm64 version: On arm64, we have a table of
vulnerable implementations, and we try the mitigation on a per-cpu
basis. Here, you entirely rely on the firmware to discover whether the
CPU needs mitigation or not. You then need to check for a return value
of 1, which indicates that although the mitigation is implemented, it is
not required on this particular CPU.

But that's probably moot if you don't support BL systems.

> +			harden_branch_predictor = call_hvc_arch_workaround_1;
> +			processor.switch_mm = cpu_v7_hvc_switch_mm;
> +			spectre_v2_method = "hypervisor";
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

My previous remark still stands: this is not really PSCI.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
-
