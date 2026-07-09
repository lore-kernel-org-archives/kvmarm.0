Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7205409620
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 10:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783593636; cv=none; b=pJ7K6d6nMi0GTMbOkoRQDg6ZO/DXJjy0CPSXnAhIqSmidVTtE7076g5LvIMpQMoIrrTYQd2OrottBXnzheA2AVnf355uBxHPbLVW9Zr0Sj+lP1AQCDkxph9zb9ie4RkJZqFa8agPnbi0Xhuw6vAqiicabbDi4vcLB7Nz2lf37o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783593636; c=relaxed/simple;
	bh=6BsRTKjJK/hWYca3nJZ3vBwv/NCGEhQ+AVoz8d6ZD1g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RJymhsKjumxtOQxyErpokW3hqkva474UWFndYvwwCRBho6jImIc8sn3Zwk4+vSG1b9cc9sHs2kCPKisdsZWtvsF6x6IlX5k2hrtf8l1o7FYV0lGeBAwSVlFDliW0H/HSqlAQsWoOvnETIJ1HN+G7NW8TEosOCJzPJKOHHOk25Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=OagxP5wd; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="OagxP5wd"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Dcqf9lUhEOQLu4tqiv3oGYn+/OLqWtAH2Drj2KbvTpM=;
	b=OagxP5wd/3HfasTRHWWPKeQFsvwmqFLXCHx4q4N6KFj51D2RLuolaeEWIOPgryn9Zpsc9aSXu
	/Rzg2pjY2U1DWulwmKus401733L2rXAkw8ESF8PggzJokZmNJLQAYNV4IufKHN8HBzxzaiszZXH
	+MCuul3Z5nRgtLA2ceuG7/E=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gwrpm15wZz1prLf;
	Thu,  9 Jul 2026 18:31:12 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id C947C40561;
	Thu,  9 Jul 2026 18:40:28 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 9 Jul
 2026 18:40:27 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <zhengtian10@huawei.com>
CC: <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<yangjinqian1@huawei.com>, <caijian11@h-partners.com>,
	<liuyonglong@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <leo.bras@arm.com>
Subject: [PATCH v4 2/6] KVM: arm64: Add support for FEAT_HDBSS
Date: Thu, 9 Jul 2026 18:40:22 +0800
Message-ID: <20260709104026.2612599-3-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260709104026.2612599-1-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)

Armv9.5 introduces the Hardware Dirty Bit State Structure (HDBSS)
feature, indicated by ID_AA64MMFR1_EL1.HAFDBS == 0b0100.

Add CPU capability detection for HDBSS. The feature requires VHE mode
and is detected via ID_AA64MMFR1_EL1.HAFDBS.HDBSS field. A helper
function system_supports_hdbss() is provided to check hardware support.

Suggested-by: Zhou Wang <wangzhou1@hisilicon.com>
Co-developed-by: Eillon <yezhenyu2@huawei.com>
Signed-off-by: Eillon <yezhenyu2@huawei.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/cpufeature.h |  5 +++++
 arch/arm64/kernel/cpufeature.c      | 12 ++++++++++++
 arch/arm64/tools/cpucaps            |  1 +
 3 files changed, 18 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a57870fa96db..bdfab086fd94 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -863,6 +863,11 @@ static inline bool system_supports_haft(void)
 	return cpus_have_final_cap(ARM64_HAFT);
 }

+static inline bool system_supports_hdbss(void)
+{
+	return cpus_have_final_cap(ARM64_HAS_HDBSS);
+}
+
 static __always_inline bool system_supports_mpam(void)
 {
 	return alternative_has_cap_unlikely(ARM64_MPAM);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a22df0c5120..aa327eebaf1c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2131,6 +2131,11 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
 	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
 }

+static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, int cope)
+{
+	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, cope);
+}
+
 bool cpu_supports_bbml2_noabort(void)
 {
 	/*
@@ -2781,6 +2786,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, HAFT)
 	},
 #endif
+	{
+		.desc = "Hardware Dirty state tracking structure (HDBSS)",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_HDBSS,
+		.matches = has_vhe_hdbss,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, HDBSS)
+	},
 	{
 		.desc = "CRC32 instructions",
 		.capability = ARM64_HAS_CRC32,
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 9b85a84f6fd4..a87706c9d160 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -69,6 +69,7 @@ HAS_VA52
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
 HAS_XNX
+HAS_HDBSS
 HAFT
 HW_DBM
 KVM_HVHE
--
2.33.0

