Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0F71CEACD
	for <kvmarm@lists.linux.dev>; Fri, 24 Jan 2025 15:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737731949; cv=none; b=dlW61O2znBYSOF6A/EqnyK4ddLOueWPKxD9P0VO0HKEIgpAqwo6NLg7t9Gs1+vJ7Qu7HIbGZHkrIQ45GKvu3HvsLjwYT9DhDhUXDpheKiam+pDmSZNNile01HmV/Pf0rgOC89prIMVWhyu1RMk2Pg/m7LZhY7nnkpWvT8/dzECQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737731949; c=relaxed/simple;
	bh=CFngofGFp143bI2qys7eYrz5Vu+rhbpie7sYLrp+ggk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PO2nIHv537mtUnrftaO47PpoI93U9+MxX3/MVDIgciQio3XouwsS657hZzeCTx2HbxWkIA4K9B3HdsdmCkS4i4i+hCENtpQkqx3kJ1gg2E4zif21PkbkZQcsghKpOGxWyl17qqkRo7N0sYcvcP0L/05ixLmNEvuqsGCWFkSZnYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YfhHk28K5z6K63S;
	Fri, 24 Jan 2025 23:17:06 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id A3572140114;
	Fri, 24 Jan 2025 23:19:05 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 24 Jan 2025 16:18:57 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <sebott@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v5 4/4] arm64: paravirt: Enable errata based on implementation CPUs
Date: Fri, 24 Jan 2025 15:17:32 +0000
Message-ID: <20250124151732.6072-5-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com>
References: <20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com>
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

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/cputype.h  | 24 +++++++++++--
 arch/arm64/include/asm/paravirt.h |  3 ++
 arch/arm64/kernel/cpu_errata.c    | 20 +++++++++--
 arch/arm64/kernel/cpufeature.c    |  2 ++
 arch/arm64/kernel/image-vars.h    |  2 ++
 arch/arm64/kernel/paravirt.c      | 58 +++++++++++++++++++++++++++++++
 include/linux/arm-smccc.h         |  2 ++
 7 files changed, 106 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index dcf0e1ce892d..f95f04ec6f66 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -265,6 +265,15 @@ struct midr_range {
 #define MIDR_REV(m, v, r) MIDR_RANGE(m, v, r, v, r)
 #define MIDR_ALL_VERSIONS(m) MIDR_RANGE(m, 0, 0, 0xf, 0xf)
 
+struct target_impl_cpu {
+	u64 midr;
+	u64 revidr;
+	u64 aidr;
+};
+
+extern u32 target_impl_cpu_num;
+extern struct target_impl_cpu *target_impl_cpus;
+
 static inline bool midr_is_cpu_model_range(u32 midr, u32 model, u32 rv_min,
 					   u32 rv_max)
 {
@@ -276,8 +285,19 @@ static inline bool midr_is_cpu_model_range(u32 midr, u32 model, u32 rv_min,
 
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
index 929685c00263..147b036d8bbd 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -14,6 +14,9 @@
 #include <asm/kvm_asm.h>
 #include <asm/smp_plat.h>
 
+u32 target_impl_cpu_num;
+struct target_impl_cpu *target_impl_cpus;
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
index aa718d6a9274..4547dc2ddc13 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/io.h>
 #include <linux/jump_label.h>
+#include <linux/memblock.h>
 #include <linux/printk.h>
 #include <linux/psci.h>
 #include <linux/reboot.h>
@@ -20,6 +21,7 @@
 #include <linux/types.h>
 #include <linux/static_call.h>
 
+#include <asm/hypervisor.h>
 #include <asm/paravirt.h>
 #include <asm/pvclock-abi.h>
 #include <asm/smp_plat.h>
@@ -153,6 +155,62 @@ static bool __init has_pv_steal_clock(void)
 	return (res.a0 == SMCCC_RET_SUCCESS);
 }
 
+void  __init pv_target_impl_cpu_init(void)
+{
+	int i;
+	unsigned long max_cpus;
+	struct arm_smccc_res res;
+	const u32 funcs[] = {
+		ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_VER,
+		ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_CPUS,
+	};
+
+	/* Check we have already set targets */
+	if (target_impl_cpu_num)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(funcs); ++i) {
+		if (!kvm_arm_hyp_service_available(funcs[i]))
+			return;
+	}
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_VER_FUNC_ID,
+			     0, &res);
+	if (res.a0 != SMCCC_RET_SUCCESS)
+		return;
+
+	if (res.a1 != ARM_SMCCC_KVM_DISCOVER_IMPL_VER_1_0 || !res.a2) {
+		pr_warn("Unsupported target impl version or CPU implementations\n");
+		return;
+	}
+
+	max_cpus = res.a2;
+	target_impl_cpus = memblock_alloc(sizeof(*target_impl_cpus) * max_cpus,
+					  __alignof__(*target_impl_cpus));
+	if (!target_impl_cpus) {
+		pr_warn("Not enough memory for struct target_impl_cpu\n");
+		return;
+	}
+
+	for (i = 0; i < max_cpus; i++) {
+		arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_CPUS_FUNC_ID,
+				     i, &res);
+		if (res.a0 != SMCCC_RET_SUCCESS) {
+			memblock_free(target_impl_cpus,
+				      sizeof(*target_impl_cpus) * max_cpus);
+			target_impl_cpus = NULL;
+			pr_warn("Discovering target implementation CPUs failed\n");
+			return;
+		}
+		target_impl_cpus[i].midr = res.a1;
+		target_impl_cpus[i].revidr = res.a2;
+		target_impl_cpus[i].aidr = res.a3;
+	};
+
+	target_impl_cpu_num = max_cpus;
+	pr_info("Number of target implementation CPUs is %d\n", target_impl_cpu_num);
+}
+
 int __init pv_time_init(void)
 {
 	int ret;
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index f19be5754090..4b4ce6ecac0a 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -228,6 +228,8 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
 			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD)
 
+#define ARM_SMCCC_KVM_DISCOVER_IMPL_VER_1_0	0x100000000
+
 #define ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_VER_FUNC_ID		\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
 			   ARM_SMCCC_SMC_64,				\
-- 
2.47.0

