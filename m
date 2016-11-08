From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 1/2] arm64: Add hypervisor safe helper for checking constant capabilities
Date: Tue,  8 Nov 2016 13:56:20 +0000
Message-ID: <1478613381-5718-2-git-send-email-suzuki.poulose@arm.com>
References: <1478613381-5718-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478613381-5718-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, Suzuki K Poulose <suzuki.poulose@arm.com>, Robert Ritcher <rritcher@cavium.com>, Tirumalesh Chalamarla <tchalamarla@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

The hypervisor may not have full access to the kernel data structures
and hence cannot safely use cpus_have_cap() helper for checking the
system capability. Add a safe helper for hypervisors to check a constant
system capability, which *doesn't* fall back to checking the bitmap
maintained by the kernel. With this, make the cpus_have_cap() only
check the bitmask and force constant cap checks to use the new API
for quicker checks.

Cc: Robert Ritcher <rritcher@cavium.com>
Cc: Tirumalesh Chalamarla <tchalamarla@cavium.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 19 ++++++++++++-------
 arch/arm64/kernel/cpufeature.c      |  2 +-
 arch/arm64/kernel/process.c         |  2 +-
 drivers/irqchip/irq-gic-v3.c        | 13 +------------
 4 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 0bc0b1d..9890d20 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -9,8 +9,6 @@
 #ifndef __ASM_CPUFEATURE_H
 #define __ASM_CPUFEATURE_H
 
-#include <linux/jump_label.h>
-
 #include <asm/cpucaps.h>
 #include <asm/hwcap.h>
 #include <asm/sysreg.h>
@@ -27,6 +25,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/bug.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
 
 /* CPU feature register tracking */
@@ -104,14 +104,19 @@ static inline bool cpu_have_feature(unsigned int num)
 	return elf_hwcap & (1UL << num);
 }
 
+/* System capability check for constant caps */
+static inline bool cpus_have_const_cap(int num)
+{
+	if (num >= ARM64_NCAPS)
+		return false;
+	return static_branch_unlikely(&cpu_hwcap_keys[num]);
+}
+
 static inline bool cpus_have_cap(unsigned int num)
 {
 	if (num >= ARM64_NCAPS)
 		return false;
-	if (__builtin_constant_p(num))
-		return static_branch_unlikely(&cpu_hwcap_keys[num]);
-	else
-		return test_bit(num, cpu_hwcaps);
+	return test_bit(num, cpu_hwcaps);
 }
 
 static inline void cpus_set_cap(unsigned int num)
@@ -200,7 +205,7 @@ static inline bool cpu_supports_mixed_endian_el0(void)
 
 static inline bool system_supports_32bit_el0(void)
 {
-	return cpus_have_cap(ARM64_HAS_32BIT_EL0);
+	return cpus_have_const_cap(ARM64_HAS_32BIT_EL0);
 }
 
 static inline bool system_supports_mixed_endian_el0(void)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c02504e..fc2bd19 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1102,5 +1102,5 @@ void __init setup_cpu_features(void)
 static bool __maybe_unused
 cpufeature_pan_not_uao(const struct arm64_cpu_capabilities *entry, int __unused)
 {
-	return (cpus_have_cap(ARM64_HAS_PAN) && !cpus_have_cap(ARM64_HAS_UAO));
+	return (cpus_have_const_cap(ARM64_HAS_PAN) && !cpus_have_const_cap(ARM64_HAS_UAO));
 }
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 01753cd..18354f3 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -282,7 +282,7 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 		memset(childregs, 0, sizeof(struct pt_regs));
 		childregs->pstate = PSR_MODE_EL1h;
 		if (IS_ENABLED(CONFIG_ARM64_UAO) &&
-		    cpus_have_cap(ARM64_HAS_UAO))
+		    cpus_have_const_cap(ARM64_HAS_UAO))
 			childregs->pstate |= PSR_UAO_BIT;
 		p->thread.cpu_context.x19 = stack_start;
 		p->thread.cpu_context.x20 = stk_sz;
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 19d642e..26e1d7f 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -120,11 +120,10 @@ static void gic_redist_wait_for_rwp(void)
 }
 
 #ifdef CONFIG_ARM64
-static DEFINE_STATIC_KEY_FALSE(is_cavium_thunderx);
 
 static u64 __maybe_unused gic_read_iar(void)
 {
-	if (static_branch_unlikely(&is_cavium_thunderx))
+	if (cpus_have_const_cap(ARM64_WORKAROUND_CAVIUM_23154))
 		return gic_read_iar_cavium_thunderx();
 	else
 		return gic_read_iar_common();
@@ -905,14 +904,6 @@ static const struct irq_domain_ops partition_domain_ops = {
 	.select = gic_irq_domain_select,
 };
 
-static void gicv3_enable_quirks(void)
-{
-#ifdef CONFIG_ARM64
-	if (cpus_have_cap(ARM64_WORKAROUND_CAVIUM_23154))
-		static_branch_enable(&is_cavium_thunderx);
-#endif
-}
-
 static int __init gic_init_bases(void __iomem *dist_base,
 				 struct redist_region *rdist_regs,
 				 u32 nr_redist_regions,
@@ -935,8 +926,6 @@ static int __init gic_init_bases(void __iomem *dist_base,
 	gic_data.nr_redist_regions = nr_redist_regions;
 	gic_data.redist_stride = redist_stride;
 
-	gicv3_enable_quirks();
-
 	/*
 	 * Find out how many interrupts are supported.
 	 * The GIC only supports up to 1020 interrupt sources (SGI+PPI+SPI)
-- 
2.7.4
