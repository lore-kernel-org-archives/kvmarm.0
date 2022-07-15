Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39278C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D57AC4BA92;
	Fri, 15 Jul 2022 02:11:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S3kPmfUioOEs; Fri, 15 Jul 2022 02:11:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9A804BC48;
	Fri, 15 Jul 2022 02:11:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 144654BC31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sp30VoJz45WK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:03 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC0604BC20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:03 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b129-20020a25e487000000b0066e1c52ac55so3291571ybh.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Own2o6tbvKIuIfDt6RX1YCvxnzH3pv8ZlCIH8Z843R8=;
 b=gfo5C0kAFY/DhTYcpdsweNWRc6amIrJNxK2I6HRtQ1uRYwQkM+g/8EfbXv8Jei6Dy9
 Z3OVhzTJCmCJBhLoGzA9ZSot85i+TAuxQmWGFXx5Oxrac0FoumywLrg0LuCX2qshququ
 bohBvC4W75iypt1b+ihRn+heB0no3yJOzheWD8OObzEQnVAqJYoA8CKmaRG68INYPpM5
 05WxGrtJapF4xGy2z4Lb0aC8BzBtubmgLcikBRK4ApIBr+yIQuvngHlV0EgD66e1LJ+E
 AMUJAXWxOsxqa9IaVKLx/kLcperTi5N3cXEJav8qwYoRzXZO4chjjIzjRDp7i8keLZJQ
 37Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Own2o6tbvKIuIfDt6RX1YCvxnzH3pv8ZlCIH8Z843R8=;
 b=62cKIhmvZw4hd/oBRc72imv2xjrMcktODtUQ0L4J7JzDs1u7uklObgf8Cwvq6m13Q3
 0Cvj/u4T5FC9jcWW0CpJCXiNg3IA4i15HMzDF58nemrsar0Pqf2nqVn/mCuRHc4U83Uk
 +43wfAhqXHukPVXiUp7QkSe77DulgPZCk1uvSV16DInVNLh2UxoVa2xcg2VNlvj9Ied6
 hmy1xY3zwpxPC3ptF3Z0xWQrpEEBViEHlHp1V1z1zIVuo+Oz7A27uFwyS46Sqra8F8cy
 QLzxDwgYSA8vMNbZA7yz77zu+aXRpsfNZf9Bf5nZdmQoVYUPXMs47NmpGpoMwFXYHEKO
 YSxg==
X-Gm-Message-State: AJIora/gDpy46sARoxCQ08sg39G39wl5hKw2RZv6rOdHgP0i9GGivOJX
 83WNcZ9PoMe8tQGKN+yg/Hl+NrVLdbbgvduL0Q==
X-Google-Smtp-Source: AGRyM1toginxWVu828tmbdDVi6RqxU4m5ogiI5wsF/cD/T/ASSWS9NG8+M6vpw5CwwLtUUF5ffU/O7fWHtDB+TCoLA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a0d:c547:0:b0:31b:d6fa:c05c with SMTP
 id h68-20020a0dc547000000b0031bd6fac05cmr14137326ywd.105.1657865463413; Thu,
 14 Jul 2022 23:11:03 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:13 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-5-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 04/18] arm64: stacktrace: Handle frame pointer from
 different address spaces
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

The unwinder code is made reusable so that it can be used to
unwind various types of stacks. One usecase is unwinding the
nVHE hyp stack from the host (EL1) in non-protected mode. This
means that the unwinder must be able to tracnslate HYP stack
addresses to kernel addresses.

Add a callback (stack_trace_translate_fp_fn) to allow specifying
the translation function.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/stacktrace/common.h | 26 ++++++++++++++++++++--
 arch/arm64/kernel/stacktrace.c             |  2 +-
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 0c5cbfdb56b5..5f5d74a286f3 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -123,9 +123,22 @@ static inline void unwind_init_common(struct unwind_state *state,
 	state->prev_fp = 0;
 	state->prev_type = STACK_TYPE_UNKNOWN;
 }
+/**
+ * stack_trace_translate_fp_fn() - Translates a non-kernel frame pointer to
+ * a kernel address.
+ *
+ * @fp:   the frame pointer to be updated to it's kernel address.
+ * @type: the stack type associated with frame pointer @fp
+ *
+ * Returns true and success and @fp is updated to the corresponding
+ * kernel virtual address; otherwise returns false.
+ */
+typedef bool (*stack_trace_translate_fp_fn)(unsigned long *fp,
+					    enum stack_type type);
 
 static inline int unwind_next_common(struct unwind_state *state,
-				     struct stack_info *info)
+				     struct stack_info *info,
+				     stack_trace_translate_fp_fn translate_fp)
 {
 	struct task_struct *tsk = state->task;
 	unsigned long fp = state->fp;
@@ -159,13 +172,22 @@ static inline int unwind_next_common(struct unwind_state *state,
 		__set_bit(state->prev_type, state->stacks_done);
 	}
 
+	/* Record fp as prev_fp before attempting to get the next fp */
+	state->prev_fp = fp;
+
+	/*
+	 * If fp is not from the current address space perform the necessary
+	 * translation before dereferencing it to get the next fp.
+	 */
+	if (translate_fp && !translate_fp(&fp, info->type))
+		return -EINVAL;
+
 	/*
 	 * Record this frame record's values and location. The prev_fp and
 	 * prev_type are only meaningful to the next unwind_next() invocation.
 	 */
 	state->fp = READ_ONCE(*(unsigned long *)(fp));
 	state->pc = READ_ONCE(*(unsigned long *)(fp + 8));
-	state->prev_fp = fp;
 	state->prev_type = info->type;
 
 	return 0;
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 834851939364..eef3cf6bf2d7 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -87,7 +87,7 @@ static int notrace unwind_next(struct unwind_state *state)
 	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
 		return -ENOENT;
 
-	err = unwind_next_common(state, &info);
+	err = unwind_next_common(state, &info, NULL);
 	if (err)
 		return err;
 
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
