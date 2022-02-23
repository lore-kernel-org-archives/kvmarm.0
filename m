Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F522C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:19:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B59444C3FC;
	Tue, 22 Feb 2022 23:19:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mVdWIIorRWTi; Tue, 22 Feb 2022 23:19:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 468EA4C3E9;
	Tue, 22 Feb 2022 23:19:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D1F54C369
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GeYGtxJDbQ2v for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:19 -0500 (EST)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A7724C3F6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:19 -0500 (EST)
Received: by mail-il1-f202.google.com with SMTP id
 x6-20020a923006000000b002bea39c3974so11802208ile.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=q4R57xxRvoqj0jvH1kp4v0WNULcwYMhHe97HrH/NaKs=;
 b=DIrZsjZSKFumvER62QxuVVmXN1YyjtPRSZ3IMZ/epU6OehIQXsMHpDUDJuGM0sOdM9
 Xa3GkIW9L1+RIdnmjFNA5a673Mcz3uKfIixj7KMotznbMEEH9dFB8SmOHRQD74Nh2iU5
 /7EiFdHWmatqdVt7VnOxpVe7w+vjpclEKpBEm02/LK+3qb4UPkYmg4HytmTCzm/wjrnA
 jtes3QqhSyJ8fFm8E02Gd9jcHp35eVR4Rdd9lJpdLD80QoXM56UOdi0o4w/M1qJT+wzi
 MKtM80CRGELEJKjtfsa2TyXi0fnONndSfUgHn+K9t6rJMB14yHAn5o3oXEAtsEZEhBiH
 KKWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=q4R57xxRvoqj0jvH1kp4v0WNULcwYMhHe97HrH/NaKs=;
 b=K1ikHNz8w9CcjSWIXW2DEqSVVHmd5I6XRw0kGmM4KNIbZvyud1Q6snvBK216x//02Z
 akLgpDA1Cx4EH7jWGMRcGpAMBRxumLti7FSk+ffgGm9CkL7pYWcoYbNwlgGNyFpAhyD0
 /hsM3inSx9XHD496Ly/DQimqn7OnSfNTO/nEl2oeD9qJMVDrdqjFZUH/E3CxeEx4RVQp
 NivB5WEMXgaeEzPGQDoAQgJX4iOQzl3HasmoGJYOqlBfv51uXVxYIkjfszLBk+ofSDae
 Ie8jAw3USSq/jLpNQnBLnHHoG4WoKFg4hLkq/ZB884vZh82Wfc9470Mm4x5iJ29UOOYi
 DfsA==
X-Gm-Message-State: AOAM533mSpCbVXKFpEfDbSbb5y6VjSOtQXujF60fTH8SKkWm5qKWqbbC
 sWJ4M2TwysNaQYzRhA11hMRAGzm0UcOulU1f1VH4r3Fim5+AXEywx65MRfUy6J2rmSoHgJ0yB0u
 IOWa0IH71VITLz3ZpCmP7K+g+KqPd531eA8zfLmUVBLquyr97ipnQSFYZ2sh2k8FZcOeA7A==
X-Google-Smtp-Source: ABdhPJyUvSf/lmncTWDQIYy3XL/42+UT+v7lgPaWwTGgn82xM27AgseWmCm72Pgc1Dgi/YpsD2EkZrVPldE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1b8e:b0:2c2:2750:1178
 with SMTP id
 h14-20020a056e021b8e00b002c227501178mr12158397ili.126.1645589958479; Tue, 22
 Feb 2022 20:19:18 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:33 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-9-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 08/19] KVM: arm64: Add reset helper that accepts
 caller-provided reset state
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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

To date, struct vcpu_reset_state has been used to implement PSCI CPU_ON,
as callers of this function provide context for the targeted vCPU. A
subsequent change to KVM will require that a vCPU can populate its own
reset context.

Extract the vCPU reset implementation into a new function to separate
the locked read of shared data (vcpu->arch.reset_state) from the use of
the reset context.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 16 ++++++-----
 arch/arm64/kvm/reset.c            | 44 +++++++++++++++++++------------
 2 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3e8bfecaa95b..33ecec755310 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -67,6 +67,15 @@ extern unsigned int kvm_sve_max_vl;
 int kvm_arm_init_sve(void);
 
 u32 __attribute_const__ kvm_target_cpu(void);
+
+struct vcpu_reset_state {
+	unsigned long	pc;
+	unsigned long	r0;
+	bool		be;
+	bool		reset;
+};
+
+int __kvm_reset_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reset_state *reset_state);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
@@ -271,13 +280,6 @@ extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
 extern u64 kvm_nvhe_sym(hyp_cpu_logical_map)[NR_CPUS];
 #define hyp_cpu_logical_map CHOOSE_NVHE_SYM(hyp_cpu_logical_map)
 
-struct vcpu_reset_state {
-	unsigned long	pc;
-	unsigned long	r0;
-	bool		be;
-	bool		reset;
-};
-
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 	void *sve_state;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index ecc40c8cd6f6..f879a8f6a99c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -205,35 +205,32 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
 }
 
 /**
- * kvm_reset_vcpu - sets core registers and sys_regs to reset value
+ * __kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
+ * @reset_state: Context to use to reset the vCPU
  *
  * This function sets the registers on the virtual CPU struct to their
  * architecturally defined reset values, except for registers whose reset is
  * deferred until kvm_arm_vcpu_finalize().
  *
- * Note: This function can be called from two paths: The KVM_ARM_VCPU_INIT
- * ioctl or as part of handling a request issued by another VCPU in the PSCI
- * handling code.  In the first case, the VCPU will not be loaded, and in the
- * second case the VCPU will be loaded.  Because this function operates purely
- * on the memory-backed values of system registers, we want to do a full put if
+ * Note: This function can be called from two paths:
+ *  - The KVM_ARM_VCPU_INIT ioctl
+ *  - handling a request issued by another VCPU in the PSCI handling code
+ *
+ * In the first case, the VCPU will not be loaded, and in the second case the
+ * VCPU will be loaded.  Because this function operates purely on the
+ * memory-backed values of system registers, we want to do a full put if
  * we were loaded (handling a request) and load the values back at the end of
  * the function.  Otherwise we leave the state alone.  In both cases, we
  * disable preemption around the vcpu reset as we would otherwise race with
  * preempt notifiers which also call put/load.
  */
-int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
+int __kvm_reset_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reset_state *reset_state)
 {
-	struct vcpu_reset_state reset_state;
 	int ret;
 	bool loaded;
 	u32 pstate;
 
-	mutex_lock(&vcpu->kvm->lock);
-	reset_state = vcpu->arch.reset_state;
-	WRITE_ONCE(vcpu->arch.reset_state.reset, false);
-	mutex_unlock(&vcpu->kvm->lock);
-
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
 
@@ -296,8 +293,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	 * Additional reset state handling that PSCI may have imposed on us.
 	 * Must be done after all the sys_reg reset.
 	 */
-	if (reset_state.reset) {
-		unsigned long target_pc = reset_state.pc;
+	if (reset_state->reset) {
+		unsigned long target_pc = reset_state->pc;
 
 		/* Gracefully handle Thumb2 entry point */
 		if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
@@ -306,11 +303,11 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 
 		/* Propagate caller endianness */
-		if (reset_state.be)
+		if (reset_state->be)
 			kvm_vcpu_set_be(vcpu);
 
 		*vcpu_pc(vcpu) = target_pc;
-		vcpu_set_reg(vcpu, 0, reset_state.r0);
+		vcpu_set_reg(vcpu, 0, reset_state->r0);
 	}
 
 	/* Reset timer */
@@ -320,6 +317,19 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
 	return ret;
+
+}
+
+int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_reset_state reset_state;
+
+	mutex_lock(&vcpu->kvm->lock);
+	reset_state = vcpu->arch.reset_state;
+	WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+	mutex_unlock(&vcpu->kvm->lock);
+
+	return __kvm_reset_vcpu(vcpu, &reset_state);
 }
 
 u32 get_kvm_ipa_limit(void)
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
