Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E8CC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 20 Apr 2022 21:46:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3E5740E62;
	Wed, 20 Apr 2022 17:46:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xQ1LerlV0zUZ; Wed, 20 Apr 2022 17:46:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F20F4B1D0;
	Wed, 20 Apr 2022 17:46:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B21644B1A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 17:46:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hWYMRPiFGcIE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 17:46:25 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DCD249B26
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 17:46:25 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b12-20020a056902030c00b0061d720e274aso2644866ybs.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 14:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=GgvZp34BK6H0FUXR9EOtBK1V9jyG5177uTq39S22sfQ=;
 b=YLibaJIUGmaDvUVjiLNeo/1HlTfI3zS6LHvsGnOZ7nQlc63ry+7w9kNdZS98Nsg0dI
 UcuRAZtkNAF9gMWQ+7tEnCk9peOHo4HZMgSZOrFmUISzJr6HtkRl9Hc5VqsyLk/Gzkqg
 GaZHzBEkf/e0IzSd1EIp3E3UsHgYiiDnynGn0Vqr4Hzuz9/delgTV+agJj7ICCbs6/Dc
 LDf+9rDXMww0jVi9aLG5NMpwWfYcVTW6WVT8VQBUoyRDgiHtiqLO3fv6vWCtCxFJAyV1
 xH57L111n1Gktk4VQNMV+qWaWEZaWoDAMmh5EdnCzNbAP96SgdXMwIvjMO87ui+g4cpy
 TuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=GgvZp34BK6H0FUXR9EOtBK1V9jyG5177uTq39S22sfQ=;
 b=nWAmRecrLOWPyJD3pywvdkci/g5MmWVGWKTF1iCOGTKi14Y2SXJSQnFlZHUgOzCZXV
 DQEU4yr/3LINNof3HB8XXWZiDObI1wR/XyyU931DrJZyTNfgL1xZ6rmWYFQwy5/IFAGR
 AO9WVwbYAuZU/p/AmgK6wXYMeXiwj/lHYFUAXNgTg71vlAbcXDK7zP4iEaUcdgfI/YXJ
 GWxkBwhyQPmbv4zA1a7s5md2Zsf/4Qbf+PtgiinZkyOIQ9vNz1wGiIRFW9kpaUIsC0ed
 fl6gS55ImnEa3ubsTf8TRpFo83Sdky08qm4mHQtTNx8yHLkLNqMihnRj4QK/hYux2eUh
 P7kQ==
X-Gm-Message-State: AOAM531pHjswyz9rs2kaBNcSYjgI0Ma/E0T6E3yd9xKVm6v8n3yC+l2x
 yyImnsRDHlTvp03+w5j5cl4iICQMHBjJCcOcqg==
X-Google-Smtp-Source: ABdhPJyppryoKr9oaIT1p1DVqRzVQjMH2bfnVLMwG49QsDwJMJtZjut11ZY+ct0kOHIySH/Adr7CF8CWrpG88gIeBg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:2a20:cec4:8f41:cd6f])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:114c:b0:644:cada:4ee7 with
 SMTP id p12-20020a056902114c00b00644cada4ee7mr20521440ybu.217.1650491184989;
 Wed, 20 Apr 2022 14:46:24 -0700 (PDT)
Date: Wed, 20 Apr 2022 14:42:56 -0700
In-Reply-To: <20220420214317.3303360-1-kaleshsingh@google.com>
Message-Id: <20220420214317.3303360-6-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220420214317.3303360-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v8 5/6] KVM: arm64: Detect and handle hypervisor stack
 overflows
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, kernel-team@android.com,
 Catalin Marinas <catalin.marinas@arm.com>, Andrew Walbran <qwandor@google.com>,
 will@kernel.org, maz@kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
 linux-kernel@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
 Changbin Du <changbin.du@intel.com>, linux-arm-kernel@lists.infradead.org,
 surenb@google.com, kvmarm@lists.cs.columbia.edu
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
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---

Changes in v8:
  - branch to hyp_panic_bad_stack(), instead of branch and link, per Marc

Changes in v7:
  - Add Fuad's Reviewed-by and Tested-by tags.

Changes in v5:
  - Valid stack addresses now have PAGE_SHIFT bit as 1 instead of 0

Changes in v3:
  - Remove test_sp_overflow macro, per Mark
  - Add asmlinkage attribute for hyp_panic, hyp_panic_bad_stack, per Ard


 arch/arm64/kvm/hyp/nvhe/host.S   | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c |  7 ++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 3d613e721a75..09b5254fb497 100644
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
+	b	hyp_panic_bad_stack
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
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
