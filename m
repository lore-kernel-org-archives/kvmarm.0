Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F3EC4741F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B2C5D206ED
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="jrUqYCAx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2C5D206ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53E9A4B741;
	Mon,  9 Nov 2020 06:33:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kKNyWgBlOB7u; Mon,  9 Nov 2020 06:33:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF8D64B861;
	Mon,  9 Nov 2020 06:33:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 147FE4B759
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xnsd8CnD8B7N for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:08 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DDA04B82C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:08 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id p8so7503600wrx.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=gwTDypgwUf3rqkSua5uxQzTJijirOP4lU9f1S+usZSk=;
 b=jrUqYCAxKbMftvyv6EO+CyG7nRBWv1N9ciXM0WTM22HN8ijzC7yryR2lqJGhSbRuOG
 iwtZf64B+wSe1RFqDZKWDqB/cZ0sAqey2anS57mqhoAJ20bblxIJNt8SlhnR/l4hsN63
 vs2yLQ6INp6gpfIL+5SmE6i36GQASly/+2LS6TLFeqqRgjqgsOBKxrRqqkh7Iw1AgMwh
 HHGaSM3jxkADdB1M0xeCQ9TlxT8iW3y0dO7RzbJY3SeffWP8ZsWfb2PPOUsAGn7hI9rP
 tJ7M3hRhPTfE06JkGh3e6zEHRr9fFR/9o/IuwJqCwI8nZd6lIb7JeKWU5ISX7viZgUlB
 9IPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=gwTDypgwUf3rqkSua5uxQzTJijirOP4lU9f1S+usZSk=;
 b=OMt6b7funCz2LZFDHfbCrgh+9JyrCRjyOk4BWAn7fn7BIjeFaCeDVEcYiMHPm3A26r
 BvUyu1KvTjtyLWHih7Vkmpx5tC54lBkxMrk/Da2XTnVmHRUdOOWYrIYH7sdrQAo1RPUh
 cL5DJy8mtuu+sp53TJ8VdAX7ZgGqLUm3gJN96PIsDIbzPAICXMQv7e2HJj+w00ycb0yP
 VWKcr+8UiOtJYKoKsFXdT59fisrKI/HWqgNDSRcVXS/ERR06IbF1Ggkr6fAxvFmWGNZL
 S+cY8PFpv8zsfguo5sPTWOYfpgvoYOXDA6NendZnib9H6A6hX9bjQnGXpxLdOK8m+Nor
 LWRg==
X-Gm-Message-State: AOAM533uRbQcA0nFa/L1ybaF0ORb8siebhnE/pYnROubJaRdEiZ2yHk7
 vZhzTz3haa744sx6ut/HvgsYJPSNDKKNu7ke
X-Google-Smtp-Source: ABdhPJzFLULK2SSOyOQsTmDu18P2ApF4H82covw7VmzC9kWedcZrYGtm7jY72SGBGNtESQ3aE2thsQ==
X-Received: by 2002:adf:db4a:: with SMTP id f10mr2709289wrj.420.1604921586733; 
 Mon, 09 Nov 2020 03:33:06 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id n22sm11769101wmk.40.2020.11.09.03.33.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:05 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 13/24] kvm: arm64: Add CPU entry point in nVHE hyp
Date: Mon,  9 Nov 2020 11:32:22 +0000
Message-Id: <20201109113233.9012-14-dbrazdil@google.com>
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

When nVHE hyp starts interception host's PSCI CPU_ON SMCs, it will need
to install KVM on the newly booted CPU before returning to the host. Add
an entry point which expects the same kvm_nvhe_init_params struct as the
__kvm_hyp_init HVC in the CPU_ON context argument (x0).

The entry point initializes EL2 state with the same init_el2_state macro
used by the kernel's entry point. It then initializes KVM using the same
helper function used in the __kvm_hyp_init HVC.

When done, the entry point branches to a function provided in the init
params.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/kernel/asm-offsets.c    |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 30 ++++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 893327d1e449..efb4872bb29f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -155,6 +155,7 @@ struct kvm_nvhe_init_params {
 	unsigned long tpidr_el2;
 	unsigned long hyp_stack_ptr;
 	unsigned long vector_ptr;
+	unsigned long psci_cpu_entry_fn;
 };
 
 /* Translate a kernel address @ptr into its equivalent linear mapping */
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 0cbb86135c7c..ffc84e68ad97 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -114,6 +114,7 @@ int main(void)
   DEFINE(NVHE_INIT_TPIDR_EL2,	offsetof(struct kvm_nvhe_init_params, tpidr_el2));
   DEFINE(NVHE_INIT_STACK_PTR,	offsetof(struct kvm_nvhe_init_params, hyp_stack_ptr));
   DEFINE(NVHE_INIT_VECTOR_PTR,	offsetof(struct kvm_nvhe_init_params, vector_ptr));
+  DEFINE(NVHE_INIT_PSCI_CPU_ENTRY_FN,	offsetof(struct kvm_nvhe_init_params, psci_cpu_entry_fn));
 #endif
 #ifdef CONFIG_CPU_PM
   DEFINE(CPU_CTX_SP,		offsetof(struct cpu_suspend_ctx, sp));
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 1697d25756e9..f999a35b2c8c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -6,6 +6,7 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/linkage.h>
+#include <linux/irqchip/arm-gic-v3.h>
 
 #include <asm/alternative.h>
 #include <asm/assembler.h>
@@ -159,6 +160,35 @@ alternative_else_nop_endif
 	ret
 SYM_CODE_END(___kvm_hyp_init)
 
+SYM_CODE_START(__kvm_hyp_cpu_entry)
+	msr	SPsel, #1			// We want to use SP_EL{1,2}
+
+	/*
+	 * Check that the core was booted in EL2. Loop indefinitely if not
+	 * because it cannot be safely given to the host without installing KVM.
+	 */
+	mrs	x1, CurrentEL
+	cmp	x1, #CurrentEL_EL2
+	b.ne	.
+
+	/* Initialize EL2 CPU state to sane values. */
+	mov	x29, x0
+	init_el2_state nvhe
+	mov	x0, x29
+
+	/*
+	 * Load hyp VA of C entry function. Must do so before switching on the
+	 * MMU because the struct pointer is PA and not identity-mapped in hyp.
+	 */
+	ldr	x29, [x0, #NVHE_INIT_PSCI_CPU_ENTRY_FN]
+
+	/* Enable MMU, set vectors and stack. */
+	bl	___kvm_hyp_init
+
+	/* Leave idmap. */
+	br	x29
+SYM_CODE_END(__kvm_hyp_cpu_entry)
+
 SYM_CODE_START(__kvm_handle_stub_hvc)
 	cmp	x0, #HVC_SOFT_RESTART
 	b.ne	1f
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
