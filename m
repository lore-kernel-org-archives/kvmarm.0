From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 11/28] arm64/sve: Core task context handling
Date: Wed, 20 Sep 2017 14:58:56 +0100
Message-ID: <20170920135856.dfuowttwi4bk4nqb@localhost>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-12-git-send-email-Dave.Martin@arm.com>
 <20170913143325.hi4cfcajbts3bbao@localhost>
 <20170914195555.GB24231@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170914195555.GB24231@e103592.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 14, 2017 at 08:55:56PM +0100, Dave P Martin wrote:
> On Wed, Sep 13, 2017 at 07:33:25AM -0700, Catalin Marinas wrote:
> > On Thu, Aug 31, 2017 at 06:00:43PM +0100, Dave P Martin wrote:
> > > +/*
> > > + * Handle SVE state across fork():
> > > + *
> > > + * dst and src must not end up with aliases of the same sve_state.
> > > + * Because a task cannot fork except in a syscall, we can discard SVE
> > > + * state for dst here, so long as we take care to retain the FPSIMD
> > > + * subset of the state if SVE is in use.  Reallocation of the SVE state
> > > + * will be deferred until dst tries to use SVE.
> > > + */
> > > +void fpsimd_dup_sve(struct task_struct *dst, struct task_struct const *src)
> > > +{
> > > +	if (test_and_clear_tsk_thread_flag(dst, TIF_SVE)) {
> > > +		WARN_ON(dst->mm && !in_syscall(task_pt_regs(dst)));
> > > +		sve_to_fpsimd(dst);
> > > +	}
> > > +
> > > +	dst->thread.sve_state = NULL;
> > > +}
> > 
> > I first thought the thread flags are not visible in dst yet since
> > dup_task_struct() calls arch_dup_task_struct() before
> > setup_thread_stack(). However, at the end of the last year we enabled
> > CONFIG_THREAD_INFO_IN_TASK_STRUCT. But I don't particularly like relying
> > on this.
> 
> Hmmm, I see your point, but there are some sequencing issues here.
> 
> > Anyway, IIUC we don't need sve_to_fpsimd() here. The
> > arch_dup_task_struct() already called fpsimd_preserve_current_state()
> 
> I consider SVE discard as an optional side effect of task_fpsimd_save(),
> not something that is guaranteed to happen -- the decision about whether
> to do so may become more intelligent later on.  So, for src, we may
> discard SVE (because syscall), but for dst we must NULL .sve_state (and
> therefore clear TIF_SVE) simply to avoid aliasing of src->sve_state and
> dst->sve_state.

My point was that the SVE state of src is already preserved at this
point and copied into dst. You don't need the sve_to_fpsimd(dst) again
which basically does the same copying of the src SVE saved state into
the FPSIMD one in dst. This has already been done in
arch_dup_task_struct() by the combination of
fpsimd_preserve_current_state() and *dst = *src (and, of course,
clearing TIF_SVE in dst).

I don't think the TIF_SVE clearing in src is just a side effect of
task_fpsimd_save() here but rather a requirement. When returning from
fork(), both src and dst would need to have the same state. However,
your fpsimd_dup_sve() implementation makes it very clear that the SVE
state is lost in dst. This is only allowed if we also lose it in src (as
a result of a syscall). So making dst->sve_state = NULL requires that
TIF_SVE is also cleared in both src and dst. Alternatively, you'd have
to allocate a new state here and copy the full src SVE state across to
dst, together with setting TIF_SVE (that's not necessary, however, since
we get here as a result of a syscall).

> > for src, so the FPSIMD state (which we care about) is transferred during
> > the *dst = *src assignment. So you'd only need the last statement,
> > possibly with a different function name like fpsimd_erase_sve (and maybe
> > make the function static inline in the header).
> 
> Not quite: TIF_SVE must be cleared so that a context switch or
> kernel_neon_begin() after dst is scheduled doesn't try to save state in
> the (NULL) dst->sve_state.

Yes, TIF_SVE must also be cleared in dst when dst->sve_state = NULL (I
may have forgotten to mention this).

-- 
Catalin
