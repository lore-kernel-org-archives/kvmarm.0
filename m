From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 11/27] arm64/sve: Core task context handling
Date: Tue, 15 Aug 2017 18:31:05 +0100
Message-ID: <CAKv+Gu-Rei0LP9q77+KHtD4JqM-6j4XvQjG7oCLrjHx2M5DA7g@mail.gmail.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com> <1502280338-23002-12-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1502280338-23002-12-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, libc-alpha@sourceware.org, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 9 August 2017 at 13:05, Dave Martin <Dave.Martin@arm.com> wrote:
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
> and code is added to allocate, duplicate and free this buffer at
> appropriate times.
>
> TIF_SVE is set when taking an SVE access trap from userspace, if
> suitable hardware support has been detected.  This enables SVE for
> the thread: a subsequent return to userspace will disable the trap
> accordingly.  If such a trap is taken without sufficient hardware
> support, SIGILL is sent to the thread instead as if an undefined
> instruction had been executed: this may happen if userspace tries
> to use SVE in a system where not all CPUs support it for example.
>
> The kernel may clear TIF_SVE and disable SVE for the thread
> whenever an explicit syscall is made by userspace, though this is
> considered an optimisation opportunity rather than a deterministic
> guarantee: the kernel may not do this on every syscall, but it is
> permitted to do so.  For backwards compatibility reasons and
> conformance with the spirit of the base AArch64 procedure call
> standard, the subset of the SVE register state that aliases the
> FPSIMD registers is still preserved across a syscall even if this
> happens.
>
> TIF_SVE is also cleared, and SVE disabled, on exec: this is an
> obvious slow path and a hint that we are running a new binary that
> may not use SVE.
>
> Code is added to sync data between thread.fpsimd_state and
> thread.sve_state whenever enabling/disabling SVE, in a manner
> consistent with the SVE architectural programmer's model.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/include/asm/fpsimd.h      |  19 +++
>  arch/arm64/include/asm/processor.h   |   2 +
>  arch/arm64/include/asm/thread_info.h |   1 +
>  arch/arm64/include/asm/traps.h       |   2 +
>  arch/arm64/kernel/entry.S            |  14 +-
>  arch/arm64/kernel/fpsimd.c           | 241 ++++++++++++++++++++++++++++++++++-
>  arch/arm64/kernel/process.c          |   6 +-
>  arch/arm64/kernel/traps.c            |   4 +-
>  8 files changed, 279 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index 026a7c7..72090a1 100644
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
> @@ -72,6 +74,23 @@ extern void sve_load_state(void const *state, u32 const *pfpsr,
>                            unsigned long vq_minus_1);
>  extern unsigned int sve_get_vl(void);
>
> +#ifdef CONFIG_ARM64_SVE
> +
> +extern size_t sve_state_size(struct task_struct const *task);
> +
> +extern void sve_alloc(struct task_struct *task);
> +extern void fpsimd_release_thread(struct task_struct *task);
> +extern void fpsimd_dup_sve(struct task_struct *dst,
> +                          struct task_struct const *src);
> +
> +#else /* ! CONFIG_ARM64_SVE */
> +
> +static void __maybe_unused sve_alloc(struct task_struct *task) { }
> +static void __maybe_unused fpsimd_release_thread(struct task_struct *task) { }
> +static void __maybe_unused fpsimd_dup_sve(struct task_struct *dst,
> +                                         struct task_struct const *src) { }
> +#endif /* ! CONFIG_ARM64_SVE */
> +
>  /* For use by EFI runtime services calls only */
>  extern void __efi_fpsimd_begin(void);
>  extern void __efi_fpsimd_end(void);
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index b7334f1..969feed 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -85,6 +85,8 @@ struct thread_struct {
>         unsigned long           tp2_value;
>  #endif
>         struct fpsimd_state     fpsimd_state;
> +       void                    *sve_state;     /* SVE registers, if any */
> +       u16                     sve_vl;         /* SVE vector length */
>         unsigned long           fault_address;  /* fault info */
>         unsigned long           fault_code;     /* ESR_EL1 value */
>         struct debug_info       debug;          /* debugging */
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 46c3b93..1a4b30b 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -96,6 +96,7 @@ struct thread_info {
>  #define TIF_RESTORE_SIGMASK    20
>  #define TIF_SINGLESTEP         21
>  #define TIF_32BIT              22      /* 32bit process */
> +#define TIF_SVE                        23      /* Scalable Vector Extension in use */
>
>  #define _TIF_SIGPENDING                (1 << TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED      (1 << TIF_NEED_RESCHED)
> diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.h
> index 02e9035..f058c07 100644
> --- a/arch/arm64/include/asm/traps.h
> +++ b/arch/arm64/include/asm/traps.h
> @@ -34,6 +34,8 @@ struct undef_hook {
>
>  void register_undef_hook(struct undef_hook *hook);
>  void unregister_undef_hook(struct undef_hook *hook);
> +void force_signal_inject(int signal, int code, struct pt_regs *regs,
> +                        unsigned long address);
>
>  void arm64_notify_segfault(struct pt_regs *regs, unsigned long addr);
>
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index cace76d..c33069c 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -524,6 +524,8 @@ el0_sync:
>         b.eq    el0_ia
>         cmp     x24, #ESR_ELx_EC_FP_ASIMD       // FP/ASIMD access
>         b.eq    el0_fpsimd_acc
> +       cmp     x24, #ESR_ELx_EC_SVE            // SVE access
> +       b.eq    el0_sve_acc
>         cmp     x24, #ESR_ELx_EC_FP_EXC64       // FP/ASIMD exception
>         b.eq    el0_fpsimd_exc
>         cmp     x24, #ESR_ELx_EC_SYS64          // configurable trap
> @@ -622,9 +624,19 @@ el0_fpsimd_acc:
>         mov     x1, sp
>         bl      do_fpsimd_acc
>         b       ret_to_user
> +el0_sve_acc:
> +       /*
> +        * Scalable Vector Extension access
> +        */
> +       enable_dbg
> +       ct_user_exit
> +       mov     x0, x25
> +       mov     x1, sp
> +       bl      do_sve_acc
> +       b       ret_to_user
>  el0_fpsimd_exc:
>         /*
> -        * Floating Point or Advanced SIMD exception
> +        * Floating Point, Advanced SIMD or SVE exception
>          */
>         enable_dbg
>         ct_user_exit
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 9c1f268e..37dd1b2 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -24,12 +24,17 @@
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
>  #define FPEXC_IOF      (1 << 0)
>  #define FPEXC_DZF      (1 << 1)
> @@ -38,6 +43,10 @@
>  #define FPEXC_IXF      (1 << 4)
>  #define FPEXC_IDF      (1 << 7)
>
> +/* Forward declarations for local functions used by both SVE and FPSIMD */
> +static void task_fpsimd_load(void);
> +static void task_fpsimd_save(void);
> +

We usually try to avoid forward declarations for functions with static
linkage. Is it possible to reorder them and get rid of this?

>  /*
>   * In order to reduce the number of times the FPSIMD state is needlessly saved
>   * and restored, we need to keep track of two things:
> @@ -99,6 +108,160 @@
>   */
>  static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
>
> +static void sve_free(struct task_struct *task)
> +{
> +       kfree(task->thread.sve_state);
> +       task->thread.sve_state = NULL;
> +}
> +
> +/* Offset of FFR in the SVE register dump */
> +static size_t sve_ffr_offset(int vl)
> +{
> +       BUG_ON(!sve_vl_valid(vl));

BUG_ON() is a pretty heavy hammer, so we should not use it unless the
kernel state is so corrupted that there is no way to carry on. I have
a feeling this may not be the case for some of the occurrences in this
patch.

> +       return SVE_SIG_FFR_OFFSET(sve_vq_from_vl(vl)) - SVE_SIG_REGS_OFFSET;
> +}
> +
> +static void *sve_pffr(struct task_struct *task)
> +{
> +       unsigned int vl = task->thread.sve_vl;
> +
> +       BUG_ON(!sve_vl_valid(vl) || !task->thread.sve_state);
> +       return (char *)task->thread.sve_state + sve_ffr_offset(vl);
> +}
> +
> +static u64 sve_cpacr_trap_on(u64 cpacr)
> +{
> +       return cpacr & ~(u64)CPACR_EL1_ZEN_EL0EN;
> +}
> +
> +static u64 sve_cpacr_trap_off(u64 cpacr)
> +{
> +       return cpacr | CPACR_EL1_ZEN_EL0EN;
> +}
> +
> +static void change_cpacr(u64 old, u64 new)
> +{
> +       if (old != new)
> +               write_sysreg(new, CPACR_EL1);
> +}
> +
> +#ifdef CONFIG_ARM64_SVE
> +
> +#define ZREG(sve_state, vq, n) ((char *)(sve_state) +          \
> +       (SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET))
> +
> +static void sve_to_fpsimd(struct task_struct *task)
> +{
> +       unsigned int vl = task->thread.sve_vl;
> +       unsigned int vq;
> +       void const *sst = task->thread.sve_state;
> +       struct fpsimd_state *fst = &task->thread.fpsimd_state;
> +       unsigned int i;
> +
> +       if (!system_supports_sve())
> +               return;
> +
> +       BUG_ON(!sve_vl_valid(vl));
> +       vq = sve_vq_from_vl(vl);
> +
> +       for (i = 0; i < 32; ++i)
> +               memcpy(&fst->vregs[i], ZREG(sst, vq, i),
> +                      sizeof(fst->vregs[i]));
> +}
> +
> +static void fpsimd_to_sve(struct task_struct *task)
> +{
> +       unsigned int vl = task->thread.sve_vl;
> +       unsigned int vq;
> +       void *sst = task->thread.sve_state;
> +       struct fpsimd_state const *fst = &task->thread.fpsimd_state;
> +       unsigned int i;
> +
> +       if (!system_supports_sve())
> +               return;
> +
> +       BUG_ON(!sve_vl_valid(vl));
> +       vq = sve_vq_from_vl(vl);
> +
> +       for (i = 0; i < 32; ++i)
> +               memcpy(ZREG(sst, vq, i), &fst->vregs[i],
> +                      sizeof(fst->vregs[i]));
> +}
> +
> +size_t sve_state_size(struct task_struct const *task)
> +{
> +       unsigned int vl = task->thread.sve_vl;
> +
> +       BUG_ON(!sve_vl_valid(vl));
> +       return SVE_SIG_REGS_SIZE(sve_vq_from_vl(vl));
> +}
> +
> +void sve_alloc(struct task_struct *task)
> +{
> +       if (task->thread.sve_state) {
> +               memset(task->thread.sve_state, 0, sve_state_size(current));
> +               return;
> +       }
> +
> +       /* This is a small allocation (maximum ~8KB) and Should Not Fail. */
> +       task->thread.sve_state =
> +               kzalloc(sve_state_size(task), GFP_KERNEL);
> +
> +       /*
> +        * If future SVE revisions can have larger vectors though,
> +        * this may cease to be true:
> +        */
> +       BUG_ON(!task->thread.sve_state);
> +}
> +
> +/*
> + * Handle SVE state across fork():
> + *
> + * dst and src must not end up with aliases of the same sve_state.
> + * Because a task cannot fork except in a syscall, we can discard SVE
> + * state for dst here: reallocation will be deferred until dst tries
> + * to use SVE.
> + */
> +void fpsimd_dup_sve(struct task_struct *dst, struct task_struct const *src)
> +{
> +       BUG_ON(!in_syscall(task_pt_regs(dst)));
> +
> +       if (test_and_clear_tsk_thread_flag(dst, TIF_SVE)) {
> +               sve_to_fpsimd(dst);
> +               dst->thread.sve_state = NULL;
> +       }
> +}
> +
> +void fpsimd_release_thread(struct task_struct *dead_task)
> +{
> +       sve_free(dead_task);
> +}
> +
> +#endif /* CONFIG_ARM64_SVE */
> +
> +/*
> + * Trapped SVE access
> + */
> +void do_sve_acc(unsigned int esr, struct pt_regs *regs)
> +{
> +       BUG_ON(is_compat_task());
> +
> +       /* Even if we chose not to use SVE, the hardware could still trap: */
> +       if (unlikely(!system_supports_sve())) {
> +               force_signal_inject(SIGILL, ILL_ILLOPC, regs, 0);
> +               return;
> +       }
> +
> +       task_fpsimd_save();
> +
> +       sve_alloc(current);
> +       fpsimd_to_sve(current);
> +       if (test_and_set_thread_flag(TIF_SVE))
> +               WARN_ON(1); /* SVE access shouldn't have trapped */
> +
> +       task_fpsimd_load();
> +}
> +
>  /*
>   * Trapped FP/ASIMD access.
>   */
> @@ -135,6 +298,55 @@ void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
>         send_sig_info(SIGFPE, &info, current);
>  }
>
> +static void task_fpsimd_load(void)
> +{
> +       if (system_supports_sve() && test_thread_flag(TIF_SVE)) {
> +               unsigned int vl = current->thread.sve_vl;
> +
> +               BUG_ON(!sve_vl_valid(vl));
> +               sve_load_state(sve_pffr(current),
> +                              &current->thread.fpsimd_state.fpsr,
> +                              sve_vq_from_vl(vl) - 1);
> +       } else
> +               fpsimd_load_state(&current->thread.fpsimd_state);
> +

Please use braces consistently on all branches of an if ()

> +       if (system_supports_sve()) {
> +               u64 cpacr = read_sysreg(CPACR_EL1);
> +               u64 new_cpacr;
> +
> +               /* Toggle SVE trapping for userspace if needed */
> +               if (test_thread_flag(TIF_SVE))
> +                       new_cpacr = sve_cpacr_trap_off(cpacr);
> +               else
> +                       new_cpacr = sve_cpacr_trap_on(cpacr);
> +
> +               change_cpacr(cpacr, new_cpacr);

I understand you want to avoid setting CPACR to the same value, but
this does look a bit clunky IMO. Wouldn't it be much better to have a
generic accessor with a mask and a value that encapsulates this?

> +               /* Serialised by exception return to user */
> +       }
> +}
> +
> +static void task_fpsimd_save(void)
> +{
> +       if (system_supports_sve() &&
> +           in_syscall(current_pt_regs()) &&
> +           test_thread_flag(TIF_SVE)) {
> +               u64 cpacr = read_sysreg(CPACR_EL1);
> +
> +               clear_thread_flag(TIF_SVE);
> +
> +               /* Trap if the task tries to use SVE again: */
> +               change_cpacr(cpacr, sve_cpacr_trap_on(cpacr));
> +       }
> +
> +       if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
> +               if (system_supports_sve() && test_thread_flag(TIF_SVE))
> +                       sve_save_state(sve_pffr(current),
> +                                      &current->thread.fpsimd_state.fpsr);
> +               else
> +                       fpsimd_save_state(&current->thread.fpsimd_state);
> +       }
> +}
> +
>  void fpsimd_thread_switch(struct task_struct *next)
>  {
>         if (!system_supports_fpsimd())
> @@ -144,8 +356,8 @@ void fpsimd_thread_switch(struct task_struct *next)
>          * the registers is in fact the most recent userland FPSIMD state of
>          * 'current'.
>          */
> -       if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
> -               fpsimd_save_state(&current->thread.fpsimd_state);
> +       if (current->mm)
> +               task_fpsimd_save();
>
>         if (next->mm) {
>                 /*
> @@ -172,8 +384,25 @@ void fpsimd_flush_thread(void)
>
>         local_bh_disable();
>
> -       memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
>         fpsimd_flush_task_state(current);
> +
> +       memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
> +

Any reason in particular this needs to be reordered?

> +       if (system_supports_sve()) {
> +               clear_thread_flag(TIF_SVE);
> +               sve_free(current);
> +
> +               /*
> +                * User tasks must have a valid vector length set, but tasks
> +                * forked early (e.g., init) may not initially have one.
> +                * By now, we will know what the hardware supports, so
> +                * sve_default_vl should be valid, and thus the above
> +                * assignment should ensure a valid VL for the task.
> +                * If not, something went badly wrong.
> +                */
> +               BUG_ON(!sve_vl_valid(current->thread.sve_vl));
> +       }
> +
>         set_thread_flag(TIF_FOREIGN_FPSTATE);
>
>         local_bh_enable();
> @@ -211,7 +440,7 @@ void fpsimd_restore_current_state(void)
>         if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
>                 struct fpsimd_state *st = &current->thread.fpsimd_state;
>
> -               fpsimd_load_state(st);
> +               task_fpsimd_load();
>                 __this_cpu_write(fpsimd_last_state, st);
>                 st->cpu = smp_processor_id();
>         }
> @@ -375,8 +604,8 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
>  {
>         switch (cmd) {
>         case CPU_PM_ENTER:
> -               if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
> -                       fpsimd_save_state(&current->thread.fpsimd_state);
> +               if (current->mm)
> +                       task_fpsimd_save();
>                 this_cpu_write(fpsimd_last_state, NULL);
>                 break;
>         case CPU_PM_EXIT:
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 659ae80..e51cb1f 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -239,13 +239,17 @@ void flush_thread(void)
>
>  void release_thread(struct task_struct *dead_task)
>  {
> +       fpsimd_release_thread(dead_task);
>  }
>
>  int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
>  {
>         if (current->mm)
>                 fpsimd_preserve_current_state();
> -       *dst = *src;
> +       memcpy(dst, src, arch_task_struct_size);
> +
> +       fpsimd_dup_sve(dst, src);
> +

Is this used for anything except fork()? If not, do we really need to
duplicate the SVE state?

>         return 0;
>  }
>
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 8964795..286064e 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -379,8 +379,8 @@ static int call_undef_hook(struct pt_regs *regs)
>         return fn ? fn(regs, instr) : 1;
>  }
>
> -static void force_signal_inject(int signal, int code, struct pt_regs *regs,
> -                               unsigned long address)
> +void force_signal_inject(int signal, int code, struct pt_regs *regs,
> +                        unsigned long address)
>  {
>         siginfo_t info;
>         void __user *pc = (void __user *)instruction_pointer(regs);
> --
> 2.1.4
>
