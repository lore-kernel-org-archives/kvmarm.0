Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FA7C43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:57:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF3A24DA37;
	Thu, 21 Jul 2022 01:57:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XGxycwKzpdsk; Thu, 21 Jul 2022 01:57:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 544054DA1E;
	Thu, 21 Jul 2022 01:57:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F5F4D832
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cxGPfEdo8Arx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:57:43 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99BED4D6F0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:43 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 l6-20020a25bf86000000b00668c915a3f2so589655ybk.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BrC0iFUi7vnhcT+nMUoOxg3oXGqYAC5+3i/gvJsLlbw=;
 b=SBHl0MnAKRFV5/9Cx0u9IGW1uKO26lo5LpMs/VKqDXqZhOUXW2q5KRdxO6ttiP3nDu
 0Ss8X8zAd7TS0qW4woYj8Mjk96gW1L50N3DM2DUASrIbtpsq92qGZVMoMSgieuWz2Wrm
 8cjfA/1BLtzpfvEgXZVCWeoF4ywAgZq0n8dt5kaCexB/mncyP9CD+WPCJYmygQFLEL33
 Rubo2DNaZC9AKNomceQdKYajP5aPFZijnBFtGYU96f6i9aM5TaiflC0BGzgKuEnV2cn4
 FN+Y5kmROrmAnRggZj9Vx3Lfcde7qoDWA9mly3RVHb6AJq54+dMsmrBrkvmtidf8Lt14
 BxOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BrC0iFUi7vnhcT+nMUoOxg3oXGqYAC5+3i/gvJsLlbw=;
 b=ToZlDbBrz8XeK9nTZ37ViURcr+gfBYKYQ/F5y7Xu4m5XDGnmvQUol4erLUfnWyejMw
 GS1sbh+bgdikmWGKRqnmQyA1qYr+drmuhuJ18onGUbSVVmqM3rQZF8PexDg5YaKTgErP
 7vx5SJQGHiWAEomLzIBo2I6g4MUoiRvNySbxg2bU9Ga2sp20RTQdNxc2MfnDGNlqeFuN
 Pqh9tiCEKKh56wfp+eaT358cuuYTodJUu20v2yreXbDbqHXiS8WM/5q7+TorN4r/hN0M
 HfFrCsq/3wpV9q/lahrYg5+iguR3aUpAnitRkxy2kt8HBuMYKrqh8G7c5JBo7eGV02FG
 m6AA==
X-Gm-Message-State: AJIora8vHL5Y71OjsTuvVOVhbNJTf94G62dJDuhfr9DxZMx8vpybLl51
 kvkB9OwWoujpU6tPnQOxKiq8r2sZ7Ljo+IcoRw==
X-Google-Smtp-Source: AGRyM1s6dEnzSM/TjATo5XryVR3TbDiGD8oaFkh/6JrgATgoBXNgg6oZxo446DCtWSijqKIcoJISLrUkRSBrVKoaaQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a81:4e04:0:b0:31e:5782:ed76 with SMTP
 id c4-20020a814e04000000b0031e5782ed76mr13240666ywb.183.1658383063172; Wed,
 20 Jul 2022 22:57:43 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:15 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-5-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 04/17] arm64: stacktrace: Handle frame pointer from
 different address spaces
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

The unwinder code is made reusable so that it can be used to
unwind various types of stacks. One usecase is unwinding the
nVHE hyp stack from the host (EL1) in non-protected mode. This
means that the unwinder must be able to translate HYP stack
addresses to kernel addresses.

Add a callback (stack_trace_translate_fp_fn) to allow specifying
the translation function.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v5:
  - Fix typo in commit text, per Fuad
  - Update unwind_next_common() to not have side effects on failure, per Fuad
  - Use regular comment instead of doc comments, per Fuad

 arch/arm64/include/asm/stacktrace/common.h | 29 +++++++++++++++++++---
 arch/arm64/kernel/stacktrace.c             |  2 +-
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 0c5cbfdb56b5..e89c8c39858d 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -124,11 +124,25 @@ static inline void unwind_init_common(struct unwind_state *state,
 	state->prev_type = STACK_TYPE_UNKNOWN;
 }
 
+/*
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
+
 static inline int unwind_next_common(struct unwind_state *state,
-				     struct stack_info *info)
+				     struct stack_info *info,
+				     stack_trace_translate_fp_fn translate_fp)
 {
+	unsigned long fp = state->fp, kern_fp = fp;
 	struct task_struct *tsk = state->task;
-	unsigned long fp = state->fp;
 
 	if (fp & 0x7)
 		return -EINVAL;
@@ -139,6 +153,13 @@ static inline int unwind_next_common(struct unwind_state *state,
 	if (test_bit(info->type, state->stacks_done))
 		return -EINVAL;
 
+	/*
+	 * If fp is not from the current address space perform the necessary
+	 * translation before dereferencing it to get the next fp.
+	 */
+	if (translate_fp && !translate_fp(&kern_fp, info->type))
+		return -EINVAL;
+
 	/*
 	 * As stacks grow downward, any valid record on the same stack must be
 	 * at a strictly higher address than the prior record.
@@ -163,8 +184,8 @@ static inline int unwind_next_common(struct unwind_state *state,
 	 * Record this frame record's values and location. The prev_fp and
 	 * prev_type are only meaningful to the next unwind_next() invocation.
 	 */
-	state->fp = READ_ONCE(*(unsigned long *)(fp));
-	state->pc = READ_ONCE(*(unsigned long *)(fp + 8));
+	state->fp = READ_ONCE(*(unsigned long *)(kern_fp));
+	state->pc = READ_ONCE(*(unsigned long *)(kern_fp + 8));
 	state->prev_fp = fp;
 	state->prev_type = info->type;
 
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
