Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD6DC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 19:13:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97D714B215;
	Mon,  2 May 2022 15:13:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YLytqZh0tbtz; Mon,  2 May 2022 15:13:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69DCF4B17C;
	Mon,  2 May 2022 15:13:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B0934B152
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 15:13:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gPRcdO3spvVk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 15:13:21 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A46D4A7FD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 15:13:21 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2f16f3a7c34so142233127b3.17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 12:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=/bI0RHeA8Y22AxlgXD6e7A4C/dpyc69T8IyS6sPGv90=;
 b=Sin22pZTsc6T28/VmcgGpYyXlwVEiagPVH8gGRdS/r6ZVMcYq/l2DNUbd/UH3/QkMs
 p/+gTtCY/niBNLAhJoOefVSsFKMM/c88SL89BSA63IuZ3cfwvFI08P1OuK2RdvCjzLBr
 qUF5qcGV6Jm4e/6av+f1gHU3a/JMtMVlOJq7Pwez5ECfb3fFshKATFmMwKNSeqhaIqih
 GGyUCCT+tOf9J+gG8j+J9OY5cZ6Ar1kGTxdP/i+tJ8C9N14Pz00FT+93lrTfUmI2IwA1
 bcCqJVJLvVrn/IbXgTc9dXoasshF+XmU0MAULG1/ZyGr4YYiQrdw3idt7UIQ/kHY2hGo
 MhwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=/bI0RHeA8Y22AxlgXD6e7A4C/dpyc69T8IyS6sPGv90=;
 b=3Ec2TN/pqYYLmJja3eqvoGFGCw5CHs0XGj8aTAATQXHa3Kd5mb6dZo2kUMolMz8Gru
 tYJ6Ct2GR+4ZGFpSR/InjmZ3m8dqwx83OtbdKuR+YhJV8ZeS22pnAZdqxArikyPNPm9T
 36sUrxW9N2Kr7TjLQ1A8FcOEdztSOdzZoAfKmTXp24dIx2GyjiAXl8AoJrQSXMkG4HEJ
 tKSbHhHqNKTiBeV1qGuxyr+uS1tXEOJ1nIzQN712f3ErSUFVKvnMFhxDvbgZh3o7/Uut
 X7+YURlEko+Ny7kRuyx1A4FloYPTv6dfAKDp/9x5CBj4KH+5dMJDRyB3OfUNSwXpJtu/
 85wQ==
X-Gm-Message-State: AOAM530b7vc6SVBsBOLNiN1lANOQ46UeXK0GDKdtyQ2DGPmvZToVNbHi
 iU5r36QZC9PE9Iwg3t3QRVNfWDvYKYbBQkRghg==
X-Google-Smtp-Source: ABdhPJwG8Jc3ZMgFFAnwpm1gcq8vn2y4rF+jHDc6argwAd5erYSjH3fDQtoG+c1wfL+lxMconIh1ekRrY/pl2Qm63w==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:55c:7548:7073:c14f])
 (user=kaleshsingh job=sendgmr) by 2002:a25:e792:0:b0:645:7ddb:b5eb with SMTP
 id e140-20020a25e792000000b006457ddbb5ebmr11745947ybh.482.1651518800615; Mon,
 02 May 2022 12:13:20 -0700 (PDT)
Date: Mon,  2 May 2022 12:12:02 -0700
In-Reply-To: <20220502191222.4192768-1-kaleshsingh@google.com>
Message-Id: <20220502191222.4192768-3-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220502191222.4192768-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 2/5] KVM: arm64: Compile stacktrace.nvhe.o
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Marco Elver <elver@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
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

Recompile stack unwinding code for use with the nVHE hypervisor. This is
a preparatory patch that will allow reusing most of the kernel unwinding
logic in the nVHE hypervisor.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v2:
  - Split out refactoring of common unwinding logic into a separate patch,
    per Mark Brown

 arch/arm64/include/asm/stacktrace.h | 18 +++++++++-----
 arch/arm64/kernel/stacktrace.c      | 37 ++++++++++++++++-------------
 arch/arm64/kvm/hyp/nvhe/Makefile    |  3 ++-
 3 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index aec9315bf156..f5af9a94c5a6 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -16,12 +16,14 @@
 #include <asm/sdei.h>
 
 enum stack_type {
-	STACK_TYPE_UNKNOWN,
+#ifndef __KVM_NVHE_HYPERVISOR__
 	STACK_TYPE_TASK,
 	STACK_TYPE_IRQ,
 	STACK_TYPE_OVERFLOW,
 	STACK_TYPE_SDEI_NORMAL,
 	STACK_TYPE_SDEI_CRITICAL,
+#endif /* !__KVM_NVHE_HYPERVISOR__ */
+	STACK_TYPE_UNKNOWN,
 	__NR_STACK_TYPES
 };
 
@@ -31,11 +33,6 @@ struct stack_info {
 	enum stack_type type;
 };
 
-extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
-			   const char *loglvl);
-
-DECLARE_PER_CPU(unsigned long *, irq_stack_ptr);
-
 static inline bool on_stack(unsigned long sp, unsigned long size,
 			    unsigned long low, unsigned long high,
 			    enum stack_type type, struct stack_info *info)
@@ -54,6 +51,12 @@ static inline bool on_stack(unsigned long sp, unsigned long size,
 	return true;
 }
 
+#ifndef __KVM_NVHE_HYPERVISOR__
+extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
+			   const char *loglvl);
+
+DECLARE_PER_CPU(unsigned long *, irq_stack_ptr);
+
 static inline bool on_irq_stack(unsigned long sp, unsigned long size,
 				struct stack_info *info)
 {
@@ -88,6 +91,7 @@ static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
 static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
 			struct stack_info *info) { return false; }
 #endif
+#endif /* !__KVM_NVHE_HYPERVISOR__ */
 
 
 /*
@@ -101,6 +105,7 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 	if (info)
 		info->type = STACK_TYPE_UNKNOWN;
 
+#ifndef __KVM_NVHE_HYPERVISOR__
 	if (on_task_stack(tsk, sp, size, info))
 		return true;
 	if (tsk != current || preemptible())
@@ -111,6 +116,7 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 		return true;
 	if (on_sdei_stack(sp, size, info))
 		return true;
+#endif /* !__KVM_NVHE_HYPERVISOR__ */
 
 	return false;
 }
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index ee60c279511c..a84e38d41d38 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -129,6 +129,26 @@ static int notrace __unwind_next(struct task_struct *tsk,
 }
 NOKPROBE_SYMBOL(__unwind_next);
 
+static int notrace unwind_next(struct task_struct *tsk,
+			       struct unwind_state *state);
+
+static void notrace unwind(struct task_struct *tsk,
+			   struct unwind_state *state,
+			   stack_trace_consume_fn consume_entry, void *cookie)
+{
+	while (1) {
+		int ret;
+
+		if (!consume_entry(cookie, state->pc))
+			break;
+		ret = unwind_next(tsk, state);
+		if (ret < 0)
+			break;
+	}
+}
+NOKPROBE_SYMBOL(unwind);
+
+#ifndef __KVM_NVHE_HYPERVISOR__
 static int notrace unwind_next(struct task_struct *tsk,
 			       struct unwind_state *state)
 {
@@ -171,22 +191,6 @@ static int notrace unwind_next(struct task_struct *tsk,
 }
 NOKPROBE_SYMBOL(unwind_next);
 
-static void notrace unwind(struct task_struct *tsk,
-			   struct unwind_state *state,
-			   stack_trace_consume_fn consume_entry, void *cookie)
-{
-	while (1) {
-		int ret;
-
-		if (!consume_entry(cookie, state->pc))
-			break;
-		ret = unwind_next(tsk, state);
-		if (ret < 0)
-			break;
-	}
-}
-NOKPROBE_SYMBOL(unwind);
-
 static bool dump_backtrace_entry(void *arg, unsigned long where)
 {
 	char *loglvl = arg;
@@ -238,3 +242,4 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 
 	unwind(task, &state, consume_entry, cookie);
 }
+#endif /* !__KVM_NVHE_HYPERVISOR__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index f9fe4dc21b1f..c0ff0d6fc403 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -14,7 +14,8 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o \
+	 ../../../kernel/stacktrace.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
