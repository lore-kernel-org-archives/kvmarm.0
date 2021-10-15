Return-Path: <SRS0=poro=PD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0465C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 16:14:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3C73E611F0
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 16:14:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3C73E611F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAC554B162;
	Fri, 15 Oct 2021 12:14:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id elpxB2qYq3CG; Fri, 15 Oct 2021 12:14:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36AE74B176;
	Fri, 15 Oct 2021 12:14:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F7864B12E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 12:14:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PhinP-3LoXPe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 12:14:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 323054B161
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 12:14:54 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8774414BF;
 Fri, 15 Oct 2021 09:14:53 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB4F73F66F;
 Fri, 15 Oct 2021 09:14:52 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 4/7] arm64: cpufeature: Enable PBHA bits for stage1
Date: Fri, 15 Oct 2021 16:14:13 +0000
Message-Id: <20211015161416.2196-5-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211015161416.2196-1-james.morse@arm.com>
References: <20211015161416.2196-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

If the CPUs support HPDS2, and there is a DT description of PBHA values
that only affect performance, enable those bits for both TTBR0 and TTBR1.

Enabling PBHA requires the hierarchical-permissions to be disabled.
Commit 87143f404f33 ("arm64: mm: use XN table mapping attributes for
the linear region") used these, but only as an optimisation.

Only the necessary PBHA bits are enabled to reduce the risk of an
unsafe bit/value being used by accident.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/Kconfig                     | 13 +++++
 arch/arm64/include/asm/pgtable-hwdef.h |  4 ++
 arch/arm64/kernel/cpufeature.c         | 81 ++++++++++++++++++++++++++
 arch/arm64/tools/cpucaps               |  1 +
 4 files changed, 99 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 077f2ec4eeb2..9196bb932aba 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1461,6 +1461,19 @@ config ARM64_CNP
 	  at runtime, and does not affect PEs that do not implement
 	  this feature.
 
+config ARM64_PBHA
+	bool "Enable support for Page Based Hardware Attributes (PBHA)"
+	default n
+	help
+	  Page Based Hardware Attributes (PBHA) allow the SoC hardware to
+	  change behaviour depending on which mapping was used to access
+	  a page of memory. e.g. access via one mapping may always result
+	  in the data being cached, whereas using another mapping of the same
+	  physical memory.
+
+	  The behaviour of each PBHA bit is not defined. Say no unless you
+	  are very sure you want this
+
 endmenu
 
 menu "ARMv8.3 architectural features"
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 40085e53f573..3d41242c52b0 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -268,6 +268,10 @@
 #define TCR_TBI1		(UL(1) << 38)
 #define TCR_HA			(UL(1) << 39)
 #define TCR_HD			(UL(1) << 40)
+#define TCR_HPD0		(UL(1) << 41)
+#define TCR_HPD1		(UL(1) << 42)
+#define TCR_HWU0nn_MASK		(UL(0xf) << 43)
+#define TCR_HWU1nn_MASK		(UL(0xf) << 47)
 #define TCR_TBID1		(UL(1) << 52)
 #define TCR_NFD0		(UL(1) << 53)
 #define TCR_NFD1		(UL(1) << 54)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 8694f9dec5e5..548c6f96a878 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -71,6 +71,7 @@
 #include <linux/types.h>
 #include <linux/minmax.h>
 #include <linux/mm.h>
+#include <linux/of.h>
 #include <linux/cpu.h>
 #include <linux/kasan.h>
 #include <asm/cpu.h>
@@ -110,6 +111,8 @@ DECLARE_BITMAP(boot_capabilities, ARM64_NPATCHABLE);
 bool arm64_use_ng_mappings = false;
 EXPORT_SYMBOL(arm64_use_ng_mappings);
 
+unsigned long __ro_after_init arm64_pbha_perf_only_values;
+
 /*
  * Permit PER_LINUX32 and execve() of 32-bit binaries even if not all CPUs
  * support it?
@@ -1676,6 +1679,71 @@ static bool has_hw_dbm(const struct arm64_cpu_capabilities *cap,
 
 #endif
 
+#ifdef CONFIG_ARM64_PBHA
+static u8 pbha_stage1_enable_bits;
+
+static bool plat_can_use_pbha_stage1(const struct arm64_cpu_capabilities *cap,
+				     int scope)
+{
+	u8 val;
+	struct device_node *cpus;
+	const u8 *perf_only_vals;
+	int num_perf_only_vals, i;
+
+	if (!has_cpuid_feature(cap, scope))
+		return false;
+
+	/*
+	 * Calls with scope == SCOPE_LOCAL_CPU need only testing whether this
+	 * cpu has the feature. A later 'system' scope call will check for a
+	 * firmware description.
+	 */
+	if (scope == SCOPE_LOCAL_CPU)
+		return true;
+
+	cpus = of_find_node_by_path("/cpus");
+	if (!cpus)
+		goto done;
+
+	perf_only_vals = of_get_property(cpus, "arm,pbha-performance-only",
+					 &num_perf_only_vals);
+	if (!perf_only_vals)
+		goto done;
+
+	/* any listed value is usable at stage 1 */
+	for (i = 0 ; i < num_perf_only_vals; i++) {
+		val = perf_only_vals[i];
+		if (val > 0xf)
+			continue;
+
+		pbha_stage1_enable_bits |= val;
+		set_bit(val, &arm64_pbha_perf_only_values);
+	}
+
+done:
+	of_node_put(cpus);
+
+	return !!pbha_stage1_enable_bits;
+}
+
+static void cpu_enable_pbha(struct arm64_cpu_capabilities const *cap)
+{
+	u64 tcr;
+
+	if (!pbha_stage1_enable_bits)
+		return;
+
+	tcr = read_sysreg(tcr_el1);
+	tcr |= FIELD_PREP(TCR_HWU0nn_MASK, pbha_stage1_enable_bits);
+	tcr |= FIELD_PREP(TCR_HWU1nn_MASK, pbha_stage1_enable_bits);
+	tcr |= FIELD_PREP(TCR_HPD0, 1) | FIELD_PREP(TCR_HPD1, 1);
+
+	write_sysreg(tcr, tcr_el1);
+	isb();
+	local_flush_tlb_all();
+}
+#endif /* CONFIG_ARM64_PBHA */
+
 #ifdef CONFIG_ARM64_AMU_EXTN
 
 /*
@@ -2337,6 +2405,19 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.min_field_value = 2,
 	},
+#ifdef CONFIG_ARM64_PBHA
+	{
+		.desc = "Page Based Hardware Attributes (PBHA)",
+		.capability = ARM64_HAS_PBHA_STAGE1,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64MMFR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR1_HPD_SHIFT,
+		.matches = plat_can_use_pbha_stage1,
+		.min_field_value = 2,
+		.cpu_enable = cpu_enable_pbha,
+	},
+#endif
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 132596d8b518..8dacca5f7c40 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -29,6 +29,7 @@ HAS_NO_FPSIMD
 HAS_NO_HW_PREFETCH
 HAS_PAN
 HAS_PBHA
+HAS_PBHA_STAGE1
 HAS_RAS_EXTN
 HAS_RNG
 HAS_SB
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
