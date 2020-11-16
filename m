Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC37C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05B382224F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="XxYQjjbQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05B382224F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADB274C290;
	Mon, 16 Nov 2020 15:44:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2KeuMT+af9eH; Mon, 16 Nov 2020 15:44:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FE674C280;
	Mon, 16 Nov 2020 15:44:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71C0F4B87F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S5TdrfQm7SNJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:43:58 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 604754B87E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:58 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id p19so662399wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=hQXzDl51KVgbTar8bkfG4D68l5PW6Ptu4C4orihp8eA=;
 b=XxYQjjbQleEihGMa6lBSPLJbnrgLF3MhlG+Qu+TFdEYUkdmG7GgeK76GDetwpVPHY+
 0Wmobxvoo+IcbO5006lnCYMaHKA3+o7cg07Lpw5pUAz79/GiwHnt2YetgapOC++rPmOS
 Ii7mnl9pyeKqz+lDTJCt7JESqOZ2YfL/nSXFqu+xsw7L6Sm3Emeub2G1TELu8hoJmc5B
 2Dwoq3u3cN7OEuCDg7M1/0dYmxeDQgDTPE8yFgyMNBO2bme3lxShcx91uRWRDP0+fpVe
 //VCXI5sWgiT7bRrGjtKa6911fco03WZ3KylE68B5I0VC1px0rU6dKBFWCgbIujqtOUf
 UUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=hQXzDl51KVgbTar8bkfG4D68l5PW6Ptu4C4orihp8eA=;
 b=F9djQ+PsNi0Ticm3iCCqMEAfSak7b6q6AA0pLJ7TVlaGTM0DLqy16/DUF37b6empG3
 jJPoKuKoDibvmH+fLL7HmkGcp+EssnnH4EiCdNDs/A4sQHSifhBf9hqjzdapmbbXSqE4
 VmOOHlF0Hj9kIhW5/KYAEvPrPjo0iuuigx4eIwm/8nHtwHfzS6h1gnmreOgqkQnUPOeG
 SfbIBJo8wYsqPmCQ/ZAaM+mQp5XvGVcnxySDPmzvzkWI6iug4qTN8tKRszJk5twVs9H+
 rbgxcxdV20qc7j2tyVKE+Qz41GfR1ZNyn5Ktq0e8D28P+2k5HnzJirio4JMaHLkqhGhz
 fZzA==
X-Gm-Message-State: AOAM5332PbmWn8kBViMhrGkDGWSMTWddPSqXSqE3xF/tywHUyY29L/wW
 OCdORgf8bUhyOeovOc+IG6KAO0eXK+AA+lBPZo8=
X-Google-Smtp-Source: ABdhPJxTuT2kvs6GtAew3CuJwBuPd4l6HxRhRGRHy6MpC962TpnwI8AZ7XOYLkPXnutxFIpVOB44Fg==
X-Received: by 2002:a1c:bac1:: with SMTP id k184mr713025wmf.76.1605559437094; 
 Mon, 16 Nov 2020 12:43:57 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id t11sm18002272wrm.8.2020.11.16.12.43.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:56 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 16/24] kvm: arm64: Extract __do_hyp_init into a helper
 function
Date: Mon, 16 Nov 2020 20:43:10 +0000
Message-Id: <20201116204318.63987-17-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116204318.63987-1-dbrazdil@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
index 67342cc9930f..d4a71ac34254 100644
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
 
-	ldr	x0, [x1, #NVHE_INIT_VECTOR_HYP_VA]
-	msr	vbar_el2, x0
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
+SYM_CODE_START(___kvm_hyp_init)
+	ldr	x1, [x0, #NVHE_INIT_TPIDR_EL2]
+	msr	tpidr_el2, x1
+
+	ldr	x1, [x0, #NVHE_INIT_VECTOR_HYP_VA]
+	msr	vbar_el2, x1
 
-	ldr	x0, [x1, #NVHE_INIT_STACK_HYP_VA]
-	mov	sp, x0
+	ldr	x1, [x0, #NVHE_INIT_STACK_HYP_VA]
+	mov	sp, x1
 
-	ldr	x1, [x1, #NVHE_INIT_PGD_PA]
+	ldr	x1, [x0, #NVHE_INIT_PGD_PA]
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
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
