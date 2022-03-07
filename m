Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19147C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 18:52:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A8FE4B0BE;
	Mon,  7 Mar 2022 13:52:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HWNkBtpJz2b4; Mon,  7 Mar 2022 13:52:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 772084B0CC;
	Mon,  7 Mar 2022 13:52:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44F7049F2C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:52:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JtGjppyMl5TN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 13:52:27 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CB3F49F0F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:52:27 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d81518795fso139731817b3.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Mar 2022 10:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=yZ2vExUCvgYgPgkkDALK76cPa7bHwbf59G/oTB4pBR8=;
 b=tk+eKcAIWUtxuJV96Cey1nH9mhAtDG3PMwLZ3ckk+KogZwGYwmT7/dpZ8WnXGuL22u
 eADem4jTAgtnEQ129ENQmGTGNMXyKBN+bsp+MtvSf5I41fA109y++CcPOiJEFM3zFYWW
 P7bPc45ODC1vAfwl+Nxb9vwBiXAcNaXbmU/GrpoQfc8qNppvw8Lhpe1GrqodiDHJ8NrQ
 Fe/YdllV09MlZX9bHbyenmKS2gO5nUHPm9ZEBRXneJWXheKDUVEqxYLFDY2buftxXBeV
 KP9/c/iZQS1OxPxidZOLCQSpImk2efRt6A53QpPKxdVSzthfCNH7onHJj2gFd3lv96GX
 0pGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=yZ2vExUCvgYgPgkkDALK76cPa7bHwbf59G/oTB4pBR8=;
 b=aRTlmUx2FXy2h2RqFQhYU8vooenBRqz040BldMXuLIbD62yYxT4Edg/+EMkQlgFyKI
 dZ9sBZZeaY6euTPedAc/DuHTV3s0CEFe3Cfg1KdtnNmN0bG1zrX9b/0Oj05NmjDWd7Ak
 CtYif0Ngks5hlv3Mul5X7XtEjsCOOiNRtL3gpbkgGL4xXInPjK6861z49RUsinJ2NfYq
 mYLQN7o6Xr6nvfnkNEJnpxWWLCA/wKZC/gwGvLhc+W5Mdvmg5v2U9KASjB5gtQaPPQwx
 AXYR/v7riBc7x+Gvrc+rULOOQdGsVb2oLkbTOWXUeyu5Z6lmZdbup+RO/bb/nsW9F8XR
 AOYA==
X-Gm-Message-State: AOAM5323Ircq/OjOtNu8WHJTwij48waf1OJaZ/r7veedi2Ep4SJsCLua
 0/KmdUi8zJncuI1E125zSBMgEB+L8c3ny3e/Mw==
X-Google-Smtp-Source: ABdhPJza/ySL4L3/K0sQ2wfta66Q9QT4UcSS3GTQhbvCuTd7cyJyumYfPDOSUIOj66wx+X5jOFzu3bWVNhegfDMp2g==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:dd66:1e7d:1858:4587])
 (user=kaleshsingh job=sendgmr) by 2002:a81:83cd:0:b0:2dc:2dc6:d695 with SMTP
 id t196-20020a8183cd000000b002dc2dc6d695mr9931415ywf.167.1646679146640; Mon,
 07 Mar 2022 10:52:26 -0800 (PST)
Date: Mon,  7 Mar 2022 10:49:03 -0800
In-Reply-To: <20220307184935.1704614-1-kaleshsingh@google.com>
Message-Id: <20220307184935.1704614-6-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220307184935.1704614-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH v5 5/8] KVM: arm64: Detect and handle hypervisor stack
 overflows
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, Stephen Boyd <swboyd@chromium.org>, surenb@google.com,
 Mark Brown <broonie@kernel.org>, Peter Collingbourne <pcc@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Masami Hiramatsu <mhiramat@kernel.org>
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

The hypervisor stacks (for both nVHE Hyp mode and nVHE protected mode)
are aligned such  that any valid stack address has PAGE_SHIFT bit as 1.
This allows us to conveniently check for overflow in the exception entry
without corrupting any GPRs. We won't recover from a stack overflow so
panic the hypervisor.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v5:
  - Valid stack addresses now have PAGE_SHIFT bit as 1 instead of 0

Changes in v3:
  - Remove test_sp_overflow macro, per Mark
  - Add asmlinkage attribute for hyp_panic, hyp_panic_bad_stack, per Ard

 arch/arm64/kvm/hyp/nvhe/host.S   | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c |  7 ++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 3d613e721a75..be6d844279b1 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -153,6 +153,18 @@ SYM_FUNC_END(__host_hvc)
 
 .macro invalid_host_el2_vect
 	.align 7
+
+	/*
+	 * Test whether the SP has overflowed, without corrupting a GPR.
+	 * nVHE hypervisor stacks are aligned so that the PAGE_SHIFT bit
+	 * of SP should always be 1.
+	 */
+	add	sp, sp, x0			// sp' = sp + x0
+	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
+	tbz	x0, #PAGE_SHIFT, .L__hyp_sp_overflow\@
+	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
+	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
+
 	/* If a guest is loaded, panic out of it. */
 	stp	x0, x1, [sp, #-16]!
 	get_loaded_vcpu x0, x1
@@ -165,6 +177,18 @@ SYM_FUNC_END(__host_hvc)
 	 * been partially clobbered by __host_enter.
 	 */
 	b	hyp_panic
+
+.L__hyp_sp_overflow\@:
+	/*
+	 * Reset SP to the top of the stack, to allow handling the hyp_panic.
+	 * This corrupts the stack but is ok, since we won't be attempting
+	 * any unwinding here.
+	 */
+	ldr_this_cpu	x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
+	mov	sp, x0
+
+	bl	hyp_panic_bad_stack
+	ASM_BUG()
 .endm
 
 .macro invalid_host_el1_vect
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6410d21d8695..703a5d3f611b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -347,7 +347,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_code;
 }
 
-void __noreturn hyp_panic(void)
+asmlinkage void __noreturn hyp_panic(void)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
@@ -369,6 +369,11 @@ void __noreturn hyp_panic(void)
 	unreachable();
 }
 
+asmlinkage void __noreturn hyp_panic_bad_stack(void)
+{
+	hyp_panic();
+}
+
 asmlinkage void kvm_unexpected_el2_exception(void)
 {
 	return __kvm_unexpected_el2_exception();
-- 
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
