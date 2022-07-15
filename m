Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8088CCA482
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8456F4BDD7;
	Fri, 15 Jul 2022 02:11:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V8CJE22xIaTL; Fri, 15 Jul 2022 02:11:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A7474BDE6;
	Fri, 15 Jul 2022 02:11:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ED414BC4C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u+n5vqw9yr+7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:41 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 190584BDD8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:40 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31c88e36c0bso34052717b3.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Aen+FkdIlH4p9Bga5nOuPk26qtzTJbITGhY4IEaQl1E=;
 b=Kl/Wb7az0Dpk964K/t53obqM+aCIu3rAPB8Mi4lFae6KU/yHzI081j9LkXEZvLEs5F
 MPJViYowMIzNBQddAvvw7Po85N97ikHIUNw2aCqDw4i0AXDa82B4v1KEU83z8qseqlST
 HTZXzVTx3cEKvN3jrQAGdDnMKiiAgo4UkwjXsn09TeVUtUfosl4u4YQzK7dAc35q0KiF
 K6rSEFoTr7QPg89dMkQWTWdYZMsZfSwVCROcIJWnD/ArXlt2GsZXHYJeqHpcyX2uz6SL
 H7qz9XZxaBwBvC2Fh/vPGLAMM6u3TCdO9kkrMhmIrKu0QEl1nu32DcC3LA/cIr2Y6+19
 rXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Aen+FkdIlH4p9Bga5nOuPk26qtzTJbITGhY4IEaQl1E=;
 b=h5MPuSJm3Rv+V7Y6LDaMZCiJ+DJE5zT9CBnASfUpO8oZgiv76nF/6+FWCZK2CYXEJ9
 ArzJlsgppqsBiGyb3XzSWJHMXS9jbRevzC6Fa6L77sQK+0yGrymeliGkSgKQeAn1wsyJ
 L4wqNypAcSphq6AuraUUEQbV/ARp24FERA2rkHwKy/mi7VzcFVR87Cj0n8fh+M4bVUgM
 bt3oCFyZKtrhoqcXnmqsHP1DIxNVqs+xomBmkMIAJoTGe9O3AHj2JWKaYglr0yd1EaT0
 y8+u5CC19FIaL/NkLfi3Bv93N+WAMuIanvkuYBc8RJeLNGt3jcIbB6OXZvCcvT1brbNr
 vfvw==
X-Gm-Message-State: AJIora8Ag5+iEur9GE/Tv+xmLqCp02aG1i/bhok5kslOqQHQp6mih945
 FWVH+GLCN2fGYJ87Hts2dBTu5F94qbz1Ir3Z1g==
X-Google-Smtp-Source: AGRyM1u/PT8LdM4OlzT2z2Ts/bIUkpNGqVgHGqY8xhTai+zpsROBqKpKpWbwRpuEkJh/W1ny4LwrRcq2gKzotGoM5Q==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:849:0:b0:66e:a027:3c with SMTP id
 v9-20020a5b0849000000b0066ea027003cmr11796208ybq.208.1657865499596; Thu, 14
 Jul 2022 23:11:39 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:23 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-15-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 14/18] KVM: arm64: Implement protected nVHE hyp stack
 unwinder
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
index b362086f4c70..cf442e67dccd 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -27,6 +27,7 @@ enum stack_type {
 	STACK_TYPE_OVERFLOW,
 	STACK_TYPE_SDEI_NORMAL,
 	STACK_TYPE_SDEI_CRITICAL,
+	STACK_TYPE_HYP,
 	__NR_STACK_TYPES
 };
 
@@ -171,6 +172,7 @@ static inline int unwind_next_common(struct unwind_state *state,
 	 *
 	 * TASK -> IRQ -> OVERFLOW -> SDEI_NORMAL
 	 * TASK -> SDEI_NORMAL -> SDEI_CRITICAL -> OVERFLOW
+	 * HYP -> OVERFLOW
 	 *
 	 * ... but the nesting itself is strict. Once we transition from one
 	 * stack to another, it's never valid to unwind back to that first
diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index 1aadfd8d7ac9..c7c8ac889ec1 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -38,10 +38,19 @@ static __always_inline void kvm_nvhe_unwind_init(struct unwind_state *state,
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
 
@@ -59,12 +68,27 @@ extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
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
 
 static int notrace unwind_next(struct unwind_state *state)
 {
-	return 0;
+	struct stack_info info;
+
+	return unwind_next_common(state, &info, NULL);
 }
 NOKPROBE_SYMBOL(unwind_next);
 #else	/* !CONFIG_PROTECTED_NVHE_STACKTRACE */
@@ -74,6 +98,12 @@ static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
 	return false;
 }
 
+static inline bool on_hyp_stack(unsigned long sp, unsigned long size,
+				struct stack_info *info)
+{
+	return false;
+}
+
 static int notrace unwind_next(struct unwind_state *state)
 {
 	return 0;
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
