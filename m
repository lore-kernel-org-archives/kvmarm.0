Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AE4C4363A
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F5F02224A
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F5F02224A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10D024B3D3;
	Tue, 27 Oct 2020 13:26:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S53vQVG-6o06; Tue, 27 Oct 2020 13:26:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9364B4B4E3;
	Tue, 27 Oct 2020 13:26:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F4D54B3D5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QRN8vRhJCnEw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:26:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A84C4B33B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D469E15AB;
 Tue, 27 Oct 2020 10:26:19 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD1BE3F719;
 Tue, 27 Oct 2020 10:26:18 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v3 04/16] arm64: Introduce CPU SPE feature
Date: Tue, 27 Oct 2020 17:26:53 +0000
Message-Id: <20201027172705.15181-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027172705.15181-1-alexandru.elisei@arm.com>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, will@kernel.org
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

Detect Statistical Profiling Extension (SPE) support using the cpufeatures
framework. The presence of SPE is reported via the ARM64_SPE capability.

The feature will be necessary for emulating SPE in KVM, because KVM needs
that all CPUs have SPE hardware to avoid scheduling a VCPU on a CPU without
support. For this reason, the feature type ARM64_CPUCAP_SYSTEM_FEATURE has
been selected to disallow hotplugging a CPU which doesn't support SPE.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/kernel/cpufeature.c   | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 42868dbd29fd..10fd094d9a5b 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -65,7 +65,8 @@
 #define ARM64_HAS_ARMv8_4_TTL			55
 #define ARM64_HAS_TLB_RANGE			56
 #define ARM64_MTE				57
+#define ARM64_SPE				58
 
-#define ARM64_NCAPS				58
+#define ARM64_NCAPS				59
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index dcc165b3fc04..4a0f4dc53824 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1278,6 +1278,18 @@ has_useable_cnp(const struct arm64_cpu_capabilities *entry, int scope)
 	return has_cpuid_feature(entry, scope);
 }
 
+static bool __maybe_unused
+has_usable_spe(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	u64 pmbidr;
+
+	if (!has_cpuid_feature(entry, scope))
+		return false;
+
+	pmbidr = read_sysreg_s(SYS_PMBIDR_EL1);
+	return !(pmbidr & BIT(SYS_PMBIDR_EL1_P_SHIFT));
+}
+
 /*
  * This check is triggered during the early boot before the cpufeature
  * is initialised. Checking the status on the local CPU allows the boot
@@ -2003,6 +2015,18 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = 1,
 		.cpu_enable = cpu_enable_cnp,
 	},
+#endif
+#ifdef CONFIG_ARM_SPE_PMU
+	{
+		.desc = "Statistical Profiling Extension (SPE)",
+		.capability = ARM64_SPE,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_usable_spe,
+		.sys_reg = SYS_ID_AA64DFR0_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64DFR0_PMSVER_SHIFT,
+		.min_field_value = 1,
+	},
 #endif
 	{
 		.desc = "Speculation barrier (SB)",
-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
