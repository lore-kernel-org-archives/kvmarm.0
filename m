From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 11/28] arm64/sve: Core task context handling
Date: Fri, 6 Oct 2017 14:10:09 +0100
Message-ID: <20171006131005.GA3611@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-12-git-send-email-Dave.Martin@arm.com>
 <20170913143325.hi4cfcajbts3bbao@localhost>
 <20171003113302.GR3611@e103592.cambridge.arm.com>
 <20171005112835.2rhaqx23bhe6tnwl@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171005112835.2rhaqx23bhe6tnwl@armageddon.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 05, 2017 at 12:28:35PM +0100, Catalin Marinas wrote:
> On Tue, Oct 03, 2017 at 12:33:03PM +0100, Dave P Martin wrote:
> > On Wed, Sep 13, 2017 at 07:33:25AM -0700, Catalin Marinas wrote:
> > > On Thu, Aug 31, 2017 at 06:00:43PM +0100, Dave P Martin wrote:
> > > > +/*
> > > > + * Handle SVE state across fork():
> > > > + *
> > > > + * dst and src must not end up with aliases of the same sve_state.
> > > > + * Because a task cannot fork except in a syscall, we can discard SVE
> > > > + * state for dst here, so long as we take care to retain the FPSIMD
> > > > + * subset of the state if SVE is in use.  Reallocation of the SVE state
> > > > + * will be deferred until dst tries to use SVE.
> > > > + */
> > > > +void fpsimd_dup_sve(struct task_struct *dst, struct task_struct const *src)
> > > > +{
> > > > +	if (test_and_clear_tsk_thread_flag(dst, TIF_SVE)) {
> > > > +		WARN_ON(dst->mm && !in_syscall(task_pt_regs(dst)));
> > > > +		sve_to_fpsimd(dst);
> > > > +	}
> > > > +
> > > > +	dst->thread.sve_state = NULL;
> > > > +}
> > > 
> > > I first thought the thread flags are not visible in dst yet since
> > > dup_task_struct() calls arch_dup_task_struct() before
> > > setup_thread_stack(). However, at the end of the last year we enabled
> > > CONFIG_THREAD_INFO_IN_TASK_STRUCT. But I don't particularly like relying
> > > on this.
> > > 
> > > Anyway, IIUC we don't need sve_to_fpsimd() here. The
> > > arch_dup_task_struct() already called fpsimd_preserve_current_state()
> > > for src, so the FPSIMD state (which we care about) is transferred during
> > > the *dst = *src assignment. So you'd only need the last statement,
> > > possibly with a different function name like fpsimd_erase_sve (and maybe
> > > make the function static inline in the header).
> > 
> > Regarding the intended meanings of the thread flags, does this help?
> > 
> > --8<--
> > 
> > TIF_FOREIGN_FPSTATE's meaning is expanded to cover SVE, but otherwise
> > unchanged:
> > 
> >  * If a task is running and !TIF_FOREIGN_FPSTATE, then the the CPU
> >    registers of the CPU the task is running on contain the authoritative
> >    FPSIMD/SVE state of the task.  The backing memory may be stale.
> > 
> >  * Otherwise (i.e., task not running, or task running and
> >    TIF_FOREIGN_FPSTATE), the task's FPSIMD/SVE backing memory is
> >    authoritative.  If additionally per_cpu(fpsimd_last_state,
> >    task->fpsimd_state.cpu) == &task->fpsimd_state.cpu, then
> >    task->fpsimd_state.cpu's registers are also up to date for task, but
> >    not authorititive: the current FPSIMD/SVE state may be read from
> >    them, but they must not be written.
> >  
> > The FPSIMD/SVE backing memory is selected by TIF_SVE:
> > 
> >  * TIF_SVE set: Zn (incorporating Vn in bits[127:0]), Pn and FFR are
> >    stored in task->thread.sve_state, formatted appropriately for vector
> >    length task->thread.sve_vl.  task->thread.sve_state must point to a
> >    valid buffer at least sve_state_size(task) bytes in size.
> > 
> >  * TIF_SVE clear: Vn are stored in task->fpsimd_state; Zn[max : 128] are
> >    logically zero[*] but not stored anywhere; Pn, FFR are not stored and
> >    have unspecified values from userspace's point of view.
> >    task->thread.sve_state does not need to be non-null, valid or any
> >    particular size: it must not be dereferenced.
> > 
> >    In practice I don't exploit the "unspecifiedness" much.  The Zn high
> >    bits, Pn and FFR are all zeroed when setting TIF_SVE again:
> >    sve_alloc() is the common path for this.
> > 
> >  * FPSR and FPCR are always stored in task->fpsimd_state irrespctive of
> >    whether TIF_SVE is clear or set, since these are not vector length
> >    dependent.
> 
> This looks fine. I think we need to make sure (with a warning) that
> task_fpsimd_save() (and probably load) is always called in a
> non-preemptible context. 
> 
> > [*] theoretically unspecified, which is what I've written in sve.txt.
> > However, on any FPSIMD Vn write the upper bits of the corresponding Zn
> > must become logically zero in order to conform to the SVE programmer's
> > model.  It's not feasible to track which Vn have been written
> > individually because that would involve trapping every FPSIMD insn until
> > all possible Vn have been written.  So the kernel ensures that the Zn
> > high bits become zero.
> > 
> > Maybe we should just guarantee "zero-or-preserved" behaviour for
> > userspace.  This may close down some future optimisation opportunities,
> > but maybe it's better to be simple.
> 
> Does it work if we leave it as "unspecified" in the document but just do
> zero-or-preserved in the kernel code?

Sure, that's the behaviour today in effect.

I'll leave the documentation unchanged, then we can take advantage of
this flexibility later if is proves to be useful.

> Just wondering, as an optimisation for do_sve_acc() - instead of
> sve_alloc() and fpsimd_to_sve(), can we not force the loading of the
> FPSIMD regs on the return to user via TIF_FOREIGN_FPSTATE? This would
> ensure the zeroing of the top SVE bits and we only need to allocate the
> SVE state on the saving path. This means enabling SVE for user and
> setting TIF_SVE without having the backing storage allocated.

Currently the set of places where the "TIF_SVE implies sve_state valid"
assumption is applied is not very constrained, so while your suggestion
is reasonable I'd rather not mess with it just now, if possible.


But we can do this (which is what my current fixup has):

el0_sve_acc:
	enable_dbg_and_irq
	// ...
	bl	do_sve_acc
	b	ret_to_user

void do_sve_acc(unsigned int esr, struct pt_regs *regs)
{
	/* Even if we chose not to use SVE, the hardware could still trap: */
	if (unlikely(!system_supports_sve()) || WARN_ON(is_compat_task())) {
		force_signal_inject(SIGILL, ILL_ILLOPC, regs, 0);
		return;
	}

	sve_alloc(current);

	local_bh_disable();
	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
		task_fpsimd_load(); /* flushes high Zn bits as a side-effect */
		sve_flush_pregs();
	} else {
		sve_flush_all(); /* flush all the SVE bits in-place */
	}

	if (test_and_set_thread_flag(TIF_SVE))
		WARN_ON(1); /* SVE access shouldn't have trapped */
	local_bh_enable();
}

where sve_flush_all() zeroes all the high Zn bits via a series of
MOV Vn, Vn instructions, and also zeroes Pn and FFR.  sve_fplush_pregs()
just does the latter.

In the common case the sve_alloc() does a memzero, but doesn't
allocate memory because more often than not, it will already have
been allocated.

On this path, the memzero is now pointless -- I'll need to double-check
what else may be impacted by its removal (probably only ptrace, and I'm
not sure if the zeroing is strictly required there).


There is still a bit of room for improvement, but it's still a step up
from v2.

What do you think?

Cheers
---Dave
