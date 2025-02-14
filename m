Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1127F265CC4
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 15:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739546090; cv=none; b=iRMRyzvdJZb7S168Oj29eO3iODQbixV2HG5qYFkBoUHjoDfTww8jTFs/tPid8w/7a1cn+vEms6d15YIL8JTCH+rcwVjqv50WG3zdHOpDUH1jPaVquRI5vYkt54ZuquRyDV7WzHHkzVFxC6tywz6jxlGAXMebyLI2a6CZ5oH2PFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739546090; c=relaxed/simple;
	bh=8tlbh6e1Wq9c+80FEtNW+7piPuQf1c/CWPLsOlf6nRM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eeyH8P/OCfsEDmf8ddZCjoecwm6FDNppDXPsj+/SNUX67qsll8vhplguYxNTrEUyalg7ZeivihWRQ/L/01pwmZFmP3CZ1upCsGiSUQOhCPgLkdFprV2rgEvWX0B9bexDjBVvmxkdbtYKFpQv1QfH8KqP9eRbtwRS1YXWa9dY9ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Yvb9m1X8zz6L55s;
	Fri, 14 Feb 2025 23:11:40 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 08F47140113;
	Fri, 14 Feb 2025 23:14:47 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 14 Feb 2025 16:14:39 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <sebott@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v7 4/5] smccc/kvm_guest: Enable errata based on implementation CPUs
Date: Fri, 14 Feb 2025 15:13:42 +0000
Message-ID: <20250214151343.61348-5-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20250214151343.61348-1-shameerali.kolothum.thodi@huawei.com>
References: <20250214151343.61348-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 frapeml500008.china.huawei.com (7.182.85.71)

Retrieve any migration target implementation CPUs using the hypercall
and enable associated errata.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/cputype.h    | 24 ++++++++++-
 arch/arm64/include/asm/hypervisor.h |  1 +
 arch/arm64/kernel/cpu_errata.c      | 20 +++++++--
 arch/arm64/kernel/cpufeature.c      |  2 +
 arch/arm64/kernel/image-vars.h      |  2 +
 drivers/firmware/smccc/kvm_guest.c  | 63 +++++++++++++++++++++++++++++
 6 files changed, 107 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 2a76f0e30006..975fbdfc9354 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -267,6 +267,15 @@ struct midr_range {
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
@@ -278,8 +287,19 @@ static inline bool midr_is_cpu_model_range(u32 midr, u32 model, u32 rv_min,
 
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
diff --git a/arch/arm64/include/asm/hypervisor.h b/arch/arm64/include/asm/hypervisor.h
index 409e239834d1..a12fd897c877 100644
--- a/arch/arm64/include/asm/hypervisor.h
+++ b/arch/arm64/include/asm/hypervisor.h
@@ -6,6 +6,7 @@
 
 void kvm_init_hyp_services(void);
 bool kvm_arm_hyp_service_available(u32 func_id);
+void kvm_arm_target_impl_cpu_init(void);
 
 #ifdef CONFIG_ARM_PKVM_GUEST
 void pkvm_init_hyp_services(void);
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 99b55893fc4e..1177a3094cf2 100644
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
index 72e876f37cd4..5c61d9d9f097 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -86,6 +86,7 @@
 #include <asm/kvm_host.h>
 #include <asm/mmu_context.h>
 #include <asm/mte.h>
+#include <asm/hypervisor.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/sysreg.h>
@@ -3679,6 +3680,7 @@ unsigned long cpu_get_elf_hwcap3(void)
 
 static void __init setup_boot_cpu_capabilities(void)
 {
+	kvm_arm_target_impl_cpu_init();
 	/*
 	 * The boot CPU's feature register values have been recorded. Detect
 	 * boot cpucaps and local cpucaps for the boot CPU, then enable and
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index ef3a69cc398e..a6926750faaf 100644
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
diff --git a/drivers/firmware/smccc/kvm_guest.c b/drivers/firmware/smccc/kvm_guest.c
index f3319be20b36..c1d2f28b0f58 100644
--- a/drivers/firmware/smccc/kvm_guest.c
+++ b/drivers/firmware/smccc/kvm_guest.c
@@ -6,8 +6,11 @@
 #include <linux/bitmap.h>
 #include <linux/cache.h>
 #include <linux/kernel.h>
+#include <linux/memblock.h>
 #include <linux/string.h>
 
+#include <uapi/linux/psci.h>
+
 #include <asm/hypervisor.h>
 
 static DECLARE_BITMAP(__kvm_arm_hyp_services, ARM_SMCCC_KVM_NUM_FUNCS) __ro_after_init = { };
@@ -51,3 +54,63 @@ bool kvm_arm_hyp_service_available(u32 func_id)
 	return test_bit(func_id, __kvm_arm_hyp_services);
 }
 EXPORT_SYMBOL_GPL(kvm_arm_hyp_service_available);
+
+void  __init kvm_arm_target_impl_cpu_init(void)
+{
+	int i;
+	u32 ver;
+	u64 max_cpus;
+	struct arm_smccc_res res;
+
+	/* Check we have already set targets */
+	if (target_impl_cpu_num)
+		return;
+
+	if (!kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_VER) ||
+	    !kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_CPUS))
+		return;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_VER_FUNC_ID,
+			     0, &res);
+	if (res.a0 != SMCCC_RET_SUCCESS)
+		return;
+
+	/* Version info is in lower 32 bits and is in SMMCCC_VERSION format */
+	ver = lower_32_bits(res.a1);
+	if (PSCI_VERSION_MAJOR(ver) != 1) {
+		pr_warn("Unsupported target CPU implementation version v%d:%d\n",
+			PSCI_VERSION_MAJOR(ver), PSCI_VERSION_MINOR(ver));
+		return;
+	}
+
+	if (!res.a2) {
+		pr_warn("No target implementation CPUs specified\n");
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
-- 
2.47.0

