Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8160CC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30A844C53A;
	Tue, 26 Jul 2022 03:38:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q+ieEvoAU4XE; Tue, 26 Jul 2022 03:38:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D65364C54C;
	Tue, 26 Jul 2022 03:38:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92F974C536
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Une604a1DEsl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:00 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56ABC4C53B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:00 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 z6-20020a056902054600b00670e3c8b43fso8388382ybs.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HJlaI56zFqTbz4E9QM1JRki26p1CmhrJ0ldLZAGD5Gc=;
 b=Hg/ba+twU69xuQeTauHfGh1xd/IG5mrk63mhJ8YbvAnkIYauk5mYLezBlA1CBAAwo5
 iudwXyj1NFecmdhOgDc713Mpd26tUbphRGBTx9y6x3SGfN+p2OKUD22cbjv1uK0Zs2iK
 7n537VLpecnFLR32XUyFwgB3FNRhMtF/cc8+8rqGN3vGNoImYNblyhe1sxYMZIG5lzi1
 sx9avbYpCLnTFekr6sLBtneCRMNiIRO9FkeJ79AvkazD6dHzX0TGFnDTV7OdwpiJ+6TE
 YS8w/xFCmTCZs1aYynybx790r1vSYJn2pkRV1zejr+IyokyYFn7uf1IPyeW8bkGwewTz
 uyvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HJlaI56zFqTbz4E9QM1JRki26p1CmhrJ0ldLZAGD5Gc=;
 b=z2QCz14OuQHYMjqisgRDgOkginiOgJMnCeFTyV1q91RPm+wgeMDFpFwDw2vAQdcea3
 hykKmShb/YeIRthfHebHj/zYtgpj6TdU3zeFLvxUL0Pnl2HhhbfdLwQuYW7B59VXyw4q
 8xqOWBTT9PGSEBrJZ0IyUq2JFX0CJgHkd3S0LKGHdZjv9QGD2ezikZ0Ok4Fv4nbRewl3
 c7CUaaTu2WvpugnrT06iR/LPbxZegW0/xvWzUVHbQyMW1aKeBznt0ePEck2AzpFN7PsV
 kOVwdX1xjRWv5yBvkWA0yDX8y7rwnaWz/7f+Wkom6ltdeWOlvmBqsLwJGwAnOmELjif9
 TzyA==
X-Gm-Message-State: AJIora88MXokToIfMlBvMjWgP0QgWkyClB8SNw16L7R2ENRl5XLsUN/I
 I7X+PSDlRWQWks68/tH6hSn2HRRS0f4PV2h47g==
X-Google-Smtp-Source: AGRyM1sij8eAETksDM9PJQAcvuFaOFZtWgM4fTTWZ/PJWmBJUpgq02OLuiPRM+zMspwuXb4dIPzCV3Wazxh9bcMfGw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a25:80d3:0:b0:66f:5da5:204f with SMTP
 id c19-20020a2580d3000000b0066f5da5204fmr12492060ybm.30.1658821079950; Tue,
 26 Jul 2022 00:37:59 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:35 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-3-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 02/17] arm64: stacktrace: Factor out
 on_accessible_stack_common()
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

Move common on_accessible_stack checks to stacktrace/common.h. This is
used in the implementation of the nVHE hypervisor unwinder later in
this series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Fuad Tabba <tabba@google.com>
---

Changes in v6:
  - Add Fuad's Tested-by tag

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
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
