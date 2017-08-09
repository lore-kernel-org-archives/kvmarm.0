From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 13/27] arm64/sve: Signal handling support
Date: Wed,  9 Aug 2017 13:05:19 +0100
Message-ID: <1502280338-23002-14-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch implements support for saving and restoring the SVE
registers around signals.

A fixed-size header struct sve_context is always included in the
signal frame encoding the thread's vector length at the time of
signal delivery, optionally followed by a variable-layout structure
encoding the SVE registers.

Because of the need to preserve backwards compatibility, the FPSIMD
view of the SVE registers is always dumped as a struct
fpsimd_context in the usual way, in addition to any sve_context.

The SVE vector registers are dumped in full, including bits 127:0
of each register which alias the corresponding FPSIMD vector
registers in the hardware.  To avoid any ambiguity about which
alias to restore during sigreturn, the kernel always restores bits
127:0 of each SVE vector register from the fpsimd_context in the
signal frame (which must be present): userspace needs to take this
into account if it wants to modify the SVE vector register contents
on return from a signal.

FPSR and FPCR, which are used by both FPSIMD and SVE, are not
included in sve_context because they are always present in
fpsimd_context anyway.

For signal delivery, a new helper
fpsimd_signal_preserve_current_state() is added to update _both_
the FPSIMD and SVE views in the task struct, to make it easier to
populate this information into the signal frame.  Because of the
redundancy between the two views of the state, only one is updated
otherwise.  In order to avoid racing with a pending discard of the
SVE state, this flush is hoisted before the sigframe layout phase,
so that the layout and population phases see a consistent view of
the thread.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/fpsimd.h |   1 +
 arch/arm64/kernel/fpsimd.c      |  23 ++++--
 arch/arm64/kernel/signal.c      | 169 ++++++++++++++++++++++++++++++++++++++--
 arch/arm64/kernel/signal32.c    |   2 +-
 4 files changed, 179 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 72090a1..7efd04e 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -63,6 +63,7 @@ extern void fpsimd_load_state(struct fpsimd_state *state);
 extern void fpsimd_thread_switch(struct task_struct *next);
 extern void fpsimd_flush_thread(void);
 
+extern void fpsimd_signal_preserve_current_state(void);
 extern void fpsimd_preserve_current_state(void);
 extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct fpsimd_state *state);
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 80ecb2d..e8674f6 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -148,8 +148,6 @@ static void change_cpacr(u64 old, u64 new)
 		write_sysreg(new, CPACR_EL1);
 }
 
-#ifdef CONFIG_ARM64_SVE
-
 #define ZREG(sve_state, vq, n) ((char *)(sve_state) +		\
 	(SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET))
 
@@ -191,6 +189,8 @@ static void fpsimd_to_sve(struct task_struct *task)
 		       sizeof(fst->vregs[i]));
 }
 
+#ifdef CONFIG_ARM64_SVE
+
 size_t sve_state_size(struct task_struct const *task)
 {
 	unsigned int vl = task->thread.sve_vl;
@@ -431,13 +431,17 @@ void fpsimd_preserve_current_state(void)
 		return;
 
 	local_bh_disable();
-
-	if (!test_thread_flag(TIF_FOREIGN_FPSTATE))
-		fpsimd_save_state(&current->thread.fpsimd_state);
-
+	task_fpsimd_save();
 	local_bh_enable();
 }
 
+void fpsimd_signal_preserve_current_state(void)
+{
+	fpsimd_preserve_current_state();
+	if (system_supports_sve() && test_thread_flag(TIF_SVE))
+		sve_to_fpsimd(current);
+}
+
 /*
  * Load the userland FPSIMD state of 'current' from memory, but only if the
  * FPSIMD state already held in the registers is /not/ the most recent FPSIMD
@@ -473,7 +477,12 @@ void fpsimd_update_current_state(struct fpsimd_state *state)
 
 	local_bh_disable();
 
-	fpsimd_load_state(state);
+	if (system_supports_sve() && test_thread_flag(TIF_SVE)) {
+		current->thread.fpsimd_state = *state;
+		fpsimd_to_sve(current);
+	}
+	task_fpsimd_load();
+
 	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
 		struct fpsimd_state *st = &current->thread.fpsimd_state;
 
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 4991e87..2694143 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -62,6 +62,7 @@ struct rt_sigframe_user_layout {
 
 	unsigned long fpsimd_offset;
 	unsigned long esr_offset;
+	unsigned long sve_offset;
 	unsigned long extra_offset;
 	unsigned long end_offset;
 };
@@ -178,9 +179,6 @@ static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
 	struct fpsimd_state *fpsimd = &current->thread.fpsimd_state;
 	int err;
 
-	/* dump the hardware registers to the fpsimd_state structure */
-	fpsimd_preserve_current_state();
-
 	/* copy the FP and status/control registers */
 	err = __copy_to_user(ctx->vregs, fpsimd->vregs, sizeof(fpsimd->vregs));
 	__put_user_error(fpsimd->fpsr, &ctx->fpsr, err);
@@ -213,6 +211,8 @@ static int restore_fpsimd_context(struct fpsimd_context __user *ctx)
 	__get_user_error(fpsimd.fpsr, &ctx->fpsr, err);
 	__get_user_error(fpsimd.fpcr, &ctx->fpcr, err);
 
+	clear_thread_flag(TIF_SVE);
+
 	/* load the hardware registers from the fpsimd_state structure */
 	if (!err)
 		fpsimd_update_current_state(&fpsimd);
@@ -220,10 +220,113 @@ static int restore_fpsimd_context(struct fpsimd_context __user *ctx)
 	return err ? -EFAULT : 0;
 }
 
+
 struct user_ctxs {
 	struct fpsimd_context __user *fpsimd;
+	struct sve_context __user *sve;
 };
 
+#ifdef CONFIG_ARM64_SVE
+
+static int preserve_sve_context(struct sve_context __user *ctx)
+{
+	int err = 0;
+	u16 reserved[ARRAY_SIZE(ctx->__reserved)];
+	unsigned int vl = current->thread.sve_vl;
+	unsigned int vq = 0;
+
+	BUG_ON(!sve_vl_valid(vl));
+	if (test_thread_flag(TIF_SVE))
+		vq = sve_vq_from_vl(vl);
+
+	memset(reserved, 0, sizeof(reserved));
+
+	__put_user_error(SVE_MAGIC, &ctx->head.magic, err);
+	__put_user_error(round_up(SVE_SIG_CONTEXT_SIZE(vq), 16),
+			 &ctx->head.size, err);
+	__put_user_error(vl, &ctx->vl, err);
+	BUILD_BUG_ON(sizeof(ctx->__reserved) != sizeof(reserved));
+	err |= copy_to_user(&ctx->__reserved, reserved, sizeof(reserved));
+
+	if (vq) {
+		/*
+		 * This assumes that the SVE state has already been saved to
+		 * the task struct by calling preserve_fpsimd_context().
+		 */
+		BUG_ON(SVE_SIG_REGS_SIZE(vq) != sve_state_size(current));
+		err |= copy_to_user((char __user *)ctx + SVE_SIG_REGS_OFFSET,
+				    current->thread.sve_state,
+				    SVE_SIG_REGS_SIZE(vq));
+	}
+
+	return err ? -EFAULT : 0;
+}
+
+static int restore_sve_fpsimd_context(struct user_ctxs *user)
+{
+	int err;
+	unsigned int vq;
+	struct fpsimd_state fpsimd;
+	struct sve_context sve;
+
+	if (__copy_from_user(&sve, user->sve, sizeof(sve)))
+		return -EFAULT;
+
+	if (sve.vl != current->thread.sve_vl)
+		return -EINVAL;
+
+	if (sve.head.size <= sizeof(*user->sve)) {
+		clear_thread_flag(TIF_SVE);
+		goto fpsimd_only;
+	}
+
+	BUG_ON(!sve_vl_valid(sve.vl));
+	vq = sve_vq_from_vl(sve.vl);
+
+	if (sve.head.size < SVE_SIG_CONTEXT_SIZE(vq))
+		return -EINVAL;
+
+	fpsimd_flush_task_state(current);
+	barrier();
+	set_thread_flag(TIF_FOREIGN_FPSTATE);
+	barrier();
+
+	sve_alloc(current);
+	BUG_ON(SVE_SIG_REGS_SIZE(vq) != sve_state_size(current));
+	err = __copy_from_user(current->thread.sve_state,
+			       (char __user const *)user->sve +
+					SVE_SIG_REGS_OFFSET,
+			       SVE_SIG_REGS_SIZE(vq));
+	if (err)
+		return err;
+
+	barrier();
+	set_thread_flag(TIF_SVE);
+
+fpsimd_only:
+	/* copy the FP and status/control registers */
+	/* restore_sigframe() already checked that user->fpsimd != NULL. */
+	err = __copy_from_user(fpsimd.vregs, user->fpsimd->vregs,
+			       sizeof(fpsimd.vregs));
+	__get_user_error(fpsimd.fpsr, &user->fpsimd->fpsr, err);
+	__get_user_error(fpsimd.fpcr, &user->fpsimd->fpcr, err);
+
+	/* load the hardware registers from the fpsimd_state structure */
+	if (!err)
+		fpsimd_update_current_state(&fpsimd);
+
+	return err;
+}
+
+#else /* ! CONFIG_ARM64_SVE */
+
+/* Turn any non-optimised out attempts to use these into a link error: */
+extern int preserve_sve_context(void __user *ctx);
+extern int restore_sve_fpsimd_context(struct user_ctxs *user);
+
+#endif /* ! CONFIG_ARM64_SVE */
+
+
 static int parse_user_sigframe(struct user_ctxs *user,
 			       struct rt_sigframe __user *sf)
 {
@@ -236,6 +339,7 @@ static int parse_user_sigframe(struct user_ctxs *user,
 	char const __user *const sfp = (char const __user *)sf;
 
 	user->fpsimd = NULL;
+	user->sve = NULL;
 
 	if (!IS_ALIGNED((unsigned long)base, 16))
 		goto invalid;
@@ -286,6 +390,19 @@ static int parse_user_sigframe(struct user_ctxs *user,
 			/* ignore */
 			break;
 
+		case SVE_MAGIC:
+			if (!system_supports_sve())
+				goto invalid;
+
+			if (user->sve)
+				goto invalid;
+
+			if (size < sizeof(*user->sve))
+				goto invalid;
+
+			user->sve = (struct sve_context __user *)head;
+			break;
+
 		case EXTRA_MAGIC:
 			if (have_extra_context)
 				goto invalid;
@@ -358,9 +475,6 @@ static int parse_user_sigframe(struct user_ctxs *user,
 	}
 
 done:
-	if (!user->fpsimd)
-		goto invalid;
-
 	return 0;
 
 invalid:
@@ -394,8 +508,18 @@ static int restore_sigframe(struct pt_regs *regs,
 	if (err == 0)
 		err = parse_user_sigframe(&user, sf);
 
-	if (err == 0)
-		err = restore_fpsimd_context(user.fpsimd);
+	if (err == 0) {
+		if (!user.fpsimd)
+			return -EINVAL;
+
+		if (user.sve) {
+			if (!system_supports_sve())
+				return -EINVAL;
+
+			err = restore_sve_fpsimd_context(&user);
+		} else
+			err = restore_fpsimd_context(user.fpsimd);
+	}
 
 	return err;
 }
@@ -454,6 +578,20 @@ static int setup_sigframe_layout(struct rt_sigframe_user_layout *user)
 			return err;
 	}
 
+	if (system_supports_sve()) {
+		unsigned int vq = 0;
+
+		if (test_thread_flag(TIF_SVE)) {
+			BUG_ON(!sve_vl_valid(current->thread.sve_vl));
+			vq = sve_vq_from_vl(current->thread.sve_vl);
+		}
+
+		err = sigframe_alloc(user, &user->sve_offset,
+				     SVE_SIG_CONTEXT_SIZE(vq));
+		if (err)
+			return err;
+	}
+
 	return sigframe_alloc_end(user);
 }
 
@@ -495,6 +633,13 @@ static int setup_sigframe(struct rt_sigframe_user_layout *user,
 		__put_user_error(current->thread.fault_code, &esr_ctx->esr, err);
 	}
 
+	/* Scalable Vector Extension state, if present */
+	if (system_supports_sve() && err == 0 && user->sve_offset) {
+		struct sve_context __user *sve_ctx =
+			apply_user_offset(user, user->sve_offset);
+		err |= preserve_sve_context(sve_ctx);
+	}
+
 	if (err == 0 && user->extra_offset) {
 		char __user *sfp = (char __user *)user->sigframe;
 		char __user *userp =
@@ -594,6 +739,14 @@ static int setup_rt_frame(int usig, struct ksignal *ksig, sigset_t *set,
 	struct rt_sigframe __user *frame;
 	int err = 0;
 
+	/*
+	 * Ensure FPSIMD/SVE state in task_struct is up-to-date.
+	 * This is needed here in order to complete any pending SVE discard:
+	 * otherwise, discard may occur between deciding on the sigframe
+	 * layout and dumping the register data.
+	 */
+	fpsimd_signal_preserve_current_state();
+
 	if (get_sigframe(&user, ksig, regs))
 		return 1;
 
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index 4e5a664..202337d 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -244,7 +244,7 @@ static int compat_preserve_vfp_context(struct compat_vfp_sigframe __user *frame)
 	 * Note that this also saves V16-31, which aren't visible
 	 * in AArch32.
 	 */
-	fpsimd_preserve_current_state();
+	fpsimd_signal_preserve_current_state();
 
 	/* Place structure header on the stack */
 	__put_user_error(magic, &frame->magic, err);
-- 
2.1.4
