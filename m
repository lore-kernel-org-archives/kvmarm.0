Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F3BC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CA464B20D;
	Tue, 19 Apr 2022 02:57:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1bPQ5xR3fySm; Tue, 19 Apr 2022 02:57:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2996F4B1FD;
	Tue, 19 Apr 2022 02:57:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E0B64B1C9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wo6bv9fNo+ge for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:27 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C9BB4B232
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:26 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 38-20020a17090a09a900b001cb95d9ea46so10128686pjo.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=/vjKAR/Lgrfopo8hEj0HEcKOQxQlZW68o1SkmclVnl4=;
 b=lzf/QpdqQv9uzaV5AJLSdksISlhdMJg0/X4yt3SQ6Pbv0hF+PdxOMJ8pLE+rdZv61f
 i15qaeHVtYUyP2dfbRSZD25p4C+rxzvhNV9nTEdGdED+ftIuvIRX25CuQu7SsRHKay0I
 YG15YkYFJ5L5ER/Zlz9Lcy7QJPO3/2Pguy2ljgPmnfmTnwIn/U+BDnLd59tE5llgaax2
 QlBXRvDLgcj/dqlkHez/TKqYPZBwwn9BUAGjjkRm4puiWejX/Kpf36vPPJRPn+7i7tqr
 zy+Ew1QFJeF2Kin3d8ZeIH0wYeZGlKFCjcM7cAb5Ib41YdGcj2wXN2yIFxLOuyzLvU3S
 gxog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/vjKAR/Lgrfopo8hEj0HEcKOQxQlZW68o1SkmclVnl4=;
 b=SLMqTKQEimHS777Tv9xhVrePjAWnKfmeksXIlv33HSnPn71BY754lCWDE6fmEEiqh6
 2DeQDRGy/eR/7pYDxtbca8GwFHhcdk+EAHFVbC9Ij+l9CgoAyZyKAAuISE9FZyOAKLc/
 7cxuboIHsJ/qbybbKnzBDwEMeAA7n1pGFeI3+S3F5v/zh6sFSbfXBottWFKeboP2cTrw
 t7/L4EwoJyGCQ1mkaUo9c4RHmsdWucMn0x8dZafrZyHE2dx7LjKWryV7jaCE6LFdRiVR
 nR55SYLVMmVHoXi+D+qah9HYpY9GyNT0dZq552bTCmy2OsN5ajVyt5CuaDXXpmuvpFwt
 qVsA==
X-Gm-Message-State: AOAM5300iDcRcFg0ccPdcuBLwu/rIvJH9vWFsmPEq0FtT9RdtOMvULcp
 jvWSKAdEAlj81WPfpojx8070MCoq+7Q=
X-Google-Smtp-Source: ABdhPJwLgiVYSYP5oQPSjEjSHx+cLaLtR0/2B0FVBvNOlRvoxy7xj829DfShZuFzYw4gbA0oeKTgAhX0I3s=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:10c7:b0:4fd:9ee6:4130 with SMTP id
 d7-20020a056a0010c700b004fd9ee64130mr16718408pfu.84.1650351445278; Mon, 18
 Apr 2022 23:57:25 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:18 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-13-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 12/38] KVM: arm64: Add a KVM flag indicating emulating
 debug regs access is needed
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

Highest numbered breakpoints must be context aware breakpoints
(as specified by Arm ARM).  If the number of non-context aware
breakpoints for the guest is decreased by userspace, simply narrowing
the breakpoints will be problematic because it will lead to
narrowing context aware breakpoints for the guest.

Introduce KVM_ARCH_FLAG_EMULATE_DEBUG_REGS for kvm->arch.flags to
indicate trapping debug reg access is needed, and enable the trapping
when the flag is set.  Set the new flag at the first KVM_RUN if the
number of non-context aware breakpoints for the guest is decreased
by userspace.

No code sets the new flag yet since ID_AA64DFR0_EL1 is not configurable
by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/debug.c            |  7 ++++++-
 arch/arm64/kvm/sys_regs.c         | 35 +++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a43fddd58e68..dbed94e759a8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -136,6 +136,8 @@ struct kvm_arch {
 	 */
 #define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED		3
 #define KVM_ARCH_FLAG_EL1_32BIT				4
+	/* Access to debug registers need to be emulated ? */
+#define KVM_ARCH_FLAG_EMULATE_DEBUG_REGS		5
 
 	unsigned long flags;
 
@@ -786,6 +788,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 
 void set_default_id_regs(struct kvm *kvm);
 int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
+void kvm_vcpu_breakpoint_config(struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 4fd5c216c4bb..6eb146d908f8 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -106,10 +106,14 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 *  (KVM_GUESTDBG_USE_HW is set).
 	 *  - The guest is not using debug (KVM_ARM64_DEBUG_DIRTY is clear).
 	 *  - The guest has enabled the OS Lock (debug exceptions are blocked).
+	 *  - The guest's access to debug registers needs to be emulated
+	 *    (the number of non-context aware breakpoints for the guest
+	 *     is decreased by userspace).
 	 */
 	if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW) ||
 	    !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY) ||
-	    kvm_vcpu_os_lock_enabled(vcpu))
+	    kvm_vcpu_os_lock_enabled(vcpu) ||
+	    test_bit(KVM_ARCH_FLAG_EMULATE_DEBUG_REGS, &vcpu->kvm->arch.flags))
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
 
 	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
@@ -124,6 +128,7 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
  */
 void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu)
 {
+	kvm_vcpu_breakpoint_config(vcpu);
 	preempt_disable();
 	kvm_arm_setup_mdcr_el2(vcpu);
 	preempt_enable();
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b68ae53af792..f4aae4ccffd0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -844,6 +844,41 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
 	}
 }
 
+#define AA64DFR0_BRPS(v)	\
+	((u8)cpuid_feature_extract_unsigned_field(v, ID_AA64DFR0_BRPS_SHIFT))
+#define AA64DFR0_CTX_CMPS(v)	\
+	((u8)cpuid_feature_extract_unsigned_field(v, ID_AA64DFR0_CTX_CMPS_SHIFT))
+
+/*
+ * Set KVM_ARCH_FLAG_EMULATE_DEBUG_REGS in the VM flags when the number of
+ * non-context aware breakpoints for the guest is decreased by userspace
+ * (meaning that debug register accesses need to be emulated).
+ */
+void kvm_vcpu_breakpoint_config(struct kvm_vcpu *vcpu)
+{
+	u64 p_val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+	u64 v_val = read_id_reg_with_encoding(vcpu, SYS_ID_AA64DFR0_EL1);
+	u8 v_nbpn, p_nbpn;
+	struct kvm *kvm = vcpu->kvm;
+
+	/*
+	 * Check the number of normal (non-context aware) breakpoints
+	 * for the guest and the host.
+	 */
+	v_nbpn = AA64DFR0_BRPS(v_val) - AA64DFR0_CTX_CMPS(v_val);
+	p_nbpn = AA64DFR0_BRPS(p_val) - AA64DFR0_CTX_CMPS(p_val);
+	if (v_nbpn >= p_nbpn)
+		/*
+		 * Nothing to do if the number of normal breakpoints for the
+		 * guest is not decreased by userspace (meaning KVM doesn't
+		 * need to emulate an access of debug registers).
+		 */
+		return;
+
+	if (!test_bit(KVM_ARCH_FLAG_EMULATE_DEBUG_REGS, &kvm->arch.flags))
+		set_bit(KVM_ARCH_FLAG_EMULATE_DEBUG_REGS, &kvm->arch.flags);
+}
+
 /*
  * We want to avoid world-switching all the DBG registers all the
  * time:
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
