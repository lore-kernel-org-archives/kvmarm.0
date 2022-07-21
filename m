Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC07BC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:57:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CE9C4D971;
	Thu, 21 Jul 2022 01:57:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H367OC6dd7jE; Thu, 21 Jul 2022 01:57:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 355284DA35;
	Thu, 21 Jul 2022 01:57:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C1834D832
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xbTV8+-YPyj7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:57:41 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F263F4D971
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:40 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31e6ffb03f6so6805077b3.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=hybHHJpNkr5qvVF2psrpE5ezfSg01aH1BSluCT+EV4I=;
 b=Gy3GT+AejE5lIqh2FM7HDqKdxCV2+m38IsmUpjEKK1QJmEoelcLR1wNLUpjwR0PQkT
 B/On8ku5ir8YgBuuIXV0lnVfrOyHsaNGO/oL7BybSdER3FWejp7+Df8wxKW/R20ChgQO
 0tgF+VaCWq69D/tqUhWzHS7NsjR7+BjUQboxtxC/mIamoEzuietAqDCS5WNaPh0NI1a7
 mrsgfg+J61pDYkEnH16ghZeVk38xPbU9JFqu4U396jprd1MwcgriPzJJOiokg7xUfE+x
 Rz6bdZ0FG+eKIe2YdXgj6+0uRXCSoNKy9bpzXtHHvJX1XzmnGuI3NqMkai5ZBhjlyTO5
 9Dfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=hybHHJpNkr5qvVF2psrpE5ezfSg01aH1BSluCT+EV4I=;
 b=pPg7dMZIw331ACe+lkyX1hh4u7s1prUn+sr4xt9JG6HwhXZhFudoVUAnRFvC0KSg1U
 FwAhQQpNUV3+KoE5t0HAedjgr0QV/aHP2dfUvVwNjPZCm324zBcOlRwsOrgJbadlIpPM
 KH+gGwINK2DZSkrWGWTv2Si76vyclIvwdqygC0ehSO6nFOWkgib1p5yAEEeqsfhYbbsU
 j4eo6eqE5OOjhxsS3zg+RFMKDQgO2Q5nYDxmSMDgdpiP6FpC6obPcOlbqpdjHBG658ei
 O8tV4iK0TKbkpsigSbflZqNn23DiHu6fM1U4dlL1rY9y2rgmokFzhBmnPviwouQ5OGIr
 O//Q==
X-Gm-Message-State: AJIora8gb2pb9l67C4cgI9QYm34r1A7tkMPNs2ReVj0sZfary2FuwgXv
 PUo78SRzRVonj4TcclACU47ehyLdMqAQ2I9dOQ==
X-Google-Smtp-Source: AGRyM1t7p5bQOsZ7cBIoy5YIYG4Vty+5ObB0xcGW4MddH7Fc9hMYX+1F2OdOwVc+nCl0IjFDFNgEYMiRjLwrtJHNPw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a25:d117:0:b0:670:7e79:e104 with SMTP
 id i23-20020a25d117000000b006707e79e104mr11309346ybg.528.1658383060543; Wed,
 20 Jul 2022 22:57:40 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:14 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-4-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 03/17] arm64: stacktrace: Factor out unwind_next_common()
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

Move common unwind_next logic to stacktrace/common.h. This allows
reusing the code in the implementation the nVHE hypervisor stack
unwinder, later in this series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---

Changes in v5:
  - Add Reviewed-by tags from Mark Brown and Fuad

 arch/arm64/include/asm/stacktrace/common.h | 50 ++++++++++++++++++++++
 arch/arm64/kernel/stacktrace.c             | 41 ++----------------
 2 files changed, 54 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index f58b786460d3..0c5cbfdb56b5 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -65,6 +65,10 @@ struct unwind_state {
 static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
 				     struct stack_info *info);
 
+static inline bool on_accessible_stack(const struct task_struct *tsk,
+				       unsigned long sp, unsigned long size,
+				       struct stack_info *info);
+
 static inline bool on_stack(unsigned long sp, unsigned long size,
 			    unsigned long low, unsigned long high,
 			    enum stack_type type, struct stack_info *info)
@@ -120,4 +124,50 @@ static inline void unwind_init_common(struct unwind_state *state,
 	state->prev_type = STACK_TYPE_UNKNOWN;
 }
 
+static inline int unwind_next_common(struct unwind_state *state,
+				     struct stack_info *info)
+{
+	struct task_struct *tsk = state->task;
+	unsigned long fp = state->fp;
+
+	if (fp & 0x7)
+		return -EINVAL;
+
+	if (!on_accessible_stack(tsk, fp, 16, info))
+		return -EINVAL;
+
+	if (test_bit(info->type, state->stacks_done))
+		return -EINVAL;
+
+	/*
+	 * As stacks grow downward, any valid record on the same stack must be
+	 * at a strictly higher address than the prior record.
+	 *
+	 * Stacks can nest in several valid orders, e.g.
+	 *
+	 * TASK -> IRQ -> OVERFLOW -> SDEI_NORMAL
+	 * TASK -> SDEI_NORMAL -> SDEI_CRITICAL -> OVERFLOW
+	 *
+	 * ... but the nesting itself is strict. Once we transition from one
+	 * stack to another, it's never valid to unwind back to that first
+	 * stack.
+	 */
+	if (info->type == state->prev_type) {
+		if (fp <= state->prev_fp)
+			return -EINVAL;
+	} else {
+		__set_bit(state->prev_type, state->stacks_done);
+	}
+
+	/*
+	 * Record this frame record's values and location. The prev_fp and
+	 * prev_type are only meaningful to the next unwind_next() invocation.
+	 */
+	state->fp = READ_ONCE(*(unsigned long *)(fp));
+	state->pc = READ_ONCE(*(unsigned long *)(fp + 8));
+	state->prev_fp = fp;
+	state->prev_type = info->type;
+
+	return 0;
+}
 #endif	/* __ASM_STACKTRACE_COMMON_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 94a5dd2ab8fd..834851939364 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -81,48 +81,15 @@ static int notrace unwind_next(struct unwind_state *state)
 	struct task_struct *tsk = state->task;
 	unsigned long fp = state->fp;
 	struct stack_info info;
+	int err;
 
 	/* Final frame; nothing to unwind */
 	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
 		return -ENOENT;
 
-	if (fp & 0x7)
-		return -EINVAL;
-
-	if (!on_accessible_stack(tsk, fp, 16, &info))
-		return -EINVAL;
-
-	if (test_bit(info.type, state->stacks_done))
-		return -EINVAL;
-
-	/*
-	 * As stacks grow downward, any valid record on the same stack must be
-	 * at a strictly higher address than the prior record.
-	 *
-	 * Stacks can nest in several valid orders, e.g.
-	 *
-	 * TASK -> IRQ -> OVERFLOW -> SDEI_NORMAL
-	 * TASK -> SDEI_NORMAL -> SDEI_CRITICAL -> OVERFLOW
-	 *
-	 * ... but the nesting itself is strict. Once we transition from one
-	 * stack to another, it's never valid to unwind back to that first
-	 * stack.
-	 */
-	if (info.type == state->prev_type) {
-		if (fp <= state->prev_fp)
-			return -EINVAL;
-	} else {
-		__set_bit(state->prev_type, state->stacks_done);
-	}
-
-	/*
-	 * Record this frame record's values and location. The prev_fp and
-	 * prev_type are only meaningful to the next unwind_next() invocation.
-	 */
-	state->fp = READ_ONCE(*(unsigned long *)(fp));
-	state->pc = READ_ONCE(*(unsigned long *)(fp + 8));
-	state->prev_fp = fp;
-	state->prev_type = info.type;
+	err = unwind_next_common(state, &info);
+	if (err)
+		return err;
 
 	state->pc = ptrauth_strip_insn_pac(state->pc);
 
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
