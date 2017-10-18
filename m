From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 19/28] arm64/sve: ptrace and ELF coredump support
Date: Wed, 18 Oct 2017 17:02:03 +0100
Message-ID: <20171018160202.GC19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-20-git-send-email-Dave.Martin@arm.com>
 <20171012170632.35zifttm55rzu745@armageddon.cambridge.arm.com>
 <20171013161638.GM19485@e103592.cambridge.arm.com>
 <20171018103254.c5ddwnzfz5ghhgad@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171018103254.c5ddwnzfz5ghhgad@armageddon.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, Alan Hayward <alan.hayward@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 18, 2017 at 11:32:55AM +0100, Catalin Marinas wrote:
> On Fri, Oct 13, 2017 at 05:16:39PM +0100, Dave P Martin wrote:
> > On Thu, Oct 12, 2017 at 06:06:32PM +0100, Catalin Marinas wrote:
> > > On Tue, Oct 10, 2017 at 07:38:36PM +0100, Dave P Martin wrote:
> > > > @@ -702,6 +737,211 @@ static int system_call_set(struct task_struct *target,
> > > >  	return ret;
> > > >  }
> > > >  
> > > > +#ifdef CONFIG_ARM64_SVE
> > > > +
> > > > +static void sve_init_header_from_task(struct user_sve_header *header,
> > > > +				      struct task_struct *target)
> > > > +{
> > > > +	unsigned int vq;
> > > > +
> > > > +	memset(header, 0, sizeof(*header));
> > > > +
> > > > +	header->flags = test_tsk_thread_flag(target, TIF_SVE) ?
> > > > +		SVE_PT_REGS_SVE : SVE_PT_REGS_FPSIMD;
> > > 
> > > For PTRACE_SYSCALL, we may or may not have TIF_SVE depending on what
> > > happened with the target. Just a thought: shall we clear TIF_SVE (and
> > > sync it to fpsimd) in syscall_trace_enter()?
> > 
> > I'm not so sure: if we were to do that, a syscall that is cancelled by
> > writing -1 to REGSET_SYSCALL could still discard the SVE registers as a
> > side-effect.
> > 
> > The target committed to discard by executing SVC, but my feeling is
> > that cancellation of a syscall in this way shouldn't have avoidable
> > side-effects for the target.  But the semantics of cancelled syscalls
> > are a bit of a grey area, so I can see potential arguments on both
> > sides.
> 
> We already can't guarantee this - if the task invoking a syscall gets
> preempted before syscall_trace_enter(), TIF_SVE will be cleared. Are you
> reinstating TIF_SVE if the syscall was cancelled?
> 
> So my comment was more about consistency on presenting the SVE state to
> the debugger handling PTRACE_SYSCALL.

See the end of this reply.

> > > > +	/* Registers: FPSIMD-only case */
> > > > +
> > > > +	BUILD_BUG_ON(SVE_PT_FPSIMD_OFFSET != sizeof(header));
> > > > +	if ((header.flags & SVE_PT_REGS_MASK) == SVE_PT_REGS_FPSIMD) {
> > > > +		sve_sync_to_fpsimd(target);
> > > > +
> > > > +		ret = __fpr_set(target, regset, pos, count, kbuf, ubuf,
> > > > +				SVE_PT_FPSIMD_OFFSET);
> > > > +		clear_tsk_thread_flag(target, TIF_SVE);
> > > > +		goto out;
> > > > +	}
> > > 
> > > __fpr_set() already calls sve_sync_to_fpsimd(). Anyway, do you actually
> > 
> > Yes, the call to sve_sync_to_fpsimd() is superfluous here -- I think
> > that I realised that all callers of __fpr_set() need this to happen,
> > but never deleted the explicit call from sve_set().
> > 
> > I'll delete it.
> > 
> > 
> > Looking more closely at __fpr_set() though, I think it needs this change
> > too, because the sync is unintentionally placed after reading
> > thread.fpsimd_state instead of before:
> > 
> > @@ -652,11 +652,12 @@ static int __fpr_set(struct task_struct *target,
> >                      unsigned int start_pos)
> >  {
> >         int ret;
> > -       struct user_fpsimd_state newstate =
> > -               target->thread.fpsimd_state.user_fpsimd;
> > +       struct user_fpsimd_state newstate;
> >  
> >         sve_sync_to_fpsimd(target);
> >  
> > +       newstate = target->thread.fpsimd_state.user_fpsimd;
> > +
> >         ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &newstate,
> > [...]
> > 
> > (Or were you confident that this was already OK?  Maybe I'm confusing
> > myself.)
> 
> With the sve_sync_to_fpsimd() called before __fpr_set(), it was ok. Once
> you removed that you indeed need the change to __fpr_set().

Hmmm, yes.  Anyway, I've applied the above fix, so I think this should
be fine now.

> > > need this since we are going to override the FPSIMD state anyway here.
> > 
> > The underlying reason for this is the issue of what should happen
> > for short regset writes.  Historically, writes through fpr_set() can
> > be truncated arbitrarily, and the rest of fpsimd_state will remain
> > unchanged.
> 
> Ah, I forgot about this.
> 
> > The issue is that if TIF_SVE is set, fpsimd_state can be stale for
> > target.  If the initial sve_sync_to_fpsimd() is removed in sve_set()
> > above, then we may resurrect old values for the untouched registers,
> > instead of simply leaving them unmodified.
> > 
> > Should I add comments explaining the purpose?  I guess it is rather
> > non-obvious.
> 
> Yes, please.

Will do.  It's pretty yucky.

> 
> > > > +	set_tsk_thread_flag(target, TIF_SVE);
> > > 
> > > This has the side-effect of enabling TIF_SVE even for PTRACE_SYSCALL
> > > which may be cleared in some circumstances. It may not be an issue
> > > though.
> > 
> > I would argue that this is correct behaviour: the syscall enter trap and
> > exit traps should both behave as if they are outside the syscall,
> > allowing the debugger to simulate the effect of inserting any
> > instructions the target could have inserted before or after the SVC.
> > This may include simulating SVE instructions or modifying SVE regs,
> > which would require TIF_SVE to get set.
> 
> I'm ok with this approach but I'm not sure we can guarantee it with
> preemption enabled.

Hmmm, I think I'm guilty of inventing a spurious argument here.


Apparently gdb does not do syscall cancelling.

Strace does though.
(See http://man7.org/linux/man-pages/man1/strace.1.html, search for
"syscall tampering" ;)

However, it never tries to skip a syscall entirelity AFAICT:
instead, it only attempts to fake what occurs during the syscall,
such as bailing out with a predetermined return value.

> > If the tracer doesn't cancel the syscall at the enter trap, then a
> > real syscall will execute and that may cause the SVE state to be
> > discarded in the usual way in the case of preemption or blocking: it
> > seems cleaner for the debug illusion that this decision isn't made
> > differently just because the target is being traced.
> > 
> > (Spoiler alert though: the syscall exit trap will force the target
> > to be scheduled out, which will force discard with the current
> > task_fpsimd_save() behaviour ... but that could be changed in the
> > future, and I prefer not to document any sort of guarantee here.)
> 
> If such state isn't guaranteed, then the de-facto ABI is that the
> debugger cannot simulate any SVE instruction via NO_SYSCALL since the
> SVE state may be discarded. So it can only rely on what's guaranteed and
> changing the behaviour later won't actually help.

I think you're right.

Simulating the content of the syscall does work though, and doesn't
depend on whether SVE discard occurs or not.

If the tracer sets the SVE regs at the syscall enter/exit traps,
they could still be discarded again before the tracee reenters
userspace, but that's no different from what happens in a real
syscall.


So I think my overall argument would be:

ptrace should be as orthogonal as possible to SVE discard.


Currently ptrace neither assumes that SVE discard will happen or that it
won't: it just does what the tracer asks for and tries to be safe with
either and doesn't try to hide the effects from the tracer or tracee.

I worry that introducing more interdependencies between ptrace and the
fpsimd.c code will complicate maintenance rather than making it easier.

Does that may my position clearer?

If we go with this, I should add a note to the documentation explaining
how NT_ARM_SVE writes interact with ptrace syscall traps.


The alternative would be to forcibly discard SVE in
syscall_trace_enter(), but this doesn't seem to simplify the NT_ARM_SVE
implementation at all -- that code needs to work for all types of
ptrace-stop, not just syscall traps: other that syscall traps, SVE
is potentially live for the tracee and must not be discarded.
So I'm still not clear on what the gain is.

Cheers
---Dave
