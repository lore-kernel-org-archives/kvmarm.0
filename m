Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3E0C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89BEF64F34
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89BEF64F34
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B5634B3B4;
	Thu,  4 Mar 2021 06:55:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2XULOMGJVt3E; Thu,  4 Mar 2021 06:55:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FB084B4BE;
	Thu,  4 Mar 2021 06:55:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AED724B344
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bZ2bju2HcGdZ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 06:55:15 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C4AA4B2BB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:15 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id b62so4362275wmc.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 03:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=w3uq674/0tvskVI05Vhx67uka1K//LSv9mwUEMDST+Y=;
 b=q+aWYVuCFmvb1x9aRuZGZBFT/kXFp7/HF+NtIpWReaJxFShWCABaZ+mx/gqh2zoTb0
 ube4+sDB9Gd+gJq6AcsaZfKJ+b42Th/iJW8VHKAk8wVIOg4rRoyJElP62mxil0+Cj9Qs
 4WfEZkpPk7OyU2LPCBbp/YfF4TnrH5xvSADclCA0yyYYBBWR72zAxtLsBt6/VjOtnOiN
 9Xx6TqPV6ylYaSObBjXYK+JAtK4BAfB9R/HF3Z+VtGIbSM8OkRcfkgqC+ikvYgxI1VzF
 u1wBi++2ju4kKETTi6/IIPGKrFTI9UNLvTcJTrutRUDJoKR79o0piBXWqegwYB4qJQpp
 Uc+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=w3uq674/0tvskVI05Vhx67uka1K//LSv9mwUEMDST+Y=;
 b=Jy8xnnAUo/QblRpacDTJ3eDJUXWsKE4cX0Cct237eWp1i56m5QAj8UxVBkEy3zTJg9
 yoN/aMl/wioyBjzeDvecc815+dCe5WJIOAqNuLbZm+BTnlmb1CoMTuK6E+X+E1K4TFmf
 ugbj2KZPqu7tKC9kAWvYAaVQYWMHLz72nqLzucwId8Vz7ppYyAQiqIdjv9XZ0k1Mjcqm
 r1Q7W3Q6Pxak9trHuULpag6QpABOwdcVSEpeCqjydStFTZMIREBLl3zvQALuX0qu5n3U
 zjGiog2xjvZ3b4rmyXAsZlkOVlGKZg/vqcRqJlD/AUrT0RMam7A6Y1eDC0WnOEnr2+/8
 WHrg==
X-Gm-Message-State: AOAM531LspOWXuXRruALy8afw6cVseu513d0gtKQ5UkG5O3HAKdsUXrJ
 OGIpU8VzPIlgpmKx+SFmhtGjgM0fSxghWeyj/GduT5/AXw9VRo66pY78EF7GnKs8nU3aJMD9Mmt
 Dkp9zt+9iCU4BMJSQrsFdy3AbadHyceDVd37NniegLV9GBrCKbgkpUcyMOGurB1JgHKtgNg==
X-Google-Smtp-Source: ABdhPJyPKPyg87hB2EkQ0c/eqbRX7g3yaxFHzgDRaefDedmhXDrwobSFSKnBb1BBKIu0XVmMfK/phRXtnJY=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a7b:c18e:: with SMTP id
 y14mr1285799wmi.1.1614858914228; 
 Thu, 04 Mar 2021 03:55:14 -0800 (PST)
Date: Thu,  4 Mar 2021 11:54:44 +0000
In-Reply-To: <20210304115454.3597879-1-ascull@google.com>
Message-Id: <20210304115454.3597879-2-ascull@google.com>
Mime-Version: 1.0
References: <20210304115454.3597879-1-ascull@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 01/10] KVM: arm64: Leave KVM_ARM64_DEBUG_DIRTY updates to the
 host
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, Dave.Martin@arm.com
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
things hyp does before exiting to the host, to being one of the first
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
index 3d10e6527f7d..6b33f720ce9c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -390,7 +390,7 @@ struct kvm_vcpu_arch {
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
index 4ebe9f558f3a..344c76a7af35 100644
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
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
