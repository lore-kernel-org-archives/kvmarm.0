Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2693C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3BB8F23B40
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BB8F23B40
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1B914B237;
	Thu, 14 Jan 2021 12:44:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8hUGrY0dfTBw; Thu, 14 Jan 2021 12:44:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D0E24B23E;
	Thu, 14 Jan 2021 12:44:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ED144B1F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QAWuvUBvVcOA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 12:24:34 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD39A4B187
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:34 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id n11so2894126wro.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 09:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=y3uVL2zsp0VJR2OozRdghUzMpLjApzFCfr62Fn6g7rg=;
 b=jXDVpHxScZiOuheuAvtB58//oBlibKwTMFxR8j3bTBIqi2TYWJks5H6A9l9H4iZEQo
 vRunm5PZ3PchWeHirQY8/It+PP3sfBYMvaGGZnDFPbesmOwT8brcqLpjhAy+DXjARHcM
 rmgXiHd8w8oSdElQ/RL48v5yfEv5plBKJKu8F/hjhdek6o6w+/14JykyMOcpvjqvIljz
 JVMrr3GrTj+XeJqSptoJFoF/uyIVGka1QGy1Rwxf/g41YbKCtc+G7vJjjGEtOzUuNiqD
 d1d+FY7iVHTWBIG4BRg8Y818P+5IjkwMe+TKBM9iNC8lF3UZ92DO/o9C97QMFiyPjJKo
 k8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=y3uVL2zsp0VJR2OozRdghUzMpLjApzFCfr62Fn6g7rg=;
 b=eLU00mZnXanAQ9V0qE72iG59AeuBbOgEaBEJURAc4wNc7LlT3TRa/bzGas3fTYfseB
 /JBEfGkw1BIrvjjCbF050upkFvif8BSa+raOupDPjbEGChEZ7XPG4zdvAj4CQuTRF+Aj
 agKa08YfX8NrAAVq6YS8G/3XsLKzrxYMX3UMWDEhWat/xek23arkvxf4nJxbOEJ/VHXI
 xKmWv1lWzy+DRekfSWaIj5FLEh/PaUOaztcomiL1pSqa4yl8+K/k6NQ90jbhkjnrjoFe
 x841QffU67PI3V15nvvXLAL+jvz7nLmnkXiVxK5Y89HBEcSaqnmj7VX3cfDwI1Xf3QHs
 cP2A==
X-Gm-Message-State: AOAM533SF9hl4Pg9K469fltRrEKo5w/0+H1R2l5T5IG73Cs9asMy0S3L
 320jKqecqzLh6cDVbePty3XYPTehHDchubNBxmr/YdGEI8BQsz9qQ23eNhAit9cGl24K7wzesiy
 Fwt6BITah5Dd0kaCZze3jRYpBA5q67blHqnygcnVYkl6ZO6fPyWpWbYZLlAfHEEYGuQO3pT7H
X-Google-Smtp-Source: ABdhPJydi7AsXcrMM3CBUVXuKwwycVtR+4ZFfJv4lMAMFVPeGz4BC+6e8WueiOFjSoLsgWVbliWfdubnCMzh
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a1c:2c89:: with SMTP id
 s131mr533151wms.0.1610645073118; Thu, 14 Jan 2021 09:24:33 -0800 (PST)
Date: Thu, 14 Jan 2021 17:23:31 +0000
In-Reply-To: <20210114172338.2798389-1-lenaptr@google.com>
Message-Id: <20210114172338.2798389-2-lenaptr@google.com>
Mime-Version: 1.0
References: <20210114172338.2798389-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 1/9] KVM: arm64: Enable UBSan instrumentation in nVHE hyp
 code
From: Elena Petrova <lenaptr@google.com>
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Thu, 14 Jan 2021 12:44:06 -0500
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

Change-Id: I4a468b33251fa099ddfc05a7cefa520cb8817994
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
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
