Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C2CC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 18:48:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5AB44B17C;
	Wed, 27 Apr 2022 14:47:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wC0C+Fs0ZUGb; Wed, 27 Apr 2022 14:47:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 582AD4B183;
	Wed, 27 Apr 2022 14:47:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A7BA408F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:47:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CN+h0vz-hiPJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 14:47:56 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E88A4089E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:47:56 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2f825f8c944so24268467b3.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 11:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=fd6rMU9yqWWeAt9OZ2FqZhtlChWn8Za3hhMR5JrXjl8=;
 b=g/8e3IN0KagfolpJ4ruEAWQvaAufar6vLj47xotGnSf8mMZjVOlNIEEiZSYg/TyXli
 y1cTgzqP1K6Pdoe+qSvha0OKdiUMQpWYTcmuiOKOP3mu4F3LxJYx/xXtG/TGYioaaUQz
 GZzpV+hBQT6uppGReMBCQnIjFqVZS5a+FuC5ZhuuteRQ31C9I1Pp4d3dqvgjOaXst0Lf
 NY2LD9CeD57+6skYrVb5cJRCoZr8AzISEIPPfFUIwP5b4nCpqxsIkRbXegw4YzfDSgan
 PIE637wzT91aGH/VdAk/EhJSxBY1c4k4WJICtOwh4RBJbTly7BRw4GB72vCvovLouaDo
 JKUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=fd6rMU9yqWWeAt9OZ2FqZhtlChWn8Za3hhMR5JrXjl8=;
 b=XxAY2HRTtyvAQJaDAVNWirw4pGIBQ12mmG7oQeRORNhsuXlEOUeQfg9zY1vgNfhXNs
 m3sxs5FS3oBdxXruExUCRifiw0iniIqZCMKVSHcZVW60YQozD8k2celF6VJu9VHRFh6A
 3LKYJZpryyozSi6iDPD8tPPYBSnDmtNI3eLrwLh+sFTdNymMqLj06Zt4gq+7B2CnRY96
 rguBaC/mdfpuFej92tLx15nG8/7EYMpiOfQO7qqFSZMcN0B2O63yT0UtzI54WoFyR5kR
 IwDbmEgTC6+7dfcVqP2k2Zqm+MrmsOFTT54kQWDfGbquf3et1SHL0k/IDB8FfUz7ZtcG
 M8qg==
X-Gm-Message-State: AOAM532W5iYfDYeenxXGEjlw9cE1cdY9jtIerocb3ICu0WpFB89jYHOQ
 YkD1AIiRnypR8jNlCgu+IUbnYqa2LQWctAZRpA==
X-Google-Smtp-Source: ABdhPJyOdBmB4vZPfSZNHktzrjvSV3WgelUopqbYoPUTMVI8+cnDshbn+jqXWwUIw/SzQtu2NNUcE7qT5WdN23ottA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:16ec:6da0:8cc5:5f24])
 (user=kaleshsingh job=sendgmr) by 2002:a25:6652:0:b0:645:d4c1:eb7 with SMTP
 id z18-20020a256652000000b00645d4c10eb7mr25152746ybm.412.1651085275548; Wed,
 27 Apr 2022 11:47:55 -0700 (PDT)
Date: Wed, 27 Apr 2022 11:46:56 -0700
In-Reply-To: <20220427184716.1949239-1-kaleshsingh@google.com>
Message-Id: <20220427184716.1949239-2-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220427184716.1949239-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 1/4] KVM: arm64: Compile stacktrace.nvhe.o
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-kernel@vger.kernel.org,
 Masami Hiramatsu <mhiramat@kernel.org>
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
 arch/arm64/include/asm/stacktrace.h | 18 ++++---
 arch/arm64/kernel/stacktrace.c      | 73 ++++++++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/Makefile    |  3 +-
 3 files changed, 60 insertions(+), 34 deletions(-)

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
index 0467cb79f080..a84e38d41d38 100644
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
@@ -127,7 +123,45 @@ static int notrace unwind_next(struct task_struct *tsk,
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
 
@@ -157,22 +191,6 @@ static int notrace unwind_next(struct task_struct *tsk,
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
@@ -224,3 +242,4 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 
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
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
