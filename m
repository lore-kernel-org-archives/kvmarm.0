From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v3 11/28] arm64/sve: Core task context handling
Date: Tue, 10 Oct 2017 19:38:28 +0100
Message-ID: <1507660725-7986-12-git-send-email-Dave.Martin@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds the core support for switching and managing the SVE
architectural state of user tasks.

Calls to the existing FPSIMD low-level save/restore functions are
factored out as new functions task_fpsimd_{save,load}(), since SVE
now dynamically may or may not need to be handled at these points
depending on the kernel configuration, hardware features discovered
at boot, and the runtime state of the task.  To make these
decisions as fast as possible, const cpucaps are used where
feasible, via the system_supports_sve() helper.

The SVE registers are only tracked for threads that have explicitly
used SVE, indicated by the new thread flag TIF_SVE.  Otherwise, the
FPSIMD view of the architectural state is stored in
thread.fpsimd_state as usual.

When in use, the SVE registers are not stored directly in
thread_struct due to their potentially large and variable size.
Because the task_struct slab allocator must be configured very
early during kernel boot, it is also tricky to configure it
correctly to match the maximum vector length provided by the
hardware, since this depends on examining secondary CPUs as well as
the primary.  Instead, a pointer sve_state in thread_struct points
to a dynamically allocated buffer containing the SVE register data,
and code is added to allocate, duplicate and free this buffer at
appropriate times.

TIF_SVE is set when taking an SVE access trap from userspace, if
suitable hardware support has been detected.  This enables SVE for
the thread: a subsequent return to userspace will disable the trap
accordingly.  If such a trap is taken without sufficient hardware
support, SIGILL is sent to the thread instead as if an undefined
instruction had been executed: this may happen if userspace tries
to use SVE in a system where not all CPUs support it for example.

The kernel may clear TIF_SVE and disable SVE for the thread
whenever an explicit syscall is made by userspace, though this is
considered an optimisation opportunity rather than a deterministic
guarantee: the kernel may not do this on every syscall, but it is
permitted to do so.  For backwards compatibility reasons and
conformance with the spirit of the base AArch64 procedure call
standard, the subset of the SVE register state that aliases the
FPSIMD registers is still preserved across a syscall even if this
happens.

TIF_SVE is also cleared, and SVE disabled, on exec: this is an
obvious slow path and a hint that we are running a new binary that
may not use SVE.

Code is added to sync data between thread.fpsimd_state and
thread.sve_state whenever enabling/disabling SVE, in a manner
consistent with the SVE architectural programmer's model.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Alex Bennée <alex.bennee@linaro.org>

---

Changes since v2
----------------

Changes requested by Catalin Marinas:

 * [bugfix] Enabled IRQs during SVE access traps

   There is no special reason why interrupts have to be disabled in
   do_sve_acc(), and the original intention was to enable them --
   I missed this while developing the series.

   This patch avoids IRQ blackout while allocating thread.sve_state and
   saving/restoring.

   This also protects us against kzalloc() sleeping, which was a bug
   here previously since this function was running in atomic context.
   Relying on GFP_ATOMIC here doen't seem justifiable.

   The code is currently suboptimal in the case where no context switch
   occurs, since it adds a store-reload roundtrip that is not strictly
   necessary.  However, avoiding this leads to violation of some
   assumptions which would require additional refactoring or code
   duplication to resolve, particularly regarding the setting of
   ZCR_EL1.LEN.

   For now, I prefer to have code that works initially, and let the
   dust settle for a bit.

   This may be refactored better later.

 * Added WARN_ON(in_softirq() && !irqs_disabled()) to
   task_fpsimd_{load,save}(), to flag up attempts to call these
   functions when softirqs could occur.  This is far from being
   everything we could check, but masking of softirqs is the most
   crucial requirement.

   This will guard against maintenance accidents that call these
   functions in inappropriate situations.

 * Provided an explicit helper
   fpsimd_preserve_current_state_discard_sve() to ensure that task
   vector state is stored to memory and unconditionally discard sve.
   This gets the parent task into the right state such that fork just
   requires a memcpy of thread_struct followed by NULLing dst->
   thread.sve_state.

   With this, fpsimd_dup_sve() has nothing to do any more, so this
   function has been deleted from the patch.

   task_fpsimd_save() is factored out with a backend
   __task_fpsimd_save(bool force_discard), which is used in the few
   places where it is appropriate.

   For now, this breaks fpsimd_preserve_current_state() for SVE tasks,
   but there is no way for SVE tasks to exist yet: so just WARN().
   This issue is resolved by "arm64/sve: Signal handling support".

Miscellaneous:

 * Added comments explaining the intent, purpose and basic constraints
   for fpsimd.c helpers.

 * Added comments explaining the role of TIF_SVE.

 * Added a WARN_ON() check in task_fpsimd_save to confirm that the
   VL currently configured in ZCR_EL1.LEN is correct for current.

   This was identified as a maintenance risk when working on enabling
   IRQs in do_sve_acc().

   The new logic flags and avoids potential buffer overruns on
   sve_state that could otherwise occur if the VL is wrong.  In this
   case, we simply skip the save.  The task state will be corrupted, but
   that's better than corrupting kernel memory.

   Since the task state is now wrong, it can't resume: just inject a
   SIGKILL instead.  We can't BUG(), since this problem may be detected
   in softirq context where BUG() panics the kernel -- so
   force_signal_inject() is called instead.  "bad mode" is a confusing
   thing to print for this, so force_signal_inject() is updated to print
   the more general "unknown or unrecoverable error" for such signals:
   there is no other call to force_signal_inject() with signal==SIGKILL
   today.
---
 arch/arm64/include/asm/fpsimd.h      |  17 ++
 arch/arm64/include/asm/processor.h   |   2 +
 arch/arm64/include/asm/thread_info.h |   1 +
 arch/arm64/include/asm/traps.h       |   2 +
 arch/arm64/kernel/entry.S            |  14 +-
 arch/arm64/kernel/fpsimd.c           | 342 ++++++++++++++++++++++++++++++++++-
 arch/arm64/kernel/process.c          |  14 +-
 arch/arm64/kernel/traps.c            |   6 +-
 8 files changed, 388 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 026a7c7..b1409de 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -20,6 +20,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/stddef.h>
+
 /*
  * FP/SIMD storage area has:
  *  - FPSR and FPCR
@@ -62,6 +64,7 @@ extern void fpsimd_thread_switch(struct task_struct *next);
 extern void fpsimd_flush_thread(void);
 
 extern void fpsimd_preserve_current_state(void);
+extern void fpsimd_preserve_current_state_discard_sve(void);
 extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct fpsimd_state *state);
 
@@ -72,6 +75,20 @@ extern void sve_load_state(void const *state, u32 const *pfpsr,
 			   unsigned long vq_minus_1);
 extern unsigned int sve_get_vl(void);
 
+#ifdef CONFIG_ARM64_SVE
+
+extern size_t sve_state_size(struct task_struct const *task);
+
+extern void sve_alloc(struct task_struct *task);
+extern void fpsimd_release_thread(struct task_struct *task);
+
+#else /* ! CONFIG_ARM64_SVE */
+
+static void __maybe_unused sve_alloc(struct task_struct *task) { }
+static void __maybe_unused fpsimd_release_thread(struct task_struct *task) { }
+
+#endif /* ! CONFIG_ARM64_SVE */
+
 /* For use by EFI runtime services calls only */
 extern void __efi_fpsimd_begin(void);
 extern void __efi_fpsimd_end(void);
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 29adab8..4831d28 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -85,6 +85,8 @@ struct thread_struct {
 	unsigned long		tp2_value;
 #endif
 	struct fpsimd_state	fpsimd_state;
+	void			*sve_state;	/* SVE registers, if any */
+	unsigned int		sve_vl;		/* SVE vector length */
 	unsigned long		fault_address;	/* fault info */
 	unsigned long		fault_code;	/* ESR_EL1 value */
 	struct debug_info	debug;		/* debugging */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index ddded64..04dbf50 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -92,6 +92,7 @@ void arch_setup_new_exec(void);
 #define TIF_RESTORE_SIGMASK	20
 #define TIF_SINGLESTEP		21
 #define TIF_32BIT		22	/* 32bit process */
+#define TIF_SVE			23	/* Scalable Vector Extension in use */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.h
index d131501..69e1aaf 100644
--- a/arch/arm64/include/asm/traps.h
+++ b/arch/arm64/include/asm/traps.h
@@ -34,6 +34,8 @@ struct undef_hook {
 
 void register_undef_hook(struct undef_hook *hook);
 void unregister_undef_hook(struct undef_hook *hook);
+void force_signal_inject(int signal, int code, struct pt_regs *regs,
+			 unsigned long address);
 
 void arm64_notify_segfault(struct pt_regs *regs, unsigned long addr);
 
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e1c59d4..6718780 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -607,6 +607,8 @@ el0_sync:
 	b.eq	el0_ia
 	cmp	x24, #ESR_ELx_EC_FP_ASIMD	// FP/ASIMD access
 	b.eq	el0_fpsimd_acc
+	cmp	x24, #ESR_ELx_EC_SVE		// SVE access
+	b.eq	el0_sve_acc
 	cmp	x24, #ESR_ELx_EC_FP_EXC64	// FP/ASIMD exception
 	b.eq	el0_fpsimd_exc
 	cmp	x24, #ESR_ELx_EC_SYS64		// configurable trap
@@ -705,9 +707,19 @@ el0_fpsimd_acc:
 	mov	x1, sp
 	bl	do_fpsimd_acc
 	b	ret_to_user
+el0_sve_acc:
+	/*
+	 * Scalable Vector Extension access
+	 */
+	enable_dbg_and_irq
+	ct_user_exit
+	mov	x0, x25
+	mov	x1, sp
+	bl	do_sve_acc
+	b	ret_to_user
 el0_fpsimd_exc:
 	/*
-	 * Floating Point or Advanced SIMD exception
+	 * Floating Point, Advanced SIMD or SVE exception
 	 */
 	enable_dbg
 	ct_user_exit
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 7a865c8..e60d451 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -18,18 +18,26 @@
  */
 
 #include <linux/bottom_half.h>
+#include <linux/bug.h>
+#include <linux/compat.h>
 #include <linux/cpu.h>
 #include <linux/cpu_pm.h>
 #include <linux/kernel.h>
+#include <linux/irqflags.h>
 #include <linux/init.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
+#include <linux/ptrace.h>
 #include <linux/sched/signal.h>
 #include <linux/signal.h>
+#include <linux/slab.h>
 
 #include <asm/fpsimd.h>
 #include <asm/cputype.h>
 #include <asm/simd.h>
+#include <asm/sigcontext.h>
+#include <asm/sysreg.h>
+#include <asm/traps.h>
 
 #define FPEXC_IOF	(1 << 0)
 #define FPEXC_DZF	(1 << 1)
@@ -39,6 +47,8 @@
 #define FPEXC_IDF	(1 << 7)
 
 /*
+ * (Note: in this discussion, statements about FPSIMD apply equally to SVE.)
+ *
  * In order to reduce the number of times the FPSIMD state is needlessly saved
  * and restored, we need to keep track of two things:
  * (a) for each task, we need to remember which CPU was the last one to have
@@ -99,6 +109,287 @@
  */
 static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
 
+static void sve_free(struct task_struct *task)
+{
+	kfree(task->thread.sve_state);
+	task->thread.sve_state = NULL;
+}
+
+/* Offset of FFR in the SVE register dump */
+static size_t sve_ffr_offset(int vl)
+{
+	return SVE_SIG_FFR_OFFSET(sve_vq_from_vl(vl)) - SVE_SIG_REGS_OFFSET;
+}
+
+static void *sve_pffr(struct task_struct *task)
+{
+	return (char *)task->thread.sve_state +
+		sve_ffr_offset(task->thread.sve_vl);
+}
+
+static void change_cpacr(u64 val, u64 mask)
+{
+	u64 cpacr = read_sysreg(CPACR_EL1);
+	u64 new = (cpacr & ~mask) | val;
+
+	if (new != cpacr)
+		write_sysreg(new, CPACR_EL1);
+}
+
+static void sve_user_disable(void)
+{
+	change_cpacr(0, CPACR_EL1_ZEN_EL0EN);
+}
+
+static void sve_user_enable(void)
+{
+	change_cpacr(CPACR_EL1_ZEN_EL0EN, CPACR_EL1_ZEN_EL0EN);
+}
+
+/*
+ * TIF_SVE controls whether a task can use SVE without trapping while
+ * in userspace, and also the way a task's FPSIMD/SVE state is stored
+ * in thread_struct.
+ *
+ * The kernel uses this flag to track whether a user task is actively
+ * using SVE, and therefore whether full SVE register state needs to
+ * be tracked.  If not, the cheaper FPSIMD context handling code can
+ * be used instead of the more costly SVE equivalents.
+ *
+ *  * TIF_SVE set:
+ *
+ *    The task can execute SVE instructions while in userspace without
+ *    trapping to the kernel.
+ *
+ *    When stored, Z0-Z31 (incorporating Vn in bits[127:0] or the
+ *    corresponding Zn), P0-P15 and FFR are encoded in in
+ *    task->thread.sve_state, formatted appropriately for vector
+ *    length task->thread.sve_vl.
+ *
+ *    task->thread.sve_state must point to a valid buffer at least
+ *    sve_state_size(task) bytes in size.
+ *
+ *    During any syscall, the kernel may optionally clear TIF_SVE and
+ *    discard the vector state except for the FPSIMD subset.
+ *
+ *  * TIF_SVE clear:
+ *
+ *    An attempt by the user task to execute an SVE instruction causes
+ *    do_sve_acc() to be called, which does some preparation and then
+ *    sets TIF_SVE.
+ *
+ *    When stored, FPSIMD registers V0-V31 are encoded in
+ *    task->fpsimd_state; bits [max : 128] for each of Z0-Z31 are
+ *    logically zero but not stored anywhere; P0-P15 and FFR are not
+ *    stored and have unspecified values from userspace's point of
+ *    view.  For hygiene purposes, the kernel zeroes them on next use,
+ *    but userspace is discouraged from relying on this.
+ *
+ *    task->thread.sve_state does not need to be non-NULL, valid or any
+ *    particular size: it must not be dereferenced.
+ *
+ *  * FPSR and FPCR are always stored in task->fpsimd_state irrespctive of
+ *    whether TIF_SVE is clear or set, since these are not vector length
+ *    dependent.
+ */
+
+/*
+ * Update current's FPSIMD/SVE registers from thread_struct.
+ *
+ * This function should be called only when the FPSIMD/SVE state in
+ * thread_struct is known to be up to date, when preparing to enter
+ * userspace.
+ *
+ * Softirqs (and preemption) must be disabled.
+ */
+static void task_fpsimd_load(void)
+{
+	WARN_ON(!in_softirq() && !irqs_disabled());
+
+	if (system_supports_sve() && test_thread_flag(TIF_SVE))
+		sve_load_state(sve_pffr(current),
+			       &current->thread.fpsimd_state.fpsr,
+			       sve_vq_from_vl(current->thread.sve_vl) - 1);
+	else
+		fpsimd_load_state(&current->thread.fpsimd_state);
+
+	if (system_supports_sve()) {
+		/* Toggle SVE trapping for userspace if needed */
+		if (test_thread_flag(TIF_SVE))
+			sve_user_enable();
+		else
+			sve_user_disable();
+
+		/* Serialised by exception return to user */
+	}
+}
+
+/*
+ * Ensure current's FPSIMD/SVE storage in thread_struct is up to date
+ * with respect to the CPU registers.
+ *
+ * Softirqs (and preemption) must be disabled.
+ *
+ * As an optimisation, this function may skip the cost of saving the
+ * full SVE state if called in syscall context: this is permitted
+ * because the syscall ABI does not require the SVE registers to be
+ * preserved across system calls except for the subset shared with
+ * FPSIMD.  However, don't _assume_ that this will occur.  In the
+ * future, discarding of SVE state may be avoided for tasks that
+ * appear to use SVE heavily.
+ *
+ * SVE state may be discarded if in a syscall.
+ * To force SVE discard unconditionally, pass force_discard==true.
+ */
+static void __task_fpsimd_save(bool force_discard)
+{
+	WARN_ON(!in_softirq() && !irqs_disabled());
+
+	if (system_supports_sve() && test_thread_flag(TIF_SVE))
+		if (force_discard || in_syscall(current_pt_regs())) {
+			clear_thread_flag(TIF_SVE);
+
+			/* Trap if the task tries to use SVE again: */
+			sve_user_disable();
+		}
+
+	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
+		if (system_supports_sve() && test_thread_flag(TIF_SVE)) {
+			if (WARN_ON(sve_get_vl() != current->thread.sve_vl)) {
+				/*
+				 * Can't save the user regs, so current would
+				 * re-enter user with corrupt state.
+				 * There's no way to recover, so kill it:
+				 */
+				force_signal_inject(
+					SIGKILL, 0, current_pt_regs(), 0);
+				return;
+			}
+
+			sve_save_state(sve_pffr(current),
+				       &current->thread.fpsimd_state.fpsr);
+		} else
+			fpsimd_save_state(&current->thread.fpsimd_state);
+	}
+}
+
+static void task_fpsimd_save(void)
+{
+	__task_fpsimd_save(false);
+}
+
+#define ZREG(sve_state, vq, n) ((char *)(sve_state) +		\
+	(SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET))
+
+/*
+ * Transfer the FPSIMD state in task->thread.fpsimd_state to
+ * task->thread.sve_state.
+ *
+ * Task can be a non-runnable task, or current.  In the latter case,
+ * softirqs (and preemption) must be disabled.
+ * task->thread.sve_state must point to at least sve_state_size(task)
+ * bytes of allocated kernel memory.
+ * task->thread.fpsimd_state must be up to date before calling this function.
+ */
+static void fpsimd_to_sve(struct task_struct *task)
+{
+	unsigned int vq;
+	void *sst = task->thread.sve_state;
+	struct fpsimd_state const *fst = &task->thread.fpsimd_state;
+	unsigned int i;
+
+	if (!system_supports_sve())
+		return;
+
+	vq = sve_vq_from_vl(task->thread.sve_vl);
+	for (i = 0; i < 32; ++i)
+		memcpy(ZREG(sst, vq, i), &fst->vregs[i],
+		       sizeof(fst->vregs[i]));
+}
+
+#ifdef CONFIG_ARM64_SVE
+
+/*
+ * Return how many bytes of memory are required to store the full SVE
+ * state for task, given task's currently configured vector length.
+ */
+size_t sve_state_size(struct task_struct const *task)
+{
+	return SVE_SIG_REGS_SIZE(sve_vq_from_vl(task->thread.sve_vl));
+}
+
+/*
+ * Ensure that task->thread.sve_state is allocated and sufficiently large.
+ *
+ * This function should be used only in preparation for replacing
+ * task->thread.sve_state with new data.  The memory is always zeroed
+ * here to prevent stale data from showing through: this is done in
+ * the interest of testability and predictability: except in the
+ * do_sve_acc() case, there is no ABI requirement to hide stale data
+ * written previously be task.
+ */
+void sve_alloc(struct task_struct *task)
+{
+	if (task->thread.sve_state) {
+		memset(task->thread.sve_state, 0, sve_state_size(current));
+		return;
+	}
+
+	/* This is a small allocation (maximum ~8KB) and Should Not Fail. */
+	task->thread.sve_state =
+		kzalloc(sve_state_size(task), GFP_KERNEL);
+
+	/*
+	 * If future SVE revisions can have larger vectors though,
+	 * this may cease to be true:
+	 */
+	BUG_ON(!task->thread.sve_state);
+}
+
+void fpsimd_release_thread(struct task_struct *dead_task)
+{
+	sve_free(dead_task);
+}
+
+#endif /* CONFIG_ARM64_SVE */
+
+/*
+ * Trapped SVE access
+ *
+ * Storage is allocated for the full SVE state, the current FPSIMD
+ * register contents are migrated across, and TIF_SVE is set so that
+ * the SVE access trap will be disabled the next time this task
+ * reaches ret_to_user.
+ *
+ * TIF_SVE should be clear on entry: otherwise, task_fpsimd_load()
+ * would have disabled the SVE access trap for userspace during
+ * ret_to_user, making an SVE access trap impossible in that case.
+ */
+void do_sve_acc(unsigned int esr, struct pt_regs *regs)
+{
+	/* Even if we chose not to use SVE, the hardware could still trap: */
+	if (unlikely(!system_supports_sve()) || WARN_ON(is_compat_task())) {
+		force_signal_inject(SIGILL, ILL_ILLOPC, regs, 0);
+		return;
+	}
+
+	sve_alloc(current);
+
+	local_bh_disable();
+
+	task_fpsimd_save();
+	fpsimd_to_sve(current);
+
+	/* Force ret_to_user to reload the registers: */
+	fpsimd_flush_task_state(current);
+	set_thread_flag(TIF_FOREIGN_FPSTATE);
+
+	if (test_and_set_thread_flag(TIF_SVE))
+		WARN_ON(1); /* SVE access shouldn't have trapped */
+
+	local_bh_enable();
+}
+
 /*
  * Trapped FP/ASIMD access.
  */
@@ -144,8 +435,8 @@ void fpsimd_thread_switch(struct task_struct *next)
 	 * the registers is in fact the most recent userland FPSIMD state of
 	 * 'current'.
 	 */
-	if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
-		fpsimd_save_state(&current->thread.fpsimd_state);
+	if (current->mm)
+		task_fpsimd_save();
 
 	if (next->mm) {
 		/*
@@ -167,6 +458,8 @@ void fpsimd_thread_switch(struct task_struct *next)
 
 void fpsimd_flush_thread(void)
 {
+	int vl;
+
 	if (!system_supports_fpsimd())
 		return;
 
@@ -174,6 +467,30 @@ void fpsimd_flush_thread(void)
 
 	memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
 	fpsimd_flush_task_state(current);
+
+	if (system_supports_sve()) {
+		clear_thread_flag(TIF_SVE);
+		sve_free(current);
+
+		/*
+		 * Reset the task vector length as required.
+		 * This is where we ensure that all user tasks have a valid
+		 * vector length configured: no kernel task can become a user
+		 * task without an exec and hence a call to this function.
+		 * If a bug causes this to go wrong, we make some noise and
+		 * try to fudge thread.sve_vl to a safe value here.
+		 */
+		vl = current->thread.sve_vl;
+
+		if (vl == 0)
+			vl = SVE_VL_MIN;
+
+		if (WARN_ON(!sve_vl_valid(vl)))
+			vl = SVE_VL_MIN;
+
+		current->thread.sve_vl = vl;
+	}
+
 	set_thread_flag(TIF_FOREIGN_FPSTATE);
 
 	local_bh_enable();
@@ -182,6 +499,10 @@ void fpsimd_flush_thread(void)
 /*
  * Save the userland FPSIMD state of 'current' to memory, but only if the state
  * currently held in the registers does in fact belong to 'current'
+ *
+ * SVE state is currently discarded, but this will not be the case in future
+ * because it would violate the user ABI for SVE in some situations.
+ * Currently, SVE tasks can't exist, so just WARN in that case.
  */
 void fpsimd_preserve_current_state(void)
 {
@@ -193,10 +514,21 @@ void fpsimd_preserve_current_state(void)
 	if (!test_thread_flag(TIF_FOREIGN_FPSTATE))
 		fpsimd_save_state(&current->thread.fpsimd_state);
 
+	WARN_ON_ONCE(test_and_clear_thread_flag(TIF_SVE));
+
 	local_bh_enable();
 }
 
 /*
+ * Like fpsimd_preserve_current_state_discard_sve(), but explicitly discard SVE
+ * state.
+ */
+void fpsimd_preserve_current_state_discard_sve(void)
+{
+	fpsimd_preserve_current_state();
+}
+
+/*
  * Load the userland FPSIMD state of 'current' from memory, but only if the
  * FPSIMD state already held in the registers is /not/ the most recent FPSIMD
  * state of 'current'
@@ -211,7 +543,7 @@ void fpsimd_restore_current_state(void)
 	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
 		struct fpsimd_state *st = &current->thread.fpsimd_state;
 
-		fpsimd_load_state(st);
+		task_fpsimd_load();
 		__this_cpu_write(fpsimd_last_state, st);
 		st->cpu = smp_processor_id();
 	}
@@ -380,8 +712,8 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
 {
 	switch (cmd) {
 	case CPU_PM_ENTER:
-		if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
-			fpsimd_save_state(&current->thread.fpsimd_state);
+		if (current->mm)
+			task_fpsimd_save();
 		this_cpu_write(fpsimd_last_state, NULL);
 		break;
 	case CPU_PM_EXIT:
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 2dc0f84..8195682 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -239,13 +239,25 @@ void flush_thread(void)
 
 void release_thread(struct task_struct *dead_task)
 {
+	fpsimd_release_thread(dead_task);
 }
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
+	/*
+	 * For SVE, dst and src must not end up with aliases of the same
+	 * sve_state.  Because we are definitely in a syscall here, SVE state
+	 * can be discarded unconditionally without violating the user ABI.
+	 * dst's sve_state pointer can then be zapped with no ill effects.
+	 *
+	 * src can safely retain its sve_state memory for later use.
+	 */
 	if (current->mm)
-		fpsimd_preserve_current_state();
+		fpsimd_preserve_current_state_discard_sve();
 	*dst = *src;
+
+	dst->thread.sve_state = NULL;
+
 	return 0;
 }
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index f202932..bf54885 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -358,8 +358,8 @@ static int call_undef_hook(struct pt_regs *regs)
 	return fn ? fn(regs, instr) : 1;
 }
 
-static void force_signal_inject(int signal, int code, struct pt_regs *regs,
-				unsigned long address)
+void force_signal_inject(int signal, int code, struct pt_regs *regs,
+			 unsigned long address)
 {
 	siginfo_t info;
 	void __user *pc = (void __user *)instruction_pointer(regs);
@@ -373,7 +373,7 @@ static void force_signal_inject(int signal, int code, struct pt_regs *regs,
 		desc = "illegal memory access";
 		break;
 	default:
-		desc = "bad mode";
+		desc = "unknown or unrecoverable error";
 		break;
 	}
 
-- 
2.1.4
