Return-Path: <SRS0=IpCr=AY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767F5C433E2
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 21:05:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2F2C120857
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 21:05:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ie1bjxBs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F2C120857
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D03364B1E7;
	Mon, 13 Jul 2020 17:05:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id URMEQtDtYK7X; Mon, 13 Jul 2020 17:05:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE9214B1FA;
	Mon, 13 Jul 2020 17:05:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5285A4B1C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 17:05:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Okse6PtO4iYf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2020 17:05:13 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36C824B1B1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 17:05:13 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id c124so885350wme.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 14:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OEvDCs6GxZh5HWA6VucXyfZNanV+chx77kwyKvJ7Fac=;
 b=ie1bjxBsz5tqCdILPZ/yM/+0lFeHUtO52aDT87w+0NeDqyntlzZtOWXFO99aTwktZY
 wnESF7ZCqXU2VJY2h4asZjbzy1eanfOJK2+VCudDqmK6iTSwWhkjURv87D+f7/uaeZ4C
 /d2pXXj52rdloFUuo3BTCIqaRedIlsTABamynQzSdSPFo+ovFNt69Cm7ASb20kGGNQE0
 1tZstE32WeqWgELvBFN0eFUzgJv+rnQHnMqIDEZyawyc5y0HsgP4VfghYh1m9s6k9GU4
 o8nnFlY6SNZNg1Jc1geGqq2A43wtipoOIUmDL9tcrVbuWHdTmNkkkecx7/y8br0eIW5W
 tfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OEvDCs6GxZh5HWA6VucXyfZNanV+chx77kwyKvJ7Fac=;
 b=Vh4mnQobHtpDjSDTskLNAhgILbRPCgaJr9lBTl1Fz+IsfNVFihI9WNXVqtQkkpF/+b
 ZZ5utSmM2tAMeZ8iZirmljnJjy16wyZ2gDWML/lFMgAjEEfJyTO67Xoko8jjoYTYajku
 P8zVWIabhLBs6syvk5gYJMifC7OVnM7ihwLKRSczC/9J7Ex6AWdO64pk8Jr07rZu9qcB
 jeLuXmp7xZM+WlJ5nlHDvmnLz74Ql4HYE/QUPOt3s59msL3yfaYtwX8sa980lFpYW9D2
 47NXKX6fy/HttWKAC2ZkxJ/qOEW4BiBdsgcRMBfrrnO2ozI7h+I7eUpuKz3RirGcIJwW
 Fovg==
X-Gm-Message-State: AOAM533elNUdxX+DGydE4G+0iD4XVAZbi/gU6uEVKq9GDkdxoVWefZ/K
 J/5XOPPTPJftVa8wW/tbfDzhhiKBnfjcOt8S87R8qBoURGzw9XhIXmIWSTtt+zDhv0l2j3jcWOo
 R1Cg5+0tbnfncMdffv4A+LTPeMfbC4a0VKWO2vz6xRjbLEC9XLoVufQggIhm0G500lpbJcg==
X-Google-Smtp-Source: ABdhPJwRkvjatsMu2Cr1NO73Cz3SPP3FoCfs1hcUZW35bsXoT291cpN+VGXGjVXNQPrs2yCg52C7CWZA0sM=
X-Received: by 2002:adf:8024:: with SMTP id 33mr1451739wrk.117.1594674312063; 
 Mon, 13 Jul 2020 14:05:12 -0700 (PDT)
Date: Mon, 13 Jul 2020 22:05:02 +0100
In-Reply-To: <20200713210505.2959828-1-ascull@google.com>
Message-Id: <20200713210505.2959828-2-ascull@google.com>
Mime-Version: 1.0
References: <20200713210505.2959828-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v2 1/4] KVM: arm64: Leave KVM_ARM64_DEBUG_DIRTY updates to the
 host
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

Move the clearing of KVM_ARM64_DEBUG_DIRTY from being one of the last
things hyp does before exiting to the host to being one of the first
things the host does after hyp exits.

This means the host always manages the state of the bit and hyp simply
respects that in the context switch.

No functional change.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_host.h         | 2 +-
 arch/arm64/kvm/debug.c                    | 2 ++
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h | 2 --
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e1a32c0707bb..b06f24b5f443 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -404,7 +404,7 @@ struct kvm_vcpu_arch {
 })
 
 /* vcpu_arch flags field values: */
-#define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
+#define KVM_ARM64_DEBUG_DIRTY		(1 << 0) /* vcpu is using debug */
 #define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
 #define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
 #define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 7a7e425616b5..e9932618a362 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -209,6 +209,8 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 {
 	trace_kvm_arm_clear_debug(vcpu->guest_debug);
 
+	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
+
 	if (vcpu->guest_debug) {
 		restore_guest_debug_regs(vcpu);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 0297dc63988c..50ca5d048017 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -161,8 +161,6 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 
 	__debug_save_state(guest_dbg, guest_ctxt);
 	__debug_restore_state(host_dbg, host_ctxt);
-
-	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
 #endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */
-- 
2.27.0.383.g050319c2ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
