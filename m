Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7A3C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 14:54:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 70613208CA
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 14:54:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70613208CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24E3A4B5E3;
	Mon, 25 Jan 2021 09:54:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PojyUF25u0+7; Mon, 25 Jan 2021 09:54:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DB3D4B5EB;
	Mon, 25 Jan 2021 09:54:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEB184B5EA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 09:54:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mNN-ZMtFOJLF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 09:54:43 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A7424B5EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 09:54:42 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id u3so8613268wri.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 06:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=KH8lqwPuHNlw7A6L2DAisCYLzYH4OHEVTZnxXtCLmTA=;
 b=OyEOvkU1NH7EHldVnULU7tuR2uWSeXPhQZrkMTeus7FpbDmkrUaQnnFsWGbfAfmCr8
 HcLkQ0D049KkRoJEeW3NC+gBkFi2rYzNcyjpaAte5YEdCTH/EA2JsI9efqmop3RE414B
 megzc69EMxddfHw+VW599ofLrEKVRUV0jPqOkO2FrI1aCrIq5EFPxVuMQjUlrPkr/GKK
 OeohCEzjDHyRkpTd1K9GZb5ESSPdA2Utc4HCYtrY4wkrPmAYWmhad3zW/ID5OrfNXRGW
 9bjKtKkDpOk05O9mrkDjKqVD7P7hQ8I/7ypRTowvbGiNLU7hH2JfPP+T8pTSwG9PlC07
 twGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KH8lqwPuHNlw7A6L2DAisCYLzYH4OHEVTZnxXtCLmTA=;
 b=o/V6E40safeKf7pT13gJoXdD027PX+LxyI+2KOxqb4bUP0jltLKDLU/+ugORIyv836
 Vg8IB7JUbbeHdiIOFdI2spDqQg6quztOrCCFSPASmQXzoDa1S+V6krruDWU5kadENDpV
 sqOoJZJYnG7MLb9KxWaxSjaNSfTnP/viugyaNz/R0SuQqzSbSpGH6ZJEyBjL2c1K23Jh
 wXUkHAvWWqMcfjqGo/a1S5Yyc8JNjnHWJ849j8I4z54TSskKGMHbxUUHYuwmOhNS2ev9
 gOaIS6caw1iURRNdtAuKok5bF5rRSdXPMNH5qSzPdP4tiZj8RmPVXel8hWIp9WqTAyoj
 vPCw==
X-Gm-Message-State: AOAM530Rwk/0650j3bzx4o2VXQDYwHH6YFznl3UUHhctBThhq527wCle
 mztaIGYjxvH35uhFQmOPRzz9F3IvHMp+crosQb+oEzvmvScfRlLFe45H29/qILL2mICE0ypQ267
 B2q0m/RlcRd9h7gHqeKqBge4VFWXQng1Lu9XFvA7fctUGOHwC1J+w/TsA3g2FhG4RUFcQLA==
X-Google-Smtp-Source: ABdhPJwSZVCGycmKEh3Bf1fF4dh7h7ba8mjj8pFtCBs54/3JvqoDkQCZO2kL5NSyXN/Ggychd6aCQVdE+qw=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a1c:9c84:: with SMTP id
 f126mr505714wme.152.1611586480765; 
 Mon, 25 Jan 2021 06:54:40 -0800 (PST)
Date: Mon, 25 Jan 2021 14:54:15 +0000
In-Reply-To: <20210125145415.122439-1-ascull@google.com>
Message-Id: <20210125145415.122439-3-ascull@google.com>
Mime-Version: 1.0
References: <20210125145415.122439-1-ascull@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH 2/2] KVM: arm64: Don't clobber x4 in __do_hyp_init
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu, kernel-team@android.com
Cc: maz@kernel.org
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

arm_smccc_1_1_hvc() only adds write contraints for x0-3 in the inline
assembly for the HVC instruction so make sure those are the only
registers that change when __do_hyp_init is called.

Tested-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index b3915ccb23b0..3df583ad12af 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -47,6 +47,8 @@ __invalid:
 	b	.
 
 	/*
+	 * Only uses x0..x3 so as to not clobber callee-saved SMCCC registers.
+	 *
 	 * x0: SMCCC function ID
 	 * x1: struct kvm_nvhe_init_params PA
 	 */
@@ -63,9 +65,9 @@ __do_hyp_init:
 	eret
 
 1:	mov	x0, x1
-	mov	x4, lr
-	bl	___kvm_hyp_init
-	mov	lr, x4
+	mov	x3, lr
+	bl	___kvm_hyp_init			// Clobbers x0..x2
+	mov	lr, x3
 
 	/* Hello, World! */
 	mov	x0, #SMCCC_RET_SUCCESS
@@ -75,8 +77,8 @@ SYM_CODE_END(__kvm_hyp_init)
 /*
  * Initialize the hypervisor in EL2.
  *
- * Only uses x0..x3 so as to not clobber callee-saved SMCCC registers
- * and leave x4 for the caller.
+ * Only uses x0..x2 so as to not clobber callee-saved SMCCC registers
+ * and leave x3 for the caller.
  *
  * x0: struct kvm_nvhe_init_params PA
  */
@@ -105,9 +107,9 @@ alternative_else_nop_endif
 	/*
 	 * Set the PS bits in TCR_EL2.
 	 */
-	ldr	x1, [x0, #NVHE_INIT_TCR_EL2]
-	tcr_compute_pa_size x1, #TCR_EL2_PS_SHIFT, x2, x3
-	msr	tcr_el2, x1
+	ldr	x0, [x0, #NVHE_INIT_TCR_EL2]
+	tcr_compute_pa_size x0, #TCR_EL2_PS_SHIFT, x1, x2
+	msr	tcr_el2, x0
 
 	isb
 
@@ -186,7 +188,7 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
 
 	/* Enable MMU, set vectors and stack. */
 	mov	x0, x28
-	bl	___kvm_hyp_init			// Clobbers x0..x3
+	bl	___kvm_hyp_init			// Clobbers x0..x2
 
 	/* Leave idmap. */
 	mov	x0, x29
-- 
2.30.0.280.ga3ce27912f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
