Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F57C433E2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD00E21D24
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="oo/JRdUQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD00E21D24
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 590F14B311;
	Tue, 15 Sep 2020 06:47:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YqWoMHjwujVN; Tue, 15 Sep 2020 06:47:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DECC4B333;
	Tue, 15 Sep 2020 06:47:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67DBD4B370
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZyV8pEpm-cGG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:47:14 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A3074B319
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:14 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id k13so1084807wrl.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=+LtBprNCQxqpSJhy1doh+zbhGd6VfOx/lpcq323EYcc=;
 b=oo/JRdUQkyDpmgBCHx0d7D3wtegJE7rUo5QUquMx1wCi1PVPbHkD3mfR44JSWG4HNh
 jOsZ1SSv8ojkI0Gfy3Xz66+n9ykUUDNO9/9//KESM+vEGkbnFdM7GOVBTuRQfJcvoqAJ
 YCq3T4aaWBrKbS9d8kZs3jDcYY8NyOMTbmBCAzNZxzMPIHbtNwEAD3w8aJPWPRfuvCEf
 EmqGdUYK3Y78vNzcmI8zcy/2OvPhzzoqeWOEYHrBYWcn5xRSA8+zYxTLyKMgCRCIGEJY
 ZRkVHKd/lp+Sk+w3CsSESmJ/w7vFJR3TJlg+xRrcAHNGPLx9NrK79b55DomlOlj5HJf8
 wc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+LtBprNCQxqpSJhy1doh+zbhGd6VfOx/lpcq323EYcc=;
 b=g/VZy1A9XTLzJvg89V4yJU+JC+Pw8AqROhIR8IVAPawj3rOufvUB/aZljlVEkq1lUm
 Ys0lTCpHFjyLkmnWatULzobDNt1ko6dAxNtSTr1hRhfvI++UBGsNvqpbHVtGjeUGpfn4
 U8Vh1rAJIXG/3SydL8KCwKzi5CQPzx5b2kK4xO9vhF7lw0FYste3swHIKoHevGdJWMXj
 5maVZ/qIOHHDGveEJllyMSfw2EAt1tL/fWAoMIZ25ekcamg2ncV3NBCJj6pdA5T3Dkzb
 OLOZzKZUj1xfUk7R4qdX2MjiTx1CI/q/tfX3+M6KPylHgvFFO4eLfYDvf8vS932aN0Py
 XrCQ==
X-Gm-Message-State: AOAM531iOubJBlAwiUUFp2NjAHOgdft64c/9SY9kHA0f3JU6fVkpNv7A
 wdsO1SLmnmZZaRF7ko9HGK6e1X2r/JrNfJSQ5q9xRIWTJmYWPxzL1qlmgjDm/N6VPS0ihkdcDZx
 UA/C05ey/po9NIB49fSzm8t/u7qz9lU1HRHJBXJ7xP5vhfEHqNZfO/wMRDpqQ6DMvMlupKg==
X-Google-Smtp-Source: ABdhPJwYBdb0ujS8zbAOTvrBnJXmJUZ8yyBlY5iHeIXvhuXdm7xLBm5SGoG8EDLrrWnFy7SHtK2LW1Oijq4=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:adf:e843:: with SMTP id
 d3mr20320412wrn.290.1600166833278; 
 Tue, 15 Sep 2020 03:47:13 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:35 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-12-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 11/19] KVM: arm64: Share context save and restore macros
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
index 4df2bd8882bc..4e3073858346 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -261,6 +261,45 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
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
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
