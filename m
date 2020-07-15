Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F88C433EA
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3995207BC
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="APtYDCsG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3995207BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E9814B3C5;
	Wed, 15 Jul 2020 14:44:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GBLyy10yGPYG; Wed, 15 Jul 2020 14:44:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F8704B3CF;
	Wed, 15 Jul 2020 14:44:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E8234B39D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:44:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9kVehgS5ve7b for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:44:53 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDD1D4B3B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:44:52 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id r19so1864948qvz.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mQ7378wZm0+9C/eSND8Chn1p7u1ATSvIrnVzbbOROIE=;
 b=APtYDCsG/uQlacUSImH4QWuA7tUZ/XxUdNgCabFtE0n1GPzlycZREuIXLC5D1uQAlh
 R0LfxLKh5g9kxcf2FEqkJyIUj8bDOLuciXmTfcfrll1S+kA3FUMO/NllBs50st2g+7mA
 dWZUCoe2CKLgjD5py/xV3aFvZPklT09ItTXE5rvrm/vR+FPDDodziQGJ/fqlkkPi2eYz
 s4hxab4HdMNxyuQV8hbaRYdRAhHS5A0ypHJJQxxKOMGYY8z+IBFQ9++322oKMAyPrJMm
 j8LSK2cGC2tZBhhfL+9JTUOzOEayLJ+l4Vtg2gH1EO4D6cXMClkGnMb4wFzY+VOnl5bL
 mCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mQ7378wZm0+9C/eSND8Chn1p7u1ATSvIrnVzbbOROIE=;
 b=HTDx4ZAv4enwWUmF24nS2kCy29+gOitHcCyx897EnshKd952FO6uHQ/5KOFmifHke+
 G18K733cWbyNyy4CLWluvDQpEJakktczbBfw/VIt4v9JcLBGVNbS4zrVfltDgKOUEUxH
 PyvOdQ1j8CNUn5eAJMI8LIcLGEPFVqdRmTCSxhO6I3IS/U+uFArdm4xX2KCH95/LKiK5
 Nj/+Ih/DaLLiOcizGtvaYKK9o/gaUaQj2sV0N0fvqmvoBld3Qt61buaDQKiRNbrqqrJT
 ItX56UeQ0qLtdpzvj/o0XTRNMQrs2k2YzIyqpdzjz7ukZnjT/0A62xhLPdzekr1hFT8d
 Jb7A==
X-Gm-Message-State: AOAM532rpc3hC7DTTXyHF99rdBEP8bBUhp+Mq4/lGGLvv1XPwcOxCrAq
 W6T+8FupxRqTDMMWw2lf0LOyU2KUBpkUYU7HHximRDmIGs7J7YNNiGK0TJeDmFp2f55FSo07mQm
 3UTA09h5fIWYFbhBAgRKLpB/gqWkC+kqoZULsYi+8Q7or+1LiLDUMPKX+REoII4kztMU/YQ==
X-Google-Smtp-Source: ABdhPJzLI6XbhVBDkpelh41Zi71HjMW6+7/BNcaGoQLNU2ESEZ3Dy8lrNLhRAW9sEPO82AcYfVGNmJW9gzE=
X-Received: by 2002:ad4:434c:: with SMTP id q12mr667056qvs.203.1594838692289; 
 Wed, 15 Jul 2020 11:44:52 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:03 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-3-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 02/37] KVM: arm64: Move clearing of vcpu debug dirty bit
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

Note: this has been sent out to kvmarm separately

The dirty bit was previously being cleared by hyp however it is more
consistent to leave the management of the bit outside of hyp and for hyp
to read and respect the state it is given.

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
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
