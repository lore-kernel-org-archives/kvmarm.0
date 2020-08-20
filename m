Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1620FC433E1
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD70220639
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="MesZ3PNR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD70220639
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 772F54B86C;
	Thu, 20 Aug 2020 06:35:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8b1AzZ7pzTBT; Thu, 20 Aug 2020 06:35:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E5884B894;
	Thu, 20 Aug 2020 06:35:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8E114B882
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FCODklbMQyBH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:52 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04B664B364
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:52 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id z12so507031wrl.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=signAkDpJN2hTUdQ+bnZtgU9oAO8c61lPXog2qZBVXQ=;
 b=MesZ3PNR9kcd/FL9wtiFqwOXOgqrcM5Mb3GHLDCaMTOol7agPJfcuSVBs5TMaN7qr8
 S6yKeorber6kTm3tCR/geW1u++pdmzLtUwgXR7oRgQkxHaykquEkDZxev654PtEJZ/rU
 oscXoSgnSvy2UCrZSYEt7lT16WL5k3RFfSItCXavKwT8XstDYGHOVMrPeGfKx5T/MIfl
 hsnfaz7qTWf+BwnBg4CBIabDXbFUFvAQIIkFgo1bCYq0qdTCSpjL0vkoY1OM1MH1SiYZ
 dWe/cRYJDpk5XZGt3wyuejmNRwrVPbEA7Yg5HO+oRa3rJ5VMWU/N8t6J1HaQrm5nVwTx
 l9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=signAkDpJN2hTUdQ+bnZtgU9oAO8c61lPXog2qZBVXQ=;
 b=mHff/yuRVxdnZxXZz3qhAuwyd/D8r1hSuHowCgEnZ9Ia67ZXJ8/cL1CJiXZhMyQnJz
 1PqlIagDjN+Q21xZb0fNT3nGsb6KFMgOUPfsqn109Og2FnxZTrJ655I63Yo6T2tXxtcD
 rP9RvvgG9L6boeLa3ZRP33vhuY3J3FG2ly254OjOvc2BBvsmdLWIJzGJJnjoqUp8M4Wl
 ERNgcN1blQrfyqyc2slnNacaXUlOSDN1QfR1U0Sgi1HHMYck9iCBotofVc2aPLSJ2wAz
 cpab00LotpKvF4IZmPOv08OPTNsv15w+wx50nKgRt+3Doptn0NBDZm7abuv1tx96Qv8g
 sxKQ==
X-Gm-Message-State: AOAM530pWyVCVknyLYkzbIykBKxC9fQ48FZ9U0it2FxM+jOLIUbw9dpL
 AjnmVZc8VViGW/QLITFK+pZvGL4KC7tC4I8ey8wnYS4oGhEtN5DRqEQBeIz/3zjiPbskysjYtcY
 9EvGddpqXL0XMq5aTpQmt1pRHTJnod2RH0IRXESgrXtmnsuvOy4nHqJOtZ+zeVjhWqiUXqg==
X-Google-Smtp-Source: ABdhPJy4HeDv6majNt95yNS6XqM9oixfR6t7Y0RnSoaSQtazUpS6zCK+kFjbF8w4Q6jVWeQOSZbGl6civt8=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a1c:286:: with SMTP id
 128mr2724517wmc.37.1597919751015; 
 Thu, 20 Aug 2020 03:35:51 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:40 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-15-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 14/20] KVM: arm64: nVHE: Handle hyp panics
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

Restore the host context when panicking from hyp to give the best chance
of the panic being clean.

The host requires that registers be preserved such as x18 for the shadow
callstack. If the panic is caused by an exception from EL1, the host
context is still valid so the panic can return straight back to the
host. If the panic comes from EL2 then it's most likely that the hyp
context is active and the host context needs to be restored.

There are windows before and after the host context is saved and
restored that restoration is attempted incorrectly and the panic won't
be clean.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/host.S   | 79 +++++++++++++++++++++++---------
 arch/arm64/kvm/hyp/nvhe/switch.c | 18 ++------
 3 files changed, 63 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 0b525e05e5bf..6b664de5ec1f 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -94,7 +94,7 @@ u64 __guest_enter(struct kvm_vcpu *vcpu);
 
 void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __noreturn __hyp_do_panic(unsigned long, ...);
+void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
 #endif
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 1062547853db..40620c1c87b8 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -47,6 +47,7 @@ SYM_FUNC_START(__host_exit)
 	ldp	x2, x3,   [x29, #CPU_XREG_OFFSET(2)]
 	ldp	x4, x5,   [x29, #CPU_XREG_OFFSET(4)]
 	ldp	x6, x7,   [x29, #CPU_XREG_OFFSET(6)]
+__host_enter_for_panic:
 	ldp	x8, x9,   [x29, #CPU_XREG_OFFSET(8)]
 	ldp	x10, x11, [x29, #CPU_XREG_OFFSET(10)]
 	ldp	x12, x13, [x29, #CPU_XREG_OFFSET(12)]
@@ -57,30 +58,49 @@ SYM_FUNC_START(__host_exit)
 	restore_callee_saved_regs x29
 
 	/* Do not touch any register after this! */
+__host_enter_without_restoring:
 	eret
 	sb
 SYM_FUNC_END(__host_exit)
 
+/*
+ * void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+ */
 SYM_FUNC_START(__hyp_do_panic)
+	/* Load the format arguments into x1-7 */
+	mov	x6, x3
+	get_vcpu_ptr x7, x3
+	mov	x7, xzr
+
+	mrs	x3, esr_el2
+	mrs	x4, far_el2
+	mrs	x5, hpfar_el2
+
+	/* Prepare and exit to the host's panic funciton. */
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
 		      PSR_MODE_EL1h)
 	msr	spsr_el2, lr
 	ldr	lr, =panic
 	msr	elr_el2, lr
-	eret
-	sb
+
+	/*
+	 * Set the panic format string and enter the host, conditionally
+	 * restoring the host context.
+	 */
+	cmp	x0, xzr
+	ldr	x0, =__hyp_panic_string
+	b.eq	__host_enter_without_restoring
+	b	__host_enter_for_panic
 SYM_FUNC_END(__hyp_do_panic)
 
 .macro valid_host_el1_sync_vect
 	.align 7
 	stp	x0, x1, [sp, #-16]!
-
 	mrs	x0, esr_el2
 	lsr	x0, x0, #ESR_ELx_EC_SHIFT
 	cmp	x0, #ESR_ELx_EC_HVC64
-	b.ne	hyp_panic
-
 	ldp	x0, x1, [sp], #16
+	b.ne	__host_exit
 
 	/* Check for a stub HVC call */
 	cmp	x0, #HVC_STUB_HCALL_NR
@@ -102,16 +122,31 @@ SYM_FUNC_END(__hyp_do_panic)
 	br	x5
 .endm
 
-.macro invalid_host_vect
+.macro invalid_host_el2_vect
 	.align 7
 	/* If a guest is loaded, panic out of it. */
 	stp	x0, x1, [sp, #-16]!
 	get_loaded_vcpu x0, x1
 	cbnz	x0, __guest_exit_panic
 	add	sp, sp, #16
+
+	/*
+	 * The panic may not be clean if the exception is taken before the host
+	 * context has been saved by __host_exit or after the hyp context has
+	 * been partially clobbered by __host_enter.
+	 */
 	b	hyp_panic
 .endm
 
+.macro invalid_host_el1_vect
+	.align 7
+	mov	x0, xzr		/* restore_host = false */
+	mrs	x1, spsr_el2
+	mrs	x2, elr_el2
+	mrs	x3, par_el1
+	b	__hyp_do_panic
+.endm
+
 /*
  * The host vector does not use an ESB instruction in order to avoid consuming
  * SErrors that should only be consumed by the host. Guest entry is deferred by
@@ -123,23 +158,23 @@ SYM_FUNC_END(__hyp_do_panic)
  */
 	.align 11
 SYM_CODE_START(__kvm_hyp_host_vector)
-	invalid_host_vect			// Synchronous EL2t
-	invalid_host_vect			// IRQ EL2t
-	invalid_host_vect			// FIQ EL2t
-	invalid_host_vect			// Error EL2t
+	invalid_host_el2_vect			// Synchronous EL2t
+	invalid_host_el2_vect			// IRQ EL2t
+	invalid_host_el2_vect			// FIQ EL2t
+	invalid_host_el2_vect			// Error EL2t
 
-	invalid_host_vect			// Synchronous EL2h
-	invalid_host_vect			// IRQ EL2h
-	invalid_host_vect			// FIQ EL2h
-	invalid_host_vect			// Error EL2h
+	invalid_host_el2_vect			// Synchronous EL2h
+	invalid_host_el2_vect			// IRQ EL2h
+	invalid_host_el2_vect			// FIQ EL2h
+	invalid_host_el2_vect			// Error EL2h
 
 	valid_host_el1_sync_vect		// Synchronous 64-bit EL1
-	invalid_host_vect			// IRQ 64-bit EL1
-	invalid_host_vect			// FIQ 64-bit EL1
-	invalid_host_vect			// Error 64-bit EL1
-
-	invalid_host_vect			// Synchronous 32-bit EL1
-	invalid_host_vect			// IRQ 32-bit EL1
-	invalid_host_vect			// FIQ 32-bit EL1
-	invalid_host_vect			// Error 32-bit EL1
+	invalid_host_el1_vect			// IRQ 64-bit EL1
+	invalid_host_el1_vect			// FIQ 64-bit EL1
+	invalid_host_el1_vect			// Error 64-bit EL1
+
+	invalid_host_el1_vect			// Synchronous 32-bit EL1
+	invalid_host_el1_vect			// IRQ 32-bit EL1
+	invalid_host_el1_vect			// FIQ 32-bit EL1
+	invalid_host_el1_vect			// Error 32-bit EL1
 SYM_CODE_END(__kvm_hyp_host_vector)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 375163b7f777..b7abe66fde22 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -242,6 +242,8 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (system_uses_irq_prio_masking())
 		gic_write_pmr(GIC_PRIO_IRQOFF);
 
+	host_ctxt->__hyp_running_vcpu = NULL;
+
 	return exit_code;
 }
 
@@ -253,25 +255,15 @@ void __noreturn hyp_panic(void)
 	struct kvm_cpu_context *host_ctxt =
 		&__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	struct kvm_vcpu *vcpu = host_ctxt->__hyp_running_vcpu;
-	unsigned long str_va;
+	bool restore_host = true;
 
-	if (read_sysreg(vttbr_el2)) {
+	if (vcpu) {
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
 		__load_host_stage2();
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
 
-	/*
-	 * Force the panic string to be loaded from the literal pool,
-	 * making sure it is a kernel address and not a PC-relative
-	 * reference.
-	 */
-	asm volatile("ldr %0, =%1" : "=r" (str_va) : "S" (__hyp_panic_string));
-
-	__hyp_do_panic(str_va,
-		       spsr, elr,
-		       read_sysreg(esr_el2), read_sysreg_el2(SYS_FAR),
-		       read_sysreg(hpfar_el2), par, vcpu);
+	__hyp_do_panic(restore_host, spsr, elr, par);
 	unreachable();
 }
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
