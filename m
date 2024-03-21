Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF969B673
	for <kvmarm@lists.linux.dev>; Thu, 21 Mar 2024 16:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711040268; cv=none; b=gUQz/ZEhHxl6MpEabazFSshBZnLc/0qlvUXtwh/pNYwrRIb015d2nP6py1faUtCi+jeQSCVJ5bEjK12virOMIpB663Fvdwv692tht6rn77DgXIxxeiPboNrUtrmjJ3kB6lH8aD3M/SgnyZDeAZBTx5AJQwMcwWn3ggJhFMPxpow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711040268; c=relaxed/simple;
	bh=wYTXYMzZxG1vUkXPmsSvJVsgNCvvn/oaW5jA7+bqrsg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B4inbHpplh6vSPql4knIsjfKAAHukAaV+YqRsefBDXJ9Lk05o2/5nqbJDKhGsMFetHBUI2T50LYaDmIAq4gXZW0wy3BqptGvAypu1xv5+H1Rr6Qfrj1hujP4dD6HRPwmvXPRc1BbjLswB6ssLj2cxKATL0v7CtMeKyASOjweUI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 975911688;
	Thu, 21 Mar 2024 09:58:20 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C50B03F67D;
	Thu, 21 Mar 2024 09:57:44 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	James Morse <james.morse@arm.com>
Subject: [PATCH v3 2/6] arm64: cpufeature: discover CPU support for MPAM
Date: Thu, 21 Mar 2024 16:57:24 +0000
Message-Id: <20240321165728.31907-3-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240321165728.31907-1-james.morse@arm.com>
References: <20240321165728.31907-1-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 .../arch/arm64/cpu-feature-registers.rst      |   2 +
 arch/arm64/Kconfig                            |  19 +++-
 arch/arm64/include/asm/cpu.h                  |   1 +
 arch/arm64/include/asm/cpufeature.h           |  13 +++
 arch/arm64/include/asm/mpam.h                 |  75 +++++++++++++
 arch/arm64/include/asm/sysreg.h               |   8 ++
 arch/arm64/kernel/Makefile                    |   2 +
 arch/arm64/kernel/cpufeature.c                | 104 ++++++++++++++++++
 arch/arm64/kernel/cpuinfo.c                   |   4 +
 arch/arm64/kernel/mpam.c                      |   8 ++
 arch/arm64/tools/cpucaps                      |   1 +
 arch/arm64/tools/sysreg                       |  32 ++++++
 12 files changed, 268 insertions(+), 1 deletion(-)
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
index 77e05d4959f2..a7b01adbd3df 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1977,7 +1977,24 @@ config ARM64_TLB_RANGE
 	  The feature introduces new assembly instructions, and they were
 	  support when binutils >= 2.30.
 
-endmenu # "ARMv8.4 architectural features"
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
+endmenu
 
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
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 8b904a757bd3..c7006fb6a30a 100644
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
@@ -832,6 +839,12 @@ static inline bool system_supports_lpa2(void)
 	return cpus_have_final_cap(ARM64_HAS_LPA2);
 }
 
+static inline bool cpus_support_mpam(void)
+{
+	return IS_ENABLED(CONFIG_ARM64_MPAM) &&
+		cpus_have_final_cap(ARM64_MPAM);
+}
+
 int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
 bool try_emulate_mrs(struct pt_regs *regs, u32 isn);
 
diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
new file mode 100644
index 000000000000..bae662107082
--- /dev/null
+++ b/arch/arm64/include/asm/mpam.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2024 Arm Ltd. */
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
+/* CPU Registers */
+#define MPAM_SYSREG_EN			BIT_ULL(63)
+#define MPAM_SYSREG_TRAP_IDR		BIT_ULL(58)
+#define MPAM_SYSREG_TRAP_MPAM0_EL1	BIT_ULL(49)
+#define MPAM_SYSREG_TRAP_MPAM1_EL1	BIT_ULL(48)
+#define MPAM_SYSREG_PMG_D		GENMASK(47, 40)
+#define MPAM_SYSREG_PMG_I		GENMASK(39, 32)
+#define MPAM_SYSREG_PARTID_D		GENMASK(31, 16)
+#define MPAM_SYSREG_PARTID_I		GENMASK(15, 0)
+
+#define MPAMIDR_PMG_MAX			GENMASK(40, 32)
+#define MPAMIDR_PMG_MAX_SHIFT		32
+#define MPAMIDR_PMG_MAX_LEN		8
+#define MPAMIDR_VPMR_MAX		GENMASK(20, 18)
+#define MPAMIDR_VPMR_MAX_SHIFT		18
+#define MPAMIDR_VPMR_MAX_LEN		3
+#define MPAMIDR_HAS_HCR			BIT(17)
+#define MPAMIDR_HAS_HCR_SHIFT		17
+#define MPAMIDR_PARTID_MAX		GENMASK(15, 0)
+#define MPAMIDR_PARTID_MAX_SHIFT	0
+#define MPAMIDR_PARTID_MAX_LEN		15
+
+#define MPAMHCR_EL0_VPMEN		BIT_ULL(0)
+#define MPAMHCR_EL1_VPMEN		BIT_ULL(1)
+#define MPAMHCR_GSTAPP_PLK		BIT_ULL(8)
+#define MPAMHCR_TRAP_MPAMIDR		BIT_ULL(31)
+
+/* Properties of the VPM registers */
+#define MPAM_VPM_NUM_REGS		8
+#define MPAM_VPM_PARTID_LEN		16
+#define MPAM_VPM_PARTID_MASK		0xffff
+#define MPAM_VPM_REG_LEN		64
+#define MPAM_VPM_PARTIDS_PER_REG	(MPAM_VPM_REG_LEN / MPAM_VPM_PARTID_LEN)
+#define MPAM_VPM_MAX_PARTID		(MPAM_VPM_NUM_REGS * MPAM_VPM_PARTIDS_PER_REG)
+
+DECLARE_STATIC_KEY_FALSE(arm64_mpam_has_hcr);
+
+/* check whether all CPUs have MPAM support */
+static inline bool mpam_cpus_have_feature(void)
+{
+	if (IS_ENABLED(CONFIG_ARM64_MPAM))
+		return cpus_have_final_cap(ARM64_MPAM);
+	return false;
+}
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
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 9e8999592f3a..dc34681ff4ef 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -535,6 +535,13 @@
 #define SYS_MPAMVPM6_EL2		__SYS__MPAMVPMx_EL2(6)
 #define SYS_MPAMVPM7_EL2		__SYS__MPAMVPMx_EL2(7)
 
+#define SYS_MPAMHCR_EL2			sys_reg(3, 4, 10, 4, 0)
+#define SYS_MPAMVPMV_EL2		sys_reg(3, 4, 10, 4, 1)
+#define SYS_MPAM2_EL2			sys_reg(3, 4, 10, 5, 0)
+
+#define __VPMn_op2(n)			((n) & 0x7)
+#define SYS_MPAM_VPMn_EL2(n)		sys_reg(3, 4, 10, 6, __VPMn_op2(n))
+
 #define SYS_VBAR_EL2			sys_reg(3, 4, 12, 0, 0)
 #define SYS_RVBAR_EL2			sys_reg(3, 4, 12, 0, 1)
 #define SYS_RMR_EL2			sys_reg(3, 4, 12, 0, 2)
@@ -622,6 +629,7 @@
 #define SYS_PMSCR_EL12			sys_reg(3, 5, 9, 9, 0)
 #define SYS_MAIR_EL12			sys_reg(3, 5, 10, 2, 0)
 #define SYS_AMAIR_EL12			sys_reg(3, 5, 10, 3, 0)
+#define SYS_MPAM1_EL12			sys_reg(3, 5, 10, 5, 0)
 #define SYS_VBAR_EL12			sys_reg(3, 5, 12, 0, 0)
 #define SYS_CONTEXTIDR_EL12		sys_reg(3, 5, 13, 0, 1)
 #define SYS_SCXTNUM_EL12		sys_reg(3, 5, 13, 0, 7)
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 763824963ed1..c790c67d3bc9 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -64,10 +64,12 @@ obj-$(CONFIG_KEXEC_CORE)		+= machine_kexec.o relocate_kernel.o	\
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
index 56583677c1f2..0d9216395d85 100644
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
@@ -681,6 +682,18 @@ static const struct arm64_ftr_bits ftr_id_dfr1[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_mpamidr[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE,
+		MPAMIDR_PMG_MAX_SHIFT, MPAMIDR_PMG_MAX_LEN, 0),        /* PMG_MAX */
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE,
+		MPAMIDR_VPMR_MAX_SHIFT, MPAMIDR_VPMR_MAX_LEN, 0),      /* VPMR_MAX */
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE,
+		MPAMIDR_HAS_HCR_SHIFT, 1, 0), /* HAS_HCR */
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE,
+		MPAMIDR_PARTID_MAX_SHIFT, MPAMIDR_PARTID_MAX_LEN, 0),  /* PARTID_MAX */
+	ARM64_FTR_END,
+};
+
 /*
  * Common ftr bits for a 32bit register with all hidden, strict
  * attributes, with 4bit feature fields and a default safe value of
@@ -801,6 +814,9 @@ static const struct __ftr_reg_entry {
 	ARM64_FTR_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3),
 	ARM64_FTR_REG(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4),
 
+	/* Op1 = 0, CRn = 10, CRm = 4 */
+	ARM64_FTR_REG(SYS_MPAMIDR_EL1, ftr_mpamidr),
+
 	/* Op1 = 1, CRn = 0, CRm = 0 */
 	ARM64_FTR_REG(SYS_GMID_EL1, ftr_gmid),
 
@@ -1160,6 +1176,9 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 		cpacr_restore(cpacr);
 	}
 
+	if (id_aa64pfr0_mpam(info->reg_id_aa64pfr0))
+		init_cpu_ftr_reg(SYS_MPAMIDR_EL1, info->reg_mpamidr);
+
 	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
 		init_cpu_ftr_reg(SYS_GMID_EL1, info->reg_gmid);
 }
@@ -1416,6 +1435,11 @@ void update_cpu_features(int cpu,
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
@@ -2358,6 +2382,42 @@ cpucap_panic_on_conflict(const struct arm64_cpu_capabilities *cap)
 	return !!(cap->type & ARM64_CPUCAP_PANIC_ON_CONFLICT);
 }
 
+static bool __maybe_unused
+test_has_mpam(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	if (!has_cpuid_feature(entry, scope))
+		return false;
+
+	/* Check firmware actually enabled MPAM on this cpu. */
+	return (read_sysreg_s(SYS_MPAM1_EL1) & MPAM_SYSREG_EN);
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
+
+	/* Until resctrl is supported, user-space should be unrestricted too. */
+	write_sysreg_s(0, SYS_MPAM0_EL1);
+}
+
+static void mpam_extra_caps(void)
+{
+	u64 idr = read_sanitised_ftr_reg(SYS_MPAMIDR_EL1);
+
+	if (!IS_ENABLED(CONFIG_ARM64_MPAM))
+		return;
+
+	if (idr & MPAMIDR_HAS_HCR)
+		__enable_mpam_hcr();
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.capability = ARM64_ALWAYS_BOOT,
@@ -2852,6 +2912,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, TGRAN16, 52_BIT)
 #endif
 #endif
+#endif
+#ifdef CONFIG_ARM64_MPAM
+	{
+		.desc = "Memory Partitioning And Monitoring",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_MPAM,
+		.matches = test_has_mpam,
+		.cpu_enable = cpu_enable_mpam,
+		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, MPAM, 1)
 	},
 #endif
 	{
@@ -3364,6 +3433,37 @@ static void verify_hyp_capabilities(void)
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
+	if ((cpu_partid_max < sys_partid_max) || (cpu_pmg_max < sys_pmg_max)) {
+		pr_crit("CPU%d: MPAM PARTID/PMG max values are mismatched\n",
+			smp_processor_id());
+		cpu_die_early();
+	}
+}
+
 /*
  * Run through the enabled system capabilities and enable() it on this CPU.
  * The capabilities were decided based on the available CPUs at the boot time.
@@ -3390,6 +3490,9 @@ static void verify_local_cpu_capabilities(void)
 
 	if (is_hyp_mode_available())
 		verify_hyp_capabilities();
+
+	if (cpus_support_mpam())
+		verify_mpam_capabilities();
 }
 
 void check_local_cpu_capabilities(void)
@@ -3557,6 +3660,7 @@ void __init setup_user_features(void)
 	}
 
 	minsigstksz_setup();
+	mpam_extra_caps();
 }
 
 static int enable_mismatched_32bit_el0(unsigned int cpu)
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 09eeaa24d456..4a4cfe496bb6 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -477,6 +477,10 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
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
index 000000000000..0c49bafc46bf
--- /dev/null
+++ b/arch/arm64/kernel/mpam.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2024 Arm Ltd. */
+
+#include <asm/mpam.h>
+
+#include <linux/jump_label.h>
+
+DEFINE_STATIC_KEY_FALSE(arm64_mpam_has_hcr);
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 62b2838a231a..2685cfa8376c 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -59,6 +59,7 @@ HW_DBM
 KVM_HVHE
 KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
+MPAM
 MTE
 MTE_ASYMM
 SME
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index a4c1dd4741a4..8bc1ce34587f 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2911,6 +2911,22 @@ Res0	1
 Field	0	EN
 EndSysreg
 
+Sysreg	MPAMIDR_EL1	3	0	10	4	4
+Res0	63:62
+Field	61	HAS_SDEFLT
+Field	60	HAS_FORCE_NS
+Field	59	SP4
+Field	58	HAS_TIDR
+Field	57	HAS_ALTSP
+Res0	56:40
+Field	39:32	PMG_MAX
+Res0	31:21
+Field	20:18	VPMR_MAX
+Field	17	HAS_HCR
+Res0	16
+Field	15:0	PARTID_MAX
+EndSysreg
+
 Sysreg	LORID_EL1	3	0	10	4	7
 Res0	63:24
 Field	23:16	LD
@@ -2918,6 +2934,22 @@ Res0	15:8
 Field	7:0	LR
 EndSysreg
 
+Sysreg	MPAM1_EL1	3	0	10	5	0
+Res0	63:48
+Field	47:40	PMG_D
+Field	39:32	PMG_I
+Field	31:16	PARTID_D
+Field	15:0	PARTID_I
+EndSysreg
+
+Sysreg	MPAM0_EL1	3	0	10	5	1
+Res0	63:48
+Field	47:40	PMG_D
+Field	39:32	PMG_I
+Field	31:16	PARTID_D
+Field	15:0	PARTID_I
+EndSysreg
+
 Sysreg	ISR_EL1	3	0	12	1	0
 Res0	63:11
 Field	10	IS
-- 
2.39.2

