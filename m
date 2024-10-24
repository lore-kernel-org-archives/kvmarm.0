Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670551714B0
	for <kvmarm@lists.linux.dev>; Thu, 24 Oct 2024 09:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729762864; cv=none; b=HG8CMrldeSJtjoXbFTOFRHeUe09kfDt6PrYynkpac+igVN80BwX2CLMwImwNDeV0k5xpYUoWhOhbd2rroNBFOjb8lTTa4d72PCmAFpnKTAZ/6lKhzz7EsY9vREsgH3q6hb48/Eh8+eGMEQrQ2LnRaipEXbatHwcfIxQEBiRtHHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729762864; c=relaxed/simple;
	bh=7euuQ3BYnb/j0LpjW6f6Wlb0bHZuiOY6Y2KNVXYbGyE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NFw7X6Vmt9Ru2Sjb4uotKVlKaypDz2dD4HSLdcCb3Hl1s4mDqw+muBSTctrJQqm5am9RuxWsdJ8o34PFS5xMfFn3UkjoeDGuGkjfJC49aCULDCeNo7qLEWQHcuFMBKVbj2okmgpg9ryDc4VMfHlnhy6sKYyiuKLYy9r2rmAKgRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XZ19C1RJFz6K5rC;
	Thu, 24 Oct 2024 17:39:59 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id A97C9140158;
	Thu, 24 Oct 2024 17:40:59 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 11:40:52 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 3/3] KVM: arm64: Enable errata based on migration target CPUs
Date: Thu, 24 Oct 2024 10:40:12 +0100
Message-ID: <20241024094012.29452-4-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20241024094012.29452-1-shameerali.kolothum.thodi@huawei.com>
References: <20241024094012.29452-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 frapeml500008.china.huawei.com (7.182.85.71)

If the Guest has migration target CPUs set, enable all errata
that are based on target MIDR/REVIDR.

Also make sure we call the paravirt helper to retrieve migration
targets if any.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/kernel/cpu_errata.c | 46 ++++++++++++++++++++++++++--------
 arch/arm64/kernel/cpufeature.c |  3 +++
 2 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index feaaf2b11f46..df6d32dfd5c0 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -18,17 +18,14 @@ u32 __ro_after_init errata_migrn_target_num;
 struct migrn_target __ro_after_init errata_migrn_target_cpus[MAX_MIGRN_TARGET_CPUS];
 
 static bool __maybe_unused
-is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
+__is_affected_midr_range(const struct arm64_cpu_capabilities *entry, u32 midr, u32 revidr)
 {
 	const struct arm64_midr_revidr *fix;
-	u32 midr = read_cpuid_id(), revidr;
 
-	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 	if (!is_midr_in_range(midr, &entry->midr_range))
 		return false;
 
 	midr &= MIDR_REVISION_MASK | MIDR_VARIANT_MASK;
-	revidr = read_cpuid(REVIDR_EL1);
 	for (fix = entry->fixed_revs; fix && fix->revidr_mask; fix++)
 		if (midr == fix->midr_rv && (revidr & fix->revidr_mask))
 			return false;
@@ -37,27 +34,56 @@ is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
 }
 
 static bool __maybe_unused
-is_affected_midr_range_list(const struct arm64_cpu_capabilities *entry,
-			    int scope)
+is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
 {
+	int i;
+
+	for (i = 0; i < errata_migrn_target_num; i++) {
+		if (__is_affected_midr_range(entry, errata_migrn_target_cpus[i].midr,
+					     errata_migrn_target_cpus[i].revidr))
+			return true;
+	}
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
-	return is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list);
+	return __is_affected_midr_range(entry, read_cpuid_id(), read_cpuid(REVIDR_EL1));
 }
 
 static bool __maybe_unused
-is_kryo_midr(const struct arm64_cpu_capabilities *entry, int scope)
+is_affected_midr_range_list(const struct arm64_cpu_capabilities *entry,
+			    int scope)
 {
-	u32 model;
+	int i;
 
+	for (i = 0; i < errata_migrn_target_num; i++) {
+		if (is_midr_in_range_list(errata_migrn_target_cpus[i].midr,
+					  entry->midr_range_list))
+			return true;
+	}
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+	return is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list);
+}
 
-	model = read_cpuid_id();
+static bool __maybe_unused
+__is_kryo_midr(const struct arm64_cpu_capabilities *entry, u32 model)
+{
 	model &= MIDR_IMPLEMENTOR_MASK | (0xf00 << MIDR_PARTNUM_SHIFT) |
 		 MIDR_ARCHITECTURE_MASK;
 
 	return model == entry->midr_range.model;
 }
 
+static bool __maybe_unused
+is_kryo_midr(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	int i;
+
+	for (i = 0; i < errata_migrn_target_num; i++) {
+		if (__is_kryo_midr(entry, errata_migrn_target_cpus[i].midr))
+			return true;
+	}
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+	return __is_kryo_midr(entry, read_cpuid_id());
+}
+
 static bool
 has_mismatched_cache_type(const struct arm64_cpu_capabilities *entry,
 			  int scope)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f7fd7e3259e4..390f4ffa773c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -86,6 +86,7 @@
 #include <asm/mmu_context.h>
 #include <asm/mpam.h>
 #include <asm/mte.h>
+#include <asm/paravirt.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/sysreg.h>
@@ -3597,6 +3598,8 @@ unsigned long cpu_get_elf_hwcap2(void)
 
 static void __init setup_boot_cpu_capabilities(void)
 {
+	pv_errata_migrn_target_init();
+
 	/*
 	 * The boot CPU's feature register values have been recorded. Detect
 	 * boot cpucaps and local cpucaps for the boot CPU, then enable and
-- 
2.45.2

