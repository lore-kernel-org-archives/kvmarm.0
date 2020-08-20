Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826D2C433E3
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3AFE220738
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="PuNNLjYO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AFE220738
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F544B7C7;
	Thu, 20 Aug 2020 06:35:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O1wuifOLOCoP; Thu, 20 Aug 2020 06:35:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3DAA4B889;
	Thu, 20 Aug 2020 06:35:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FE2E4B78D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id va2K0JgArE38 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:45 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F27D4B845
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:45 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id r29so507178wrr.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=RRUDLQ30J3nDHv605QtnFqERH+SevOS80YqWgmQFnRQ=;
 b=PuNNLjYO2m6kcfgatgkfzfu8KbNu/7W94jO41l7ayWj/6/LM7fdeLea4tzkvUkCCxz
 Qq4CqdLVmWVkCx0WTBPTzigccnrYEqphjJ8drnlWmOyKjPq7agHbj239WVyJEFfMY3rD
 4vunlIsHn9I5pubvgn0V9tJIRxg8U3gnX1DOCtpcwgT8Ka0QSq2rrHjTn3pWgHAM4RpQ
 5mTrVj7ol5AK+BaU96m0DTwtiN1p/nN8L/UKEJ3ZIEfDfX+nRCIDs6H51NUAoDVKCzKs
 2RCp5g4G+WudScL3VKtvaQT8gIvqIc0O1vVQqughEkdKfvt+vDeM4k13LnArofetvQ1T
 U2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=RRUDLQ30J3nDHv605QtnFqERH+SevOS80YqWgmQFnRQ=;
 b=BcTIsia+DrQpDPcjX+C6vaKAcLGbpdODC2Xry9gLP8YFoFQdhWJyYJqQa32Va4Dh+6
 McC//+yuSWhYj/4mp5iV1l7qmEzQNtIQrcwT+yrU7Kyy130WLjx1T8jzQDpUdSjJZS7D
 8Nz9XJrVaT/UCosoSiftM3iO/r6wC6wSCwqW19mSx9nv4co7xmu1vMe8NDh8RfemCXJY
 sSPwgYmq3z/+kDBkaZ753MVFhaT8k9/MHACmQievVsQWCveCMDlFD3X8TAsXY/Rc7OBu
 Fij05IJmbznNpiLAJv12GcORsobuv/RZ4x+sG2Z8LBYob49DoqDEMqE8Sn7kFrDTNJ4h
 nlRw==
X-Gm-Message-State: AOAM5302a/+BaiSTN3IP9UKFWfas1ATdpSc/XKddKuvROUrIV4YH5e/M
 1UqGXc6KiRA0xGuLMyczrvGTATQ4cg1I+k4qCgLxp2b3Dslk0Ylr33EGk1Pp3VNTvr1Bh8JkmPE
 YuXtz+LfKLY1bON535HR7j/ky5ASy1Dm0Qcu8u6HwB0JnTpRHMyo64Y3xNiXhbZ0qBdnGEA==
X-Google-Smtp-Source: ABdhPJx3iaCJXYdyOkNUaDW3ih429EiBupZLfTd5sWs8MnkLgLWgBjzD/EH4FdnyeCa6CoE30TE48gC24T0=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a1c:7f17:: with SMTP id
 a23mr2796360wmd.28.1597919744411; 
 Thu, 20 Aug 2020 03:35:44 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:37 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-12-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 11/20] KVM: arm64: Restore hyp when panicking in guest
 context
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

If the guest context is loaded when a panic is triggered, restore the
hyp context so e.g. the shadow call stack works when hyp_panic() is
called and SP_EL0 is valid when the host's panic() is called.

Use the hyp context's __hyp_running_vcpu field to track when hyp
transitions to and from the guest vcpu so the exception handlers know
whether the context needs to be restored.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 10 ++++++++++
 arch/arm64/kvm/hyp/entry.S       | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S   | 12 +++++-------
 arch/arm64/kvm/hyp/nvhe/host.S   |  5 +++++
 4 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 81f29a2c361a..106279a6d027 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -198,6 +198,16 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
 .endm
 
+.macro get_loaded_vcpu vcpu, ctxt
+	hyp_adr_this_cpu \ctxt, kvm_hyp_ctxt, \vcpu
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
+.endm
+
+.macro set_loaded_vcpu vcpu, ctxt, tmp
+	hyp_adr_this_cpu \ctxt, kvm_hyp_ctxt, \tmp
+	str	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
+.endm
+
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index e95cd7f2ff86..872ac89ffc1e 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -86,6 +86,8 @@ alternative_else_nop_endif
 	ret
 
 1:
+	set_loaded_vcpu x0, x1, x2
+
 	add	x29, x0, #VCPU_CONTEXT
 
 	// Macro ptrauth_switch_to_guest format:
@@ -116,6 +118,26 @@ alternative_else_nop_endif
 	eret
 	sb
 
+SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
+	// x2-x29,lr: vcpu regs
+	// vcpu x0-x1 on the stack
+
+	// If the hyp context is loaded, go straight to hyp_panic
+	get_loaded_vcpu x0, x1
+	cbz	x0, hyp_panic
+
+	// The hyp context is saved so make sure it is restored to allow
+	// hyp_panic to run at hyp and, subsequently, panic to run in the host.
+	// This makes use of __guest_exit to avoid duplication but sets the
+	// return address to tail call into hyp_panic. As a side effect, the
+	// current state is saved to the guest context but it will only be
+	// accurate if the guest had been completely restored.
+	hyp_adr_this_cpu x0, kvm_hyp_ctxt, x1
+	adr	x1, hyp_panic
+	str	x1, [x0, #CPU_XREG_OFFSET(30)]
+
+	get_vcpu_ptr	x1, x0
+
 SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// x0: return code
 	// x1: vcpu
@@ -163,6 +185,8 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// Now restore the hyp regs
 	restore_callee_saved_regs x2
 
+	set_loaded_vcpu xzr, x1, x2
+
 alternative_if ARM64_HAS_RAS_EXTN
 	// If we have the RAS extensions we can consume a pending error
 	// without an unmask-SError and isb. The ESB-instruction consumed any
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 6e14873680a8..b7a1ea221f6e 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -96,7 +96,7 @@ el2_sync:
 
 	/* if this was something else, then panic! */
 	tst	x0, #PSR_IL_BIT
-	b.eq	hyp_panic
+	b.eq	__guest_exit_panic
 
 	/* Let's attempt a recovery from the illegal exception return */
 	get_vcpu_ptr	x1, x0
@@ -105,8 +105,6 @@ el2_sync:
 
 
 el2_error:
-	ldp	x0, x1, [sp], #16
-
 	/*
 	 * Only two possibilities:
 	 * 1) Either we come from the exit path, having just unmasked
@@ -124,12 +122,13 @@ el2_error:
 	cmp	x0, x1
 	adr	x1, abort_guest_exit_end
 	ccmp	x0, x1, #4, ne
-	b.ne	hyp_panic
+	b.ne	__guest_exit_panic
+	ldp	x0, x1, [sp], #16
 	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 	eret
 	sb
 
-.macro invalid_vector	label, target = hyp_panic
+.macro invalid_vector	label, target = __guest_exit_panic
 	.align	2
 SYM_CODE_START(\label)
 	b \target
@@ -170,10 +169,9 @@ check_preamble_length 661b, 662b
 .macro invalid_vect target
 	.align 7
 661:
-	b	\target
 	nop
+	stp	x0, x1, [sp, #-16]!
 662:
-	ldp	x0, x1, [sp], #16
 	b	\target
 
 check_preamble_length 661b, 662b
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 5a7380c342c8..d4e8b8084020 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -72,6 +72,11 @@ SYM_FUNC_END(__hyp_do_panic)
 
 .macro invalid_host_vect
 	.align 7
+	/* If a guest is loaded, panic out of it. */
+	stp	x0, x1, [sp, #-16]!
+	get_loaded_vcpu x0, x1
+	cbnz	x0, __guest_exit_panic
+	add	sp, sp, #16
 	b	hyp_panic
 .endm
 
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
