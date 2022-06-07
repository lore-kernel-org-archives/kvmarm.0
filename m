Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDBCC43334
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 16:51:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C9854B24C;
	Tue,  7 Jun 2022 12:51:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W+6uxNN2eNET; Tue,  7 Jun 2022 12:51:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 203554B2FB;
	Tue,  7 Jun 2022 12:51:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF5854B283
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 12:51:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qFa4v69inwyJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 12:51:39 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 883ED4B116
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 12:51:39 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 p78-20020a254251000000b006607e0a2965so10647639yba.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Jun 2022 09:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=utThYmevKONU/9m2pQGdDHA12doEH9idunElwn0Wp+Y=;
 b=gUIQMQl0JQzhYd3S4fyRf5XmWfJe5lmGtNGJawPlt9xGCh6iVfChXa73AoojCUrlbl
 IVXeOtMoTYUHDpAFH3A8brBwPVcti7T1TXiYbRGm9WL+wI2w1S/KEwaSu9WutVR9tygx
 84Kvg+VfGwL6M1f0ziUNEjgMhLSuSnn44AbVKJ9wncUs/50JTgmnIHf+wQmtrOV7M8Mt
 K4uO5mPCKZewDVjZ3Ihsg/rY8/0Ud5jqcoTKOFhCTALO+vhAlMfVTPQqBzexRVTQ5AE6
 AWpm7eIByU/UruiBwIFFfpmgXXAyJwhbholwIR4cxXKH/anXN/52PMZ9cQYrHOq/XYDw
 pDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=utThYmevKONU/9m2pQGdDHA12doEH9idunElwn0Wp+Y=;
 b=u1d4NKZ33VFY6Kf6bH6IstRY6tESMeeYsIYGS8y25jLOeTFY/Edt1MFyHYdjZRHlH6
 RtCyc0TpDRlzCzvd5t4hCCDMwku4O/fnAMZ6uHtDdd0MKst31R2/d0fUcM8geFtKayP/
 1QG9ttD5MgdJ2maS+abGAS8wTPxbGNWmw0WKMhTd27Uczr+7nWoaMCNI1/9xMc0u7+sX
 1v0bhb307L9HM1n1Fpx3gKpW/JA6KNN0L6kGF8MHypwuPWOKj6Smo+VSIW5FIfrxDAHQ
 sQn+2yn08F30r3XQBPPJVt2DMn4TsOuV4md1guR2Lchy/TndCYelu6MrcYMobad71vM1
 fjZg==
X-Gm-Message-State: AOAM531kMtoI6c+R6Po9Iq9IQVxXaUdSByYBoyZmQa6UC1US7DpfX+dG
 ZhNxXucmhHlG4NUJGaSusCv5vcnejv0hPNIlNQ==
X-Google-Smtp-Source: ABdhPJzuHcHlzERjFFs10J5b1VKR548pg9LJge0vp7jHTNhan1WTvDRj/6ZH8ppj3YV0piRTv9xwQbWhp9qkOIWgBQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:7091:8518:ec1e:93dc])
 (user=kaleshsingh job=sendgmr) by 2002:a81:57d6:0:b0:30c:a234:140d with SMTP
 id l205-20020a8157d6000000b0030ca234140dmr33093505ywb.269.1654620698862; Tue,
 07 Jun 2022 09:51:38 -0700 (PDT)
Date: Tue,  7 Jun 2022 09:50:43 -0700
In-Reply-To: <20220607165105.639716-1-kaleshsingh@google.com>
Message-Id: <20220607165105.639716-2-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220607165105.639716-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v3 1/5] KVM: arm64: Factor out common stack unwinding logic
From: Kalesh Singh <kaleshsingh@google.com>
To: mark.rutland@arm.com, broonie@kernel.org, maz@kernel.org
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marco Elver <elver@google.com>,
 will@kernel.org, surenb@google.com, kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Alexei Starovoitov <ast@kernel.org>, tjmercier@google.com,
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
Reviewed-by: Mark Brown <broonie@kernel.org>
---

Changes in v3:
  - Add Mark's Reviewed-by tag

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
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
