Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795391951;
	b=u398g04Xx5OzjbWda0fjtpUks3upJC7Lk1Pl+LyUH4KslFF/GkvWmcqsPGWVIi0NJ2mD
	 38HYh7ULnZxUZKLBwFk0Wb0evZ7lONXG/HCc0n2T80m++8ssSiMfA6PnBDrWQxutHNsSD
	 VVdRYTdm8jUlVYwqRi/uahTV3TdyENG/4RD58p1MMLPlq3jNlhBFsoOopqtceOdeUONgF
	 mdMZixqe6y4DQxQepqyagxOGzgHkCA1pjL+ggRwrRaGi4JIln9yJ+gtdcE7JVqx8po4HW
	 WNelid7rk7NKosQIRV5xv+n0NdC+BhqjF/ehNbx5+nd0VAQ+Yje9siKPOaPx1A6CUdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795391951;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=cAxELkFDVo0H7iMwg+usnW6750UvO5PdYA7jAmdaF0g=;
	b=0aAqRNvaQJk6AMP+izA9dcyz9V5Mzz9V8X9PwaE0KbFjxWCsi0J2wIVb+4GTlj2vE729
	 8EENs2/prv/oVW4+QlObqxMCRd3tz5w6YdGg5rYIEr0h8ZAtoJ3FBq26JiNxwUmkqSu8O
	 6auU8FQDUn1w4Znv+F/zYGryVtdudeeeUQm/owurYDKmrOeZasXnAaNZKvfPQyIeaK3BC
	 X0Nu/FUKft4Uq5AAbDiqXktLkgJu1GTZZj1wpSv+p/G9L4i3IBSq6b+5+Y1oExmqGBX0Q
	 GINwg9d8JBBxuBQ3Nz3GNo3aM++ZHsp7f5LYU8MndYq9C40k0MNXEgISbngaRq8awbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gKX+SQdC;
	arc=none smtp.remote-ip=74.125.82.70
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C36606A339
	for <kvmarm@lists.linux.dev>; Sun, 22 Nov 2026 23:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23C36606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gKX+SQdC
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1b3b5b49cabso2493464c88.0
        for <kvmarm@lists.linux.dev>; Sun, 22 Nov 2026 15:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795391950; x=1795996750; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cAxELkFDVo0H7iMwg+usnW6750UvO5PdYA7jAmdaF0g=;
        b=gKX+SQdCSFjafpk++EksETSFHX0MtbGS9U7YloOoVTNJ2Tf4V14y0B3vqpCn5eyFHI
         jFDpjW14XPMp3jJcT0TfZgRGJkxTbVm5YKimNq75fVwBxIsZJAVBShYsfBB4i3lfJ0gb
         E5olk4+x5Zn9pKbsMmlHJ89o8Ib2Q+EbcePgZ5101Xasqaa97yyjgJn0zNU1q+yRWHSi
         jH14o3oHS0nT7Z+ERqBWofeMsEaR+CmL+ji2XUbz4XBLs5NWnMbG4awxnc3NIONGC1j+
         7HF+hfL1LQNBXbnZDNNNNsasVkZlk3uDJTVDF32ewlYIPGswM/qgewfz5b+n6w+Bylx7
         q1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795391950; x=1795996750;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cAxELkFDVo0H7iMwg+usnW6750UvO5PdYA7jAmdaF0g=;
        b=FeQdg78I4Q879BQSBDiYyENPXZqg4nuerxr+kc5hLo1O4bm/HmNckhUvwhn1/6FGxi
         STdq3FsuB81LTw92QoXyDHKq7X4IBP/x1OeKXrDIEzNwHiMjv/PEoEwqpw3a6Kla47I4
         3j05DXuh6VLxcoqPRfRe5AdtJ96KZslYxHvbaklxx+NllGz4G60anzXIN7KWTmx5ad8J
         WdGOgqA+mZErX3IK9E21LE2+WRwu2aIO/9QtdtrQ0LT7LXxfpIcIUla12xuhSku3ZcWI
         ARvGGOm7NouBa34960KvlPyG9hBRg4EmTnMM24/qhO7NCrTq2O81YcoUk7QWZ+VrysNR
         po/A==
X-Forwarded-Encrypted: i=1; AL+hErE+spn6km1YAGED2e/t+/YXbS9wwZzU/caQUET37LKueBkM4VssyVc3MnJ4lfl+y8S+Xm6sBLM=@lists.linux.dev
X-Gm-Message-State: APuU4Z9erFIUO06/b6AxXuWJx60UrUTbDGmoGLEu7R2DItPYWFzUC62X
	eiRs7ZepQg5kMnX4tHuS0EthwmqijJOja0zKkX0ZkWoYGahONeqXgDu6poYWwef4Txe9xtxP0ct
	nyk5g1uKp7A==
X-Received: from dltt13.prod.google.com ([2002:a05:701a:c96d:b0:18f:4e29:3ddd])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:4196:b0:1b2:3b5b:b80b
 with SMTP id a92af1059eb24-1b55689ee3amr15827553c88.8.1795391949713; Sun, 22
 Nov 2026 15:59:09 -0800 (PST)
Date: Sun, 22 Nov 2026 15:57:52 -0800
In-Reply-To: <20261122235757.3456048-1-irogers@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261122235757.3456048-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261122235757.3456048-7-irogers@google.com>
Subject: [RFC PATCH v1 06/11] arm64: unwind_user: Support Minimal DWARF CFI
 and FP user unwinding
From: Ian Rogers <irogers@google.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, 
	mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, acme@kernel.org, namhyung@kernel.org, 
	linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, 
	ojeda@kernel.org, rust-for-linux@vger.kernel.org, ardb@kernel.org, 
	linux-efi@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	kvmarm@lists.linux.dev, shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, 
	dylanbhatch@google.com, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

Wire up CONFIG_HAVE_UNWIND_USER_CFI and CONFIG_HAVE_UNWIND_USER_FP on
arm64 by providing arch/arm64/include/asm/unwind_user.h and
unwind_user_sigreturn():

 - Populate DWARF CFI register mappings for both 64-bit AArch64
   (ws=8, sp=31, fp=29, lr=30) and 32-bit AArch32 compat tasks
   (ws=4, sp=13, fp=11, lr=14).
 - Expose the user frame pointer (x29 / compat_fp) and link register
   (x30 / compat_lr) via unwind_user_frame_pointer() and
   unwind_user_link_register() so leaf functions with DW_CFA_same_value
   on LR unwind accurately before falling back to stack-saved return
   addresses.
 - Implement unwind_user_sigreturn() in arch/arm64/kernel/signal.c to
   recover pc, sp, x29, and x30 directly from rt_sigframe.uc.uc_mcontext
   at __kernel_rt_sigreturn (which intentionally omits .eh_frame in the
   arm64 vDSO), preserving interrupted leaf functions and SA_ONSTACK
   alternate signal stacks.
 - Strip user-space pointer authentication codes via
   ptrauth_strip_user_insn_pac() in unwind_user_strip_pac(), and define
   ARCH_INIT_USER_FP_FRAME for both 64-bit AArch64 PCS frame records and
   32-bit AArch32 compat_frame_tail layouts.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/arm64/Kconfig                   |   2 +
 arch/arm64/include/asm/unwind_user.h | 126 +++++++++++++++++++++++++++
 arch/arm64/kernel/signal.c           |  54 ++++++++++++
 3 files changed, 182 insertions(+)
 create mode 100644 arch/arm64/include/asm/unwind_user.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ee0f263f477d..918d7e278f7d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -228,6 +228,8 @@ config ARM64
 	select HAVE_STACKPROTECTOR
 	select HAVE_STATIC_CALL if CFI
 	select HAVE_SYSCALL_TRACEPOINTS
+	select HAVE_UNWIND_USER_CFI
+	select HAVE_UNWIND_USER_FP
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HOTPLUG_CORE_SYNC_DEAD if HOTPLUG_CPU
diff --git a/arch/arm64/include/asm/unwind_user.h b/arch/arm64/include/asm/unwind_user.h
new file mode 100644
index 000000000000..38d0641ae554
--- /dev/null
+++ b/arch/arm64/include/asm/unwind_user.h
@@ -0,0 +1,126 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_ARM64_UNWIND_USER_H
+#define __ASM_ARM64_UNWIND_USER_H
+
+#ifdef CONFIG_UNWIND_USER
+
+#include <linux/sched.h>
+#include <linux/sched/task_stack.h>
+#include <linux/unwind_dwarf_cfi.h>
+#include <linux/unwind_user_types.h>
+#include <asm/compiler.h>
+#include <asm/ptrace.h>
+
+/**
+ * unwind_user_word_size() - Return the user-space word size in bytes on arm64
+ * @regs: User-mode register state.
+ *
+ * Return: 4 for AArch32 compat user mode, or 8 for AArch64 user mode.
+ */
+static inline int unwind_user_word_size(struct pt_regs *regs)
+{
+	return compat_user_mode(regs) ? 4 : 8;
+}
+
+/**
+ * unwind_user_frame_pointer() - Fetch the user frame pointer from @regs
+ * @regs: User-mode register state.
+ *
+ * Return: r11 (compat_fp) for AArch32 compat tasks, or x29 for AArch64 tasks.
+ */
+static inline unsigned long unwind_user_frame_pointer(struct pt_regs *regs)
+{
+	return compat_user_mode(regs) ? regs->compat_fp : frame_pointer(regs);
+}
+#define unwind_user_frame_pointer unwind_user_frame_pointer
+
+/**
+ * unwind_user_link_register() - Fetch the user link register from @regs
+ * @regs: User-mode register state.
+ * @ra: Output link register value (r14 for AArch32 compat, x30 for AArch64).
+ *
+ * Return: Always true on arm64 because a link register is architecturally
+ * present in both AArch64 and AArch32 execution states.
+ */
+static inline bool unwind_user_link_register(struct pt_regs *regs,
+					     unsigned long *ra)
+{
+	if (compat_user_mode(regs))
+		*ra = regs->compat_lr;
+	else
+		*ra = procedure_link_pointer(regs);
+	return true;
+}
+#define unwind_user_link_register unwind_user_link_register
+
+/**
+ * unwind_user_strip_pac() - Strip user pointer authentication bits on arm64
+ * @ip: Recovered user return address.
+ * @ra_signed: Whether CFI marked the return address as PAC-signed (unused;
+ *             arm64 strips user instruction PAC bits unconditionally via the
+ *             task's configured pointer authentication mask).
+ *
+ * Return: @ip unchanged for AArch32 compat tasks, or @ip with user instruction
+ * PAC bits stripped for AArch64 tasks.
+ */
+static inline unsigned long unwind_user_strip_pac(unsigned long ip,
+						  bool ra_signed)
+{
+	if (IS_ENABLED(CONFIG_COMPAT) &&
+	    compat_user_mode(task_pt_regs(current)))
+		return ip;
+	return ptrauth_strip_user_insn_pac(ip);
+}
+#define unwind_user_strip_pac unwind_user_strip_pac
+
+/**
+ * unwind_user_cfi_arch() - Populate AArch64/AArch32 DWARF register numbers
+ * @ws: User word size in bytes (8 for AArch64, 4 for AArch32 compat).
+ * @arch: Output DWARF CFI architecture descriptor.
+ *
+ * Return: true if @ws is 4 or 8, false otherwise.
+ */
+static inline bool unwind_user_cfi_arch(unsigned int ws,
+					struct dwarf_cfi_arch *arch)
+{
+	if (ws == 8) {
+		*arch = (struct dwarf_cfi_arch){
+			.ws	= 8,
+			.sp_reg	= 31,	/* sp */
+			.fp_reg	= 29,	/* x29 */
+			.ra_reg	= 30,	/* x30 (lr) */
+		};
+		return true;
+	}
+	if (ws == 4) {
+		*arch = (struct dwarf_cfi_arch){
+			.ws	= 4,
+			.sp_reg	= 13,	/* r13 (sp) */
+			.fp_reg	= 11,	/* r11 (fp) */
+			.ra_reg	= 14,	/* r14 (lr) */
+		};
+		return true;
+	}
+	return false;
+}
+
+bool unwind_user_sigreturn(struct unwind_user_state *state);
+#define unwind_user_sigreturn unwind_user_sigreturn
+
+#endif /* CONFIG_UNWIND_USER */
+
+#ifdef CONFIG_HAVE_UNWIND_USER_FP
+
+/*
+ * AArch64 PCS stores {fp, lr} at [fp, fp + 16), while 32-bit AArch32 compat
+ * APCS stores struct compat_frame_tail {fp, sp, lr} at [compat_fp - 12, compat_fp).
+ */
+#define ARCH_INIT_USER_FP_FRAME(ws)			\
+	.cfa_off	= (ws) == 8 ? 2 * (ws) : 0,	\
+	.ra_off		= -1 * (ws),			\
+	.fp_off		= (ws) == 8 ? -2 * (ws) : -3 * (ws), \
+	.use_fp		= true,
+
+#endif /* CONFIG_HAVE_UNWIND_USER_FP */
+
+#endif /* __ASM_ARM64_UNWIND_USER_H */
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 80398ac83c3b..41dfbfcc1d2e 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -21,6 +21,7 @@
 #include <linux/rseq.h>
 #include <linux/syscalls.h>
 #include <linux/pkeys.h>
+#include <linux/unwind_user.h>
 
 #include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
@@ -1705,6 +1706,59 @@ void __init minsigstksz_setup(void)
 		16; /* max alignment padding */
 }
 
+#ifdef CONFIG_UNWIND_USER
+/**
+ * unwind_user_sigreturn() - Unwind an AArch64 vDSO rt_sigreturn signal frame
+ * @state: Current user unwind state.
+ *
+ * __kernel_rt_sigreturn intentionally omits .eh_frame directives in the arm64
+ * vDSO so libgcc uses its sigcontext fallback path, and the synthetic
+ * user->next_frame FP record skips the interrupted PC. Recover the interrupted
+ * PC, SP, x29, and x30 directly from &rt_sigframe.uc.uc_mcontext so leaf
+ * functions, -fomit-frame-pointer code, and alternate signal stacks unwind
+ * accurately.
+ *
+ * Return: true if @state was at __kernel_rt_sigreturn and advanced to the
+ * interrupted user context, false otherwise.
+ */
+bool unwind_user_sigreturn(struct unwind_user_state *state)
+{
+	struct mm_struct *mm = current->mm;
+	struct rt_sigframe __user *sf;
+	unsigned long sigtramp;
+	u64 fp_lr[2], sp_pc[2];
+
+	if (!mm || state->ws != 8 || !mm->context.vdso)
+		return false;
+
+	sigtramp = (unsigned long)VDSO_SYMBOL(mm->context.vdso, sigtramp);
+	if (state->ip != sigtramp &&
+	    !(state->topmost && state->ip == sigtramp + 4))
+		return false;
+
+	if (state->sp & 0xfUL)
+		return false;
+
+	sf = (struct rt_sigframe __user *)state->sp;
+	if (copy_from_user(fp_lr, &sf->uc.uc_mcontext.regs[29], sizeof(fp_lr)) ||
+	    copy_from_user(sp_pc, &sf->uc.uc_mcontext.sp, sizeof(sp_pc)))
+		return false;
+
+	sp_pc[1] = ptrauth_strip_user_insn_pac(sp_pc[1]);
+	if ((sp_pc[0] & 7ULL) || !sp_pc[1])
+		return false;
+
+	state->fp = fp_lr[0];
+	state->ra = ptrauth_strip_user_insn_pac(fp_lr[1]);
+	state->sp = sp_pc[0];
+	state->ip = sp_pc[1];
+	state->ra_valid = true;
+	state->signal = true;
+	state->topmost = false;
+	return true;
+}
+#endif
+
 /*
  * Compile-time assertions for siginfo_t offsets. Check NSIG* as well, as
  * changes likely come with new fields that should be added below.
-- 
2.56.1.750.gf70dc682cf-goog

