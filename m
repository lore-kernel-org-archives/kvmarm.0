Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CC0C433E9
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 72470208C7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="WT5sc5td"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72470208C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26B704B140;
	Thu,  3 Sep 2020 09:53:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id egNCsr2kS19B; Thu,  3 Sep 2020 09:53:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C83A84B260;
	Thu,  3 Sep 2020 09:53:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6194B2C5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E3GjaOWKQ4Ti for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:34 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E0B24B16C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:34 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id t11so2164013qtn.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=vGZZU806BMsy2FlLEX9qIWyBhkIdFLM7BAbzd+ZcB1o=;
 b=WT5sc5tdhRBRISXaDNOk6FqQ7nwCI8swSSbHW2meTzgSCRWZpQMQ+39HAxerymu55M
 5CKahcMIAX18RDONRzqdli9HeHdrqgbhmfH+IXvMCkRsEsOI6F74TQYH00pedVeTEmwP
 z5IiQJ84F2zGTC7A+1nuGRXSwsuOsdkcieVR8be9W4cDbHpw2RNaUoyt146rNBztQcXS
 a1Zd0KH4aeuqPcGvdE2S0dVtJL9gx0eXQOjqG4PxRjIfhwd5Wtb3JxVhkx89HzqvNalq
 fpH8iLt49vhiwnTEGFUG+akvIrChc+nmcA1QNOhW1s0GdzdFRfqSkECpYrTF8wrUOH+o
 Y9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=vGZZU806BMsy2FlLEX9qIWyBhkIdFLM7BAbzd+ZcB1o=;
 b=Si1IFbqt5vZhNakZavnqYYHpW+mNDTpKAwV8KrOaCXcZvJRi735/PXRGfNwo2kDxa3
 hS/+rsqRTL3iA4BI+Eh80RRpcLWC2U/jwCD/6doLNSsEXafR3Yi5yG2QAU32l3dcqutM
 UtLJ5QKw8wC8GQcL3vsADJ5Nt4M3b0ue4CmL7R1rw4R5X/vkFEibI1jE/gVj4cUFw4bO
 z9Fs5+d1je5uyXxkX8/LPRf/FGe00EzaZdTpTrvNJJJ6JLWWO5d7OrVF8FHEibaDMdKI
 3dGiSMk+e4rzAYo+aOEHMvoJ2dd2qykCuvsXPF+X7B+7O/u8As+Pk51AsiGiC7vs4a7O
 xcsQ==
X-Gm-Message-State: AOAM530OIjl5GJN09eRdUsXZcxWPDbf7rydcbAg2COQCMJ5IYUa0FBi1
 fij3VoopWFXhDuuTga+vtggV3rUrrHSdyw6pjmMRJgI6qrHFeNTvpduqBMfWWEi/PagAbogYdFe
 GmxW/8bAt9Y4f9nWgIKxz2RiIg+hrnmEEFIsS7fGzGc6dFQE++Z67FE4oas4tZJsvZDOfsg==
X-Google-Smtp-Source: ABdhPJw4vZR6Z2Okaohac4Pa1YhCKmEapI4LF/TQcl603TxBJtJMT+OMFzMRR1DDDIyHUfYHfgoynLi/62s=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:b2d4:: with SMTP id
 d20mr1990339qvf.1.1599141213911; 
 Thu, 03 Sep 2020 06:53:33 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:52:59 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-11-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 10/18] KVM: arm64: Restore hyp when panicking in guest
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
 arch/arm64/include/asm/kvm_asm.h        | 10 ++++++++++
 arch/arm64/kvm/hyp/entry.S              | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S          |  5 ++---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +++-
 arch/arm64/kvm/hyp/nvhe/host.S          |  5 +++++
 5 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 34ec1b558219..6c3e3b903343 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -226,6 +226,16 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
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
 /*
  * KVM extable for unexpected exceptions.
  * In the same format _asm_extable, but output to a different section so that
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 38cca690a6ff..4787fc82790c 100644
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
index f92489250dfc..bc9f53df46f5 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -145,7 +145,7 @@ el2_error:
 	eret
 	sb
 
-.macro invalid_vector	label, target = hyp_panic
+.macro invalid_vector	label, target = __guest_exit_panic
 	.align	2
 SYM_CODE_START(\label)
 	b \target
@@ -186,10 +186,9 @@ check_preamble_length 661b, 662b
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
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index afe714056b97..821721b78ad9 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -509,6 +509,7 @@ static inline void __set_host_arch_workaround_state(struct kvm_vcpu *vcpu)
 
 static inline void __kvm_unexpected_el2_exception(void)
 {
+	extern char __guest_exit_panic[];
 	unsigned long addr, fixup;
 	struct exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
@@ -529,7 +530,8 @@ static inline void __kvm_unexpected_el2_exception(void)
 		return;
 	}
 
-	hyp_panic();
+	/* Trigger a panic after restoring the hyp context. */
+	write_sysreg(__guest_exit_panic, elr_el2);
 }
 
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */
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
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
