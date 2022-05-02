Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5832C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 19:12:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA594B152;
	Mon,  2 May 2022 15:12:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eibtTlwLx7Zh; Mon,  2 May 2022 15:12:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 315124B176;
	Mon,  2 May 2022 15:12:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B8BE4B131
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 15:12:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EYKPovLor8Zc for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 15:12:51 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 806F74A7FD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 15:12:51 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b6-20020a5b0b46000000b006457d921729so13891434ybr.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 12:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=SbkfFHwtj6LDfXcNEKyNCOiQxOwKu8gDiCPd3B2piLM=;
 b=EDJR3DTAX2eHb+n+nXs3NyHOQJ5iRpUPyz9W4sVPdLTKifwIuceSm9nqbUt+EAUjs8
 Uy7YZCVBjsQZMuZZcYGoCTs3O2Q/0PWU1nemxTVCkyltR+Pfraxqcm/Mij0yMMW/vQpX
 7o+MND69tDg8pttIB2MbNlqW61RbtG5ybH/CaNOoZlcGKOazY5whaBWWiNA+qS9nBW32
 lGox+qsH97d8T7BvUlXqz4iiarm8kZeWQnrhNR/mPh4JMvWU2LVL4KaXwOnrglgIsYjJ
 4umG8AwCaxD8GgaeNHACi79kPhW7xzf/d4gjHIFvgZyqSBDCJJIazbd++y+qCRLqv5Go
 POdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=SbkfFHwtj6LDfXcNEKyNCOiQxOwKu8gDiCPd3B2piLM=;
 b=mnUG8Lbq9I3vnYffJGS4bFObuDv+IBkqlp9Gz2S8QpbE+Tb4/Kgo2++h3rRwFuEVt6
 bqRe6AafSVv0/MlqOPjf7PWCuIV9E6Ni89S0DKcGG/5c1E7R0W1ud3aFgmf2Tsi+6CDX
 Bia6/9dav9aqNyN7JjqsGjByOeGKI6yfG6SpUr7edagx/XZlm4GbRHFF/ouQJoMsG+ar
 5K+aZIkjIpxPulwbNHNa4S6d0PH+984iPwiupYhOWmVThzme4miO94wXcy+kUHwK54Zk
 GbqwzBxnGgTDsRD3abAENcDsXQyz2SssibAk2kV25BdSTyrSpFVPiF5edFxpt9So56f/
 a5Dg==
X-Gm-Message-State: AOAM533ZYxdF0LfsbFL6yejOVigbk30XyNd4QCnTTDvb8PePhaBD3AxP
 OiBXhLm5H93AVR5ePr7khnUEYYWCV/O26JyY7w==
X-Google-Smtp-Source: ABdhPJxP2xIlP7KifAzH0zbmoPkFGlaCnGx7XBRgqtsRS8QtrsuRrH/CX2j863LkhO0OA3feG1oXuqpQ/Sp0DoMkEA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:55c:7548:7073:c14f])
 (user=kaleshsingh job=sendgmr) by 2002:a0d:e8c7:0:b0:2f4:cd95:76d8 with SMTP
 id r190-20020a0de8c7000000b002f4cd9576d8mr12025072ywe.55.1651518771017; Mon,
 02 May 2022 12:12:51 -0700 (PDT)
Date: Mon,  2 May 2022 12:12:01 -0700
In-Reply-To: <20220502191222.4192768-1-kaleshsingh@google.com>
Message-Id: <20220502191222.4192768-2-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220502191222.4192768-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 1/5] KVM: arm64: Factor out common stack unwinding logic
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Marco Elver <elver@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 surenb@google.com, broonie@kernel.org, Peter Collingbourne <pcc@google.com>,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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

Factor out the stack unwinding logic common to both the host kernel and
the nVHE hypersivor into __unwind_next(). This allows for reuse in the
nVHE hypervisor stack unwinding (later in this series).

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/kernel/stacktrace.c | 36 +++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 0467cb79f080..ee60c279511c 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -81,23 +81,19 @@ NOKPROBE_SYMBOL(unwind_init);
  * records (e.g. a cycle), determined based on the location and fp value of A
  * and the location (but not the fp value) of B.
  */
-static int notrace unwind_next(struct task_struct *tsk,
-			       struct unwind_state *state)
+static int notrace __unwind_next(struct task_struct *tsk,
+				 struct unwind_state *state,
+				 struct stack_info *info)
 {
 	unsigned long fp = state->fp;
-	struct stack_info info;
-
-	/* Final frame; nothing to unwind */
-	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
-		return -ENOENT;
 
 	if (fp & 0x7)
 		return -EINVAL;
 
-	if (!on_accessible_stack(tsk, fp, 16, &info))
+	if (!on_accessible_stack(tsk, fp, 16, info))
 		return -EINVAL;
 
-	if (test_bit(info.type, state->stacks_done))
+	if (test_bit(info->type, state->stacks_done))
 		return -EINVAL;
 
 	/*
@@ -113,7 +109,7 @@ static int notrace unwind_next(struct task_struct *tsk,
 	 * stack to another, it's never valid to unwind back to that first
 	 * stack.
 	 */
-	if (info.type == state->prev_type) {
+	if (info->type == state->prev_type) {
 		if (fp <= state->prev_fp)
 			return -EINVAL;
 	} else {
@@ -127,7 +123,25 @@ static int notrace unwind_next(struct task_struct *tsk,
 	state->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
 	state->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
 	state->prev_fp = fp;
-	state->prev_type = info.type;
+	state->prev_type = info->type;
+
+	return 0;
+}
+NOKPROBE_SYMBOL(__unwind_next);
+
+static int notrace unwind_next(struct task_struct *tsk,
+			       struct unwind_state *state)
+{
+	struct stack_info info;
+	int err;
+
+	/* Final frame; nothing to unwind */
+	if (state->fp == (unsigned long)task_pt_regs(tsk)->stackframe)
+		return -ENOENT;
+
+	err = __unwind_next(tsk, state, &info);
+	if (err)
+		return err;
 
 	state->pc = ptrauth_strip_insn_pac(state->pc);
 
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
