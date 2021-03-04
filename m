Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A63C433E6
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08A9564F34
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08A9564F34
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC7814B639;
	Thu,  4 Mar 2021 06:55:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2DgmlURWqexi; Thu,  4 Mar 2021 06:55:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4126E4B663;
	Thu,  4 Mar 2021 06:55:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A89B54B649
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z0wVtX9mqMHo for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 06:55:31 -0500 (EST)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFC994B637
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:30 -0500 (EST)
Received: by mail-qt1-f202.google.com with SMTP id i16so9978458qtv.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 03:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=cNgXY/JFeSU7Z1MXcmjC3/D4Sn13+fSA212rRQ4AWSs=;
 b=KMVxFgtdo80qKgtWKMZxbVIQ8fC5xT83qT25MVgUwg0yYpLNsJ4KHOUGujY8D52yYg
 925YdL+3UiGRRriPdMhXuNWuMcBW2IP9Z9rvmYd7eAccLEKXNRMY6JWKWLb1dCFOxMy+
 XbBpuieIBMqXiZZSzA10a64MEBshvWVUx12OLZnjZu/0zCB162aWRZqIx/beSBq96Qct
 Rd1jjaal5Qj6e0kNbblsCZPSrlnUjHJPwbmEOu8Aoj/gGaU8Z4Tm+eYsuu0qoD4taUOx
 J8OJWc+aO5XZeYMXOBss4bRNN6zydNSpj6lpYRDY6RQxdWuTxJQftTV9KvtgkC8mhSwM
 kH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cNgXY/JFeSU7Z1MXcmjC3/D4Sn13+fSA212rRQ4AWSs=;
 b=nIxZAnN8p+ijwEmkf5pmzJR0nFtPWCBwItNyPPj3SerVK95mDftA5W0lM2erSjornJ
 riIKiZoNwtfG91FbT3UplH35jUccfWDGb/XxCUsI3cgY+mx+AdriPojBHCngO5lpzVcx
 IM+b3ODe8UCUsjpfebwkZAp+fAR8Llj5GC1GkSmH3B7E4aIiI6/lTuzbUZDOGVKocAGB
 mwbUX0S16fw4Q3LGWTUgEgeKswDYQttNmTt7gaS/YxH6VIyA1nxw0Z3/rzghsLLGdOTP
 XR8IHNhF3VfqVkzc4+mOboeWDj14pm4uB9I8B1+AWbCUzbyevvLNEjKTjTTWdI4aNCKE
 cN8w==
X-Gm-Message-State: AOAM531/qwXMlNsuP0nzbpaIp/Hvu+nFv/+W+rRrGi+QfYEqjifF6K/z
 bU2od/jNc4io7xtXWavfZq87uG3DlbWKjgKjgF9amuIGVKEFGzXcT3gWVifh2oe8c826H1M4KA9
 WVuW1WxAQOL/dmVrJ91MQCuG5qzfPuVql/nEEoXHv+CTTe7ZXm/r8jWD6NK9/Z2pj0WA7oA==
X-Google-Smtp-Source: ABdhPJwwBTfPpqEORV77vf/p970MNc5byRFVQ1yNfvsYgF1PWsxKeJvEleqeb+GINqfqaYSGe8Ihc/2zZKI=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a0c:b894:: with SMTP id
 y20mr3721186qvf.43.1614858930354; 
 Thu, 04 Mar 2021 03:55:30 -0800 (PST)
Date: Thu,  4 Mar 2021 11:54:52 +0000
In-Reply-To: <20210304115454.3597879-1-ascull@google.com>
Message-Id: <20210304115454.3597879-10-ascull@google.com>
Mime-Version: 1.0
References: <20210304115454.3597879-1-ascull@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 09/10] KVM: arm64: Use hyp-private run struct in protected mode
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

The run struct affects how hyp handles the guest's state so it needs to
be kept safe from the host in protected mode. Copy the relevant values
into hyp-private memory while running a vcpu to achieve this.

In the traditional, non-protected, mode, there's no need to protect the
values from the host so the run struct in host memory is used directly.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 33 +++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 076c2200324f..a0fbaf0ee309 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -165,9 +165,26 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+/* Snapshot state from the host to private memory and sanitize them. */
+void __sync_vcpu_before_run(struct kvm_vcpu *vcpu, struct kvm_vcpu_arch_run *run)
+{
+	run->flags = vcpu->arch.run.flags;
+
+	/* Clear host state to make misuse apparent. */
+	vcpu->arch.run.flags = 0;
+}
+
+/* Sanitize the run state before writing it back to the host. */
+void __sync_vcpu_after_run(struct kvm_vcpu *vcpu, struct kvm_vcpu_arch_run *run)
+{
+	vcpu->arch.run.flags = run->flags;
+}
+
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
+	struct kvm_vcpu_arch_run protected_run;
+	struct kvm_vcpu_arch_run *run;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	bool pmu_switch_needed;
@@ -184,6 +201,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		pmr_sync();
 	}
 
+	if (is_protected_kvm_enabled()) {
+		run = &protected_run;
+		__sync_vcpu_before_run(vcpu, run);
+	} else {
+		run = &vcpu->arch.run;
+	}
+
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
@@ -206,7 +230,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
 	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
-	__activate_traps(vcpu, &vcpu->arch.run);
+	__activate_traps(vcpu, run);
 
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps(vcpu);
@@ -218,7 +242,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, &vcpu->arch.run, &exit_code));
+	} while (fixup_guest_exit(vcpu, run, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
@@ -230,7 +254,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (vcpu->arch.run.flags & KVM_ARM64_RUN_FP_ENABLED)
+	if (run->flags & KVM_ARM64_RUN_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
 	/*
@@ -248,6 +272,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	host_ctxt->__hyp_running_vcpu = NULL;
 
+	if (is_protected_kvm_enabled())
+		__sync_vcpu_after_run(vcpu, run);
+
 	return exit_code;
 }
 
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
