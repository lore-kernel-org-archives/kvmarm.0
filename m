Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B04C64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5BB722250
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5BB722250
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 820344B446;
	Wed,  2 Dec 2020 13:42:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L+kFwrQg6NjN; Wed,  2 Dec 2020 13:42:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6887A4B429;
	Wed,  2 Dec 2020 13:42:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 708304B379
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CgGGnL3GVzy7 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:42:02 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 423374B3CE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:02 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id i2so5163868wrs.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=6X5Tu43pgKNfdIYIj06Fr+JlpCFzZj/ZURHeuSR11Bw=;
 b=IAmw5/Y6w/en7YUiVJqEzUbksV4/sxbgv4bnK+MzI6iH7OV6SdZNtRr7IEYZL2boJs
 11rJ0wEO34CQVAzo02Vc1m1rTPe8chZU5zhwCjwmrbgxOieXaTiWJatxME0NjTCK+tIW
 KQP07nH5PKznctiftFYr7s5fGiPHzmRDG9F78EGHbm5d6XAaffuWi4ZxiF9Jv27/TAya
 /SyK9qECXiwUWdFlzgBP/LVZXOr9gOu2UiODgi1YZl6d2EmVVL8ajBezwoxJ3+f5QxoN
 9xF5YFOYDA9SdlVcBWYS1x/NrGphTirebdIi98mz97lZLSx9zo/ExmCsthjnEdHnvp4T
 DmPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=6X5Tu43pgKNfdIYIj06Fr+JlpCFzZj/ZURHeuSR11Bw=;
 b=rfWhmA48eBAJwJ3POAfcWZHAkf6w2NME3ya68bUFedpunpEfTwuDQLsFVkIAiiRzId
 qhicsOLY0XO650lM4KKF2UBmI/VK4dKn4u5xfS2kdR1sNG/LQH4eKMwm1LWGPhUI0XVG
 SpCAe5JlEiRkMJ9Pw24x7e4HjynQrPmGKfDu2pjCnqUnMVU1caDN3c5WK9HEH7x8LnyT
 oiOjFpTL44zKV1fQHZViHHJKbT98nKCIzLByk/lRBCeX9tDKG9yCazW81l3HsU/Q3QEa
 GwzZ4lvEieJJrl7+TtbKoews7P1OTfHlb6nvdaI7j6daStpeKlV4WDNQSycbBI73YALN
 fScw==
X-Gm-Message-State: AOAM530gfHWqKDOfZbaECSl0PR7NPMmqtPDrO8VCCIOVz/DDdZ+UzTex
 Fh+fs8T1DWz7yZD9rb6SzDMlnE54RduzmQ==
X-Google-Smtp-Source: ABdhPJzPFxnIikpIDzOJVUvZ6LglTEeEOYbM++Awb1eYvwM5zMt7kfYo0dvt6rG0gZ8koyG/p8VLcQ==
X-Received: by 2002:a5d:4087:: with SMTP id o7mr4938755wrp.27.1606934520868;
 Wed, 02 Dec 2020 10:42:00 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id l16sm3085275wrx.5.2020.12.02.10.41.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:41:59 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 15/26] kvm: arm64: Add SMC handler in nVHE EL2
Date: Wed,  2 Dec 2020 18:41:11 +0000
Message-Id: <20201202184122.26046-16-dbrazdil@google.com>
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

Add handler of host SMCs in KVM nVHE trap handler. Forward all SMCs to
EL3 and propagate the result back to EL1. This is done in preparation
for validating host SMCs in KVM protected mode.

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
