Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF74C433F2
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9BD3B207BB
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="EdocCqMI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BD3B207BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55A524B3D0;
	Wed, 15 Jul 2020 14:45:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XQ6D9LTPMvqw; Wed, 15 Jul 2020 14:45:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 315714B3C0;
	Wed, 15 Jul 2020 14:45:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3850F4B170
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sx92mvseJfAe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:23 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19AD64B3D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:22 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id x1so3963027ybg.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=hHJnqDO6tZwOu8efN18XUjctMX/oYEHWNmg+LgZYzVw=;
 b=EdocCqMIxlC7QxpxvM0J/lCXIN/cVt09OdJE4kn6kTzaoVAKuBTsCVK8RcfggsG/Yu
 +6kyfskCgAFjbMVRs3/bbUlYCxgY05vD+fOFyYtEx8j0g2M6F9gMrqOQXNwhSIXvIJvb
 uryfy+IpWbaio6k9sOYkwefe2z3IzRoOd+jrym3nZOZLblP7Z9M9IgcFMyeuCpF7nWRV
 rAkccGsV0d9hoGH+S+vKHReg39XeyG8SyOFmWqXENf13e1UVg/bj8owNFI1wegGJCSNk
 GTu1thIdDNjrO90lqf7r2jcDX9tarz6GCaBVPbdPrtAAOmarT2em5rlvNgn2+RUvLIVG
 ysWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=hHJnqDO6tZwOu8efN18XUjctMX/oYEHWNmg+LgZYzVw=;
 b=lGa2+NjbzueN226Me4nFBbbej62hZ42En0z+AMzeSF41snHpofIJeh+zw4TIiAiS3D
 ZH4m1uEjZVYb20dTCwRpDXCIblSnqe4hAcOGW/xFJrezVCel2vdiA8w48zE84vcNv0T9
 w7UMySdDJ/bNeuIHme1ngz9Phoiol32aL0EVYf3gDxfxo5/Ua4bszhIMn6m23WxQ/f1E
 0tQPFuNriXqxuutrIwuSNBEuop6+QJsnLAjdU4l+fTvXE89Z9FY2qzZ1/W5EaCB7sP1R
 LgD7J53OLFvvoeUs3i+yfpqQyhPRPAsKvekyd9mQcFkTWl3QtMoVsGk1v86c1qND99Sk
 D5Xw==
X-Gm-Message-State: AOAM530KxigaRvbdOu47VphmfOssz7/7ZsUwnbAgJSEW2bFJmUz4TrTh
 mhRGjX/cD+qtzbiyDX15ChEtdNEnbvtkBHryTu4CH/N9JDdkBvJ0VoXMWVRnnYV48a4Hrrz2fRd
 7tAdFHAAhfNkS+sxjmGS2kse5y1I4ASqiHxbK/3iLbCVAKSo18C00ZqmrfagnPs0xLcw/Hw==
X-Google-Smtp-Source: ABdhPJyo5brUJ+RY/S4CV291QQHPiJIVpLC6fza7NLvgCB37ByTolFKQzIpb27LV06nVZOzEYd6czWpg6uo=
X-Received: by 2002:a25:4c81:: with SMTP id z123mr491621yba.309.1594838721552; 
 Wed, 15 Jul 2020 11:45:21 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:16 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-16-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 15/37] KVM: arm64: Share some context save and restore macros
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

These macros should be used to avoid repeating the context save and
restore sequences.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_asm.h    | 39 +++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/entry.S          | 39 -----------------------------
 arch/arm64/kvm/hyp/nvhe/hyp-start.S |  2 --
 3 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ff27c18b9fd6..1b2c718fa58f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -212,6 +212,45 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 	add	\reg, \reg, #HOST_DATA_CONTEXT
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
index da349c152791..63d484059c01 100644
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
  * u64 __guest_enter(struct kvm_vcpu *vcpu,
  *		     struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-start.S b/arch/arm64/kvm/hyp/nvhe/hyp-start.S
index dd955e022963..d7744dcfd184 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-start.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-start.S
@@ -13,8 +13,6 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_ptrauth.h>
 
-#define CPU_LR_OFFSET (CPU_USER_PT_REGS + (8 * 30))
-
 /*
  * Initialize ptrauth in the hyp ctxt by populating it with the keys of the
  * host, which are the keys currently installed.
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
