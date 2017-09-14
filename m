From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 11/28] arm64/sve: Core task context handling
Date: Thu, 14 Sep 2017 20:40:41 +0100
Message-ID: <20170914193944.GA24231@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-12-git-send-email-Dave.Martin@arm.com>
 <20170913172605.hjrwjf34kyy7coh4@localhost>
 <20170913191707.GD23415@e103592.cambridge.arm.com>
 <20170913222129.vi3lidawdp33zzjd@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170913222129.vi3lidawdp33zzjd@localhost>
Sender: linux-arch-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 13, 2017 at 03:21:29PM -0700, Catalin Marinas wrote:
> On Wed, Sep 13, 2017 at 08:17:07PM +0100, Dave P Martin wrote:
> > On Wed, Sep 13, 2017 at 10:26:05AM -0700, Catalin Marinas wrote:
> > > On Thu, Aug 31, 2017 at 06:00:43PM +0100, Dave P Martin wrote:
> > > > +/*
> > > > + * Trapped SVE access
> > > > + */
> > > > +void do_sve_acc(unsigned int esr, struct pt_regs *regs)
> > > > +{
> > > > +	/* Even if we chose not to use SVE, the hardware could still trap: */
> > > > +	if (unlikely(!system_supports_sve()) || WARN_ON(is_compat_task())) {
> > > > +		force_signal_inject(SIGILL, ILL_ILLOPC, regs, 0);
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	task_fpsimd_save();
> > > > +
> > > > +	sve_alloc(current);
> > > > +	fpsimd_to_sve(current);
> > > > +	if (test_and_set_thread_flag(TIF_SVE))
> > > > +		WARN_ON(1); /* SVE access shouldn't have trapped */
> > > > +
> > > > +	task_fpsimd_load();
> > > > +}
> > > 
> > > When this function is entered, do we expect TIF_SVE to always be
> > > cleared? It's worth adding a comment on the expected conditions. If
> > 
> > Yes, and this is required for correctness, as you observe.
> > 
> > I had a BUG_ON() here which I removed, but it makes sense to add a
> > comment to capture the precondition here, and how it is satisfied.
> > 
> > > that's the case, task_fpsimd_save() would only save the FPSIMD state
> > > which is fine. However, you subsequently transfer the FPSIMD state to
> > > SVE, set TIF_SVE and restore the full SVE state. If we don't care about
> > > the SVE state here, can we call task_fpsimd_load() *before* setting
> > > TIF_SVE?
> > 
> > There should be no way to reach this code with TIF_SVE set, unless
> > task_fpsimd_load() sets the CPACR trap bit wrongly, or the hardware is
> > broken -- either of which is a bug.
> 
> Thanks for confirming my assumptions. What I meant was rewriting the
> above function as:
> 
> 	/* reset the SVE state (other than FPSIMD) */
> 	task_fpsimd_save();
> 	task_fpsimd_load();

I think this works, but can you explain your rationale?

I think the main effect of your suggestion is that it is cheaper, due
to eliminating some unnecessary load/store operations.

We could go one better, and do

	mov	v0.16b, v0.16b
	mov	v1.16b, v1.16b
	// ...
	mov	v31.16b, v31.16b

which doesn't require any memory access.

But I still prefer to zero p0..p15, ffr for cleanliness, even though
the SVE programmer's model doesn't require this (unlike for the Z-reg
high bits where we do need to zero them in order not to violate the
programmer's model).

Currently sve_alloc()+task_fpsimd_load() ensures that all the non-FPSIMD
regs are zeroed too, in addition to the Z-reg high bits.

So we might want a special-purpose helper -- if so, we can do it all
with no memory access.

	pfalse	p0.b
	// ..
	pfalse	p15.b
	wrffr	p0.b

This would allow the memset-zero an sve_alloc() to be removed, but I
would need to check what other code is relying on it.

I guess I hadn't done this because I viewed it as an optimisation.

Thoughts?

Cheers
---Dave
