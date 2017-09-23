From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 03/20] arm64: Use the physical counter when available for read_cycles
Date: Sat, 23 Sep 2017 02:41:50 +0200
Message-ID: <20170923004207.22356-4-cdall@linaro.org>
References: <20170923004207.22356-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170923004207.22356-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Currently get_cycles() is hardwired to arch_counter_get_cntvct() on
arm64, but as we move to using the physical timer for the in-kernel
time-keeping, we need to make that more flexible.

First, we need to make sure the physical counter can be read on equal
terms to the virtual counter, which includes adding physical counter
read functions for timers that require errata.

Second, we need to make a choice between reading the physical vs virtual
counter, depending on which timer is used for time keeping in the kernel
otherwise.  We can do this using a static key to avoid a performance
penalty during runtime when reading the counter.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/include/asm/arch_timer.h  | 15 ++++++++++++---
 arch/arm64/include/asm/timex.h       |  2 +-
 drivers/clocksource/arm_arch_timer.c | 32 ++++++++++++++++++++++++++++++--
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 1859a1c..c56d8cd 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -30,6 +30,8 @@
 
 #include <clocksource/arm_arch_timer.h>
 
+extern struct static_key_false arch_timer_phys_counter_available;
+
 #if IS_ENABLED(CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND)
 extern struct static_key_false arch_timer_read_ool_enabled;
 #define needs_unstable_timer_counter_workaround() \
@@ -52,6 +54,7 @@ struct arch_timer_erratum_workaround {
 	const char *desc;
 	u32 (*read_cntp_tval_el0)(void);
 	u32 (*read_cntv_tval_el0)(void);
+	u64 (*read_cntpct_el0)(void);
 	u64 (*read_cntvct_el0)(void);
 	int (*set_next_event_phys)(unsigned long, struct clock_event_device *);
 	int (*set_next_event_virt)(unsigned long, struct clock_event_device *);
@@ -148,10 +151,8 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 
 static inline u64 arch_counter_get_cntpct(void)
 {
-	u64 cval;
 	isb();
-	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
-	return cval;
+	return arch_timer_reg_read_stable(cntpct_el0);
 }
 
 static inline u64 arch_counter_get_cntvct(void)
@@ -160,6 +161,14 @@ static inline u64 arch_counter_get_cntvct(void)
 	return arch_timer_reg_read_stable(cntvct_el0);
 }
 
+static inline u64 arch_counter_get_cycles(void)
+{
+	if (static_branch_unlikely(&arch_timer_phys_counter_available))
+	    return arch_counter_get_cntpct();
+	else
+	    return arch_counter_get_cntvct();
+}
+
 static inline int arch_timer_arch_init(void)
 {
 	return 0;
diff --git a/arch/arm64/include/asm/timex.h b/arch/arm64/include/asm/timex.h
index 81a076e..c0d214c 100644
--- a/arch/arm64/include/asm/timex.h
+++ b/arch/arm64/include/asm/timex.h
@@ -22,7 +22,7 @@
  * Use the current timer as a cycle counter since this is what we use for
  * the delay loop.
  */
-#define get_cycles()	arch_counter_get_cntvct()
+#define get_cycles()	arch_counter_get_cycles()
 
 #include <asm-generic/timex.h>
 
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 9b3322a..f35da20 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -77,6 +77,9 @@ static bool arch_timer_mem_use_virtual;
 static bool arch_counter_suspend_stop;
 static bool vdso_default = true;
 
+DEFINE_STATIC_KEY_FALSE(arch_timer_phys_counter_available);
+EXPORT_SYMBOL_GPL(arch_timer_phys_counter_available);
+
 static bool evtstrm_enable = IS_ENABLED(CONFIG_ARM_ARCH_TIMER_EVTSTREAM);
 
 static int __init early_evtstrm_cfg(char *buf)
@@ -217,6 +220,11 @@ static u32 notrace fsl_a008585_read_cntv_tval_el0(void)
 	return __fsl_a008585_read_reg(cntv_tval_el0);
 }
 
+static u64 notrace fsl_a008585_read_cntpct_el0(void)
+{
+	return __fsl_a008585_read_reg(cntpct_el0);
+}
+
 static u64 notrace fsl_a008585_read_cntvct_el0(void)
 {
 	return __fsl_a008585_read_reg(cntvct_el0);
@@ -258,6 +266,11 @@ static u32 notrace hisi_161010101_read_cntv_tval_el0(void)
 	return __hisi_161010101_read_reg(cntv_tval_el0);
 }
 
+static u64 notrace hisi_161010101_read_cntpct_el0(void)
+{
+	return __hisi_161010101_read_reg(cntpct_el0);
+}
+
 static u64 notrace hisi_161010101_read_cntvct_el0(void)
 {
 	return __hisi_161010101_read_reg(cntvct_el0);
@@ -288,6 +301,15 @@ static struct ate_acpi_oem_info hisi_161010101_oem_info[] = {
 #endif
 
 #ifdef CONFIG_ARM64_ERRATUM_858921
+static u64 notrace arm64_858921_read_cntpct_el0(void)
+{
+	u64 old, new;
+
+	old = read_sysreg(cntpct_el0);
+	new = read_sysreg(cntpct_el0);
+	return (((old ^ new) >> 32) & 1) ? old : new;
+}
+
 static u64 notrace arm64_858921_read_cntvct_el0(void)
 {
 	u64 old, new;
@@ -346,6 +368,7 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.desc = "Freescale erratum a005858",
 		.read_cntp_tval_el0 = fsl_a008585_read_cntp_tval_el0,
 		.read_cntv_tval_el0 = fsl_a008585_read_cntv_tval_el0,
+		.read_cntpct_el0 = fsl_a008585_read_cntpct_el0,
 		.read_cntvct_el0 = fsl_a008585_read_cntvct_el0,
 		.set_next_event_phys = erratum_set_next_event_tval_phys,
 		.set_next_event_virt = erratum_set_next_event_tval_virt,
@@ -358,6 +381,7 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.desc = "HiSilicon erratum 161010101",
 		.read_cntp_tval_el0 = hisi_161010101_read_cntp_tval_el0,
 		.read_cntv_tval_el0 = hisi_161010101_read_cntv_tval_el0,
+		.read_cntpct_el0 = hisi_161010101_read_cntpct_el0,
 		.read_cntvct_el0 = hisi_161010101_read_cntvct_el0,
 		.set_next_event_phys = erratum_set_next_event_tval_phys,
 		.set_next_event_virt = erratum_set_next_event_tval_virt,
@@ -368,6 +392,7 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.desc = "HiSilicon erratum 161010101",
 		.read_cntp_tval_el0 = hisi_161010101_read_cntp_tval_el0,
 		.read_cntv_tval_el0 = hisi_161010101_read_cntv_tval_el0,
+		.read_cntpct_el0 = hisi_161010101_read_cntpct_el0,
 		.read_cntvct_el0 = hisi_161010101_read_cntvct_el0,
 		.set_next_event_phys = erratum_set_next_event_tval_phys,
 		.set_next_event_virt = erratum_set_next_event_tval_virt,
@@ -378,6 +403,7 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.match_type = ate_match_local_cap_id,
 		.id = (void *)ARM64_WORKAROUND_858921,
 		.desc = "ARM erratum 858921",
+		.read_cntpct_el0 = arm64_858921_read_cntpct_el0,
 		.read_cntvct_el0 = arm64_858921_read_cntvct_el0,
 	},
 #endif
@@ -890,10 +916,12 @@ static void __init arch_counter_register(unsigned type)
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_TIMER_TYPE_CP15) {
-		if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
+		if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI) {
 			arch_timer_read_counter = arch_counter_get_cntvct;
-		else
+		} else {
 			arch_timer_read_counter = arch_counter_get_cntpct;
+			static_branch_enable(&arch_timer_phys_counter_available);
+		}
 
 		clocksource_counter.archdata.vdso_direct = vdso_default;
 	} else {
-- 
2.9.0
