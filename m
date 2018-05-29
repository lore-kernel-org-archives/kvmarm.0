From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v4 08/15] ARM: spectre-v2: harden user aborts in kernel space
Date: Tue, 29 May 2018 10:09:37 +0100
Message-ID: <E1fNadN-0000gD-I9@rmk-PC.armlinux.org.uk>
References: <20180529090756.GG17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180529090756.GG17671@n2100.armlinux.org.uk>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to prevent aliasing attacks on the branch predictor,
invalidate the BTB or instruction cache on CPUs that are known to be
affected when taking an abort on a address that is outside of a user
task limit:

Cortex A8, A9, A12, A17, A73, A75: flush BTB.
Cortex A15, Brahma B15: invalidate icache.

If the IBE bit is not set, then there is little point to enabling the
workaround.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/include/asm/cp15.h        |  3 ++
 arch/arm/include/asm/system_misc.h | 15 ++++++++
 arch/arm/mm/fault.c                |  3 ++
 arch/arm/mm/proc-v7-bugs.c         | 78 ++++++++++++++++++++++++++++++++++----
 arch/arm/mm/proc-v7.S              |  8 ++--
 5 files changed, 97 insertions(+), 10 deletions(-)

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
index 78f6db114faf..8e76db83c498 100644
--- a/arch/arm/include/asm/system_misc.h
+++ b/arch/arm/include/asm/system_misc.h
@@ -8,6 +8,7 @@
 #include <linux/linkage.h>
 #include <linux/irqflags.h>
 #include <linux/reboot.h>
+#include <linux/percpu.h>
 
 extern void cpu_init(void);
 
@@ -15,6 +16,20 @@ void soft_restart(unsigned long);
 extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
 extern void (*arm_pm_idle)(void);
 
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+typedef void (*harden_branch_predictor_fn_t)(void);
+DECLARE_PER_CPU(harden_branch_predictor_fn_t, harden_branch_predictor_fn);
+static inline void harden_branch_predictor(void)
+{
+	harden_branch_predictor_fn_t fn = per_cpu(harden_branch_predictor_fn,
+						  smp_processor_id());
+	if (fn)
+		fn();
+}
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
index cd368f1e6748..0b48270b7318 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -2,31 +2,95 @@
 #include <linux/kernel.h>
 #include <linux/smp.h>
 
-static __maybe_unused void cpu_v7_check_auxcr_set(u32 mask, const char *msg)
+#include <asm/cp15.h>
+#include <asm/cputype.h>
+#include <asm/system_misc.h>
+
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+DEFINE_PER_CPU(harden_branch_predictor_fn_t, harden_branch_predictor_fn);
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
+static void cpu_v7_spectre_init(void)
+{
+	const char *spectre_v2_method = NULL;
+	int cpu = smp_processor_id();
+
+	if (per_cpu(harden_branch_predictor_fn, cpu))
+		return;
+
+	switch (read_cpuid_part()) {
+	case ARM_CPU_PART_CORTEX_A8:
+	case ARM_CPU_PART_CORTEX_A9:
+	case ARM_CPU_PART_CORTEX_A12:
+	case ARM_CPU_PART_CORTEX_A17:
+	case ARM_CPU_PART_CORTEX_A73:
+	case ARM_CPU_PART_CORTEX_A75:
+		per_cpu(harden_branch_predictor_fn, cpu) =
+			harden_branch_predictor_bpiall;
+		spectre_v2_method = "BPIALL";
+		break;
+
+	case ARM_CPU_PART_CORTEX_A15:
+	case ARM_CPU_PART_BRAHMA_B15:
+		per_cpu(harden_branch_predictor_fn, cpu) =
+			harden_branch_predictor_iciallu;
+		spectre_v2_method = "ICIALLU";
+		break;
+	}
+	if (spectre_v2_method)
+		pr_info("CPU%u: Spectre v2: using %s workaround\n",
+			smp_processor_id(), spectre_v2_method);
+}
+#else
+static void cpu_v7_spectre_init(void)
+{
+}
+#endif
+
+static __maybe_unused bool cpu_v7_check_auxcr_set(u32 mask, const char *msg)
 {
 	u32 aux_cr;
 
 	asm("mrc p15, 0, %0, c1, c0, 1" : "=r" (aux_cr));
 
-	if ((aux_cr & mask) != mask)
+	if ((aux_cr & mask) != mask) {
 		pr_err("CPU%u: %s", smp_processor_id(), msg);
+		return false;
+	}
+	return true;
 }
 
 static DEFINE_PER_CPU(bool, spectre_checked);
 
-static void check_spectre_auxcr(u32 bit)
+static bool check_spectre_auxcr(u32 bit)
 {
-	if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR) &&
-	    !__this_cpu_xchg(spectre_checked, true))
+	return IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR) &&
+		!__this_cpu_xchg(spectre_checked, true) &&
 		cpu_v7_check_auxcr_set(bit, "Spectre v2: firmware did not set auxiliary control register IBE bit, system vulnerable\n");
 }
 
 void cpu_v7_ca8_ibe(void)
 {
-	check_spectre_auxcr(BIT(6));
+	if (check_spectre_auxcr(BIT(6)))
+		cpu_v7_spectre_init();
 }
 
 void cpu_v7_ca15_ibe(void)
 {
-	check_spectre_auxcr(BIT(0));
+	if (check_spectre_auxcr(BIT(0)))
+		cpu_v7_spectre_init();
+}
+
+void cpu_v7_bugs_init(void)
+{
+	cpu_v7_spectre_init();
 }
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index fa9214036fb3..79510011e7eb 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -532,8 +532,10 @@ ENDPROC(__v7_setup)
 
 	__INITDATA
 
+	.weak cpu_v7_bugs_init
+
 	@ define struct processor (see <asm/proc-fns.h> and proc-macros.S)
-	define_processor_functions v7, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions v7, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_bugs_init
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	@ generic v7 bpiall on context switch
@@ -548,7 +550,7 @@ ENDPROC(__v7_setup)
 	globl_equ	cpu_v7_bpiall_do_suspend,	cpu_v7_do_suspend
 	globl_equ	cpu_v7_bpiall_do_resume,	cpu_v7_do_resume
 #endif
-	define_processor_functions v7_bpiall, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions v7_bpiall, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_bugs_init
 
 #define HARDENED_BPIALL_PROCESSOR_FUNCTIONS v7_bpiall_processor_functions
 #else
@@ -584,7 +586,7 @@ ENDPROC(__v7_setup)
 	globl_equ	cpu_ca9mp_switch_mm,	cpu_v7_switch_mm
 #endif
 	globl_equ	cpu_ca9mp_set_pte_ext,	cpu_v7_set_pte_ext
-	define_processor_functions ca9mp, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions ca9mp, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_bugs_init
 #endif
 
 	@ Cortex-A15 - needs iciallu switch_mm for hardening
-- 
2.7.4
