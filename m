Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA23C55178
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 15:59:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B66422400
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 15:59:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xcKoRPu4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B66422400
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E7854B535;
	Mon, 26 Oct 2020 11:59:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G7Btozy3PK8I; Mon, 26 Oct 2020 11:59:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 701804B517;
	Mon, 26 Oct 2020 11:59:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AFB24B52B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 11:58:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QyW9fREkh42B for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 11:58:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CF944B533
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 11:58:56 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 475DC2242A;
 Mon, 26 Oct 2020 15:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603727935;
 bh=Bzois/euCwL2L/bDEEDY0NNglsy0/h5C1ed9KKFDZRU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=xcKoRPu4JSwCxGbvGATOZjg6qBHlCPf8dHTcki6LshPK9qk9a1ATVN3LH1ZRKno1r
 xavKbNnk9pUcyxEm00N/q5gYSSIYrAAKq/O9zRpiSBV/y4bcZwNP9OoJAUNmClR8/4
 qZ/+T/G8mHV9OHyh+e5L65qwuaZz5GwSAC779hk4=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 9/9] arm64: spectre: Consolidate spectre-v3a detection
Date: Mon, 26 Oct 2020 15:58:33 +0000
Message-Id: <20201026155833.24847-10-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201026155833.24847-1-will@kernel.org>
References: <20201026155833.24847-1-will@kernel.org>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>
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
index 1b0c432d577d..306f80cc7703 100644
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
index 672dfda73881..47676d13d477 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -279,6 +279,18 @@ void spectre_v2_enable_mitigation(const struct arm64_cpu_capabilities *__unused)
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
2.29.0.rc2.309.g374f81d7ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
