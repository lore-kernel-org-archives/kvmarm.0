Return-Path: <SRS0=H5U9=DG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96465C4346E
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 09:18:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1179A208FE
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 09:18:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1179A208FE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8568E4B344;
	Tue, 29 Sep 2020 05:18:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WpoyzxA0Om8W; Tue, 29 Sep 2020 05:18:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70E2C4B333;
	Tue, 29 Sep 2020 05:18:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 841E84B311
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 05:18:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y+EpsSjwt1F3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2020 05:18:04 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FDE24B324
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 05:18:04 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 7CC37386EB632C20326B;
 Tue, 29 Sep 2020 17:18:02 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.69) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:17:56 +0800
From: Jingyi Wang <wangjingyi11@huawei.com>
To: <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>
Subject: [RFC PATCH 1/4] arm64: cpufeature: TWED support detection
Date: Tue, 29 Sep 2020 17:17:24 +0800
Message-ID: <20200929091727.8692-2-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200929091727.8692-1-wangjingyi11@huawei.com>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.69]
X-CFilter-Loop: Reflected
Cc: catalin.marinas@arm.com, fanhenglong@huawei.com, prime.zeng@hisilicon.com,
 maz@kernel.org, will@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Zengruan Ye <yezengruan@huawei.com>

TWE Delay is an optional feature in ARMv8.6 Extentions. This patch
detect this feature.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arch/arm64/Kconfig               | 10 ++++++++++
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/kernel/cpufeature.c   | 12 ++++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6d232837cbee..fe66f4fc5f49 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1666,6 +1666,16 @@ config ARCH_RANDOM
 
 endmenu
 
+menu "ARMv8.6 architectural features"
+
+config ARM64_TWED
+	bool "Enable suppot for delayed trapping of WFE"
+	default y
+	help
+	  Delayed Trapping of WFE (part of the ARMv8.6 Extensions)
+
+endmenu
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 07b643a70710..7b8f018d142b 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -64,7 +64,8 @@
 #define ARM64_BTI				54
 #define ARM64_HAS_ARMv8_4_TTL			55
 #define ARM64_HAS_TLB_RANGE			56
+#define ARM64_HAS_TWED				57
 
-#define ARM64_NCAPS				57
+#define ARM64_NCAPS				58
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6424584be01e..d042d32a1144 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2120,6 +2120,18 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = ID_AA64PFR1_BT_BTI,
 		.sign = FTR_UNSIGNED,
 	},
+#endif
+#ifdef CONFIG_ARM64_TWED
+	{
+		.desc = "Delayed Trapping of WFE",
+		.capability = ARM64_HAS_TWED,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64MMFR1_EL1,
+		.field_pos = ID_AA64MMFR1_TWED_SHIFT,
+		.sign = FTR_UNSIGNED,
+		.min_field_value = 1,
+	},
 #endif
 	{},
 };
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
