Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD9FC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 18:53:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B729C49F40;
	Mon,  7 Mar 2022 13:53:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rtX4D6r1F-Ry; Mon,  7 Mar 2022 13:53:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A599F4B0C2;
	Mon,  7 Mar 2022 13:53:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71B6B49F1C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:53:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cpyNPdxRJByw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 13:53:01 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 709A849F0F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:53:01 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2dc58f5a95bso91757427b3.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Mar 2022 10:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=UdruCL33ZZYFGiCR380CmESQcj657VbKKdTgZ1Wg8kc=;
 b=bTmhJBEGbQH5zpBf4K3Tji6NNSug2HBwU66gLQY4V5NmqKRyZhideePdARpKiCOF1c
 OOXrO4Me1fvF4pmpx411lsWI36L53KeZD78//0S7lZr7sWRneIo6LIZnHduanDKHirrp
 cW/4+mBILBdF49NaYQQ0ozFhlZCcywn/DUEVKJhd4GnfmL1mzgkqZ3czm1wYzJZkNXS4
 qW0Xc4qp7wwzIJVMA4t3smwcBSiVYJXN3TcTP/hWgqOHXc334UibH9+IWo75N0qlPwVC
 YmStcjlKcadCn3EjrZpBFiXMXsvKRboTwre/t2KGu5JqT/eDWY7BZogvQhmzrK9+elF8
 Tk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=UdruCL33ZZYFGiCR380CmESQcj657VbKKdTgZ1Wg8kc=;
 b=19Aw64QyvhgyymVUo19rBEZGiWtUwY4S9XNmp6Rv9pNsXsda8YndEFtcLtvjB/Wc/L
 //pmlawdHWCn32VIu383TNXQcm++7gHUsUEEBd3PQDu45moIYKHeWGTT3gzyZYciCFlQ
 QL8krPPXjni89zGlK9l7UaAyDZIDsMj6YkZMmowuVKuZqU26faiurCRYCp6PL3EnF+dP
 m7WQ9SO1Nel3Ri2WcGuM/xx2tz1vzXDKvYmr/yJRY9oicq80w5k7UlbTZ+JogC2BRe6e
 CvP2UsfC6tuYHJUHzq4X8peSin2fn2cffXQY4JVSSPUS3L8d9I/q6oln7QLqhVx76vtP
 fUpA==
X-Gm-Message-State: AOAM5301NgfWbFBruj9pS7pUWEV1SIJg8zxce4pTCeU/nrGI90OLjIzQ
 lAIPKVUiv3ayJiChMZVL6JwI7m6PFSbtf5VOPw==
X-Google-Smtp-Source: ABdhPJwG45Vn5BAyOQ+RCPGdUX9ElV2nKbX47V20HlQVVZhmpw653i9aEL2BOEqCy0uZFwnil4o/gkljjwS9kfExXA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:dd66:1e7d:1858:4587])
 (user=kaleshsingh job=sendgmr) by 2002:a25:be85:0:b0:61d:7838:c9a2 with SMTP
 id i5-20020a25be85000000b0061d7838c9a2mr9060538ybk.364.1646679180921; Mon, 07
 Mar 2022 10:53:00 -0800 (PST)
Date: Mon,  7 Mar 2022 10:49:04 -0800
In-Reply-To: <20220307184935.1704614-1-kaleshsingh@google.com>
Message-Id: <20220307184935.1704614-7-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220307184935.1704614-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH v5 6/8] KVM: arm64: Add hypervisor overflow stack
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
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
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
