Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5782C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:10:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F3B84BB9F;
	Fri, 15 Jul 2022 02:10:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zi-PDaLNBbKg; Fri, 15 Jul 2022 02:10:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98DA24BC80;
	Fri, 15 Jul 2022 02:10:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5047D4BBE6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:10:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 254i8H4U7iTm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:10:36 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 182664BBE0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:10:36 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 c7-20020a258807000000b0066d6839741eso3298600ybl.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HwPTm6cmxu9zJXjSHjPz49JaMF8MztZgzIWe/cJ+deE=;
 b=Z3zQjpPDiRsDOnp5dDl1GRJwMvY87HgUwdl0j3CSd+VpRKjoClSRyeMLjaJep5115R
 DBeCAIIkFz6OCl7XTKhwsUTqotNv8xGpbXkoldYm0q//4woWStURAOVbCoj+7WJsjXL9
 /zCQ0od5ZsSU7isO7m3a380zlVBKQ98kJkp1EEubvlQogyBvSds1KHxUuyihgbI4DZFQ
 7jg+p0Re5JrfdxV3tD1DwB4Dv/sOdelLp5ZxaZHAqrcn5E2G5jbwzfBbd60SM+e2HKuw
 MGOWY6pFUCK2GEIWFI1PcqPGK72EinGGpI7hh0LvcIJ4Fn+Gjx4dYM3Jw1HuIlK0JR8r
 afTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HwPTm6cmxu9zJXjSHjPz49JaMF8MztZgzIWe/cJ+deE=;
 b=AB3mloSKEr2CxGMMnarCc/azIe18GHMglzhVzD4xpd1Glp3Wb4NQZX06IwvhTkcplI
 smXbu7FM/ftRukr2Zn5gGfAK2ggucgvdwH94Z1JSjwzs1ZyXrd7o2qdWpVJpbk0OTcb2
 zbjg4D+T7OgUl7bfATkX2+R+sPMv1H4L2kBDhiHMKwyCAJ3bJRNIPNPd2g6H6xt2HlYK
 s+0vrFA+ZifaiNjmHMXUx50efDhrrAC6LZGgadHzlkz1SwrhItfhXUZRHuQeePP+x/Om
 amf+lTN8qx11i8vRZpxR7Esk3nat4fE14CkigqzkdCgNK/n0p8XKVYL9Ja42QoAfqjQM
 L47A==
X-Gm-Message-State: AJIora8DsOkJLn+s7nspQyHDygYIv28R6JF4dtKZ/fvzIbCmpH+y+lzW
 3OR0Fk1ILJtMNcb+bPMIPNHP9Vj1Mp27dDH14A==
X-Google-Smtp-Source: AGRyM1uQsnm9sZo0q5d9K7/udtHT67wBvEUrThfObqq+hDgims8clShXazzHT77SMjEPhS9aYSgaY5BdxHGEM8HEWw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a81:b80c:0:b0:31c:8cfc:cbc0 with SMTP
 id v12-20020a81b80c000000b0031c8cfccbc0mr14308532ywe.157.1657865435586; Thu,
 14 Jul 2022 23:10:35 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:10 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-2-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 01/18] arm64: stacktrace: Add shared header for common
 stack unwinding code
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

In order to reuse the arm64 stack unwinding logic for the nVHE
hypervisor stack, move the common code to a shared header
(arch/arm64/include/asm/stacktrace/common.h).

The nVHE hypervisor cannot safely link against kernel code, so we
make use of the shared header to avoid duplicated logic later in
this series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/stacktrace.h        |  35 +------
 arch/arm64/include/asm/stacktrace/common.h | 105 +++++++++++++++++++++
 arch/arm64/kernel/stacktrace.c             |  57 -----------
 3 files changed, 106 insertions(+), 91 deletions(-)
 create mode 100644 arch/arm64/include/asm/stacktrace/common.h

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index aec9315bf156..79f455b37c84 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -8,52 +8,19 @@
 #include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
-#include <linux/types.h>
 #include <linux/llist.h>
 
 #include <asm/memory.h>
 #include <asm/ptrace.h>
 #include <asm/sdei.h>
 
-enum stack_type {
-	STACK_TYPE_UNKNOWN,
-	STACK_TYPE_TASK,
-	STACK_TYPE_IRQ,
-	STACK_TYPE_OVERFLOW,
-	STACK_TYPE_SDEI_NORMAL,
-	STACK_TYPE_SDEI_CRITICAL,
-	__NR_STACK_TYPES
-};
-
-struct stack_info {
-	unsigned long low;
-	unsigned long high;
-	enum stack_type type;
-};
+#include <asm/stacktrace/common.h>
 
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
 			   const char *loglvl);
 
 DECLARE_PER_CPU(unsigned long *, irq_stack_ptr);
 
-static inline bool on_stack(unsigned long sp, unsigned long size,
-			    unsigned long low, unsigned long high,
-			    enum stack_type type, struct stack_info *info)
-{
-	if (!low)
-		return false;
-
-	if (sp < low || sp + size < sp || sp + size > high)
-		return false;
-
-	if (info) {
-		info->low = low;
-		info->high = high;
-		info->type = type;
-	}
-	return true;
-}
-
 static inline bool on_irq_stack(unsigned long sp, unsigned long size,
 				struct stack_info *info)
 {
diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
new file mode 100644
index 000000000000..64ae4f6b06fe
--- /dev/null
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Common arm64 stack unwinder code.
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ */
+#ifndef __ASM_STACKTRACE_COMMON_H
+#define __ASM_STACKTRACE_COMMON_H
+
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/types.h>
+
+enum stack_type {
+	STACK_TYPE_UNKNOWN,
+	STACK_TYPE_TASK,
+	STACK_TYPE_IRQ,
+	STACK_TYPE_OVERFLOW,
+	STACK_TYPE_SDEI_NORMAL,
+	STACK_TYPE_SDEI_CRITICAL,
+	__NR_STACK_TYPES
+};
+
+struct stack_info {
+	unsigned long low;
+	unsigned long high;
+	enum stack_type type;
+};
+
+/*
+ * A snapshot of a frame record or fp/lr register values, along with some
+ * accounting information necessary for robust unwinding.
+ *
+ * @fp:          The fp value in the frame record (or the real fp)
+ * @pc:          The lr value in the frame record (or the real lr)
+ *
+ * @stacks_done: Stacks which have been entirely unwound, for which it is no
+ *               longer valid to unwind to.
+ *
+ * @prev_fp:     The fp that pointed to this frame record, or a synthetic value
+ *               of 0. This is used to ensure that within a stack, each
+ *               subsequent frame record is at an increasing address.
+ * @prev_type:   The type of stack this frame record was on, or a synthetic
+ *               value of STACK_TYPE_UNKNOWN. This is used to detect a
+ *               transition from one stack to another.
+ *
+ * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
+ *               associated with the most recently encountered replacement lr
+ *               value.
+ *
+ * @task:        The task being unwound.
+ */
+struct unwind_state {
+	unsigned long fp;
+	unsigned long pc;
+	DECLARE_BITMAP(stacks_done, __NR_STACK_TYPES);
+	unsigned long prev_fp;
+	enum stack_type prev_type;
+#ifdef CONFIG_KRETPROBES
+	struct llist_node *kr_cur;
+#endif
+	struct task_struct *task;
+};
+
+static inline bool on_stack(unsigned long sp, unsigned long size,
+			    unsigned long low, unsigned long high,
+			    enum stack_type type, struct stack_info *info)
+{
+	if (!low)
+		return false;
+
+	if (sp < low || sp + size < sp || sp + size > high)
+		return false;
+
+	if (info) {
+		info->low = low;
+		info->high = high;
+		info->type = type;
+	}
+	return true;
+}
+
+static inline void unwind_init_common(struct unwind_state *state,
+				      struct task_struct *task)
+{
+	state->task = task;
+#ifdef CONFIG_KRETPROBES
+	state->kr_cur = NULL;
+#endif
+
+	/*
+	 * Prime the first unwind.
+	 *
+	 * In unwind_next() we'll check that the FP points to a valid stack,
+	 * which can't be STACK_TYPE_UNKNOWN, and the first unwind will be
+	 * treated as a transition to whichever stack that happens to be. The
+	 * prev_fp value won't be used, but we set it to 0 such that it is
+	 * definitely not an accessible stack address.
+	 */
+	bitmap_zero(state->stacks_done, __NR_STACK_TYPES);
+	state->prev_fp = 0;
+	state->prev_type = STACK_TYPE_UNKNOWN;
+}
+
+#endif	/* __ASM_STACKTRACE_COMMON_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index fcaa151b81f1..94a5dd2ab8fd 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -18,63 +18,6 @@
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
-/*
- * A snapshot of a frame record or fp/lr register values, along with some
- * accounting information necessary for robust unwinding.
- *
- * @fp:          The fp value in the frame record (or the real fp)
- * @pc:          The lr value in the frame record (or the real lr)
- *
- * @stacks_done: Stacks which have been entirely unwound, for which it is no
- *               longer valid to unwind to.
- *
- * @prev_fp:     The fp that pointed to this frame record, or a synthetic value
- *               of 0. This is used to ensure that within a stack, each
- *               subsequent frame record is at an increasing address.
- * @prev_type:   The type of stack this frame record was on, or a synthetic
- *               value of STACK_TYPE_UNKNOWN. This is used to detect a
- *               transition from one stack to another.
- *
- * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
- *               associated with the most recently encountered replacement lr
- *               value.
- *
- * @task:        The task being unwound.
- */
-struct unwind_state {
-	unsigned long fp;
-	unsigned long pc;
-	DECLARE_BITMAP(stacks_done, __NR_STACK_TYPES);
-	unsigned long prev_fp;
-	enum stack_type prev_type;
-#ifdef CONFIG_KRETPROBES
-	struct llist_node *kr_cur;
-#endif
-	struct task_struct *task;
-};
-
-static void unwind_init_common(struct unwind_state *state,
-			       struct task_struct *task)
-{
-	state->task = task;
-#ifdef CONFIG_KRETPROBES
-	state->kr_cur = NULL;
-#endif
-
-	/*
-	 * Prime the first unwind.
-	 *
-	 * In unwind_next() we'll check that the FP points to a valid stack,
-	 * which can't be STACK_TYPE_UNKNOWN, and the first unwind will be
-	 * treated as a transition to whichever stack that happens to be. The
-	 * prev_fp value won't be used, but we set it to 0 such that it is
-	 * definitely not an accessible stack address.
-	 */
-	bitmap_zero(state->stacks_done, __NR_STACK_TYPES);
-	state->prev_fp = 0;
-	state->prev_type = STACK_TYPE_UNKNOWN;
-}
-
 /*
  * Start an unwind from a pt_regs.
  *
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
