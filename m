Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50138C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 15:00:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B2FD4BA11;
	Fri, 25 Feb 2022 10:00:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s9wsuUrHWkOi; Fri, 25 Feb 2022 10:00:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D44C4BA9D;
	Fri, 25 Feb 2022 09:59:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E778A4BB9C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:43:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hqd-f0Em7Lj1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 22:43:53 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D53914BB7F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:43:53 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 s22-20020a252d56000000b00624652ac3e1so1986907ybe.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 19:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=N53fsYbjdomZEqC08ZX2aLHLeu/DgUziJYRqEwUtI1A=;
 b=RDsCf9B/tbqpBWDVVLA0Uni/cUxBssEL82brdpQDflFscrjWeDp/IrFbmB2lXkwnOT
 +aBRWNfkxrYjNC06MXJX+XbipoXeQdIouEFph61JxnLy+dAT8wBgGgTRmpGb6ZeE08OW
 7pwzwrlXeD3rOPlWuIroN5SUiUVJPqFsleOthEEoxub28NOvTT+YyUVHv2PlkCalpcgo
 qgwxVpdwC96gSO2gBGYZYG9DZwu2zh03MCxlgz5iq6nL9h/OBROE4CheyUhRwlryYluZ
 Pe15eTYZFhbKKqb8Vi5+4TLV3djTewGaBaZDmTc1qVLOTEnaHckwbPlSu9/2sm80a6Zj
 uLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=N53fsYbjdomZEqC08ZX2aLHLeu/DgUziJYRqEwUtI1A=;
 b=7f0iRf0u0mH5meJ1zKN0MQQmbXYSYGg/7o7fMDaL8KTwLHFw6/d5q+yEeCVEOA2rFd
 iqMGBviupXTogCnLeOm7zudU76S6GabymJpC+cHfI8YdUqJgf9dW85OeK0vF/slMT9ZJ
 kuZL7xvb+84Y7Gdtw4UIMs82Jot5lQJPEFF4SSbWYgPRFKLPK8SBjkoseoAckp6af188
 527toOrowNKkPfvNChEjNcsFX582CvEj4jD4xrD8Eta0fFbuGMoo5jcuZe3JjOAUbHMm
 GbW8CUY1zFRJj3YctuvyMBI89xiD9FJdx2tucNduUYsNW0eUNEG5uPPkj1lts59qsehJ
 w3FQ==
X-Gm-Message-State: AOAM531FCJ7WlSzODMSeD01QOecO4mofUum+d3MtmvcZ/OLuavDZSsqw
 vNnwaqGT6nrcpxsUA5hwgfQ5b8gQs5m+Sqe3Vg==
X-Google-Smtp-Source: ABdhPJyXz9CYv8vpYP/3Z7ESWeXMCWY52bhCF65m+jCDLtu1xmRA3zZ3JjZrJQKEzrQefdbm9ToCdQ84n4fL6vpCfQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:3a50:90b2:e6a2:9060])
 (user=kaleshsingh job=sendgmr) by 2002:a25:df51:0:b0:624:5c91:8e76 with SMTP
 id w78-20020a25df51000000b006245c918e76mr5460126ybg.337.1645760633363; Thu,
 24 Feb 2022 19:43:53 -0800 (PST)
Date: Thu, 24 Feb 2022 19:34:50 -0800
In-Reply-To: <20220225033548.1912117-1-kaleshsingh@google.com>
Message-Id: <20220225033548.1912117-6-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220225033548.1912117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 5/8] KVM: arm64: Detect and handle hypervisor stack
 overflows
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 25 Feb 2022 09:59:45 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
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
are aligned to twice their size (PAGE_SIZE), meaning that any valid stack
address has PAGE_SHIFT bit as 0. This allows us to conveniently check for
overflow in the exception entry without corrupting any GPRs. We won't
recover from a stack overflow so panic the hypervisor.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v3:
  - Remove test_sp_overflow macro, per Mark
  - Add asmlinkage attribute for hyp_panic, hyp_panic_bad_stack, per Ard

 arch/arm64/kvm/hyp/nvhe/host.S   | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c |  7 ++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 3d613e721a75..749961bfa5ba 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -153,6 +153,18 @@ SYM_FUNC_END(__host_hvc)
 
 .macro invalid_host_el2_vect
 	.align 7
+
+	/*
+	 * Test whether the SP has overflowed, without corrupting a GPR.
+	 * nVHE hypervisor stacks are aligned so that SP & (1 << PAGE_SHIFT)
+	 * should always be zero.
+	 */
+	add	sp, sp, x0			// sp' = sp + x0
+	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
+	tbnz	x0, #PAGE_SHIFT, .L__hyp_sp_overflow\@
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
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
