Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63457C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 16:52:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0A4C4B24C;
	Tue,  7 Jun 2022 12:52:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GZw9Gy62jz+J; Tue,  7 Jun 2022 12:52:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B3624B315;
	Tue,  7 Jun 2022 12:52:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1815B4B2FB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 12:52:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id opmXkTGT8PUh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 12:52:03 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 978D14B24C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 12:52:03 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-3135d02968bso2923687b3.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Jun 2022 09:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rjRsj4m79FaG01hh1JM+gnevDQqcLHdW4HjfiuVC0I0=;
 b=hn7Xx71n2KnaaudPsWoOTWsmIKVH2tEImkA5C6UnP/mD/yBngfMLji74jihCgmGl3i
 Oe+usDOEZhIztDMPc4rcdCiSldhSIax6bzofbCx/aXbOpHA8gJZb4Yt4b3HyzrEDGavY
 tz1an+NE9s3+fZ4I/wqrsGluqW7Gl9q8cb52CZ1wNMrgLvNqRIVFbx7acB7jUIs6dy3a
 z6SeXpB+1tP7RqmG/ZlE2XEI4V6CdBQCR3gjZkV62ZVv42q3eIfxz3DsUvqfdulCdf0n
 aWtbzj2IgfmtGIcAPuyAQ6d5/2iF/92KY92kI9WA2rv9rcUAH23ftma3wW1dEriJCT6t
 aD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rjRsj4m79FaG01hh1JM+gnevDQqcLHdW4HjfiuVC0I0=;
 b=dPlTfQiD0TPQi8zcwWVxnRthJB9XK2qo19RdCNjxA2lgsots6rDIet9N8yNH0Or+I+
 6jGJuRp7FY3UQlKoaz3Fzzyg9mwvgvBFXGCNPNVcxth+Vbw587CYW/vXNF73DoDp3t8r
 wQA2+/CUg+JOr8EpAvjZbD8GzFBJg/UivdO2766VgiQe5YlMtpDroPoeSfqyk2w4oHAh
 2ut+hlrQxAu0tsE70Qcpq+6pcSEYLvCTh3zvNS2udlSOY/zAQ9rL8q5lEemynscr6PvB
 sGT7q0rCEjIlIu9xXAtv4CnDdSAVmqyk5yBrt/uiycxz6sMccTuYc3sXer63Ahj3zcEU
 g7UA==
X-Gm-Message-State: AOAM5339d7tiAbNzEmkcHuMc1pg6VNPNV2MB2UnsoJqwI2uiHC7Xs/No
 kancDdLFbEjXI7c9feTIJAbGA4XdK+Tjc5xYaQ==
X-Google-Smtp-Source: ABdhPJy+IB15B8hsKv/SihsClOR+eo9Nq0yxU4MyQoY67kA3uwyRsLph8BS0L40V/9kbjX+bqF3kZKaMqzx2PJ910Q==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:7091:8518:ec1e:93dc])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:1006:b0:660:6f21:a210 with
 SMTP id w6-20020a056902100600b006606f21a210mr22111816ybt.178.1654620722845;
 Tue, 07 Jun 2022 09:52:02 -0700 (PDT)
Date: Tue,  7 Jun 2022 09:50:44 -0700
In-Reply-To: <20220607165105.639716-1-kaleshsingh@google.com>
Message-Id: <20220607165105.639716-3-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220607165105.639716-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v3 2/5] KVM: arm64: Compile stacktrace.nvhe.o
From: Kalesh Singh <kaleshsingh@google.com>
To: mark.rutland@arm.com, broonie@kernel.org, maz@kernel.org
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, surenb@google.com,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, tjmercier@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
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
Reviewed-by: Mark Brown <broonie@kernel.org>
---

Changes in v3:
  - Add Mark's Reviewed-by tag

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
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
