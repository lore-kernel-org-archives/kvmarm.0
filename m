Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83E4C43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54D6521D80
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Yrxhb/Ib"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54D6521D80
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 071C64B339;
	Tue, 15 Sep 2020 06:47:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7JcFGqlA6VgH; Tue, 15 Sep 2020 06:47:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFFF34B38A;
	Tue, 15 Sep 2020 06:47:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 262744B381
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MSu8g3ET6Bno for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:47:16 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C62E34B368
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:15 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id p20so1891255qvl.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=wzFd2Se+hSZFSU9MNWw+evLd20Vc2LmYdGji4Cqfwno=;
 b=Yrxhb/IbZqs0MnCRYBKrcrZAcxjNPwN8Eg0LpUCBEdK5DW8r+vfUFntl0dVniBVcur
 YEFy2X9rzGfmEpygefHHNWbkM+zC+z93+L25nUieVxaVXx/V7ni40oMsigqpPigpwABc
 LgSKRyUdCTNigBQk2RPThRzCDg+horsKnF5Nu6FbJUpGCIKaXUnFvBfpGf5qW1zp+dCf
 5cFDDsegiDbKseWvr8CFcGvc5KzELjcMWNvG+poynIp/v4yLKX1dBJ7Mbrile2j4kvEZ
 X1ooBEnenEODgpU/DoecDxggRQiK8b6HoUtO4LmW4nIQbSzY7gTga9PU39xJYZ+bMDBK
 HuDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wzFd2Se+hSZFSU9MNWw+evLd20Vc2LmYdGji4Cqfwno=;
 b=oj58HwXCF+VsKoRhvxrAXSp4k4ZTcE7w+pfEwCR6kSzIZqVrMNx1+JiIBLdKGuEtnm
 /T5QFXhlz7cnucFESIx0KUvR9tYRtDngFXT4k3vzdikWZs9R5K6HVqlXBNsKSeOAL0Ya
 3fugNO9YsYA4iafx9gL2sqB0zeHacqfQB9hgiVp0UOLs0U7UYK3qUvpa1l/P3BRJuK2H
 q52ECufdUMBRdOY/1tVstORykEoPphmRfFJnVR9bdu+jyNTntkgdBQUyBn9U0PdEjgjB
 UHfI47WNDnVye9ocnymXRtXIihYg9UBueyiTgA4MeHUZ3Gf93frAGxYdJ5hPoNxGlYRu
 Um1Q==
X-Gm-Message-State: AOAM532Zf3vz/rZDMolMs1Ypk0oZUWtp3gJFmXjtmVfwqgxozOoVtnE2
 o3ZLbWN+qsl2KGtabPwAtML71J+SC+l1UOGubmyTYpaeiiyxh/q01kPL6x/PVa4yhFPIDvQSHhe
 dDZULTNroJlhzvphbmPJ5HEr2cGtebKCZTMNdQMeEgBnBLSaEkNpAzBrE/Ty2UabISDfYpQ==
X-Google-Smtp-Source: ABdhPJwdICVtPnTewBkU+0XX56pwR94BGjqfet77o0wGVIPdThjbg/6FNE62pNL2F9jnTFbS5JlbAv7eNUY=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:ad4:58e7:: with SMTP id
 di7mr1042793qvb.36.1600166835280; 
 Tue, 15 Sep 2020 03:47:15 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:36 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-13-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 12/19] KVM: arm64: nVHE: Switch to hyp context for EL2
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

Save and restore the host context when switching to and from hyp. This
gives hyp its own context that the host will not see as a step towards a
full trust boundary between the two.

SP_EL0 and pointer authentication keys are currently shared between the
host and hyp so don't need to be switched yet.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +
 arch/arm64/kvm/hyp/nvhe/Makefile        |  2 +-
 arch/arm64/kvm/hyp/nvhe/host.S          | 68 ++++++++++++++++++-------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 36 +++++++++++++
 4 files changed, 89 insertions(+), 19 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-main.c

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 821721b78ad9..4536b50ddc06 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -372,6 +372,8 @@ static inline bool esr_is_ptrauth_trap(u32 esr)
 	ctxt_sys_reg(ctxt, key ## KEYHI_EL1) = __val;                   \
 } while(0)
 
+DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
+
 static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *ctxt;
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index ddf98eb07b9d..46c89e8c30bc 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o hyp-main.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
 
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 9ab7814e6114..d26e41773dc4 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -12,6 +12,55 @@
 
 	.text
 
+SYM_FUNC_START(__host_exit)
+	stp	x0, x1, [sp, #-16]!
+
+	get_host_ctxt	x0, x1
+
+	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
+
+	/* Store the host regs x2 and x3 */
+	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(2)]
+
+	/* Retrieve the host regs x0-x1 from the stack */
+	ldp	x2, x3, [sp], #16	// x0, x1
+
+	/* Store the host regs x0-x1 and x4-x17 */
+	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(0)]
+	stp	x4, x5,   [x0, #CPU_XREG_OFFSET(4)]
+	stp	x6, x7,   [x0, #CPU_XREG_OFFSET(6)]
+	stp	x8, x9,   [x0, #CPU_XREG_OFFSET(8)]
+	stp	x10, x11, [x0, #CPU_XREG_OFFSET(10)]
+	stp	x12, x13, [x0, #CPU_XREG_OFFSET(12)]
+	stp	x14, x15, [x0, #CPU_XREG_OFFSET(14)]
+	stp	x16, x17, [x0, #CPU_XREG_OFFSET(16)]
+
+	/* Store the host regs x18-x29, lr */
+	save_callee_saved_regs x0
+
+	/* Save the host context pointer in x29 across the function call */
+	mov	x29, x0
+	bl	handle_trap
+
+	/* Restore host regs x0-x17 */
+	ldp	x0, x1,   [x29, #CPU_XREG_OFFSET(0)]
+	ldp	x2, x3,   [x29, #CPU_XREG_OFFSET(2)]
+	ldp	x4, x5,   [x29, #CPU_XREG_OFFSET(4)]
+	ldp	x6, x7,   [x29, #CPU_XREG_OFFSET(6)]
+	ldp	x8, x9,   [x29, #CPU_XREG_OFFSET(8)]
+	ldp	x10, x11, [x29, #CPU_XREG_OFFSET(10)]
+	ldp	x12, x13, [x29, #CPU_XREG_OFFSET(12)]
+	ldp	x14, x15, [x29, #CPU_XREG_OFFSET(14)]
+	ldp	x16, x17, [x29, #CPU_XREG_OFFSET(16)]
+
+	/* Restore host regs x18-x29, lr */
+	restore_callee_saved_regs x29
+
+	/* Do not touch any register after this! */
+	eret
+	sb
+SYM_FUNC_END(__host_exit)
+
 SYM_FUNC_START(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
 		      PSR_MODE_EL1h)
@@ -34,7 +83,7 @@ SYM_FUNC_END(__hyp_do_panic)
 
 	/* Check for a stub HVC call */
 	cmp	x0, #HVC_STUB_HCALL_NR
-	b.hs	1f
+	b.hs	__host_exit
 
 	/*
 	 * Compute the idmap address of __kvm_handle_stub_hvc and
@@ -50,23 +99,6 @@ SYM_FUNC_END(__hyp_do_panic)
 	/* x5 = __pa(x5) */
 	sub	x5, x5, x6
 	br	x5
-
-1:
-	/*
-	 * Shuffle the parameters before calling the function
-	 * pointed to in x0. Assumes parameters in x[1,2,3].
-	 */
-	kern_hyp_va	x0
-	str	lr, [sp, #-16]!
-	mov	lr, x0
-	mov	x0, x1
-	mov	x1, x2
-	mov	x2, x3
-	blr	lr
-	ldr	lr, [sp], #16
-
-	eret
-	sb
 .L__vect_end\@:
 .if ((.L__vect_end\@ - .L__vect_start\@) > 0x80)
 	.error "host_el1_sync_vect larger than vector entry"
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
new file mode 100644
index 000000000000..570c3896f42e
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 - Google Inc
+ * Author: Andrew Scull <ascull@google.com>
+ */
+
+#include <hyp/switch.h>
+
+#include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_host.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+
+typedef unsigned long (*hypcall_fn_t)
+	(unsigned long, unsigned long, unsigned long);
+
+void handle_trap(struct kvm_cpu_context *host_ctxt)
+{
+	u64 esr = read_sysreg_el2(SYS_ESR);
+	hypcall_fn_t func;
+	unsigned long ret;
+
+	if (ESR_ELx_EC(esr) != ESR_ELx_EC_HVC64)
+		hyp_panic();
+
+	/*
+	 * __kvm_call_hyp takes a pointer in the host address space and
+	 * up to three arguments.
+	 */
+	func = (hypcall_fn_t)kern_hyp_va(host_ctxt->regs.regs[0]);
+	ret = func(host_ctxt->regs.regs[1],
+		   host_ctxt->regs.regs[2],
+		   host_ctxt->regs.regs[3]);
+	host_ctxt->regs.regs[0] = ret;
+}
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
