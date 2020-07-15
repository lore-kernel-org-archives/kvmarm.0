Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A57BCC433F1
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 640EA207BC
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="WCkXUeWk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 640EA207BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DD114B3DC;
	Wed, 15 Jul 2020 14:45:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rIO5HJPi7Duy; Wed, 15 Jul 2020 14:45:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA1A44B238;
	Wed, 15 Jul 2020 14:45:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 168B44B1CC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xVEOmConIHZM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:18 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C449B4B3E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:17 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id t36so1992501qtc.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=DzLM30YLaDahBmFN2vdswcf6xS4U0YF4/in7tp2e7Ac=;
 b=WCkXUeWkGWipxkJCnWezDbCCye5WPmn66w/ehPc0Z+l4toQG+0YCSl7fVleP8jhhgW
 uugm9ZqV3oEtfBPpC+awJS7TWFvCoVyYiI1lWmJCrJuP8GQBQ0ShSQjzSzQS5p7GN+MR
 XKt/prGdwBu/JEwQKYsaSiuVdoRBDDmDBCz+MXPbUfQn/ir3YXBtoBlTU6izDGkDl03b
 w857hVaR/7JH/pIYsV9d2yidZAzaveOevBG4byZs9XsQak6XwYprLKUL9g6KAmzVQ5El
 osO9X33dyLac7cgFNOmd0mTe3MVXgjzP501wWF+UKJmXuIqMwbnsjDCKbIIxuo21InCb
 uBVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DzLM30YLaDahBmFN2vdswcf6xS4U0YF4/in7tp2e7Ac=;
 b=agTFVLGLvFqtEZZOOXneZ4V88b1p7O3Pc2ccoYDCoSUgctTIWzhzkObdN2665Yq4by
 T7wjzS/JhVMwB06rA8Y+2VmJuY2WlFtTC7n3u9pX5NjfS1Zuvayxe2z7FSg8OnhoBls6
 YhEXHAoa+3lHqWjvEl50bRrab/xGmUMdlvyzv/RV5pJIQYdLySRS+F6L1l1wpOFMlBGa
 jXT30aWSwj7/hyDHPLPBCXQOxUm8AXPlFuyXgJ9C9Ao0QVBl7jXWj96Bil9eaWDCU1z3
 IzJVyi+M6F2ygwgPJcya9T/r8dPmRB4zgLbzC+J3z5RdAfUJeZ4Al+0V5wpz3aTsxCF3
 6vuA==
X-Gm-Message-State: AOAM531CBFaY/i4JjDj3yey8DVilywPC3SIsoFZD5Cx/2m9GMa2pms1c
 m7SyPzAU3UksD4RvUZmnVxp7V5SLippWM5tC36UBZX8K9n7MSA7TnVQ1zXkRAcsWmOSCcFdbdNG
 iUHlTyLBSBJ5OHp/us5qq8Nqd8NqPPidXHrs84BtYfRAlepGsfHzqaRRHrCCNTfB58vuXxQ==
X-Google-Smtp-Source: ABdhPJz07yNAPawl1Q7Sa9Gv1Ygjsv3jpDz+jg0pE43kpSN1W13sgdR3OGkk29zNgxuysvvAQvOjhQt9dpM=
X-Received: by 2002:a0c:ea26:: with SMTP id t6mr708145qvp.220.1594838717224;
 Wed, 15 Jul 2020 11:45:17 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:14 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-14-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 13/37] KVM: arm64: Rename workaround 2 helpers
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

Change the names from 'guest' and 'host' to terms that can also apply
when the host is treated as a vcpu and hyp has its own state.

'guest' becomes 'vcpu' as the host is now also a vcpu.

'host' becomes 'hyp' as the nVHE hyp is gaining indepedent state and the
VHE hyp _is_ the host anyway.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c         |  4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 248f434c5de6..fa62c2b21b4b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -484,15 +484,15 @@ static inline bool __needs_ssbd_off(struct kvm_vcpu *vcpu)
 	if (!cpus_have_final_cap(ARM64_SSBD))
 		return false;
 
-	return !(vcpu->arch.workaround_flags & VCPU_WORKAROUND_2_FLAG);
+	return !kvm_arm_get_vcpu_workaround_2_flag(vcpu);
 }
 
-static inline void __set_guest_arch_workaround_state(struct kvm_vcpu *vcpu)
+static inline void __set_vcpu_arch_workaround_state(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_ARM64_SSBD
 	/*
-	 * The host runs with the workaround always present. If the
-	 * guest wants it disabled, so be it...
+	 * The hyp runs with the workaround always present. If the
+	 * vpu wants it disabled, so be it...
 	 */
 	if (__needs_ssbd_off(vcpu) &&
 	    __hyp_this_cpu_read(arm64_ssbd_callback_required))
@@ -500,11 +500,11 @@ static inline void __set_guest_arch_workaround_state(struct kvm_vcpu *vcpu)
 #endif
 }
 
-static inline void __set_host_arch_workaround_state(struct kvm_vcpu *vcpu)
+static inline void __set_hyp_arch_workaround_state(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_ARM64_SSBD
 	/*
-	 * If the guest has disabled the workaround, bring it back on.
+	 * If the vcpu has disabled the workaround, bring it back on.
 	 */
 	if (__needs_ssbd_off(vcpu) &&
 	    __hyp_this_cpu_read(arm64_ssbd_callback_required))
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index d866bff8a142..81cdf33f92bc 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -200,7 +200,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__debug_switch_to_guest(vcpu);
 
-	__set_guest_arch_workaround_state(vcpu);
+	__set_vcpu_arch_workaround_state(vcpu);
 
 	do {
 		/* Jump in the fire! */
@@ -209,7 +209,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-	__set_host_arch_workaround_state(vcpu);
+	__set_hyp_arch_workaround_state(vcpu);
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 366dc386224c..d871e79fceaf 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -131,7 +131,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
-	__set_guest_arch_workaround_state(vcpu);
+	__set_vcpu_arch_workaround_state(vcpu);
 
 	do {
 		/* Jump in the fire! */
@@ -140,7 +140,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-	__set_host_arch_workaround_state(vcpu);
+	__set_hyp_arch_workaround_state(vcpu);
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
 
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
