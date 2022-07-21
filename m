Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB34EC43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:58:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 849564DA80;
	Thu, 21 Jul 2022 01:58:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0lpchnmwGTsu; Thu, 21 Jul 2022 01:58:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF3B04DA69;
	Thu, 21 Jul 2022 01:58:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DAAB4DA64
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pt9frivzhW1I for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:58:09 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5F034DA76
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:08 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 t10-20020a5b07ca000000b0066ec1bb6e2cso576987ybq.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4s5X/+YCEmbcnDUwCHy1+kT8bVMvMylr6BkPvcZOYaI=;
 b=Hn8tDDVc0jcMOfIfcL7Tu34q/rCTcA8rnhoPvX/kVCgOu3vXyuDDkfkT597nYfwbfp
 4ORIBESXdaMaeKjj+U19qYy2XGpQxAUT0bsM+BQretTXEB6PWKE9iqRxqc1HxgVvwTyv
 YBR+U/GgeyaOOAiDI2fE/vXex7Eo6fMwLqUJa27U4Yef2PWnHrh8LZbTHnOmpg67QL8D
 yTgQkqEUS92Ba6PkU2POCDZkstTHe5z/0JDT6Kxx7sbSgJ2m1J4lJv6xJ8MekVNKiZ6X
 koOKLyQNvI2jYg07OxqXuZRj5C4KdqD1MwZvvFWcWvHYVoKuh6/BK6s8uw6GYBwWV9KL
 0Brg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4s5X/+YCEmbcnDUwCHy1+kT8bVMvMylr6BkPvcZOYaI=;
 b=xaG8IArg+qfnMr9k488u1q2+FlycVqxyCuVtoSNaSOkwyPQReMAmpZ8a6B1shxFxgs
 dl9pqPI6LXo6TRQjmBqD6i/kwIU/Nv94O89Eou7peAMV+wCgEpM553YgeFrIiM9oEr8b
 3jVmeUJJRzgKvKla2bxkEF9g3lsYxcxguzGQI9WS4Hcu2wN11DeOvhmb38fldEK1Nayv
 R/CTJqYwXB773VN3pcg7GCZuOI/ACxVUrLamsYvtTUG9Jr09rVH3gglGIMmLrBgq0qLD
 eZ+qUg/dLQlotJSnE7jpPsGDsKWEqOs9rJBW3uRS5OZFFXbrnp3Uclj/mzKQzG95TbyW
 MErg==
X-Gm-Message-State: AJIora+E1KabZNg7Q2mw1j7R3olhWoHxK3juowoLTxiPEuvio1/DcsOQ
 lnyC1JIxJbVI0oxotvyEmNeC1WPPVdkEzFljxw==
X-Google-Smtp-Source: AGRyM1vTsife9M3jC/RGyzsoBBcL6UKgtSGPhy1mwndXgmrgVzbFMS42En18APbAoAXWfT95Wu4YGZ+TT/Ki5Tnxxw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:282:b0:66e:26b0:8f16 with
 SMTP id v2-20020a056902028200b0066e26b08f16mr39101418ybh.469.1658383088431;
 Wed, 20 Jul 2022 22:58:08 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:25 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-15-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 14/17] KVM: arm64: Implement protected nVHE hyp stack
 unwinder
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

Implements the common framework necessary for unwind() to work in
the protected nVHE context:
   - on_accessible_stack()
   - on_overflow_stack()
   - unwind_next()

Protected nVHE unwind() is used to unwind and save the hyp stack
addresses to the shared stacktrace buffer. The host reads the
entries in this buffer, symbolizes and dumps the stacktrace (later
patch in the series).

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/stacktrace/common.h |  2 ++
 arch/arm64/include/asm/stacktrace/nvhe.h   | 34 ++++++++++++++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index be7920ba70b0..73fd9e143c4a 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -34,6 +34,7 @@ enum stack_type {
 	STACK_TYPE_OVERFLOW,
 	STACK_TYPE_SDEI_NORMAL,
 	STACK_TYPE_SDEI_CRITICAL,
+	STACK_TYPE_HYP,
 	__NR_STACK_TYPES
 };
 
@@ -186,6 +187,7 @@ static inline int unwind_next_common(struct unwind_state *state,
 	 *
 	 * TASK -> IRQ -> OVERFLOW -> SDEI_NORMAL
 	 * TASK -> SDEI_NORMAL -> SDEI_CRITICAL -> OVERFLOW
+	 * HYP -> OVERFLOW
 	 *
 	 * ... but the nesting itself is strict. Once we transition from one
 	 * stack to another, it's never valid to unwind back to that first
diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index 8f02803a005f..c3688e717136 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -39,10 +39,19 @@ static inline void kvm_nvhe_unwind_init(struct unwind_state *state,
 	state->pc = pc;
 }
 
+static inline bool on_hyp_stack(unsigned long sp, unsigned long size,
+				struct stack_info *info);
+
 static inline bool on_accessible_stack(const struct task_struct *tsk,
 				       unsigned long sp, unsigned long size,
 				       struct stack_info *info)
 {
+	if (on_accessible_stack_common(tsk, sp, size, info))
+		return true;
+
+	if (on_hyp_stack(sp, size, info))
+		return true;
+
 	return false;
 }
 
@@ -60,12 +69,27 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
 				     struct stack_info *info)
 {
-	return false;
+	unsigned long low = (unsigned long)this_cpu_ptr(overflow_stack);
+	unsigned long high = low + OVERFLOW_STACK_SIZE;
+
+	return on_stack(sp, size, low, high, STACK_TYPE_OVERFLOW, info);
+}
+
+static inline bool on_hyp_stack(unsigned long sp, unsigned long size,
+				struct stack_info *info)
+{
+	struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
+	unsigned long high = params->stack_hyp_va;
+	unsigned long low = high - PAGE_SIZE;
+
+	return on_stack(sp, size, low, high, STACK_TYPE_HYP, info);
 }
 
 static inline int notrace unwind_next(struct unwind_state *state)
 {
-	return 0;
+	struct stack_info info;
+
+	return unwind_next_common(state, &info, NULL);
 }
 NOKPROBE_SYMBOL(unwind_next);
 #else	/* !CONFIG_PROTECTED_NVHE_STACKTRACE */
@@ -75,6 +99,12 @@ static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
 	return false;
 }
 
+static inline bool on_hyp_stack(unsigned long sp, unsigned long size,
+				struct stack_info *info)
+{
+	return false;
+}
+
 static inline int notrace unwind_next(struct unwind_state *state)
 {
 	return 0;
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
