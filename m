Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DEE3C43219
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 17:28:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D06EF4B21A;
	Tue, 14 Dec 2021 12:28:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W9sUexNI86pn; Tue, 14 Dec 2021 12:28:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D032E4B21E;
	Tue, 14 Dec 2021 12:28:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6394E4B212
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0fAqQRlWmf1Y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 12:28:22 -0500 (EST)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E0264B228
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:21 -0500 (EST)
Received: by mail-il1-f202.google.com with SMTP id
 r1-20020a92cd81000000b002a3ae5f6ad9so18362747ilb.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AHaXpoeYGJKTcAQ6Ud9mbrS81eJMXMtZFTk611Ztqc4=;
 b=c6W/nuae9oJxHgaXmzSGJgmKhJwSh2+LsAI2ukYUcpG4HInlgliXxM9uwDKAFF38/B
 K912gRJ6ueOjUFUKOnA+q16CwFcmxWyYOB419U2/AntSymTrHJDOb0qwqVl/KyhYwjKC
 ojtn1l0nx0gfyhB93Edm/2wv6LFgbx2uWhlEFNzQYVQZL8baoCrMEx/1b3YwXRSaP9hs
 IhFpTVQ1C1Egxkvv+xtzfvBLLVss081BpixM1thXE2EgGY13ZGtpTXkcOSU3JXUt7091
 P1nTeYPbbYQyXcrh0lcIR5FhOH1tl74uoblifx7psv3Ovc0vDXUWABszb2VZIQ775ec9
 qJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AHaXpoeYGJKTcAQ6Ud9mbrS81eJMXMtZFTk611Ztqc4=;
 b=t7BOMP+ls7vDS7Z+GClBKBp6s1j+vG0EjDhrykHiwL14yxD4OCpZHNBb7ItLDyuCgF
 BkT1nwvbJur2yAmcYJZ0iA2M0kGrE9hN3D4QLtScs+XoDef3ljS+o4PeTeArM4JWd8TN
 QKwR3TK4zrf4x+RHva0ud/gtIGg2sArkWJyoxrPlNjxRSINaxA/Pr7M5Ge8JlWJjEEhQ
 l2Y3wNXHvIYspdVqRAn27Tq2SJsCWsCpqhHOtpBKV4J29Yg/KuRp3oN9jm/XW7wStvsZ
 Q9c1sh9XTGnIz6q85REy1oqJrRxusfrswYZrzYgOUR3TLeHsiGJno+EkuyKqQDDeyazM
 /YXA==
X-Gm-Message-State: AOAM532RYBeCPoCjfb6CxYBLoBznTmcYHLBOVf7GihcceKPsI5UXE88M
 7hIRwQHaLQ9teKyXxh7IacvvN40fBEXApLz4Q6SQymTbr8ghAf+wZyqY9yQA/8kYutehFraJs7M
 Vt6GHqL8Smm4Va6y/Gcl071il5wI9FUzOVf6MWgPQEq3xpHQorox99I3choygJAEb/LG6IQ==
X-Google-Smtp-Source: ABdhPJwgdXjrBk4yOm+tW/+RM2khejK62DN1txDRVsC8fkYX9XOzvSZ+GgcF2gHj6U1ZYY3NspcG+conVeU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:b:: with SMTP id
 z11mr3766250jao.801.1639502900958; Tue, 14 Dec 2021 09:28:20 -0800 (PST)
Date: Tue, 14 Dec 2021 17:28:10 +0000
In-Reply-To: <20211214172812.2894560-1-oupton@google.com>
Message-Id: <20211214172812.2894560-5-oupton@google.com>
Mime-Version: 1.0
References: <20211214172812.2894560-1-oupton@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 4/6] KVM: arm64: Emulate the OS Lock
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

The OS lock blocks all debug exceptions at every EL. To date, KVM has
not implemented the OS lock for its guests, despite the fact that it is
mandatory per the architecture. Simple context switching between the
guest and host is not appropriate, as its effects are not constrained to
the guest context.

Emulate the OS Lock by clearing MDE and SS in MDSCR_EL1, thereby
blocking all but software breakpoint instructions.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  4 ++++
 arch/arm64/kvm/debug.c            | 26 ++++++++++++++++++++++----
 arch/arm64/kvm/sys_regs.c         |  6 +++---
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 53fc8a6eaf1c..e5a06ff1cba6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -726,6 +726,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
+
+#define kvm_vcpu_os_lock_enabled(vcpu)		\
+	(!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK))
+
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index db9361338b2a..4fd5c216c4bb 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -105,9 +105,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 *  - Userspace is using the hardware to debug the guest
 	 *  (KVM_GUESTDBG_USE_HW is set).
 	 *  - The guest is not using debug (KVM_ARM64_DEBUG_DIRTY is clear).
+	 *  - The guest has enabled the OS Lock (debug exceptions are blocked).
 	 */
 	if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW) ||
-	    !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
+	    !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY) ||
+	    kvm_vcpu_os_lock_enabled(vcpu))
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
 
 	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
@@ -160,8 +162,8 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 
 	kvm_arm_setup_mdcr_el2(vcpu);
 
-	/* Is Guest debugging in effect? */
-	if (vcpu->guest_debug) {
+	/* Check if we need to use the debug registers. */
+	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
 		/* Save guest debug state */
 		save_guest_debug_regs(vcpu);
 
@@ -223,6 +225,19 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
 						&vcpu->arch.debug_ptr->dbg_wcr[0],
 						&vcpu->arch.debug_ptr->dbg_wvr[0]);
+
+		/*
+		 * The OS Lock blocks debug exceptions in all ELs when it is
+		 * enabled. If the guest has enabled the OS Lock, constrain its
+		 * effects to the guest. Emulate the behavior by clearing
+		 * MDSCR_EL1.MDE. In so doing, we ensure that host debug
+		 * exceptions are unaffected by guest configuration of the OS
+		 * Lock.
+		 */
+		} else if (kvm_vcpu_os_lock_enabled(vcpu)) {
+			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
+			mdscr &= ~DBG_MDSCR_MDE;
+			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 		}
 	}
 
@@ -244,7 +259,10 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 {
 	trace_kvm_arm_clear_debug(vcpu->guest_debug);
 
-	if (vcpu->guest_debug) {
+	/*
+	 * Restore the guest's debug registers if we were using them.
+	 */
+	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
 		restore_guest_debug_regs(vcpu);
 
 		/*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5188a74095e3..50a6966aab1b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1457,9 +1457,9 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
  * Debug handling: We do trap most, if not all debug related system
  * registers. The implementation is good enough to ensure that a guest
  * can use these with minimal performance degradation. The drawback is
- * that we don't implement any of the external debug, none of the
- * OSlock protocol. This should be revisited if we ever encounter a
- * more demanding guest...
+ * that we don't implement any of the external debug architecture.
+ * This should be revisited if we ever encounter a more demanding
+ * guest...
  */
 static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
