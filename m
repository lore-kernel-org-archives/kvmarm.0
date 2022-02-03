Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF59C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  3 Feb 2022 17:42:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13D484B0F4;
	Thu,  3 Feb 2022 12:42:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oDUivoNCei01; Thu,  3 Feb 2022 12:42:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70FDF4B156;
	Thu,  3 Feb 2022 12:42:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BFB24B137
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:42:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X917fOgB8geF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Feb 2022 12:42:09 -0500 (EST)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D6984B103
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:42:07 -0500 (EST)
Received: by mail-il1-f202.google.com with SMTP id
 t18-20020a92ca92000000b002b952c60bfbso2144108ilo.15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Feb 2022 09:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Nr8Z5OJ29ROTcrYqtf+ESfxb+ZGc4axhNqbKIHGyx48=;
 b=Zsmt6apLHIOrBX2WT/vEH+Cx5ozwlrkyIKXHn1hHeEEE8fib7VyrQFw+64K33mlo4Z
 fKUvhi393LhKtsn0GRp2uUfGOVxAsGxCBjRJM7yN8Y9+WLbgvoN5wCmKqh6kCq/UJOAL
 vjoe9AVESUQJhGxjbxHPCrwUwwM92RQKsK3vbxKrMyJV/p7MghbYHLe4x/VmHq9z4pZa
 KMKANvjA3mPuRaxs0Wq2zJMymU36GpQ7HlmIHT+eza9nhM8pRxerwWnuaNtP+EuoWuQ0
 0mrlcZhcXPaDJjPprgQTJQk7vwIoTBQLndrmGxCML+1AG77OAz3qSPsXarnS5G8nQyz1
 qpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Nr8Z5OJ29ROTcrYqtf+ESfxb+ZGc4axhNqbKIHGyx48=;
 b=SFT4zkHpLBoOW3NaylP6eOD98ljyUa2wg+3plrySjMiJEa8QMsEzslgCUC98hlQhgL
 IKjzMd8/ICWHHtM6p0etfkrPShQHEWX2pAHbdnzmmY9KzZAXusDDJbAiH+780UXZFPFB
 jYcGreWBgjUUQeCzXqXS9lbAT4h2ABjuxnBUzN1u/LKD+M+vrD7f37E1/6U46hFcNbe6
 Ej7oJffCslXVyww/fu1mu8SqM3SAhzL3g4L7KrsMSQcEv/HsoDFU0Fm0piU6r+PWc8Nx
 7oyD10EmAP9QAmrnIco7xH/aq2/SmWEtxBxSVmhGmCEvkOAB+fJ85YFR2dpXS2Ew1Eu+
 bgQg==
X-Gm-Message-State: AOAM533GDC6HsxsAzej/8iCspXYjqeHKppbbn7rXw3O2BNNMVqfhcaGN
 1ugH65D3KC4Hatq0I3BL9Po8a08IJ1jjIdFz+myUdRCW9ZbTW1t3LUIfRCfh4XkXXSTqF5IHwRB
 RCbT7xmJYKrUPW2+XPmx/KrQLVkaGnpE+tPXb9ib94aqEczL/+FFlK63r/Xw16wmrtt2Vxg==
X-Google-Smtp-Source: ABdhPJyPjx/GoLIMEP3S5DYF0m7WONfmTl73rjwA7Ukvp8YcT5Olh4b/zTsPduICjWXRqbtnZGNz7XZiRHs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:ba14:: with SMTP id
 z20mr11969165jan.102.1643910127009; 
 Thu, 03 Feb 2022 09:42:07 -0800 (PST)
Date: Thu,  3 Feb 2022 17:41:57 +0000
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
Message-Id: <20220203174159.2887882-5-oupton@google.com>
Mime-Version: 1.0
References: <20220203174159.2887882-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 4/6] KVM: arm64: Emulate the OS Lock
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
index cc1cc40d89f0..3c73e4de4229 100644
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
index b0d7240ef49f..dd34b5ab51d4 100644
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
2.35.0.263.gb82422642f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
