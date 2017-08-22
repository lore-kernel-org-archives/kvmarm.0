From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 11/27] arm64/sve: Core task context handling
Date: Tue, 22 Aug 2017 17:21:19 +0100
Message-ID: <87378jbmkg.fsf@linaro.org>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com> <1502280338-23002-12-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-reply-to: <1502280338-23002-12-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
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
>  			   unsigned long vq_minus_1);
>  extern unsigned int sve_get_vl(void);
>
> +#ifdef CONFIG_ARM64_SVE
> +
> +extern size_t sve_state_size(struct task_struct const *task);
> +
> +extern void sve_alloc(struct task_struct *task);
> +extern void fpsimd_release_thread(struct task_struct *task);
> +extern void fpsimd_dup_sve(struct task_struct *dst,
> +			   struct task_struct const *src);
> +
> +#else /* ! CONFIG_ARM64_SVE */
> +
> +static void __maybe_unused sve_alloc(struct task_struct *task) { }
> +static void __maybe_unused fpsimd_release_thread(struct task_struct *task) { }
> +static void __maybe_unused fpsimd_dup_sve(struct task_struct *dst,
> +					  struct task_struct const *src) { }
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
>  	unsigned long		tp2_value;
>  #endif
>  	struct fpsimd_state	fpsimd_state;
> +	void			*sve_state;	/* SVE registers, if any */
> +	u16			sve_vl;		/* SVE vector length */

sve_vl is implicitly cast to unsigned int bellow - it should be
consistent.

Given the allocation functions rely on sve_vl being valid it might be
worth noting where this is set/live from?

>  	unsigned long		fault_address;	/* fault info */
>  	unsigned long		fault_code;	/* ESR_EL1 value */
>  	struct debug_info	debug;		/* debugging */
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 46c3b93..1a4b30b 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
<snip>

And I see there are other comments from Ard.
