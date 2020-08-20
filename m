Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3EAC433DF
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3350520639
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ZQ6+vTLF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3350520639
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1A014B86A;
	Thu, 20 Aug 2020 06:35:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rjPNZRTHBybe; Thu, 20 Aug 2020 06:35:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFA3C4B86C;
	Thu, 20 Aug 2020 06:35:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5CAB4B81A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5aAlRjbLDvFa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:47 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BDB54B7C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:47 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id f7so507196wrs.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=0udsbz2N+HsyocyrF2gNSxRsywyf2sCKDogEB4hsysU=;
 b=ZQ6+vTLFVszytvx05y3izoKAMdz1kZc/rmVKOVtVXBdbf8huOMSEq5/b/Ld4Fn08P4
 pWLgr7jbigEjoqSQi51lo7vqYmfBGgG6jruVbnZuY64EcUez7+Et2Rt1QqpsWS8K2rId
 myBOmEi2fq04PY5tIFEXU2zka97hfAOFvjgUvclsRMXs+KZy58C5xW1w8JYQr9mkJKKG
 rggID0PpzqENEe1LpRzZWJKdxgTv2wsU91kC8nEPBYGGpEiqDR0anOQQQ3NBOSos/EUi
 iY+Q7GSHcv9JrmALq+Xx8iFXfH9DgAINOK7zOky8kBOxwbU5Ysaehr+QN6SutQRRHr9Y
 wcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0udsbz2N+HsyocyrF2gNSxRsywyf2sCKDogEB4hsysU=;
 b=hkVSFhxX1N5PsKHETbbywTTff/PYiLqeKufRkWIi4qOgDrHgkNjjL2vzWvK2ujWris
 2/8LEHEVnMQULJDJ0pMacRX/pQ2T3DW4RN2+oGsohqLNKAtbseg4RzYz/mbDhKZ64ntO
 iM1op+a4sjCwhry3K6fySEThsXG9yIEgJ0YVJQDK1SgXKaYzw056wsw1wAj3ruLGId73
 SzIaCmlvnK3/u6sOJOoWyGmiFhe7jPSz+Ij08f6ToiMqysRwWivMtRGSoAiq0GmjiDd/
 6Y3cAr6UEc+kA3pG9/4MwTOVA6ug02YCnOQjwMlqFx6jRDSjwSlh6nNteKXQiPy+Lbwk
 Znyw==
X-Gm-Message-State: AOAM530kpQd7bxCDmqag8ZF3IvS5waOoFpt2D+Sd/8QVVtS3ZV3s7yLV
 B05sJ7H4t/oBq8DZieQlmaeENxPNXxIKW6kcqx6yPJgIlHI1mjzrNQf+WHd+sP/wMo4uBoEgLxP
 WU0YEXRWbExLk9sAqB3HwyOYJr7Bpoe/NDTuNgD5kzELK9UuyOc7N/sUlCuKuWtHX8ATTQA==
X-Google-Smtp-Source: ABdhPJzxrGBPHJAd8wP9yqw5PlOq2ycRCS7nqv5kujd00fKJ6Ds22R+N1j+mm9gX9+nAfgZrtwliuPr2G8I=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a7b:c205:: with SMTP id
 x5mr3027021wmi.161.1597919746685; 
 Thu, 20 Aug 2020 03:35:46 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:38 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-13-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 12/20] KVM: arm64: Share context save and restore macros
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
index 106279a6d027..358262d4546e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -208,6 +208,45 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 	str	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
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
index 872ac89ffc1e..204130db62ee 100644
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
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
