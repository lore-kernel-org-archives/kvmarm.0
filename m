From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v5 13/30] arm64/sve: Core task context handling
Date: Thu, 09 Nov 2017 17:16:40 +0000
Message-ID: <878tffqsnb.fsf@linaro.org>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com> <1509465082-30427-14-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
In-reply-to: <1509465082-30427-14-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


Dave Martin <Dave.Martin@arm.com> writes:

> This patch adds the core support for switching and managing the SVE
> architectural state of user tasks.
>
> Calls to the existing FPSIMD low-level save/restore functions are
> factored out as new functions task_fpsimd_{save,load}(), since SVE
> now dynamically may or may not need to be handled at these points
> depending on the kernel configuration, hardware features discovered
> at boot, and the runtime state of the task.  To make these
> decisions as fast as possible, const cpucaps are used where
> feasible, via the system_supports_sve() helper.
>
> The SVE registers are only tracked for threads that have explicitly
> used SVE, indicated by the new thread flag TIF_SVE.  Otherwise, the
> FPSIMD view of the architectural state is stored in
> thread.fpsimd_state as usual.
>
> When in use, the SVE registers are not stored directly in
> thread_struct due to their potentially large and variable size.
> Because the task_struct slab allocator must be configured very
> early during kernel boot, it is also tricky to configure it
> correctly to match the maximum vector length provided by the
> hardware, since this depends on examining secondary CPUs as well as
> the primary.  Instead, a pointer sve_state in thread_struct points
> to a dynamically allocated buffer containing the SVE register data,
> and code is added to allocate and free this buffer at appropriate
> times.
>
> TIF_SVE is set when taking an SVE access trap from userspace, if
> suitable hardware support has been detected.  This enables SVE for
> the thread: a subsequent return to userspace will disable the trap
> accordingly.  If such a trap is taken without sufficient system-
> wide hardware support, SIGILL is sent to the thread instead as if
> an undefined instruction had been executed: this may happen if
> userspace tries to use SVE in a system where not all CPUs support
> it for example.
>
> The kernel will clear TIF_SVE and disable SVE for the thread
> whenever an explicit syscall is made by userspace.  For backwards
> compatibility reasons and conformance with the spirit of the base
> AArch64 procedure call standard, the subset of the SVE register
> state that aliases the FPSIMD registers is still preserved across a
> syscall even if this happens.  The remainder of the SVE register
> state logically becomes zero at syscall entry, though the actual
> zeroing work is currently deferred until the thread next tries to
> use SVE, causing another trap to the kernel.  This implementation
> is suboptimal: in the future, the fastpath case may be optimised
> to zero the registers in-place and leave SVE enabled for the task,
> where beneficial.
>
> TIF_SVE is also cleared in the following slowpath cases, which are
> taken as reasonable hints that the task may no longer use SVE:
>  * exec
>  * fork and clone
>
> Code is added to sync data between thread.fpsimd_state and
> thread.sve_state whenever enabling/disabling SVE, in a manner
> consistent with the SVE architectural programmer's model.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> ---
>
> Kept Catalin's Reviewed-by, since this is a trivial change.
>
> Changes since v4
> ----------------
>
> Miscellaneous:
>
>  * Mark do_sve_acc() as asmlinkage.
>
>    (Semantic correctness only; no functional impact.)
> ---
>  arch/arm64/include/asm/fpsimd.h      |  16 ++
>  arch/arm64/include/asm/processor.h   |   2 +
>  arch/arm64/include/asm/thread_info.h |   4 +
>  arch/arm64/include/asm/traps.h       |   2 +
>  arch/arm64/kernel/entry.S            |  39 ++++-
>  arch/arm64/kernel/fpsimd.c           | 324 +++++++++++++++++++++++++++++=
+++++-
>  arch/arm64/kernel/process.c          |  24 +++
>  arch/arm64/kernel/traps.c            |   6 +-
>  8 files changed, 406 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fps=
imd.h
> index 026a7c7..5655fe1 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -20,6 +20,8 @@
>
>  #ifndef __ASSEMBLY__
>
> +#include <linux/stddef.h>
> +
>  /*
>   * FP/SIMD storage area has:
>   *  - FPSR and FPCR
> @@ -72,6 +74,20 @@ extern void sve_load_state(void const *state, u32 cons=
t *pfpsr,
>  			   unsigned long vq_minus_1);
>  extern unsigned int sve_get_vl(void);
>
> +#ifdef CONFIG_ARM64_SVE
> +
> +extern size_t sve_state_size(struct task_struct const *task);
> +
> +extern void sve_alloc(struct task_struct *task);
> +extern void fpsimd_release_task(struct task_struct *task);
> +
> +#else /* ! CONFIG_ARM64_SVE */
> +
> +static inline void sve_alloc(struct task_struct *task) { }
> +static inline void fpsimd_release_task(struct task_struct *task) { }
> +
> +#endif /* ! CONFIG_ARM64_SVE */
> +
>  /* For use by EFI runtime services calls only */
>  extern void __efi_fpsimd_begin(void);
>  extern void __efi_fpsimd_end(void);
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/=
processor.h
> index 7dddca2..e2f575d 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -105,6 +105,8 @@ struct thread_struct {
>  	unsigned long		tp2_value;
>  #endif
>  	struct fpsimd_state	fpsimd_state;
> +	void			*sve_state;	/* SVE registers, if any */
> +	unsigned int		sve_vl;		/* SVE vector length */
>  	unsigned long		fault_address;	/* fault info */
>  	unsigned long		fault_code;	/* ESR_EL1 value */
>  	struct debug_info	debug;		/* debugging */
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/as=
m/thread_info.h
> index ddded64..92b7b48 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -63,6 +63,8 @@ struct thread_info {
>  void arch_setup_new_exec(void);
>  #define arch_setup_new_exec     arch_setup_new_exec
>
> +void arch_release_task_struct(struct task_struct *tsk);
> +
>  #endif
>
>  /*
> @@ -92,6 +94,7 @@ void arch_setup_new_exec(void);
>  #define TIF_RESTORE_SIGMASK	20
>  #define TIF_SINGLESTEP		21
>  #define TIF_32BIT		22	/* 32bit process */
> +#define TIF_SVE			23	/* Scalable Vector Extension in use */
>
>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
> @@ -105,6 +108,7 @@ void arch_setup_new_exec(void);
>  #define _TIF_UPROBE		(1 << TIF_UPROBE)
>  #define _TIF_FSCHECK		(1 << TIF_FSCHECK)
>  #define _TIF_32BIT		(1 << TIF_32BIT)
> +#define _TIF_SVE		(1 << TIF_SVE)
>
>  #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
>  				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
> diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/trap=
s.h
> index 45e3da3..1696f9d 100644
> --- a/arch/arm64/include/asm/traps.h
> +++ b/arch/arm64/include/asm/traps.h
> @@ -34,6 +34,8 @@ struct undef_hook {
>
>  void register_undef_hook(struct undef_hook *hook);
>  void unregister_undef_hook(struct undef_hook *hook);
> +void force_signal_inject(int signal, int code, struct pt_regs *regs,
> +			 unsigned long address);
>
>  void arm64_notify_segfault(struct pt_regs *regs, unsigned long addr);
>
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index f5e851e..56e848f 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -607,6 +607,8 @@ el0_sync:
>  	b.eq	el0_ia
>  	cmp	x24, #ESR_ELx_EC_FP_ASIMD	// FP/ASIMD access
>  	b.eq	el0_fpsimd_acc
> +	cmp	x24, #ESR_ELx_EC_SVE		// SVE access
> +	b.eq	el0_sve_acc

I'm guessing there is a point that this long chain of cmp instructions
is better handled with a jump table? One for the maintainer though I
guess?

>  	cmp	x24, #ESR_ELx_EC_FP_EXC64	// FP/ASIMD exception
>  	b.eq	el0_fpsimd_exc
>  	cmp	x24, #ESR_ELx_EC_SYS64		// configurable trap
> @@ -658,6 +660,7 @@ el0_svc_compat:
>  	/*
>  	 * AArch32 syscall handling
>  	 */
> +	ldr	x16, [tsk, #TSK_TI_FLAGS]	// load thread flags
>  	adrp	stbl, compat_sys_call_table	// load compat syscall table pointer
>  	mov	wscno, w7			// syscall number in w7 (r7)
>  	mov     wsc_nr, #__NR_compat_syscalls
> @@ -705,9 +708,19 @@ el0_fpsimd_acc:
>  	mov	x1, sp
>  	bl	do_fpsimd_acc
>  	b	ret_to_user
> +el0_sve_acc:
> +	/*
> +	 * Scalable Vector Extension access
> +	 */
> +	enable_dbg_and_irq
> +	ct_user_exit
> +	mov	x0, x25
> +	mov	x1, sp
> +	bl	do_sve_acc
> +	b	ret_to_user
>  el0_fpsimd_exc:
>  	/*
> -	 * Floating Point or Advanced SIMD exception
> +	 * Floating Point, Advanced SIMD or SVE exception
>  	 */
>  	enable_dbg
>  	ct_user_exit
> @@ -835,16 +848,36 @@ ENDPROC(ret_to_user)
>   */
>  	.align	6
>  el0_svc:
> +	ldr	x16, [tsk, #TSK_TI_FLAGS]	// load thread flags
>  	adrp	stbl, sys_call_table		// load syscall table pointer
>  	mov	wscno, w8			// syscall number in w8
>  	mov	wsc_nr, #__NR_syscalls
> +
> +#ifndef CONFIG_ARM64_SVE
> +	b	el0_svc_naked

Hmm we've hoisted the ldr x16, [tsk, #TSK_TI_FLAGS] out of el0_svc_naked
but we'll still be testing the bit when CONFIG_ARM64_SVE isn't enabled?

I'm not clear why you couldn't keep that where it was?

> +#else
> +	tbz	x16, #TIF_SVE, el0_svc_naked	// Skip unless TIF_SVE set:
> +	bic	x16, x16, #_TIF_SVE		// discard SVE state
> +	str	x16, [tsk, #TSK_TI_FLAGS]
> +
> +	/*
> +	 * task_fpsimd_load() won't be called to update CPACR_EL1 in
> +	 * ret_to_user unless TIF_FOREIGN_FPSTATE is still set, which only
> +	 * happens if a context switch or kernel_neon_begin() or context
> +	 * modification (sigreturn, ptrace) intervenes.
> +	 * So, ensure that CPACR_EL1 is already correct for the fast-path case:
> +	 */
> +	mrs	x9, cpacr_el1
> +	bic	x9, x9, #CPACR_EL1_ZEN_EL0EN	// disable SVE for el0
> +	msr	cpacr_el1, x9			// synchronised by eret to el0
> +#endif /* CONFIG_ARM64_SVE */
> +
>  el0_svc_naked:					// compat entry point
>  	stp	x0, xscno, [sp, #S_ORIG_X0]	// save the original x0 and syscall num=
ber
>  	enable_dbg_and_irq
>  	ct_user_exit 1
>
> -	ldr	x16, [tsk, #TSK_TI_FLAGS]	// check for syscall hooks
> -	tst	x16, #_TIF_SYSCALL_WORK
> +	tst	x16, #_TIF_SYSCALL_WORK		// check for syscall hooks
>  	b.ne	__sys_trace
>  	cmp     wscno, wsc_nr			// check upper syscall limit
>  	b.hs	ni_sys
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 2baba0d..787f5d3 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -18,19 +18,27 @@
>   */
>
>  #include <linux/bottom_half.h>
> +#include <linux/bug.h>
> +#include <linux/compat.h>
>  #include <linux/cpu.h>
>  #include <linux/cpu_pm.h>
>  #include <linux/kernel.h>
>  #include <linux/linkage.h>
> +#include <linux/irqflags.h>
>  #include <linux/init.h>
>  #include <linux/percpu.h>
>  #include <linux/preempt.h>
> +#include <linux/ptrace.h>
>  #include <linux/sched/signal.h>
>  #include <linux/signal.h>
> +#include <linux/slab.h>
>
>  #include <asm/fpsimd.h>
>  #include <asm/cputype.h>
>  #include <asm/simd.h>
> +#include <asm/sigcontext.h>
> +#include <asm/sysreg.h>
> +#include <asm/traps.h>
>
>  #define FPEXC_IOF	(1 << 0)
>  #define FPEXC_DZF	(1 << 1)
> @@ -40,6 +48,8 @@
>  #define FPEXC_IDF	(1 << 7)
>
>  /*
> + * (Note: in this discussion, statements about FPSIMD apply equally to S=
VE.)
> + *
>   * In order to reduce the number of times the FPSIMD state is needlessly=
 saved
>   * and restored, we need to keep track of two things:
>   * (a) for each task, we need to remember which CPU was the last one to =
have
> @@ -101,6 +111,279 @@
>  static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
>
>  /*
> + * Call __sve_free() directly only if you know task can't be scheduled
> + * or preempted.
> + */
> +static void __sve_free(struct task_struct *task)
> +{
> +	kfree(task->thread.sve_state);
> +	task->thread.sve_state =3D NULL;
> +}
> +
> +static void sve_free(struct task_struct *task)
> +{
> +	WARN_ON(test_tsk_thread_flag(task, TIF_SVE));
> +
> +	__sve_free(task);
> +}
> +
> +
> +/* Offset of FFR in the SVE register dump */
> +static size_t sve_ffr_offset(int vl)
> +{
> +	return SVE_SIG_FFR_OFFSET(sve_vq_from_vl(vl)) - SVE_SIG_REGS_OFFSET;
> +}
> +
> +static void *sve_pffr(struct task_struct *task)
> +{
> +	return (char *)task->thread.sve_state +
> +		sve_ffr_offset(task->thread.sve_vl);
> +}
> +
> +static void change_cpacr(u64 val, u64 mask)
> +{
> +	u64 cpacr =3D read_sysreg(CPACR_EL1);
> +	u64 new =3D (cpacr & ~mask) | val;
> +
> +	if (new !=3D cpacr)
> +		write_sysreg(new, CPACR_EL1);
> +}
> +
> +static void sve_user_disable(void)
> +{
> +	change_cpacr(0, CPACR_EL1_ZEN_EL0EN);
> +}
> +
> +static void sve_user_enable(void)
> +{
> +	change_cpacr(CPACR_EL1_ZEN_EL0EN, CPACR_EL1_ZEN_EL0EN);
> +}
> +
> +/*
> + * TIF_SVE controls whether a task can use SVE without trapping while
> + * in userspace, and also the way a task's FPSIMD/SVE state is stored
> + * in thread_struct.
> + *
> + * The kernel uses this flag to track whether a user task is actively
> + * using SVE, and therefore whether full SVE register state needs to
> + * be tracked.  If not, the cheaper FPSIMD context handling code can
> + * be used instead of the more costly SVE equivalents.
> + *
> + *  * TIF_SVE set:
> + *
> + *    The task can execute SVE instructions while in userspace without
> + *    trapping to the kernel.
> + *
> + *    When stored, Z0-Z31 (incorporating Vn in bits[127:0] or the
> + *    corresponding Zn), P0-P15 and FFR are encoded in in
> + *    task->thread.sve_state, formatted appropriately for vector
> + *    length task->thread.sve_vl.
> + *
> + *    task->thread.sve_state must point to a valid buffer at least
> + *    sve_state_size(task) bytes in size.
> + *
> + *    During any syscall, the kernel may optionally clear TIF_SVE and
> + *    discard the vector state except for the FPSIMD subset.
> + *
> + *  * TIF_SVE clear:
> + *
> + *    An attempt by the user task to execute an SVE instruction causes
> + *    do_sve_acc() to be called, which does some preparation and then
> + *    sets TIF_SVE.
> + *
> + *    When stored, FPSIMD registers V0-V31 are encoded in
> + *    task->fpsimd_state; bits [max : 128] for each of Z0-Z31 are
> + *    logically zero but not stored anywhere; P0-P15 and FFR are not
> + *    stored and have unspecified values from userspace's point of
> + *    view.  For hygiene purposes, the kernel zeroes them on next use,
> + *    but userspace is discouraged from relying on this.
> + *
> + *    task->thread.sve_state does not need to be non-NULL, valid or any
> + *    particular size: it must not be dereferenced.
> + *
> + *  * FPSR and FPCR are always stored in task->fpsimd_state irrespctive =
of
> + *    whether TIF_SVE is clear or set, since these are not vector length
> + *    dependent.
> + */
> +
> +/*
> + * Update current's FPSIMD/SVE registers from thread_struct.
> + *
> + * This function should be called only when the FPSIMD/SVE state in
> + * thread_struct is known to be up to date, when preparing to enter
> + * userspace.
> + *
> + * Softirqs (and preemption) must be disabled.
> + */
> +static void task_fpsimd_load(void)
> +{
> +	WARN_ON(!in_softirq() && !irqs_disabled());
> +
> +	if (system_supports_sve() && test_thread_flag(TIF_SVE))
> +		sve_load_state(sve_pffr(current),
> +			       &current->thread.fpsimd_state.fpsr,
> +			       sve_vq_from_vl(current->thread.sve_vl) - 1);
> +	else
> +		fpsimd_load_state(&current->thread.fpsimd_state);
> +
> +	if (system_supports_sve()) {
> +		/* Toggle SVE trapping for userspace if needed */
> +		if (test_thread_flag(TIF_SVE))
> +			sve_user_enable();
> +		else
> +			sve_user_disable();
> +
> +		/* Serialised by exception return to user */
> +	}
> +}
> +
> +/*
> + * Ensure current's FPSIMD/SVE storage in thread_struct is up to date
> + * with respect to the CPU registers.
> + *
> + * Softirqs (and preemption) must be disabled.
> + */
> +static void task_fpsimd_save(void)
> +{
> +	WARN_ON(!in_softirq() && !irqs_disabled());
> +
> +	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
> +		if (system_supports_sve() && test_thread_flag(TIF_SVE)) {
> +			if (WARN_ON(sve_get_vl() !=3D current->thread.sve_vl)) {
> +				/*
> +				 * Can't save the user regs, so current would
> +				 * re-enter user with corrupt state.
> +				 * There's no way to recover, so kill it:
> +				 */
> +				force_signal_inject(
> +					SIGKILL, 0, current_pt_regs(), 0);
> +				return;
> +			}
> +
> +			sve_save_state(sve_pffr(current),
> +				       &current->thread.fpsimd_state.fpsr);
> +		} else
> +			fpsimd_save_state(&current->thread.fpsimd_state);
> +	}
> +}
> +
> +#define ZREG(sve_state, vq, n) ((char *)(sve_state) +		\
> +	(SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET))
> +
> +/*
> + * Transfer the FPSIMD state in task->thread.fpsimd_state to
> + * task->thread.sve_state.
> + *
> + * Task can be a non-runnable task, or current.  In the latter case,
> + * softirqs (and preemption) must be disabled.
> + * task->thread.sve_state must point to at least sve_state_size(task)
> + * bytes of allocated kernel memory.
> + * task->thread.fpsimd_state must be up to date before calling this func=
tion.
> + */
> +static void fpsimd_to_sve(struct task_struct *task)
> +{
> +	unsigned int vq;
> +	void *sst =3D task->thread.sve_state;
> +	struct fpsimd_state const *fst =3D &task->thread.fpsimd_state;
> +	unsigned int i;
> +
> +	if (!system_supports_sve())
> +		return;
> +
> +	vq =3D sve_vq_from_vl(task->thread.sve_vl);
> +	for (i =3D 0; i < 32; ++i)
> +		memcpy(ZREG(sst, vq, i), &fst->vregs[i],
> +		       sizeof(fst->vregs[i]));
> +}
> +
> +#ifdef CONFIG_ARM64_SVE
> +
> +/*
> + * Return how many bytes of memory are required to store the full SVE
> + * state for task, given task's currently configured vector length.
> + */
> +size_t sve_state_size(struct task_struct const *task)
> +{
> +	return SVE_SIG_REGS_SIZE(sve_vq_from_vl(task->thread.sve_vl));
> +}
> +
> +/*
> + * Ensure that task->thread.sve_state is allocated and sufficiently larg=
e.
> + *
> + * This function should be used only in preparation for replacing
> + * task->thread.sve_state with new data.  The memory is always zeroed
> + * here to prevent stale data from showing through: this is done in
> + * the interest of testability and predictability: except in the
> + * do_sve_acc() case, there is no ABI requirement to hide stale data
> + * written previously be task.
> + */
> +void sve_alloc(struct task_struct *task)
> +{
> +	if (task->thread.sve_state) {
> +		memset(task->thread.sve_state, 0, sve_state_size(current));
> +		return;
> +	}
> +
> +	/* This is a small allocation (maximum ~8KB) and Should Not Fail. */
> +	task->thread.sve_state =3D
> +		kzalloc(sve_state_size(task), GFP_KERNEL);
> +
> +	/*
> +	 * If future SVE revisions can have larger vectors though,
> +	 * this may cease to be true:
> +	 */
> +	BUG_ON(!task->thread.sve_state);
> +}
> +
> +/*
> + * Called from the put_task_struct() path, which cannot get here
> + * unless dead_task is really dead and not schedulable.
> + */
> +void fpsimd_release_task(struct task_struct *dead_task)
> +{
> +	__sve_free(dead_task);
> +}
> +
> +#endif /* CONFIG_ARM64_SVE */
> +
> +/*
> + * Trapped SVE access
> + *
> + * Storage is allocated for the full SVE state, the current FPSIMD
> + * register contents are migrated across, and TIF_SVE is set so that
> + * the SVE access trap will be disabled the next time this task
> + * reaches ret_to_user.
> + *
> + * TIF_SVE should be clear on entry: otherwise, task_fpsimd_load()
> + * would have disabled the SVE access trap for userspace during
> + * ret_to_user, making an SVE access trap impossible in that case.
> + */
> +asmlinkage void do_sve_acc(unsigned int esr, struct pt_regs *regs)
> +{
> +	/* Even if we chose not to use SVE, the hardware could still trap: */
> +	if (unlikely(!system_supports_sve()) || WARN_ON(is_compat_task())) {
> +		force_signal_inject(SIGILL, ILL_ILLOPC, regs, 0);
> +		return;
> +	}
> +
> +	sve_alloc(current);
> +
> +	local_bh_disable();
> +
> +	task_fpsimd_save();
> +	fpsimd_to_sve(current);
> +
> +	/* Force ret_to_user to reload the registers: */
> +	fpsimd_flush_task_state(current);
> +	set_thread_flag(TIF_FOREIGN_FPSTATE);
> +
> +	if (test_and_set_thread_flag(TIF_SVE))
> +		WARN_ON(1); /* SVE access shouldn't have trapped */
> +
> +	local_bh_enable();
> +}
> +
> +/*
>   * Trapped FP/ASIMD access.
>   */
>  asmlinkage void do_fpsimd_acc(unsigned int esr, struct pt_regs *regs)
> @@ -145,8 +428,8 @@ void fpsimd_thread_switch(struct task_struct *next)
>  	 * the registers is in fact the most recent userland FPSIMD state of
>  	 * 'current'.
>  	 */
> -	if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
> -		fpsimd_save_state(&current->thread.fpsimd_state);
> +	if (current->mm)
> +		task_fpsimd_save();
>
>  	if (next->mm) {
>  		/*
> @@ -168,6 +451,8 @@ void fpsimd_thread_switch(struct task_struct *next)
>
>  void fpsimd_flush_thread(void)
>  {
> +	int vl;
> +
>  	if (!system_supports_fpsimd())
>  		return;
>
> @@ -175,6 +460,30 @@ void fpsimd_flush_thread(void)
>
>  	memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
>  	fpsimd_flush_task_state(current);
> +
> +	if (system_supports_sve()) {
> +		clear_thread_flag(TIF_SVE);
> +		sve_free(current);
> +
> +		/*
> +		 * Reset the task vector length as required.
> +		 * This is where we ensure that all user tasks have a valid
> +		 * vector length configured: no kernel task can become a user
> +		 * task without an exec and hence a call to this function.
> +		 * If a bug causes this to go wrong, we make some noise and
> +		 * try to fudge thread.sve_vl to a safe value here.
> +		 */
> +		vl =3D current->thread.sve_vl;
> +
> +		if (vl =3D=3D 0)
> +			vl =3D SVE_VL_MIN;
> +
> +		if (WARN_ON(!sve_vl_valid(vl)))
> +			vl =3D SVE_VL_MIN;
> +
> +		current->thread.sve_vl =3D vl;
> +	}
> +
>  	set_thread_flag(TIF_FOREIGN_FPSTATE);
>
>  	local_bh_enable();
> @@ -183,6 +492,9 @@ void fpsimd_flush_thread(void)
>  /*
>   * Save the userland FPSIMD state of 'current' to memory, but only if th=
e state
>   * currently held in the registers does in fact belong to 'current'
> + *
> + * Currently, SVE tasks can't exist, so just WARN in that case.
> + * Subsequent patches will add full SVE support here.
>   */
>  void fpsimd_preserve_current_state(void)
>  {
> @@ -194,6 +506,8 @@ void fpsimd_preserve_current_state(void)
>  	if (!test_thread_flag(TIF_FOREIGN_FPSTATE))
>  		fpsimd_save_state(&current->thread.fpsimd_state);
>
> +	WARN_ON_ONCE(test_and_clear_thread_flag(TIF_SVE));
> +
>  	local_bh_enable();
>  }
>
> @@ -212,7 +526,7 @@ void fpsimd_restore_current_state(void)
>  	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
>  		struct fpsimd_state *st =3D &current->thread.fpsimd_state;
>
> -		fpsimd_load_state(st);
> +		task_fpsimd_load();
>  		__this_cpu_write(fpsimd_last_state, st);
>  		st->cpu =3D smp_processor_id();
>  	}
> @@ -381,8 +695,8 @@ static int fpsimd_cpu_pm_notifier(struct notifier_blo=
ck *self,
>  {
>  	switch (cmd) {
>  	case CPU_PM_ENTER:
> -		if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
> -			fpsimd_save_state(&current->thread.fpsimd_state);
> +		if (current->mm)
> +			task_fpsimd_save();
>  		this_cpu_write(fpsimd_last_state, NULL);
>  		break;
>  	case CPU_PM_EXIT:
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index c15ec41..b2adcce 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -49,6 +49,7 @@
>  #include <linux/notifier.h>
>  #include <trace/events/power.h>
>  #include <linux/percpu.h>
> +#include <linux/thread_info.h>
>
>  #include <asm/alternative.h>
>  #include <asm/compat.h>
> @@ -273,11 +274,27 @@ void release_thread(struct task_struct *dead_task)
>  {
>  }
>
> +void arch_release_task_struct(struct task_struct *tsk)
> +{
> +	fpsimd_release_task(tsk);
> +}
> +
> +/*
> + * src and dst may temporarily have aliased sve_state after task_struct
> + * is copied.  We cannot fix this properly here, because src may have
> + * live SVE state and dst's thread_info may not exist yet, so tweaking
> + * either src's or dst's TIF_SVE is not safe.
> + *
> + * The unaliasing is done in copy_thread() instead.  This works because
> + * dst is not schedulable or traceable until both of these functions
> + * have been called.
> + */
>  int arch_dup_task_struct(struct task_struct *dst, struct task_struct *sr=
c)
>  {
>  	if (current->mm)
>  		fpsimd_preserve_current_state();
>  	*dst =3D *src;
> +
>  	return 0;
>  }
>
> @@ -290,6 +307,13 @@ int copy_thread(unsigned long clone_flags, unsigned =
long stack_start,
>
>  	memset(&p->thread.cpu_context, 0, sizeof(struct cpu_context));
>
> +	/*
> +	 * Unalias p->thread.sve_state (if any) from the parent task
> +	 * and disable discard SVE state for p:
> +	 */
> +	clear_tsk_thread_flag(p, TIF_SVE);
> +	p->thread.sve_state =3D NULL;
> +
>  	if (likely(!(p->flags & PF_KTHREAD))) {
>  		*childregs =3D *current_pt_regs();
>  		childregs->regs[0] =3D 0;
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 18c0290..9d3c7f0 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -310,8 +310,8 @@ static int call_undef_hook(struct pt_regs *regs)
>  	return fn ? fn(regs, instr) : 1;
>  }
>
> -static void force_signal_inject(int signal, int code, struct pt_regs *re=
gs,
> -				unsigned long address)
> +void force_signal_inject(int signal, int code, struct pt_regs *regs,
> +			 unsigned long address)
>  {
>  	siginfo_t info;
>  	void __user *pc =3D (void __user *)instruction_pointer(regs);
> @@ -325,7 +325,7 @@ static void force_signal_inject(int signal, int code,=
 struct pt_regs *regs,
>  		desc =3D "illegal memory access";
>  		break;
>  	default:
> -		desc =3D "bad mode";
> +		desc =3D "unknown or unrecoverable error";
>  		break;
>  	}

Is this a separate trivial clean-up patch? It seems like you should
handle SIGKILL explicitly?
