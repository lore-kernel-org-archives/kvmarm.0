Return-Path: <SRS0=poro=PD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C65CC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 16:15:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A065561053
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 16:15:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A065561053
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 419974B12E;
	Fri, 15 Oct 2021 12:15:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6wMSJh49R8L4; Fri, 15 Oct 2021 12:15:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 902B04B190;
	Fri, 15 Oct 2021 12:15:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B16B84B11F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 12:15:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T+7Nk0jGyb+n for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 12:14:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 921204B12F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 12:14:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D86D1515;
 Fri, 15 Oct 2021 09:14:56 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 82D593F66F;
 Fri, 15 Oct 2021 09:14:55 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 6/7] KVM: arm64: Configure PBHA bits for stage2
Date: Fri, 15 Oct 2021 16:14:15 +0000
Message-Id: <20211015161416.2196-7-james.morse@arm.com>
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

There are two conflicting use-cases for PBHA at stage2. We could copy
the stage1 PBHA bits to stage2, this would ensure the VMMs memory is
exactly reproduced for the guest, including the PBHA bits. The problem
here is how the VMM's memory is allocated with the PBHA bits set.

The other is allowing the guest to configure PBHA directly. This would
allow guest device drivers to map memory with the appropriate PBHA bits.
This would only be safe if the guest can be trusted to only generate
PBHA values that only affect performance.

The arm-arm doesn't describe how the stage1 and stage2 bits are combined.
Arm's implementations appear to all have the same behaviour, according
to the TRM: stage2 wins.

For these CPUs, we can allow a guest to use a PBHA bit by disabling it
in VTCR_EL2. We just need to know which bits...

The DT describes the values that only affect performance, but if value-5
is safe for use, we can't prevent the guest from using value-1 and value-4.
These 'decomposed' values would also need to be listed as only affecting
performance.

Add a cpufeature for CPUs that have this 'stage2 wins' behaviour.
Decompose each performance-only value (5 -> 5, 4, 1), and check each of
these values is listed as only affecting performance. If so, the bits
of the original value (5) can be used by the guest at stage1. (by clearing
the bits from VTCR_EL2)

Signed-off-by: James Morse <james.morse@arm.com>
---
I've checked the TRMs for the listed CPUs.
There are more, I've asked for the TRMs to always describe this.
---
 arch/arm64/include/asm/cpufeature.h |   1 +
 arch/arm64/include/asm/cputype.h    |   4 ++
 arch/arm64/kernel/cpufeature.c      | 105 ++++++++++++++++++++++++++++
 arch/arm64/kernel/image-vars.h      |   3 +
 arch/arm64/kvm/hyp/pgtable.c        |   8 ++-
 arch/arm64/tools/cpucaps            |   1 +
 6 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ef6be92b1921..ec800ce15308 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -101,6 +101,7 @@ struct arm64_ftr_reg {
 };
 
 extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
+extern unsigned long arm64_pbha_stage2_safe_bits;
 
 /*
  * CPU capabilities:
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 6231e1f0abe7..4d7f18749d23 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -73,6 +73,8 @@
 #define ARM_CPU_PART_CORTEX_A76		0xD0B
 #define ARM_CPU_PART_NEOVERSE_N1	0xD0C
 #define ARM_CPU_PART_CORTEX_A77		0xD0D
+#define ARM_CPU_PART_CORTEX_A78		0xD41
+#define ARM_CPU_PART_CORTEX_X1		0xD44
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -113,6 +115,8 @@
 #define MIDR_CORTEX_A76	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76)
 #define MIDR_NEOVERSE_N1 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N1)
 #define MIDR_CORTEX_A77	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A77)
+#define MIDR_CORTEX_A78	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78)
+#define MIDR_CORTEX_X1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 88f0f805b938..ad2b3b179ab1 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -77,6 +77,7 @@
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
+#include <asm/cputype.h>
 #include <asm/fpsimd.h>
 #include <asm/insn.h>
 #include <asm/kvm_host.h>
@@ -113,6 +114,7 @@ EXPORT_SYMBOL(arm64_use_ng_mappings);
 
 unsigned long __ro_after_init arm64_pbha_perf_only_values;
 EXPORT_SYMBOL(arm64_pbha_perf_only_values);
+unsigned long __ro_after_init arm64_pbha_stage2_safe_bits;
 
 /*
  * Permit PER_LINUX32 and execve() of 32-bit binaries even if not all CPUs
@@ -1680,13 +1682,50 @@ static bool has_hw_dbm(const struct arm64_cpu_capabilities *cap,
 
 #endif
 
+
 #ifdef CONFIG_ARM64_PBHA
 static u8 pbha_stage1_enable_bits;
+static DEFINE_SPINLOCK(pbha_dt_lock);
+
+/* For the value 5, return a bitmap with bits 5, 4, and 1 set. */
+static unsigned long decompose_pbha_values(u8 val)
+{
+	int i;
+	unsigned long mask = 0;
+
+	for (i = 1; i <= 15; i++) {
+		if ((i & val) == i)
+			set_bit(i, &mask);
+	}
+
+	return mask;
+}
+
+/*
+ * The bits of a value are safe if all values that can be built from those
+ * enabled bits are listed as only affecting performance.
+ * e.g. 5 would also need 1 and 4 to be listed.
+ *
+ * When there is a conflict with the bits already enabled, the new value is
+ * skipped.
+ * e.g. if 5 already caused bit-0 and bit-2 to be enabled, adding 3 to the list
+ * would need to test 7 as bit-2 is already enabled. If 7 is not listed, 3 is
+ * skipped and bit-1 is not enabled.
+ */
+static void stage2_test_pbha_value(u8 val)
+{
+	unsigned long mask;
+
+	mask = decompose_pbha_values(val | arm64_pbha_stage2_safe_bits);
+	if ((arm64_pbha_perf_only_values & mask) == mask)
+		arm64_pbha_stage2_safe_bits |= val;
+}
 
 static bool plat_can_use_pbha_stage1(const struct arm64_cpu_capabilities *cap,
 				     int scope)
 {
 	u8 val;
+	static bool dt_check_done;
 	struct device_node *cpus;
 	const u8 *perf_only_vals;
 	int num_perf_only_vals, i;
@@ -1702,6 +1741,10 @@ static bool plat_can_use_pbha_stage1(const struct arm64_cpu_capabilities *cap,
 	if (scope == SCOPE_LOCAL_CPU)
 		return true;
 
+	spin_lock(&pbha_dt_lock);
+	if (dt_check_done)
+		goto out_unlock;
+
 	cpus = of_find_node_by_path("/cpus");
 	if (!cpus)
 		goto done;
@@ -1721,9 +1764,24 @@ static bool plat_can_use_pbha_stage1(const struct arm64_cpu_capabilities *cap,
 		set_bit(val, &arm64_pbha_perf_only_values);
 	}
 
+	/*
+	 * for stage2 the values are collapsed back to 4 bits that can only
+	 * enable values in the arm64_pbha_perf_only_values mask.
+	 */
+	for (i = 0 ; i < num_perf_only_vals; i++) {
+		val = perf_only_vals[i];
+		if (val > 0xf)
+			continue;
+
+		stage2_test_pbha_value(val);
+	}
+
 done:
 	of_node_put(cpus);
+	dt_check_done = true;
 
+out_unlock:
+	spin_unlock(&pbha_dt_lock);
 	return !!pbha_stage1_enable_bits;
 }
 
@@ -1743,6 +1801,47 @@ static void cpu_enable_pbha(struct arm64_cpu_capabilities const *cap)
 	isb();
 	local_flush_tlb_all();
 }
+
+/*
+ * PBHA's behaviour is implementation defined, as is the way it combines
+ * stage1 and stage2 attributes. If the kernel has KVM supported, and booted
+ * at EL2, only these CPUs can allow PBHA in a guest, as KVM knows how the PBHA
+ * bits are combined. This prevents the host being affected by some
+ * implementation defined behaviour from the guest.
+ *
+ * The TRM for these CPUs describe stage2 as overriding stage1.
+ */
+static const struct midr_range pbha_stage2_wins[] = {
+	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A76),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A77),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A78),
+	{},
+};
+
+static bool plat_can_use_pbha_stage2(const struct arm64_cpu_capabilities *cap,
+				     int scope)
+{
+	/*  Booted at EL2? */
+	if (!is_hyp_mode_available() && !is_kernel_in_hyp_mode())
+		return false;
+
+	if (!is_midr_in_range_list(read_cpuid_id(), cap->midr_range_list))
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
+	if (!__system_matches_cap(ARM64_HAS_PBHA_STAGE1))
+		return false;
+
+	return !!arm64_pbha_stage2_safe_bits;
+}
 #endif /* CONFIG_ARM64_PBHA */
 
 #ifdef CONFIG_ARM64_AMU_EXTN
@@ -2418,6 +2517,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = 2,
 		.cpu_enable = cpu_enable_pbha,
 	},
+	{
+		.capability = ARM64_HAS_PBHA_STAGE2,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = plat_can_use_pbha_stage2,
+		.midr_range_list = pbha_stage2_wins,
+	},
 #endif
 	{},
 };
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index c96a9a0043bf..d6abdc53f4d9 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -134,6 +134,9 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
 /* pKVM static key */
 KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
 
+/* PBHA bits for stage2 */
+KVM_NVHE_ALIAS(arm64_pbha_stage2_safe_bits);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 7bd90ea1c61f..c0bfef55a1ff 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -520,7 +520,7 @@ struct stage2_map_data {
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 {
 	u64 vtcr = VTCR_EL2_FLAGS;
-	u8 lvls;
+	u8 lvls, pbha = 0xf;
 
 	vtcr |= kvm_get_parange(mmfr0) << VTCR_EL2_PS_SHIFT;
 	vtcr |= VTCR_EL2_T0SZ(phys_shift);
@@ -545,9 +545,13 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	 * value will always be 0, which is defined as the safe default
 	 * setting. On Cortex cores, enabling PBHA for stage2 effectively
 	 * disables it for stage1.
+	 * When the HAS_PBHA_STAGE2 feature is supported, clear the 'safe'
+	 * bits to allow the guest's stage1 to use these bits.
 	 */
+	if (cpus_have_final_cap(ARM64_HAS_PBHA_STAGE2))
+		pbha = pbha ^ arm64_pbha_stage2_safe_bits;
 	if (cpus_have_final_cap(ARM64_HAS_PBHA))
-		vtcr = FIELD_PREP(VTCR_EL2_PBHA_MASK, 0xf);
+		vtcr = FIELD_PREP(VTCR_EL2_PBHA_MASK, pbha);
 
 	/* Set the vmid bits */
 	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 8dacca5f7c40..c561c20d556a 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -30,6 +30,7 @@ HAS_NO_HW_PREFETCH
 HAS_PAN
 HAS_PBHA
 HAS_PBHA_STAGE1
+HAS_PBHA_STAGE2
 HAS_RAS_EXTN
 HAS_RNG
 HAS_SB
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
