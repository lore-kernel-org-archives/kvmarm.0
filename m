Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E433E209F46
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 07:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728633172; cv=none; b=SwCmwXgidM0pHtr9j9Soe4+76SW3RrD9yOY/h6/UK/eU/RUMOq9eGrlzuLdXPIOCIIgU+BN8VJNqAX2iKPWRiAA4uK1dzvEoaXKzeF7udUAWNwk6Z2mg/6UhjxEokACv2gMsx+8Fcm0LTPmJ7p5XeGhaAe0sii0UMQ4OI5nI4L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728633172; c=relaxed/simple;
	bh=MGFU/kz/3PQgSKV00nY6sneh2yAzO+iwgvZ3/gtxsJY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X8+ax8XhiKWG0x2EqK0Y5AI/uELz6QPWe1Iw0lAtCqYVjX+4a1eMYmI7Z07DI+1rjWBtNqpB7YfBer96K8eDZt3rKSbFh8iNzV6jD/m9BFWE7g8Zf8bMjyvCHLwcfxxJWP8zFVybd2Yk3wqv52jyBFC1nS2gMNvfqipwGMXsZtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XPzP56Kp0z6JB4v;
	Fri, 11 Oct 2024 15:52:25 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id AA5EB140A78;
	Fri, 11 Oct 2024 15:52:48 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 11 Oct 2024 09:52:41 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [RFC PATCH 6/6] arm64: errata: Set migration_safe_cap for MIDR based errata
Date: Fri, 11 Oct 2024 08:50:53 +0100
Message-ID: <20241011075053.80540-7-shameerali.kolothum.thodi@huawei.com>
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

These errata can be enabled for a Guest if it has set migration
Target CPUs.

ToDo: This needs careful vetting.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/cpu_migrn_errata.h | 42 +++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c            | 34 +++++++++++++++++-
 2 files changed, 75 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/cpu_migrn_errata.h

diff --git a/arch/arm64/include/asm/cpu_migrn_errata.h b/arch/arm64/include/asm/cpu_migrn_errata.h
new file mode 100644
index 000000000000..83d9f3f16e74
--- /dev/null
+++ b/arch/arm64/include/asm/cpu_migrn_errata.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __ASM_CPU_MIGRN_ERRATA_H
+#define __ASM_CPU_MIGRN_ERRATA_H
+
+/* Add an enum for any migration safe eraratum here*/
+enum {
+	ARM64_MIGRN_NOT_SUPPORTED = 0,
+	ARM64_MIGRN_WORKAROUND_CLEAN_CACHE,
+	ARM64_MIGRN_WORKAROUND_DEVICE_LOAD_ACQUIRE,
+	ARM64_MIGRN_WORKAROUND_834220,
+	ARM64_MIGRN_WORKAROUND_843419,
+	ARM64_MIGRN_WORKAROUND_845719,
+	ARM64_MIGRN_WORKAROUND_CAVIUM_23154,
+	ARM64_MIGRN_WORKAROUND_CAVIUM_27456,
+	ARM64_MIGRN_WORKAROUND_CAVIUM_30115,
+	ARM64_MIGRN_WORKAROUND_QCOM_FALKOR_E1003,
+	ARM64_MIGRN_WORKAROUND_REPEAT_TLBI,
+	ARM64_MIGRN_WORKAROUND_858921,
+	ARM64_MIGRN_WORKAROUND_1418040,
+	ARM64_MIGRN_WORKAROUND_SPECULATIVE_AT,
+	ARM64_MIGRN_WORKAROUND_1463225,
+	ARM64_MIGRN_WORKAROUND_CAVIUM_TX2_219_TVM,
+	ARM64_MIGRN_WORKAROUND_CAVIUM_TX2_219_PRFM,
+	ARM64_MIGRN_WORKAROUND_1508412,
+	ARM64_MIGRN_WORKAROUND_NVIDIA_CARMEL_CNP,
+	ARM64_MIGRN_WORKAROUND_TRBE_OVERWRITE_FILL_MODE,
+	ARM64_MIGRN_WORKAROUND_TSB_FLUSH_FAILURE,
+	ARM64_MIGRN_WORKAROUND_TRBE_WRITE_OUT_OF_RANGE,
+	ARM64_MIGRN_WORKAROUND_2645198,
+	ARM64_MIGRN_WORKAROUND_2077057,
+	ARM64_MIGRN_WORKAROUND_2064142,
+	ARM64_MIGRN_WORKAROUND_2457168,
+	ARM64_MIGRN_WORKAROUND_2038923,
+	ARM64_MIGRN_WORKAROUND_1902691,
+	ARM64_MIGRN_CPUCAP_LOCAL_CPU_ERRATUM,
+	ARM64_MIGRN_WORKAROUND_2658417,
+	ARM64_MIGRN_WORKAROUND_SPECULATIVE_SSBS,
+	ARM64_MIGRN_WORKAROUND_SPECULATIVE_UNPRIV_LOAD,
+	ARM64_MIGRN_WORKAROUND_AMPERE_AC03_CPU_38,
+};
+#endif
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index e0acb473312d..b36377c156b8 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -12,6 +12,7 @@
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/cpufeature.h>
+#include <asm/cpu_migrn_errata.h>
 #include <asm/kvm_asm.h>
 #include <asm/smp_plat.h>
 
@@ -512,6 +513,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_CLEAN_CACHE,
 		ERRATA_MIDR_RANGE_LIST(workaround_clean_cache),
 		.cpu_enable = cpu_enable_cache_maint_trap,
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_CLEAN_CACHE,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_832075
@@ -522,6 +524,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE(MIDR_CORTEX_A57,
 				  0, 0,
 				  1, 2),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_DEVICE_LOAD_ACQUIRE,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_834220
@@ -532,6 +535,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE(MIDR_CORTEX_A57,
 				  0, 0,
 				  1, 2),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_834220,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_843419
@@ -541,6 +545,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = cpucap_multi_entry_cap_matches,
 		.match_list = erratum_843419_list,
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_843419,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_845719
@@ -548,6 +553,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "ARM erratum 845719",
 		.capability = ARM64_WORKAROUND_845719,
 		ERRATA_MIDR_RANGE_LIST(erratum_845719_list),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_845719,
 	},
 #endif
 #ifdef CONFIG_CAVIUM_ERRATUM_23154
@@ -556,6 +562,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_CAVIUM_23154,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		ERRATA_MIDR_RANGE_LIST(cavium_erratum_23154_cpus),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_CAVIUM_23154,
 	},
 #endif
 #ifdef CONFIG_CAVIUM_ERRATUM_27456
@@ -563,6 +570,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "Cavium erratum 27456",
 		.capability = ARM64_WORKAROUND_CAVIUM_27456,
 		ERRATA_MIDR_RANGE_LIST(cavium_erratum_27456_cpus),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_CAVIUM_27456,
 	},
 #endif
 #ifdef CONFIG_CAVIUM_ERRATUM_30115
@@ -570,6 +578,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "Cavium erratum 30115",
 		.capability = ARM64_WORKAROUND_CAVIUM_30115,
 		ERRATA_MIDR_RANGE_LIST(cavium_erratum_30115_cpus),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_CAVIUM_30115,
 	},
 #endif
 	{
@@ -586,6 +595,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = cpucap_multi_entry_cap_matches,
 		.match_list = qcom_erratum_1003_list,
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_QCOM_FALKOR_E1003,
 	},
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_REPEAT_TLBI
@@ -595,6 +605,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = cpucap_multi_entry_cap_matches,
 		.match_list = arm64_repeat_tlbi_list,
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_REPEAT_TLBI,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_858921
@@ -603,6 +614,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "ARM erratum 858921",
 		.capability = ARM64_WORKAROUND_858921,
 		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_858921,
 	},
 #endif
 	{
@@ -647,6 +659,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		 * in at any point in time. Wonderful.
 		 */
 		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_1418040,
 	},
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_AT
@@ -654,6 +667,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "ARM errata 1165522, 1319367, or 1530923",
 		.capability = ARM64_WORKAROUND_SPECULATIVE_AT,
 		ERRATA_MIDR_RANGE_LIST(erratum_speculative_at_list),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_SPECULATIVE_AT,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_1463225
@@ -663,6 +677,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = has_cortex_a76_erratum_1463225,
 		.midr_range_list = erratum_1463225,
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_1463225,
 	},
 #endif
 #ifdef CONFIG_CAVIUM_TX2_ERRATUM_219
@@ -671,11 +686,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_CAVIUM_TX2_219_TVM,
 		ERRATA_MIDR_RANGE_LIST(tx2_family_cpus),
 		.matches = needs_tx2_tvm_workaround,
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_CAVIUM_TX2_219_TVM,
 	},
 	{
 		.desc = "Cavium ThunderX2 erratum 219 (PRFM removal)",
 		.capability = ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM,
 		ERRATA_MIDR_RANGE_LIST(tx2_family_cpus),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_CAVIUM_TX2_219_PRFM,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_1542419
@@ -696,6 +713,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE(MIDR_CORTEX_A77,
 				  0, 0,
 				  1, 0),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_1508412,
 	},
 #endif
 #ifdef CONFIG_NVIDIA_CARMEL_CNP_ERRATUM
@@ -704,6 +722,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "NVIDIA Carmel CNP erratum",
 		.capability = ARM64_WORKAROUND_NVIDIA_CARMEL_CNP,
 		ERRATA_MIDR_ALL_VERSIONS(MIDR_NVIDIA_CARMEL),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_NVIDIA_CARMEL_CNP,
 	},
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_TRBE_OVERWRITE_FILL_MODE
@@ -717,6 +736,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_TRBE_OVERWRITE_FILL_MODE,
 		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
 		CAP_MIDR_RANGE_LIST(trbe_overwrite_fill_mode_cpus),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_TRBE_OVERWRITE_FILL_MODE,
 	},
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_TSB_FLUSH_FAILURE
@@ -724,6 +744,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "ARM erratum 2067961 or 2054223",
 		.capability = ARM64_WORKAROUND_TSB_FLUSH_FAILURE,
 		ERRATA_MIDR_RANGE_LIST(tsb_flush_fail_cpus),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_TSB_FLUSH_FAILURE,
 	},
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
@@ -732,12 +753,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_TRBE_WRITE_OUT_OF_RANGE,
 		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
 		CAP_MIDR_RANGE_LIST(trbe_write_out_of_range_cpus),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_TRBE_WRITE_OUT_OF_RANGE,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_2645198
 	{
 		.desc = "ARM erratum 2645198",
 		.capability = ARM64_WORKAROUND_2645198,
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_2645198,
 		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A715)
 	},
 #endif
@@ -746,12 +769,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "ARM erratum 2077057",
 		.capability = ARM64_WORKAROUND_2077057,
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_2077057,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_2064142
 	{
 		.desc = "ARM erratum 2064142",
 		.capability = ARM64_WORKAROUND_2064142,
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_2064142,
 
 		/* Cortex-A510 r0p0 - r0p2 */
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2)
@@ -762,6 +787,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "ARM erratum 2457168",
 		.capability = ARM64_WORKAROUND_2457168,
 		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_2457168,
 
 		/* Cortex-A510 r0p0-r1p1 */
 		CAP_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1)
@@ -771,7 +797,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "ARM erratum 2038923",
 		.capability = ARM64_WORKAROUND_2038923,
-
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_2038923,
 		/* Cortex-A510 r0p0 - r0p2 */
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2)
 	},
@@ -780,6 +806,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "ARM erratum 1902691",
 		.capability = ARM64_WORKAROUND_1902691,
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_1902691,
 
 		/* Cortex-A510 r0p0 - r0p1 */
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 1)
@@ -791,6 +818,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_1742098,
 		CAP_MIDR_RANGE_LIST(broken_aarch32_aes),
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.migration_safe_cap = ARM64_MIGRN_CPUCAP_LOCAL_CPU_ERRATUM,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_2658417
@@ -800,6 +828,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		/* Cortex-A510 r0p0 - r1p1 */
 		ERRATA_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1),
 		MIDR_FIXED(MIDR_CPU_VAR_REV(1,1), BIT(25)),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_2658417,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_3194386
@@ -807,6 +836,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "SSBS not fully self-synchronizing",
 		.capability = ARM64_WORKAROUND_SPECULATIVE_SSBS,
 		ERRATA_MIDR_RANGE_LIST(erratum_spec_ssbs_list),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_SPECULATIVE_SSBS,
 	},
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
@@ -815,6 +845,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD,
 		/* Cortex-A520 r0p0 - r0p1 */
 		ERRATA_MIDR_RANGE_LIST(erratum_spec_unpriv_load_list),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_SPECULATIVE_UNPRIV_LOAD,
 	},
 #endif
 #ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
@@ -822,6 +853,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "AmpereOne erratum AC03_CPU_38",
 		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_38,
 		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_38_list),
+		.migration_safe_cap = ARM64_MIGRN_WORKAROUND_AMPERE_AC03_CPU_38,
 	},
 #endif
 	{
-- 
2.45.2

