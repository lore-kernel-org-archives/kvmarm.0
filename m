Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA8DC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03A024BC48;
	Fri, 15 Jul 2022 02:11:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x4Hq-VaEfdmw; Fri, 15 Jul 2022 02:11:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07B1F4BC80;
	Fri, 15 Jul 2022 02:11:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78B274BC20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4QJ4cx6nVo0k for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:13 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08CDB4BC0C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:13 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b129-20020a25e487000000b0066e1c52ac55so3291768ybh.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=FYBq07VQ4DkWTq1d4ACftXBrb374xXzNK5S2gkLiMO4=;
 b=NLk/3Rkt1n9uJrc345lFPf00C8qzQsyt6y0eZMNx0g5v0lsiCyWYkQx9+2s0nx+FLY
 l7j3QQaH3ghXRvmcdL6PGLW5W9miUzv1T/9vOdwyAYy89tQ4GzXz6p2V30airVL0TRTT
 gaLDbMYbtao1xmyAPM316twHkn78kx1XbDcVfax/2vyIxWw1W37UN08gJVNKESNU8Oys
 3jH/VfxUi0as5R1vO3yh8Bbomq/4kTKHP8BA1NtAj2jLFtJU78Ld+givYs9UGzykLejf
 HyugqtinuF2BlKD1nkuiKiJvYxXkzhFLGM9aX0dGi4OaK2KgU1YGI4OpXw2Mssc0AWMc
 PTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FYBq07VQ4DkWTq1d4ACftXBrb374xXzNK5S2gkLiMO4=;
 b=rlYEwKEenKPE89ocC5m+I2ko/L0JGP3uT1waNDD8FecJ2klXtXFsy6karfIejMqybh
 eUBI1URpIG9GKD7hb3SG/sJxaErv3o9TLrXnulKEilW60evAwbDctqh+5+X/Y6KMP8Cm
 9QNzBepa1xprrLrhs/qjpZFOTb9Ub0FinkdRN571Wx4estrbfckUpmygA+7+nkPCb0RX
 HUkg3f0GzHIsNN/dMWAto/Ti+NHDSJ5YdMhP/GWZDyvjrZ3pzCUy1o5pdtWlmvmXPrTW
 2vsHaeTuEdY3HK+hlWiRTCOhrlia3ncZGhxACXIDhYEuTOHrbEdHMwNi2K5INNvu2sSl
 2SQQ==
X-Gm-Message-State: AJIora+dvGNY6SQfhngjfOKYxAWusT5HvEF85/JFAl5hMDU3W4IL0LSM
 PPVN6AyqhtGtT65hL+k3kZQ5ojOvhJ8Hnxi5pA==
X-Google-Smtp-Source: AGRyM1tJ1+XhW8SOFOo1j4XRkY2qov8EmHa+wSlCqK9/nwu8v8plCWadpgoj0f878y6UXleMAR/B6ETRxL9pzXJZ8w==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a25:2d57:0:b0:66e:497f:51e6 with SMTP
 id s23-20020a252d57000000b0066e497f51e6mr12368453ybe.251.1657865472764; Thu,
 14 Jul 2022 23:11:12 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:14 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-6-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 05/18] arm64: stacktrace: Factor out common unwind()
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

Move unwind() to stacktrace/common.h, and as a result
the kernel unwind_next() to asm/stacktrace.h. This allow
reusing unwind() in the implementation of the nVHE HYP
stack unwinder, later in the series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/stacktrace.h        | 51 ++++++++++++++++
 arch/arm64/include/asm/stacktrace/common.h | 19 ++++++
 arch/arm64/kernel/stacktrace.c             | 67 ----------------------
 3 files changed, 70 insertions(+), 67 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index a4f8b84fb459..4fa07f0f913d 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -11,6 +11,7 @@
 #include <linux/llist.h>
 
 #include <asm/memory.h>
+#include <asm/pointer_auth.h>
 #include <asm/ptrace.h>
 #include <asm/sdei.h>
 
@@ -78,4 +79,54 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 
 	return false;
 }
+
+/*
+ * Unwind from one frame record (A) to the next frame record (B).
+ *
+ * We terminate early if the location of B indicates a malformed chain of frame
+ * records (e.g. a cycle), determined based on the location and fp value of A
+ * and the location (but not the fp value) of B.
+ */
+static inline int notrace unwind_next(struct unwind_state *state)
+{
+	struct task_struct *tsk = state->task;
+	unsigned long fp = state->fp;
+	struct stack_info info;
+	int err;
+
+	/* Final frame; nothing to unwind */
+	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
+		return -ENOENT;
+
+	err = unwind_next_common(state, &info, NULL);
+	if (err)
+		return err;
+
+	state->pc = ptrauth_strip_insn_pac(state->pc);
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	if (tsk->ret_stack &&
+		(state->pc == (unsigned long)return_to_handler)) {
+		unsigned long orig_pc;
+		/*
+		 * This is a case where function graph tracer has
+		 * modified a return address (LR) in a stack frame
+		 * to hook a function return.
+		 * So replace it to an original value.
+		 */
+		orig_pc = ftrace_graph_ret_addr(tsk, NULL, state->pc,
+						(void *)state->fp);
+		if (WARN_ON_ONCE(state->pc == orig_pc))
+			return -EINVAL;
+		state->pc = orig_pc;
+	}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+#ifdef CONFIG_KRETPROBES
+	if (is_kretprobe_trampoline(state->pc))
+		state->pc = kretprobe_find_ret_addr(tsk, (void *)state->fp, &state->kr_cur);
+#endif
+
+	return 0;
+}
+NOKPROBE_SYMBOL(unwind_next);
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 5f5d74a286f3..f86efe71479d 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -9,6 +9,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
+#include <linux/kprobes.h>
 #include <linux/types.h>
 
 enum stack_type {
@@ -69,6 +70,8 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 				       unsigned long sp, unsigned long size,
 				       struct stack_info *info);
 
+static inline int unwind_next(struct unwind_state *state);
+
 static inline bool on_stack(unsigned long sp, unsigned long size,
 			    unsigned long low, unsigned long high,
 			    enum stack_type type, struct stack_info *info)
@@ -192,4 +195,20 @@ static inline int unwind_next_common(struct unwind_state *state,
 
 	return 0;
 }
+
+static inline void notrace unwind(struct unwind_state *state,
+				  stack_trace_consume_fn consume_entry,
+				  void *cookie)
+{
+	while (1) {
+		int ret;
+
+		if (!consume_entry(cookie, state->pc))
+			break;
+		ret = unwind_next(state);
+		if (ret < 0)
+			break;
+	}
+}
+NOKPROBE_SYMBOL(unwind);
 #endif	/* __ASM_STACKTRACE_COMMON_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index eef3cf6bf2d7..9fa60ee48499 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -7,14 +7,12 @@
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/ftrace.h>
-#include <linux/kprobes.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
 
 #include <asm/irq.h>
-#include <asm/pointer_auth.h>
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
@@ -69,71 +67,6 @@ static inline void unwind_init_from_task(struct unwind_state *state,
 	state->pc = thread_saved_pc(task);
 }
 
-/*
- * Unwind from one frame record (A) to the next frame record (B).
- *
- * We terminate early if the location of B indicates a malformed chain of frame
- * records (e.g. a cycle), determined based on the location and fp value of A
- * and the location (but not the fp value) of B.
- */
-static int notrace unwind_next(struct unwind_state *state)
-{
-	struct task_struct *tsk = state->task;
-	unsigned long fp = state->fp;
-	struct stack_info info;
-	int err;
-
-	/* Final frame; nothing to unwind */
-	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
-		return -ENOENT;
-
-	err = unwind_next_common(state, &info, NULL);
-	if (err)
-		return err;
-
-	state->pc = ptrauth_strip_insn_pac(state->pc);
-
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	if (tsk->ret_stack &&
-		(state->pc == (unsigned long)return_to_handler)) {
-		unsigned long orig_pc;
-		/*
-		 * This is a case where function graph tracer has
-		 * modified a return address (LR) in a stack frame
-		 * to hook a function return.
-		 * So replace it to an original value.
-		 */
-		orig_pc = ftrace_graph_ret_addr(tsk, NULL, state->pc,
-						(void *)state->fp);
-		if (WARN_ON_ONCE(state->pc == orig_pc))
-			return -EINVAL;
-		state->pc = orig_pc;
-	}
-#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-#ifdef CONFIG_KRETPROBES
-	if (is_kretprobe_trampoline(state->pc))
-		state->pc = kretprobe_find_ret_addr(tsk, (void *)state->fp, &state->kr_cur);
-#endif
-
-	return 0;
-}
-NOKPROBE_SYMBOL(unwind_next);
-
-static void notrace unwind(struct unwind_state *state,
-			   stack_trace_consume_fn consume_entry, void *cookie)
-{
-	while (1) {
-		int ret;
-
-		if (!consume_entry(cookie, state->pc))
-			break;
-		ret = unwind_next(state);
-		if (ret < 0)
-			break;
-	}
-}
-NOKPROBE_SYMBOL(unwind);
-
 static bool dump_backtrace_entry(void *arg, unsigned long where)
 {
 	char *loglvl = arg;
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
