From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 11/28] arm64/sve: Core task context handling
Date: Wed, 11 Oct 2017 17:15:58 +0100
Message-ID: <20171011161558.ts7adaryabttg47z@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-12-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-12-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:28PM +0100, Dave P Martin wrote:
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index 026a7c7..b1409de 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -72,6 +75,20 @@ extern void sve_load_state(void const *state, u32 const *pfpsr,
>  			   unsigned long vq_minus_1);
>  extern unsigned int sve_get_vl(void);
>  
> +#ifdef CONFIG_ARM64_SVE
> +
> +extern size_t sve_state_size(struct task_struct const *task);
> +
> +extern void sve_alloc(struct task_struct *task);
> +extern void fpsimd_release_thread(struct task_struct *task);
> +
> +#else /* ! CONFIG_ARM64_SVE */
> +
> +static void __maybe_unused sve_alloc(struct task_struct *task) { }
> +static void __maybe_unused fpsimd_release_thread(struct task_struct *task) { }

Nitpick: usually we just add static inline functions here rather than
__maybe_unused.

> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 29adab8..4831d28 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -39,6 +47,8 @@
>  #define FPEXC_IDF	(1 << 7)
>  
>  /*
> + * (Note: in this discussion, statements about FPSIMD apply equally to SVE.)
> + *
>   * In order to reduce the number of times the FPSIMD state is needlessly saved
>   * and restored, we need to keep track of two things:
>   * (a) for each task, we need to remember which CPU was the last one to have
> @@ -99,6 +109,287 @@
>   */
>  static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
>  
> +static void sve_free(struct task_struct *task)
> +{
> +	kfree(task->thread.sve_state);
> +	task->thread.sve_state = NULL;
> +}

I think we need a WARN_ON if TIF_SVE is still set here (and the callers
making sure it is cleared). I haven't checked the code paths via
fpsimd_release_thread() but wondering what happens if we get an
interrupt between freeing the state and making the pointer NULL, with
some context switching in a preemptible kernel.

Alternatively, always clear TIF_SVE here before freeing (also wondering
whether we should make sve_state NULL before the actual freeing but I
think TIF_SVE clearing should suffice).

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
> + *  * FPSR and FPCR are always stored in task->fpsimd_state irrespctive of
> + *    whether TIF_SVE is clear or set, since these are not vector length
> + *    dependent.
> + */

This looks fine, thanks for adding the description.

-- 
Catalin
