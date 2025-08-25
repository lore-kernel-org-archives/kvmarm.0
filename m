Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993DE18FC91
	for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 02:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756090057; cv=none; b=NqaMe30en3CUVHtVLlYbXQbjcCC7fjdq1T5jNEGLoMyqp7ZUVWjvrrqNuOuA3S5ojI88KNfTQiFWSMZWitit9hkUa9DsA8XsRSUiBZkGcSXBcQU/WzSneBoZTmZ5qwsfnBdRzhHDdL1LbeOXZXpFwveWIU1696VYh3XE1PP266s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756090057; c=relaxed/simple;
	bh=Q6uBlWMbOmk29fT5efcu0SjqikpiXfzjlXhCVghLBF0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sy5FNN80PlfYBvjFnNC5PP7mtri0aroAAAbRbkmVfOB5fWloBtZk7QlsaWpmdcyCedEXBM3kov+cQNSNGwkV2Q72pzJzV7UZe81oPN2OPn20/38l3NVsAfBV6LVfJlUMTfOyVw+hxsQwZEiUxplC5/083N6m4YY93SGIwmVQO/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c9FW970yXz1R91T;
	Mon, 25 Aug 2025 10:44:37 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2A12D1A0188;
	Mon, 25 Aug 2025 10:47:33 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 25 Aug 2025 10:47:32 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 10:47:32 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <tangnianyao@huawei.com>,
	<wangwudi@hisilicon.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>, Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH v2 4/4] ARM64: errata: Add workaround for HIP10/HIP10C erratum 162200802
Date: Mon, 25 Aug 2025 10:39:54 +0800
Message-ID: <20250825023954.3516381-5-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
References: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200004.china.huawei.com (7.202.195.237)

For GICv4.0 of Hip10 and Hip10C, it has a SoC bug with vPE schedule:
when multiple vPEs are sending vpe schedule/deschedule commands
concurrently and repeatedly, some vPE schedule command may not be
scheduled, and it will cause the command timeout.

The hardware implementation is that there is one GIC hardware in one CPU die,
which handles all vPE schedule operations one by one in all CPUs of this die.
The bug is that if the number of queued vPE schedule operations is more
than a certain value, the last vPE schedule operation will be lost.

One possible way to solve this problem is to limit the number of vLPIs, so
the hardware could spend less time to scan virtual pending table when it
handles the vPE schedule operations, so the queued vPE schedule operations
will never be more than above certain value.

Given the number of CPUs of die, and imagine there is 100 vPE schedule
operations per second one CPU, it can be calculated that we can limit
the number of vLPI to 4096 for virtual machine to avoid the issue.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 Documentation/arch/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                          | 12 ++++++++++++
 arch/arm64/include/asm/cputype.h            |  4 ++++
 arch/arm64/kernel/cpu_errata.c              | 15 +++++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c             |  9 ++++++++-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c          |  6 ++++++
 arch/arm64/tools/cpucaps                    |  1 +
 7 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index b18ef4064bc0..0de545c1fce5 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -264,6 +264,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip09           | #162100801      | HISILICON_ERRATUM_162100801 |
 +----------------+-----------------+-----------------+-----------------------------+
+| Hisilicon      | Hip{10,10C}     | #162200802      | HISILICON_ERRATUM_162200802 |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Kryo/Falkor v1  | E1003           | QCOM_FALKOR_ERRATUM_1003    |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e9bbfacc35a6..a43a341047a2 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1270,6 +1270,18 @@ config HISILICON_ERRATUM_162100801
 
 	  If unsure, say Y.
 
+config HISILICON_ERRATUM_162200802
+	bool "Hip{10, 10C} 162200802 erratum support"
+	default y
+	help
+	  For GICv4.0 of Hip10 and Hip10C, it has a soc bug with vPE schedule:
+	  when multiple vPEs are sending vpe schedule/deschedule commands
+	  concurrently and repeatly, some vPE schedule command may not be
+	  scheduled, and it will cause the command timeout. To avoid the
+	  issue, limit the number of vLPI to 4096 for virtual machine.
+
+	  If unsure, say Y.
+
 config QCOM_FALKOR_ERRATUM_1003
 	bool "Falkor E1003: Incorrect translation due to ASID change"
 	default y
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 661735616787..c40328907433 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -134,6 +134,8 @@
 
 #define HISI_CPU_PART_TSV110		0xD01
 #define HISI_CPU_PART_HIP09			0xD02
+#define HISI_CPU_PART_HIP10		0xD03
+#define HISI_CPU_PART_HIP10C		0xD45
 #define HISI_CPU_PART_HIP12		0xD06
 
 #define APPLE_CPU_PART_M1_ICESTORM	0x022
@@ -223,6 +225,8 @@
 #define MIDR_FUJITSU_A64FX MIDR_CPU_MODEL(ARM_CPU_IMP_FUJITSU, FUJITSU_CPU_PART_A64FX)
 #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
 #define MIDR_HISI_HIP09 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_HIP09)
+#define MIDR_HISI_HIP10 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_HIP10)
+#define MIDR_HISI_HIP10C MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_HIP10C)
 #define MIDR_HISI_HIP12 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_HIP12)
 #define MIDR_APPLE_M1_ICESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM)
 #define MIDR_APPLE_M1_FIRESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 59d723c9ab8f..c97a65d799db 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -564,6 +564,14 @@ static const struct midr_range erratum_ac04_cpu_23_list[] = {
 };
 #endif
 
+#ifdef CONFIG_HISILICON_ERRATUM_162200802
+static const struct midr_range erratum_hisi_162200802[] = {
+	MIDR_ALL_VERSIONS(MIDR_HISI_HIP10),
+	MIDR_ALL_VERSIONS(MIDR_HISI_HIP10C),
+	{},
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -905,6 +913,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = has_impdef_pmuv3,
 		.cpu_enable = cpu_enable_impdef_pmuv3_traps,
 	},
+#ifdef CONFIG_HISILICON_ERRATUM_162200802
+	{
+		.desc = "HiSilicon erratum 162200802",
+		.capability = ARM64_WORKAROUND_HISI_162200802,
+		ERRATA_MIDR_RANGE_LIST(erratum_hisi_162200802),
+	},
+#endif
 	{
 	}
 };
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 46468cb97536..306ae6f55983 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -389,7 +389,14 @@ int vgic_init(struct kvm *kvm)
 	/* freeze the number of spis */
 	if (!dist->nr_spis)
 		dist->nr_spis = VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
-	dist->nr_lpis = 0;
+
+	if (cpus_have_final_cap(ARM64_WORKAROUND_HISI_162200802) &&
+	    kvm_vgic_global_state.has_gicv4 &&
+	    !kvm_vgic_global_state.has_gicv4_1)
+		dist->nr_lpis = 4096;
+	else
+		dist->nr_lpis = 0;
+
 
 	ret = kvm_vgic_dist_init(kvm, dist->nr_spis);
 	if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 3a53b63f7b20..477d6af4a709 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -180,6 +180,12 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		if (GICD_TYPER_NUM_LPIS(val) > INTERRUPT_ID_BITS_ITS)
 			return -EINVAL;
+		/* Limit the number of vlpis to 4096 */
+		if (cpus_have_final_cap(ARM64_WORKAROUND_HISI_162200802) &&
+		    kvm_vgic_global_state.has_gicv4 &&
+		    !kvm_vgic_global_state.has_gicv4_1 &&
+		    GICD_TYPER_NUM_LPIS(val) != 12)
+			return -EINVAL;
 
 		dist->nr_lpis = 2 ^ GICD_TYPER_NUM_LPIS(val);
 		return 0;
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index ef0b7946f5a4..e39bd95dea74 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -111,6 +111,7 @@ WORKAROUND_CAVIUM_TX2_219_PRFM
 WORKAROUND_CAVIUM_TX2_219_TVM
 WORKAROUND_CLEAN_CACHE
 WORKAROUND_DEVICE_LOAD_ACQUIRE
+WORKAROUND_HISI_162200802
 WORKAROUND_NVIDIA_CARMEL_CNP
 WORKAROUND_PMUV3_IMPDEF_TRAPS
 WORKAROUND_QCOM_FALKOR_E1003
-- 
2.33.0

