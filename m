Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDA0C63798
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB5522075E
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="C7k/+8DY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB5522075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B9CA4B712;
	Wed,  4 Nov 2020 13:37:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gl6acPN6fotL; Wed,  4 Nov 2020 13:37:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 650324B7F7;
	Wed,  4 Nov 2020 13:37:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA02A4B7B7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id obXFrTvkIhqG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:20 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F001F4B7B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:19 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id k10so21833622wrw.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=lntpB9k/GNt3DHKTS6XU+Lzi+3feR2/TDoLFam5OEsI=;
 b=C7k/+8DYRMsN5av0hh1p2auJO+TujqPhkBo9BQOirCYTD1fGH4MKjmZ90c5bMU7Dvs
 7iXLOCA5XTk7X+s6+G/FADEg1vlFiJNnSKQpNHFzsfJuI/egt0VB2R4bGqay6pSEtMzV
 mugN96IDPyJUl9J8nZJmCNxxPlcS7q0g1lFjISxMbqwVf9hoORqeGPgKxbvioXh+Gz1z
 LKEVEAz2BDBUn3fCSiGXaFJKOrRpL0Tc+GLucbHuJ/FMZdaIvRy4x7frQIOcGnejA6Lw
 PAlCYBfM7fvOkTtGmNbT8j+d/lf3B55XUIwrtUiNVEb55mNzk9xPRhDXqT+vgc88HxfL
 Zb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=lntpB9k/GNt3DHKTS6XU+Lzi+3feR2/TDoLFam5OEsI=;
 b=lIR0WsgkTv6eWMCXMSCQbIEJEP/l4KNACLiQR6hyRCDvfYjnmsVmJX1a7pVlyf8x34
 EdT8XrfmAQ+2pFZAgUDSSejBLePrjQGjdBC5AbrjjP39o4Xn9TvZ6y16CcEr0w1vyXDR
 GHPIxSz7xKpA1Fs6D8oBcN0YCaQjEqWkhGwlkitgJfYzrhWqnTVys67mWiyg90hQgk7O
 RSTvDzN6JViqkszDet6q5B5+SCOJraFwD4RvdHIs7TurPEZMTJxf84RPhLGkXqaGWvst
 uuzAr39izScFlvnqEzLUOgZLSw//v61Hu5gUOjKLzpUkBixBz9DkSAsMNxq+mc1u1njG
 x9bg==
X-Gm-Message-State: AOAM532E5pXW8JAgnNovIR8fYvJk1jX0tniJqU+MI+AOaGWDpmUv2BoI
 EgwPPaJUXfNV6rQHPkENU0T7w0GxXJoPdqGK
X-Google-Smtp-Source: ABdhPJzp3ZjoC9LnEvi+UKHAL909ZKm0IHo36bHGz5PnMfBxU0GoHEvnmkwHDRi5tS6FA8eyTXdSfQ==
X-Received: by 2002:adf:f104:: with SMTP id r4mr33995916wro.202.1604515038644; 
 Wed, 04 Nov 2020 10:37:18 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id r1sm3905404wro.18.2020.11.04.10.37.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:17 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 19/26] kvm: arm64: Extract __do_hyp_init into a helper
 function
Date: Wed,  4 Nov 2020 18:36:23 +0000
Message-Id: <20201104183630.27513-20-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

In preparation for adding a CPU entry point in nVHE hyp code, extract
most of __do_hyp_init hypervisor initialization code into a common
helper function. This will be invoked by the entry point to install KVM
on the newly booted CPU.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 39 +++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 6f3ac5d428ec..1726cc44b3ee 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -68,16 +68,35 @@ __do_hyp_init:
 	mov	x0, #SMCCC_RET_NOT_SUPPORTED
 	eret
 
-1:	ldr	x0, [x1, #NVHE_INIT_TPIDR_EL2]
-	msr	tpidr_el2, x0
+1:	mov	x0, x1
+	mov	x4, lr
+	bl	___kvm_hyp_init
+	mov	lr, x4
 
-	ldr	x0, [x1, #NVHE_INIT_STACK_PTR]
-	mov	sp, x0
+	/* Hello, World! */
+	mov	x0, #SMCCC_RET_SUCCESS
+	eret
+SYM_CODE_END(__kvm_hyp_init)
+
+/*
+ * Initialize the hypervisor in EL2.
+ *
+ * Only modifies x0..x3 so as to not clobber callee-saved SMCCC registers
+ * and leave x4 for the caller.
+ *
+ * x0: struct kvm_nvhe_init_params PA
+ */
+SYM_CODE_START(___kvm_hyp_init)
+	ldr	x1, [x0, #NVHE_INIT_TPIDR_EL2]
+	msr	tpidr_el2, x1
+
+	ldr	x1, [x0, #NVHE_INIT_STACK_PTR]
+	mov	sp, x1
 
-	ldr	x0, [x1, #NVHE_INIT_VECTOR_PTR]
-	msr	vbar_el2, x0
+	ldr	x1, [x0, #NVHE_INIT_VECTOR_PTR]
+	msr	vbar_el2, x1
 
-	ldr	x1, [x1, #NVHE_INIT_PGD_PTR]
+	ldr	x1, [x0, #NVHE_INIT_PGD_PTR]
 	phys_to_ttbr x0, x1
 alternative_if ARM64_HAS_CNP
 	orr	x0, x0, #TTBR_CNP_BIT
@@ -137,10 +156,8 @@ alternative_else_nop_endif
 	msr	sctlr_el2, x0
 	isb
 
-	/* Hello, World! */
-	mov	x0, #SMCCC_RET_SUCCESS
-	eret
-SYM_CODE_END(__kvm_hyp_init)
+	ret
+SYM_CODE_END(___kvm_hyp_init)
 
 SYM_CODE_START(__kvm_handle_stub_hvc)
 	cmp	x0, #HVC_SOFT_RESTART
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
