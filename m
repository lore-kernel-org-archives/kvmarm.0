From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 09/14] ARM: spectre-v2: add PSCI based hardening
Date: Wed, 16 May 2018 12:01:23 +0100
Message-ID: <E1fIuBP-0003qE-DZ@rmk-PC.armlinux.org.uk>
References: <20180516105949.GJ16141@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78E1049F88
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:52:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cdy1uUYndZOk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 06:52:22 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA9F84A0FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:51:38 -0400 (EDT)
In-Reply-To: <20180516105949.GJ16141@n2100.armlinux.org.uk>
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Add PSCI based hardening for cores that require more complex handling in
firmware.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm/mm/proc-v7-bugs.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/proc-v7.S      | 21 +++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 65a9b8141f86..81de4a8e74c6 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -1,9 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/arm-smccc.h>
 #include <linux/kernel.h>
+#include <linux/psci.h>
 #include <linux/smp.h>
 
 #include <asm/cp15.h>
 #include <asm/cputype.h>
+#include <asm/proc-fns.h>
 #include <asm/system_misc.h>
 
 void cpu_v7_bugs_init(void);
@@ -39,6 +42,9 @@ void cpu_v7_ca15_ibe(void)
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 void (*harden_branch_predictor)(void);
 
+extern void cpu_v7_smc_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
+extern void cpu_v7_hvc_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
+
 static void harden_branch_predictor_bpiall(void)
 {
 	write_sysreg(0, BPIALL);
@@ -49,6 +55,18 @@ static void harden_branch_predictor_iciallu(void)
 	write_sysreg(0, ICIALLU);
 }
 
+#ifdef CONFIG_ARM_PSCI
+static void call_smc_arch_workaround_1(void)
+{
+	arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
+}
+
+static void call_hvc_arch_workaround_1(void)
+{
+	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
+}
+#endif
+
 void cpu_v7_bugs_init(void)
 {
 	const char *spectre_v2_method = NULL;
@@ -73,6 +91,38 @@ void cpu_v7_bugs_init(void)
 		spectre_v2_method = "ICIALLU";
 		break;
 	}
+
+#ifdef CONFIG_ARM_PSCI
+	if (psci_ops.smccc_version != SMCCC_VERSION_1_0) {
+		struct arm_smccc_res res;
+
+		switch (psci_ops.conduit) {
+		case PSCI_CONDUIT_HVC:
+			arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+			if ((int)res.a0 < 0)
+				break;
+			harden_branch_predictor = call_hvc_arch_workaround_1;
+			processor.switch_mm = cpu_v7_hvc_switch_mm;
+			spectre_v2_method = "hypervisor PSCI";
+			break;
+
+		case PSCI_CONDUIT_SMC:
+			arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+			if ((int)res.a0 < 0)
+				break;
+			harden_branch_predictor = call_smc_arch_workaround_1;
+			processor.switch_mm = cpu_v7_smc_switch_mm;
+			spectre_v2_method = "firmware PSCI";
+			break;
+
+		default:
+			break;
+		}
+	}
+#endif
+
 	if (spectre_v2_method)
 		pr_info("CPU: Spectre v2: using %s workaround\n",
 			spectre_v2_method);
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 989864676f8b..7e6719a0eada 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -9,6 +9,7 @@
  *
  *  This is the "shell" of the ARMv7 processor support.
  */
+#include <linux/arm-smccc.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/assembler.h>
@@ -93,6 +94,26 @@ ENTRY(cpu_v7_dcache_clean_area)
 	ret	lr
 ENDPROC(cpu_v7_dcache_clean_area)
 
+#ifdef CONFIG_ARM_PSCI
+	.arch_extension sec
+ENTRY(cpu_v7_smc_switch_mm)
+	stmfd	sp!, {r0 - r3}
+	movw	r0, #:lower16:ARM_SMCCC_ARCH_WORKAROUND_1
+	movt	r0, #:upper16:ARM_SMCCC_ARCH_WORKAROUND_1
+	smc	#0
+	ldmfd	sp!, {r0 - r3}
+	b	cpu_v7_switch_mm
+ENDPROC(cpu_v7_smc_switch_mm)
+	.arch_extension virt
+ENTRY(cpu_v7_hvc_switch_mm)
+	stmfd	sp!, {r0 - r3}
+	movw	r0, #:lower16:ARM_SMCCC_ARCH_WORKAROUND_1
+	movt	r0, #:upper16:ARM_SMCCC_ARCH_WORKAROUND_1
+	hvc	#0
+	ldmfd	sp!, {r0 - r3}
+	b	cpu_v7_switch_mm
+ENDPROC(cpu_v7_smc_switch_mm)
+#endif
 ENTRY(cpu_v7_iciallu_switch_mm)
 	mov	r3, #0
 	mcr	p15, 0, r3, c7, c5, 0		@ ICIALLU
-- 
2.7.4
