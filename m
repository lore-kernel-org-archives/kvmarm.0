Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C873EC5517A
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 21:48:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32F172074F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 21:48:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="TDvQN99o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32F172074F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C31F84BA54;
	Mon,  9 Nov 2020 16:48:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eTZtoLe037dr; Mon,  9 Nov 2020 16:48:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 767AB4BA6A;
	Mon,  9 Nov 2020 16:48:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 444064BA4A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 16:48:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jzfxNrDz2z4g for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 16:48:01 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6DDB4BA57
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 16:47:59 -0500 (EST)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A864721D93;
 Mon,  9 Nov 2020 21:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604958479;
 bh=zP0FHaLQ6wi5hKZ4vknMBkdzLRNFRTUxVnSeKgahOAc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=TDvQN99o/BBBeaJQdaf3Pt713tOdh60gqFC8J2gg8nqLumVl5R/ym2J2qEtnuyEIc
 ne8ny+KJYdBVJ68y2wzheksDHChuyhLS0sqvM3s3DfSRiVcAOvJpFnTp9q6MKGO5Sy
 ZbLBQvSrROJ/uJ0QxbHaNrVSc49bdk4TqeJVwADQ=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 9/9] arm64: spectre: Consolidate spectre-v3a detection
Date: Mon,  9 Nov 2020 21:47:26 +0000
Message-Id: <20201109214726.15276-10-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201109214726.15276-1-will@kernel.org>
References: <20201109214726.15276-1-will@kernel.org>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, kernel-team@android.com,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
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

The spectre-v3a mitigation is split between cpu_errata.c and spectre.c,
with the former handling detection of the problem and the latter handling
enabling of the workaround.

Move the detection logic alongside the enabling logic, like we do for the
other spectre mitigations.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/spectre.h |  1 +
 arch/arm64/kernel/cpu_errata.c   | 13 ++-----------
 arch/arm64/kernel/proton-pack.c  | 12 ++++++++++++
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/spectre.h b/arch/arm64/include/asm/spectre.h
index b4df683ed800..12a4eb5e4e6b 100644
--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -83,6 +83,7 @@ enum mitigation_state arm64_get_spectre_v2_state(void);
 bool has_spectre_v2(const struct arm64_cpu_capabilities *cap, int scope);
 void spectre_v2_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 
+bool has_spectre_v3a(const struct arm64_cpu_capabilities *cap, int scope);
 void spectre_v3a_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 
 enum mitigation_state arm64_get_spectre_v4_state(void);
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 949d5615a47e..0709c827f2b3 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -196,16 +196,6 @@ has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
 	return is_midr_in_range(midr, &range) && has_dic;
 }
 
-#ifdef CONFIG_RANDOMIZE_BASE
-
-static const struct midr_range ca57_a72[] = {
-	MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
-	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
-	{},
-};
-
-#endif
-
 #ifdef CONFIG_ARM64_WORKAROUND_REPEAT_TLBI
 static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
 #ifdef CONFIG_QCOM_FALKOR_ERRATUM_1009
@@ -462,7 +452,8 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	/* Must come after the Spectre-v2 entry */
 		.desc = "Spectre-v3a",
 		.capability = ARM64_SPECTRE_V3A,
-		ERRATA_MIDR_RANGE_LIST(ca57_a72),
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.matches = has_spectre_v3a,
 		.cpu_enable = spectre_v3a_enable_mitigation,
 	},
 #endif
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index cf9f8b885aea..d89be9882998 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -277,6 +277,18 @@ void spectre_v2_enable_mitigation(const struct arm64_cpu_capabilities *__unused)
  * an indirect trampoline for the hyp vectors so that guests can't read
  * VBAR_EL2 to defeat randomisation of the hypervisor VA layout.
  */
+bool has_spectre_v3a(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	static const struct midr_range spectre_v3a_unsafe_list[] = {
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+		{},
+	};
+
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+	return is_midr_in_range_list(read_cpuid_id(), spectre_v3a_unsafe_list);
+}
+
 void spectre_v3a_enable_mitigation(const struct arm64_cpu_capabilities *__unused)
 {
 	struct bp_hardening_data *data = this_cpu_ptr(&bp_hardening_data);
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
