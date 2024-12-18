Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1591ACEC9
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 10:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734519267; cv=none; b=RssJvvZpijNYfwJO5catIKes1ke0U3GiUBDBZpnN4LW8NtEsfA/19SETel7oijiVRnT8V86HeSp6Uy/Z5TtQz/Uaact2Gp/n04V1HWut9QflmwTn+HYUkRUll197hnfr4cF963tUGt4H8r9+2oq4oj5n3cctccfyKGiow+JZoPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734519267; c=relaxed/simple;
	bh=gSVHgGGt5al7irW8mO8ex6Z3He1xqdxMF/z74lSOWSc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yq5MIgsk42w6THalNlNLONjP73FpDw9StLoWmgq06ohSzSF524pKgunhosYtsFd34ye79p3Wd9gcrDxBrwvrrBqRLG9FJT9xIpiuYpD1yLEE6LEHjW/0DO2NsFV5KaascKgLLTzeZRnvUusNkYE/FPf7QnEIT8WNaMn6fzAsGd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YCrBN62x5z6LD3c;
	Wed, 18 Dec 2024 18:53:16 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 88D9B140B3C;
	Wed, 18 Dec 2024 18:54:21 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.195.247.46) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 18 Dec 2024 11:54:13 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <sebott@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v4 1/3] arm64: Modify _midr_range() functions to read MIDR/REVIDR internally
Date: Wed, 18 Dec 2024 10:53:43 +0000
Message-ID: <20241218105345.73472-2-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20241218105345.73472-1-shameerali.kolothum.thodi@huawei.com>
References: <20241218105345.73472-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 frapeml500008.china.huawei.com (7.182.85.71)

These changes lay the groundwork for adding support for guest kernels,
allowing them to leverage target CPU implementations provided by the
VMM.

No functional changes intended.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/cputype.h     | 28 ++++++++++++++--------------
 arch/arm64/include/asm/mmu.h         |  3 +--
 arch/arm64/kernel/cpu_errata.c       | 23 +++++++++++++----------
 arch/arm64/kernel/cpufeature.c       |  6 +++---
 arch/arm64/kernel/proton-pack.c      | 17 ++++++++---------
 arch/arm64/kvm/vgic/vgic-v3.c        |  2 +-
 drivers/clocksource/arm_arch_timer.c |  2 +-
 7 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 488f8e751349..dcf0e1ce892d 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -229,6 +229,16 @@
 
 #define read_cpuid(reg)			read_sysreg_s(SYS_ ## reg)
 
+/*
+ * The CPU ID never changes at run time, so we might as well tell the
+ * compiler that it's constant.  Use this function to read the CPU ID
+ * rather than directly reading processor_id or read_cpuid() directly.
+ */
+static inline u32 __attribute_const__ read_cpuid_id(void)
+{
+	return read_cpuid(MIDR_EL1);
+}
+
 /*
  * Represent a range of MIDR values for a given CPU model and a
  * range of variant/revision values.
@@ -264,31 +274,21 @@ static inline bool midr_is_cpu_model_range(u32 midr, u32 model, u32 rv_min,
 	return _model == model && rv >= rv_min && rv <= rv_max;
 }
 
-static inline bool is_midr_in_range(u32 midr, struct midr_range const *range)
+static inline bool is_midr_in_range(struct midr_range const *range)
 {
-	return midr_is_cpu_model_range(midr, range->model,
+	return midr_is_cpu_model_range(read_cpuid_id(), range->model,
 				       range->rv_min, range->rv_max);
 }
 
 static inline bool
-is_midr_in_range_list(u32 midr, struct midr_range const *ranges)
+is_midr_in_range_list(struct midr_range const *ranges)
 {
 	while (ranges->model)
-		if (is_midr_in_range(midr, ranges++))
+		if (is_midr_in_range(ranges++))
 			return true;
 	return false;
 }
 
-/*
- * The CPU ID never changes at run time, so we might as well tell the
- * compiler that it's constant.  Use this function to read the CPU ID
- * rather than directly reading processor_id or read_cpuid() directly.
- */
-static inline u32 __attribute_const__ read_cpuid_id(void)
-{
-	return read_cpuid(MIDR_EL1);
-}
-
 static inline u64 __attribute_const__ read_cpuid_mpidr(void)
 {
 	return read_cpuid(MPIDR_EL1);
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 2ec96d91acc6..bfd303e074be 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -101,8 +101,7 @@ static inline bool kaslr_requires_kpti(void)
 	if (IS_ENABLED(CONFIG_CAVIUM_ERRATUM_27456)) {
 		extern const struct midr_range cavium_erratum_27456_cpus[];
 
-		if (is_midr_in_range_list(read_cpuid_id(),
-					  cavium_erratum_27456_cpus))
+		if (is_midr_in_range_list(cavium_erratum_27456_cpus))
 			return false;
 	}
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a78f247029ae..929685c00263 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -15,30 +15,34 @@
 #include <asm/smp_plat.h>
 
 static bool __maybe_unused
-is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
+__is_affected_midr_range(const struct arm64_cpu_capabilities *entry,
+			 u32 midr, u32 revidr)
 {
 	const struct arm64_midr_revidr *fix;
-	u32 midr = read_cpuid_id(), revidr;
-
-	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
-	if (!is_midr_in_range(midr, &entry->midr_range))
+	if (!is_midr_in_range(&entry->midr_range))
 		return false;
 
 	midr &= MIDR_REVISION_MASK | MIDR_VARIANT_MASK;
-	revidr = read_cpuid(REVIDR_EL1);
 	for (fix = entry->fixed_revs; fix && fix->revidr_mask; fix++)
 		if (midr == fix->midr_rv && (revidr & fix->revidr_mask))
 			return false;
-
 	return true;
 }
 
+static bool __maybe_unused
+is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+	return __is_affected_midr_range(entry, read_cpuid_id(),
+					read_cpuid(REVIDR_EL1));
+}
+
 static bool __maybe_unused
 is_affected_midr_range_list(const struct arm64_cpu_capabilities *entry,
 			    int scope)
 {
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
-	return is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list);
+	return is_midr_in_range_list(entry->midr_range_list);
 }
 
 static bool __maybe_unused
@@ -186,12 +190,11 @@ static bool __maybe_unused
 has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
 				int scope)
 {
-	u32 midr = read_cpuid_id();
 	bool has_dic = read_cpuid_cachetype() & BIT(CTR_EL0_DIC_SHIFT);
 	const struct midr_range range = MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1);
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
-	return is_midr_in_range(midr, &range) && has_dic;
+	return is_midr_in_range(&range) && has_dic;
 }
 
 #ifdef CONFIG_ARM64_WORKAROUND_REPEAT_TLBI
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6ce71f444ed8..4cc4ae16b28d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1783,7 +1783,7 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 	char const *str = "kpti command line option";
 	bool meltdown_safe;
 
-	meltdown_safe = is_midr_in_range_list(read_cpuid_id(), kpti_safe_list);
+	meltdown_safe = is_midr_in_range_list(kpti_safe_list);
 
 	/* Defer to CPU feature registers */
 	if (has_cpuid_feature(entry, scope))
@@ -1853,7 +1853,7 @@ static bool has_nv1(const struct arm64_cpu_capabilities *entry, int scope)
 
 	return (__system_matches_cap(ARM64_HAS_NESTED_VIRT) &&
 		!(has_cpuid_feature(entry, scope) ||
-		  is_midr_in_range_list(read_cpuid_id(), nv1_ni_list)));
+		  is_midr_in_range_list(nv1_ni_list)));
 }
 
 #if defined(ID_AA64MMFR0_EL1_TGRAN_LPA2) && defined(ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2)
@@ -2036,7 +2036,7 @@ static bool cpu_has_broken_dbm(void)
 		{},
 	};
 
-	return is_midr_in_range_list(read_cpuid_id(), cpus);
+	return is_midr_in_range_list(cpus);
 }
 
 static bool cpu_can_use_dbm(const struct arm64_cpu_capabilities *cap)
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index da53722f95d4..a573fa40d4b6 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -172,7 +172,7 @@ static enum mitigation_state spectre_v2_get_cpu_hw_mitigation_state(void)
 		return SPECTRE_UNAFFECTED;
 
 	/* Alternatively, we have a list of unaffected CPUs */
-	if (is_midr_in_range_list(read_cpuid_id(), spectre_v2_safe_list))
+	if (is_midr_in_range_list(spectre_v2_safe_list))
 		return SPECTRE_UNAFFECTED;
 
 	return SPECTRE_VULNERABLE;
@@ -331,7 +331,7 @@ bool has_spectre_v3a(const struct arm64_cpu_capabilities *entry, int scope)
 	};
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
-	return is_midr_in_range_list(read_cpuid_id(), spectre_v3a_unsafe_list);
+	return is_midr_in_range_list(spectre_v3a_unsafe_list);
 }
 
 void spectre_v3a_enable_mitigation(const struct arm64_cpu_capabilities *__unused)
@@ -475,7 +475,7 @@ static enum mitigation_state spectre_v4_get_cpu_hw_mitigation_state(void)
 		{ /* sentinel */ },
 	};
 
-	if (is_midr_in_range_list(read_cpuid_id(), spectre_v4_safe_list))
+	if (is_midr_in_range_list(spectre_v4_safe_list))
 		return SPECTRE_UNAFFECTED;
 
 	/* CPU features are detected first */
@@ -878,13 +878,13 @@ u8 spectre_bhb_loop_affected(int scope)
 			{},
 		};
 
-		if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k32_list))
+		if (is_midr_in_range_list(spectre_bhb_k32_list))
 			k = 32;
-		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k24_list))
+		else if (is_midr_in_range_list(spectre_bhb_k24_list))
 			k = 24;
-		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k11_list))
+		else if (is_midr_in_range_list(spectre_bhb_k11_list))
 			k = 11;
-		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k8_list))
+		else if (is_midr_in_range_list(spectre_bhb_k8_list))
 			k =  8;
 
 		max_bhb_k = max(max_bhb_k, k);
@@ -926,8 +926,7 @@ static bool is_spectre_bhb_fw_affected(int scope)
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
 		{},
 	};
-	bool cpu_in_list = is_midr_in_range_list(read_cpuid_id(),
-					 spectre_bhb_firmware_mitigated_list);
+	bool cpu_in_list = is_midr_in_range_list(spectre_bhb_firmware_mitigated_list);
 
 	if (scope != SCOPE_LOCAL_CPU)
 		return system_affected;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index f267bc2486a1..b815d910c7e4 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -632,7 +632,7 @@ static const struct midr_range broken_seis[] = {
 static bool vgic_v3_broken_seis(void)
 {
 	return ((kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK) &&
-		is_midr_in_range_list(read_cpuid_id(), broken_seis));
+		is_midr_in_range_list(broken_seis));
 }
 
 /**
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 808f259781fd..981a578043a5 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -842,7 +842,7 @@ static u64 __arch_timer_check_delta(void)
 		{},
 	};
 
-	if (is_midr_in_range_list(read_cpuid_id(), broken_cval_midrs)) {
+	if (is_midr_in_range_list(broken_cval_midrs)) {
 		pr_warn_once("Broken CNTx_CVAL_EL1, using 31 bit TVAL instead.\n");
 		return CLOCKSOURCE_MASK(31);
 	}
-- 
2.47.0

