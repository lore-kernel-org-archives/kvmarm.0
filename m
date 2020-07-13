Return-Path: <SRS0=IpCr=AY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D05C433E3
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 21:05:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77ED42068F
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 21:05:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="F8xTfv3G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77ED42068F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32F8C4B1FA;
	Mon, 13 Jul 2020 17:05:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2bUE1jNyztoM; Mon, 13 Jul 2020 17:05:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10F284B212;
	Mon, 13 Jul 2020 17:05:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23F1A4B1E3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 17:05:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fpB1LAUomB4A for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2020 17:05:17 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 121584B1D4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 17:05:17 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id j79so11703431qke.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 14:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=YEkbDrvQ0q+w7KjWKSvL4POX4BcT2EOCC4I7AJO1aBs=;
 b=F8xTfv3GCdaTw48ubzrccBMsmX+9SocnsOqZFFUjYeMPXIozgKe+nS4M5TLIrjEi5m
 YiZ152QJFyMju4LdytlMawpqLat2ipB/7ab+FWjhsC+b/yUe7zv0QAoLk/JEa3M5YG6f
 7zf8QGdTBGNiLCzBEPoCDpN2+3YflRA7kqFb2a3yqOSSX/8RxWDDoBoCGHkK83W3WkoD
 AbY/PcPmWS48hkWiqJmskWjwInvxZToQCZ5BhU7T4/Fa4mX2mBboHM9s4uUDiEJMXm8h
 GXc649ie9ZR9YcQt24YwplcoN+AcWjewPTpWgXpwBUyt7o+gIU9r/8CzsSYOk/qtsZL7
 VrOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YEkbDrvQ0q+w7KjWKSvL4POX4BcT2EOCC4I7AJO1aBs=;
 b=l29QGrQsmJnEPS761N9LQUKPhokQLeQSealbvXnuxXx5ii9kst7tkjx9ajJKxxq8CR
 qKWneLQon1s6GHFLJB0WTt10MQHn5NyfwmgEo1962oA89Z6W/XoWa9YFBTv5ZHHweKqV
 P6ug3Rw5+4GZnwv7WtfX74Eoy4cD5TnoB/CvMQ2zCvIhv6LUKgPH6ggV01ebLIUftx4A
 8mAn2mNT/2ANWJbFMNJY559vc5QRW2Xk3LLxCfhd90d+s8gFztjJmkWlvTHQ/JbQw0+V
 m6JMr5stcFyjkawMgofKnyZEjVo2IbApUAP7RX9wEHnAjj+Js0GeOsPn1ojQt5dS+fH5
 YHCA==
X-Gm-Message-State: AOAM530LdA6sV+LFhXJK42WmcKNGBq/wx4qQyfq3vN4WoNXsuoYE6h6V
 PDQG4SOhwOUMVU0YbO0xQ0caZSUFO5g4dcx4aecxdjKd3W2kH0oYKg6Ft2K6Sq9t2sfAox1AZve
 KoFG8v7FG35DfT9YjjsHDxNIuKRGnywwOR8T5dKFG47pLLoM8ryyl6GUkBjlIcpFkPShkug==
X-Google-Smtp-Source: ABdhPJx0sgW8Elg5ZyDp/QoE5/iNwCt5HrH5i5NCPvSrzAWlXaP/RWRWTNnFNSpEjCi8JP5/rKd/rq1GnGU=
X-Received: by 2002:a0c:fa84:: with SMTP id o4mr1368787qvn.186.1594674316435; 
 Mon, 13 Jul 2020 14:05:16 -0700 (PDT)
Date: Mon, 13 Jul 2020 22:05:04 +0100
In-Reply-To: <20200713210505.2959828-1-ascull@google.com>
Message-Id: <20200713210505.2959828-4-ascull@google.com>
Mime-Version: 1.0
References: <20200713210505.2959828-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v2 3/4] KVM: arm64: Leave vcpu FPSIMD synchronization in host
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
before calling into hyp. Hyp simply acts on the state provided to it by
the host and updates it when switching to the vcpu state.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  3 ++-
 arch/arm64/kvm/arm.c                    |  4 +++-
 arch/arm64/kvm/fpsimd.c                 | 19 ++++++++++++++++++-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 19 -------------------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  3 +--
 arch/arm64/kvm/hyp/vhe/switch.c         |  3 +--
 6 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b06f24b5f443..1a062d44b395 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -616,7 +616,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
-void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_sync_fp_before_run(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_sync_fp_after_run(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 98f05bdac3c1..c91b0a66bf20 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -682,6 +682,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_disable();
 
+		kvm_arch_vcpu_sync_fp_before_run(vcpu);
+
 		kvm_vgic_flush_hwstate(vcpu);
 
 		/*
@@ -769,7 +771,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (static_branch_unlikely(&userspace_irqchip_in_use))
 			kvm_timer_sync_user(vcpu);
 
-		kvm_arch_vcpu_ctxsync_fp(vcpu);
+		kvm_arch_vcpu_sync_fp_after_run(vcpu);
 
 		/*
 		 * We may have taken a host interrupt in HYP mode (ie
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index c6b3197f6754..2779cc11f3dd 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -88,13 +88,30 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	}
 }
 
+void kvm_arch_vcpu_sync_fp_before_run(struct kvm_vcpu *vcpu)
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
+}
+
 /*
  * If the guest FPSIMD state was loaded, update the host's context
  * tracking data mark the CPU FPSIMD regs as dirty and belonging to vcpu
  * so that they will be written back if the kernel clobbers them due to
  * kernel-mode NEON before re-entry into the guest.
  */
-void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
+void kvm_arch_vcpu_sync_fp_after_run(struct kvm_vcpu *vcpu)
 {
 	WARN_ON_ONCE(!irqs_disabled());
 
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
