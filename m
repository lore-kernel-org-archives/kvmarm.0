Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38E4204584
	for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 14:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740146993; cv=none; b=nnmZ77v77ySsPCEjHFUkwy5sIiRTs0wOfFjmqV2JORF9OW1OxaqdUOzcitqLMHtZkX2NcVNaxmIRKr8Ex43y3ZyjnOYri+3C4STch6iEi4ZgzfdJdpolhra9LOKaZXouyelTN/vlDH5hm9tqSTWJsXBJhiYaWDOQ6y5VUlf8v6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740146993; c=relaxed/simple;
	bh=+7lY0Zo/e9sv/L9evWr+YnwRN58IW1VSCOYPW4z8YgI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CXbIc3tTTZOewwuLw9tWfiOZYM1kOlVHKKckyaGG+QDU4aQ4mOyzn0QaLlVAPprBml59sPo4bWKerXRdSVkY1rBQAxvXJamFuK0jJbVPFe6q3hZNpTehO80aGFAprKJ2pcloqTD2x02N7j3n9p2ip0lAtUYs5AJsh8WHI5ikf6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YzsQ54ntWz6L74m;
	Fri, 21 Feb 2025 22:07:09 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id CEBA71400D9;
	Fri, 21 Feb 2025 22:09:48 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 21 Feb 2025 15:09:41 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <sebott@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v8 5/6] smccc/kvm_guest: Enable errata based on implementation CPUs
Date: Fri, 21 Feb 2025 14:02:28 +0000
Message-ID: <20250221140229.12588-6-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
References: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
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
Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/cputype.h    |  7 ++++
 arch/arm64/include/asm/hypervisor.h |  1 +
 arch/arm64/kernel/cpu_errata.c      | 45 +++++++++++++++++---
 arch/arm64/kernel/cpufeature.c      |  2 +
 drivers/firmware/smccc/kvm_guest.c  | 64 +++++++++++++++++++++++++++++
 5 files changed, 114 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index ccb4a155d118..cc2d58141be1 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -276,6 +276,13 @@ static inline bool midr_is_cpu_model_range(u32 midr, u32 model, u32 rv_min,
 	return _model == model && rv >= rv_min && rv <= rv_max;
 }
 
+struct target_impl_cpu {
+	u64 midr;
+	u64 revidr;
+	u64 aidr;
+};
+
+bool cpu_errata_set_target_impl(u64 num, void *impl_cpus);
 bool is_midr_in_range_list(struct midr_range const *ranges);
 
 static inline u64 __attribute_const__ read_cpuid_mpidr(void)
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
index 1f51cf6378c5..66869d81c3d5 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -14,10 +14,34 @@
 #include <asm/kvm_asm.h>
 #include <asm/smp_plat.h>
 
+static u64 target_impl_cpu_num;
+static struct target_impl_cpu *target_impl_cpus;
+
+bool cpu_errata_set_target_impl(u64 num, void *impl_cpus)
+{
+	if (target_impl_cpu_num || !num || !impl_cpus)
+		return false;
+
+	target_impl_cpu_num = num;
+	target_impl_cpus = impl_cpus;
+	return true;
+}
+
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
 
 bool is_midr_in_range_list(struct midr_range const *ranges)
@@ -47,9 +71,20 @@ __is_affected_midr_range(const struct arm64_cpu_capabilities *entry,
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
diff --git a/drivers/firmware/smccc/kvm_guest.c b/drivers/firmware/smccc/kvm_guest.c
index f3319be20b36..2f03b582c298 100644
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
@@ -51,3 +54,64 @@ bool kvm_arm_hyp_service_available(u32 func_id)
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
+	struct target_impl_cpu *target;
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
+		pr_warn("Unsupported target CPU implementation version v%d.%d\n",
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
+	target = memblock_alloc(sizeof(*target) * max_cpus,  __alignof__(*target));
+	if (!target) {
+		pr_warn("Not enough memory for struct target_impl_cpu\n");
+		return;
+	}
+
+	for (i = 0; i < max_cpus; i++) {
+		arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_CPUS_FUNC_ID,
+				     i, &res);
+		if (res.a0 != SMCCC_RET_SUCCESS) {
+			pr_warn("Discovering target implementation CPUs failed\n");
+			goto mem_free;
+		}
+		target[i].midr = res.a1;
+		target[i].revidr = res.a2;
+		target[i].aidr = res.a3;
+	};
+
+	if (!cpu_errata_set_target_impl(max_cpus, target)) {
+		pr_warn("Failed to set target implementation CPUs\n");
+		goto mem_free;
+	}
+
+	pr_info("Number of target implementation CPUs is %lld\n", max_cpus);
+	return;
+
+mem_free:
+	memblock_free(target, sizeof(*target) * max_cpus);
+}
-- 
2.47.0

