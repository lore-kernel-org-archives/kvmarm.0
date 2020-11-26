Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0F7C63697
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C25E21D46
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="pbb/yCmE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C25E21D46
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 400444C013;
	Thu, 26 Nov 2020 10:55:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nfrFvkWqgcJC; Thu, 26 Nov 2020 10:55:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44A274C0BE;
	Thu, 26 Nov 2020 10:55:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52ED84BA29
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RORVZfX4fVtc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:55:05 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBF9B4C081
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:04 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id 23so2636348wrc.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=Pb+ABw8dDs4PbD0OqVCMWkPKj8CiLKPB9XpZniqrrrk=;
 b=pbb/yCmE0LnjVE/ExQ/pJl7w83OT3LzqwQppQ3HqidXv2SfAJ9Nb1cPbq9a8ZZI4YA
 X5M/PUSmd0+3fpTDL/InmQ2mCDNpr9piPAuo7p6crV0IeKBHx/ZTIZOgH/esG4VTPy2J
 vlfVzxrBEn8n6D2S5rPjeXvv6YodXNpHneVC8Nwje61zvBtJxL9jKl+VgVh2Lahc+ksZ
 iHqtiBbtPHB1T5RFyjVg6EG7jdM6DUm23grUSANYdwjKev67RJFOYVUfOzyGvHvg8snO
 dasZpwdSKPiXhpsLurhfNgNIsnFGj3Bo6vrCCFJGRdAo6Tb+BYMNEOrvmCeSdXjXLlsU
 jk1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Pb+ABw8dDs4PbD0OqVCMWkPKj8CiLKPB9XpZniqrrrk=;
 b=LnM68mCL3YIn16GbVgaX28HXb8EG9H/6SANhKQVG01L6tl3xznLwrq1Rc6xNOlxa1f
 tt3o78NFRiisPD1h+7zZO2fHenTOl3/LwZjQgIog4PabsYNOwg8+EAE0ky59QMWoazki
 nfv779XfDopqJtCdO/ijRdYmFRRAJgRgYzu2zZ0US7THi/N28TKp+y/2+QWva5SDeOjj
 Yg7WX6TAE5g9XTR8IshqKi96aSLYgUwnKT3f7RO06Jbg8jufEW87xfpjww1NdavCP1b2
 owyZYX14ZWbthYxxJA8BKobcqvqztgicIZJCcVfngPVAfagPnEraGYsxNDl2dU0k6f+4
 ImCw==
X-Gm-Message-State: AOAM531e+E8P8Kgsawk6fjLwnz4BOkkrWE9JrJP7JzOxe7/kLnLS7j4y
 IWHLfjTIp1SRZ0odvphAhTbGiMHC06dHoUzu
X-Google-Smtp-Source: ABdhPJwxY6DWeyXDaTKzR9vlEHnJK1db+CbK/rNz4u0C73SsrWbM3UVGNV4lTxhZ1MSN5bqYaJbUug==
X-Received: by 2002:adf:eb4d:: with SMTP id u13mr4757138wrn.146.1606406103382; 
 Thu, 26 Nov 2020 07:55:03 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id g25sm8706624wmk.5.2020.11.26.07.55.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:55:02 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 17/23] kvm: arm64: Extract __do_hyp_init into a helper
 function
Date: Thu, 26 Nov 2020 15:54:15 +0000
Message-Id: <20201126155421.14901-18-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126155421.14901-1-dbrazdil@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
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
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 35 ++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 77c983aa90fa..98ce40e17b42 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -68,13 +68,32 @@ __do_hyp_init:
 	mov	x0, #SMCCC_RET_NOT_SUPPORTED
 	eret
 
-1:	ldr	x0, [x1, #NVHE_INIT_TPIDR_EL2]
-	msr	tpidr_el2, x0
+1:	mov	x0, x1
+	mov	x4, lr
+	bl	___kvm_hyp_init
+	mov	lr, x4
 
-	ldr	x0, [x1, #NVHE_INIT_STACK_HYP_VA]
-	mov	sp, x0
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
+	ldr	x1, [x0, #NVHE_INIT_STACK_HYP_VA]
+	mov	sp, x1
 
-	ldr	x1, [x1, #NVHE_INIT_PGD_PA]
+	ldr	x1, [x0, #NVHE_INIT_PGD_PA]
 	phys_to_ttbr x0, x1
 alternative_if ARM64_HAS_CNP
 	orr	x0, x0, #TTBR_CNP_BIT
@@ -139,10 +158,8 @@ alternative_else_nop_endif
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
