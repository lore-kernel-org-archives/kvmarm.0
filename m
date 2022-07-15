Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B88BC43334
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 130A94BE01;
	Fri, 15 Jul 2022 02:11:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4VSmK5e8GGno; Fri, 15 Jul 2022 02:11:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D62934BDC9;
	Fri, 15 Jul 2022 02:11:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5598A4BC48
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4cSp19T6jY42 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:30 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 269204BC0C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:30 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31cb93cadf2so33662037b3.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=XgQpVRIZ/+rgJJYIXD5u7GGidNPh5ehm0t/PGc8qxk4=;
 b=KIHmo/pFQxPEIfafDaLCTvF0a7EDE8nMQQXsRPJRrevGR3G5T02SGJqczYQwFMh3ZD
 S/Mo2JRunG4K5QfkTmv39O6d0aPoe54uL7UFThYBPTrE9ktG8ha/V72h8G/iIXiVYeU0
 ai+yxL/3VpBtP32KoMJUaGknijL0zeAZhx81eaFZibT0M7zAo7VFUWGw3jhnFFrHt88D
 XeOwA7YKrOUvs+ecvZNS1RSl8Rn+s8uHO6WELw5UJbkTUdlcQbKBIsZDrRgcNZb6UF+Q
 E1JZUQiUj6FUphFlGMzjl6HBBRywechF6Ry6KSIoVwvIBwBQKX3kIHEj/DFZyAREiTAg
 LvkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XgQpVRIZ/+rgJJYIXD5u7GGidNPh5ehm0t/PGc8qxk4=;
 b=rHy/plpIxnJfbZ2ixhiJ+QLU1STsalhR/UWTlo5IjSSoNPPOomMn/hg4oycHVrX7S7
 ynnWOgHRgGuNweKxZK7zqpZQai6Bwr302dV8YWB9/npqgYnJg3Ki4pP3hRcZerYRFijH
 6qWdsQJPbC1ib6jboXxAhLadAe0A5GFeUsksgsgwfY3g6NbIiMQC0tK3WFNWSt0WJOvS
 xQrqYwprgavCk33SAnTqv1569PjuZq7ZAeYOlHnfbZwUd7v8U4TPhXOEFlx/Otu90i0W
 FcY1+q8VGryd32HMW+DuSkqCzTi8aJB1rLvTKazMvEXSjeLwXM8wJxq+PdLWaHg40b9J
 pHrw==
X-Gm-Message-State: AJIora88uEr0E9S49pOO1E0oB2iz+32uxVanohHHUyTbTSrq9PtOvv5m
 A8qzHHTajlIiMy4DyDO6xgrOeSvu7W0P0wkn5A==
X-Google-Smtp-Source: AGRyM1s5cymxF5/2M5vXFAclyed+75vWvwbMa/H/SxWfjgxHei8pGcmW11dtGoK7T5A2HhMEXreSpy82wKmWy2XaFg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:282:b0:66e:26b0:8f16 with
 SMTP id v2-20020a056902028200b0066e26b08f16mr12192829ybh.469.1657865489758;
 Thu, 14 Jul 2022 23:11:29 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:19 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-11-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 10/18] KVM: arm64: Stub implementation of pKVM HYP stack
 unwinder
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, android-mm@google.com, andreyknvl@gmail.com,
 kernel-team@android.com, drjones@redhat.com,
 linux-arm-kernel@lists.infradead.org, russell.king@oracle.com,
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

Add some stub implementations of protected nVHE stack unwinder, for
building. These are implemented later in this series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/stacktrace/nvhe.h | 57 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/stacktrace.c     |  3 +-
 2 files changed, 58 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/stacktrace/nvhe.h

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
new file mode 100644
index 000000000000..1eac4e57f2ae
--- /dev/null
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * KVM nVHE hypervisor stack tracing support.
+ *
+ * The unwinder implementation depends on the nVHE mode:
+ *
+ *   1) pKVM (protected nVHE) mode - the host cannot directly access
+ *      the HYP memory. The stack is unwinded in EL2 and dumped to a shared
+ *      buffer where the host can read and print the stacktrace.
+ *
+ * Copyright (C) 2022 Google LLC
+ */
+#ifndef __ASM_STACKTRACE_NVHE_H
+#define __ASM_STACKTRACE_NVHE_H
+
+#include <asm/stacktrace/common.h>
+
+static inline bool on_accessible_stack(const struct task_struct *tsk,
+				       unsigned long sp, unsigned long size,
+				       struct stack_info *info)
+{
+	return false;
+}
+
+/*
+ * Protected nVHE HYP stack unwinder
+ */
+#ifdef __KVM_NVHE_HYPERVISOR__
+
+#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
+static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
+				     struct stack_info *info)
+{
+	return false;
+}
+
+static int notrace unwind_next(struct unwind_state *state)
+{
+	return 0;
+}
+NOKPROBE_SYMBOL(unwind_next);
+#else	/* !CONFIG_PROTECTED_NVHE_STACKTRACE */
+static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
+				     struct stack_info *info)
+{
+	return false;
+}
+
+static int notrace unwind_next(struct unwind_state *state)
+{
+	return 0;
+}
+NOKPROBE_SYMBOL(unwind_next);
+#endif	/* CONFIG_PROTECTED_NVHE_STACKTRACE */
+
+#endif	/* __KVM_NVHE_HYPERVISOR__ */
+#endif	/* __ASM_STACKTRACE_NVHE_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index 69e65b457f1c..96c8b93320eb 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -4,8 +4,7 @@
  *
  * Copyright (C) 2022 Google LLC
  */
-#include <asm/memory.h>
-#include <asm/percpu.h>
+#include <asm/stacktrace/nvhe.h>
 
 DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
 	__aligned(16);
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
