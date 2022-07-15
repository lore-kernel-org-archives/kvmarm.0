Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BDCCCA47C
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:10:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A77344BC45;
	Fri, 15 Jul 2022 02:10:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1tIu7eouW9yo; Fri, 15 Jul 2022 02:10:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F3994BC1E;
	Fri, 15 Jul 2022 02:10:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B88E4BBB7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:10:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LpLvGbdj1Wcy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:10:39 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AE3A4BB9F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:10:39 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31c9d560435so33841387b3.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=/Ia+O9M0Pz2+/05x4XoBRaUcJqadaj8Ww7ydsZGTIyc=;
 b=AsFH83JSc75pqQLjhwbkNC5eEmbVMfMhBpPhg7rjc25BQstmijhQMgTA+PPbxJYlqN
 QPVHh8kifhnzc58ChmI3fgEyNUKltfrMrL+ztxu2EOY7NCdrkHxnV8NMvG/wC3CD+uXU
 dAxvUDRaBJDjKtmTWDjl5DPdd+gPLE/+RiY4lPMa2oGT1tRuMwcgcIPgFOqRKpNBMp9d
 Khxf6sFE2z9CYuQWyepW9GSGfVixtwjnqotLqhBTyVuYzQxt7DIX7fontQfVBdI7aFon
 MuJbSY7lOoXOx555VBK2EWAbxAa10joar+VP9GpSz11xwuxaKieYJDSmFvWw+Kh7aS+7
 lQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/Ia+O9M0Pz2+/05x4XoBRaUcJqadaj8Ww7ydsZGTIyc=;
 b=hZinRrhjqUsgQUMjzzsSisD92EqwSzTcN09KbKwgYz+qq0Ea9T2WzNgrUMwSVDZOWJ
 wAAcm6/b3+OzzZVVy2rYcEcZUfHaQvxaQeIwXEW5EB9Bv7gzujy43aU4sM/Hw52DH65a
 o2070DtZmkd9cD4Yjl1vZvwyWZwROxG3M/vdhOcm/X06MJdLqQv9hn37+2FTiEO6P0db
 L3fwBbsTmwMmQ7Ki4oVfQ7UmeIoTKNSHvsT+y6uTmFxq0+r+p2BuSGFpN2mRL+B82dI+
 ELJ0xZIEK8/islpERaaPwNMy+uEI2p43iPh/ufCd+OrvDFN8Cob3cuWO9byJVTRj6La4
 AzDA==
X-Gm-Message-State: AJIora9shZcLzISyuUi8FCMGHTg2OE3pXshDJRD7oLqedbdGEltBWbx9
 RCUFGYWJeAYU186KzONNEJzHJXFUJvnrF1RDqw==
X-Google-Smtp-Source: AGRyM1vQf/Bx1CweucDNGXThIQceIJF3jerLq31SSlQ4DRKoZzzVX77BCd9Mi+GQ+qVz+MEqdkAvXKVOyWEjNha+Qg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a0d:f647:0:b0:31d:17cc:3337 with SMTP
 id g68-20020a0df647000000b0031d17cc3337mr14046493ywf.100.1657865438690; Thu,
 14 Jul 2022 23:10:38 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:11 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-3-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 02/18] arm64: stacktrace: Factor out
 on_accessible_stack_common()
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

Move common on_accessible_stack checks to stacktrace/common.h. This is
used in the implementation of the nVHE hypervisor unwinder later in
this series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/stacktrace.h        |  8 ++------
 arch/arm64/include/asm/stacktrace/common.h | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 79f455b37c84..a4f8b84fb459 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -56,7 +56,6 @@ static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
 			struct stack_info *info) { return false; }
 #endif
 
-
 /*
  * We can only safely access per-cpu stacks from current in a non-preemptible
  * context.
@@ -65,8 +64,8 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 				       unsigned long sp, unsigned long size,
 				       struct stack_info *info)
 {
-	if (info)
-		info->type = STACK_TYPE_UNKNOWN;
+	if (on_accessible_stack_common(tsk, sp, size, info))
+		return true;
 
 	if (on_task_stack(tsk, sp, size, info))
 		return true;
@@ -74,12 +73,9 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 		return false;
 	if (on_irq_stack(sp, size, info))
 		return true;
-	if (on_overflow_stack(sp, size, info))
-		return true;
 	if (on_sdei_stack(sp, size, info))
 		return true;
 
 	return false;
 }
-
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 64ae4f6b06fe..f58b786460d3 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -62,6 +62,9 @@ struct unwind_state {
 	struct task_struct *task;
 };
 
+static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
+				     struct stack_info *info);
+
 static inline bool on_stack(unsigned long sp, unsigned long size,
 			    unsigned long low, unsigned long high,
 			    enum stack_type type, struct stack_info *info)
@@ -80,6 +83,21 @@ static inline bool on_stack(unsigned long sp, unsigned long size,
 	return true;
 }
 
+static inline bool on_accessible_stack_common(const struct task_struct *tsk,
+					      unsigned long sp,
+					      unsigned long size,
+					      struct stack_info *info)
+{
+	if (info)
+		info->type = STACK_TYPE_UNKNOWN;
+
+	/*
+	 * Both the kernel and nvhe hypervisor make use of
+	 * an overflow_stack
+	 */
+	return on_overflow_stack(sp, size, info);
+}
+
 static inline void unwind_init_common(struct unwind_state *state,
 				      struct task_struct *task)
 {
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
