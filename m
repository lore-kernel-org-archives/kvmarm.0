Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F1CC433F7
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF5E92065F
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="kNtd2NkJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF5E92065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7905F4B3DC;
	Wed, 15 Jul 2020 14:45:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VZ9bENrYq6Mk; Wed, 15 Jul 2020 14:45:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF184B381;
	Wed, 15 Jul 2020 14:45:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22A484B388
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jCwAdPOOkjez for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:25 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFAC54B37F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:24 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id b8so1962599wro.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Qo3944Qoo193O+Tpg+oZeZWzZeNiujtLf5FI4S09YtM=;
 b=kNtd2NkJiYVrlNQmWiIFhS0qv7z2NxKIA8AHaV3SOx6sPwGwCqwxmIqIIFaT/91KY0
 Plc1uUWXBmTphiOyIJZ6DW2IB0zR7EO99ZF+MBfNV/L9BiMTpRpwHxjyQ6+AOuYB04m4
 BfvqKeR/0ROTCEa/M5gq8fJ7NzVJHs9Vgk0bwIxNqmOJGxpKac6LeDam4vvvUsewwZ6q
 IdcPpezk91+/WYstn+5Pyo0seEQikZKq5ZA0AYpOUwtRrbxASWIhshvoeIlgPfWqL4+s
 7y7folXfIaXJY5gs02dBV1iDohsearVsiLg4MpxcEtfnzGv83XOvLRQ1H3/B7+mMG3d3
 1BgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Qo3944Qoo193O+Tpg+oZeZWzZeNiujtLf5FI4S09YtM=;
 b=mFpPm0DdI97BYKF0LBcL4Ls61mTYhU1pxehzapaGQ+ce+bPSScrpunW4KnNGWpiLE6
 zR86yDEjYSEOAM9qI1Se5YbKhObkoorIgICkImsuZs7KzpMSFTIebfQAHSw4ctD+dj4I
 xfZLabfWX7vRULrOZfyG8xXiwJUQL4qyPsCnZQDUv/5oBr2mI8n00dm7hN3uevYtrEei
 2Wzhes/g4cWDBslifOSNKnlXuu2/sX8+XSQvw9I6Cef0teW+Yni9mxDDOJwJsBg1UP0j
 PpITKp7y3+NnyccjDI4ipwGFTDqKdP9eW7VnCKpmrPiGPuK3MLBVvgmZMa48vztEAuhQ
 FIGQ==
X-Gm-Message-State: AOAM532m6vXahS4bJcXQdIyInbV52QVKklXsRzsqQTquyUTA+ycmqtfE
 cDjcaXeH5Cv3x1b2B6l4w+6fZYkMmZ7lCdNxIq0GfHKRfHfz1npAtlUIB7BwwqyjOTVxBO9HJO+
 ORcOo5+hmVj4fhAJsBj3QZpCEy99RINA3/Wj43ule0X2bu2UZ2SmyFP5pGOkXnWDMgnVv8Q==
X-Google-Smtp-Source: ABdhPJyJSZPa/eteX4n/cVnwS9P2sGnVL1tdBOHRZYfPgmquuK1bK03CDtBPFvGVjXZeAwtzvcZUxg6WprE=
X-Received: by 2002:a1c:398b:: with SMTP id g133mr755257wma.76.1594838723813; 
 Wed, 15 Jul 2020 11:45:23 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:17 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-17-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 16/37] KVM: arm64: nVHE: Handle stub HVCs in the host loop
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

Since the host is called from the hyp run loop, we can use that context
to identify calls from the host rather than checking VTTBR_EL2, which
will be used for the host's stage 2 in future.

Moving this to C also allows for more flexibiliy e.g. in applying
policies, such as forbidding HVC_RESET_VECTORS, based on the current
state of the hypervisor and removes the special casing for nVHE in the
exception handler.

Control over arch workaround 2 is made available to the host, the same
as any other vcpu.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/hyp-entry.S     | 36 ++-------------------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 15 +++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 50 +++++++++++++++++++++++++++++-
 3 files changed, 65 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index a45459d1c135..3113665ce912 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -17,50 +17,20 @@
 
 	.text
 
-el1_sync:				// Guest trapped into EL2
-
+el1_sync:
 	mrs	x0, esr_el2
 	lsr	x0, x0, #ESR_ELx_EC_SHIFT
 	cmp	x0, #ESR_ELx_EC_HVC64
 	ccmp	x0, #ESR_ELx_EC_HVC32, #4, ne
 	b.ne	el1_trap
 
-#ifdef __KVM_NVHE_HYPERVISOR__
-	mrs	x1, vttbr_el2		// If vttbr is valid, the guest
-	cbnz	x1, el1_hvc_guest	// called HVC
-
-	/* Here, we're pretty sure the host called HVC. */
-	ldp	x0, x1, [sp]
-
-	/* Check for a stub HVC call */
-	cmp	x0, #HVC_STUB_HCALL_NR
-	b.hs	el1_trap
-	add	sp, sp, #16
-
-	/*
-	 * Compute the idmap address of __kvm_handle_stub_hvc and
-	 * jump there. Since we use kimage_voffset, do not use the
-	 * HYP VA for __kvm_handle_stub_hvc, but the kernel VA instead
-	 * (by loading it from the constant pool).
-	 *
-	 * Preserve x0-x4, which may contain stub parameters.
-	 */
-	ldr	x5, =__kvm_handle_stub_hvc
-	ldr_l	x6, kimage_voffset
-
-	/* x5 = __pa(x5) */
-	sub	x5, x5, x6
-	br	x5
-#endif /* __KVM_NVHE_HYPERVISOR__ */
-
-el1_hvc_guest:
 	/*
 	 * Fastest possible path for ARM_SMCCC_ARCH_WORKAROUND_1.
 	 * The workaround has already been applied on the host,
 	 * so let's quickly get back to the guest. We don't bother
 	 * restoring x1, as it can be clobbered anyway.
 	 */
-	ldr	x1, [sp]				// Guest's x0
+	ldr	x1, [sp]				// vcpu's x0
 	eor	w1, w1, #ARM_SMCCC_ARCH_WORKAROUND_1
 	cbz	w1, wa_epilogue
 
@@ -77,7 +47,7 @@ alternative_cb_end
 	ldr	x0, [x2, #VCPU_WORKAROUND_FLAGS]
 
 	// Sanitize the argument and update the guest flags
-	ldr	x1, [sp, #8]			// Guest's x1
+	ldr	x1, [sp, #8]			// vcpu's x1
 	clz	w1, w1				// Murphy's device:
 	lsr	w1, w1, #5			// w1 = !!w1 without using
 	eor	w1, w1, #1			// the flags...
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index df2a7904a83b..43e1ee6178d4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -15,6 +15,9 @@
 #include <asm/sysreg.h>
 #include <asm/virt.h>
 
+#include <asm/kvm_asm.h>
+#include <asm/kvm_ptrauth.h>
+
 	.text
 	.pushsection	.hyp.idmap.text, "ax"
 
@@ -137,6 +140,7 @@ SYM_CODE_START(__kvm_handle_stub_hvc)
 	cmp	x0, #HVC_SOFT_RESTART
 	b.ne	1f
 
+SYM_INNER_LABEL(__kvm_handle_stub_hvc_soft_restart, SYM_L_GLOBAL)
 	/* This is where we're about to jump, staying at EL2 */
 	msr	elr_el2, x1
 	mov	x0, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT | PSR_MODE_EL2h)
@@ -146,11 +150,18 @@ SYM_CODE_START(__kvm_handle_stub_hvc)
 	mov	x0, x2
 	mov	x1, x3
 	mov	x2, x4
-	b	reset
+	b	2f
 
 1:	cmp	x0, #HVC_RESET_VECTORS
 	b.ne	1f
-reset:
+
+SYM_INNER_LABEL(__kvm_handle_stub_hvc_reset_vectors, SYM_L_GLOBAL)
+	/* Restore host's ptrauth, sp_el0 and callee saved regs */
+	ptrauth_switch_to_guest x5, x6, x7, x8
+	restore_sp_el0 x5, x6
+	restore_callee_saved_regs x5
+
+2:
 	/*
 	 * Reset kvm back to the hyp stub. Do not clobber x0-x4 in
 	 * case we coming via HVC_SOFT_RESTART.
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 213977634601..d013586e3a03 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -13,6 +13,51 @@
 
 #include <kvm/arm_hypercalls.h>
 
+typedef unsigned long (*stub_hvc_handler_t)
+	(unsigned long, unsigned long, unsigned long, unsigned long,
+	 unsigned long, struct kvm_cpu_context *);
+
+extern char __kvm_handle_stub_hvc_soft_restart[];
+extern char __kvm_handle_stub_hvc_reset_vectors[];
+
+static void handle_stub_hvc(unsigned long func_id, struct kvm_vcpu *host_vcpu)
+{
+	char *stub_hvc_handler_kern_va;
+	__noreturn stub_hvc_handler_t stub_hvc_handler;
+
+	/*
+	 * The handlers of the supported stub HVCs disable the MMU so they must
+	 * be called in the idmap. We compute the idmap address by subtracting
+	 * kimage_voffset from the kernel VA handler.
+	 */
+	switch (func_id) {
+	case HVC_SOFT_RESTART:
+		asm volatile("ldr %0, =%1"
+			     : "=r" (stub_hvc_handler_kern_va)
+			     : "S" (__kvm_handle_stub_hvc_soft_restart));
+		break;
+	case HVC_RESET_VECTORS:
+		asm volatile("ldr %0, =%1"
+			     : "=r" (stub_hvc_handler_kern_va)
+			     : "S" (__kvm_handle_stub_hvc_reset_vectors));
+		break;
+	default:
+		vcpu_set_reg(host_vcpu, 0, HVC_STUB_ERR);
+		return;
+	}
+
+	stub_hvc_handler = (__noreturn stub_hvc_handler_t)
+		(stub_hvc_handler_kern_va - kimage_voffset);
+
+	/* Preserve x0-x4, which may contain stub parameters. */
+	stub_hvc_handler(func_id,
+			 vcpu_get_reg(host_vcpu, 1),
+			 vcpu_get_reg(host_vcpu, 2),
+			 vcpu_get_reg(host_vcpu, 3),
+			 vcpu_get_reg(host_vcpu, 4),
+			 &host_vcpu->arch.ctxt);
+}
+
 static void handle_host_hcall(unsigned long func_id, struct kvm_vcpu *host_vcpu)
 {
 	unsigned long ret = 0;
@@ -105,7 +150,10 @@ static void handle_trap(struct kvm_vcpu *host_vcpu) {
 	if (kvm_vcpu_trap_get_class(host_vcpu) == ESR_ELx_EC_HVC64) {
 		unsigned long func_id = smccc_get_function(host_vcpu);
 
-		handle_host_hcall(func_id, host_vcpu);
+		if (func_id < HVC_STUB_HCALL_NR)
+			handle_stub_hvc(func_id, host_vcpu);
+		else
+			handle_host_hcall(func_id, host_vcpu);
 	}
 
 	/* Other traps are ignored. */
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
