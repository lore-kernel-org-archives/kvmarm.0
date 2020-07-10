Return-Path: <SRS0=mTyv=AV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F197AC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jul 2020 09:58:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A8FD620767
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jul 2020 09:58:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="HF50uaBx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8FD620767
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 538AA4B140;
	Fri, 10 Jul 2020 05:58:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ajWQZhPEeYs6; Fri, 10 Jul 2020 05:58:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00EF24B160;
	Fri, 10 Jul 2020 05:58:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8FD54B154
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 05:58:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A6EWaUcUjV31 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2020 05:58:29 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0C834B167
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 05:58:28 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id y16so5470583wrr.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 02:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=TPtjeXB9eLfgobcExqCseFPTnQO0EZGF6ZjxPScLvps=;
 b=HF50uaBxNfMQruBCp6z9AUa2gJBZ4pCh8jG/buRd3Cg6S0fF7va8XpyZBzeIrytPYc
 uKlV6W9oQMEiDCgQwjT8oCRLc/a3nD4cUAAQEp2FV3xPoylJX7+4ugG/LV/yci1e2hdw
 P6iCxkoLse1v46huAj6uRcqt4ipvAxP/5ruoDm7L8gyjN0IlSyhBrns1y+OKJG3eeeG9
 UGMfjo16geSDro9iKopZwdK6rUTrtbkbDQ2XkEhGdSiiJz2F8qvfT6BpVmUSqt/h8qvS
 zo5UU35F5dZEbpJg6rywCFAurdXiRhzRsW7tQR867y+ZiKRtGan0v5m8JyrSLQkNBg2p
 hY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=TPtjeXB9eLfgobcExqCseFPTnQO0EZGF6ZjxPScLvps=;
 b=C/bBhsPA+CG4sMf2BEbRtjbn02ersNG0KGm/IWXKyyZeTFE+eWaEtjLqz7vUqTs9F9
 dLanJsIKYckeOqaswgzFjs/KzHwK4ndTzBIYd4zWF11rak4rXPM3Q46ibNDxVN89ynZ6
 qK2D1DNoGzDhnnj8lsHkYr0EUbnpGIXxNbjEHcVQ/rp0c+X/88k+AoQCcXGmEaI1KEcO
 uLbg8Ir4qXPsPk28TBo1qoqJif1tr1v3J/OiUwh0u7wAJLecHIB/VBRn08cmP61K6Cwm
 3OP9Q/j+sGF3kOxXOT5fQwH8rYNVHv3KIWt2h2ViFSTFadIKw/1qDZq+g315XAIlHi4n
 bNPg==
X-Gm-Message-State: AOAM532Zi/J+uhGGETbSwhQd9RWp1AS0hCOdsUeQPwtAXyYyRWXdTo/j
 ic8LV6BJoDH8iED64QJ247Ax8kE3Xa0L57T6IMkHNPKb7nQLmbsjDfvoBjo+aRmTrilo8pNxcEm
 jyL0F6CzE/2uwcBpd7M5j4zSVNvPHxpCWlT69g/KK1ViY6o96VBYGZnXzSncfh3Qf5NdvRA==
X-Google-Smtp-Source: ABdhPJwPIOBT+VCxcwP075E20/DN17+bNLVbWZiVeWVbP/2GP4UspT+GOA3gtA7r0hgu0q1gIp0PLx5wN1Y=
X-Received: by 2002:a7b:c5c4:: with SMTP id n4mr4260312wmk.67.1594375107824;
 Fri, 10 Jul 2020 02:58:27 -0700 (PDT)
Date: Fri, 10 Jul 2020 10:57:54 +0100
In-Reply-To: <20200710095754.3641976-1-ascull@google.com>
Message-Id: <20200710095754.3641976-3-ascull@google.com>
Mime-Version: 1.0
References: <20200710095754.3641976-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH 2/2] KVM: arm64: Leave vcpu FPSIMD synchronization in host
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com, dave.martin@arm.com
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

The task state can be checked by the host and the vcpu flags updated
before calling into hyp. This more neatly separates the concerns and
removes the need to map the task flags to EL2.

Hyp acts on the state provided to it by the host and updates it when
switching to the vcpu state.

No functional change.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  5 +--
 arch/arm64/kvm/arm.c                    |  4 +-
 arch/arm64/kvm/fpsimd.c                 | 57 ++++++++++++++++++-------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 19 ---------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  3 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  3 +-
 6 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b06f24b5f443..ca1621eeb9d9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -24,7 +24,6 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
-#include <asm/thread_info.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
@@ -320,7 +319,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	struct thread_info *host_thread_info;	/* hyp VA */
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 
 	struct {
@@ -616,7 +614,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
-void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_enter_ctxsync_fp(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_exit_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 98f05bdac3c1..c7a711ca840e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -682,6 +682,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_disable();
 
+		kvm_arch_vcpu_enter_ctxsync_fp(vcpu);
+
 		kvm_vgic_flush_hwstate(vcpu);
 
 		/*
@@ -769,7 +771,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (static_branch_unlikely(&userspace_irqchip_in_use))
 			kvm_timer_sync_user(vcpu);
 
-		kvm_arch_vcpu_ctxsync_fp(vcpu);
+		kvm_arch_vcpu_exit_ctxsync_fp(vcpu);
 
 		/*
 		 * We may have taken a host interrupt in HYP mode (ie
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 3e081d556e81..aec91f43df62 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -27,22 +27,13 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	struct thread_info *ti = &current->thread_info;
 	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
 
-	/*
-	 * Make sure the host task thread flags and fpsimd state are
-	 * visible to hyp:
-	 */
-	ret = create_hyp_mappings(ti, ti + 1, PAGE_HYP);
-	if (ret)
-		goto error;
-
+	/* Make sure the host task fpsimd state is visible to hyp: */
 	ret = create_hyp_mappings(fpsimd, fpsimd + 1, PAGE_HYP);
 	if (ret)
 		goto error;
 
-	vcpu->arch.host_thread_info = kern_hyp_va(ti);
 	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
 error:
 	return ret;
@@ -52,7 +43,7 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
  * Prepare vcpu for saving the host's FPSIMD state and loading the guest's.
  * The actual loading is done by the FPSIMD access trap taken to hyp.
  *
- * Here, we just set the correct metadata to indicate that the FPSIMD
+ * Here, we just set the correct metadata to indicate whether the FPSIMD
  * state in the cpu regs (if any) belongs to current on the host.
  *
  * TIF_SVE is backed up here, since it may get clobbered with guest state.
@@ -63,15 +54,46 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	BUG_ON(!current->mm);
 
 	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
+			      KVM_ARM64_FP_HOST |
 			      KVM_ARM64_HOST_SVE_IN_USE |
 			      KVM_ARM64_HOST_SVE_ENABLED);
+
+	if (!system_supports_fpsimd())
+		return;
+
+	/*
+	 * Having just come from the user task, if any FP state is loaded it
+	 * will be that of the task. Make a note of this but, just before
+	 * entering the vcpu, it will be double checked that the loaded FP
+	 * state isn't transient because things could change between now and
+	 * then.
+	 */
 	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
 
-	if (test_thread_flag(TIF_SVE))
-		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
+	if (system_supports_sve()) {
+		if (test_thread_flag(TIF_SVE))
+			vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
 
-	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
-		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
+		if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
+			vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
+	}
+}
+
+void kvm_arch_vcpu_enter_ctxsync_fp(struct kvm_vcpu *vcpu)
+{
+	WARN_ON_ONCE(!irqs_disabled());
+
+	if (!system_supports_fpsimd())
+		return;
+
+	/*
+	 * If the CPU's FP state is transient, there is no need to save the
+	 * current state. Without further information, it must also be assumed
+	 * that the vcpu's state is not loaded.
+	 */
+	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
+		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
+				      KVM_ARM64_FP_HOST);
 }
 
 /*
@@ -80,7 +102,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
  * so that they will be written back if the kernel clobbers them due to
  * kernel-mode NEON before re-entry into the guest.
  */
-void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
+void kvm_arch_vcpu_exit_ctxsync_fp(struct kvm_vcpu *vcpu)
 {
 	WARN_ON_ONCE(!irqs_disabled());
 
@@ -106,6 +128,9 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	bool host_has_sve = system_supports_sve();
 	bool guest_has_sve = vcpu_has_sve(vcpu);
 
+	if (!system_supports_fpsimd())
+		return;
+
 	local_irq_save(flags);
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0511af14dc81..65cde758abad 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -25,28 +25,9 @@
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
-#include <asm/thread_info.h>
 
 extern const char __hyp_panic_string[];
 
-/* Check whether the FP regs were dirtied while in the host-side run loop: */
-static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * When the system doesn't support FP/SIMD, we cannot rely on
-	 * the _TIF_FOREIGN_FPSTATE flag. However, we always inject an
-	 * abort on the very first access to FP and thus we should never
-	 * see KVM_ARM64_FP_ENABLED. For added safety, make sure we always
-	 * trap the accesses.
-	 */
-	if (!system_supports_fpsimd() ||
-	    vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)
-		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
-				      KVM_ARM64_FP_HOST);
-
-	return !!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED);
-}
-
 /* Save the 32-bit only FPSIMD system register state */
 static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 341be2f2f312..3b7306003917 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -25,7 +25,6 @@
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
-#include <asm/thread_info.h>
 
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
@@ -36,7 +35,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TZ | CPTR_EL2_TAM;
-	if (!update_fp_enabled(vcpu)) {
+	if (!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED)) {
 		val |= CPTR_EL2_TFP;
 		__activate_traps_fpsimd32(vcpu);
 	}
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index c52d714e0d75..0c08c9123ce5 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -24,7 +24,6 @@
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
-#include <asm/thread_info.h>
 
 const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
 
@@ -49,7 +48,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val |= CPTR_EL2_TAM;
 
-	if (update_fp_enabled(vcpu)) {
+	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
 		if (vcpu_has_sve(vcpu))
 			val |= CPACR_EL1_ZEN;
 	} else {
-- 
2.27.0.383.g050319c2ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
