Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDF9C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:36:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 812F520639
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:36:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="UGKHI5Om"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 812F520639
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36D934B867;
	Thu, 20 Aug 2020 06:36:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ebVmDwD2mpFE; Thu, 20 Aug 2020 06:36:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9F8F4B814;
	Thu, 20 Aug 2020 06:36:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A1FD4B814
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:36:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3SAAtjDCIJd8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:36:05 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18E364B872
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:36:05 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id p184so806586wmp.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=YnIDkojxZWvGrLdfzL+x20jLDIFUW/oDu0/bNDDOHqc=;
 b=UGKHI5OmI2cUPFTctM+KI91jNDPnK6yq6zAihfswg9a1jHU4W+tLBBL0gE3mVPMb8N
 oO2tHKOtxCqvJD1Vmi75sPsdDINO9+v4qNUeidnCjdweLYiTaud/DOTs19qNJE5Yixrm
 HMoh2l3Hd4E0RADAGN/4LVVpadYG3NuLMyynA50ToRXqmGYlA2L8Dvko30jtACBP6qHz
 bM9RRkepPzlXCvkfggwXh10srG29+0Mce90livaULrWj5QWD9oI2sYQ+bADKpz9LjPVc
 mU8gdXl3XerbsEbC3eNBR72F29Y1PTVSXezBo2jlMfuHm+WUSnJeDCS9bftZpzirUU26
 ejwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YnIDkojxZWvGrLdfzL+x20jLDIFUW/oDu0/bNDDOHqc=;
 b=WS2MGgJUWISkWRxyCN/EGDBQ11Lx4McOFvUqHv+/FWdFxi+6v3NfhxMRqftcbzbckc
 t7A2wwwBXxx8v3Eco1LBwIpgSH40Mx5Pm01l9Gfzcpa6n8eCwUbwzQSNwQpLyQoJGpz7
 syR42Y9HQWkefUSyI6NHB90vAR8xlkPvmhuanE3I5zvaIRnenvKzmYtrMEk5fY/J6BS5
 /4XYFpxfBZFz9jgQZbiVnLtPsas9IgcAk7La9M7njdPN2sdZ1okRw2/qJzJ3X6lyUmeE
 RTnfrwS+zzhAGfoILf0kfJxPU56vJcQdZNsK2XQrzDkNwPoe/eP+8s3ucNIPUBgoDDSU
 KKbA==
X-Gm-Message-State: AOAM5311Q/JJRM/NKQI+p9xjXdjITHhMOJ3DMlg3lm2JwJcVfMmrpIcK
 ZrivXCfMwbLD8lzDn6DCjbkIyZmRm+Y5a7M+ZzvE1amJoSZcEvbmNNjIarBmOpf6gOYw7HSJoGq
 uhEQvFcJ0vUP84qPZlxA6UbxRXVX55IIpIl5oeOa+1oSBPW+8+hC7cRY5g3MvlJgmzmO4Xg==
X-Google-Smtp-Source: ABdhPJwT89xJnZRWjqWD0qIGZ2McuPGMJdHO9+XfTBNdOsErjCDjeyowWHssxGWNT5eWz/3MNzgKYBCgVMg=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:adf:e7cd:: with SMTP id
 e13mr2531035wrn.227.1597919763968; 
 Thu, 20 Aug 2020 03:36:03 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:46 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-21-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 20/20] KVM: arm64: nVHE: Handle stub HVCs in the host loop
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
 arch/arm64/kvm/hyp/hyp-entry.S     |  1 -
 arch/arm64/kvm/hyp/nvhe/host.S     | 26 +--------------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 13 ++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 51 +++++++++++++++++++++++++++++-
 4 files changed, 62 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index b7a1ea221f6e..db54f84003ec 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -24,7 +24,6 @@ el1_sync:				// Guest trapped into EL2
 	ccmp	x0, #ESR_ELx_EC_HVC32, #4, ne
 	b.ne	el1_trap
 
-el1_hvc_guest:
 	/*
 	 * Fastest possible path for ARM_SMCCC_ARCH_WORKAROUND_1.
 	 * The workaround has already been applied on the host,
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 40620c1c87b8..68d425b7bd62 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -95,31 +95,7 @@ SYM_FUNC_END(__hyp_do_panic)
 
 .macro valid_host_el1_sync_vect
 	.align 7
-	stp	x0, x1, [sp, #-16]!
-	mrs	x0, esr_el2
-	lsr	x0, x0, #ESR_ELx_EC_SHIFT
-	cmp	x0, #ESR_ELx_EC_HVC64
-	ldp	x0, x1, [sp], #16
-	b.ne	__host_exit
-
-	/* Check for a stub HVC call */
-	cmp	x0, #HVC_STUB_HCALL_NR
-	b.hs	__host_exit
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
+	b	__host_exit
 .endm
 
 .macro invalid_host_el2_vect
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 47224dc62c51..40b5aa95c194 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -16,6 +16,9 @@
 #include <asm/sysreg.h>
 #include <asm/virt.h>
 
+#include <asm/kvm_asm.h>
+#include <asm/kvm_ptrauth.h>
+
 	.text
 	.pushsection	.hyp.idmap.text, "ax"
 
@@ -138,6 +141,7 @@ SYM_CODE_START(__kvm_handle_stub_hvc)
 	cmp	x0, #HVC_SOFT_RESTART
 	b.ne	1f
 
+SYM_INNER_LABEL(__kvm_handle_stub_hvc_soft_restart, SYM_L_GLOBAL)
 	/* This is where we're about to jump, staying at EL2 */
 	msr	elr_el2, x1
 	mov	x0, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT | PSR_MODE_EL2h)
@@ -150,8 +154,13 @@ SYM_CODE_START(__kvm_handle_stub_hvc)
 	b	reset
 
 1:	cmp	x0, #HVC_RESET_VECTORS
-	b.ne	1f
+	b.ne	3f
+	b	2f
+
+SYM_INNER_LABEL(__kvm_handle_stub_hvc_reset_vectors, SYM_L_GLOBAL)
+	restore_callee_saved_regs x5
 
+2:
 	/*
 	 * Set the HVC_RESET_VECTORS return code before entering the common
 	 * path so that we do not clobber x0-x2 in case we are coming via
@@ -172,7 +181,7 @@ reset:
 	msr	vbar_el2, x5
 	eret
 
-1:	/* Bad stub call */
+3:	/* Bad stub call */
 	mov_q	x0, HVC_STUB_ERR
 	eret
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 78d7afcefbb8..302333ea96eb 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -14,6 +14,52 @@
 
 #include <kvm/arm_hypercalls.h>
 
+typedef __noreturn unsigned long (*stub_hvc_handler_t)
+	(unsigned long, unsigned long, unsigned long, unsigned long,
+	 unsigned long, struct kvm_cpu_context *);
+
+extern char __kvm_handle_stub_hvc_soft_restart[];
+extern char __kvm_handle_stub_hvc_reset_vectors[];
+
+static void handle_stub_hvc(unsigned long func_id,
+			    struct kvm_cpu_context *host_ctxt)
+{
+	char *stub_hvc_handler_kern_va;
+	stub_hvc_handler_t stub_hvc_handler;
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
+		host_ctxt->regs.regs[0] = HVC_STUB_ERR;
+		return;
+	}
+
+	stub_hvc_handler = (stub_hvc_handler_t)
+		(stub_hvc_handler_kern_va - kimage_voffset);
+
+	/* Preserve x0-x4, which may contain stub parameters. */
+	stub_hvc_handler(func_id,
+			 host_ctxt->regs.regs[1],
+			 host_ctxt->regs.regs[2],
+			 host_ctxt->regs.regs[3],
+			 host_ctxt->regs.regs[4],
+			 host_ctxt);
+}
+
 static void handle_host_hcall(unsigned long func_id,
 			      struct kvm_cpu_context *host_ctxt)
 {
@@ -118,5 +164,8 @@ void handle_trap(struct kvm_cpu_context *host_ctxt) {
 		hyp_panic();
 
 	func_id = host_ctxt->regs.regs[0];
-	handle_host_hcall(func_id, host_ctxt);
+	if (func_id < HVC_STUB_HCALL_NR)
+		handle_stub_hvc(func_id, host_ctxt);
+	else
+		handle_host_hcall(func_id, host_ctxt);
 }
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
