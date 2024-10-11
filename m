Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BA0207217
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 07:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728633131; cv=none; b=U4pxQXd2i9DwwhsNVC2bbY7dXL+1oaUbD8LrfKSNYNrk7WksppbCNSnDWJJACbquVf4rITSNdExsJBPJBoBSsGL6ZF83b7xPas6N+xQGpd+7SFdLfOPyNPVesv0zMMSQ4Glt9sP/2Ol91KIa4o2+kiKywS7q/ATmyH+SjWmQQrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728633131; c=relaxed/simple;
	bh=zr64RB52Q2Ij77JGBXYzre2L5Rv9dzO1P2OLhx/+XXY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=avJ9nImRtXhrSyEo7JnzJsqYoLbPxGjV/bieOaRGijZM4dwwEink+vpa7wgBxyHGV+4cr2/TkWtxBjyp1o5tpzl3JPlWOkmGyIBa/7foDbF0h8900q0WyIc8Q2vCV/NgDoGkK2PxHqSpeIXv3sJg1/sbTG/OpgRNzerTX14URt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XPzNH3nD9z6JB4V;
	Fri, 11 Oct 2024 15:51:43 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 641F3140A78;
	Fri, 11 Oct 2024 15:52:06 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 11 Oct 2024 09:51:59 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [RFC PATCH 1/6] arm64: Modify callback matches() fn to take a target info
Date: Fri, 11 Oct 2024 08:50:48 +0100
Message-ID: <20241011075053.80540-2-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 frapeml500008.china.huawei.com (7.182.85.71)

In preparation of identifying the errata associated with a particular
target CPU, modify the matches fn to take a target pointer. For
capabilities representing system features, this is not used and
named as __unused. In subsequent patches, errata workarounds matches
function will make use of  the target pointer instead of the
read_cpuid_id() to check the cpu model.

No functional changes intended.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/cpufeature.h |  7 ++-
 arch/arm64/include/asm/spectre.h    |  8 +--
 arch/arm64/kernel/cpu_errata.c      | 19 +++---
 arch/arm64/kernel/cpufeature.c      | 97 +++++++++++++++++------------
 arch/arm64/kernel/proton-pack.c     | 13 ++--
 5 files changed, 82 insertions(+), 62 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 3d261cc123c1..c7b1d3ae469e 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -335,7 +335,8 @@ struct arm64_cpu_capabilities {
 	const char *desc;
 	u16 capability;
 	u16 type;
-	bool (*matches)(const struct arm64_cpu_capabilities *caps, int scope);
+	bool (*matches)(const struct arm64_cpu_capabilities *caps, int scope,
+			void *target);
 	/*
 	 * Take the appropriate actions to configure this capability
 	 * for this CPU. If the capability is detected by the kernel
@@ -398,12 +399,12 @@ static inline int cpucap_default_scope(const struct arm64_cpu_capabilities *cap)
  */
 static inline bool
 cpucap_multi_entry_cap_matches(const struct arm64_cpu_capabilities *entry,
-			       int scope)
+			       int scope, void *target)
 {
 	const struct arm64_cpu_capabilities *caps;
 
 	for (caps = entry->match_list; caps->matches; caps++)
-		if (caps->matches(caps, scope))
+		if (caps->matches(caps, scope, target))
 			return true;
 
 	return false;
diff --git a/arch/arm64/include/asm/spectre.h b/arch/arm64/include/asm/spectre.h
index 0c4d9045c31f..295de6a08bc2 100644
--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -82,21 +82,21 @@ static __always_inline void arm64_apply_bp_hardening(void)
 }
 
 enum mitigation_state arm64_get_spectre_v2_state(void);
-bool has_spectre_v2(const struct arm64_cpu_capabilities *cap, int scope);
+bool has_spectre_v2(const struct arm64_cpu_capabilities *cap, int scope, void *target);
 void spectre_v2_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 
-bool has_spectre_v3a(const struct arm64_cpu_capabilities *cap, int scope);
+bool has_spectre_v3a(const struct arm64_cpu_capabilities *cap, int scope, void *target);
 void spectre_v3a_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 
 enum mitigation_state arm64_get_spectre_v4_state(void);
-bool has_spectre_v4(const struct arm64_cpu_capabilities *cap, int scope);
+bool has_spectre_v4(const struct arm64_cpu_capabilities *cap, int scope, void *target);
 void spectre_v4_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 void spectre_v4_enable_task_mitigation(struct task_struct *tsk);
 
 enum mitigation_state arm64_get_meltdown_state(void);
 
 enum mitigation_state arm64_get_spectre_bhb_state(void);
-bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
+bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope, void *target);
 u8 spectre_bhb_loop_affected(int scope);
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 bool try_emulate_el1_ssbs(struct pt_regs *regs, u32 instr);
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index dfefbdf4073a..37464f100a21 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -15,7 +15,8 @@
 #include <asm/smp_plat.h>
 
 static bool __maybe_unused
-is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
+is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope,
+		       void *target)
 {
 	const struct arm64_midr_revidr *fix;
 	u32 midr = read_cpuid_id(), revidr;
@@ -35,14 +36,14 @@ is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
 
 static bool __maybe_unused
 is_affected_midr_range_list(const struct arm64_cpu_capabilities *entry,
-			    int scope)
+			    int scope, void *target)
 {
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 	return is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list);
 }
 
 static bool __maybe_unused
-is_kryo_midr(const struct arm64_cpu_capabilities *entry, int scope)
+is_kryo_midr(const struct arm64_cpu_capabilities *entry, int scope, void *target)
 {
 	u32 model;
 
@@ -57,7 +58,7 @@ is_kryo_midr(const struct arm64_cpu_capabilities *entry, int scope)
 
 static bool
 has_mismatched_cache_type(const struct arm64_cpu_capabilities *entry,
-			  int scope)
+			  int scope, void *__unused)
 {
 	u64 mask = arm64_ftr_reg_ctrel0.strict_mask;
 	u64 sys = arm64_ftr_reg_ctrel0.sys_val & mask;
@@ -109,9 +110,9 @@ cpu_enable_trap_ctr_access(const struct arm64_cpu_capabilities *cap)
 #ifdef CONFIG_ARM64_ERRATUM_1463225
 static bool
 has_cortex_a76_erratum_1463225(const struct arm64_cpu_capabilities *entry,
-			       int scope)
+			       int scope, void *target)
 {
-	return is_affected_midr_range_list(entry, scope) && is_kernel_in_hyp_mode();
+	return is_affected_midr_range_list(entry, scope, target) && is_kernel_in_hyp_mode();
 }
 #endif
 
@@ -166,11 +167,11 @@ static const __maybe_unused struct midr_range tx2_family_cpus[] = {
 
 static bool __maybe_unused
 needs_tx2_tvm_workaround(const struct arm64_cpu_capabilities *entry,
-			 int scope)
+			 int scope, void *target)
 {
 	int i;
 
-	if (!is_affected_midr_range_list(entry, scope) ||
+	if (!is_affected_midr_range_list(entry, scope, target) ||
 	    !is_hyp_mode_available())
 		return false;
 
@@ -184,7 +185,7 @@ needs_tx2_tvm_workaround(const struct arm64_cpu_capabilities *entry,
 
 static bool __maybe_unused
 has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
-				int scope)
+				int scope, void *target)
 {
 	u32 midr = read_cpuid_id();
 	bool has_dic = read_cpuid_cachetype() & BIT(CTR_EL0_DIC_SHIFT);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 718728a85430..ac0cff5ab09d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1538,7 +1538,7 @@ u64 __read_sysreg_by_encoding(u32 sys_id)
 #include <linux/irqchip/arm-gic-v3.h>
 
 static bool
-has_always(const struct arm64_cpu_capabilities *entry, int scope)
+has_always(const struct arm64_cpu_capabilities *entry, int scope, void *__unused)
 {
 	return true;
 }
@@ -1581,7 +1581,8 @@ read_scoped_sysreg(const struct arm64_cpu_capabilities *entry, int scope)
 }
 
 static bool
-has_user_cpuid_feature(const struct arm64_cpu_capabilities *entry, int scope)
+has_user_cpuid_feature(const struct arm64_cpu_capabilities *entry, int scope,
+		       void *__unused)
 {
 	int mask;
 	struct arm64_ftr_reg *regp;
@@ -1601,7 +1602,8 @@ has_user_cpuid_feature(const struct arm64_cpu_capabilities *entry, int scope)
 }
 
 static bool
-has_cpuid_feature(const struct arm64_cpu_capabilities *entry, int scope)
+has_cpuid_feature(const struct arm64_cpu_capabilities *entry, int scope,
+		  void *__unused)
 {
 	u64 val = read_scoped_sysreg(entry, scope);
 	return feature_matches(val, entry);
@@ -1651,9 +1653,10 @@ static int __init aarch32_el0_sysfs_init(void)
 }
 device_initcall(aarch32_el0_sysfs_init);
 
-static bool has_32bit_el0(const struct arm64_cpu_capabilities *entry, int scope)
+static bool has_32bit_el0(const struct arm64_cpu_capabilities *entry, int scope,
+			  void *__unused)
 {
-	if (!has_cpuid_feature(entry, scope))
+	if (!has_cpuid_feature(entry, scope, NULL))
 		return allow_mismatched_32bit_el0;
 
 	if (scope == SCOPE_SYSTEM)
@@ -1662,11 +1665,12 @@ static bool has_32bit_el0(const struct arm64_cpu_capabilities *entry, int scope)
 	return true;
 }
 
-static bool has_useable_gicv3_cpuif(const struct arm64_cpu_capabilities *entry, int scope)
+static bool has_useable_gicv3_cpuif(const struct arm64_cpu_capabilities *entry, int scope,
+				    void *__unused)
 {
 	bool has_sre;
 
-	if (!has_cpuid_feature(entry, scope))
+	if (!has_cpuid_feature(entry, scope, NULL))
 		return false;
 
 	has_sre = gic_enable_sre();
@@ -1678,7 +1682,7 @@ static bool has_useable_gicv3_cpuif(const struct arm64_cpu_capabilities *entry,
 }
 
 static bool has_cache_idc(const struct arm64_cpu_capabilities *entry,
-			  int scope)
+			  int scope, void *__unused)
 {
 	u64 ctr;
 
@@ -1703,7 +1707,7 @@ static void cpu_emulate_effective_ctr(const struct arm64_cpu_capabilities *__unu
 }
 
 static bool has_cache_dic(const struct arm64_cpu_capabilities *entry,
-			  int scope)
+			  int scope, void *__unused)
 {
 	u64 ctr;
 
@@ -1716,7 +1720,8 @@ static bool has_cache_dic(const struct arm64_cpu_capabilities *entry,
 }
 
 static bool __maybe_unused
-has_useable_cnp(const struct arm64_cpu_capabilities *entry, int scope)
+has_useable_cnp(const struct arm64_cpu_capabilities *entry, int scope,
+		void *__unused)
 {
 	/*
 	 * Kdump isn't guaranteed to power-off all secondary CPUs, CNP
@@ -1729,14 +1734,14 @@ has_useable_cnp(const struct arm64_cpu_capabilities *entry, int scope)
 	if (cpus_have_cap(ARM64_WORKAROUND_NVIDIA_CARMEL_CNP))
 		return false;
 
-	return has_cpuid_feature(entry, scope);
+	return has_cpuid_feature(entry, scope, NULL);
 }
 
 static bool __meltdown_safe = true;
 static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 
 static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
-				int scope)
+				int scope, void *__unused)
 {
 	/* List of CPUs that are not vulnerable and don't need KPTI */
 	static const struct midr_range kpti_safe_list[] = {
@@ -1763,7 +1768,7 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 	meltdown_safe = is_midr_in_range_list(read_cpuid_id(), kpti_safe_list);
 
 	/* Defer to CPU feature registers */
-	if (has_cpuid_feature(entry, scope))
+	if (has_cpuid_feature(entry, scope, NULL))
 		meltdown_safe = true;
 
 	if (!meltdown_safe)
@@ -1811,7 +1816,8 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 	return !meltdown_safe;
 }
 
-static bool has_nv1(const struct arm64_cpu_capabilities *entry, int scope)
+static bool has_nv1(const struct arm64_cpu_capabilities *entry, int scope,
+		    void *__unused)
 {
 	/*
 	 * Although the Apple M2 family appears to support NV1, the
@@ -1829,7 +1835,7 @@ static bool has_nv1(const struct arm64_cpu_capabilities *entry, int scope)
 	};
 
 	return (__system_matches_cap(ARM64_HAS_NESTED_VIRT) &&
-		!(has_cpuid_feature(entry, scope) ||
+		!(has_cpuid_feature(entry, scope, NULL) ||
 		  is_midr_in_range_list(read_cpuid_id(), nv1_ni_list)));
 }
 
@@ -1852,7 +1858,8 @@ static bool has_lpa2_at_stage2(u64 mmfr0)
 	return tgran == ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2;
 }
 
-static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope)
+static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope,
+		     void *__unused)
 {
 	u64 mmfr0;
 
@@ -1860,7 +1867,8 @@ static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope)
 	return has_lpa2_at_stage1(mmfr0) && has_lpa2_at_stage2(mmfr0);
 }
 #else
-static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope)
+static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope,
+		     void *__unused)
 {
 	return false;
 }
@@ -2018,7 +2026,7 @@ static bool cpu_has_broken_dbm(void)
 
 static bool cpu_can_use_dbm(const struct arm64_cpu_capabilities *cap)
 {
-	return has_cpuid_feature(cap, SCOPE_LOCAL_CPU) &&
+	return has_cpuid_feature(cap, SCOPE_LOCAL_CPU, NULL) &&
 	       !cpu_has_broken_dbm();
 }
 
@@ -2031,7 +2039,7 @@ static void cpu_enable_hw_dbm(struct arm64_cpu_capabilities const *cap)
 }
 
 static bool has_hw_dbm(const struct arm64_cpu_capabilities *cap,
-		       int __unused)
+		       int __unused, void *__unused2)
 {
 	/*
 	 * DBM is a non-conflicting feature. i.e, the kernel can safely
@@ -2071,7 +2079,7 @@ int get_cpu_with_amu_feat(void)
 
 static void cpu_amu_enable(struct arm64_cpu_capabilities const *cap)
 {
-	if (has_cpuid_feature(cap, SCOPE_LOCAL_CPU)) {
+	if (has_cpuid_feature(cap, SCOPE_LOCAL_CPU, NULL)) {
 		cpumask_set_cpu(smp_processor_id(), &amu_cpus);
 
 		/* 0 reference values signal broken/disabled counters */
@@ -2081,7 +2089,7 @@ static void cpu_amu_enable(struct arm64_cpu_capabilities const *cap)
 }
 
 static bool has_amu(const struct arm64_cpu_capabilities *cap,
-		    int __unused)
+		    int __unused, void *__unused2)
 {
 	/*
 	 * The AMU extension is a non-conflicting feature: the kernel can
@@ -2105,7 +2113,8 @@ int get_cpu_with_amu_feat(void)
 }
 #endif
 
-static bool runs_at_el2(const struct arm64_cpu_capabilities *entry, int __unused)
+static bool runs_at_el2(const struct arm64_cpu_capabilities *entry, int __unused,
+			void *__unused2)
 {
 	return is_kernel_in_hyp_mode();
 }
@@ -2125,12 +2134,12 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
 }
 
 static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
-				    int scope)
+				    int scope, void *__unused)
 {
 	if (kvm_get_mode() != KVM_MODE_NV)
 		return false;
 
-	if (!has_cpuid_feature(cap, scope)) {
+	if (!has_cpuid_feature(cap, scope, NULL)) {
 		pr_warn("unavailable: %s\n", cap->desc);
 		return false;
 	}
@@ -2139,7 +2148,7 @@ static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
 }
 
 static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
-			  int __unused)
+			  int __unused, void *__unused2)
 {
 	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
 }
@@ -2167,7 +2176,8 @@ static void cpu_clear_disr(const struct arm64_cpu_capabilities *__unused)
 #endif /* CONFIG_ARM64_RAS_EXTN */
 
 #ifdef CONFIG_ARM64_PTR_AUTH
-static bool has_address_auth_cpucap(const struct arm64_cpu_capabilities *entry, int scope)
+static bool has_address_auth_cpucap(const struct arm64_cpu_capabilities *entry, int scope,
+				    void *__unused)
 {
 	int boot_val, sec_val;
 
@@ -2194,17 +2204,20 @@ static bool has_address_auth_cpucap(const struct arm64_cpu_capabilities *entry,
 }
 
 static bool has_address_auth_metacap(const struct arm64_cpu_capabilities *entry,
-				     int scope)
+				     int scope, void *__unused)
 {
-	bool api = has_address_auth_cpucap(cpucap_ptrs[ARM64_HAS_ADDRESS_AUTH_IMP_DEF], scope);
-	bool apa = has_address_auth_cpucap(cpucap_ptrs[ARM64_HAS_ADDRESS_AUTH_ARCH_QARMA5], scope);
-	bool apa3 = has_address_auth_cpucap(cpucap_ptrs[ARM64_HAS_ADDRESS_AUTH_ARCH_QARMA3], scope);
+	bool api = has_address_auth_cpucap(cpucap_ptrs[ARM64_HAS_ADDRESS_AUTH_IMP_DEF],
+					   scope, NULL);
+	bool apa = has_address_auth_cpucap(cpucap_ptrs[ARM64_HAS_ADDRESS_AUTH_ARCH_QARMA5],
+					   scope, NULL);
+	bool apa3 = has_address_auth_cpucap(cpucap_ptrs[ARM64_HAS_ADDRESS_AUTH_ARCH_QARMA3], scope,
+					    NULL);
 
 	return apa || apa3 || api;
 }
 
 static bool has_generic_auth(const struct arm64_cpu_capabilities *entry,
-			     int __unused)
+			     int __unused, void *__unused2)
 {
 	bool gpi = __system_matches_cap(ARM64_HAS_GENERIC_AUTH_IMP_DEF);
 	bool gpa = __system_matches_cap(ARM64_HAS_GENERIC_AUTH_ARCH_QARMA5);
@@ -2224,7 +2237,7 @@ static void cpu_enable_e0pd(struct arm64_cpu_capabilities const *cap)
 
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 static bool can_use_gic_priorities(const struct arm64_cpu_capabilities *entry,
-				   int scope)
+				   int scope, void *__unused)
 {
 	/*
 	 * ARM64_HAS_GIC_CPUIF_SYSREGS has a lower index, and is a boot CPU
@@ -2238,7 +2251,7 @@ static bool can_use_gic_priorities(const struct arm64_cpu_capabilities *entry,
 }
 
 static bool has_gic_prio_relaxed_sync(const struct arm64_cpu_capabilities *entry,
-				      int scope)
+				      int scope, void *__unused)
 {
 	/*
 	 * If we're not using priority masking then we won't be poking PMR_EL1,
@@ -2329,7 +2342,8 @@ static void elf_hwcap_fixup(void)
 }
 
 #ifdef CONFIG_KVM
-static bool is_kvm_protected_mode(const struct arm64_cpu_capabilities *entry, int __unused)
+static bool is_kvm_protected_mode(const struct arm64_cpu_capabilities *entry, int __unused,
+				  void *__unused2)
 {
 	return kvm_get_mode() == KVM_MODE_PROTECTED;
 }
@@ -3061,7 +3075,8 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 };
 
 #ifdef CONFIG_COMPAT
-static bool compat_has_neon(const struct arm64_cpu_capabilities *cap, int scope)
+static bool compat_has_neon(const struct arm64_cpu_capabilities *cap, int scope,
+			    void *__unused)
 {
 	/*
 	 * Check that all of MVFR1_EL1.{SIMDSP, SIMDInt, SIMDLS} are available,
@@ -3156,7 +3171,7 @@ static void setup_elf_hwcaps(const struct arm64_cpu_capabilities *hwcaps)
 	/* We support emulation of accesses to CPU ID feature registers */
 	cpu_set_named_feature(CPUID);
 	for (; hwcaps->matches; hwcaps++)
-		if (hwcaps->matches(hwcaps, cpucap_default_scope(hwcaps)))
+		if (hwcaps->matches(hwcaps, cpucap_default_scope(hwcaps), NULL))
 			cap_set_elf_hwcap(hwcaps);
 }
 
@@ -3170,7 +3185,7 @@ static void update_cpu_capabilities(u16 scope_mask)
 		caps = cpucap_ptrs[i];
 		if (!caps || !(caps->type & scope_mask) ||
 		    cpus_have_cap(caps->capability) ||
-		    !caps->matches(caps, cpucap_default_scope(caps)))
+		    !caps->matches(caps, cpucap_default_scope(caps), NULL))
 			continue;
 
 		if (caps->desc && !caps->cpus)
@@ -3268,7 +3283,7 @@ static void verify_local_cpu_caps(u16 scope_mask)
 		if (!caps || !(caps->type & scope_mask))
 			continue;
 
-		cpu_has_cap = caps->matches(caps, SCOPE_LOCAL_CPU);
+		cpu_has_cap = caps->matches(caps, SCOPE_LOCAL_CPU, NULL);
 		system_has_cap = cpus_have_cap(caps->capability);
 
 		if (system_has_cap) {
@@ -3324,7 +3339,7 @@ __verify_local_elf_hwcaps(const struct arm64_cpu_capabilities *caps)
 {
 
 	for (; caps->matches; caps++)
-		if (cpus_have_elf_hwcap(caps) && !caps->matches(caps, SCOPE_LOCAL_CPU)) {
+		if (cpus_have_elf_hwcap(caps) && !caps->matches(caps, SCOPE_LOCAL_CPU, NULL)) {
 			pr_crit("CPU%d: missing HWCAP: %s\n",
 					smp_processor_id(), caps->desc);
 			cpu_die_early();
@@ -3450,7 +3465,7 @@ bool this_cpu_has_cap(unsigned int n)
 		const struct arm64_cpu_capabilities *cap = cpucap_ptrs[n];
 
 		if (cap)
-			return cap->matches(cap, SCOPE_LOCAL_CPU);
+			return cap->matches(cap, SCOPE_LOCAL_CPU, NULL);
 	}
 
 	return false;
@@ -3468,7 +3483,7 @@ static bool __maybe_unused __system_matches_cap(unsigned int n)
 		const struct arm64_cpu_capabilities *cap = cpucap_ptrs[n];
 
 		if (cap)
-			return cap->matches(cap, SCOPE_SYSTEM);
+			return cap->matches(cap, SCOPE_SYSTEM, NULL);
 	}
 	return false;
 }
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index da53722f95d4..671b412b0634 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -199,7 +199,8 @@ static enum mitigation_state spectre_v2_get_cpu_fw_mitigation_state(void)
 	}
 }
 
-bool has_spectre_v2(const struct arm64_cpu_capabilities *entry, int scope)
+bool has_spectre_v2(const struct arm64_cpu_capabilities *entry, int scope,
+		    void *__unused)
 {
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 
@@ -322,7 +323,8 @@ void spectre_v2_enable_mitigation(const struct arm64_cpu_capabilities *__unused)
  * an indirect trampoline for the hyp vectors so that guests can't read
  * VBAR_EL2 to defeat randomisation of the hypervisor VA layout.
  */
-bool has_spectre_v3a(const struct arm64_cpu_capabilities *entry, int scope)
+bool has_spectre_v3a(const struct arm64_cpu_capabilities *entry, int scope,
+		     void *target)
 {
 	static const struct midr_range spectre_v3a_unsafe_list[] = {
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
@@ -508,7 +510,8 @@ static enum mitigation_state spectre_v4_get_cpu_fw_mitigation_state(void)
 	}
 }
 
-bool has_spectre_v4(const struct arm64_cpu_capabilities *cap, int scope)
+bool has_spectre_v4(const struct arm64_cpu_capabilities *cap, int scope,
+		    void *__unused)
 {
 	enum mitigation_state state;
 
@@ -955,7 +958,7 @@ static bool supports_ecbhb(int scope)
 }
 
 bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry,
-			     int scope)
+			     int scope, void *__unused)
 {
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 
@@ -1005,7 +1008,7 @@ void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *entry)
 	enum mitigation_state fw_state, state = SPECTRE_VULNERABLE;
 	struct bp_hardening_data *data = this_cpu_ptr(&bp_hardening_data);
 
-	if (!is_spectre_bhb_affected(entry, SCOPE_LOCAL_CPU))
+	if (!is_spectre_bhb_affected(entry, SCOPE_LOCAL_CPU, NULL))
 		return;
 
 	if (arm64_get_spectre_v2_state() == SPECTRE_VULNERABLE) {
-- 
2.45.2

