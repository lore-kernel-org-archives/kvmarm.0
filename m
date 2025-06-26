Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D68821CA18
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 12:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750942132; cv=none; b=fE4Fz8VQmxw6tXtX961JpWdgU8KsPLrjNT+7bT72XsBQz1IbB5Z+6KA6uLT7RTrgYdxhjRAzyN9zBXIWqNqus29GxrX/Sdc98qdS/AWi9tVOYXYcJkk1CAXPjlVoBLO47DX8guu4lzKQVW5wgrn5ip3LzfLc3yfJl7dqkKebmko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750942132; c=relaxed/simple;
	bh=JykfwBhwc2pjuRP/JHdEu90GPUiZyeSahL1vVMpILTM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ivgca7UI0OYvFw/TK3kV2jr/Js1HsteB9gMIfZi4lQx1CIc0ADc3zk+DWv1p5aCUkwoLJcxrv6tCWtvfOOiWc6vMMy1r8vThr9UMoDnHhPWZl1KiaBRCdHotzdPGVO1LWU56j9JbqEmN3v6yY9gva9WZzkiSD6baOk/tnoZJwSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4bSdn04XFxz27hvW;
	Thu, 26 Jun 2025 20:49:40 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 47CD21A016C;
	Thu, 26 Jun 2025 20:48:45 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Jun 2025 20:48:45 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 26 Jun
 2025 20:48:44 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	"Will Deacon" <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<tangnianyao@huawei.com>, <wangwudi@hisilicon.com>, Zhou Wang
	<wangzhou1@hisilicon.com>
Subject: [PATCH] ARM64: errata: Add workaround for HIP10/HIP10C erratum 162200803
Date: Thu, 26 Jun 2025 20:41:42 +0800
Message-ID: <20250626124142.2035110-1-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
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
 arch/arm64/kvm/vgic/vgic-mmio-v3.c          |  5 +++++
 arch/arm64/tools/cpucaps                    |  1 +
 include/linux/irqchip/arm-gic-v3.h          |  1 +
 7 files changed, 40 insertions(+)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index b18ef4064bc0..e8baa04e3f8c 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -264,6 +264,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip09           | #162100801      | HISILICON_ERRATUM_162100801 |
 +----------------+-----------------+-----------------+-----------------------------+
+| Hisilicon      | Hip{10,10C}     | #162200803      | HISILICON_ERRATUM_162200803 |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Kryo/Falkor v1  | E1003           | QCOM_FALKOR_ERRATUM_1003    |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 55fc331af337..d3df92c0fde7 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1268,6 +1268,18 @@ config HISILICON_ERRATUM_162100801
 
 	  If unsure, say Y.
 
+config HISILICON_ERRATUM_162200803
+	bool "Hip{10, 10C} 162200803 erratum support"
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
index 59d723c9ab8f..693cf748396d 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -564,6 +564,14 @@ static const struct midr_range erratum_ac04_cpu_23_list[] = {
 };
 #endif
 
+#ifdef CONFIG_HISILICON_ERRATUM_162200803
+static const struct midr_range erratum_hisi_162200803[] = {
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
+#ifdef CONFIG_HISILICON_ERRATUM_162200803
+	{
+		.desc = "HiSilicon erratum 162200803",
+		.capability = ARM64_WORKAROUND_HISI_162200803,
+		ERRATA_MIDR_RANGE_LIST(erratum_hisi_162200803),
+	},
+#endif
 	{
 	}
 };
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index ae4c0593d114..495a56e9dc4b 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -81,6 +81,11 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 		if (vgic_has_its(vcpu->kvm)) {
 			value |= (INTERRUPT_ID_BITS_ITS - 1) << 19;
 			value |= GICD_TYPER_LPIS;
+			/* Limit the number of vlpis to 4096 */
+			if (cpus_have_final_cap(ARM64_WORKAROUND_HISI_162200803) &&
+			    kvm_vgic_global_state.has_gicv4 &&
+			    !kvm_vgic_global_state.has_gicv4_1)
+				value |= 11 << GICD_TYPER_NUM_LPIS_SHIFT;
 		} else {
 			value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
 		}
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 10effd4cff6b..fda817f830f9 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -106,6 +106,7 @@ WORKAROUND_CAVIUM_TX2_219_PRFM
 WORKAROUND_CAVIUM_TX2_219_TVM
 WORKAROUND_CLEAN_CACHE
 WORKAROUND_DEVICE_LOAD_ACQUIRE
+WORKAROUND_HISI_162200803
 WORKAROUND_NVIDIA_CARMEL_CNP
 WORKAROUND_PMUV3_IMPDEF_TRAPS
 WORKAROUND_QCOM_FALKOR_E1003
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 70c0948f978e..3118728671e5 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -89,6 +89,7 @@
 #define GICD_TYPER_SPIS(typer)		((((typer) & 0x1f) + 1) * 32)
 #define GICD_TYPER_ESPIS(typer)						\
 	(((typer) & GICD_TYPER_ESPI) ? GICD_TYPER_SPIS((typer) >> 27) : 0)
+#define GICD_TYPER_NUM_LPIS_SHIFT	11
 
 #define GICD_TYPER2_nASSGIcap		(1U << 8)
 #define GICD_TYPER2_VIL			(1U << 7)
-- 
2.33.0

