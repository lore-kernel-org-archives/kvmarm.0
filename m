Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7E4C43461
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3718208C7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="bG/FxPK6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3718208C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82C184B2DA;
	Thu,  3 Sep 2020 09:53:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EA-N545ZZV8C; Thu,  3 Sep 2020 09:53:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 381DB4B2F3;
	Thu,  3 Sep 2020 09:53:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5CD94B14C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6a54yXUa1504 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:39 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BDF54B2DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:39 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id j35so2163855qtk.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=iX0UA+C5OJZxUJ80KkTtDVXLZzGWOE7Mb0uxCBt1RA0=;
 b=bG/FxPK6DoBGR9W5dst5PPYrkG90sT2B0YaFVThu6MlnSW07Lutxi/s2mjMxYNOSzX
 K67IAYsElF7otuIStLWYGLvfuPqVMgX42zCajbYqDDebht1w6mogHV6IOVSkl/vPJQGe
 RdGK6RzKQvzJHy7+P5Eb5Lbw81LhDnliVjGLkWUJ9czRLcLne13bdp9tELpCxjNLeyg1
 ZwG2aqSZ44wFgrhKJQBMoVoIljkmYuPkXV2DpNQl9x9YnCZwSI/wr+h4yobPzsy6qWY3
 SdcoEyIar0OAAPylnqsVH1fnuYFZaAShJLikpW+kMK0Z6CBAvTo0ZYxZFv1irWPjWLII
 smLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iX0UA+C5OJZxUJ80KkTtDVXLZzGWOE7Mb0uxCBt1RA0=;
 b=ErNgVulDKy0krAumiat1aRwXGhzCa+RYHysmt0iEANX7foEwKuv0TW9uVHnS675U+R
 SNAUpcmvn4WfBxZU73tiurj4+XFkOskpYrBZW5rvHgeJkdtKWTLoyxIuJ7SDKDKZ+DZ2
 N1TZ3s29ZQu0FJf7+bRFtJAmQ1a8HdTj82ye0eK3+kkXnibrikbLb0oChXmuyyCllimo
 5V6nG0h7HaDODgJOMNSekTaOdqr1UrjW7sKKnjrUNlzQ7xit+dttXyJgtbjOf48D7Xik
 Ncr2R/hNJIlL7qVxrUuakhN9k+A4U6jPzTAEg+sF1csAPprEq6I/umsxM3OPmChZL0l8
 QYOA==
X-Gm-Message-State: AOAM5324sueR1dXuT+ILqIngPpfunpoR+bGNzfqO6PinEfRT6ao249ad
 +OnSutRJPSf4HLbkJwNTCRNrzULsqBlb+dTHSUPhnzQeO2UejpFCXbKaKszcV9MXnGuj3e2/wp+
 VnaHWVjAiBRUObDUKKJtBB9T1hgsTR/UMKrBhkFuo3CUda2ycubJz9faTl44aJukmQguBnw==
X-Google-Smtp-Source: ABdhPJyLx4gbvAjvzeOs30bQnDUV3ooTAL/i228YR9AoNHXwYI+8skpt4WY+62adPVr1RzxtgaZSQWV7zao=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:e543:: with SMTP id
 n3mr1943671qvm.11.1599141218554; 
 Thu, 03 Sep 2020 06:53:38 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:53:01 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-13-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 12/18] KVM: arm64: nVHE: Switch to hyp context for EL2
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
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 35 +++++++++++++
 4 files changed, 88 insertions(+), 19 deletions(-)
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
index d4e8b8084020..1062547853db 100644
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
+	/* Store the guest regs x2 and x3 */
+	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(2)]
+
+	/* Retrieve the guest regs x0-x1 from the stack */
+	ldp	x2, x3, [sp], #16	// x0, x1
+
+	// Store the guest regs x0-x1 and x4-x17
+	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(0)]
+	stp	x4, x5,   [x0, #CPU_XREG_OFFSET(4)]
+	stp	x6, x7,   [x0, #CPU_XREG_OFFSET(6)]
+	stp	x8, x9,   [x0, #CPU_XREG_OFFSET(8)]
+	stp	x10, x11, [x0, #CPU_XREG_OFFSET(10)]
+	stp	x12, x13, [x0, #CPU_XREG_OFFSET(12)]
+	stp	x14, x15, [x0, #CPU_XREG_OFFSET(14)]
+	stp	x16, x17, [x0, #CPU_XREG_OFFSET(16)]
+
+	/* Store the guest regs x18-x29, lr */
+	save_callee_saved_regs x0
+
+	/* Save the host context pointer in x29 across the function call */
+	mov	x29, x0
+	bl	handle_trap
+
+	/* Restore guest regs x0-x17 */
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
+	/* Restore guest regs x18-x29, lr */
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
@@ -35,7 +84,7 @@ SYM_FUNC_END(__hyp_do_panic)
 
 	/* Check for a stub HVC call */
 	cmp	x0, #HVC_STUB_HCALL_NR
-	b.hs	1f
+	b.hs	__host_exit
 
 	/*
 	 * Compute the idmap address of __kvm_handle_stub_hvc and
@@ -51,23 +100,6 @@ SYM_FUNC_END(__hyp_do_panic)
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
 .endm
 
 .macro invalid_host_vect
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
new file mode 100644
index 000000000000..c8938e09f585
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -0,0 +1,35 @@
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
+void handle_trap(struct kvm_cpu_context *host_ctxt) {
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
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
