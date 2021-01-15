Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0BDC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:18:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8AD1823976
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:18:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8AD1823976
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F7A04B23A;
	Fri, 15 Jan 2021 12:18:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id btQD0pVuMxjd; Fri, 15 Jan 2021 12:18:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0632F4B23E;
	Fri, 15 Jan 2021 12:18:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E2944B229
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:18:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dmnZfpVp5qrN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 12:18:49 -0500 (EST)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 76DF34B171
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:18:49 -0500 (EST)
Received: by mail-qv1-f74.google.com with SMTP id m8so8295041qvk.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=UgDs2wXmKTNFZw7IyERVXhSRi4O+lIRTxi4K3FR+2eo=;
 b=DYevj3oUdHfFqoPzpKfhqj1mj2K3AAMmzbDr56bDluU1dRt2ncqiu78K58yY20DuOv
 1wEh1UJa53ZoHOAcbkzm02W8kSdEh60XjZJsmYXmgj3neWu+HpGCga9jR2N1aQsiyz3G
 rhVRiq1P3lY7XVo1HRvbtUlwLh2uUpsCK1QA8w+WZC7NFOpxq/O7GbdrAMqySleco44z
 9bF/5xYkpnfPp3bR9l4M6KAcsSUai3NXQZyDbjcan1LwyiEl0jQH65IrjD/PuLguGJ3i
 fP+CVEG7Sy+HYa94GnjDOdwSWn/crNM+gxy1JOn2fIM3RliKl59o8x9MTdWtdFYtg9nO
 gEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=UgDs2wXmKTNFZw7IyERVXhSRi4O+lIRTxi4K3FR+2eo=;
 b=irtC3txHC2d4OqYguPLfBxfhXSGm1sLvPz7+lvEZNJHKEZgRFyuUkvdyooUwlzC2hS
 9RxK30Eo85Gq2Y8CwUlV2Jh2syvyAC0dqc1EFWZ60Ou6NJKQ297tsQFFm6iNI+FvE1Xi
 AToIVF0xGNrsH58mCKPHrlPCxvogQzSlvcKKubqp0JWNukpzOzkDCTyVRaWKc5GvwP9i
 RyA+6aQcIEtfpCgNo0/gWzzIIfG5bZg0OOBiNvtxdwa4HMGNMr2m66Opzf6/LJmPBsUm
 gJwr3prSSxNe3h8g5IWc18ZBRgEWEdHpM39ZXQDO7Vtr969fNjwBqba3/VGkDaLz42Zx
 xQJg==
X-Gm-Message-State: AOAM531dXtTOBi7un433hwad8bL43nPlXX+cEcLIyzAypNArlAqacPZ7
 /48Mcp5471N5R+4Ru5clk+xeG/5A6NGjOfpp4t7vU8P9UsLnv4YRm3VT4I2mrSxJrWPLwj8u/Gx
 WSbKROicPx5y88Qb4m9A97G+EXiyLMb1cCKOymTBlnQ3vwvaakYVpLYg+Wksl/0QwEGqUDPDG
X-Google-Smtp-Source: ABdhPJy6ISdrGnRn9CouEV5yxigJFodkL9NQqNNhZDDdgN4wy4Bt8DXBalgoL+ge3A3oT0tlGsHh2R/Jrpyu
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a05:6214:4e2:: with SMTP id
 cl2mr12940505qvb.27.1610731128896; Fri, 15 Jan 2021 09:18:48 -0800 (PST)
Date: Fri, 15 Jan 2021 17:18:22 +0000
In-Reply-To: <20210115171830.3602110-1-lenaptr@google.com>
Message-Id: <20210115171830.3602110-2-lenaptr@google.com>
Mime-Version: 1.0
References: <20210115171830.3602110-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
Subject: [PATCH v3 1/9] KVM: arm64: Enable UBSan instrumentation in nVHE hyp
 code
From: Elena Petrova <lenaptr@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: George-Aurelian Popescu <georgepope@google.com>,
 Elena Petrova <lenaptr@google.com>, Marc Zyngier <maz@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
 George Popescu <george.apopescu97@gmail.com>
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

From: George-Aurelian Popescu <georgepope@google.com>

Implement UBSan handlers inside nVHe hyp code, as empty functions for the
moment, so the undefined behaviours, that are triggered there, will be
linked to them, not to the ones defined in kernel-proper lib/ubsan.c.

In this way, enabling UBSAN_MISC won't cause a link error.

Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile |  3 ++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c  | 30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/ubsan.c

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 1f1e351c5fe2..2a683e7c6c5b 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -10,6 +10,8 @@ obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
+obj-$(CONFIG_UBSAN) += ubsan.o
+CFLAGS_ubsan.nvhe.o += -I $(srctree)/lib/
 
 ##
 ## Build rules for compiling nVHE hyp code
@@ -61,7 +63,6 @@ KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUILD_CFLAG
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
2.30.0.296.g2bfb1c46d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
