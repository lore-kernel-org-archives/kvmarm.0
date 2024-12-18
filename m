Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A921A239E
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 10:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734519286; cv=none; b=F2xFqvS6Z0Txyj9d77Oz1RkmW2zlKu5S3gIdfMwDiAXNIrDG3LGzAH54YbtQCIG2VgP//UF/1V4hssbrK4xGrMAjXseSdyFu8830OKHD5DE8YLbUpVD3HOFbOv3H3m4+aU7r3MssBIahXi6J4HqG7te+6dTkJ9obnPacJCrgEM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734519286; c=relaxed/simple;
	bh=34XSp9GrULqiABpJNSvw7bZ02/BwAxkmNPP1t2DbEWE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tgwdFoUGxsfTGUfLA8iMlo8G7Jb/KpKQyTp7ZJi48v0PW0HDhzjBCQuIpyhr2pzMXrP8X37L8LkGN5zAJp1F2leqk1JGEFjk57tZ+m/EICByMdOhOmWgCRyuASxg7qtSyTejnYs9ot7d6AhRV98xvA0v3eNSfqjIvnA+DxRwO6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YCr7t6G5fz6K990;
	Wed, 18 Dec 2024 18:51:06 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 6AC11140133;
	Wed, 18 Dec 2024 18:54:42 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.195.247.46) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 18 Dec 2024 11:54:34 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <sebott@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v4 3/3] arm64: paravirt: Enable errata based on implementation CPUs
Date: Wed, 18 Dec 2024 10:53:45 +0000
Message-ID: <20241218105345.73472-4-shameerali.kolothum.thodi@huawei.com>
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

Retrieve any migration target implementation CPUs using the hypercall
and enable associated errata.

Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/cputype.h  | 25 +++++++++++++++++++++++--
 arch/arm64/include/asm/paravirt.h |  3 +++
 arch/arm64/kernel/cpu_errata.c    | 20 +++++++++++++++++---
 arch/arm64/kernel/cpufeature.c    |  2 ++
 arch/arm64/kernel/image-vars.h    |  2 ++
 arch/arm64/kernel/paravirt.c      | 31 +++++++++++++++++++++++++++++++
 6 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index dcf0e1ce892d..019d1b7dae80 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -265,6 +265,16 @@ struct midr_range {
 #define MIDR_REV(m, v, r) MIDR_RANGE(m, v, r, v, r)
 #define MIDR_ALL_VERSIONS(m) MIDR_RANGE(m, 0, 0, 0xf, 0xf)
 
+#define MAX_TARGET_IMPL_CPUS 64
+
+struct target_impl_cpu {
+	u64 midr;
+	u64 revidr;
+};
+
+extern u32 target_impl_cpu_num;
+extern struct target_impl_cpu target_impl_cpus[];
+
 static inline bool midr_is_cpu_model_range(u32 midr, u32 model, u32 rv_min,
 					   u32 rv_max)
 {
@@ -276,8 +286,19 @@ static inline bool midr_is_cpu_model_range(u32 midr, u32 model, u32 rv_min,
 
 static inline bool is_midr_in_range(struct midr_range const *range)
 {
-	return midr_is_cpu_model_range(read_cpuid_id(), range->model,
-				       range->rv_min, range->rv_max);
+	int i;
+
+	if (!target_impl_cpu_num)
+		return midr_is_cpu_model_range(read_cpuid_id(), range->model,
+					       range->rv_min, range->rv_max);
+
+	for (i = 0; i < target_impl_cpu_num; i++) {
+		if (midr_is_cpu_model_range(target_impl_cpus[i].midr,
+					    range->model,
+					    range->rv_min, range->rv_max))
+			return true;
+	}
+	return false;
 }
 
 static inline bool
diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
index 9aa193e0e8f2..95f1c15bbb7d 100644
--- a/arch/arm64/include/asm/paravirt.h
+++ b/arch/arm64/include/asm/paravirt.h
@@ -19,11 +19,14 @@ static inline u64 paravirt_steal_clock(int cpu)
 }
 
 int __init pv_time_init(void);
+void __init pv_target_impl_cpu_init(void);
 
 #else
 
 #define pv_time_init() do {} while (0)
 
+#define pv_target_impl_cpu_init() do {} while (0)
+
 #endif // CONFIG_PARAVIRT
 
 #endif
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 929685c00263..4055082ce69b 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -14,6 +14,9 @@
 #include <asm/kvm_asm.h>
 #include <asm/smp_plat.h>
 
+u32 target_impl_cpu_num;
+struct target_impl_cpu target_impl_cpus[MAX_TARGET_IMPL_CPUS];
+
 static bool __maybe_unused
 __is_affected_midr_range(const struct arm64_cpu_capabilities *entry,
 			 u32 midr, u32 revidr)
@@ -32,9 +35,20 @@ __is_affected_midr_range(const struct arm64_cpu_capabilities *entry,
 static bool __maybe_unused
 is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
 {
-	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
-	return __is_affected_midr_range(entry, read_cpuid_id(),
-					read_cpuid(REVIDR_EL1));
+	int i;
+
+	if (!target_impl_cpu_num) {
+		WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+		return __is_affected_midr_range(entry, read_cpuid_id(),
+						read_cpuid(REVIDR_EL1));
+	}
+
+	for (i = 0; i < target_impl_cpu_num; i++) {
+		if (__is_affected_midr_range(entry, target_impl_cpus[i].midr,
+					     target_impl_cpus[i].midr))
+			return true;
+	}
+	return false;
 }
 
 static bool __maybe_unused
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 4cc4ae16b28d..d32c767bf189 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -85,6 +85,7 @@
 #include <asm/kvm_host.h>
 #include <asm/mmu_context.h>
 #include <asm/mte.h>
+#include <asm/paravirt.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/sysreg.h>
@@ -3642,6 +3643,7 @@ unsigned long cpu_get_elf_hwcap3(void)
 
 static void __init setup_boot_cpu_capabilities(void)
 {
+	pv_target_impl_cpu_init();
 	/*
 	 * The boot CPU's feature register values have been recorded. Detect
 	 * boot cpucaps and local cpucaps for the boot CPU, then enable and
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 8f5422ed1b75..694e19709c46 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -49,6 +49,8 @@ PROVIDE(__pi_arm64_sw_feature_override	= arm64_sw_feature_override);
 PROVIDE(__pi_arm64_use_ng_mappings	= arm64_use_ng_mappings);
 #ifdef CONFIG_CAVIUM_ERRATUM_27456
 PROVIDE(__pi_cavium_erratum_27456_cpus	= cavium_erratum_27456_cpus);
+PROVIDE(__pi_target_impl_cpu_num	= target_impl_cpu_num);
+PROVIDE(__pi_target_impl_cpus		= target_impl_cpus);
 #endif
 PROVIDE(__pi__ctype			= _ctype);
 PROVIDE(__pi_memstart_offset_seed	= memstart_offset_seed);
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index aa718d6a9274..95fc3aae4a27 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -153,6 +153,37 @@ static bool __init has_pv_steal_clock(void)
 	return (res.a0 == SMCCC_RET_SUCCESS);
 }
 
+void  __init pv_target_impl_cpu_init(void)
+{
+	struct arm_smccc_res res;
+	int index = 0, max_idx = -1;
+
+	/* Check we have already set targets */
+	if (target_impl_cpu_num)
+		return;
+
+	do {
+		arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_CPUS_FUNC_ID,
+				     index, &res);
+		if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
+			return;
+
+		if (max_idx < 0) {
+			/* res.a0 should have a valid maximum CPU implementation index */
+			if (res.a0 >= MAX_TARGET_IMPL_CPUS)
+				return;
+			max_idx = res.a0;
+		}
+
+		target_impl_cpus[index].midr = res.a1;
+		target_impl_cpus[index].revidr = res.a2;
+		index++;
+	} while (index <= max_idx);
+
+	target_impl_cpu_num = index;
+	pr_info("Number of target implementation CPUs is %d\n", target_impl_cpu_num);
+}
+
 int __init pv_time_init(void)
 {
 	int ret;
-- 
2.47.0

