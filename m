Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEEA7C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 20:05:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 991E149E35;
	Mon, 14 Mar 2022 16:05:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GIPISWKUHnLF; Mon, 14 Mar 2022 16:05:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6424849EAC;
	Mon, 14 Mar 2022 16:05:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D50DD49AF7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:05:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jv6-2yY-0Y91 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 16:05:51 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97BDC4086D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:05:51 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2dcd6a5e4b6so141242697b3.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 13:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=8f0s79ka6K+xZLjhEa6v9OQwM+zc/G84NFUgH0amXtY=;
 b=oWMxFcmEuQa7Oz8Msf5z2d2F/+cxSvJeY2AkshA00cCwmDongR92lT++R6u+2wswp/
 KeHuRfDuIINh7QuVpmgim0OtP9TVidSBRd8VA4FhF9ErV1otSCPmz+AkktixGdSZwzT8
 LCfWw99uiLBPTLjaM7e2GesV6Vr95aJhEjo56x1iSRDgcy1Pi4qC604b7DxcZjF0+c7w
 /2K0o8E7BBCgilr6vRGvf156M3tc+fnB8epOT0a5sLqt3zWx7hzNiJnGvxaWsM5waXja
 J6OMDvqIkNbTk3t3YyDVaC5Q3RlFOFXcGH/fE9ejjisH84XYUlCL+8IflYOkwpId7Erp
 aQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=8f0s79ka6K+xZLjhEa6v9OQwM+zc/G84NFUgH0amXtY=;
 b=7M1LilxODB4Zv1Tp/D24xKv1vEKGJQ3YNVRk8hJ1mZy/J0yV+l8MpcMrmbf6Vi4eJB
 p2F9jGYNskJTbIDVnyaZouAS3A28FPxjAJLyOo6h0IJ0XXWeJISzO1/mxdtdtJxlvF10
 30P00yLlN5wx2kg4ehN3XW8qJ6Zw3PwkvcbEdBUBCH04pZJ0eC6rFxo6wY3c0VmgBggF
 g0iYLbQlULlWkN4TtHiymiJz6MgzEuwWYM1asllOgvRBn0JY7JTIRJ0TzqBED/TeDXhH
 yAvvI2yjIiVqeB1hOyht2KGcQNdqvmT1f9C9bDkEsqyPD6zihyUNxleFaVsneRZxGHwq
 upSw==
X-Gm-Message-State: AOAM531lOuhZMXWEB4i+74MhprRYGcf50YJPrOP4UfRC2C2qxv8oz0MN
 sFBbYRdRZJX8FPsj64AuJDCiTNtypJxreNo1hw==
X-Google-Smtp-Source: ABdhPJxeJ4ERpyXJrRQxcj/bYJNsQODEu20+d8yn9qPL1N8ZlV6KyQDHbDeVHPvOyZo+/DauOEQQySrLcRIvNw+kpA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:500a:9ac2:e73e:69e3])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:712:0:b0:629:5d03:4b1b with SMTP
 id g18-20020a5b0712000000b006295d034b1bmr19139174ybq.380.1647288351094; Mon,
 14 Mar 2022 13:05:51 -0700 (PDT)
Date: Mon, 14 Mar 2022 13:01:15 -0700
In-Reply-To: <20220314200148.2695206-1-kaleshsingh@google.com>
Message-Id: <20220314200148.2695206-7-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220314200148.2695206-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 6/8] KVM: arm64: Add hypervisor overflow stack
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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

Allocate and switch to 16-byte aligned secondary stack on overflow. This
provides us stack space to better handle overflows; and is used in
a subsequent patch to dump the hypervisor stacktrace. The overflow stack
is only allocated if CONFIG_NVHE_EL2_DEBUG is enabled, as hypervisor
stacktraces is a debug feature dependent on CONFIG_NVHE_EL2_DEBUG.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v4:
  - Update comment to clarify resetting the SP to the top of the stack
    only happens if CONFIG_NVHE_EL2_DEBUG is disabled, per Fuad


 arch/arm64/kvm/hyp/nvhe/host.S   | 11 ++++++++---
 arch/arm64/kvm/hyp/nvhe/switch.c |  5 +++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index be6d844279b1..a0c4b4f1549f 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -179,13 +179,18 @@ SYM_FUNC_END(__host_hvc)
 	b	hyp_panic
 
 .L__hyp_sp_overflow\@:
+#ifdef CONFIG_NVHE_EL2_DEBUG
+	/* Switch to the overflow stack */
+	adr_this_cpu sp, hyp_overflow_stack + PAGE_SIZE, x0
+#else
 	/*
-	 * Reset SP to the top of the stack, to allow handling the hyp_panic.
-	 * This corrupts the stack but is ok, since we won't be attempting
-	 * any unwinding here.
+	 * If !CONFIG_NVHE_EL2_DEBUG, reset SP to the top of the stack, to
+	 * allow handling the hyp_panic. This corrupts the stack but is ok,
+	 * since we won't be attempting any unwinding here.
 	 */
 	ldr_this_cpu	x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
 	mov	sp, x0
+#endif
 
 	bl	hyp_panic_bad_stack
 	ASM_BUG()
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 703a5d3f611b..efc20273a352 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -34,6 +34,11 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+DEFINE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], hyp_overflow_stack)
+	__aligned(16);
+#endif
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
