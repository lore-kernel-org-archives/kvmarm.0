Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53EE8C433E2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:46:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C112120B1F
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:46:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="K9Fho3aA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C112120B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 701E74B315;
	Tue, 15 Sep 2020 06:46:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f5kBCYIBFn+J; Tue, 15 Sep 2020 06:46:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41EC14B332;
	Tue, 15 Sep 2020 06:46:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BDD04B315
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:46:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mn5hANtuvsIP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:46:52 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C11F4B338
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:46:51 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id x81so750154wmg.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=FtRrF3HJrkl6Kgil9FQQ7n4eux/aw8pbY+vMb70E3yg=;
 b=K9Fho3aA3AC8h2JWZlbTqFriptK7K6CovKcqq8pV9agNThHbP5wM2/H/P5B6m6sFCn
 HALw8A768wgiih0RDN9VPTiUSP8GhmZmrsgEc8ij8vW6tme9DQtwpmrgGOlZIZ6OBbA8
 980+9LpZiw4vY7yHg08ET8wziCIXkvd/MuwDeFR+C3QkfNl3xOHPptkfiR3308dl0sT5
 icVCNzzHbJkbeBwgHxNgcG0OsE+TFkDK066h9hcyR7cMknspggyEPQDUoEFlgfqsYu9R
 gWH835kQEm46w4T/zoc/y1dIupouOp05i9t2gFr9pDuknpwTyx+3+HGlCLGzcQte/MA8
 82GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FtRrF3HJrkl6Kgil9FQQ7n4eux/aw8pbY+vMb70E3yg=;
 b=EhISyMP7JeXDvV63Bx6IZM8OB6/6jcWptOpSuahbIFVDFxZZwwTRsfhul4Kk9zDYpD
 U6pBcy4o+R1GI1jwgDQPEzyQ6AI3jcFwtopGja0XhE/HSe1jzww2fozFMZHFTRVbauZ/
 AynUYH+VP71D6PIqFSrZfxL/C15O2ETpRl8sE2eNNgFjEIwf0REbQB5g6ODvbzkTUptf
 9kqXBO+N4MT+XZv9ZJjLd+pT4YjLIb1xgdexQAOAiGWBc+IDe951oIGaigOHmWrEvruO
 tz2gjJV1q3IEUzpc3ClBG+YoG9QofCw1ZWTlTCN3TSCtI03Tr1R3RrTCjsSYYXLIVsqV
 gIpw==
X-Gm-Message-State: AOAM530Vz1kGJsVbfReBH3Nc/vyHHxdcybj+QYLv5wujHl+WlkysK++w
 RD4z52UzuSLehObF/bnq3Jj5ZlBal1jIOjWYeH5p5HW4x68F2zZ6/V8Oy596w8dVY87ocnAQ+BA
 T5chvmwALiBAPuDYNU8qOFs0x1qffw6pu7m2FnNBPMXNAk/MueTLAHJ0bt5lvy/+sc6YtRw==
X-Google-Smtp-Source: ABdhPJyqm+zSXSbUB3V/Ze4+quq3syfmDToNa8AuMfnBt6hwP0hrSSR2eK/9U5qEyFzXXGuhoLCQIkzwkQ0=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a5d:5583:: with SMTP id
 i3mr20059308wrv.119.1600166810490; 
 Tue, 15 Sep 2020 03:46:50 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:25 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-2-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 01/19] KVM: arm64: Remove __activate_vm wrapper
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
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
