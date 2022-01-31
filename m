Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC462C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 31 Jan 2022 12:41:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5201B4B269;
	Mon, 31 Jan 2022 07:41:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K4Q4hrrtjDhG; Mon, 31 Jan 2022 07:41:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 319A44B232;
	Mon, 31 Jan 2022 07:41:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B5DE4B224
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jan 2022 07:41:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G+3Ll8j3AZYn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jan 2022 07:41:23 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 588604B1D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jan 2022 07:41:23 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 n22-20020a05600c3b9600b00352d3f6a850so803248wms.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jan 2022 04:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=PcKNikI55bDy8w/A2/XpgUqHNUjMqDQm7v+KU8P6jUw=;
 b=ZedAg5IsAwnYYvRJ/slW9PVXqVh6BAZ3kdHrRnBQoYf7wiHTyZKjveOe7YXnVEe5hP
 yPUPut/r2Qk7KWFPFcGNBm2SE5zg5sDltAxYo4G7B4heLVKv2qAHpFm06Wsalcr3zu3g
 3PHmeGOC10U2ZaArFU8ocDjO4TkyMSp3GUOvFHCXS1jGA9emquJCdQ9J0d9feaWzkHzO
 +rwBDjqhqFIRvy0IwvKkqArF1VRsL895WEF5D3dXCM7dDzwSxZ+JVPT7fMz90mXGyPxn
 zpsK4aNQcWyt/1fWq6JVHCzzWsWgox8bjxfUfbIi/ZattNOOq57oLM57K5q1tbAiR2md
 q/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=PcKNikI55bDy8w/A2/XpgUqHNUjMqDQm7v+KU8P6jUw=;
 b=hjisa1ylMUchyFg1y6tlvGb0Yb9he8cJjeRMjW1scN74JKUXhJNdlHFdxCVjSTlUTy
 D2G4WaxCQs98T9D91c873e+9G+cpTVjVQ4LghbsgFaqzTwqN1n5D9t5WOaqlCPV/L1h6
 kv2/K5HYdPNF+lxRuVckv9GZY3c5CJ4/7301NZrSmYwm+6O5dvDnaPJHuFlzCscGssoB
 eAQPBM7wzY7a1RyemFMgcreG1faN0VMbOqtFza6mK2qwllMrn+Y9k+kwF9Fsrm+5Zg7+
 9UjOoDpcSaP2F/74fPW2fijwvoKGiinK8+wR4s7dQhyyau6W6nmvus6qXTRZWVFZd/lA
 oEWA==
X-Gm-Message-State: AOAM530rmPsi3w5lJKO4GSQsKhsZQ8CIQyyVTMt7/ATVrDbj/t3DDxNP
 hIag9QxE4m9LtGzjJMvOOKBBHx18sQ==
X-Google-Smtp-Source: ABdhPJxEMVqxK9VFD8U6hh5jEgX20oC9m+6rJ8uxexwyoP/dRPBjb+gbo3+XuJgFltlFVrGro+z8K8VcqA==
X-Received: from keirf-1.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:17ba])
 (user=keirf job=sendgmr) by 2002:a05:6000:16c9:: with SMTP id
 h9mr17519944wrf.272.1643632882051; Mon, 31 Jan 2022 04:41:22 -0800 (PST)
Date: Mon, 31 Jan 2022 12:40:53 +0000
Message-Id: <20220131124114.3103337-1-keirf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH v2] KVM: arm64: pkvm: Implement CONFIG_DEBUG_LIST at Hyp
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Kees Cook <keescook@chromium.org>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>
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

Currently the check functions are stubbed out at EL2. Implement
versions suitable for the constrained EL2 environment.

Signed-off-by: Keir Fraser <keirf@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile     |  3 +-
 arch/arm64/kvm/hyp/nvhe/list_debug.c | 54 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/stub.c       | 22 ------------
 3 files changed, 56 insertions(+), 23 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/list_debug.c
 delete mode 100644 arch/arm64/kvm/hyp/nvhe/stub.c

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 24b2c2425b38..f9fe4dc21b1f 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -13,10 +13,11 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
+	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
+obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-y += $(lib-objs)
 
 ##
diff --git a/arch/arm64/kvm/hyp/nvhe/list_debug.c b/arch/arm64/kvm/hyp/nvhe/list_debug.c
new file mode 100644
index 000000000000..d68abd7ea124
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/list_debug.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 - Google LLC
+ * Author: Keir Fraser <keirf@google.com>
+ */
+
+#include <linux/list.h>
+#include <linux/bug.h>
+
+static inline __must_check bool nvhe_check_data_corruption(bool v)
+{
+	return v;
+}
+
+#define NVHE_CHECK_DATA_CORRUPTION(condition)				 \
+	nvhe_check_data_corruption(({					 \
+		bool corruption = unlikely(condition);			 \
+		if (corruption) {					 \
+			if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION)) { \
+				BUG_ON(1);				 \
+			} else						 \
+				WARN_ON(1);				 \
+		}							 \
+		corruption;						 \
+	}))
+
+/* The predicates checked here are taken from lib/list_debug.c. */
+
+bool __list_add_valid(struct list_head *new, struct list_head *prev,
+		      struct list_head *next)
+{
+	if (NVHE_CHECK_DATA_CORRUPTION(next->prev != prev) ||
+	    NVHE_CHECK_DATA_CORRUPTION(prev->next != next) ||
+	    NVHE_CHECK_DATA_CORRUPTION(new == prev || new == next))
+		return false;
+
+	return true;
+}
+
+bool __list_del_entry_valid(struct list_head *entry)
+{
+	struct list_head *prev, *next;
+
+	prev = entry->prev;
+	next = entry->next;
+
+	if (NVHE_CHECK_DATA_CORRUPTION(next == LIST_POISON1) ||
+	    NVHE_CHECK_DATA_CORRUPTION(prev == LIST_POISON2) ||
+	    NVHE_CHECK_DATA_CORRUPTION(prev->next != entry) ||
+	    NVHE_CHECK_DATA_CORRUPTION(next->prev != entry))
+		return false;
+
+	return true;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/stub.c b/arch/arm64/kvm/hyp/nvhe/stub.c
deleted file mode 100644
index c0aa6bbfd79d..000000000000
--- a/arch/arm64/kvm/hyp/nvhe/stub.c
+++ /dev/null
@@ -1,22 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Stubs for out-of-line function calls caused by re-using kernel
- * infrastructure at EL2.
- *
- * Copyright (C) 2020 - Google LLC
- */
-
-#include <linux/list.h>
-
-#ifdef CONFIG_DEBUG_LIST
-bool __list_add_valid(struct list_head *new, struct list_head *prev,
-		      struct list_head *next)
-{
-		return true;
-}
-
-bool __list_del_entry_valid(struct list_head *entry)
-{
-		return true;
-}
-#endif
-- 
2.35.0.rc2.247.g8bbb082509-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
