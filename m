Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE93C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 30C86208B3
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Wj17iHI2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30C86208B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90B024B2AF;
	Thu,  3 Sep 2020 09:53:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3KHhaSITimUe; Thu,  3 Sep 2020 09:53:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E0714B2A4;
	Thu,  3 Sep 2020 09:53:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 909314B249
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2nIdGqLecf1c for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:15 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 863124B2A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:15 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id o6so990463wrp.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=BnMJBgJiDhVxiUGYUS5SOi8paRTmIE3UJRbLhmkSw7w=;
 b=Wj17iHI2FFBQ+/FbnuZRtQYRpHDe5aImOg9FRfWHF4F4b7q4Qouw9lyqJinF9gfyWn
 B4p1G/hn0qdFVt5QtLRH/xcAjGFE9tke2Z/v+39+kIsTzJT6pjqJ7KXAtSSHBDT/yXWh
 A0o3PMWT4DZaMO8B6RgE9G5+MYfzAScP2ERVJXldYvQAz9WK/duVx4XhULmCML0D9lbp
 uj+CrYODJz99oUf8s45+w/1rICYIQlwNSVH8Fvhr2eSrMGCSO0JCC26Zad0sv6vwTCph
 FockXREocolFDcHpqJy0+yatrCJ+yjBqMIBjMHoGe0Ssw9VN2OR1RRN5v8Or5LomAs3H
 qoZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BnMJBgJiDhVxiUGYUS5SOi8paRTmIE3UJRbLhmkSw7w=;
 b=XXnjtaHNfvoS7u+Vj5LjrdYAQJk0qHgn8faby3Ev1xsgDdhPQBsWzTNt6jdhGbaTia
 oqssa/XQ8vI5cWo33HnTkFHM+zjLvzgrIgASOjuEGDUhxdt2LvDUWjKsTXQhcDZdGZos
 iZUTUbkXXZ3b6vNQbcBxKBugAnNAW8PS/FcZ8kfCdhGxUmkmYhUXl8yw1+uj/CdOza2G
 g+afhVYml7Mgld35i1/gcm2xk2eXz3D6Pdxki6sxFTeaYzfaBiWeWlX9tIF9PQvlzZl0
 Tk+iV9yhgUg5FvTCVWgQzvmTdyndM24XqcEwlHGTTme7pBImjEsVEDfHyA66bAOrXCbT
 CS7g==
X-Gm-Message-State: AOAM532FAFTEeL92aJ/kilfTQ/77X6sMG5nQJrsyRBbT8Y/rnN1OxWDL
 qLZXcI51dv9ef5/uuN2FiaguQpppvsf00mxJ/s5w85B99Rsc0vIY/idiyvLa3nQLouRCCsZJBD8
 Nq1eIVUuyC25LKvxz/d/rB2kQgH02wAydIEkh4rH0qkXBK3wZrClTmXqfnQQ36y+nfHpohg==
X-Google-Smtp-Source: ABdhPJx1b8IwK+r2Pkar5vpwz0NAjhOUWL9h65XWXzWZBmyUP/ImLysk1/0DgwOZon/9BXbR8piMQpCeTdA=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a7b:c019:: with SMTP id
 c25mr720374wmb.0.1599141193462; 
 Thu, 03 Sep 2020 06:53:13 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:52:50 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-2-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 01/18] KVM: arm64: Remove __activate_vm wrapper
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

The __activate_vm wrapper serves no useful function and has a misleading
name as it simply calls __load_guest_stage2 and does not touch
HCR_EL2.VM so remove it.

Also rename __deactivate_vm to __load_host_stage2 to match naming
pattern.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  5 -----
 arch/arm64/kvm/hyp/nvhe/switch.c        |  8 ++++----
 arch/arm64/kvm/hyp/vhe/switch.c         | 10 +++++-----
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 5b6b8fa00f0a..0864f88bc840 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -126,11 +126,6 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
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
index 0970442d2dbc..3c9c065b3264 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -93,7 +93,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
 
-static void __deactivate_vm(struct kvm_vcpu *vcpu)
+static void __load_host_stage2(void)
 {
 	write_sysreg(0, vttbr_el2);
 }
@@ -194,7 +194,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
-	__activate_vm(kern_hyp_va(vcpu->arch.hw_mmu));
+	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
 	__activate_traps(vcpu);
 
 	__hyp_vgic_restore_state(vcpu);
@@ -219,7 +219,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__hyp_vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
-	__deactivate_vm(vcpu);
+	__load_host_stage2();
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
@@ -253,7 +253,7 @@ void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
 	if (read_sysreg(vttbr_el2)) {
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
-		__deactivate_vm(vcpu);
+		__load_host_stage2();
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index c1da4f86ccac..6636522a8529 100644
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
 	__activate_traps(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
-- 
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
