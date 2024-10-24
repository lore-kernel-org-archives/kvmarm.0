Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416B51714B0
	for <kvmarm@lists.linux.dev>; Thu, 24 Oct 2024 09:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729762854; cv=none; b=XYKO+L8YBAGLm5ulSdITny4JNnZVm6uc1TB386XlONfXEOnZTBuPb+oX8KcxD9dYp7YIoxKikMUGcd5v7/MPiEJ83Vp7pSMxhieTAg8B9kt5UTi6oBbxUjYCoF+vF492Uv5Y0e+Ln2WPOAwIm85pGR/FpcG6k6c/dcQK+Y07KOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729762854; c=relaxed/simple;
	bh=GSvtuDohjYCZ2tJCVmPj6rXYWHDkb8LHLcKLkA7nx9g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rThdj5aeC8ev+AQo+M3H/l0+s+hneo0cUyAXz7tKdG+krkmlu19TRDwzRKaAghIiDzJIoaxPLkp7Kc0VLuaeYhlPn8alVWeGiYxDkSJBeHGsDq5HRNRQhF+3WwdDBm/s9HkMFa0PAihSLgCuJ7JBSQgU8I5yC5sVfo0l4/cHPKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XZ17m3dHfz6K61T;
	Thu, 24 Oct 2024 17:38:44 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 5851F1406AD;
	Thu, 24 Oct 2024 17:40:50 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 11:40:43 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<cohuck@redhat.com>, <eric.auger@redhat.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <jiangkunkun@huawei.com>,
	<jonathan.cameron@huawei.com>, <anthony.jebson@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 2/3] KVM: arm64: Use hypercall to retrieve any migration targets
Date: Thu, 24 Oct 2024 10:40:11 +0100
Message-ID: <20241024094012.29452-3-shameerali.kolothum.thodi@huawei.com>
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

Provides a paravirt helper function to retrieve any migration target
CPUs if available and store it. This will be used in subsequent patch
to enable any errata associated with those targets

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
ToDo:
Not sure it make sense to use kvm_arm_hyp_service_available() here
as these hypercalls will be handled by userspace VMM.

---
 arch/arm64/include/asm/cpufeature.h |  7 +++++
 arch/arm64/include/asm/paravirt.h   |  3 ++
 arch/arm64/kernel/cpu_errata.c      |  3 ++
 arch/arm64/kernel/paravirt.c        | 48 +++++++++++++++++++++++++++++
 4 files changed, 61 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 985d966787b1..6623f47814bc 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -386,6 +386,13 @@ struct arm64_cpu_capabilities {
 	const struct cpumask *cpus;
 };
 
+#define MIGRN_TARGET_CPUS_HYP_CALL_VER_1	1
+#define MAX_MIGRN_TARGET_CPUS			64
+struct migrn_target {
+	u32 midr;
+	u32 revidr;
+};
+
 static inline int cpucap_default_scope(const struct arm64_cpu_capabilities *cap)
 {
 	return cap->type & ARM64_CPUCAP_SCOPE_MASK;
diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
index 9aa193e0e8f2..19cd97dafbbc 100644
--- a/arch/arm64/include/asm/paravirt.h
+++ b/arch/arm64/include/asm/paravirt.h
@@ -19,11 +19,14 @@ static inline u64 paravirt_steal_clock(int cpu)
 }
 
 int __init pv_time_init(void);
+void __init pv_errata_migrn_target_init(void);
 
 #else
 
 #define pv_time_init() do {} while (0)
 
+#define pv_errata_migrn_target_init() do {} while (0)
+
 #endif // CONFIG_PARAVIRT
 
 #endif
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index dfefbdf4073a..feaaf2b11f46 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -14,6 +14,9 @@
 #include <asm/kvm_asm.h>
 #include <asm/smp_plat.h>
 
+u32 __ro_after_init errata_migrn_target_num;
+struct migrn_target __ro_after_init errata_migrn_target_cpus[MAX_MIGRN_TARGET_CPUS];
+
 static bool __maybe_unused
 is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
 {
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index aa718d6a9274..675424258419 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -153,6 +153,54 @@ static bool __init has_pv_steal_clock(void)
 	return (res.a0 == SMCCC_RET_SUCCESS);
 }
 
+extern struct migrn_target __ro_after_init errata_migrn_target_cpus[];
+extern u32 __ro_after_init errata_migrn_target_num;
+void  __init pv_errata_migrn_target_init(void)
+{
+	u32 target_num;
+	struct arm_smccc_res res;
+	u32 curr = 0;
+
+	/* Check we have already set errata targets */
+	if (errata_migrn_target_num)
+		return;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_NUM_FUNC_ID, &res);
+	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
+		return;
+
+	target_num = lower_32_bits(res.a0);
+	if (!target_num || target_num > MAX_MIGRN_TARGET_CPUS ||
+	    upper_32_bits(res.a0) != MIGRN_TARGET_CPUS_HYP_CALL_VER_1)
+		return;
+
+	while (curr < target_num) {
+		unsigned long *ptr;
+		int j;
+
+		arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_CPUS_FUNC_ID, &res);
+		if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
+			break;
+
+		ptr = (unsigned long *)&res;
+		for (j = 0; j < 4; j++, ptr++) {
+			if (!(*ptr))
+				goto out;
+			errata_migrn_target_cpus[curr].midr = lower_32_bits(*ptr);
+			errata_migrn_target_cpus[curr].revidr = upper_32_bits(*ptr);
+			curr++;
+		}
+	}
+out:
+	if (curr != target_num) {
+		pr_warn("Failed to retrieve all migration target CPUs\n");
+		return;
+	}
+
+	errata_migrn_target_num = target_num;
+	pr_info("Migration target CPUs set to %d\n", target_num);
+}
+
 int __init pv_time_init(void)
 {
 	int ret;
-- 
2.45.2

