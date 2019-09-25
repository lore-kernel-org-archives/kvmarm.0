Return-Path: <SRS0=kdt8=XU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B45C432C1
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 11:20:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B99621D7C
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 11:20:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B99621D7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 223C54A6BE;
	Wed, 25 Sep 2019 07:20:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mBKp11ITZro9; Wed, 25 Sep 2019 07:19:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0A544A6B5;
	Wed, 25 Sep 2019 07:19:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 553674A6BD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 07:19:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j92AZZMYIUyV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Sep 2019 07:19:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4404F4A5BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 07:19:57 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F08381596;
 Wed, 25 Sep 2019 04:19:56 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7D5D3F694;
 Wed, 25 Sep 2019 04:19:55 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 1/5] arm64: Add ARM64_WORKAROUND_1319367 for all A57 and A72
 versions
Date: Wed, 25 Sep 2019 12:19:37 +0100
Message-Id: <20190925111941.88103-2-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925111941.88103-1-maz@kernel.org>
References: <20190925111941.88103-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Rework the EL2 vector hardening that is only selected for A57 and A72
so that the table can also be used for ARM64_WORKAROUND_1319367.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/kernel/cpu_errata.c   | 13 ++++++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index f19fe4b9acc4..277e37b2a513 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -52,7 +52,8 @@
 #define ARM64_HAS_IRQ_PRIO_MASKING		42
 #define ARM64_HAS_DCPODP			43
 #define ARM64_WORKAROUND_1463225		44
+#define ARM64_WORKAROUND_1319367		45
 
-#define ARM64_NCAPS				45
+#define ARM64_NCAPS				46
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 1e43ba5c79b7..1640c988d5a1 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -623,9 +623,9 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 	return (need_wa > 0);
 }
 
-#ifdef CONFIG_HARDEN_EL2_VECTORS
+#if defined(CONFIG_HARDEN_EL2_VECTORS) || defined(CONFIG_ARM64_ERRATUM_1319367)
 
-static const struct midr_range arm64_harden_el2_vectors[] = {
+static const struct midr_range ca57_a72[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
 	{},
@@ -819,7 +819,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "EL2 vector hardening",
 		.capability = ARM64_HARDEN_EL2_VECTORS,
-		ERRATA_MIDR_RANGE_LIST(arm64_harden_el2_vectors),
+		ERRATA_MIDR_RANGE_LIST(ca57_a72),
 	},
 #endif
 	{
@@ -851,6 +851,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = has_cortex_a76_erratum_1463225,
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_1319367
+	{
+		.desc = "ARM erratum 1319367",
+		.capability = ARM64_WORKAROUND_1319367,
+		ERRATA_MIDR_RANGE_LIST(ca57_a72),
+	},
 #endif
 	{
 	}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
