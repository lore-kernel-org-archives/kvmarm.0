Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36671C43461
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE55F20BED
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="XybMqOVI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE55F20BED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C8F4B140;
	Thu,  3 Sep 2020 09:53:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o3SWU-8limC9; Thu,  3 Sep 2020 09:53:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CDB94B2FB;
	Thu,  3 Sep 2020 09:53:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 539C24B119
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XMwBnG+PtFVK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:37 -0400 (EDT)
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com
 [209.85.208.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 348784B29C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:37 -0400 (EDT)
Received: by mail-ed1-f74.google.com with SMTP id n4so1311520edo.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=cAvy6+fwIiIRiG9Lmy2tseyLyfcoEEJ+B7YgNlapmHE=;
 b=XybMqOVIYlSbC1mtMeCumaSTYuKR14itWH/9Udj4Q/jGw8Oq2z5dQkzc3Z8OnEAxyI
 D/WhXvX6F7odWpOCc5SLig1gOk/Nz3nvFHkkh1MeM5Gjy+jgHn7aho1eHSp5US8n3b0Z
 G2P6ACMYQzfdKCG9u6wQGCD04ORc6Zb7PV3PJpMwah9eMHfesEBYJAWxAJGWyA+WlC7F
 Qo4U+F/WpRzmHvZVLVczcGsLMRw9V3yyDACclox5sf1IkoypDs5HqFMvctotspcuy7IV
 HFWVNtmdEM9SfMSkgHrbZZKKACYpxV0u0j5IFRKG3zdLc3nweKjZyMPqF1eruiq2u8R7
 3u3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cAvy6+fwIiIRiG9Lmy2tseyLyfcoEEJ+B7YgNlapmHE=;
 b=uPJndUcfhvTHcl8fKY2eiAGQF6V9KQOZfPfKTFFxaPZWR3dpjMrOoqWglZ4tXAmLnk
 q1tLIt6OBQze+R2JXLwA6NxqnPH9lw0Vw4O+caM7rTuz/ncF9j3DxZ6+SrlcFoJ0Vwwb
 F/H5Mket8x1bbOAxbjo2UML5Ew+RHQVWKlRqmjedWP9GY2IFIaHNWVaV3Y63u1AF7shA
 dswq7HuBXOVNoSVdN/FNXCYI5QNXI7KTOVHkFlZJvTwDMcnfOlsFEBsVc/wmz/VPyPzl
 0bs4j+W/lnK7+BwrYL4wxAMS8CmjmQanL4VNXeiTbQREgER35RXJAFYqFytw9MNwFWvF
 EnSg==
X-Gm-Message-State: AOAM531VQhtTeDfkbFjrmswW+fjxMm1kuyrdHDKwtTRf1TPUaHkb4G+9
 tZKUA9zRgJ4ScDt3upNJRE/7CflQVsQXwy5oV/C5eH9vg9m52tFQO8EMQQj+FPj0ZX5ujM3dXa0
 OPTX4YeYaDItlY/8gVaSgrcseZr5l2TR6FXDgEwUvH/XxiB+Ve82K2SsK3S4zxl08sudPdA==
X-Google-Smtp-Source: ABdhPJzp/V/z98iSGPCAD6TVFlO4ZbwsqHiIoj9tVHtOmIVogU8wQqeSmKEJPPLOE02Odj0PDM2eo/nnjNc=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a17:906:8245:: with SMTP id
 f5mr743254ejx.264.1599141216147; Thu, 03 Sep 2020 06:53:36 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:53:00 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-12-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 11/18] KVM: arm64: Share context save and restore macros
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

To avoid duplicating the context save and restore macros, move them into
a shareable header.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 39 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/entry.S       | 39 --------------------------------
 2 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 6c3e3b903343..4bbde3d3989c 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -251,6 +251,45 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 	.popsection
 .endm
 
+#define CPU_XREG_OFFSET(x)	(CPU_USER_PT_REGS + 8*x)
+#define CPU_LR_OFFSET		CPU_XREG_OFFSET(30)
+#define CPU_SP_EL0_OFFSET	(CPU_LR_OFFSET + 8)
+
+/*
+ * We treat x18 as callee-saved as the host may use it as a platform
+ * register (e.g. for shadow call stack).
+ */
+.macro save_callee_saved_regs ctxt
+	str	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
+	stp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
+	stp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
+	stp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
+	stp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
+	stp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
+	stp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
+.endm
+
+.macro restore_callee_saved_regs ctxt
+	// We require \ctxt is not x18-x28
+	ldr	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
+	ldp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
+	ldp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
+	ldp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
+	ldp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
+	ldp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
+	ldp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
+.endm
+
+.macro save_sp_el0 ctxt, tmp
+	mrs	\tmp,	sp_el0
+	str	\tmp,	[\ctxt, #CPU_SP_EL0_OFFSET]
+.endm
+
+.macro restore_sp_el0 ctxt, tmp
+	ldr	\tmp,	  [\ctxt, #CPU_SP_EL0_OFFSET]
+	msr	sp_el0, \tmp
+.endm
+
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 4787fc82790c..afaa8d1f2485 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -7,7 +7,6 @@
 #include <linux/linkage.h>
 
 #include <asm/alternative.h>
-#include <asm/asm-offsets.h>
 #include <asm/assembler.h>
 #include <asm/fpsimdmacros.h>
 #include <asm/kvm.h>
@@ -16,46 +15,8 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_ptrauth.h>
 
-#define CPU_XREG_OFFSET(x)	(CPU_USER_PT_REGS + 8*x)
-#define CPU_SP_EL0_OFFSET	(CPU_XREG_OFFSET(30) + 8)
-
 	.text
 
-/*
- * We treat x18 as callee-saved as the host may use it as a platform
- * register (e.g. for shadow call stack).
- */
-.macro save_callee_saved_regs ctxt
-	str	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
-	stp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
-	stp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
-	stp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
-	stp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
-	stp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
-	stp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
-.endm
-
-.macro restore_callee_saved_regs ctxt
-	// We require \ctxt is not x18-x28
-	ldr	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
-	ldp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
-	ldp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
-	ldp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
-	ldp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
-	ldp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
-	ldp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
-.endm
-
-.macro save_sp_el0 ctxt, tmp
-	mrs	\tmp,	sp_el0
-	str	\tmp,	[\ctxt, #CPU_SP_EL0_OFFSET]
-.endm
-
-.macro restore_sp_el0 ctxt, tmp
-	ldr	\tmp,	  [\ctxt, #CPU_SP_EL0_OFFSET]
-	msr	sp_el0, \tmp
-.endm
-
 /*
  * u64 __guest_enter(struct kvm_vcpu *vcpu);
  */
-- 
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
