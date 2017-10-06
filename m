From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 11/28] arm64/sve: Core task context handling
Date: Fri, 6 Oct 2017 16:15:28 +0100
Message-ID: <20171006151528.GB3611@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-12-git-send-email-Dave.Martin@arm.com>
 <20170913143325.hi4cfcajbts3bbao@localhost>
 <20171003113302.GR3611@e103592.cambridge.arm.com>
 <20171005112835.2rhaqx23bhe6tnwl@armageddon.cambridge.arm.com>
 <20171006131005.GA3611@e103592.cambridge.arm.com>
 <20171006133639.ialgglabo7yca5bm@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-85511-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20171006133639.ialgglabo7yca5bm@armageddon.cambridge.arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 02:36:40PM +0100, Catalin Marinas wrote:
> On Fri, Oct 06, 2017 at 02:10:09PM +0100, Dave P Martin wrote:
> > On Thu, Oct 05, 2017 at 12:28:35PM +0100, Catalin Marinas wrote:
> > > On Tue, Oct 03, 2017 at 12:33:03PM +0100, Dave P Martin wrote:
> > > > TIF_FOREIGN_FPSTATE's meaning is expanded to cover SVE, but otherwise
> > > > unchanged:
> > > > 
> > > >  * If a task is running and !TIF_FOREIGN_FPSTATE, then the the CPU
> > > >    registers of the CPU the task is running on contain the authoritative
> > > >    FPSIMD/SVE state of the task.  The backing memory may be stale.
> > > > 
> > > >  * Otherwise (i.e., task not running, or task running and
> > > >    TIF_FOREIGN_FPSTATE), the task's FPSIMD/SVE backing memory is
> > > >    authoritative.  If additionally per_cpu(fpsimd_last_state,
> > > >    task->fpsimd_state.cpu) == &task->fpsimd_state.cpu, then
> > > >    task->fpsimd_state.cpu's registers are also up to date for task, but
> > > >    not authorititive: the current FPSIMD/SVE state may be read from
> > > >    them, but they must not be written.
> > > >  
> > > > The FPSIMD/SVE backing memory is selected by TIF_SVE:
> > > > 
> > > >  * TIF_SVE set: Zn (incorporating Vn in bits[127:0]), Pn and FFR are
> > > >    stored in task->thread.sve_state, formatted appropriately for vector
> > > >    length task->thread.sve_vl.  task->thread.sve_state must point to a
> > > >    valid buffer at least sve_state_size(task) bytes in size.
> 
> "Zn [...] stored in  task->thread.sve_state" - is this still true with
> the changes you proposed? I guess even without these changes, you have
> situations where the hardware regs are out of sync with sve_state (see
> more below).

I guess I need to tweak the wording here.

TIF_SVE says where the vector state should be loaded/stored from,
but does not say whether the data is up to date in memory, or when
it should be loaded/stored.

The latter is described by a cocktail of different things including
which bit of kernel code we are executing if any, whether the task
is running/stopped etc., TIF_FOREIGN_FPSTATE,
task->thread.fpsimd_state.cpu and per_cpu(fpsimd_last_state).


Does this make any better sense of my code below?

> 
> > > >  * TIF_SVE clear: Vn are stored in task->fpsimd_state; Zn[max : 128] are
> > > >    logically zero[*] but not stored anywhere; Pn, FFR are not stored and
> > > >    have unspecified values from userspace's point of view.
> > > >    task->thread.sve_state does not need to be non-null, valid or any
> > > >    particular size: it must not be dereferenced.
> > > > 
> > > >    In practice I don't exploit the "unspecifiedness" much.  The Zn high
> > > >    bits, Pn and FFR are all zeroed when setting TIF_SVE again:
> > > >    sve_alloc() is the common path for this.
> > > > 
> > > >  * FPSR and FPCR are always stored in task->fpsimd_state irrespctive of
> > > >    whether TIF_SVE is clear or set, since these are not vector length
> > > >    dependent.
> [...]
> > > Just wondering, as an optimisation for do_sve_acc() - instead of
> > > sve_alloc() and fpsimd_to_sve(), can we not force the loading of the
> > > FPSIMD regs on the return to user via TIF_FOREIGN_FPSTATE? This would
> > > ensure the zeroing of the top SVE bits and we only need to allocate the
> > > SVE state on the saving path. This means enabling SVE for user and
> > > setting TIF_SVE without having the backing storage allocated.
> > 
> > Currently the set of places where the "TIF_SVE implies sve_state valid"
> > assumption is applied is not very constrained, so while your suggestion
> > is reasonable I'd rather not mess with it just now, if possible.
> > 
> > 
> > But we can do this (which is what my current fixup has):
> > 
> > el0_sve_acc:
> > 	enable_dbg_and_irq
> > 	// ...
> > 	bl	do_sve_acc
> > 	b	ret_to_user
> > 
> > void do_sve_acc(unsigned int esr, struct pt_regs *regs)
> > {
> > 	/* Even if we chose not to use SVE, the hardware could still trap: */
> > 	if (unlikely(!system_supports_sve()) || WARN_ON(is_compat_task())) {
> > 		force_signal_inject(SIGILL, ILL_ILLOPC, regs, 0);
> > 		return;
> > 	}
> > 
> > 	sve_alloc(current);
> > 
> > 	local_bh_disable();
> > 	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
> > 		task_fpsimd_load(); /* flushes high Zn bits as a side-effect */
> > 		sve_flush_pregs();
> > 	} else {
> > 		sve_flush_all(); /* flush all the SVE bits in-place */
> > 	}
> > 
> > 	if (test_and_set_thread_flag(TIF_SVE))
> > 		WARN_ON(1); /* SVE access shouldn't have trapped */
> > 	local_bh_enable();
> > }
> > 
> > where sve_flush_all() zeroes all the high Zn bits via a series of
> > MOV Vn, Vn instructions, and also zeroes Pn and FFR.  sve_fplush_pregs()
> > just does the latter.
> 
> This looks fine to me but I added a comment above. IIUC, we can now have
> TIF_SVE set while sve_state contains stale data. I don't see an issue
> given that every time you enter the kernel from user space you have
> TIF_SVE set and the sve_state storage out of sync. Maybe tweak the
> TIF_SVE description above slightly.
> 

See my comment above ... any better?

If so, I'll paste some of that explanatory text into fpsimd.c (in lieu
of a better place to put it).

Cheers
---Dave
