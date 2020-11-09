Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F090C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 775AC21D40
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="VscquQxn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 775AC21D40
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 142C44B4DF;
	Mon,  9 Nov 2020 06:33:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id phTPZ06EJKqo; Mon,  9 Nov 2020 06:33:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CA064B615;
	Mon,  9 Nov 2020 06:33:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D424A4B772
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y--Lbct-UpXu for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:05 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDD054B86C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:05 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id c9so7650016wml.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=YdG01yv5L5aUOCAWsL0c1AI2VybNbkzT+FglMLEKPUc=;
 b=VscquQxnoFwls/oqHCEPpTF7SsklW2SmI3fLE1F5tN+dxJgy3126pQhYRhyWkGvJIp
 KRmeP24h8deaDxwtzjlMieLgmBUlFsjhUi2pn0JMhw4TjUrc/7yP3r+3yL0UJpi61Vyd
 hG1vant3CV08pg/Sz0fn+TUu3AYvp0ZsSrk0b5+H/QLxcLfAZsX3iI/aGB3XEbW0tpDa
 /1+EhkRGYmrcDHK6NRYGxx9rztUPZiXN/BvdGNLPpnekFtzi9eAtwHElENEJD3a07VHU
 ospDdFOtyypJeJSVppNpzOmBV1BYsT7xmGdDkoNgLrrtu3ByjGzeJulL64nvB0vqtcBG
 OXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=YdG01yv5L5aUOCAWsL0c1AI2VybNbkzT+FglMLEKPUc=;
 b=JPGHytqoqbaFsMe13EjT2FNMR/cSqFI5ow9UP1QFipBdH6sjO8UHqYT7NFWQK3otUG
 GDndpJwCXRBruB8ExZBL7u89HyAb8RtpXvN0Y+yF9v4ZiRIEOn9gWGhq5ioxhk5PCOvu
 v1nTKj/iMmNQSexBIFwTThOMZkWBcvp0GEk5S/hz0zSWW9zIoyPt8UqUC4T1NTDiDnv4
 XuvSgTUyit7zDEnDeCwBS/PY5ZCrpU8ZTEeS+29zTedXjQcWbenEPlnpsMQFBevlkHYN
 2DFGunDxk6ZFSAx3iXGr/0ciJQSFZnOrXopHCBWIHE5g6es3c7m6JXdiCmIg41JyzwEV
 9pCA==
X-Gm-Message-State: AOAM530Qc1Egulo7NeilqBw6qKSqKH0sNKipHH3k5WaPhLLXWo8c2oUu
 Wv5X0kL2+KN6ZF8ELzdN+y365yuTjuZz7ne4
X-Google-Smtp-Source: ABdhPJzK69A1Q7likl7qMwl1Im0ltc4/Nfe7H1rxArIqrin2R1yRgaBVm6eGs7AcogdA8AWyKibl5A==
X-Received: by 2002:a1c:e345:: with SMTP id a66mr13968140wmh.188.1604921584566; 
 Mon, 09 Nov 2020 03:33:04 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id d2sm12884700wrq.34.2020.11.09.03.33.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:03 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 12/24] kvm: arm64: Extract __do_hyp_init into a helper
 function
Date: Mon,  9 Nov 2020 11:32:21 +0000
Message-Id: <20201109113233.9012-13-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
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
index 6f3ac5d428ec..1697d25756e9 100644
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
+ * Only uses x0..x3 so as to not clobber callee-saved SMCCC registers
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
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
