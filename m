From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 15/27] arm64/sve: Probe SVE capabilities and usable vector lengths
Date: Wed,  9 Aug 2017 13:05:21 +0100
Message-ID: <1502280338-23002-16-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch uses the cpufeatures framework to determine common SVE
capabilities and vector lengths, and configures the runtime SVE
support code appropriately.

ZCR_ELx is not really a feature register, but it is convenient to
use it as a template for recording the maximum vector length
supported by a CPU, using the LEN field.  This field is similar to
a feature field in that it is a contiguous bitfield for which we
want to determine the minimum system-wide value.  This patch adds
ZCR as a pseudo-register in cpuinfo/cpufeatures, with appropriate
custom code to populate it.  Finding the minimum supported value of
the LEN field is left to the cpufeatures framework in the usual
way.

The meaning of ID_AA64ZFR0_EL1 is not architecturally defined yet,
so for now we just require it to be zero.

Note that much of this code is dormant and SVE still won't be used
yet, since system_supports_sve() remains hardwired to false.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/cpu.h        |   4 ++
 arch/arm64/include/asm/cpufeature.h |  28 ++++++++++
 arch/arm64/include/asm/fpsimd.h     |  10 ++++
 arch/arm64/kernel/cpufeature.c      |  48 ++++++++++++++++
 arch/arm64/kernel/cpuinfo.c         |   6 ++
 arch/arm64/kernel/fpsimd.c          | 108 ++++++++++++++++++++++++++++++++++++
 6 files changed, 204 insertions(+)

diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index 889226b..8839227 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -41,6 +41,7 @@ struct cpuinfo_arm64 {
 	u64		reg_id_aa64mmfr2;
 	u64		reg_id_aa64pfr0;
 	u64		reg_id_aa64pfr1;
+	u64		reg_id_aa64zfr0;
 
 	u32		reg_id_dfr0;
 	u32		reg_id_isar0;
@@ -59,6 +60,9 @@ struct cpuinfo_arm64 {
 	u32		reg_mvfr0;
 	u32		reg_mvfr1;
 	u32		reg_mvfr2;
+
+	/* pseudo-ZCR for recording maximum ZCR_EL1 LEN value: */
+	u64		reg_zcr;
 };
 
 DECLARE_PER_CPU(struct cpuinfo_arm64, cpu_data);
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 4ea3441..05eec27 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -10,6 +10,7 @@
 #define __ASM_CPUFEATURE_H
 
 #include <asm/cpucaps.h>
+#include <asm/fpsimd.h>
 #include <asm/hwcap.h>
 #include <asm/sysreg.h>
 
@@ -223,6 +224,13 @@ static inline bool id_aa64pfr0_32bit_el0(u64 pfr0)
 	return val == ID_AA64PFR0_EL0_32BIT_64BIT;
 }
 
+static inline bool id_aa64pfr0_sve(u64 pfr0)
+{
+	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_SVE_SHIFT);
+
+	return val > 0;
+}
+
 void __init setup_cpu_features(void);
 
 void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
@@ -267,6 +275,26 @@ static inline bool system_supports_sve(void)
 	return false;
 }
 
+/*
+ * Read the pseudo-ZCR used by cpufeatures to identify the supported SVE
+ * vector length.
+ * Use only if SVE is present.  This function clobbers the SVE vector length.
+ */
+static u64 __maybe_unused read_zcr_features(void)
+{
+	u64 zcr;
+	unsigned int vq_max;
+
+	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL1);
+
+	zcr = read_sysreg_s(SYS_ZCR_EL1);
+	zcr &= ~(u64)ZCR_ELx_LEN_MASK;
+	vq_max = sve_get_vl() / 16;
+	zcr |= vq_max - 1;
+
+	return zcr;
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 39b26d2..f43f573 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -90,12 +90,22 @@ extern void fpsimd_dup_sve(struct task_struct *dst,
 extern int sve_set_vector_length(struct task_struct *task,
 				 unsigned long vl, unsigned long flags);
 
+extern void __init sve_init_vq_map(void);
+extern void sve_update_vq_map(void);
+extern int sve_verify_vq_map(void);
+extern void __init sve_setup(void);
+
 #else /* ! CONFIG_ARM64_SVE */
 
 static void __maybe_unused sve_alloc(struct task_struct *task) { }
 static void __maybe_unused fpsimd_release_thread(struct task_struct *task) { }
 static void __maybe_unused fpsimd_dup_sve(struct task_struct *dst,
 					  struct task_struct const *src) { }
+static void __maybe_unused sve_init_vq_map(void) { }
+static void __maybe_unused sve_update_vq_map(void) { }
+static int __maybe_unused sve_verify_vq_map(void) { return 0; }
+static void __maybe_unused sve_setup(void) { }
+
 #endif /* ! CONFIG_ARM64_SVE */
 
 /* For use by EFI runtime services calls only */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9f9e0064..f322c90 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -27,6 +27,7 @@
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
+#include <asm/fpsimd.h>
 #include <asm/mmu_context.h>
 #include <asm/processor.h>
 #include <asm/sysreg.h>
@@ -267,6 +268,12 @@ static const struct arm64_ftr_bits ftr_id_dfr0[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_zcr[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE,
+		ZCR_ELx_LEN_SHIFT, ZCR_ELx_LEN_SIZE, 0),	/* LEN */
+	ARM64_FTR_END,
+};
+
 /*
  * Common ftr bits for a 32bit register with all hidden, strict
  * attributes, with 4bit feature fields and a default safe value of
@@ -333,6 +340,7 @@ static const struct __ftr_reg_entry {
 	/* Op1 = 0, CRn = 0, CRm = 4 */
 	ARM64_FTR_REG(SYS_ID_AA64PFR0_EL1, ftr_id_aa64pfr0),
 	ARM64_FTR_REG(SYS_ID_AA64PFR1_EL1, ftr_raz),
+	ARM64_FTR_REG(SYS_ID_AA64ZFR0_EL1, ftr_raz),
 
 	/* Op1 = 0, CRn = 0, CRm = 5 */
 	ARM64_FTR_REG(SYS_ID_AA64DFR0_EL1, ftr_id_aa64dfr0),
@@ -347,6 +355,9 @@ static const struct __ftr_reg_entry {
 	ARM64_FTR_REG(SYS_ID_AA64MMFR1_EL1, ftr_id_aa64mmfr1),
 	ARM64_FTR_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2),
 
+	/* Op1 = 0, CRn = 1, CRm = 2 */
+	ARM64_FTR_REG(SYS_ZCR_EL1, ftr_zcr),
+
 	/* Op1 = 3, CRn = 0, CRm = 0 */
 	{ SYS_CTR_EL0, &arm64_ftr_reg_ctrel0 },
 	ARM64_FTR_REG(SYS_DCZID_EL0, ftr_dczid),
@@ -484,6 +495,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR2_EL1, info->reg_id_aa64mmfr2);
 	init_cpu_ftr_reg(SYS_ID_AA64PFR0_EL1, info->reg_id_aa64pfr0);
 	init_cpu_ftr_reg(SYS_ID_AA64PFR1_EL1, info->reg_id_aa64pfr1);
+	init_cpu_ftr_reg(SYS_ID_AA64ZFR0_EL1, info->reg_id_aa64zfr0);
 
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0)) {
 		init_cpu_ftr_reg(SYS_ID_DFR0_EL1, info->reg_id_dfr0);
@@ -504,6 +516,10 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 		init_cpu_ftr_reg(SYS_MVFR2_EL1, info->reg_mvfr2);
 	}
 
+	if (id_aa64pfr0_sve(info->reg_id_aa64pfr0)) {
+		init_cpu_ftr_reg(SYS_ZCR_EL1, info->reg_zcr);
+		sve_init_vq_map();
+	}
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
@@ -607,6 +623,9 @@ void update_cpu_features(int cpu,
 	taint |= check_update_ftr_reg(SYS_ID_AA64PFR1_EL1, cpu,
 				      info->reg_id_aa64pfr1, boot->reg_id_aa64pfr1);
 
+	taint |= check_update_ftr_reg(SYS_ID_AA64ZFR0_EL1, cpu,
+				      info->reg_id_aa64zfr0, boot->reg_id_aa64zfr0);
+
 	/*
 	 * If we have AArch32, we care about 32-bit features for compat.
 	 * If the system doesn't support AArch32, don't update them.
@@ -654,6 +673,12 @@ void update_cpu_features(int cpu,
 					info->reg_mvfr2, boot->reg_mvfr2);
 	}
 
+	if (id_aa64pfr0_sve(info->reg_id_aa64pfr0)) {
+		taint |= check_update_ftr_reg(SYS_ZCR_EL1, cpu,
+					info->reg_zcr, boot->reg_zcr);
+		sve_update_vq_map();
+	}
+
 	/*
 	 * Mismatched CPU features are a recipe for disaster. Don't even
 	 * pretend to support them.
@@ -1084,6 +1109,23 @@ verify_local_cpu_features(const struct arm64_cpu_capabilities *caps)
 	}
 }
 
+static void verify_sve_features(void)
+{
+	u64 safe_zcr = read_sanitised_ftr_reg(SYS_ZCR_EL1);
+	u64 zcr = read_zcr_features();
+
+	unsigned int safe_len = safe_zcr & ZCR_ELx_LEN_MASK;
+	unsigned int len = zcr & ZCR_ELx_LEN_MASK;
+
+	if (len < safe_len || sve_verify_vq_map()) {
+		pr_crit("CPU%d: SVE: required vector length(s) missing\n",
+			smp_processor_id());
+		cpu_die_early();
+	}
+
+	/* Add checks on other ZCR bits here if necessary */
+}
+
 /*
  * Run through the enabled system capabilities and enable() it on this CPU.
  * The capabilities were decided based on the available CPUs at the boot time.
@@ -1097,8 +1139,12 @@ static void verify_local_cpu_capabilities(void)
 	verify_local_cpu_errata_workarounds();
 	verify_local_cpu_features(arm64_features);
 	verify_local_elf_hwcaps(arm64_elf_hwcaps);
+
 	if (system_supports_32bit_el0())
 		verify_local_elf_hwcaps(compat_elf_hwcaps);
+
+	if (system_supports_sve())
+		verify_sve_features();
 }
 
 void check_local_cpu_capabilities(void)
@@ -1176,6 +1222,8 @@ void __init setup_cpu_features(void)
 	if (system_supports_32bit_el0())
 		setup_elf_hwcaps(compat_elf_hwcaps);
 
+	sve_setup();
+
 	/* Advertise that we have computed the system capabilities */
 	set_sys_caps_initialised();
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index f495ee5..0e087d7 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -19,6 +19,7 @@
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/cpufeature.h>
+#include <asm/fpsimd.h>
 
 #include <linux/bitops.h>
 #include <linux/bug.h>
@@ -325,6 +326,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_id_aa64mmfr2 = read_cpuid(ID_AA64MMFR2_EL1);
 	info->reg_id_aa64pfr0 = read_cpuid(ID_AA64PFR0_EL1);
 	info->reg_id_aa64pfr1 = read_cpuid(ID_AA64PFR1_EL1);
+	info->reg_id_aa64zfr0 = read_cpuid(ID_AA64ZFR0_EL1);
 
 	/* Update the 32bit ID registers only if AArch32 is implemented */
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0)) {
@@ -347,6 +349,10 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 		info->reg_mvfr2 = read_cpuid(MVFR2_EL1);
 	}
 
+	if (IS_ENABLED(CONFIG_ARM64_SVE) &&
+	    id_aa64pfr0_sve(info->reg_id_aa64pfr0))
+		info->reg_zcr = read_zcr_features();
+
 	cpuinfo_detect_icache_policy(info);
 }
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index bce95de..955c873 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -119,11 +119,13 @@ static int sve_default_vl = -1;
 int sve_max_vl = -1;
 /* Set of available vector lengths, as vq_to_bit(vq): */
 static DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
+static bool sve_vq_map_finalised;
 
 #else /* ! CONFIG_ARM64_SVE */
 
 /* Dummy declaration for code that will be optimised out: */
 extern DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
+extern bool sve_vq_map_finalised;
 
 #endif /* ! CONFIG_ARM64_SVE */
 
@@ -349,6 +351,112 @@ int sve_set_vector_length(struct task_struct *task,
 	return 0;
 }
 
+static unsigned long *sve_alloc_vq_map(void)
+{
+	return kzalloc(BITS_TO_LONGS(SVE_VQ_MAX) * sizeof(unsigned long),
+		       GFP_KERNEL);
+}
+
+static void sve_probe_vqs(DECLARE_BITMAP(map, SVE_VQ_MAX))
+{
+	unsigned int vq, vl;
+	unsigned long zcr;
+
+	zcr = ZCR_ELx_LEN_MASK;
+	zcr = read_sysreg_s(SYS_ZCR_EL1) & ~zcr;
+
+	for (vq = SVE_VQ_MAX; vq >= 1; --vq) {
+		write_sysreg_s(zcr | (vq - 1), SYS_ZCR_EL1); /* self-syncing */
+		vl = sve_get_vl();
+
+		BUG_ON(!sve_vl_valid(vl));
+		vq = sve_vq_from_vl(vl);
+		set_bit(vq_to_bit(vq), map);
+	}
+}
+
+void __init sve_init_vq_map(void)
+{
+	sve_probe_vqs(sve_vq_map);
+}
+
+/*
+ * If we haven't committed to the set of supported VQs yet, filter out
+ * those not supported by the current CPU:
+ */
+void sve_update_vq_map(void)
+{
+	unsigned long *map;
+
+	if (sve_vq_map_finalised)
+		return;
+
+	map = sve_alloc_vq_map();
+	sve_probe_vqs(map);
+	bitmap_and(sve_vq_map, sve_vq_map, map, SVE_VQ_MAX);
+	kfree(map);
+}
+
+/* Check whether the current CPU supports all VQs in the committed set */
+int sve_verify_vq_map(void)
+{
+	int ret = 0;
+	unsigned long *map = sve_alloc_vq_map();
+
+	sve_probe_vqs(map);
+	bitmap_andnot(map, sve_vq_map, map, SVE_VQ_MAX);
+	if (!bitmap_empty(map, SVE_VQ_MAX)) {
+		pr_warn("SVE: cpu%d: Required vector length(s) missing\n",
+			smp_processor_id());
+		ret = -EINVAL;
+	}
+
+	kfree(map);
+
+	return ret;
+}
+
+void __init sve_setup(void)
+{
+	u64 zcr;
+	unsigned int max_vl;
+
+	if (!system_supports_sve())
+		return;
+
+	/*
+	 * The architecture mandates 128-bit vectors be supported, and
+	 * the code assumes elsewhere that sve_vq_map is non-empty:
+	 */
+	BUG_ON(!test_bit(vq_to_bit(1), sve_vq_map));
+
+	sve_vq_map_finalised = true;
+
+
+	zcr = read_sanitised_ftr_reg(SYS_ZCR_EL1);
+	max_vl = sve_vl_from_vq((zcr & ZCR_ELx_LEN_MASK) + 1);
+
+	/*
+	 * Sanity-check that the max VL we determined through CPU features
+	 * corresponds properly to sve_vq_map:
+	 */
+	sve_max_vl = SVE_VL_MAX;
+	BUG_ON(find_supported_vector_length(SVE_VL_MAX) != max_vl);
+	BUG_ON(find_supported_vector_length(max_vl) != max_vl);
+
+	sve_max_vl = max_vl;
+
+	/* For the default VL, pick the maximum supported value <= 64: */
+	sve_default_vl = find_supported_vector_length(64);
+	BUG_ON(!sve_vl_valid(sve_default_vl));
+	BUG_ON(sve_default_vl > 64);
+
+	pr_info("SVE: maximum available vector length %u bytes per vector\n",
+		sve_max_vl);
+	pr_info("SVE: default vector length %u bytes per vector\n",
+		sve_default_vl);
+}
+
 void fpsimd_release_thread(struct task_struct *dead_task)
 {
 	sve_free(dead_task);
-- 
2.1.4
