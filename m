Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A430413B2AF
	for <kvmarm@lists.linux.dev>; Fri,  4 Oct 2024 11:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728040051; cv=none; b=iy3Vj17dSJItwziy0w/f39GbJc1OjEkDyXVrqTNmTnFz1RqHHNxQWAsID1HMVUzFbkP/ujFtLi5lsWVQHGi+8dUb+uE4/FMy/XVrEY8jaIxztptFouEvifhG0hSFWk3O7xFWMLW8eDTr9MeYdjk61GHcu3EQc0V++iW/0sRfLVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728040051; c=relaxed/simple;
	bh=MVQM4MnZd/cuOoTDSoYw55pqCQyz/PxC6QJADmgsTco=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C79n3iDWG4WaA3L5ASPTUeFuq67rjhOwk5TpwwDoYtVI0sUQyhIdEIGVxHa2m3UZvW/aFCU/kf5hPInk3aGTiHjFldpGgM04uD5UkFTOOYKYQXigxR/pC6uzDIstsBbfbC4s14DaDTi1/HIg5GZy0dkQCi6zP5oSmp4xaOJ1hZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83E3A1063;
	Fri,  4 Oct 2024 04:07:57 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4913F3F640;
	Fri,  4 Oct 2024 04:07:26 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com,
	james.morse@arm.com,
	joey.gouly@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v4 3/7] arm64: cpufeature: discover CPU support for MPAM
Date: Fri,  4 Oct 2024 12:07:10 +0100
Message-Id: <20241004110714.2051604-4-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241004110714.2051604-1-joey.gouly@arm.com>
References: <20241004110714.2051604-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

ARMv8.4 adds support for 'Memory Partitioning And Monitoring' (MPAM)
which describes an interface to cache and bandwidth controls wherever
they appear in the system.

Add support to detect MPAM. Like SVE, MPAM has an extra id register that
describes some more properties, including the virtualisation support,
which is optional. Detect this separately so we can detect
mismatched/insane systems, but still use MPAM on the host even if the
virtualisation support is missing.

MPAM needs enabling at the highest implemented exception level, otherwise
the register accesses trap. The 'enabled' flag is accessible to lower
exception levels, but its in a register that traps when MPAM isn't enabled.
The cpufeature 'matches' hook is extended to test this on one of the
CPUs, so that firmware can emulate MPAM as disabled if it is reserved
for use by secure world.

Secondary CPUs that appear late could trip cpufeature's 'lower safe'
behaviour after the MPAM properties have been advertised to user-space.
Add a verify call to ensure late secondaries match the existing CPUs.

(If you have a boot failure that bisects here its likely your CPUs
advertise MPAM in the id registers, but firmware failed to either enable
or MPAM, or emulate the trap as if it were disabled)

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
Changes since v3:
 * A proper conversion to sysreg
---
 .../arch/arm64/cpu-feature-registers.rst      |  2 +
 arch/arm64/Kconfig                            | 20 ++++
 arch/arm64/include/asm/cpu.h                  |  1 +
 arch/arm64/include/asm/cpucaps.h              |  2 +
 arch/arm64/include/asm/cpufeature.h           | 12 +++
 arch/arm64/include/asm/mpam.h                 | 32 ++++++
 arch/arm64/kernel/Makefile                    |  2 +
 arch/arm64/kernel/cpufeature.c                | 97 +++++++++++++++++++
 arch/arm64/kernel/cpuinfo.c                   |  4 +
 arch/arm64/kernel/mpam.c                      |  8 ++
 arch/arm64/tools/cpucaps                      |  1 +
 11 files changed, 181 insertions(+)
 create mode 100644 arch/arm64/include/asm/mpam.h
 create mode 100644 arch/arm64/kernel/mpam.c

diff --git a/Documentation/arch/arm64/cpu-feature-registers.rst b/Documentation/arch/arm64/cpu-feature-registers.rst
index 44f9bd78539d..253e9743de2f 100644
--- a/Documentation/arch/arm64/cpu-feature-registers.rst
+++ b/Documentation/arch/arm64/cpu-feature-registers.rst
@@ -152,6 +152,8 @@ infrastructure:
      +------------------------------+---------+---------+
      | DIT                          | [51-48] |    y    |
      +------------------------------+---------+---------+
+     | MPAM                         | [43-40] |    n    |
+     +------------------------------+---------+---------+
      | SVE                          | [35-32] |    y    |
      +------------------------------+---------+---------+
      | GIC                          | [27-24] |    n    |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 3e29b44d2d7b..df09537a3b2a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2037,6 +2037,26 @@ config ARM64_TLB_RANGE
 	  The feature introduces new assembly instructions, and they were
 	  support when binutils >= 2.30.
 
+config ARM64_MPAM
+	bool "Enable support for MPAM"
+	help
+	  Memory Partitioning and Monitoring is an optional extension
+	  that allows the CPUs to mark load and store transactions with
+	  labels for partition-id and performance-monitoring-group.
+	  System components, such as the caches, can use the partition-id
+	  to apply a performance policy. MPAM monitors can use the
+	  partition-id and performance-monitoring-group to measure the
+	  cache occupancy or data throughput.
+
+	  Use of this extension requires CPU support, support in the
+	  memory system components (MSC), and a description from firmware
+	  of where the MSC are in the address space.
+
+	  MPAM is exposed to user-space via the resctrl pseudo filesystem.
+
+	  NOTE: This config does not currently expose MPAM to user-space via
+	  resctrl.
+
 endmenu # "ARMv8.4 architectural features"
 
 menu "ARMv8.5 architectural features"
diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index 9b73fd0cd721..81e4157f92b7 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -46,6 +46,7 @@ struct cpuinfo_arm64 {
 	u64		reg_revidr;
 	u64		reg_gmid;
 	u64		reg_smidr;
+	u64		reg_mpamidr;
 
 	u64		reg_id_aa64dfr0;
 	u64		reg_id_aa64dfr1;
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index a6e5b07b64fd..0b51dfcf8a94 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -38,6 +38,8 @@ cpucap_is_possible(const unsigned int cap)
 		return IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI);
 	case ARM64_MTE:
 		return IS_ENABLED(CONFIG_ARM64_MTE);
+	case ARM64_MPAM:
+		return IS_ENABLED(CONFIG_ARM64_MPAM);
 	case ARM64_BTI:
 		return IS_ENABLED(CONFIG_ARM64_BTI);
 	case ARM64_HAS_TLB_RANGE:
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 3d261cc123c1..1abe55e62e63 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -612,6 +612,13 @@ static inline bool id_aa64pfr1_sme(u64 pfr1)
 	return val > 0;
 }
 
+static inline bool id_aa64pfr0_mpam(u64 pfr0)
+{
+	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL1_MPAM_SHIFT);
+
+	return val > 0;
+}
+
 static inline bool id_aa64pfr1_mte(u64 pfr1)
 {
 	u32 val = cpuid_feature_extract_unsigned_field(pfr1, ID_AA64PFR1_EL1_MTE_SHIFT);
@@ -838,6 +845,11 @@ static inline bool system_supports_poe(void)
 		alternative_has_cap_unlikely(ARM64_HAS_S1POE);
 }
 
+static inline bool cpus_support_mpam(void)
+{
+	return alternative_has_cap_unlikely(ARM64_MPAM);
+}
+
 int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
 bool try_emulate_mrs(struct pt_regs *regs, u32 isn);
 
diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
new file mode 100644
index 000000000000..d3ef0b5cd456
--- /dev/null
+++ b/arch/arm64/include/asm/mpam.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021 Arm Ltd. */
+
+#ifndef __ASM__MPAM_H
+#define __ASM__MPAM_H
+
+#include <linux/bitops.h>
+#include <linux/init.h>
+#include <linux/jump_label.h>
+
+#include <asm/cpucaps.h>
+#include <asm/cpufeature.h>
+#include <asm/sysreg.h>
+
+DECLARE_STATIC_KEY_FALSE(arm64_mpam_has_hcr);
+
+/* check whether all CPUs have MPAM virtualisation support */
+static inline bool mpam_cpus_have_mpam_hcr(void)
+{
+	if (IS_ENABLED(CONFIG_ARM64_MPAM))
+		return static_branch_unlikely(&arm64_mpam_has_hcr);
+	return false;
+}
+
+/* enable MPAM virtualisation support */
+static inline void __init __enable_mpam_hcr(void)
+{
+	if (IS_ENABLED(CONFIG_ARM64_MPAM))
+		static_branch_enable(&arm64_mpam_has_hcr);
+}
+
+#endif /* __ASM__MPAM_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 2b112f3b7510..2f60dd957e9c 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -63,10 +63,12 @@ obj-$(CONFIG_KEXEC_CORE)		+= machine_kexec.o relocate_kernel.o	\
 obj-$(CONFIG_KEXEC_FILE)		+= machine_kexec_file.o kexec_image.o
 obj-$(CONFIG_ARM64_RELOC_TEST)		+= arm64-reloc-test.o
 arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
+
 obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
 obj-$(CONFIG_VMCORE_INFO)		+= vmcore_info.o
 obj-$(CONFIG_ARM_SDE_INTERFACE)		+= sdei.o
 obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
+obj-$(CONFIG_ARM64_MPAM)		+= mpam.o
 obj-$(CONFIG_ARM64_MTE)			+= mte.o
 obj-y					+= vdso-wrap.o
 obj-$(CONFIG_COMPAT_VDSO)		+= vdso32-wrap.o
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 718728a85430..f7fd7e3259e4 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -84,6 +84,7 @@
 #include <asm/insn.h>
 #include <asm/kvm_host.h>
 #include <asm/mmu_context.h>
+#include <asm/mpam.h>
 #include <asm/mte.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
@@ -684,6 +685,14 @@ static const struct arm64_ftr_bits ftr_id_dfr1[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_mpamidr[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, MPAMIDR_EL1_PMG_MAX_SHIFT, MPAMIDR_EL1_PMG_MAX_WIDTH, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, MPAMIDR_EL1_VPMR_MAX_SHIFT, MPAMIDR_EL1_VPMR_MAX_WIDTH, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MPAMIDR_EL1_HAS_HCR_SHIFT, 1, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, MPAMIDR_EL1_PARTID_MAX_SHIFT, MPAMIDR_EL1_PARTID_MAX_WIDTH, 0),
+	ARM64_FTR_END,
+};
+
 /*
  * Common ftr bits for a 32bit register with all hidden, strict
  * attributes, with 4bit feature fields and a default safe value of
@@ -804,6 +813,9 @@ static const struct __ftr_reg_entry {
 	ARM64_FTR_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3),
 	ARM64_FTR_REG(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4),
 
+	/* Op1 = 0, CRn = 10, CRm = 4 */
+	ARM64_FTR_REG(SYS_MPAMIDR_EL1, ftr_mpamidr),
+
 	/* Op1 = 1, CRn = 0, CRm = 0 */
 	ARM64_FTR_REG(SYS_GMID_EL1, ftr_gmid),
 
@@ -1163,6 +1175,9 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 		cpacr_restore(cpacr);
 	}
 
+	if (id_aa64pfr0_mpam(info->reg_id_aa64pfr0))
+		init_cpu_ftr_reg(SYS_MPAMIDR_EL1, info->reg_mpamidr);
+
 	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
 		init_cpu_ftr_reg(SYS_GMID_EL1, info->reg_gmid);
 }
@@ -1419,6 +1434,11 @@ void update_cpu_features(int cpu,
 		cpacr_restore(cpacr);
 	}
 
+	if (id_aa64pfr0_mpam(info->reg_id_aa64pfr0)) {
+		taint |= check_update_ftr_reg(SYS_MPAMIDR_EL1, cpu,
+					info->reg_mpamidr, boot->reg_mpamidr);
+	}
+
 	/*
 	 * The kernel uses the LDGM/STGM instructions and the number of tags
 	 * they read/write depends on the GMID_EL1.BS field. Check that the
@@ -2377,6 +2397,39 @@ cpucap_panic_on_conflict(const struct arm64_cpu_capabilities *cap)
 	return !!(cap->type & ARM64_CPUCAP_PANIC_ON_CONFLICT);
 }
 
+static bool __maybe_unused
+test_has_mpam(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	if (!has_cpuid_feature(entry, scope))
+		return false;
+
+	/* Check firmware actually enabled MPAM on this cpu. */
+	return (read_sysreg_s(SYS_MPAM1_EL1) & MPAM1_EL1_MPAMEN);
+}
+
+static void __maybe_unused
+cpu_enable_mpam(const struct arm64_cpu_capabilities *entry)
+{
+	/*
+	 * Access by the kernel (at EL1) should use the reserved PARTID
+	 * which is configured unrestricted. This avoids priority-inversion
+	 * where latency sensitive tasks have to wait for a task that has
+	 * been throttled to release the lock.
+	 */
+	write_sysreg_s(0, SYS_MPAM1_EL1);
+}
+
+static void mpam_extra_caps(void)
+{
+	u64 idr = read_sanitised_ftr_reg(SYS_MPAMIDR_EL1);
+
+	if (!IS_ENABLED(CONFIG_ARM64_MPAM))
+		return;
+
+	if (idr & MPAMIDR_EL1_HAS_HCR)
+		__enable_mpam_hcr();
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.capability = ARM64_ALWAYS_BOOT,
@@ -2872,6 +2925,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 #endif
 #endif
 	},
+#endif
+#ifdef CONFIG_ARM64_MPAM
+	{
+		.desc = "Memory Partitioning And Monitoring",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_MPAM,
+		.matches = test_has_mpam,
+		.cpu_enable = cpu_enable_mpam,
+		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, MPAM, 1)
+	},
 #endif
 	{
 		.desc = "NV1",
@@ -3396,6 +3459,36 @@ static void verify_hyp_capabilities(void)
 	}
 }
 
+static void verify_mpam_capabilities(void)
+{
+	u64 cpu_idr = read_cpuid(ID_AA64PFR0_EL1);
+	u64 sys_idr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+	u16 cpu_partid_max, cpu_pmg_max, sys_partid_max, sys_pmg_max;
+
+	if (FIELD_GET(ID_AA64PFR0_EL1_MPAM_MASK, cpu_idr) !=
+	    FIELD_GET(ID_AA64PFR0_EL1_MPAM_MASK, sys_idr)) {
+		pr_crit("CPU%d: MPAM version mismatch\n", smp_processor_id());
+		cpu_die_early();
+	}
+
+	cpu_idr = read_cpuid(MPAMIDR_EL1);
+	sys_idr = read_sanitised_ftr_reg(SYS_MPAMIDR_EL1);
+	if (FIELD_GET(MPAMIDR_EL1_HAS_HCR, cpu_idr) !=
+	    FIELD_GET(MPAMIDR_EL1_HAS_HCR, sys_idr)) {
+		pr_crit("CPU%d: Missing MPAM HCR\n", smp_processor_id());
+		cpu_die_early();
+	}
+
+	cpu_partid_max = FIELD_GET(MPAMIDR_EL1_PARTID_MAX, cpu_idr);
+	cpu_pmg_max = FIELD_GET(MPAMIDR_EL1_PMG_MAX, cpu_idr);
+	sys_partid_max = FIELD_GET(MPAMIDR_EL1_PARTID_MAX, sys_idr);
+	sys_pmg_max = FIELD_GET(MPAMIDR_EL1_PMG_MAX, sys_idr);
+	if (cpu_partid_max < sys_partid_max || cpu_pmg_max < sys_pmg_max) {
+		pr_crit("CPU%d: MPAM PARTID/PMG max values are mismatched\n", smp_processor_id());
+		cpu_die_early();
+	}
+}
+
 /*
  * Run through the enabled system capabilities and enable() it on this CPU.
  * The capabilities were decided based on the available CPUs at the boot time.
@@ -3422,6 +3515,9 @@ static void verify_local_cpu_capabilities(void)
 
 	if (is_hyp_mode_available())
 		verify_hyp_capabilities();
+
+	if (cpus_support_mpam())
+		verify_mpam_capabilities();
 }
 
 void check_local_cpu_capabilities(void)
@@ -3589,6 +3685,7 @@ void __init setup_user_features(void)
 	}
 
 	minsigstksz_setup();
+	mpam_extra_caps();
 }
 
 static int enable_mismatched_32bit_el0(unsigned int cpu)
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 44718d0482b3..7d134255e7cb 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -478,6 +478,10 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0))
 		__cpuinfo_store_cpu_32bit(&info->aarch32);
 
+	if (IS_ENABLED(CONFIG_ARM64_MPAM) &&
+	    id_aa64pfr0_mpam(info->reg_id_aa64pfr0))
+		info->reg_mpamidr = read_cpuid(MPAMIDR_EL1);
+
 	cpuinfo_detect_icache_policy(info);
 }
 
diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
new file mode 100644
index 000000000000..a29dc58c2da5
--- /dev/null
+++ b/arch/arm64/kernel/mpam.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021 Arm Ltd. */
+
+#include <asm/mpam.h>
+
+#include <linux/jump_label.h>
+
+DEFINE_STATIC_KEY_FALSE(arm64_mpam_has_hcr);
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index eedb5acc21ed..16feb1ac27b7 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -60,6 +60,7 @@ HW_DBM
 KVM_HVHE
 KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
+MPAM
 MTE
 MTE_ASYMM
 SME
-- 
2.25.1

