Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EACDC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:55:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05D6861401
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:55:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 05D6861401
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B08A24B21A;
	Fri, 24 Sep 2021 08:55:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LUF5iu4961rC; Fri, 24 Sep 2021 08:55:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 734234B216;
	Fri, 24 Sep 2021 08:55:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E73924B08D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:55:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o9c2AGwuoq+b for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:55:00 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE95A4B21F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:55:00 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 w10-20020ac87e8a000000b002a68361412bso29121311qtj.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=y44fzIX1ftLMcQsIMexqk7MlH9WcFM4Uf4DFLHOV8zw=;
 b=kbcSGdX6W1DTAU32KsoIRyu5RXf3fqm9Ft5iyr3m/VyqUU0YPxHG/sYle+VkB16whN
 9piwWyrAzf3Hxu30Th595VibMFLO2rpVfcxRv8/4Vr3TxfZOOinM57oyVhs3Lyv3EEw9
 3CD8zN0/CXFY+HOMRwnQZFvaTz/vPVp1e2YFjT8nonSduXGwPCwDIb6KxRjLfSKyrEtU
 rm8/pwdZ5NhnzCLYTqiDn9sxDW66NgWRbLMVtkQ6y1APguvqZIitvKc9pajmjDzx7G2S
 D3fDEfhzx/5Av6NBQz11mDPmB0KHsuaTGp3D1kawfgMWZ5D6+PDgqcBdRjHtYliJMgMP
 flYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=y44fzIX1ftLMcQsIMexqk7MlH9WcFM4Uf4DFLHOV8zw=;
 b=Dx3fYZHndzd7H0P9F7fu1O5RPjmKbAA3vqUdaShCJNp4Ite66angANp6JxYzB25N7D
 gPXy30SbW3nYch9DPLK9dLhRkTxY4X4njdicbK2bCW0ONoN3uSQCpz+7Umve5jJ5xEJg
 Tm1wYMH3vXigOfMbJx6pdZFDxpB+r0ZdoZfmjmQn+OWQdbcj8lHSLHZ3Y1XXBI6+Mbs2
 2Q8xJirzcWlMIaIuz7rBpS7ok1zKYYAGGVmTtFV405UIi5DHtNozrJtaSgZQ4mH4aZj3
 h715W7TiM8IbgcUIq8MZ0cnHNvFLM5uD/weqZn5Lb96J0Nk6PD+9LXJXCwfvW4D1sh+u
 HiWA==
X-Gm-Message-State: AOAM531gBXzIknIuZnvxE/JBYd7KuSzWG3jhbb0jAzI/aqT7KL9bIaO2
 sz74FXImmV/BILPHrulaBRazdh2jhUZ0obg7AEStPhR71HlDPI5o8XInzBzjiXX/27bJrOdBj9k
 FBlhv51feiQeZkQ4x17BD+xDIhmlkzdVUCQnDKHp9i0yPijiBKrC3dlEfYLtNzNHvEEs=
X-Google-Smtp-Source: ABdhPJwzDg459e5SoIW1gM5OBltgwgX9FKJl95y+IxUYvre8ucu6ik03AQSvZPZnEMDcAv3LYlxmQdXBGA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:2e4:: with SMTP id
 h4mr9596859qvu.3.1632488100413; Fri, 24 Sep 2021 05:55:00 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:57 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-29-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 28/30] KVM: arm64: reduce scope of pVM fixup_guest_exit
 to hyp_state and kvm_cpu_ctxt
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Reduce the scope of fixup_guest_exit for protected VMs to only
need hyp_state and kvm_cpu_ctxt

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 23 +++++++++++++++++++----
 arch/arm64/kvm/hyp/nvhe/switch.c        |  7 ++-----
 arch/arm64/kvm/hyp/vhe/switch.c         |  3 +--
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 3ef429cfd9af..ea9571f712c6 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -423,11 +423,8 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  * the guest, false when we should restore the host state and return to the
  * main run loop.
  */
-static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, struct vgic_dist *vgic, u64 *exit_code)
+static inline bool _fixup_guest_exit(struct kvm_vcpu *vcpu, struct vgic_dist *vgic, struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps, u64 *exit_code)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		hyp_state_fault(vcpu_hyps).esr_el2 = read_sysreg_el2(SYS_ESR);
 
@@ -518,6 +515,24 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, struct vgic_dist *vgi
 	return true;
 }
 
+static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+	struct vcpu_hyp_state *hyps = &vcpu->arch.hyp_state;
+	// TODO: create helper for getting VA
+	struct kvm *kvm = vcpu->kvm;
+
+	if (is_nvhe_hyp_code())
+		kvm = kern_hyp_va(kvm);
+
+	return _fixup_guest_exit(vcpu, &kvm->arch.vgic, ctxt, hyps, exit_code);
+}
+
+static inline bool fixup_pvm_guest_exit(struct kvm_vcpu *vcpu, struct vgic_dist *vgic, struct kvm_cpu_context *ctxt, struct vcpu_hyp_state *hyps, u64 *exit_code)
+{
+	return _fixup_guest_exit(vcpu, vgic, ctxt, hyps, exit_code);
+}
+
 static inline void __kvm_unexpected_el2_exception(void)
 {
 	extern char __guest_exit_panic[];
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index aa0dc4f0433b..1920aebbe49a 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -182,8 +182,6 @@ static int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &vcpu->arch.hyp_state;
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu->arch.ctxt;
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct vgic_dist *vgic = &kvm->arch.vgic;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	bool pmu_switch_needed;
@@ -245,7 +243,7 @@ static int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 		exit_code = __guest_enter(guest_ctxt);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
+	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
@@ -285,7 +283,6 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct vgic_dist *vgic = &kvm->arch.vgic;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
@@ -325,7 +322,7 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 		exit_code = __guest_enter(guest_ctxt);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
+	} while (fixup_pvm_guest_exit(vcpu, &kvm->arch.vgic, vcpu_ctxt, vcpu_hyps, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__timer_disable_traps();
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7f926016cebe..4a05aff37325 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -110,7 +110,6 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
@@ -148,7 +147,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 		exit_code = __guest_enter(guest_ctxt);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
+	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
