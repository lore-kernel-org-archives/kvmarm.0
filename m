Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87097C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:58:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F86D4DA60;
	Thu, 21 Jul 2022 01:58:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qBtizD07vtGl; Thu, 21 Jul 2022 01:58:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 473F54DA64;
	Thu, 21 Jul 2022 01:58:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A90604D8AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6gNeOCz1l9qr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:57:58 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D8384DA4B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:58 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31e60b8bb07so6822527b3.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=/uwhBcl2d0wd6dxTVJiUUqJSQ7KfqpT1oTO144kMEdg=;
 b=BWqTOdX0ZIZ5zMm9VbYz1xMo06XHQHmhBqBdZFqXLyASFYZjsNE0fFUJrAsotKVH2h
 XJ7hnW52HME2xg7ReZn6rVjK2osnE0jb/K5QlqNipgjkKtb2cl59Qo9j03gCasGmJ1Dz
 juzPZNdDyUki1Nl7gMr8C8xcc3zmItqQLlBdzUKbzgx6Z9BCZggI7WpumSn2X8NpsikN
 Al4RWHWjPLmEgPPSEw4HJe4fxQeNejE3gTySW3+FilDGT5zBLX4fkZKiY/WCg2vsjjZI
 20fJzOdm9yjBIiPMnknkrQIGVupnOa68FqKEeobAjDieK1E+aWmxh3/BRiXSRfNAKWLp
 etqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/uwhBcl2d0wd6dxTVJiUUqJSQ7KfqpT1oTO144kMEdg=;
 b=F7qegbzTut9WgqStv9dxO4a1X/oGxoQUq/KkjuKEfPiIvldQB/UanI74Zy6i8pyKKH
 3I1jxsZD9I+VrVzp+2T2M6TNgXYbSQqp0QRhQckYF0zwFtbP1o0UisBMqhMNFqu/aV3O
 8M9gLrgE3RvRwzuncB3J5nXCJ7s/ZDxKv+sV0TPqM8YNOVNeXOdENcQoMMfnoHyg1set
 Hme9M1GBOGMu+Vk7GMnmextUF9MCNyKaoOP8kysVnv9++wV+5eY2nAKaLdz37XoJVXSX
 4GLd11repSezC/rVsOHOTiG/bXaDqom2qSksLGjWI1gBHoKWpFTXZOsBJ2xPMubF1eTL
 VYnA==
X-Gm-Message-State: AJIora9FFVzhMEiumvz6jPKZ4s0dDdRHge2yQa9wd57WjEWXZFFV8L+h
 3gWA4uiMpk4amN64GbyUAwNC8MXyCcxxdBILhg==
X-Google-Smtp-Source: AGRyM1uyhPISg+ylS606kbQmjVcPYblSh0zIWTy2KDjhJBy7OL6s9V2L9bR+SAwwb9z1QoXAfY2vMc1gsnfMDuOPFg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a0d:d8ce:0:b0:31e:545c:7343 with SMTP
 id a197-20020a0dd8ce000000b0031e545c7343mr14812233ywe.29.1658383078088; Wed,
 20 Jul 2022 22:57:58 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:21 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-11-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 10/17] KVM: arm64: Stub implementation of pKVM HYP stack
 unwinder
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, drjones@redhat.com,
 ast@kernel.org, linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
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

Changes in v5:
  - Mark unwind_next() as inline, per Marc

 arch/arm64/include/asm/stacktrace/nvhe.h | 59 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/stacktrace.c     |  3 +-
 2 files changed, 60 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/stacktrace/nvhe.h

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
new file mode 100644
index 000000000000..80d71932afff
--- /dev/null
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -0,0 +1,59 @@
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
+#ifdef __KVM_NVHE_HYPERVISOR__
+/*
+ * Protected nVHE HYP stack unwinder
+ *
+ * In protected mode, the unwinding is done by the hypervisor in EL2.
+ */
+
+#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
+static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
+				     struct stack_info *info)
+{
+	return false;
+}
+
+static inline int notrace unwind_next(struct unwind_state *state)
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
+static inline int notrace unwind_next(struct unwind_state *state)
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
