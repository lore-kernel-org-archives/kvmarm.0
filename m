Return-Path: <SRS0=IpCr=AY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B41C433E4
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 21:05:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A6E42068F
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 21:05:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="vDvOwSAR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A6E42068F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E98AC4B171;
	Mon, 13 Jul 2020 17:05:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r0DJVUPH+YWf; Mon, 13 Jul 2020 17:05:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2A744B1DB;
	Mon, 13 Jul 2020 17:05:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E35574B1D4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 17:05:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VMR8UaARFzDg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2020 17:05:16 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4EBEA4B171
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 17:05:15 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id y18so18887694wrq.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 14:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=MciEXR7pwIUwUTfGfuUf6bd3Xe+wMqxtrLbFuAKNZME=;
 b=vDvOwSARmVSuoqWLQX4VkFzh78qLZs/9cyQYwBOn5HSXlaYcWPKglCSBIfTS4lgZBY
 Z2V9hk2ADP8bQOrL8LJgnmvoVMi4oCyFdnNQyNtpODe38ekmNvtSSrpQVBZtsc43U4sS
 AkkBkUC69bE33djVsYROnkxA+ZJ6+Q9e5qamsTtjTuiCgwMqOskyp7hFvgCmcB50V0/x
 ftAy1xcZEWR6Gn1+kDi910rC3v7xjIVxLL5ErpjmHqP81vkuMXUGwElXDfF1yGejJ5tx
 9wNWRnwIUZ0fZyRDMy46h7vIOqxGSFeGsbKSghv8w70ryO0nVkqW8Nc03qRCCsfkiKRN
 GdVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MciEXR7pwIUwUTfGfuUf6bd3Xe+wMqxtrLbFuAKNZME=;
 b=dvRCk9pmM4oqA6KcB/+Eo3/FuwrmCG5AgmewxZPMPi1wiPXI/KVCTg6A97emYqFGfY
 bI70CGAMp/Bj4oVyI6LNarZS8PoUgFzSNVDUfxvJvgdFSxhZraT5pz5mvdqYu1rzL9dK
 +SxElSE6Tc/kN0T1RmTIPAehjwJEHEuw+/eyjaO2zYls4xZ0TTbSij1DZwYsMReUvSc/
 /zrUa5LSLCzUaD5iZ0ye4RqNRtQfTQZcWokYsAuv001T00MxPZ9s7gyJbepY0ltmNwDq
 iEF1d0v8Z+zKEZfbLkjIiW+4k3QyTJ5sgNEYZoUHtRdrxlAq6ecZ3jil6usRNZsH5j0s
 fuFA==
X-Gm-Message-State: AOAM530e+Gy38MxTNScPvpKSXMyDWW7Bh6zzcZo2hatdDqNiabW1x/Hv
 38Nok479F5iGXRLN/e0mWifJ+1W4hL55ID34BXD20jlniplqZEnfpxtSO8pQQ2PUClHKAed8Rs6
 gEELPviCAlJcoWMo0usteN2TcIV2CRQFQRwX46Um/HNgjIT76D5w9jIclu12I3enGd/f0MQ==
X-Google-Smtp-Source: ABdhPJygptohZzZb1sq2jer2LL0xKVSZXPjhoqhb9fCRFoZqRczy+DCeR9Ztpihm+QRKf/NOCbjidJ2tLG4=
X-Received: by 2002:a1c:7306:: with SMTP id d6mr1101957wmb.113.1594674314377; 
 Mon, 13 Jul 2020 14:05:14 -0700 (PDT)
Date: Mon, 13 Jul 2020 22:05:03 +0100
In-Reply-To: <20200713210505.2959828-1-ascull@google.com>
Message-Id: <20200713210505.2959828-3-ascull@google.com>
Mime-Version: 1.0
References: <20200713210505.2959828-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v2 2/4] KVM: arm64: Predicate FPSIMD vcpu flags on feature
 support
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com, dave.martin@arm.com
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

If the system doesn't support FPSIMD features then the flags must never
be set. These are the same feature checks performed by hyp when handling
an FPSIMD trap.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/fpsimd.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 3e081d556e81..c6b3197f6754 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -52,7 +52,7 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
  * Prepare vcpu for saving the host's FPSIMD state and loading the guest's.
  * The actual loading is done by the FPSIMD access trap taken to hyp.
  *
- * Here, we just set the correct metadata to indicate that the FPSIMD
+ * Here, we just set the correct metadata to indicate whether the FPSIMD
  * state in the cpu regs (if any) belongs to current on the host.
  *
  * TIF_SVE is backed up here, since it may get clobbered with guest state.
@@ -63,15 +63,29 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	BUG_ON(!current->mm);
 
 	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
+			      KVM_ARM64_FP_HOST |
 			      KVM_ARM64_HOST_SVE_IN_USE |
 			      KVM_ARM64_HOST_SVE_ENABLED);
+
+	if (!system_supports_fpsimd())
+		return;
+
+	/*
+	 * Having just come from the user task, if any FP state is loaded it
+	 * will be that of the task. Make a note of this but, just before
+	 * entering the vcpu, it will be double checked that the loaded FP
+	 * state isn't transient because things could change between now and
+	 * then.
+	 */
 	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
 
-	if (test_thread_flag(TIF_SVE))
-		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
+	if (system_supports_sve()) {
+		if (test_thread_flag(TIF_SVE))
+			vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
 
-	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
-		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
+		if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
+			vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
+	}
 }
 
 /*
-- 
2.27.0.383.g050319c2ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
