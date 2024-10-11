Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8AB209F22
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 07:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728633163; cv=none; b=orJsMmIwoUx7ezX2TwmAD4qnItZtLK9ekdL8mjTJkKwzWLxuYb72St7HvDCCx0XBZ4cvSrje4F870aHVDU8rLgfTSomswMj/WteCvQEZRW9f61TdITy/uyQq+LjMYMfUhxT+VT1lgXiuxjxshJFN8HgOxfF0pEfvJnlKu+imuSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728633163; c=relaxed/simple;
	bh=bf3Bs3QzF2akzF59tPjwvQcA1cKujSIn1m9xUUJOZlM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HnO4f5+qw0M4vp3ao7ypP9enZ1hy1hZpW/X+2JZS/yUlYkKX1GwU0bfGO5DVf135NbmnMEtzxP+Bj8bmK+99obG7bQRRf9JZgw47hVFgaqbJLBnpMYUJbsPG98f+jIUK8eM1VjoWq6cUyWOYi0SanvkuY/lWdfIIsdSg+8E4/Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XPzMm6PJNz6FGb8;
	Fri, 11 Oct 2024 15:51:16 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 56C1014010C;
	Fri, 11 Oct 2024 15:52:40 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 11 Oct 2024 09:52:33 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [RFC PATCH 5/6] arm64: Use hypercall to check for any migration related errata
Date: Fri, 11 Oct 2024 08:50:52 +0100
Message-ID: <20241011075053.80540-6-shameerali.kolothum.thodi@huawei.com>
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

We now have a hypercall to retrieve any migration related erratas
for Guest kernels. Use that and update system_cpucaps based on any
set errata.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/paravirt.h |  4 ++++
 arch/arm64/kernel/cpufeature.c    | 27 +++++++++++++++++++++++++++
 arch/arm64/kernel/paravirt.c      | 18 ++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
index 9aa193e0e8f2..f2cbf2c51acc 100644
--- a/arch/arm64/include/asm/paravirt.h
+++ b/arch/arm64/include/asm/paravirt.h
@@ -19,11 +19,15 @@ static inline u64 paravirt_steal_clock(int cpu)
 }
 
 int __init pv_time_init(void);
+int __init pv_update_migrn_errata(unsigned long *errata_map);
 
 #else
 
 #define pv_time_init() do {} while (0)
 
+static inline int pv_update_migrn_errata(unsigned long *errata_map)
+{ return -EINVAL; }
+
 #endif // CONFIG_PARAVIRT
 
 #endif
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7b39b0a4aadd..829b9eccec09 100644
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
@@ -111,6 +112,8 @@ static struct arm64_cpu_capabilities const __ro_after_init *cpucap_ptrs[ARM64_NC
 
 DECLARE_BITMAP(boot_cpucaps, ARM64_NCAPS);
 
+DECLARE_BITMAP(migrn_safe_errata_map, ARM64_NCAPS);
+
 bool arm64_use_ng_mappings = false;
 EXPORT_SYMBOL(arm64_use_ng_mappings);
 
@@ -3189,6 +3192,29 @@ void arm_get_migrn_errata_map(void *target, unsigned long *errata_map)
 	}
 }
 
+static void update_migrn_errata(void)
+{
+	int i, j;
+	const struct arm64_cpu_capabilities *caps;
+	u16 scope = ARM64_CPUCAP_LOCAL_CPU_ERRATUM;
+
+	if (pv_update_migrn_errata(migrn_safe_errata_map))
+		return;
+
+	for_each_set_bit(i, migrn_safe_errata_map, ARM64_NCAPS) {
+		for (j = 0; j < ARM64_NCAPS; j++) {
+			caps = cpucap_ptrs[j];
+			if (!caps || !(caps->type & scope) ||
+			    caps->migration_safe_cap != i ||
+			    cpus_have_cap(caps->capability))
+				continue;
+			if (caps->desc && !caps->cpus)
+				pr_info("Updated with migration errata: %s\n", caps->desc);
+			__set_bit(caps->capability, system_cpucaps);
+		}
+	}
+}
+
 static void update_cpu_capabilities(u16 scope_mask)
 {
 	int i;
@@ -3566,6 +3592,7 @@ static void __init setup_system_capabilities(void)
 	 * cpucaps.
 	 */
 	update_cpu_capabilities(SCOPE_SYSTEM);
+	update_migrn_errata();
 	enable_cpu_capabilities(SCOPE_ALL & ~SCOPE_BOOT_CPU);
 	apply_alternatives_all();
 
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index aa718d6a9274..04b1930d0e9a 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -23,6 +23,7 @@
 #include <asm/paravirt.h>
 #include <asm/pvclock-abi.h>
 #include <asm/smp_plat.h>
+#include <asm/hypervisor.h>
 
 struct static_key paravirt_steal_enabled;
 struct static_key paravirt_steal_rq_enabled;
@@ -153,6 +154,23 @@ static bool __init has_pv_steal_clock(void)
 	return (res.a0 == SMCCC_RET_SUCCESS);
 }
 
+int __init pv_update_migrn_errata(unsigned long *errata_map)
+{
+	int ret;
+	struct arm_smccc_res res;
+
+	ret = kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_MIGRN_ERRATA);
+	if (ret <= 0)
+		return -EOPNOTSUPP;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_ERRATA, &res);
+	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
+		return -EINVAL;
+
+	bitmap_from_arr64(errata_map, &res, ARM64_NCAPS);
+	return 0;
+}
+
 int __init pv_time_init(void)
 {
 	int ret;
-- 
2.45.2

