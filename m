Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84992C433E6
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3FDF120787
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="cqQrw4UW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FDF120787
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7B64B40A;
	Wed, 15 Jul 2020 14:46:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZH-1xtvanEGM; Wed, 15 Jul 2020 14:46:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D43794B405;
	Wed, 15 Jul 2020 14:46:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5BFE4B3D8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:46:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jgxsna56p7sz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:46:04 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAA154B40A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:46:01 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id u189so3933107ybg.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=l/rmm4yRSsvMqNS1fY4vFBlPhMuUHHjzRrgzAxA79to=;
 b=cqQrw4UWuiRav8qvFlIERtg0XgnvypiE3tSteSI1ncEvEC6ugbuPtt2LMYH7OqxsJe
 uLHJe5lG5gAcUuTFL4ETGRD0mAcPFIZo6ZNMNnVweAlgC2kwgM8cF4JIWI0e4N6xwQKW
 c3rH8GqMQq77L5UIJMxbxckhYgXaHHr2WlUNi9Vy7+pw2u2bXeOdMKnxtDN1N3VN2gsk
 oqgUHNP0Kqp/jgnsrlnjAQ48sNF2+lS8XZllUZa9ubn4R43ZcvwKi57f5pWvBsGEUPoS
 iMl3eYyfLLSofuqjGMbM4wUrudMO0R/FDg7siNw/uC/p5ajmIiaLxEgSJPMq6ZpxfkBY
 GGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=l/rmm4yRSsvMqNS1fY4vFBlPhMuUHHjzRrgzAxA79to=;
 b=Dam4+ZGvy8WJXECBO3SdF5+x/sQeQWaFXlTer1ASAhvx+R4n4UcatodS0hFyWen9Er
 QLkC6Bd24athSkRmLtZ0zrzGrp7KEx+2X33e7bbSHJAlG/QRUWGNN2G38IVQSocXriCn
 dGnSQww/zXhosx7wcRVdkJAkfx4DcsXA9rPvwhPe9TyzXVwPG+DVJsw0guLsP6vL25g6
 PpuuFszThbnnBlxkifzlfRD49cmdN76NrLADuu49LgYA7nxxSn1r6r0XFn7u+tyWs4h2
 JQQCg57FOfWCEmd7NAwtSmlANB22sVLxKegnzwP0OA/sGEv+8QMSV9km/mcR/JbRv4QU
 cdNg==
X-Gm-Message-State: AOAM5324Y0DOESFEXJ5rJ7V2jBaYRLuXxpS7TKi4e6cMj61iKU3vpe+G
 LqHM+OS2bVgqUt8oSZi0LjcjwkyQyZ+ZdeS1IgAO51g+Zt4xIxL32ghWn3R6c9KnCruz6WIld8i
 bg1rQW1nQhKTTCqDmB5COUqen4dgGCiMxEZCIJUIF/2oYVg4mePmnDbqBdFMeN2RjCKnV9A==
X-Google-Smtp-Source: ABdhPJxqJm57E//xOdCX4WCXVZjUrqNUYyljxqpnPuWUFsEq6c7Gk5Le23qDqL92nnWaoyWg9T/ysARS8c0=
X-Received: by 2002:a5b:34f:: with SMTP id q15mr561948ybp.23.1594838761258;
 Wed, 15 Jul 2020 11:46:01 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:34 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-34-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 33/37] KVM: arm64: Remove __activate_vm wrapper
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

This wrapper serves no useful function and has a misleading name as it
simply calls __load_guest_stage2 and does not touch HCR_EL2.VM

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  5 -----
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 10 +++++-----
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 18a8ecc2e3a6..84fd6b0601b2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -127,11 +127,6 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline void __activate_vm(struct kvm_s2_mmu *mmu)
-{
-	__load_guest_stage2(mmu);
-}
-
 static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 {
 	u64 par, tmp;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c87b0a709d35..fa90fc776374 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -59,7 +59,7 @@ static void __deactivate_traps(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu
 static void __restore_stage2(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.hcr_el2 & HCR_VM)
-		__activate_vm(kern_hyp_va(vcpu->arch.hw_mmu));
+		__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
 	else
 		write_sysreg(0, vttbr_el2);
 }
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 04ee01774ea2..bc372629e1c1 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -120,12 +120,12 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	 * HCR_EL2.TGE.
 	 *
 	 * We have already configured the guest's stage 1 translation in
-	 * kvm_vcpu_load_sysregs_vhe above.  We must now call __activate_vm
-	 * before __activate_traps, because __activate_vm configures
-	 * stage 2 translation, and __activate_traps clear HCR_EL2.TGE
-	 * (among other things).
+	 * kvm_vcpu_load_sysregs_vhe above.  We must now call
+	 * __load_guest_stage2 before __activate_traps, because
+	 * __load_guest_stage2 configures stage 2 translation, and
+	 * __activate_traps clear HCR_EL2.TGE (among other things).
 	 */
-	__activate_vm(vcpu->arch.hw_mmu);
+	__load_guest_stage2(vcpu->arch.hw_mmu);
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 	__activate_traps(vcpu);
 
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
