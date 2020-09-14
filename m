Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF05C43461
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4297E21D1B
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Ccbq3bhS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4297E21D1B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3DB04B592;
	Mon, 14 Sep 2020 13:28:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B9GnRa2pAOGt; Mon, 14 Sep 2020 13:28:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA0A24B57A;
	Mon, 14 Sep 2020 13:28:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAB2D4B578
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EuW4o+h45co3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 13:28:04 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07A4F4B567
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:04 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id s12so465734wrw.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 10:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=067z7eOkoIjswCFUZaQiAlz7Yh/C6SQlkfm83TpWTDI=;
 b=Ccbq3bhSWLvuICZcTk6r5XIHbRKedih0ZWTIzz80wN/dhQskbOMUHfhHes6S8NjK03
 MdZiUUQ1RqECF0LV++t36OhqhWKQin1j4MGs2VLOVHTXD7mAlHdM1hMqdM0sm1D53f9d
 KkXWyEOSr43mtUVMecgZ3sBGstXl2R6MoLAtF48EkQ5IpPN2RtScfjiA74Iqd502EOpw
 5LwHPOjozU2dfOg4wiCnsQJHx/5ydgKvDDJLVEeAbUJ1AomfjISseAhY1fyJhK+2EfWk
 JFJTokplO4+5jUEMY9SWa8pFoguuVKTfKKsEyOf0gPldU07FI17N8pzfweAg5M7GAaBI
 x3xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=067z7eOkoIjswCFUZaQiAlz7Yh/C6SQlkfm83TpWTDI=;
 b=oTvNRIDJ7ao5u8WHbfKV2R7xHJHriwMGPDLGIRt6zETKJRUKyXmqWLfIVpBvzd7XNJ
 S9O2ZYXjrqedcUR/s/wRXs6qwV+VYHobVKW1imq31oymU19LT5B9qfx6nXCr8qZgva6c
 6a3Lzl0kZfEbgNj1+saA/lc801QiUBrpRXePrGnm3Q3WU6EKHO11u+uU0yiU+B3Xr/Qj
 taqONeops+iK0LJyUJ73md692Ba36vLYQ10jnE7/zHrx/qJzSzeqUOmSY8+bNrfRBAye
 d9ZX+PcwitMtTHAGrQ3LsVj4p9+5BgLWVq3pYnKaPy3DYdpBZZrhHIsr1a0wD/Nc7Pos
 TOrA==
X-Gm-Message-State: AOAM532IjZR4g2E6PA2XKPF6O7jZNxvxy1qD6qdOIQiB2yY6dhijVD6f
 ce4FSUHy/nNtpyy+BfKzkYGQXw==
X-Google-Smtp-Source: ABdhPJxPTT5/y2bkI5dyBo11sTtACjcXqzQfAIFfMByvB17sbPDS6CpmIX1YCL1LK2SPPsa/YejUaQ==
X-Received: by 2002:a5d:5281:: with SMTP id c1mr16890910wrv.184.1600104483118; 
 Mon, 14 Sep 2020 10:28:03 -0700 (PDT)
Received: from localhost (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id y1sm19586977wma.36.2020.09.14.10.28.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Sep 2020 10:28:02 -0700 (PDT)
From: George-Aurelian Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: [PATCH 01/14] KVM: arm64: Enable UBSan instrumentation in nVHE hyp
 code
Date: Mon, 14 Sep 2020 17:27:37 +0000
Message-Id: <20200914172750.852684-2-georgepope@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200914172750.852684-1-georgepope@google.com>
References: <20200914172750.852684-1-georgepope@google.com>
MIME-Version: 1.0
Cc: arnd@arndb.de, elver@google.com, tglx@linutronix.de, keescook@chromium.org,
 maskray@google.com, linux-kbuild@vger.kernel.org, ndesaulniers@google.com,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 clang-built-linux@googlegroups.com, broonie@kernel.org, dvyukov@google.com,
 natechancellor@gmail.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: George Popescu <georgepope@google.com>

Implement UBSan handlers inside nVHe hyp code, as empty functions for the
moment, so the undefined behaviours, that are triggered there, will be
linked to them, not to the ones defined in kernel-proper lib/ubsan.c.

In this way, enabling UBSAN_MISC won't cause a link error.

Signed-off-by: George Popescu <georgepope@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile |  4 +++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c  | 30 ++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/ubsan.c

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index aef76487edc2..cc082e516353 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -10,6 +10,9 @@ obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
 
+CFLAGS_ubsan.hyp.tmp.o += -I $(srctree)/lib/
+obj-$(CONFIG_UBSAN) += ubsan.o
+
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
 
@@ -54,7 +57,6 @@ KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUILD_CFLAG
 # cause crashes. Just disable it.
 GCOV_PROFILE	:= n
 KASAN_SANITIZE	:= n
-UBSAN_SANITIZE	:= n
 KCOV_INSTRUMENT	:= n
 
 # Skip objtool checking for this directory because nVHE code is compiled with
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
new file mode 100644
index 000000000000..a5db6b61ceb2
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2020 Google LLC
+ * Author: George Popescu <georgepope@google.com>
+ */
+#include <linux/ctype.h>
+#include <linux/types.h>
+#include <ubsan.h>
+
+void __ubsan_handle_add_overflow(void *_data, void *lhs, void *rhs) {}
+
+void __ubsan_handle_sub_overflow(void *_data, void *lhs, void *rhs) {}
+
+void __ubsan_handle_mul_overflow(void *_data, void *lhs, void *rhs) {}
+
+void __ubsan_handle_negate_overflow(void *_data, void *old_val) {}
+
+void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs) {}
+
+void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr) {}
+
+void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr) {}
+
+void __ubsan_handle_out_of_bounds(void *_data, void *index) {}
+
+void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs) {}
+
+void __ubsan_handle_builtin_unreachable(void *_data) {}
+
+void __ubsan_handle_load_invalid_value(void *_data, void *val) {}
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
