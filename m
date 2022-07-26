Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEE0C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAD654C548;
	Tue, 26 Jul 2022 03:38:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id akgu-zkMXw49; Tue, 26 Jul 2022 03:38:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C264A4C558;
	Tue, 26 Jul 2022 03:38:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 912204C437
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ohk+tKJOqjs8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:13 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03B234C540
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:12 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31e6a8e2674so104322227b3.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jVgz/szeSDEehPkBGFOtiG6TH4cWoSnAE1JEiuFeF4M=;
 b=C8Yf1l5/uTkII4CdB1cNpCvsxEc+28PsYTXUIba+64kfS7ozSMTCfLNCiyBvwQNoYx
 v4tLxHFGn1NugmrjBRhPGqOdAZyJXo6plyN8kY2kxqrqmVq3LsXugD6jJievh78HX1KU
 8SV94Q4buvRguuD8HdNpI5/LLT4QrCi5nivUYVxFdpMWinuWqv8Wjo2CCaEzyts5qj2l
 xJc8atY4LJrRDy1iJjqOnQ7dmFBLYGMRuagGcaTc0e7clYvr/Z70nvyA4TtGSrPQOrH8
 Y5fQN/ePeHrKVVNVIg/c62DaamTj1boYjZ/CNnJsQw/brcmyDLOOKu7s7UrMm8NQL9ED
 RE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jVgz/szeSDEehPkBGFOtiG6TH4cWoSnAE1JEiuFeF4M=;
 b=oSPuSEiQg/j7yhHS1qCvc6f+5lkmEsmTZ/sE4QWKVYqhz7mXw2/f7f2WtyKks9Y7H9
 bNn0UexX9HRMMF15nXii6dL4HIEeSYvJyIEmzP0/jmvrT/SdB8l+FBowd40esJmwvzF+
 TsJZae9Po7lOC88FICMux0bt0NdLqpeqpGCztjLQfDPe3eoja4SltzIwtNnJZoa/DeUK
 t+vrVsmH8epdpiTrKlaMDc5P61WdUXWJ99h5UxyK6yqpzBZunHyhfivgeSU/rOlZ2Ifk
 qdXdT9ZQzfz5hkIz/U8yrF77wkMMGK65UIfT/7gBiB69dHSKgadJSb6Tv0KXMe0yfNaz
 hYBw==
X-Gm-Message-State: AJIora8cZUzLRrlK7xv1+trF4koBOy+8GFbqu40rHD8CKmBGp0pdRjFL
 3cYKp6Vnjzmm4Rg+QRlGJEnAIAl9XXxMZOdyCA==
X-Google-Smtp-Source: AGRyM1u/sM09rRaGMw6Yf5N3cXgpcmHXKZVyWJE18QaDwOtW5yaQPATPB7V5gHdj9ore7niZ9XvnVO65RXiiNAWyfg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:1613:b0:671:2e0c:dda1 with
 SMTP id bw19-20020a056902161300b006712e0cdda1mr7585688ybb.514.1658821092633;
 Tue, 26 Jul 2022 00:38:12 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:40 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-8-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 07/17] KVM: arm64: On stack overflow switch to hyp
 overflow_stack
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, elver@google.com,
 linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

On hyp stack overflow switch to 16-byte aligned secondary stack.
This provides us stack space to better handle overflows; and is
used in a subsequent patch to dump the hypervisor stacktrace.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
---

Changes in v6:
  - Add Fuad's Tested-by tag

Changes in v5:
  - Add Reviewed-by tag from Fuad

 arch/arm64/kvm/hyp/nvhe/Makefile     |  2 +-
 arch/arm64/kvm/hyp/nvhe/host.S       |  9 ++-------
 arch/arm64/kvm/hyp/nvhe/stacktrace.c | 11 +++++++++++
 3 files changed, 14 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/stacktrace.c

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index f9fe4dc21b1f..524e7dad5739 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -14,7 +14,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index ea6a397b64a6..b6c0188c4b35 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -177,13 +177,8 @@ SYM_FUNC_END(__host_hvc)
 	b	hyp_panic
 
 .L__hyp_sp_overflow\@:
-	/*
-	 * Reset SP to the top of the stack, to allow handling the hyp_panic.
-	 * This corrupts the stack but is ok, since we won't be attempting
-	 * any unwinding here.
-	 */
-	ldr_this_cpu	x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
-	mov	sp, x0
+	/* Switch to the overflow stack */
+	adr_this_cpu sp, overflow_stack + OVERFLOW_STACK_SIZE, x0
 
 	b	hyp_panic_bad_stack
 	ASM_BUG()
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
new file mode 100644
index 000000000000..a3d5b34e1249
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM nVHE hypervisor stack tracing support.
+ *
+ * Copyright (C) 2022 Google LLC
+ */
+#include <asm/memory.h>
+#include <asm/percpu.h>
+
+DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
+	__aligned(16);
-- 
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
