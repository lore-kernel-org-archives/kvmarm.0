Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10CDC56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 28461221EB
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="qZUzcyIm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28461221EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C66704BCEF;
	Thu, 26 Nov 2020 10:54:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NAz7C9mgvDws; Thu, 26 Nov 2020 10:54:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF8B04C0B2;
	Thu, 26 Nov 2020 10:54:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 033994C088
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zjdDthu4rdXL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:54:56 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D35104C066
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:55 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id i2so2642165wrs.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=oagbJM5Ax/HFickgEo8A1TkVP1JuhAjLvznvg3GZEXE=;
 b=qZUzcyImvGBn0yrIjOeE6dvV8TTcOgLZ9npbYQvvt7NZJZCYO36QukjaKQ65C91yOa
 s6tgkRFbVNUlbAQyM/7pZ4EJB2V1rzieMnwHNy9Z3C8bHxhWy5lulXiAWX4nIFRcgwnZ
 8JDUw1NkODEBzf/2+Sl5ZC+NtbVdmIe1Xa1R1EWCiKT9iNFd+bW9iMhp7tUNrPDdcfEm
 IcFm9PjetQN+jfEzQ/p6X99K1DbXM6md/Mno9gTBZRSKaaY4v5CUq9wI3TH+kvyuGbDF
 NQq4JQ7SE57CJdE5n7JT8TupuWKDm/pQEnVdnWQ7o+BP0HzGpEcUNS9YN0Si+lO2uRD8
 Xhlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=oagbJM5Ax/HFickgEo8A1TkVP1JuhAjLvznvg3GZEXE=;
 b=N0IoysLBYr4L5eoB4nIrthYwCtApOnRyq8x4ScnkLBknzhMPEvhN9X60JTmnRgNnN/
 NpZHqa6Bdjb7imxYw0vJBNEYBHBM6FwrWmpjWWXKqpste4DZTYBBrGDyZ2GgX6q34qaw
 be+am52Ja3vi11RPOfcvdGx1Qey4igwVrACwe+ktzQbnRmQTH0n4NbUPb2hYb1HIJrJf
 am9Ix/CAuovu+Oc8xPLNMmVlvcbYef2CesYa++KJoLLZE5l0RGIx3/xF/dkw5wmqrh7S
 kG1XEPHs7wJC49czlk88S60ozamyFZag+pEGLhq+fzYMvc+nOUcRq1PaNdhTsrXv4Mdt
 PNQw==
X-Gm-Message-State: AOAM531SwOHqJNez7VfkR5OR7EUJXd/DtR/KJxrs1DDJqLDBLGBoagKZ
 7jcZBzWqGpw5GsL/6G2tIxvjRWca8kieO3cI
X-Google-Smtp-Source: ABdhPJzN6596YemtZxOQnXDEasriPsfnG62j/YEP9/S71/zP7vvdUkweGbmtUDi3GsZaFW91d4W0tQ==
X-Received: by 2002:adf:f882:: with SMTP id u2mr4653371wrp.271.1606406094562; 
 Thu, 26 Nov 2020 07:54:54 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id o203sm2654638wmb.0.2020.11.26.07.54.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:54:53 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 13/23] kvm: arm64: Add SMC handler in nVHE EL2
Date: Thu, 26 Nov 2020 15:54:11 +0000
Message-Id: <20201126155421.14901-14-dbrazdil@google.com>
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

Add handler of host SMCs in KVM nVHE trap handler. Forward all SMCs to
EL3 and propagate the result back to EL1. This is done in preparation
for validating host SMCs in KVM nVHE protected mode.

The implementation assumes that firmware uses SMCCC v1.2 or older. That
means x0-x17 can be used both for arguments and results, other GPRs are
preserved.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S     | 38 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 35 ++++++++++++++++++++++++---
 2 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index fe2740b224cf..2b56f0bdf874 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -180,3 +180,41 @@ SYM_CODE_START(__kvm_hyp_host_vector)
 	invalid_host_el1_vect			// FIQ 32-bit EL1
 	invalid_host_el1_vect			// Error 32-bit EL1
 SYM_CODE_END(__kvm_hyp_host_vector)
+
+/*
+ * Forward SMC with arguments in struct kvm_cpu_context, and
+ * store the result into the same struct. Assumes SMCCC 1.2 or older.
+ *
+ * x0: struct kvm_cpu_context*
+ */
+SYM_CODE_START(__kvm_hyp_host_forward_smc)
+	/*
+	 * Use x18 to keep the pointer to the host context because
+	 * x18 is callee-saved in SMCCC but not in AAPCS64.
+	 */
+	mov	x18, x0
+
+	ldp	x0, x1,   [x18, #CPU_XREG_OFFSET(0)]
+	ldp	x2, x3,   [x18, #CPU_XREG_OFFSET(2)]
+	ldp	x4, x5,   [x18, #CPU_XREG_OFFSET(4)]
+	ldp	x6, x7,   [x18, #CPU_XREG_OFFSET(6)]
+	ldp	x8, x9,   [x18, #CPU_XREG_OFFSET(8)]
+	ldp	x10, x11, [x18, #CPU_XREG_OFFSET(10)]
+	ldp	x12, x13, [x18, #CPU_XREG_OFFSET(12)]
+	ldp	x14, x15, [x18, #CPU_XREG_OFFSET(14)]
+	ldp	x16, x17, [x18, #CPU_XREG_OFFSET(16)]
+
+	smc	#0
+
+	stp	x0, x1,   [x18, #CPU_XREG_OFFSET(0)]
+	stp	x2, x3,   [x18, #CPU_XREG_OFFSET(2)]
+	stp	x4, x5,   [x18, #CPU_XREG_OFFSET(4)]
+	stp	x6, x7,   [x18, #CPU_XREG_OFFSET(6)]
+	stp	x8, x9,   [x18, #CPU_XREG_OFFSET(8)]
+	stp	x10, x11, [x18, #CPU_XREG_OFFSET(10)]
+	stp	x12, x13, [x18, #CPU_XREG_OFFSET(12)]
+	stp	x14, x15, [x18, #CPU_XREG_OFFSET(14)]
+	stp	x16, x17, [x18, #CPU_XREG_OFFSET(16)]
+
+	ret
+SYM_CODE_END(__kvm_hyp_host_forward_smc)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index a4f1cac714d7..f25680ede080 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -18,6 +18,8 @@
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
+void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
+
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -152,12 +154,39 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
 }
 
+static void default_host_smc_handler(struct kvm_cpu_context *host_ctxt)
+{
+	__kvm_hyp_host_forward_smc(host_ctxt);
+}
+
+static void skip_host_instruction(void)
+{
+	write_sysreg_el2(read_sysreg_el2(SYS_ELR) + 4, SYS_ELR);
+}
+
+static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
+{
+	default_host_smc_handler(host_ctxt);
+
+	/*
+	 * Unlike HVC, the return address of an SMC is the instruction's PC.
+	 * Move the return address past the instruction.
+	 */
+	skip_host_instruction();
+}
+
 void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
 
-	if (unlikely(ESR_ELx_EC(esr) != ESR_ELx_EC_HVC64))
+	switch (ESR_ELx_EC(esr)) {
+	case ESR_ELx_EC_HVC64:
+		handle_host_hcall(host_ctxt);
+		break;
+	case ESR_ELx_EC_SMC64:
+		handle_host_smc(host_ctxt);
+		break;
+	default:
 		hyp_panic();
-
-	handle_host_hcall(host_ctxt);
+	}
 }
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
