Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3647FCCA488
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:57:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE7234D2C3;
	Thu, 21 Jul 2022 01:57:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o4bNELPO24Xl; Thu, 21 Jul 2022 01:57:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 189624D8AF;
	Thu, 21 Jul 2022 01:57:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AA194D6F0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cS3wWyFVoq+E for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:57:38 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88F9C4D2C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:38 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 k13-20020a056902024d00b0066fa7f50b97so582893ybs.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iuiJRZjPzVH9NFZXc2I6eZu6HPWoG6DIfc9zwIk6fqU=;
 b=Ub0rmGKgsPw/uAZ4GGpi1VBT46ThpqEdpr2mq5eMvygSt80XqgB/W48o9TC1s3+qQS
 v7DHcG2nDxfhoyg2sVyhfTK1tZgdAmY8h3XLPAHmTVUmOr+REfo2lm37KSYFn0DZJkoo
 fAPXgIdDJaieSrl96TjbUmS0Apzy9/IwJS8MSzDEGhlEf7kVwIHmY/AvMqDSAb+r/3un
 HTJoGcKhknLgg8DBNTgbWSM0ot1aggOfhqWLlmPxSAmrPvtDYz+yzz9CQiaZcUjI8f8z
 +PfBftcQ+q2R/jPuE6SyZ1Jp8dLREhbSOn5/T3iKFcDQF9YB2nUogVbKGT7n3tY7Yb+f
 IBvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iuiJRZjPzVH9NFZXc2I6eZu6HPWoG6DIfc9zwIk6fqU=;
 b=iFbdbwJwaFb09LuipWh1XM/PCAPVyFFaGvdmS13sMNnAAvYjfd3V7xZy+hrPmqAU3K
 2lq/smiPlbwj3QX8B8JuF2je+uD1i7nhTp4OhyqPSJMeZlNm+wnesx1XaCvwayDNk3D3
 E30ycqUlvvGWiqMuSqyZqdkkBtS9Ao+J3PzdZ7ncohwz2a7kUWB9VDaSSryToEIfG+Ag
 5y13v0nDGq7kzhfbDEylkuGd9IuHVEQaJWVZFqJkfl+QfVkWeXbVdW3JWEgrRBwlZVA1
 cl0Lgu9FteAsiCq8E2v940ii9oW3E4msChRhUwsAHUBAgGWH8i81dzgyLy7nL4n3B+Xp
 Dmag==
X-Gm-Message-State: AJIora/H/Xj8xk1F9455ezSvHgu2J3ghI7Ud/v+aASCq9inHb5lLIgkE
 XMY786nFWSTLsnlCYVOqtdg8DRrtD0t7o0Q5mg==
X-Google-Smtp-Source: AGRyM1vGT8w8+qyglCyqqsexhhFl2xh/RNXpV9KZJmAlMvxnjkqvinTizqBBiGxZFk68SWeE0uI4FjmfcyDRZ1sZmg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:114d:b0:66d:9fa6:4bd4 with
 SMTP id p13-20020a056902114d00b0066d9fa64bd4mr37315370ybu.362.1658383058157;
 Wed, 20 Jul 2022 22:57:38 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:13 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-3-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 02/17] arm64: stacktrace: Factor out
 on_accessible_stack_common()
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

Move common on_accessible_stack checks to stacktrace/common.h. This is
used in the implementation of the nVHE hypervisor unwinder later in
this series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---

Changes in v5:
  - Add Reviewed-by tags from Mark Brown and Fuad
  - Remove random whitespace change, per Mark Brown

 arch/arm64/include/asm/stacktrace.h        |  6 ++----
 arch/arm64/include/asm/stacktrace/common.h | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 79f455b37c84..43f4b4a6d383 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -65,8 +65,8 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 				       unsigned long sp, unsigned long size,
 				       struct stack_info *info)
 {
-	if (info)
-		info->type = STACK_TYPE_UNKNOWN;
+	if (on_accessible_stack_common(tsk, sp, size, info))
+		return true;
 
 	if (on_task_stack(tsk, sp, size, info))
 		return true;
@@ -74,8 +74,6 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 		return false;
 	if (on_irq_stack(sp, size, info))
 		return true;
-	if (on_overflow_stack(sp, size, info))
-		return true;
 	if (on_sdei_stack(sp, size, info))
 		return true;
 
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
