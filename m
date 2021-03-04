Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6308C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3DB6264F36
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DB6264F36
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF52B4B634;
	Thu,  4 Mar 2021 06:55:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nzFlfEZu963B; Thu,  4 Mar 2021 06:55:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36E514B4BD;
	Thu,  4 Mar 2021 06:55:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 886974B2EC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5wQRj8lizrzf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 06:55:17 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 413734B458
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:17 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id 73so4333458wma.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 03:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=BrTcUqUqZ8zywm7WAdcfHUat+sTNFKRJbFeDknkcqGE=;
 b=PYugRLuoU0Gn+cGHhiLznl5QgZaOhSZ2bPeFeXQAoqNx98ZkkE79E274LGw1k4ys2L
 EU6fMV431kjXguyb2RRCxO1Cy/gcsgzFQ1/bLT0BcwcfEBO0RbOQekaviVWmIEc7TM9a
 u92LQCZ6MDsav9xMOYEI5UM9kEsHnZhEk/DYaIwaTXox5+kYh2qcM94GiKo24kSwHhfA
 iRkypT9K2cAO7a8alrNZNd95vpt/+qL8Dv7qvSnk8SSstzeIm5ciiR0wTG+g+tVQ3APH
 RsIrsDRF95Hsfe9VqeN6hDln96ce1JgEm34M4kq7Apm2LzfLa9REhaQJm7bA86VktmP4
 ZOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BrTcUqUqZ8zywm7WAdcfHUat+sTNFKRJbFeDknkcqGE=;
 b=UF6rXZnY8ihvtlqo5IYXWXynqQX7NecFd1tdvRKTF5ncluf/BBmGfbHlXGyA+6ae5p
 t8IEJ4apMWhNVi1vQY/kovaozr5rhJq3+isihfb6cnOKR3WJQJIMTYtO2NJins2c+3+w
 NsDld9cWu6c69fwZPFDX7yKhMeudbNCbdqrk8PPdfGJOGR3oN8+co2jWghJRdgOOtEPT
 SDMmW5dRm8LOIskWS/ES3u+PKpRF8VU2beQJG/wgdBufCAZsg6bolO8WxF5GPRJIN4iL
 FBK4h3/lqnAvfe5+XmzoMBzHI+48z6yDid7TSKiMkPYLPxUFn5L7DaP3Zav621szeJpT
 K39A==
X-Gm-Message-State: AOAM530ZG1RrLh8MKVEghKBc52lo1oHup2tRtkTWtRBPOU6UIvs35Cvn
 0PDbp8yM9AAPKlGgP3zF6ysGW/qNzRifjoE5yQ3l1aNOOUmCYzgqicNEYx5U8xgjAkEe2FzDiVM
 vpsET4AbXPu4mOEg5MtNACNRcXg5ip3T+2hdXbY4kI4rVDDDvlii4iWg3osh7u1TmnDA7ng==
X-Google-Smtp-Source: ABdhPJzTPSbaywtZYP/dJX7JugY/KVsctzRC3gjkOz3JXFepOXuLl9Xc5v3RXTx1pQiIdLXLgZavi4cXI5Q=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a1c:32ca:: with SMTP id
 y193mr878311wmy.56.1614858916427; 
 Thu, 04 Mar 2021 03:55:16 -0800 (PST)
Date: Thu,  4 Mar 2021 11:54:45 +0000
In-Reply-To: <20210304115454.3597879-1-ascull@google.com>
Message-Id: <20210304115454.3597879-3-ascull@google.com>
Mime-Version: 1.0
References: <20210304115454.3597879-1-ascull@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 02/10] KVM: arm64: Synchronize vcpu FPSIMD in the host
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

Check the task's state about FP in the host and update the vcpu flags
before calling into hyp. This keeps the synchronization symmetrical
around the call into hyp.

kvm_arch_vcpu_ctxsync_fp() is renamed to kvm_arch_vcpu_sync_fp_after_hyp()
so that its name can pair with the new kvm_arch_vcpu_sync_fp_before_hyp().

If the system doesn't support FPSIMD, avoid setting any of the vcpu's
FPSIMD flags to match the previous behavior.

Signed-off-by: Andrew Scull <ascull@google.com>
Cc: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/kvm_host.h       |  3 ++-
 arch/arm64/kvm/arm.c                    |  4 +++-
 arch/arm64/kvm/fpsimd.c                 | 26 ++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 19 ------------------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  3 +--
 arch/arm64/kvm/hyp/vhe/switch.c         |  3 +--
 6 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6b33f720ce9c..f6a478d3a902 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -726,7 +726,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
-void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_sync_fp_before_hyp(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_sync_fp_after_hyp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fc4c95dd2d26..26ccc369cf11 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -738,6 +738,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_disable();
 
+		kvm_arch_vcpu_sync_fp_before_hyp(vcpu);
+
 		kvm_vgic_flush_hwstate(vcpu);
 
 		/*
@@ -825,7 +827,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (static_branch_unlikely(&userspace_irqchip_in_use))
 			kvm_timer_sync_user(vcpu);
 
-		kvm_arch_vcpu_ctxsync_fp(vcpu);
+		kvm_arch_vcpu_sync_fp_after_hyp(vcpu);
 
 		/*
 		 * We may have taken a host interrupt in HYP mode (ie
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 3e081d556e81..0c5e79be34d5 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -63,8 +63,13 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	BUG_ON(!current->mm);
 
 	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
+			      KVM_ARM64_FP_HOST |
 			      KVM_ARM64_HOST_SVE_IN_USE |
 			      KVM_ARM64_HOST_SVE_ENABLED);
+
+	if (!system_supports_fpsimd())
+		return;
+
 	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
 
 	if (test_thread_flag(TIF_SVE))
@@ -74,13 +79,32 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
 }
 
+
+/*
+ * If TIF_FOREIGN_FPSTATE is set, the FPSIMD regs do not contain the state of
+ * current or the guest. However, the state will have been saved where it was
+ * needed. This means the guest's state will have to be loaded if it is needed,
+ * without saving the FPSIMD regs.
+ */
+void kvm_arch_vcpu_sync_fp_before_hyp(struct kvm_vcpu *vcpu)
+{
+	WARN_ON_ONCE(!irqs_disabled());
+
+	if (!system_supports_fpsimd())
+		return;
+
+	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
+		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
+				      KVM_ARM64_FP_HOST);
+}
+
 /*
  * If the guest FPSIMD state was loaded, update the host's context
  * tracking data mark the CPU FPSIMD regs as dirty and belonging to vcpu
  * so that they will be written back if the kernel clobbers them due to
  * kernel-mode NEON before re-entry into the guest.
  */
-void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
+void kvm_arch_vcpu_sync_fp_after_hyp(struct kvm_vcpu *vcpu)
 {
 	WARN_ON_ONCE(!irqs_disabled());
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 54f4860cd87c..8eb1f87f9119 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -28,31 +28,12 @@
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
-#include <asm/thread_info.h>
 
 extern const char __hyp_panic_string[];
 
 extern struct exception_table_entry __start___kvm_ex_table;
 extern struct exception_table_entry __stop___kvm_ex_table;
 
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
index f3d0e9eca56c..6fc1e0a5adaa 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -26,7 +26,6 @@
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
-#include <asm/thread_info.h>
 
 /* Non-VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
@@ -42,7 +41,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TZ | CPTR_EL2_TAM;
-	if (!update_fp_enabled(vcpu)) {
+	if (!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED)) {
 		val |= CPTR_EL2_TFP;
 		__activate_traps_fpsimd32(vcpu);
 	}
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index af8e940d0f03..f6f60a537b3e 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -25,7 +25,6 @@
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
-#include <asm/thread_info.h>
 
 const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
 
@@ -55,7 +54,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val |= CPTR_EL2_TAM;
 
-	if (update_fp_enabled(vcpu)) {
+	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
 		if (vcpu_has_sve(vcpu))
 			val |= CPACR_EL1_ZEN;
 	} else {
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
