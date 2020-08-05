Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3734AC433E3
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:26:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5C5022D08
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:26:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nS9sEKoy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5C5022D08
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A28DA4B4F9;
	Wed,  5 Aug 2020 14:26:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TY20cRWyhE6V; Wed,  5 Aug 2020 14:26:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D39424B5DB;
	Wed,  5 Aug 2020 14:26:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D3E94B56B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:26:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pDVHfwtTI9N4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 14:26:08 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FE5D4B57E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:26:08 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3D72F22D04;
 Wed,  5 Aug 2020 18:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596651967;
 bh=B/jPCLQ/xBA20yQ0kQHCyvDom/Z2WtI15fihJ9w0l20=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=nS9sEKoycrPqJyLTvjfjAHO2VpVE03KGBalunyjpUIG1BMGYwNIOMb/SbOoN1iSn6
 jn7tEE52oQWe6shKPN9lsTd7O1NQsPFARYBBDKcnAM0vV8bwa8MSv32gRYtuK8VHPo
 j0vpTWm8yTCG9Np5oVUVjrOtqs2LCEXMeIfn6xu0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k3Nfz-0004w9-Ay; Wed, 05 Aug 2020 18:58:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 50/56] KVM: arm64: Substitute RANDOMIZE_BASE for
 HARDEN_EL2_VECTORS
Date: Wed,  5 Aug 2020 18:56:54 +0100
Message-Id: <20200805175700.62775-51-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com,
 alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com,
 richard.peng@oppo.com, qperret@google.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: David Brazdil <dbrazdil@google.com>

The HARDEN_EL2_VECTORS config maps vectors at a fixed location on cores which
are susceptible to Spector variant 3a (A57, A72) to prevent defeating hyp
layout randomization by leaking the value of VBAR_EL2.

Since this feature is only applicable when EL2 layout randomization is enabled,
unify both behind the same RANDOMIZE_BASE Kconfig. Majority of code remains
conditional on a capability selected for the affected cores.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200721094445.82184-3-dbrazdil@google.com
---
 arch/arm64/Kconfig             | 16 ----------------
 arch/arm64/include/asm/mmu.h   |  6 ++----
 arch/arm64/kernel/cpu_errata.c |  4 ++--
 arch/arm64/kvm/Kconfig         |  2 +-
 4 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 31380da53689..152deef3277e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1182,22 +1182,6 @@ config HARDEN_BRANCH_PREDICTOR
 
 	  If unsure, say Y.
 
-config HARDEN_EL2_VECTORS
-	bool "Harden EL2 vector mapping against system register leak" if EXPERT
-	default y
-	help
-	  Speculation attacks against some high-performance processors can
-	  be used to leak privileged information such as the vector base
-	  register, resulting in a potential defeat of the EL2 layout
-	  randomization.
-
-	  This config option will map the vectors to a fixed location,
-	  independent of the EL2 code mapping, so that revealing VBAR_EL2
-	  to an attacker does not give away any extra information. This
-	  only gets enabled on affected CPUs.
-
-	  If unsure, say Y.
-
 config ARM64_SSBD
 	bool "Speculative Store Bypass Disable" if EXPERT
 	default y
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 68140fdd89d6..bd12011eb560 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -42,12 +42,10 @@ struct bp_hardening_data {
 	bp_hardening_cb_t	fn;
 };
 
-#if (defined(CONFIG_HARDEN_BRANCH_PREDICTOR) ||	\
-     defined(CONFIG_HARDEN_EL2_VECTORS))
-
+#ifdef CONFIG_KVM_INDIRECT_VECTORS
 extern char __bp_harden_hyp_vecs[];
 extern atomic_t arm64_el2_vector_last_slot;
-#endif  /* CONFIG_HARDEN_BRANCH_PREDICTOR || CONFIG_HARDEN_EL2_VECTORS */
+#endif
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 DECLARE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index ad06d6802d2e..a524142e55d0 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -635,7 +635,7 @@ has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
 	return is_midr_in_range(midr, &range) && has_dic;
 }
 
-#if defined(CONFIG_HARDEN_EL2_VECTORS)
+#ifdef CONFIG_RANDOMIZE_BASE
 
 static const struct midr_range ca57_a72[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
@@ -880,7 +880,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = check_branch_predictor,
 	},
-#ifdef CONFIG_HARDEN_EL2_VECTORS
+#ifdef CONFIG_RANDOMIZE_BASE
 	{
 		.desc = "EL2 vector hardening",
 		.capability = ARM64_HARDEN_EL2_VECTORS,
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 13489aff4440..318c8f2df245 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -58,7 +58,7 @@ config KVM_ARM_PMU
 	  virtual machines.
 
 config KVM_INDIRECT_VECTORS
-	def_bool HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS
+	def_bool HARDEN_BRANCH_PREDICTOR || RANDOMIZE_BASE
 
 endif # KVM
 
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
