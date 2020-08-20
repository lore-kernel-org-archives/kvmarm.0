Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43A3C433E1
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9AD4620885
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ftAVyEgD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AD4620885
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5529B4B85C;
	Thu, 20 Aug 2020 06:35:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q2MzKRBWpn-o; Thu, 20 Aug 2020 06:35:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED30E4B889;
	Thu, 20 Aug 2020 06:35:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 460004B364
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JR2Ry7HlpqlJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:49 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42B9C4B86C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:49 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id o8so1781282ybg.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=Z52PvuoAeNAlVglLYMJyxpHd4UnE5OntGtMJdsIzdAs=;
 b=ftAVyEgDyRU3uE3FbF1hO2JO95vap7AgKcfdc8+gz6wh1sKc0cd+WU6kfNwuh3ezyh
 KVBBntrmci01FQvMwPImgL/2rwqlWCwY0PYHOUni/UJP7QEBsm8etUr5H5yY7mk1mckA
 /CIcUv6OxCjgaNQ5Zep8PXcbI9CLRTgpGQljm9iHrHtgylKxeVUpmhJuhyVLtBAqMsWx
 9qtyxLgU16VWkvkwopLrZHwn79CfdQ8vz3gxVNgYSFGFrgYXL60peIyNVhM1XXWfYJ9m
 WV13tqRYUemkGQr5p4YHGjf1UtLWtwoEmQzjQMphWUzLY7w3DjuiXzWdGnodiH4hrUyb
 H9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Z52PvuoAeNAlVglLYMJyxpHd4UnE5OntGtMJdsIzdAs=;
 b=HE7wQmiHKZh8FoMKyRiDmvjOIzL3d6eG7Xei5M4Qu8qZYRPG8KmAVtX8lht0/UHX5M
 GIrok8ZiHXilcVrnNRqreT4fQ9w9OJpgCF4uxxMdcwNR0GoKje5kfN1VDYj+ssU8701t
 UI6hX1eS/lPusIqV99ZY43iB6Qh5KJ1h1chbfDRBAkJHxiBR49e2XU0p94hcI/d9YlM5
 /hAUP4mWym1+wYMXlwLfQmKMxBMlB6AKpEU+ZKMXDx3T3NS5vUyMRAFLIXJB+XZs28OC
 kMQ4B6n/ZpRqnHKGtFFldqATAAHhujSKHjyAThHafrG2W5klhLcU4s7SOJbN8/MftcUN
 D5cQ==
X-Gm-Message-State: AOAM532RQ90UIiDCu8c+PLEaPpCg45yVLyO9P3BynMOONYSx/+ww8/Zj
 oQjsPFxWmBrZsw6hBDbfr/wsallN0cSyC1N466kLPeBBQqwitlbYjO7f0p3WBNIA09c6jEWYjFz
 DRG7B96ay9ChRX0E035nKqylhTVQvDbgzRla+0OBWVg339GOJimukKABZG5mcXnbP1TR3Kg==
X-Google-Smtp-Source: ABdhPJyMVHLl+k/XnkRhGvt7h8vFB61AIXIoetie/9K5BHpZFrVhAya7dVh8BXZeB5/tabu4/BmS4HTwXaI=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a25:6986:: with SMTP id
 e128mr3611199ybc.199.1597919748734; 
 Thu, 20 Aug 2020 03:35:48 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:39 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-14-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 13/20] KVM: arm64: nVHE: Switch to hyp context for EL2
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
index e9382c7e100a..01d9dcd9d591 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -368,6 +368,8 @@ static inline bool esr_is_ptrauth_trap(u32 esr)
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
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
