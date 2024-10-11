Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EE7209F46
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 07:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728633148; cv=none; b=mS6xM6cg78pNrwhbBk/Q+s6byUeff+IPJeCmlri5zb4Lv/YSo+isu4bqwehnaCgx+z4FrnJCcp3MzZTBaUk7VO39QC0egBVLYcrEpeyTG2FJTI/wq5eaNccdwvUHnvlhABIOkxHQ6EI86HRFDPCWbAII2OU5/k4jwPJLstFnBek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728633148; c=relaxed/simple;
	bh=9+fuovLpJeDsRZaXl/Z0o4Rs3PL6hm4SBBgfMsAZ3x0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SRBe8pjEyUNE/K11FPquPNHRSWdxjsw/WD0J8zJ+62xdUrFbd83ZDwfhmehbDhT+ZUJ7K7lAn1i/BF7BSKfJUArH6jIhtFtK0MbiHusFXOp6bfSjktNTc3cFZG6KU57vBZCIh98v+xTS/w77vc2tWmFAdo8qqTnBNVucUlcixK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XPzNc5cnbz6JB3Y;
	Fri, 11 Oct 2024 15:52:00 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id A28B61401DC;
	Fri, 11 Oct 2024 15:52:23 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 11 Oct 2024 09:52:16 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [RFC PATCH 3/6] KVM: arm64: Introduce a helper to retrieve errata
Date: Fri, 11 Oct 2024 08:50:50 +0100
Message-ID: <20241011075053.80540-4-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 frapeml500008.china.huawei.com (7.182.85.71)

And update the errata matches functions to use the target CPU values if
it is set.

Also introduce a "migration_safe_cap" to capabilities structure.
This should be a statically allocated constant for any migration safe errata.
This is because the existing "capability" value is a generated one and may
be renumbered and reordered, hence cannot be used to set the bits in
migration errata bitmap.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/cpufeature.h |  8 ++++
 arch/arm64/kernel/cpu_errata.c      | 60 ++++++++++++++++++++++++-----
 arch/arm64/kernel/cpufeature.c      | 14 +++++++
 3 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index c7b1d3ae469e..eada7b9ac4ff 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -335,6 +335,13 @@ struct arm64_cpu_capabilities {
 	const char *desc;
 	u16 capability;
 	u16 type;
+	/*
+	 * For Erratum only. This should be a static enum value separate from the
+	 * above generated capability value for this erratum. A non-zero value
+	 * here indicates whether this can be safely enabled for migration purposes
+	 * for a specified target CPU.
+	 */
+	u16 migration_safe_cap;
 	bool (*matches)(const struct arm64_cpu_capabilities *caps, int scope,
 			void *target);
 	/*
@@ -625,6 +632,7 @@ void __init setup_system_features(void);
 void __init setup_user_features(void);
 
 void check_local_cpu_capabilities(void);
+void arm_get_migrn_errata_map(void *migrn, unsigned long *errata_map);
 
 u64 read_sanitised_ftr_reg(u32 id);
 u64 __read_sysreg_by_encoding(u32 sys_id);
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 37464f100a21..e0acb473312d 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -8,6 +8,7 @@
 #include <linux/arm-smccc.h>
 #include <linux/types.h>
 #include <linux/cpu.h>
+#include <linux/kvm.h>
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/cpufeature.h>
@@ -19,14 +20,26 @@ is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope,
 		       void *target)
 {
 	const struct arm64_midr_revidr *fix;
-	u32 midr = read_cpuid_id(), revidr;
+	struct migrn_target_cpu *t_cpu = target;
+	u32 midr, revidr;
+
+	if (t_cpu) {
+		midr = t_cpu->midr;
+	} else {
+		WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+		midr = read_cpuid_id();
+	}
 
-	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 	if (!is_midr_in_range(midr, &entry->midr_range))
 		return false;
 
 	midr &= MIDR_REVISION_MASK | MIDR_VARIANT_MASK;
-	revidr = read_cpuid(REVIDR_EL1);
+
+	if (t_cpu)
+		revidr = t_cpu->revidr;
+	else
+		revidr = read_cpuid(REVIDR_EL1);
+
 	for (fix = entry->fixed_revs; fix && fix->revidr_mask; fix++)
 		if (midr == fix->midr_rv && (revidr & fix->revidr_mask))
 			return false;
@@ -38,18 +51,31 @@ static bool __maybe_unused
 is_affected_midr_range_list(const struct arm64_cpu_capabilities *entry,
 			    int scope, void *target)
 {
-	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
-	return is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list);
+	struct migrn_target_cpu *t_cpu = target;
+	u32 midr;
+
+	if (t_cpu) {
+		midr = t_cpu->midr;
+	} else {
+		WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+		midr = read_cpuid_id();
+	}
+	return is_midr_in_range_list(midr, entry->midr_range_list);
 }
 
 static bool __maybe_unused
 is_kryo_midr(const struct arm64_cpu_capabilities *entry, int scope, void *target)
 {
+	struct migrn_target_cpu *t_cpu = target;
 	u32 model;
 
-	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+	if (t_cpu) {
+		model = t_cpu->midr;
+	} else {
+		WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+		model = read_cpuid_id();
+	}
 
-	model = read_cpuid_id();
 	model &= MIDR_IMPLEMENTOR_MASK | (0xf00 << MIDR_PARTNUM_SHIFT) |
 		 MIDR_ARCHITECTURE_MASK;
 
@@ -187,11 +213,25 @@ static bool __maybe_unused
 has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
 				int scope, void *target)
 {
-	u32 midr = read_cpuid_id();
-	bool has_dic = read_cpuid_cachetype() & BIT(CTR_EL0_DIC_SHIFT);
+	struct migrn_target_cpu *t_cpu = target;
+	u32 midr;
+	bool has_dic;
+
+	if (t_cpu) {
+		midr = t_cpu->midr;
+		/*
+		 * TBD: Should we pass CTR_EL0 as well? or treat this
+		 * as not safe for migration? For now set this as false.
+		 */
+		has_dic = false;
+	} else {
+		WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+		midr = read_cpuid_id();
+		has_dic = read_cpuid_cachetype() & BIT(CTR_EL0_DIC_SHIFT);
+	}
+
 	const struct midr_range range = MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1);
 
-	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 	return is_midr_in_range(midr, &range) && has_dic;
 }
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ac0cff5ab09d..7b39b0a4aadd 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3175,6 +3175,20 @@ static void setup_elf_hwcaps(const struct arm64_cpu_capabilities *hwcaps)
 			cap_set_elf_hwcap(hwcaps);
 }
 
+void arm_get_migrn_errata_map(void *target, unsigned long *errata_map)
+{
+	int i;
+	const struct arm64_cpu_capabilities *caps;
+
+	for (i = 0; i < ARM64_NCAPS; i++) {
+		caps = cpucap_ptrs[i];
+		if (!caps || !caps->migration_safe_cap ||
+		    !caps->matches(caps, cpucap_default_scope(caps), target))
+			continue;
+		__set_bit(caps->migration_safe_cap, errata_map);
+	}
+}
+
 static void update_cpu_capabilities(u16 scope_mask)
 {
 	int i;
-- 
2.45.2

