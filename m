Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75004C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8DC864F37
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8DC864F37
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92BB34B1FD;
	Thu,  4 Mar 2021 06:55:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SCII2TYBz8RO; Thu,  4 Mar 2021 06:55:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA6374B613;
	Thu,  4 Mar 2021 06:55:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 198D24B3B4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OqnoZv2cqlXe for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 06:55:27 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 46A544B616
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:27 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id f9so4377293wml.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 03:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=OiZpXDKllD6faQeY+ISCMbgMo/47OtYWnkWC6xd58k4=;
 b=UM/Z9HxYkNtCY91A9AOXb1GpONC1Umnj2UW6QYUdwFC0W8Gb4XWUgevy8dXc4t8R9A
 1XrezOqL7CflBbpyknFZa+fxxiWlPZenv69xhIpb8w9fnDoD6kLCg3M5bkT9tJ0VflDN
 rSPfjgyGSPrUfBOX9gCu1/Tpg0gxr+Dag25hi8aSaRuf/OiCwa3ryAXBWlsjNlJy4WM1
 f17PxISVlnLnFgmq/xw8kfmh4tcEu4StlXqoVPRqQP3AZiA2P/ibl2KVdD0Fi/BA9UoT
 iLoeGoDn/GAsKiRpAG/aR8CMk7XksU8GA0UNCJbvT6FsCKTodlCdc4oSDJbEtVtarIU3
 UbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OiZpXDKllD6faQeY+ISCMbgMo/47OtYWnkWC6xd58k4=;
 b=ki7LCUOjNlhta5C5XUqqBdwWIxxNq9XDVSpOUKXyhe75M8BQ7iPQ8d5HYYzXkEGISn
 q8TDZgTLta9SzHj09MW+miwW2bHZ+Nplxn5W/U/sZJ/A+Z89DymnkTvOf6paU65HEVqT
 EnzbOIaxeU12jf9aOqkEk/26nx1TgqXZVcYuaxZDbfM/V0Px5bySO38om4SFNC12XzXo
 ZouYROqQ7LSPrZM/A8QZqDEiuB69UIyJdQTrr5Kr10piIvCFWWGwgS+ptxl/oRKLv2TK
 yCzjzy9ICw5mLftpYpthsZGDy9RdNAYmzvsjiC+vC/MG0fBrLFs/DwjS8LjIl92Twpao
 snXQ==
X-Gm-Message-State: AOAM530m3AjOb2aUgWGKWuX/gOv97hLBEB163+S1ZMpq1CRvMZfMbKoE
 C1zLYIt0cDXOPnaofCnMBGhAWpN/H7dkRXeGXkRdxSfOU8P6zIOubq/UfjACwdE7n83YXQoeGpx
 5ajHnqtTatQCVYH8wHHr+TRyvqTJUqtPa/GQ50BESnPS9pItLmwfc6XzsB+IgQFH7U9w9Jw==
X-Google-Smtp-Source: ABdhPJx4DEgrbojP/5L0qk7LADEtX4qlpW9nw2YzD96fhoam5l2vKn3tzA2CO3nPMSmzJfjB/0avUzEBlIA=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a1c:c903:: with SMTP id
 f3mr3548534wmb.69.1614858926516; 
 Thu, 04 Mar 2021 03:55:26 -0800 (PST)
Date: Thu,  4 Mar 2021 11:54:50 +0000
In-Reply-To: <20210304115454.3597879-1-ascull@google.com>
Message-Id: <20210304115454.3597879-8-ascull@google.com>
Mime-Version: 1.0
References: <20210304115454.3597879-1-ascull@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 07/10] KVM: arm64: Separate host and hyp vcpu FP flags
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

The FP flags on the vcpu are used as arguments to hyp and to track the
state as hyp runs. In protected mode, this sort of state needs to be
safe from meddling by the host. Begin the separation with the FP flags.

Since protected mode is only available for nVHE and nVHE does not yet
support SVE, the SVE flags are left untouched.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_host.h       | 33 ++++++++++++++++++-------
 arch/arm64/kvm/fpsimd.c                 | 24 +++++++++---------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  6 ++---
 arch/arm64/kvm/hyp/nvhe/switch.c        |  4 +--
 arch/arm64/kvm/hyp/vhe/switch.c         |  4 +--
 5 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a01194371ae5..8c5242d4ed73 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -268,6 +268,16 @@ struct vcpu_reset_state {
 	bool		reset;
 };
 
+/*
+ * State that affects the behaviour of hyp when running a vcpu. In protected
+ * mode, the hypervisor will have a private copy of this state so that the host
+ * cannot interfere with the hyp while it is running.
+ */
+struct kvm_vcpu_arch_run {
+	/* Miscellaneous vcpu run state flags */
+	u64 flags;
+};
+
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 	void *sve_state;
@@ -289,6 +299,9 @@ struct kvm_vcpu_arch {
 	/* Miscellaneous vcpu state flags */
 	u64 flags;
 
+	/* State to manage running of the vcpu by hyp */
+	struct kvm_vcpu_arch_run run;
+
 	/*
 	 * We maintain more than a single set of debug registers to support
 	 * debugging the guest from the host and to maintain separate host and
@@ -390,15 +403,17 @@ struct kvm_vcpu_arch {
 
 /* vcpu_arch flags field values: */
 #define KVM_ARM64_DEBUG_DIRTY		(1 << 0) /* vcpu is using debug */
-#define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
-#define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
-#define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
-#define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
-#define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
-#define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
-#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
-#define KVM_ARM64_PENDING_EXCEPTION	(1 << 8) /* Exception pending */
-#define KVM_ARM64_EXCEPT_MASK		(7 << 9) /* Target EL/MODE */
+#define KVM_ARM64_HOST_SVE_IN_USE	(1 << 1) /* backup for host TIF_SVE */
+#define KVM_ARM64_HOST_SVE_ENABLED	(1 << 2) /* SVE enabled for EL0 */
+#define KVM_ARM64_GUEST_HAS_SVE		(1 << 3) /* SVE exposed to guest */
+#define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 4) /* SVE config completed */
+#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 5) /* PTRAUTH exposed to guest */
+#define KVM_ARM64_PENDING_EXCEPTION	(1 << 6) /* Exception pending */
+#define KVM_ARM64_EXCEPT_MASK		(7 << 7) /* Target EL/MODE */
+
+/* vcpu_arch_run flags field values: */
+#define KVM_ARM64_RUN_FP_ENABLED	(1 << 0) /* guest FP regs loaded */
+#define KVM_ARM64_RUN_FP_HOST		(1 << 1) /* host FP regs loaded */
 
 /*
  * When KVM_ARM64_PENDING_EXCEPTION is set, KVM_ARM64_EXCEPT_MASK can
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index dcc5bfad5408..74a4b55d1b37 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -43,8 +43,9 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
  * Prepare vcpu for saving the host's FPSIMD state and loading the guest's.
  * The actual loading is done by the FPSIMD access trap taken to hyp.
  *
- * Here, we just set the correct metadata to indicate that the FPSIMD
- * state in the cpu regs (if any) belongs to current on the host.
+ * Here, we just set the correct metadata to indicate that the FPSIMD state in
+ * the cpu regs (if any) belongs to current on the host and will need to be
+ * saved before replacing it.
  *
  * TIF_SVE is backed up here, since it may get clobbered with guest state.
  * This flag is restored by kvm_arch_vcpu_put_fp(vcpu).
@@ -55,9 +56,10 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 
 	BUG_ON(!current->mm);
 
-	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
-			      KVM_ARM64_FP_HOST |
-			      KVM_ARM64_HOST_SVE_IN_USE |
+	vcpu->arch.run.flags &= ~(KVM_ARM64_RUN_FP_ENABLED |
+				  KVM_ARM64_RUN_FP_HOST);
+
+	vcpu->arch.flags &= ~(KVM_ARM64_HOST_SVE_IN_USE |
 			      KVM_ARM64_HOST_SVE_ENABLED);
 
 	if (!system_supports_fpsimd())
@@ -70,9 +72,9 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
 		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));
 
-		vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
+		vcpu->arch.run.flags |= KVM_ARM64_RUN_FP_ENABLED;
 	} else {
-		vcpu->arch.flags |= KVM_ARM64_FP_HOST;
+		vcpu->arch.run.flags |= KVM_ARM64_RUN_FP_HOST;
 	}
 
 	if (test_thread_flag(TIF_SVE))
@@ -99,8 +101,8 @@ void kvm_arch_vcpu_sync_fp_before_hyp(struct kvm_vcpu *vcpu)
 		return;
 
 	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
-		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
-				      KVM_ARM64_FP_HOST);
+		vcpu->arch.run.flags &= ~(KVM_ARM64_RUN_FP_ENABLED |
+					  KVM_ARM64_RUN_FP_HOST);
 }
 
 /*
@@ -113,7 +115,7 @@ void kvm_arch_vcpu_sync_fp_after_hyp(struct kvm_vcpu *vcpu)
 {
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
+	if (vcpu->arch.run.flags & KVM_ARM64_RUN_FP_ENABLED) {
 		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fp_regs,
 					 vcpu->arch.sve_state,
 					 vcpu->arch.sve_max_vl);
@@ -137,7 +139,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	local_irq_save(flags);
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
+	if (vcpu->arch.run.flags & KVM_ARM64_RUN_FP_ENABLED) {
 		fpsimd_thread_switch(current);
 
 		if (guest_has_sve)
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 1afee8557ddf..3f299c7d42cd 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -227,7 +227,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 
 	isb();
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
+	if (vcpu->arch.run.flags & KVM_ARM64_RUN_FP_HOST) {
 		/*
 		 * In the SVE case, VHE is assumed: it is enforced by
 		 * Kconfig and kvm_arch_init().
@@ -243,7 +243,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
 		}
 
-		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
+		vcpu->arch.run.flags &= ~KVM_ARM64_RUN_FP_HOST;
 	}
 
 	if (sve_guest) {
@@ -261,7 +261,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.fpsimd_cpu = smp_processor_id();
 
-	vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
+	vcpu->arch.run.flags |= KVM_ARM64_RUN_FP_ENABLED;
 
 	return true;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6fc1e0a5adaa..f0a32c993ac4 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -41,7 +41,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TZ | CPTR_EL2_TAM;
-	if (!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED)) {
+	if (!(vcpu->arch.run.flags & KVM_ARM64_RUN_FP_ENABLED)) {
 		val |= CPTR_EL2_TFP;
 		__activate_traps_fpsimd32(vcpu);
 	}
@@ -230,7 +230,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
+	if (vcpu->arch.run.flags & KVM_ARM64_RUN_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
 	/*
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index f6f60a537b3e..5bb6a2cf574d 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -54,7 +54,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val |= CPTR_EL2_TAM;
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
+	if (vcpu->arch.run.flags & KVM_ARM64_RUN_FP_ENABLED) {
 		if (vcpu_has_sve(vcpu))
 			val |= CPACR_EL1_ZEN;
 	} else {
@@ -151,7 +151,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
+	if (vcpu->arch.run.flags & KVM_ARM64_RUN_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
