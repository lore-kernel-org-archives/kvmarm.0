Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EEA15A8
	for <kvmarm@lists.linux.dev>; Sat, 29 Mar 2025 03:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743219847; cv=none; b=eXRJ8xbU2IspPHn2nnsVdiPGO8N8jAg43aSD2KHHrjAGBporYdJwMiOyyp52WVEtVzVsD87wb7RGps4QYpGj/ry4k7sLwCHK+RZiVJPGfWME2Vq2z6kzNCq1k/7TAr1PFjznqLxer701ODIeMfEEZTADGdeswUFViSKdYs15Eb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743219847; c=relaxed/simple;
	bh=WvqyV4/DWf4DY1MhbBrxDGbjmUWzhsmw8LPC6DYdI1g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MSMWm5fGiQjEtQ8vXF5LccsuaHQwRkKtpIT2d28EdZ14/JVwb2kv/f6PLTutbROCgZPvlE1LFCgAFvWxhOvVWcx4RHAMXSF9SAkdqUJEnp/Fg9YrRgztFMdLjJD2tNQbooIfIcsXM6hjwZaaZCs2rS2B3dHOgLhMSimpBxudlG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4ZPjpY3x3WzHrJR;
	Sat, 29 Mar 2025 11:40:37 +0800 (CST)
Received: from kwepemd200014.china.huawei.com (unknown [7.221.188.8])
	by mail.maildlp.com (Postfix) with ESMTPS id F3BB11403D2;
	Sat, 29 Mar 2025 11:43:55 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 kwepemd200014.china.huawei.com (7.221.188.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Sat, 29 Mar 2025 11:43:55 +0800
From: Yicong Yang <yangyicong@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>
CC: <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>,
	<prime.zeng@hisilicon.com>, <xuwei5@huawei.com>, <yangyicong@hisilicon.com>,
	<linuxarm@huawei.com>
Subject: [PATCH 2/3] arm64/cpufeature: Add cpucap for HCR_EL2.E2H RES1 (!FEAT_E2H0)
Date: Sat, 29 Mar 2025 11:44:08 +0800
Message-ID: <20250329034409.21354-3-yangyicong@huawei.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20250329034409.21354-1-yangyicong@huawei.com>
References: <20250329034409.21354-1-yangyicong@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemd200014.china.huawei.com (7.221.188.8)

From: Yicong Yang <yangyicong@hisilicon.com>

Arm introduced a "new" feature FEAT_E2H0 indicates that HCR_EL2.E2H can
be programmed to the value 0 for legacy hardwares supported VHE. The
feature is indicated by ID_AA64MMFR4_EL1.E2H0 == 0. It is needed to
detect this feature for KVM mode initialization. Instead of bothering
the existed hardwares, introduce a new cpucap HAS_E2H_RES1 to indicate
FEAT_E2H0 is not supported. Make this a ARM64_CPUCAP_SYSTEM_FEATURE
just like VHE.

Introduce cpu_has_e2h_res1() for checking the feature's support
which can be used in the early boot stage where CPU capabilities
are not initialized.

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
---
 arch/arm64/include/asm/cpufeature.h | 23 +++++++++++++++++++++++
 arch/arm64/kernel/cpufeature.c      | 12 ++++++++++++
 arch/arm64/tools/cpucaps            |  1 +
 3 files changed, 36 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index c4326f1cb917..b35d393da28d 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -889,6 +889,29 @@ static inline bool cpu_has_hw_af(void)
 						ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
 }
 
+/*
+ * Check whether FEAT_E2H0 is not supported, in which case HCR_EL2.E2H
+ * is implemented as RES1.
+ */
+static __always_inline bool cpu_has_e2h_res1(void)
+{
+	u64 mmfr4;
+	u32 val;
+
+	/*
+	 * It's also used for checking the kvm mode cfg in early_param()
+	 * where boot capabilities is not initialized. In such case read
+	 * mmfr4 directly. This works same after boot stage since
+	 * ARM64_HAS_E2H_RES1 is a system feature, the cached sanitised
+	 * value keeps same with every single CPU.
+	 */
+	mmfr4 = read_sysreg_s(SYS_ID_AA64MMFR4_EL1);
+	val = cpuid_feature_extract_signed_field(mmfr4,
+						 ID_AA64MMFR4_EL1_E2H0_SHIFT);
+
+	return val != ID_AA64MMFR4_EL1_E2H0_IMP;
+}
+
 static inline bool cpu_has_pan(void)
 {
 	u64 mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 75ef319c1ef8..64e99330b380 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2473,6 +2473,12 @@ test_has_mpam_hcr(const struct arm64_cpu_capabilities *entry, int scope)
 	return idr & MPAMIDR_EL1_HAS_HCR;
 }
 
+static bool
+has_e2h_res1(const struct arm64_cpu_capabilities *entry, int __unused)
+{
+	return cpu_has_e2h_res1();
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.capability = ARM64_ALWAYS_BOOT,
@@ -3043,6 +3049,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_pmuv3,
 	},
 #endif
+	{
+		.desc = "HCR_EL2.E2H RES1",
+		.capability = ARM64_HAS_E2H_RES1,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_e2h_res1,
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 772c1b008e43..dd6631886d67 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -22,6 +22,7 @@ HAS_DCPODP
 HAS_DCPOP
 HAS_DIT
 HAS_E0PD
+HAS_E2H_RES1
 HAS_ECV
 HAS_ECV_CNTPOFF
 HAS_EPAN
-- 
2.24.0

