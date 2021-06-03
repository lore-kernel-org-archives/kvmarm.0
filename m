Return-Path: <SRS0=Ht+8=K5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60405C47098
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 18:34:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03CDB613F3
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 18:34:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03CDB613F3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A94224B10A;
	Thu,  3 Jun 2021 14:34:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZJ7O3ekIOKgV; Thu,  3 Jun 2021 14:34:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A88254B0CD;
	Thu,  3 Jun 2021 14:34:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B6EB4B0CC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 14:34:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RnIR47doptwi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Jun 2021 14:34:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D28064B106
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 14:34:00 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B51D613DC;
 Thu,  3 Jun 2021 18:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1622745240;
 bh=8rzvn6RTUZ+Fwle5zCQTw7SSxwCeA8VzLr8wda4TNzA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=knMwvqEDfg1TqKq+8mJzto8ZkP9NHA83kO8aFVRApvuOlPy9xFn72QrTIAgylo6Ma
 3v6ZqrpoCULuBEn8DmxDjf1InP1TggNgxD1zfvlh8Om1ATNdLqijRLa+F4MVdQsQEC
 d1Dud6Nte9sawAg+6/fFb37Y2xITBxlb7HbBFoZi/ouDnQglK6DIiH4fs2oAmIFIQ4
 KYlAhqnNYpCVRKpKMJrwt0K02poML1UyEJASdpEsCJe5m9sdWJiY9UcOl5iaJn3U/d
 899ah8ctyb0RvqKAFoXKS0tbkSuiTzr+JVK4q7wbodfJ+ZkAetwAykwg9/9knRGtUK
 8alKJHF/yy/2A==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/4] KVM: arm64: Ignore 'kvm-arm.mode=protected' when using VHE
Date: Thu,  3 Jun 2021 19:33:44 +0100
Message-Id: <20210603183347.1695-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210603183347.1695-1-will@kernel.org>
References: <20210603183347.1695-1-will@kernel.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>
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

Ignore 'kvm-arm.mode=protected' when using VHE so that kvm_get_mode()
only returns KVM_MODE_PROTECTED on systems where the feature is available.

Cc: David Brazdil <dbrazdil@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  1 -
 arch/arm64/kernel/cpufeature.c                  | 10 +---------
 arch/arm64/kvm/arm.c                            |  6 +++++-
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index cb89dbdedc46..e85dbdf1ee8e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2300,7 +2300,6 @@
 
 			protected: nVHE-based mode with support for guests whose
 				   state is kept private from the host.
-				   Not valid if the kernel is running in EL2.
 
 			Defaults to VHE/nVHE based on hardware support.
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index efed2830d141..dc1f2e747828 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1773,15 +1773,7 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 #ifdef CONFIG_KVM
 static bool is_kvm_protected_mode(const struct arm64_cpu_capabilities *entry, int __unused)
 {
-	if (kvm_get_mode() != KVM_MODE_PROTECTED)
-		return false;
-
-	if (is_kernel_in_hyp_mode()) {
-		pr_warn("Protected KVM not available with VHE\n");
-		return false;
-	}
-
-	return true;
+	return kvm_get_mode() == KVM_MODE_PROTECTED;
 }
 #endif /* CONFIG_KVM */
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1cb39c0803a4..8d5e23198dfd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2121,7 +2121,11 @@ static int __init early_kvm_mode_cfg(char *arg)
 		return -EINVAL;
 
 	if (strcmp(arg, "protected") == 0) {
-		kvm_mode = KVM_MODE_PROTECTED;
+		if (!is_kernel_in_hyp_mode())
+			kvm_mode = KVM_MODE_PROTECTED;
+		else
+			pr_warn_once("Protected KVM not available with VHE\n");
+
 		return 0;
 	}
 
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
