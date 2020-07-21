Return-Path: <SRS0=7ri5=BA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA00FC433E5
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 09:45:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9410620771
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 09:45:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="tWR9rnlY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9410620771
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 359004B110;
	Tue, 21 Jul 2020 05:45:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F1tuUCY2fz-W; Tue, 21 Jul 2020 05:45:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AD3C4B178;
	Tue, 21 Jul 2020 05:45:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0765F4B0EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 05:45:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q+1C3BbxqDfH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jul 2020 05:45:04 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 641A84B1AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 05:45:03 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id q15so2158728wmj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 02:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=O5bPnopOLq11q64kzXObPPX3zXeboctA7LnF6OeX/Us=;
 b=tWR9rnlYloerCveUYnUsgHR6uCRBFYzwqBsetdUug9EvMRIwBXaG4SCjOMjVtauMUJ
 97N1WZ621rikPNoHQXNmrVmESpg0gZnwcNLiH60UOxggwcfd4lAZ6EYDxsBtqU3x9EYS
 Y7Exsd59gYnIzinxGWKObN+zfguxbE7NftfkR2U02GA1SsvSbV8d+qC3Bno2dVpbGuDQ
 adG6BsK3byX4yKpmDko9Usb+E4ha4gtYeYEf3lYAUSUkxD2CtRzicn8iWMWaf0ivy4p7
 Xp+2/knS7ku/h2J4ZPmygJeDRN0zN0AJf4u5D2FkFmKcY58v7CfFg5L0yCEre3Dwa1GQ
 7UZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=O5bPnopOLq11q64kzXObPPX3zXeboctA7LnF6OeX/Us=;
 b=D4AjEXZrS5pha/L3tb23/PeFh+dnJDyvhFOZKsr3W7ed1yBqM1nUBz3O287HTNWYUd
 iNULa1TbGaESgfaU/v9setNljMtcjisThlWlgPMqJ39Z+D7TDpgd4854y0/uh1JZmqzc
 Q03aU/ubQXIUCXe+ePbYCDONKXJ/5HHbf5qxp7wvdg/i8t0QvxZQbpxxbkCEHiYUqhlt
 Nk7sUypbHfwV8nlaV8vA7HM7GeQ+WhiHIpzGWTC1o/EYhP5a0yGzCAtcirOimJMHNH7c
 Kwe/4oiyKMxrXBRf9rBsKgBMn4HgtreRp30Js0FJKAvJq6CnkzKhZL9gQUJq3dphMe+a
 W50g==
X-Gm-Message-State: AOAM530MEB7XcRSlNPv/zdzsenja1/oDgZsWLxfS2q0sx9hsgbLkV/aa
 CWKfquc648WZYQ+/Q4Msywie9g==
X-Google-Smtp-Source: ABdhPJwAbje3FiMydnF5IO/xJvjntypm8jgHonmXqBcBqkgG96tfrwMxDpijIOUo3wHwTBkkF6mM/A==
X-Received: by 2002:a1c:48d:: with SMTP id 135mr3387581wme.102.1595324702381; 
 Tue, 21 Jul 2020 02:45:02 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:cd93:4ca4:af31:19e5])
 by smtp.gmail.com with ESMTPSA id s203sm2809491wms.32.2020.07.21.02.45.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jul 2020 02:45:01 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 2/2] KVM: arm64: Substitute RANDOMIZE_BASE for
 HARDEN_EL2_VECTORS
Date: Tue, 21 Jul 2020 10:44:45 +0100
Message-Id: <20200721094445.82184-3-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721094445.82184-1-dbrazdil@google.com>
References: <20200721094445.82184-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

The HARDEN_EL2_VECTORS config maps vectors at a fixed location on cores which
are susceptible to Spector variant 3a (A57, A72) to prevent defeating hyp
layout randomization by leaking the value of VBAR_EL2.

Since this feature is only applicable when EL2 layout randomization is enabled,
unify both behind the same RANDOMIZE_BASE Kconfig. Majority of code remains
conditional on a capability selected for the affected cores.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/Kconfig             | 16 ----------------
 arch/arm64/include/asm/mmu.h   |  6 ++----
 arch/arm64/kernel/cpu_errata.c |  4 ++--
 arch/arm64/kvm/Kconfig         |  2 +-
 4 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 66dc41fd49f2..527d217baf55 100644
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
index 8444df000181..e26542c0e79e 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -45,12 +45,10 @@ struct bp_hardening_data {
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
index 79728bfb5351..6bd1d3ad037a 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -632,7 +632,7 @@ has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
 	return is_midr_in_range(midr, &range) && has_dic;
 }
 
-#if defined(CONFIG_HARDEN_EL2_VECTORS)
+#ifdef CONFIG_RANDOMIZE_BASE
 
 static const struct midr_range ca57_a72[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
@@ -891,7 +891,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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
