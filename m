Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96788C07E9B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 44DFB61482
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44DFB61482
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E99C44A531;
	Mon, 19 Jul 2021 12:04:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IfhPU2sb4ovd; Mon, 19 Jul 2021 12:04:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAAF84B096;
	Mon, 19 Jul 2021 12:04:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C5EC4A00B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id meQEGya0-yiM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:04:09 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55BA04B0B2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:09 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 ca6-20020ad456060000b02902ea7953f97fso15489838qvb.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=SMvDYa3zVL7ibMIO+tJttZvbwBrpgIyQmskq/9zvomc=;
 b=nGcldOEvZ5gWaVQK3V9NQw9Y7jzhGQff63UdVHhYuhqFTHhJpJgtfItHCpgXnUYWgF
 riofulYZNFspqyBcwCFLJYzHtqPp7NhHlSodygph/7KFIIvnll+TXaRp0kPqqEh/U0Cs
 hDFWRlxh0nov15s4XBnXuod8MiCXG4gUVh+ikbJO7n765CkOWYE+flUQJdauB4NeQ94H
 ihAhIjrc1bevXuKouvZqlPPKHhtbR0NSN5zY5CxKWS3eMe/lfvR0H93BDEfyvf4b4WLL
 G84YFwcjbBHDCk/WjsnL3veSJD7H1hP4jcoOsJGM1B81Rz0uuU4xj50iHAK7mizg8DuJ
 vM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SMvDYa3zVL7ibMIO+tJttZvbwBrpgIyQmskq/9zvomc=;
 b=rkHavza8QTroq2h91d46JIHhReA2hMwurc0NzKWAqQsWadM64b6cKerFHFO17uKvJU
 Radl89OK592bh42iFHOu5/45zfGkr+rR9tDp8eC2GFT3XybkJr4cwMbwhJTcL179A38/
 a1pllxM50WQs8Z5sQFDjVAEODs5aLniBHsQizWZY100UFF3guBYVLIy6ie78kFtqq2mr
 KYHqgszhm5YGRtqW2GecpOqrX/AtndRRzzEMY5ChMDS3spzqOgRrAbEW8QYj+WmhJmgo
 kmWpZXY9SqJOem3tyi6wDYQMEt2d0+7TBs/AUkm28njL0VE/vaHS012bwMHxUmKabM8e
 kyyA==
X-Gm-Message-State: AOAM532ZEs9U595HQpbaMUXTrQJQxH53ArD2ws2x6Hpp7ctuEEzczTSS
 KytwggZc7uxljvae6zyqNLIAgemOr1Y/zj4XXRdQ/6KptBcNANVuSMAPEqEkVlnXebKGaOw3Pjj
 clnrnrp7subZ5jZZhU42qCIQOhEmvxVPPO+MwgEFC1oljgydEHfu6dqwcm516LRM3xR0=
X-Google-Smtp-Source: ABdhPJwjha9rcUJY9NIyV03u/us5GcujWpRscIOZkLe7Tu5+P5KuYptKASNahYciLnoOFUq0gk0t4prOVg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:4bae:: with SMTP id
 i14mr25407298qvw.24.1626710648907; 
 Mon, 19 Jul 2021 09:04:08 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:41 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-11-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 10/15] KVM: arm64: Guest exit handlers for nVHE hyp
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Add an array of pointers to handlers for various trap reasons in
nVHE code.

The current code selects how to fixup a guest on exit based on a
series of if/else statements. Future patches will also require
different handling for guest exists. Create an array of handlers
to consolidate them.

No functional change intended as the array isn't populated yet.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 43 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 35 ++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a0e78a6027be..5a2b89b96c67 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -409,6 +409,46 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+typedef int (*exit_handle_fn)(struct kvm_vcpu *);
+
+exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);
+
+static exit_handle_fn kvm_get_hyp_exit_handler(struct kvm_vcpu *vcpu)
+{
+	return is_nvhe_hyp_code() ? kvm_get_nvhe_exit_handler(vcpu) : NULL;
+}
+
+/*
+ * Allow the hypervisor to handle the exit with an exit handler if it has one.
+ *
+ * Returns true if the hypervisor handled the exit, and control should go back
+ * to the guest, or false if it hasn't.
+ */
+static bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu)
+{
+	bool is_handled = false;
+	exit_handle_fn exit_handler = kvm_get_hyp_exit_handler(vcpu);
+
+	if (exit_handler) {
+		/*
+		 * There's limited vcpu context here since it's not synced yet.
+		 * Ensure that relevant vcpu context that might be used by the
+		 * exit_handler is in sync before it's called and if handled.
+		 */
+		*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
+		*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
+
+		is_handled = exit_handler(vcpu);
+
+		if (is_handled) {
+			write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
+			write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
+		}
+	}
+
+	return is_handled;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -496,6 +536,9 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			goto guest;
 	}
 
+	/* Check if there's an exit handler and allow it to handle the exit. */
+	if (kvm_hyp_handle_exit(vcpu))
+		goto guest;
 exit:
 	/* Return to the host kernel and handle the exit */
 	return false;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 86f3d6482935..36da423006bd 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -158,6 +158,41 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+typedef int (*exit_handle_fn)(struct kvm_vcpu *);
+
+static exit_handle_fn hyp_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_WFx]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= NULL,
+	[ESR_ELx_EC_CP15_64]		= NULL,
+	[ESR_ELx_EC_CP14_MR]		= NULL,
+	[ESR_ELx_EC_CP14_LS]		= NULL,
+	[ESR_ELx_EC_CP14_64]		= NULL,
+	[ESR_ELx_EC_HVC32]		= NULL,
+	[ESR_ELx_EC_SMC32]		= NULL,
+	[ESR_ELx_EC_HVC64]		= NULL,
+	[ESR_ELx_EC_SMC64]		= NULL,
+	[ESR_ELx_EC_SYS64]		= NULL,
+	[ESR_ELx_EC_SVE]		= NULL,
+	[ESR_ELx_EC_IABT_LOW]		= NULL,
+	[ESR_ELx_EC_DABT_LOW]		= NULL,
+	[ESR_ELx_EC_SOFTSTP_LOW]	= NULL,
+	[ESR_ELx_EC_WATCHPT_LOW]	= NULL,
+	[ESR_ELx_EC_BREAKPT_LOW]	= NULL,
+	[ESR_ELx_EC_BKPT32]		= NULL,
+	[ESR_ELx_EC_BRK64]		= NULL,
+	[ESR_ELx_EC_FP_ASIMD]		= NULL,
+	[ESR_ELx_EC_PAC]		= NULL,
+};
+
+exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
+{
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u8 esr_ec = ESR_ELx_EC(esr);
+
+	return hyp_exit_handlers[esr_ec];
+}
+
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
