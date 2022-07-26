Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14288C43334
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4C724C536;
	Tue, 26 Jul 2022 03:38:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q1iWyp1+fPlB; Tue, 26 Jul 2022 03:38:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CBEB4C538;
	Tue, 26 Jul 2022 03:38:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FE684C548
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OCY4e-hmfMxX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:03 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19A624C536
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:03 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 s186-20020a255ec3000000b0067162ed1bd3so2183686ybb.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=5LzygoxYBmX52V1I8A5Hvt/OcxOdlEMYc0Y930yUiBQ=;
 b=lxba6zPS8bNj3T4SQ4NgtR3spXvbVhLqKPcx1Hc782Lm9/xnxi+CiSSlzu4yrB+6Ob
 +nmlTtMJekStORm3jx3MPu7T8RpB2I3EFhmAMg67K2+TOyWtvgD8ceXd2DZEz98cp+tB
 AHbCkifdg/jPtMKpNDl63zHG7jkWkO4I6Mrp++lQyYGmqJhbb8+2J+8O3jJTXddAXJze
 hzHbAAZxokWC+22wtYsQGG0iXfr3iYegpLoWC3Za44kxt61yZtjlHL5W74mLLRp4HBVo
 2PURIJR3vLCK3lvSW66LOdSgAoZIvwAkopq9F1Qr9I8F1VaYKVLQYLvCnqkmvISyVhlB
 8OpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=5LzygoxYBmX52V1I8A5Hvt/OcxOdlEMYc0Y930yUiBQ=;
 b=D4yiwez8BcVdTj/G1W+EmPCyJKk44lUvfM8JavolHV4XbX+LBi1DQVjgiziZQECm5h
 qsmQ3BIdrjPSteJXkDiBfcqgvNubaptyXJGXOkaZaRiIE7MN53ywtL5u+Bdhh0zkDKqq
 HRS77Srpd3wy3FEj0lXIteDRi28bAfp7ptmbUxYvvt+YwFPewh6VbvP+LoCu4PSmFYSW
 s4rc+qk1LErGtIpjPoYYMVouEX7yfPiTx0wkZFQrJ51nZA0raibL70HSEYH2+ee0gNRL
 BGLDOzs3iUSchwnzcLEJRjlzDWmkcBw+6RlkpA+6OsFjOdrdq3Gs4YSVitLlJzANcd9W
 5YbA==
X-Gm-Message-State: AJIora+heG3JruiiQ0Ad8d3cNqlNWxECfmSASt+ocsietiV/cTtrHG6s
 oeQBCDvqWjIqGWq7hX7hokTVzICTCCoLG/EptA==
X-Google-Smtp-Source: AGRyM1vLCGxSpACfvit1h9qHAotszBcN5RiBC0/VBQZAO/C3DHxhNjsQIs2RUsZ7LNGl/jujBDMD9xrWPH2wZ/0Q7A==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a25:4c9:0:b0:671:6f60:eed8 with SMTP
 id 192-20020a2504c9000000b006716f60eed8mr1683033ybe.243.1658821082719; Tue,
 26 Jul 2022 00:38:02 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:36 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-4-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 03/17] arm64: stacktrace: Factor out unwind_next_common()
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

Move common unwind_next logic to stacktrace/common.h. This allows
reusing the code in the implementation the nVHE hypervisor stack
unwinder, later in this series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Fuad Tabba <tabba@google.com>
---

Changes in v6:
  - Add Fuad's Tested-by tag

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
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
