Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E86C71155
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 273DE21D7F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 273DE21D7F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4E484B42A;
	Wed,  2 Dec 2020 13:42:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g59YTUyxf7cw; Wed,  2 Dec 2020 13:42:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04A434B38F;
	Wed,  2 Dec 2020 13:42:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C79F44B43A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J-SABOC4nfd2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:42:11 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77B2D4B452
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:11 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id k10so10125165wmi.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=C6am4hqHGk+Vo0ud1IP29/X2lpqX4cUlMBiGKiun4f8=;
 b=hoQt5BzIWgY7qXX3fYCd3gye89dvXes5OcxZR1oaFHiJQ0uNuctf0EfXcXsXQqJZHi
 lyMsVJArQ0COsJ3V461k6nveoLNzCLiKZbAL5LUSG4DkZ0mZ4TD+7GR+bvNwn6Oztk+b
 junmL8dzKUi31Dphr3YG92zBLKleqoCJLPlvFxbGeHyYhHq5d6poYXr1fCeGHotQtBSR
 HE+mkv/OIjfKLvHevZZVRrqv3+kaP8yMimI6sQpItNZb7BDN+1luqcdtgtiTsgiqIFoE
 bB/s2tgV4B1tzXzOp8LoYqmDeZbINdCG9fd4QhlOCkBE+gk5X9QdHlI8qQkX3t6UKEwH
 0a9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=C6am4hqHGk+Vo0ud1IP29/X2lpqX4cUlMBiGKiun4f8=;
 b=KPhMbUx0M37/j286LwINhB+X6gzBoCj9JGQWKpcD0b81X+vO38jKgQHb/173PjqxCa
 gtn6t/1Ha4/CoDu/3ZybjFqAdmlxmdNs8Oe+T4xSztvWxTFyhiJLh4RUyLbbUBRRnGS8
 VutR+ac8lxOU03n7NcWYVL1L+mhElYyOqS/yqahBurw6b2omnHxK36XWerD8vPIc88h4
 NMI7ZEcxUoQwxOO9aGY88a93Lb5Lyd4JETrFsmo3d8OXAxfQ9xc+yYW6MlDb4M/aJs2W
 jObjT4uj4G5P4wiDPAdbllH8yEwp++L00vLL46i7O3miH8G6PH8Z/rjIp/RdHtgub91L
 1YiA==
X-Gm-Message-State: AOAM531gmAs+PPlHOZ5JjE05isSfsSZjyEqKNixGC8uPxVK6EHkqCC//
 kSibyBOvltqMuqRO2bydkC3DMVIZFHpX/Q==
X-Google-Smtp-Source: ABdhPJzQrJ/LWyt16hrvnyOSjGz1ckoWGV76pEesTOfeJNYR/dIM8PSyGIBinNhf3COj/w3pWBottw==
X-Received: by 2002:a7b:ce17:: with SMTP id m23mr4554470wmc.117.1606934530064; 
 Wed, 02 Dec 2020 10:42:10 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id y20sm3136706wma.15.2020.12.02.10.42.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:42:08 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 19/26] kvm: arm64: Extract __do_hyp_init into a helper
 function
Date: Wed,  2 Dec 2020 18:41:15 +0000
Message-Id: <20201202184122.26046-20-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202184122.26046-1-dbrazdil@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
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
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 47 ++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 712f57289357..b0856b006bc0 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -68,17 +68,36 @@ __do_hyp_init:
 	mov	x0, #SMCCC_RET_NOT_SUPPORTED
 	eret
 
-1:	ldr	x0, [x1, #NVHE_INIT_TPIDR_EL2]
-	msr	tpidr_el2, x0
+1:	mov	x0, x1
+	mov	x4, lr
+	bl	___kvm_hyp_init
+	mov	lr, x4
 
-	ldr	x0, [x1, #NVHE_INIT_MAIR_EL2]
-	msr	mair_el2, x0
+	/* Hello, World! */
+	mov	x0, #SMCCC_RET_SUCCESS
+	eret
+SYM_CODE_END(__kvm_hyp_init)
+
+/*
+ * Initialize the hypervisor in EL2.
+ *
+ * Only uses x0..x3 so as to not clobber callee-saved SMCCC registers
+ * and leave x4 for the caller.
+ *
+ * x0: struct kvm_nvhe_init_params PA
+ */
+SYM_CODE_START_LOCAL(___kvm_hyp_init)
+	ldr	x1, [x0, #NVHE_INIT_TPIDR_EL2]
+	msr	tpidr_el2, x1
+
+	ldr	x1, [x0, #NVHE_INIT_STACK_HYP_VA]
+	mov	sp, x1
 
-	ldr	x0, [x1, #NVHE_INIT_STACK_HYP_VA]
-	mov	sp, x0
+	ldr	x1, [x0, #NVHE_INIT_MAIR_EL2]
+	msr	mair_el2, x1
 
-	ldr	x0, [x1, #NVHE_INIT_PGD_PA]
-	phys_to_ttbr x2, x0
+	ldr	x1, [x0, #NVHE_INIT_PGD_PA]
+	phys_to_ttbr x2, x1
 alternative_if ARM64_HAS_CNP
 	orr	x2, x2, #TTBR_CNP_BIT
 alternative_else_nop_endif
@@ -87,9 +106,9 @@ alternative_else_nop_endif
 	/*
 	 * Set the PS bits in TCR_EL2.
 	 */
-	ldr	x0, [x1, #NVHE_INIT_TCR_EL2]
-	tcr_compute_pa_size x0, #TCR_EL2_PS_SHIFT, x1, x2
-	msr	tcr_el2, x0
+	ldr	x1, [x0, #NVHE_INIT_TCR_EL2]
+	tcr_compute_pa_size x1, #TCR_EL2_PS_SHIFT, x2, x3
+	msr	tcr_el2, x1
 
 	isb
 
@@ -117,10 +136,8 @@ alternative_else_nop_endif
 	kimg_hyp_va x0, x1
 	msr	vbar_el2, x0
 
-	/* Hello, World! */
-	mov	x0, #SMCCC_RET_SUCCESS
-	eret
-SYM_CODE_END(__kvm_hyp_init)
+	ret
+SYM_CODE_END(___kvm_hyp_init)
 
 SYM_CODE_START(__kvm_handle_stub_hvc)
 	cmp	x0, #HVC_SOFT_RESTART
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
