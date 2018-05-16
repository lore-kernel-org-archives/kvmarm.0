From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 08/14] ARM: spectre-v2: harden user aborts in kernel space
Date: Wed, 16 May 2018 12:01:18 +0100
Message-ID: <E1fIuBK-0003q7-9n@rmk-PC.armlinux.org.uk>
References: <20180516105949.GJ16141@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CFD749F88
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:52:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GaNl+bv3U41j for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 06:52:12 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE1784A0E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:51:36 -0400 (EDT)
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

In order to prevent aliasing attacks on the branch predictor,
invalidate the BTB or instruction cache on CPUs that are known to be
affected when taking an abort on a address that is outside of a user
task limit:

Cortex A8, A9, A12, A17, A73, A75: flush BTB.
Cortex A15, Brahma B15: invalidate icache.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm/include/asm/cp15.h        |  3 +++
 arch/arm/include/asm/system_misc.h |  8 ++++++
 arch/arm/mm/fault.c                |  3 +++
 arch/arm/mm/proc-v7-bugs.c         | 51 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/proc-v7.S              |  8 +++---
 5 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/cp15.h b/arch/arm/include/asm/cp15.h
index 4c9fa72b59f5..07e27f212dc7 100644
--- a/arch/arm/include/asm/cp15.h
+++ b/arch/arm/include/asm/cp15.h
@@ -65,6 +65,9 @@
 #define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
 #define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
 
+#define BPIALL				__ACCESS_CP15(c7, 0, c5, 6)
+#define ICIALLU				__ACCESS_CP15(c7, 0, c5, 0)
+
 extern unsigned long cr_alignment;	/* defined in entry-armv.S */
 
 static inline unsigned long get_cr(void)
diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
index 78f6db114faf..3cfe010c5734 100644
--- a/arch/arm/include/asm/system_misc.h
+++ b/arch/arm/include/asm/system_misc.h
@@ -15,6 +15,14 @@ void soft_restart(unsigned long);
 extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
 extern void (*arm_pm_idle)(void);
 
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+extern void (*harden_branch_predictor)(void);
+#define harden_branch_predictor() \
+	do { if (harden_branch_predictor) harden_branch_predictor(); } while (0)
+#else
+#define harden_branch_predictor() do { } while (0)
+#endif
+
 #define UDBG_UNDEFINED	(1 << 0)
 #define UDBG_SYSCALL	(1 << 1)
 #define UDBG_BADABORT	(1 << 2)
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index b75eada23d0a..3b1ba003c4f9 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -163,6 +163,9 @@ __do_user_fault(struct task_struct *tsk, unsigned long addr,
 {
 	struct siginfo si;
 
+	if (addr > TASK_SIZE)
+		harden_branch_predictor();
+
 #ifdef CONFIG_DEBUG_USER
 	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
 	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index a32ce13479d9..65a9b8141f86 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -2,6 +2,12 @@
 #include <linux/kernel.h>
 #include <linux/smp.h>
 
+#include <asm/cp15.h>
+#include <asm/cputype.h>
+#include <asm/system_misc.h>
+
+void cpu_v7_bugs_init(void);
+
 static __maybe_unused void cpu_v7_check_auxcr_set(u32 mask, const char *msg)
 {
 	u32 aux_cr;
@@ -21,9 +27,54 @@ static void check_spectre_auxcr(u32 bit)
 void cpu_v7_ca8_ibe(void)
 {
 	check_spectre_auxcr(BIT(6));
+	cpu_v7_bugs_init();
 }
 
 void cpu_v7_ca15_ibe(void)
 {
 	check_spectre_auxcr(BIT(0));
+	cpu_v7_bugs_init();
+}
+
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+void (*harden_branch_predictor)(void);
+
+static void harden_branch_predictor_bpiall(void)
+{
+	write_sysreg(0, BPIALL);
+}
+
+static void harden_branch_predictor_iciallu(void)
+{
+	write_sysreg(0, ICIALLU);
+}
+
+void cpu_v7_bugs_init(void)
+{
+	const char *spectre_v2_method = NULL;
+
+	if (harden_branch_predictor)
+		return;
+
+	switch (read_cpuid_part()) {
+	case ARM_CPU_PART_CORTEX_A8:
+	case ARM_CPU_PART_CORTEX_A9:
+	case ARM_CPU_PART_CORTEX_A12:
+	case ARM_CPU_PART_CORTEX_A17:
+	case ARM_CPU_PART_CORTEX_A73:
+	case ARM_CPU_PART_CORTEX_A75:
+		harden_branch_predictor = harden_branch_predictor_bpiall;
+		spectre_v2_method = "BPIALL";
+		break;
+
+	case ARM_CPU_PART_CORTEX_A15:
+	case ARM_CPU_PART_BRAHMA_B15:
+		harden_branch_predictor = harden_branch_predictor_iciallu;
+		spectre_v2_method = "ICIALLU";
+		break;
+	}
+	if (spectre_v2_method)
+		pr_info("CPU: Spectre v2: using %s workaround\n",
+			spectre_v2_method);
 }
+#endif
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 5cfed34fd1af..989864676f8b 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -533,8 +533,10 @@ ENDPROC(__v7_setup)
 
 	__INITDATA
 
+	.weak cpu_v7_bugs_init
+
 	@ define struct processor (see <asm/proc-fns.h> and proc-macros.S)
-	define_processor_functions v7, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions v7, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_bugs_init
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	@ generic v7 bpiall on context switch
@@ -549,7 +551,7 @@ ENDPROC(__v7_setup)
 	globl_equ	cpu_v7_bpiall_do_suspend,	cpu_v7_do_suspend
 	globl_equ	cpu_v7_bpiall_do_resume,	cpu_v7_do_resume
 #endif
-	define_processor_functions v7_bpiall, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions v7_bpiall, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_bugs_init
 
 #define HARDENED_BPIALL_PROCESSOR_FUNCTIONS v7_bpiall_processor_functions
 #else
@@ -585,7 +587,7 @@ ENDPROC(__v7_setup)
 	globl_equ	cpu_ca9mp_switch_mm,	cpu_v7_switch_mm
 #endif
 	globl_equ	cpu_ca9mp_set_pte_ext,	cpu_v7_set_pte_ext
-	define_processor_functions ca9mp, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions ca9mp, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_bugs_init
 #endif
 
 	@ Cortex-A15 - needs iciallu switch_mm for hardening
-- 
2.7.4
