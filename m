Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248F9C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 10:36:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2A2E4BFB9;
	Thu, 24 Feb 2022 05:36:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MEMmxTzxRyyI; Thu, 24 Feb 2022 05:36:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51BB44C060;
	Thu, 24 Feb 2022 05:36:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 411A64BC67
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:22:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fsxAcj+3YoTY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 00:22:21 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DA7A4BC5B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:22:21 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d74a0ff060so11823917b3.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 21:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=K66ess7r5mHhZ+jyrx/v31ubR1dLR/5O6RljnD9TbJk=;
 b=LozXqHfMaTDJaEwKzPinWRR8XkqdwYysp39GImtwCrM0+rogfw04rb+mueZhhhGfGL
 23FdMdHjfPe/ucA5NO1Ps2x7QWVTIJkn5r3/w8An+6Yu/OFB26uda3T3TViaharQGbj+
 7lqzJTjK+W3cWbsaENJ9QW4K/1yBNzLwviodZJ0Bmop3eVKvP4pz+i1Le2m2DPlNVJkU
 D6YZicoBfCDZKRojOUD0ad+qD2XesbCuBtMdPnkVExspbT66sEOb2LAjVrIpfal4EMKl
 1ZUgGHWlikvJtJGdsQ/1RJ+WivRUeJ3YDFLrF3XG6Nm86ZogXR2B4GecgXGAI7R39qwJ
 v2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=K66ess7r5mHhZ+jyrx/v31ubR1dLR/5O6RljnD9TbJk=;
 b=oMflPVHYWjP980yJZCLrpZkU9noux8hUGKocC2tC4ArV4dffbovsX7ZkSkiLTVEm1U
 q94FzZBTxfbPcH1m2JhMGiiuRdB/zfr5y4Nf128RGlJhOjG8yWizVsBb6qy+nzqs7Oul
 HOh5qcD3crhcEK2DDauhM3V7m6M4i6K/CO1kfodWJW1nIoA+3fgIYS+AmDWVw3y5HtMv
 IIPkWLhSl4TYggMjNVPHd2iFN0BA+VG/pk0fhio+qqGqPGRDjSw7ERbSk3iBpLTPJrwr
 N+H0VM2Jc7UcE9DNY40TiYh+ed+sz2IcsXzbmCzOrSAhgwYG1MDo+dvy9j7IUtrjn34b
 c00A==
X-Gm-Message-State: AOAM531jRjVupNciN7+EFgYmWLlgd/P4cH8+u3898wTahLi4BBhuIBF1
 LiiJiOGQ53ljiZVxPCb58vMzj4tEbG24hMRTEg==
X-Google-Smtp-Source: ABdhPJw/I4KRWgId8HIW9zGlW2JOH88r+9WEJZxHfHet2WVfgtVJ4oQgjoWSFqxv0u3Uw07d8ZDDCNzupW/Z9K00hw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:415c:9be0:c461:440a])
 (user=kaleshsingh job=sendgmr) by 2002:a25:2e45:0:b0:624:3b7e:7ffa with SMTP
 id b5-20020a252e45000000b006243b7e7ffamr988328ybn.293.1645680141135; Wed, 23
 Feb 2022 21:22:21 -0800 (PST)
Date: Wed, 23 Feb 2022 21:13:42 -0800
In-Reply-To: <20220224051439.640768-1-kaleshsingh@google.com>
Message-Id: <20220224051439.640768-8-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 7/8] KVM: arm64: Unwind and dump nVHE HYP stacktrace
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Thu, 24 Feb 2022 05:36:21 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
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

Unwind the stack in EL1, when CONFIG_NVHE_EL2_DEBUG is enabled. This is
possible because CONFIG_NVHE_EL2_DEBUG disables the host stage 2 protection
which allows host to access the hypervisor stack pages in EL1.

Unwinding and dumping hyp call traces is gated on CONFIG_NVHE_EL2_DEBUG
to avoid the potential leaking of information to the host.

A simple stack overflow test produces the following output:

[  580.376051][  T412] kvm: nVHE hyp panic at: ffffffc0116145c4!
[  580.378034][  T412] kvm [412]: nVHE HYP call trace:
[  580.378591][  T412] kvm [412]:  [<ffffffc011614934>]
[  580.378993][  T412] kvm [412]:  [<ffffffc01160fa48>]
[  580.379386][  T412] kvm [412]:  [<ffffffc0116145dc>]  // Non-terminating recursive call
[  580.379772][  T412] kvm [412]:  [<ffffffc0116145dc>]
[  580.380158][  T412] kvm [412]:  [<ffffffc0116145dc>]
[  580.380544][  T412] kvm [412]:  [<ffffffc0116145dc>]
[  580.380928][  T412] kvm [412]:  [<ffffffc0116145dc>]
. . .

Since nVHE hyp symbols are not included by kallsyms to avoid issues
with aliasing, we fallback to the vmlinux addresses. Symbolizing the
addresses is handled in the next patch in this series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v3:
  - The nvhe hyp stack unwinder now makes use of the core logic from the
    regular kernel unwinder to avoid duplication, per Mark

Changes in v2:
  - Add cpu_prepare_nvhe_panic_info()
  - Move updating the panic info to hyp_panic(), so that unwinding also
    works for conventional nVHE Hyp-mode.

 arch/arm64/include/asm/kvm_asm.h    |  19 +++
 arch/arm64/include/asm/stacktrace.h |  12 ++
 arch/arm64/kernel/stacktrace.c      | 210 +++++++++++++++++++++++++---
 arch/arm64/kvm/Kconfig              |   5 +-
 arch/arm64/kvm/arm.c                |   2 +-
 arch/arm64/kvm/handle_exit.c        |   3 +
 arch/arm64/kvm/hyp/nvhe/switch.c    |  18 +++
 7 files changed, 243 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 2e277f2ed671..16efdf150a37 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -176,6 +176,25 @@ struct kvm_nvhe_init_params {
 	unsigned long vtcr;
 };
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+/*
+ * Used by the host in EL1 to dump the nVHE hypervisor backtrace on
+ * hyp_panic. This is possible because CONFIG_NVHE_EL2_DEBUG disables
+ * the host stage 2 protection. See: __hyp_do_panic()
+ *
+ * @hyp_stack_base:             hyp VA of the hyp_stack base.
+ * @hyp_overflow_stack_base:    hyp VA of the hyp_overflow_stack base.
+ * @fp:                         hyp FP where the backtrace begins.
+ * @pc:                         hyp PC where the backtrace begins.
+ */
+struct kvm_nvhe_panic_info {
+	unsigned long hyp_stack_base;
+	unsigned long hyp_overflow_stack_base;
+	unsigned long fp;
+	unsigned long pc;
+};
+#endif /* CONFIG_NVHE_EL2_DEBUG */
+
 /* Translate a kernel address @ptr into its equivalent linear mapping */
 #define kvm_ksym_ref(ptr)						\
 	({								\
diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index e77cdef9ca29..18611a51cf14 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -22,6 +22,10 @@ enum stack_type {
 	STACK_TYPE_OVERFLOW,
 	STACK_TYPE_SDEI_NORMAL,
 	STACK_TYPE_SDEI_CRITICAL,
+#ifdef CONFIG_NVHE_EL2_DEBUG
+	STACK_TYPE_KVM_NVHE_HYP,
+	STACK_TYPE_KVM_NVHE_OVERFLOW,
+#endif /* CONFIG_NVHE_EL2_DEBUG */
 	__NR_STACK_TYPES
 };
 
@@ -147,4 +151,12 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 	return false;
 }
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+void kvm_nvhe_dump_backtrace(unsigned long hyp_offset);
+#else
+static inline void kvm_nvhe_dump_backtrace(unsigned long hyp_offset)
+{
+}
+#endif /* CONFIG_NVHE_EL2_DEBUG */
+
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index e4103e085681..6ec85cb69b1f 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -15,6 +15,8 @@
 
 #include <asm/irq.h>
 #include <asm/pointer_auth.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_hyp.h>
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
@@ -64,26 +66,15 @@ NOKPROBE_SYMBOL(start_backtrace);
  * records (e.g. a cycle), determined based on the location and fp value of A
  * and the location (but not the fp value) of B.
  */
-static int notrace unwind_frame(struct task_struct *tsk,
-				struct stackframe *frame)
+static int notrace __unwind_frame(struct stackframe *frame, struct stack_info *info,
+		unsigned long (*translate_fp)(unsigned long, enum stack_type))
 {
 	unsigned long fp = frame->fp;
-	struct stack_info info;
-
-	if (!tsk)
-		tsk = current;
-
-	/* Final frame; nothing to unwind */
-	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
-		return -ENOENT;
 
 	if (fp & 0x7)
 		return -EINVAL;
 
-	if (!on_accessible_stack(tsk, fp, 16, &info))
-		return -EINVAL;
-
-	if (test_bit(info.type, frame->stacks_done))
+	if (test_bit(info->type, frame->stacks_done))
 		return -EINVAL;
 
 	/*
@@ -94,28 +85,62 @@ static int notrace unwind_frame(struct task_struct *tsk,
 	 *
 	 * TASK -> IRQ -> OVERFLOW -> SDEI_NORMAL
 	 * TASK -> SDEI_NORMAL -> SDEI_CRITICAL -> OVERFLOW
+	 * KVM_NVHE_HYP -> KVM_NVHE_OVERFLOW
 	 *
 	 * ... but the nesting itself is strict. Once we transition from one
 	 * stack to another, it's never valid to unwind back to that first
 	 * stack.
 	 */
-	if (info.type == frame->prev_type) {
+	if (info->type == frame->prev_type) {
 		if (fp <= frame->prev_fp)
 			return -EINVAL;
 	} else {
 		set_bit(frame->prev_type, frame->stacks_done);
 	}
 
+	/* Record fp as prev_fp before attempting to get the next fp */
+	frame->prev_fp = fp;
+
+	/*
+	 * If fp is not from the current address space perform the
+	 * necessary translation before dereferencing it to get next fp.
+	 */
+	if (translate_fp)
+		fp = translate_fp(fp, info->type);
+	if (!fp)
+		return -EINVAL;
+
 	/*
 	 * Record this frame record's values and location. The prev_fp and
-	 * prev_type are only meaningful to the next unwind_frame() invocation.
+	 * prev_type are only meaningful to the next __unwind_frame() invocation.
 	 */
 	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
 	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
-	frame->prev_fp = fp;
-	frame->prev_type = info.type;
-
 	frame->pc = ptrauth_strip_insn_pac(frame->pc);
+	frame->prev_type = info->type;
+
+	return 0;
+}
+
+static int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
+{
+	unsigned long fp = frame->fp;
+	struct stack_info info;
+	int err;
+
+	if (!tsk)
+		tsk = current;
+
+	/* Final frame; nothing to unwind */
+	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
+		return -ENOENT;
+
+	if (!on_accessible_stack(tsk, fp, 16, &info))
+		return -EINVAL;
+
+	err = __unwind_frame(frame, &info, NULL);
+	if (err)
+		return err;
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (tsk->ret_stack &&
@@ -143,20 +168,27 @@ static int notrace unwind_frame(struct task_struct *tsk,
 }
 NOKPROBE_SYMBOL(unwind_frame);
 
-static void notrace walk_stackframe(struct task_struct *tsk,
-				    struct stackframe *frame,
-				    bool (*fn)(void *, unsigned long), void *data)
+static void notrace __walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
+		bool (*fn)(void *, unsigned long), void *data,
+		int (*unwind_frame_fn)(struct task_struct *tsk, struct stackframe *frame))
 {
 	while (1) {
 		int ret;
 
 		if (!fn(data, frame->pc))
 			break;
-		ret = unwind_frame(tsk, frame);
+		ret = unwind_frame_fn(tsk, frame);
 		if (ret < 0)
 			break;
 	}
 }
+
+static void notrace walk_stackframe(struct task_struct *tsk,
+				    struct stackframe *frame,
+				    bool (*fn)(void *, unsigned long), void *data)
+{
+	__walk_stackframe(tsk, frame, fn, data, unwind_frame);
+}
 NOKPROBE_SYMBOL(walk_stackframe);
 
 static bool dump_backtrace_entry(void *arg, unsigned long where)
@@ -210,3 +242,135 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 
 	walk_stackframe(task, &frame, consume_entry, cookie);
 }
+
+#ifdef CONFIG_NVHE_EL2_DEBUG
+DECLARE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
+DECLARE_KVM_NVHE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], hyp_overflow_stack);
+DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_panic_info, kvm_panic_info);
+
+static inline bool kvm_nvhe_on_overflow_stack(unsigned long sp, unsigned long size,
+				 struct stack_info *info)
+{
+	struct kvm_nvhe_panic_info *panic_info = this_cpu_ptr_nvhe_sym(kvm_panic_info);
+	unsigned long low = (unsigned long)panic_info->hyp_overflow_stack_base;
+	unsigned long high = low + PAGE_SIZE;
+
+	return on_stack(sp, size, low, high, STACK_TYPE_KVM_NVHE_OVERFLOW, info);
+}
+
+static inline bool kvm_nvhe_on_hyp_stack(unsigned long sp, unsigned long size,
+				 struct stack_info *info)
+{
+	struct kvm_nvhe_panic_info *panic_info = this_cpu_ptr_nvhe_sym(kvm_panic_info);
+	unsigned long low = (unsigned long)panic_info->hyp_stack_base;
+	unsigned long high = low + PAGE_SIZE;
+
+	return on_stack(sp, size, low, high, STACK_TYPE_KVM_NVHE_HYP, info);
+}
+
+static inline bool kvm_nvhe_on_accessible_stack(unsigned long sp, unsigned long size,
+				       struct stack_info *info)
+{
+	if (info)
+		info->type = STACK_TYPE_UNKNOWN;
+
+	if (kvm_nvhe_on_hyp_stack(sp, size, info))
+		return true;
+	if (kvm_nvhe_on_overflow_stack(sp, size, info))
+		return true;
+
+	return false;
+}
+
+static unsigned long kvm_nvhe_hyp_stack_kern_va(unsigned long addr)
+{
+	struct kvm_nvhe_panic_info *panic_info = this_cpu_ptr_nvhe_sym(kvm_panic_info);
+	unsigned long hyp_base, kern_base, hyp_offset;
+
+	hyp_base = (unsigned long)panic_info->hyp_stack_base;
+	hyp_offset = addr - hyp_base;
+
+	kern_base = (unsigned long)*this_cpu_ptr(&kvm_arm_hyp_stack_page);
+
+	return kern_base + hyp_offset;
+}
+
+static unsigned long kvm_nvhe_overflow_stack_kern_va(unsigned long addr)
+{
+	struct kvm_nvhe_panic_info *panic_info = this_cpu_ptr_nvhe_sym(kvm_panic_info);
+	unsigned long hyp_base, kern_base, hyp_offset;
+
+	hyp_base = (unsigned long)panic_info->hyp_overflow_stack_base;
+	hyp_offset = addr - hyp_base;
+
+	kern_base = (unsigned long)this_cpu_ptr_nvhe_sym(hyp_overflow_stack);
+
+	return kern_base + hyp_offset;
+}
+
+/*
+ * Convert KVM nVHE hypervisor stack VA to a kernel VA.
+ *
+ * The nVHE hypervisor stack is mapped in the flexible 'private' VA range, to allow
+ * for guard pages below the stack. Consequently, the fixed offset address
+ * translation macros won't work here.
+ *
+ * The kernel VA is calculated as an offset from the kernel VA of the hypervisor
+ * stack base. See: kvm_nvhe_hyp_stack_kern_va(),  kvm_nvhe_overflow_stack_kern_va()
+ */
+static unsigned long kvm_nvhe_stack_kern_va(unsigned long addr,
+					enum stack_type type)
+{
+	switch (type) {
+	case STACK_TYPE_KVM_NVHE_HYP:
+		return kvm_nvhe_hyp_stack_kern_va(addr);
+	case STACK_TYPE_KVM_NVHE_OVERFLOW:
+		return kvm_nvhe_overflow_stack_kern_va(addr);
+	default:
+		return 0UL;
+	}
+}
+
+static int notrace kvm_nvhe_unwind_frame(struct task_struct *tsk,
+					struct stackframe *frame)
+{
+	struct stack_info info;
+
+	if (!kvm_nvhe_on_accessible_stack(frame->fp, 16, &info))
+		return -EINVAL;
+
+	return  __unwind_frame(frame, &info, kvm_nvhe_stack_kern_va);
+}
+
+static bool kvm_nvhe_dump_backtrace_entry(void *arg, unsigned long where)
+{
+	unsigned long va_mask = GENMASK_ULL(vabits_actual - 1, 0);
+	unsigned long hyp_offset = (unsigned long)arg;
+
+	where &= va_mask;	/* Mask tags */
+	where += hyp_offset;	/* Convert to kern addr */
+
+	kvm_err("[<%016lx>] %pB\n", where, (void *)where);
+
+	return true;
+}
+
+static void notrace kvm_nvhe_walk_stackframe(struct task_struct *tsk,
+				    struct stackframe *frame,
+				    bool (*fn)(void *, unsigned long), void *data)
+{
+	__walk_stackframe(tsk, frame, fn, data, kvm_nvhe_unwind_frame);
+}
+
+void kvm_nvhe_dump_backtrace(unsigned long hyp_offset)
+{
+	struct kvm_nvhe_panic_info *panic_info = this_cpu_ptr_nvhe_sym(kvm_panic_info);
+	struct stackframe frame;
+
+	start_backtrace(&frame, panic_info->fp, panic_info->pc);
+	pr_err("nVHE HYP call trace:\n");
+	kvm_nvhe_walk_stackframe(NULL, &frame, kvm_nvhe_dump_backtrace_entry,
+					(void *)hyp_offset);
+	pr_err("---- end of nVHE HYP call trace ----\n");
+}
+#endif /* CONFIG_NVHE_EL2_DEBUG */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 8a5fbbf084df..75f2c8255ff0 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -51,8 +51,9 @@ config NVHE_EL2_DEBUG
 	depends on KVM
 	help
 	  Say Y here to enable the debug mode for the non-VHE KVM EL2 object.
-	  Failure reports will BUG() in the hypervisor. This is intended for
-	  local EL2 hypervisor development.
+	  Failure reports will BUG() in the hypervisor; and panics will print
+	  the hypervisor call stack. This is intended for local EL2 hypervisor
+	  development.
 
 	  If unsure, say N.
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7a23630c4a7f..66c07c04eb52 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -49,7 +49,7 @@ DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
-static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
+DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e3140abd2e2e..ff69dff33700 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -17,6 +17,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/debug-monitors.h>
+#include <asm/stacktrace.h>
 #include <asm/traps.h>
 
 #include <kvm/arm_hypercalls.h>
@@ -326,6 +327,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 		kvm_err("nVHE hyp panic at: %016llx!\n", elr_virt + hyp_offset);
 	}
 
+	kvm_nvhe_dump_backtrace(hyp_offset);
+
 	/*
 	 * Hyp has panicked and we're going to handle that by panicking the
 	 * kernel. The kernel offset will be revealed in the panic so we're
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index efc20273a352..b8ecffc47424 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -37,6 +37,22 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 #ifdef CONFIG_NVHE_EL2_DEBUG
 DEFINE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], hyp_overflow_stack)
 	__aligned(16);
+DEFINE_PER_CPU(struct kvm_nvhe_panic_info, kvm_panic_info);
+
+static inline void cpu_prepare_nvhe_panic_info(void)
+{
+	struct kvm_nvhe_panic_info *panic_info = this_cpu_ptr(&kvm_panic_info);
+	struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
+
+	panic_info->hyp_stack_base = (unsigned long)(params->stack_hyp_va - PAGE_SIZE);
+	panic_info->hyp_overflow_stack_base = (unsigned long)this_cpu_ptr(hyp_overflow_stack);
+	panic_info->fp = (unsigned long)__builtin_frame_address(0);
+	panic_info->pc = _THIS_IP_;
+}
+ #else
+static inline void cpu_prepare_nvhe_panic_info(void)
+{
+}
 #endif
 
 static void __activate_traps(struct kvm_vcpu *vcpu)
@@ -360,6 +376,8 @@ asmlinkage void __noreturn hyp_panic(void)
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 
+	cpu_prepare_nvhe_panic_info();
+
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
