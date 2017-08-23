From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 13/27] arm64/sve: Signal handling support
Date: Wed, 23 Aug 2017 12:30:26 +0100
Message-ID: <20170823113025.GA6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-14-git-send-email-Dave.Martin@arm.com>
 <87y3qaaaj8.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87y3qaaaj8.fsf@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 23, 2017 at 10:38:51AM +0100, Alex Bennée wrote:
> 
> Dave Martin <Dave.Martin@arm.com> writes:
> 
> > This patch implements support for saving and restoring the SVE
> > registers around signals.
> >
> > A fixed-size header struct sve_context is always included in the
> > signal frame encoding the thread's vector length at the time of
> > signal delivery, optionally followed by a variable-layout structure
> > encoding the SVE registers.
> >
> > Because of the need to preserve backwards compatibility, the FPSIMD
> > view of the SVE registers is always dumped as a struct
> > fpsimd_context in the usual way, in addition to any sve_context.
> >
> > The SVE vector registers are dumped in full, including bits 127:0
> > of each register which alias the corresponding FPSIMD vector
> > registers in the hardware.  To avoid any ambiguity about which
> > alias to restore during sigreturn, the kernel always restores bits
> > 127:0 of each SVE vector register from the fpsimd_context in the
> > signal frame (which must be present): userspace needs to take this
> > into account if it wants to modify the SVE vector register contents
> > on return from a signal.
> >
> > FPSR and FPCR, which are used by both FPSIMD and SVE, are not
> > included in sve_context because they are always present in
> > fpsimd_context anyway.
> >
> > For signal delivery, a new helper
> > fpsimd_signal_preserve_current_state() is added to update _both_
> > the FPSIMD and SVE views in the task struct, to make it easier to
> > populate this information into the signal frame.  Because of the
> > redundancy between the two views of the state, only one is updated
> > otherwise.  In order to avoid racing with a pending discard of the
> > SVE state, this flush is hoisted before the sigframe layout phase,
> > so that the layout and population phases see a consistent view of
> > the thread.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---

[...]

> > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> > index 80ecb2d..e8674f6 100644
> > --- a/arch/arm64/kernel/fpsimd.c
> > +++ b/arch/arm64/kernel/fpsimd.c
> > @@ -148,8 +148,6 @@ static void change_cpacr(u64 old, u64 new)
> >  		write_sysreg(new, CPACR_EL1);
> >  }
> >
> > -#ifdef CONFIG_ARM64_SVE
> > -
> >  #define ZREG(sve_state, vq, n) ((char *)(sve_state) +		\
> >  	(SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET))
> >
> > @@ -191,6 +189,8 @@ static void fpsimd_to_sve(struct task_struct *task)
> >  		       sizeof(fst->vregs[i]));
> >  }
> >
> > +#ifdef CONFIG_ARM64_SVE
> > +
> 
> Hmm have sve_to_fpsimd and fpsimd_to_sve only just started being used by
> the generic code here?

Yes, the signal code now makes use of these via
fpsimd_signal_preserve_current_state() and
fpsimd_update_current_state(), with this patch.

[...]

> > diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> > index 4991e87..2694143 100644
> > --- a/arch/arm64/kernel/signal.c
> > +++ b/arch/arm64/kernel/signal.c

[...]

> > +#ifdef CONFIG_ARM64_SVE
> > +
> > +static int preserve_sve_context(struct sve_context __user *ctx)
> > +{
> > +	int err = 0;
> > +	u16 reserved[ARRAY_SIZE(ctx->__reserved)];
> > +	unsigned int vl = current->thread.sve_vl;
> > +	unsigned int vq = 0;
> > +
> > +	BUG_ON(!sve_vl_valid(vl));
> > +	if (test_thread_flag(TIF_SVE))
> > +		vq = sve_vq_from_vl(vl);
> > +
> > +	memset(reserved, 0, sizeof(reserved));
> > +
> > +	__put_user_error(SVE_MAGIC, &ctx->head.magic, err);
> > +	__put_user_error(round_up(SVE_SIG_CONTEXT_SIZE(vq), 16),
> > +			 &ctx->head.size, err);
> > +	__put_user_error(vl, &ctx->vl, err);
> > +	BUILD_BUG_ON(sizeof(ctx->__reserved) != sizeof(reserved));
> > +	err |= copy_to_user(&ctx->__reserved, reserved, sizeof(reserved));
> > +
> > +	if (vq) {
> > +		/*
> > +		 * This assumes that the SVE state has already been saved to
> > +		 * the task struct by calling preserve_fpsimd_context().
> > +		 */
> > +		BUG_ON(SVE_SIG_REGS_SIZE(vq) !=
> > sve_state_size(current));
> 
> I think others have mentioned the excessive BUG_ON()s here but I think
> you are planning on cleaning some up on the next version. Assuming
> sve_vq_from_vl() can't give you an invalid answer from a
> sve_vl_valid(vl) then I wouldn't expect this test to add much.

Agreed.  Some BUG_ON()s test for things that are now obviously true
by construction, which was not initially the case during development.
This one can go away.

I'm very interested in any BUG_ON() that you think can actually fire.
There _shouldn't_ be any of those, but the reasons are non-trivial in
some cases.

> > +		err |= copy_to_user((char __user *)ctx + SVE_SIG_REGS_OFFSET,
> > +				    current->thread.sve_state,
> > +				    SVE_SIG_REGS_SIZE(vq));
> > +	}
> > +
> > +	return err ? -EFAULT : 0;
> > +}
> > +
> > +static int restore_sve_fpsimd_context(struct user_ctxs *user)
> > +{
> > +	int err;
> > +	unsigned int vq;
> > +	struct fpsimd_state fpsimd;
> > +	struct sve_context sve;
> > +
> > +	if (__copy_from_user(&sve, user->sve, sizeof(sve)))
> > +		return -EFAULT;
> > +
> > +	if (sve.vl != current->thread.sve_vl)
> > +		return -EINVAL;
> > +
> > +	if (sve.head.size <= sizeof(*user->sve)) {
> > +		clear_thread_flag(TIF_SVE);
> > +		goto fpsimd_only;
> > +	}
> > +
> > +	BUG_ON(!sve_vl_valid(sve.vl));
> > +	vq = sve_vq_from_vl(sve.vl);
> > +
> > +	if (sve.head.size < SVE_SIG_CONTEXT_SIZE(vq))
> > +		return -EINVAL;
> > +
> > +	fpsimd_flush_task_state(current);
> > +	barrier();
> > +	set_thread_flag(TIF_FOREIGN_FPSTATE);
> > +	barrier();
> 
> What are you trying to achieve with barriers here? Is there a potential
> interaction between flushing the state and setting the flag that the
> compiler can't see? A comment should be added at least.

This is a tricky one -- I suppose I should definitely add comments,
since it took me 2-3 weeks to debug this and get it right the first time
around...

I'm trying to protect against a context switch during the copy_from_user
rewriting stale register data over the data we're copying from the user
signal frame.

In most places, I now disable preemption when writing into thread_struct,
to keep this can of worms firmly closed.

Here though, the code writes directly into thread_struct with
preemption enabled: in this one case the copy is a copy_from_user(),
and we can't disable preemption for that.  Other than this, the reasons
for this code being the way it is derive from Ard's deferred fpsimd
reload machinery (the TIF_FOREIGN_FPSTATE stuff), which is described in
more detail in fpsimd.c.


The reason for the difference from the old fpsimd code here is that the
SVE state may be unreasonably large to bounce via a buffer on the stack,
and the copy-in occurs while the thread is running.  In the ptrace case
(later on) the thread is guaranteed stopped, whereas for fpsimd the
state is small enough that we _can_ bounce it via the stack.

TIF_FOREIGN_FPSTATE may be cleared by the context switch code, but only
if fpsimd_flush_task_state() wasn't called since the last kernel entry
for current.  (See fpsimd_thread_switch().)

The context switch code may write the CPU registers over thread_struct,
but only if TIF_FOREIGN_FPSTATE is not set at sched-out time.
(fpsimd_thread_switch() again).

These dependencies are strictly intra-thread, since context-switch is
part of the same thread, so

	fpsimd_flush_task_state();
	barrier();
	set_thread_flag(TIF_FOREIGN_FPSTATE);
	barrier();
	copy_from_user(current->thread.sve_state, ...);

should be sufficient.

I prefer to avoid spuriously saving the SVE regs into thread_struct
when they may not already be live, so I don't set TIF_SVE until after
TIF_FOREIGN_FPSTATE is set.  (This is a cost saving rather than a
security issue -- only current's state can be in the registers, but the
extra SVE bits are definitely not worth saving.  In any case, it only
makes a difference to context switches in this narrow window.)

> > +
> > +	sve_alloc(current);
> > +	BUG_ON(SVE_SIG_REGS_SIZE(vq) != sve_state_size(current));
> > +	err = __copy_from_user(current->thread.sve_state,
> > +			       (char __user const *)user->sve +
> > +					SVE_SIG_REGS_OFFSET,
> > +			       SVE_SIG_REGS_SIZE(vq));
> > +	if (err)
> > +		return err;
> > +
> > +	barrier();
> > +	set_thread_flag(TIF_SVE);
> 
> Hmm and again. If this is about visibility of context when the thread
> flag is read by other CPUs a barrier() on it's own is not enough as it
> only stop local code re-organisation - do you actually mean smp_mb()?
> 
> Either way you need to document the potential race in a comment so the
> reason can be understood.

The final barrier() isn't really needed, and the ordering of TIF_SVE
with the copy_from_user is unimportant unless I've missed something ...
so I may get rid of that.  TIF_SVE would affect context switch, but
only if TIF_FOREIGN_FPSTATE is clear or a ret_to_user occurs, neither
of which is possible after the second barrier().


Re smp_mb(), the only cross-thread ordering guarantees needed are for
ptrace (later in the series), since that runs in some thread operating
on a stopped thread that may have last run on some other CPU.  But this
is a general ptrace issue, not specifically related to SVE.  IIRC some
interaction between the ptrace core code and the scheduler's
manipulation of the task state and runqueue locks ensures safety in
that case without need for extra smp_mb() all over the place.

> > +
> > +fpsimd_only:
> > +	/* copy the FP and status/control registers */
> > +	/* restore_sigframe() already checked that user->fpsimd != NULL. */
> > +	err = __copy_from_user(fpsimd.vregs, user->fpsimd->vregs,
> > +			       sizeof(fpsimd.vregs));
> > +	__get_user_error(fpsimd.fpsr, &user->fpsimd->fpsr, err);
> > +	__get_user_error(fpsimd.fpcr, &user->fpsimd->fpcr, err);
> > +
> > +	/* load the hardware registers from the fpsimd_state structure */
> > +	if (!err)
> > +		fpsimd_update_current_state(&fpsimd);
> > +
> > +	return err;
> > +}

[...]

Cheers
---Dave
