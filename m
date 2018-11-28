From: Steven Price <steven.price@arm.com>
Subject: [PATCH 07/12] clocksource: arm_arch_timer: Use paravirtualized LPT
Date: Wed, 28 Nov 2018 14:45:22 +0000
Message-ID: <20181128144527.44710-8-steven.price@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C58CD4A377
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ckTJN9JuPRsb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Nov 2018 09:46:42 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB59D4A34E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:40 -0500 (EST)
In-Reply-To: <20181128144527.44710-1-steven.price@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Enable paravirtualized time to be used in a KVM guest if the host
supports it. This allows the guest to derive a counter which is clocked
at a persistent rate even when the guest is migrated.

If we discover that the system supports SMCCC v1.1 then we probe to
determine whether the hypervisor supports paravirtualized features and
finally whether it supports "Live Physical Time" reporting. If so a
shared structure is made available to the guest containing coefficients
to calculate the derived clock.

The guest kernel uses the coefficients to present a clock to user space
that is always clocked at the same rate whenever the guest is running
('live'), even if the physical clock changes (due to the guest being
migrated).

The existing workaround framework for CNTVCT is used to disable the VDSO
and trap user space accesses to the timer registers so we can present the
derived clock.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/arch_timer.h  |  32 ++++-
 arch/arm64/kernel/cpuinfo.c          |   2 +-
 drivers/clocksource/arm_arch_timer.c | 176 ++++++++++++++++++++++++++-
 3 files changed, 204 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index f2a234d6516c..ec0e7250c453 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -20,12 +20,14 @@
 #define __ASM_ARCH_TIMER_H
 
 #include <asm/barrier.h>
+#include <asm/pvclock-abi.h>
 #include <asm/sysreg.h>
 
 #include <linux/bug.h>
 #include <linux/init.h>
 #include <linux/jump_label.h>
 #include <linux/smp.h>
+#include <linux/static_key.h>
 #include <linux/types.h>
 
 #include <clocksource/arm_arch_timer.h>
@@ -79,6 +81,19 @@ DECLARE_PER_CPU(const struct arch_timer_erratum_workaround *,
 	_val;								\
 })
 
+void pvclock_reg_write_cntv_tval_el0(u32 val);
+extern struct static_key_false arch_counter_cntfrq_ool_enabled;
+extern u64 pvclock_get_cntfrq(void);
+extern struct static_key_false arch_counter_cntvct_ool_enabled;
+extern u64 pvclock_get_cntvct(void);
+
+static __always_inline void __write_cntv_tval_el0(u32 val)
+{
+	if (static_branch_unlikely(&arch_counter_cntvct_ool_enabled))
+		return pvclock_reg_write_cntv_tval_el0(val);
+	write_sysreg(val, cntv_tval_el0);
+}
+
 /*
  * These register accessors are marked inline so the compiler can
  * nicely work out which register we want, and chuck away the rest of
@@ -102,7 +117,7 @@ void arch_timer_reg_write_cp15(int access, enum arch_timer_reg reg, u32 val)
 			write_sysreg(val, cntv_ctl_el0);
 			break;
 		case ARCH_TIMER_REG_TVAL:
-			write_sysreg(val, cntv_tval_el0);
+			__write_cntv_tval_el0(val);
 			break;
 		}
 	}
@@ -134,7 +149,10 @@ u32 arch_timer_reg_read_cp15(int access, enum arch_timer_reg reg)
 
 static inline u32 arch_timer_get_cntfrq(void)
 {
-	return read_sysreg(cntfrq_el0);
+	if (static_branch_unlikely(&arch_counter_cntfrq_ool_enabled))
+		return pvclock_get_cntfrq();
+	else
+		return read_sysreg(cntfrq_el0);
 }
 
 static inline u32 arch_timer_get_cntkctl(void)
@@ -154,12 +172,20 @@ static inline u64 arch_counter_get_cntpct(void)
 	return arch_timer_reg_read_stable(cntpct_el0);
 }
 
-static inline u64 arch_counter_get_cntvct(void)
+static inline u64 __arch_counter_get_cntvct(void)
 {
 	isb();
 	return arch_timer_reg_read_stable(cntvct_el0);
 }
 
+static inline u64 arch_counter_get_cntvct(void)
+{
+	if (static_branch_unlikely(&arch_counter_cntvct_ool_enabled))
+		return pvclock_get_cntvct();
+	else
+		return __arch_counter_get_cntvct();
+}
+
 static inline int arch_timer_arch_init(void)
 {
 	return 0;
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index bcc2831399cb..74410727829d 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -324,7 +324,7 @@ static void cpuinfo_detect_icache_policy(struct cpuinfo_arm64 *info)
 
 static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 {
-	info->reg_cntfrq = arch_timer_get_cntfrq();
+	info->reg_cntfrq = read_cpuid(CNTFRQ_EL0);
 	/*
 	 * Use the effective value of the CTR_EL0 than the raw value
 	 * exposed by the CPU. CTR_E0.IDC field value must be interpreted
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 9a7d4dc00b6e..1991d5044496 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -11,6 +11,7 @@
 
 #define pr_fmt(fmt)	"arm_arch_timer: " fmt
 
+#include <linux/arm-smccc.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
@@ -23,6 +24,8 @@
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <linux/io.h>
+#include <linux/psci.h>
+#include <linux/reboot.h>
 #include <linux/slab.h>
 #include <linux/sched/clock.h>
 #include <linux/sched_clock.h>
@@ -86,6 +89,170 @@ static int __init early_evtstrm_cfg(char *buf)
 }
 early_param("clocksource.arm_arch_timer.evtstrm", early_evtstrm_cfg);
 
+#ifdef CONFIG_ARM64
+/* Paravirtualised time is only supported for 64 bit */
+static struct pvclock_vm_time_info *pvclock_vm_time_info;
+
+DEFINE_STATIC_KEY_FALSE(arch_counter_cntvct_ool_enabled);
+EXPORT_SYMBOL_GPL(arch_counter_cntvct_ool_enabled);
+DEFINE_STATIC_KEY_FALSE(arch_counter_cntfrq_ool_enabled);
+EXPORT_SYMBOL_GPL(arch_counter_cntfrq_ool_enabled);
+
+static inline u64 native_to_pv_cycles(const struct pvclock_vm_time_info *info,
+		u64 cnt)
+{
+	u32 shift = le32_to_cpu(info->shift);
+	u64 scale_mult = le64_to_cpu(info->scale_mult);
+
+	cnt <<= shift;
+	return mul_u64_u64_shr(scale_mult, cnt, 64);
+}
+
+static inline u64 pv_to_native_cycles(const struct pvclock_vm_time_info *info,
+		u64 cnt)
+{
+	u64 native_freq = le64_to_cpu(info->native_freq);
+	u64 pv_freq = le64_to_cpu(info->pv_freq);
+	u64 div_by_pv_freq_mult = le64_to_cpu(info->div_by_pv_freq_mult);
+
+	cnt = native_freq * cnt + pv_freq - 1;
+	return mul_u64_u64_shr(div_by_pv_freq_mult, cnt, 64);
+}
+
+u64 pvclock_get_cntvct(void)
+{
+	u64 cval;
+	__le64 seq_begin, seq_end;
+
+	do {
+		seq_begin = READ_ONCE(pvclock_vm_time_info->sequence_number);
+
+		barrier();
+
+		cval = __arch_counter_get_cntvct();
+		cval = native_to_pv_cycles(pvclock_vm_time_info, cval);
+
+		barrier();
+		seq_end = READ_ONCE(pvclock_vm_time_info->sequence_number);
+	} while (unlikely(seq_begin != seq_end));
+
+	return cval;
+}
+
+u64 pvclock_get_cntfrq(void)
+{
+	return le64_to_cpu(pvclock_vm_time_info->pv_freq);
+}
+
+static void arch_timer_pvclock_init(void)
+{
+	struct arm_smccc_res res;
+	void *kaddr;
+
+	if (psci_ops.smccc_version < SMCCC_VERSION_1_1)
+		return;
+
+	arm_smccc_1_1(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+		      ARM_SMCCC_HV_PV_FEATURES, &res);
+
+	if (res.a0 != SMCCC_RET_SUCCESS)
+		return;
+
+	arm_smccc_1_1(ARM_SMCCC_HV_PV_FEATURES, ARM_SMCCC_HV_PV_TIME_LPT, &res);
+
+	if ((s32)res.a0 < 0)
+		return;
+
+	arm_smccc_1_1(ARM_SMCCC_HV_PV_TIME_LPT, 0, &res);
+
+	if ((s64)res.a0 < 0)
+		return;
+
+	kaddr = memremap(res.a0,
+			sizeof(struct pvclock_vm_time_info),
+			MEMREMAP_WB);
+
+	if (!kaddr) {
+		pr_warn("Failed to map LPT structure for paravirtualized clock\n");
+		return;
+	}
+
+	pvclock_vm_time_info = kaddr;
+
+	static_branch_enable(&arch_counter_cntvct_ool_enabled);
+	static_branch_enable(&arch_counter_cntfrq_ool_enabled);
+
+	pr_info("Using paravirtualized clock\n");
+}
+
+static inline bool pvclock_trap_cntvct(void)
+{
+	return static_branch_unlikely(&arch_counter_cntvct_ool_enabled);
+}
+
+static inline void arch_timer_reg_write_cntv_tval(u32 val,
+						  struct arch_timer *timer)
+{
+	__le64 seq_begin, seq_end;
+
+	if (!static_branch_unlikely(&arch_counter_cntvct_ool_enabled)) {
+		writel_relaxed(val, timer->base + CNTV_TVAL);
+		return;
+	}
+
+	do {
+		u32 n_val;
+
+		seq_begin = READ_ONCE(pvclock_vm_time_info->sequence_number);
+
+		barrier();
+
+		n_val = pv_to_native_cycles(pvclock_vm_time_info, val);
+
+		writel_relaxed(n_val, timer->base + CNTV_TVAL);
+		barrier();
+
+		seq_end = READ_ONCE(pvclock_vm_time_info->sequence_number);
+	} while (unlikely(seq_begin != seq_end));
+}
+
+void pvclock_reg_write_cntv_tval_el0(u32 val)
+{
+	__le64 seq_begin, seq_end;
+
+	do {
+		u32 n_val;
+
+		seq_begin = READ_ONCE(pvclock_vm_time_info->sequence_number);
+
+		barrier();
+
+		n_val = pv_to_native_cycles(pvclock_vm_time_info, val);
+
+		write_sysreg(n_val, cntv_tval_el0);
+		barrier();
+
+		seq_end = READ_ONCE(pvclock_vm_time_info->sequence_number);
+	} while (unlikely(seq_begin != seq_end));
+}
+
+#else /* CONFIG_ARM64 */
+static void arch_timer_pvclock_init(void)
+{
+}
+
+static inline bool pvclock_trap_cntvct(void)
+{
+	return false;
+}
+
+static inline void arch_timer_reg_write_cntv_tval(u32 val,
+						 struct arch_timer *timer)
+{
+	writel_relaxed(val, timer->base + CNTV_TVAL);
+}
+#endif /* CONFIG_ARM64 */
+
 /*
  * Architected system timer support.
  */
@@ -111,7 +278,7 @@ void arch_timer_reg_write(int access, enum arch_timer_reg reg, u32 val,
 			writel_relaxed(val, timer->base + CNTV_CTL);
 			break;
 		case ARCH_TIMER_REG_TVAL:
-			writel_relaxed(val, timer->base + CNTV_TVAL);
+			arch_timer_reg_write_cntv_tval(val, timer);
 			break;
 		}
 	} else {
@@ -589,6 +756,7 @@ static bool arch_timer_this_cpu_has_cntvct_wa(void)
 #define erratum_set_next_event_tval_phys(...)		({BUG(); 0;})
 #define erratum_handler(fn, r, ...)			({false;})
 #define arch_timer_this_cpu_has_cntvct_wa()		({false;})
+
 #endif /* CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND */
 
 static __always_inline irqreturn_t timer_handler(const int access,
@@ -815,7 +983,7 @@ static void arch_counter_set_user_access(void)
 	 * need to be workaround. The vdso may have been already
 	 * disabled though.
 	 */
-	if (arch_timer_this_cpu_has_cntvct_wa())
+	if (pvclock_trap_cntvct() || arch_timer_this_cpu_has_cntvct_wa())
 		pr_info("CPU%d: Trapping CNTVCT access\n", smp_processor_id());
 	else
 		cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
@@ -1222,6 +1390,8 @@ static int __init arch_timer_of_init(struct device_node *np)
 
 	arch_timer_kvm_info.virtual_irq = arch_timer_ppi[ARCH_TIMER_VIRT_PPI];
 
+	arch_timer_pvclock_init();
+
 	rate = arch_timer_get_cntfrq();
 	arch_timer_of_configure_rate(rate, np);
 
@@ -1552,6 +1722,8 @@ static int __init arch_timer_acpi_init(struct acpi_table_header *table)
 
 	arch_timer_kvm_info.virtual_irq = arch_timer_ppi[ARCH_TIMER_VIRT_PPI];
 
+	arch_timer_pvclock_init();
+
 	/*
 	 * When probing via ACPI, we have no mechanism to override the sysreg
 	 * CNTFRQ value. This *must* be correct.
-- 
2.19.2
