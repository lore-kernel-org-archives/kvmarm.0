From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 11/28] arm64/sve: Core task context handling
Date: Fri, 13 Oct 2017 18:53:37 +0100
Message-ID: <20171013175336.GQ19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-12-git-send-email-Dave.Martin@arm.com>
 <20171011161558.ts7adaryabttg47z@armageddon.cambridge.arm.com>
 <20171012160506.GH19485@e103592.cambridge.arm.com>
 <20171013135736.hd75eja76n4bt2rq@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171013135736.hd75eja76n4bt2rq@armageddon.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 13, 2017 at 02:57:37PM +0100, Catalin Marinas wrote:
> On Thu, Oct 12, 2017 at 05:05:07PM +0100, Dave P Martin wrote:
> > On Wed, Oct 11, 2017 at 05:15:58PM +0100, Catalin Marinas wrote:
> > > On Tue, Oct 10, 2017 at 07:38:28PM +0100, Dave P Martin wrote:
> > > > diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> > > > index 29adab8..4831d28 100644
> > > > --- a/arch/arm64/include/asm/processor.h
> > > > +++ b/arch/arm64/include/asm/processor.h
> > > > @@ -39,6 +47,8 @@
> > > >  #define FPEXC_IDF	(1 << 7)
> > > >  
> > > >  /*
> > > > + * (Note: in this discussion, statements about FPSIMD apply equally to SVE.)
> > > > + *
> > > >   * In order to reduce the number of times the FPSIMD state is needlessly saved
> > > >   * and restored, we need to keep track of two things:
> > > >   * (a) for each task, we need to remember which CPU was the last one to have
> > > > @@ -99,6 +109,287 @@
> > > >   */
> > > >  static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
> > > >  
> > > > +static void sve_free(struct task_struct *task)
> > > > +{
> > > > +	kfree(task->thread.sve_state);
> > > > +	task->thread.sve_state = NULL;
> > > > +}
> > > 
> > > I think we need a WARN_ON if TIF_SVE is still set here (and the callers
> > > making sure it is cleared). I haven't checked the code paths via
> > > fpsimd_release_thread() but wondering what happens if we get an
> > > interrupt between freeing the state and making the pointer NULL, with
> > > some context switching in a preemptible kernel.
> > 
> > Having a WARN_ON() here may be a decent way to sanity-check that we
> > don't ever have sve_state NULL with TIF_SVE set.  This is a lot more
> > economical than putting a WARN_ON() at each dereference of sve_state
> > (of which there are quite a few).  sve_free() is also a slow path.
> > 
> > Currently, there are two callsites: sve_set_vector_length(), where we
> > test_and_clear_tsk_thread_flags(task, TIF_SVE) before calling sve_free();
> > and fpsimd_release_thread() where we "don't care" because the thread
> > is dying.
> > 
> > Looking more closely though, is the release_thread() path preemptible?
> > I can't see anything in the scheduler core to ensure this, nor any
> > general reason why it should be needed.
> > 
> > In which case preemption during thread exit after sve_free() could
> > result in a NULL deference in fpsimd_thread_switch().
> > 
> > 
> > So, I think my favoured approach is:
> > 
> > sve_release_thread()
> > {
> > 	local_bh_disable();
> > 	fpsimd_flush_task_state(current);
> > 	clear_thread_flag(TIF_SVE);
> > 	local_bh_enable();
> > 
> > 	sve_free();
> > }
> > 
> > The local_bh stuff is cumbersome here, and could be replaced with
> > barrier()s to force the order of fpsimd_flusk_task_state() versus
> > clearing TIF_SVE.  Or should the barrier really be in
> > fpsimd_flush_task_state()?  Disabling softirqs avoids the need to answer
> > such questions...
> > 
> > 
> > Then:
> > 
> > sve_free(task)
> > {
> > 	WARN_ON(test_thread_flag(TIF_SVE));
> > 
> > 	barrier();
> > 	kfree(task->thread.sve_state);
> > 	tash->thread.sve_state = NULL;
> > }
> > 
> > I'm assuming here that kfree() can't be called safely from atomic
> > context, but this is unclear.  I would expect to be able to free
> > GFP_ATOMIC memory from atomic context (though sve_statue is GFP_KERNEL,
> > so dunno).
> 
> The kfree should be fine.
> 
> Alternative proposal: free the SVE state in arch_release_task_struct().
> This is called via the RCU mechanism and the task is no longer current,
> so no preemption issues.

Heh, I wasn't aware of that option.  That would be better, since
there's no value in the task still being schedulable while we do
the freeing.

Only SuperH seems to have a real version of that function, but it
frees some dynamically allocated state, which sounds familiar.

I'll take a look at moving over to this.

> 
> > > Alternatively, always clear TIF_SVE here before freeing (also wondering
> > > whether we should make sve_state NULL before the actual freeing but I
> > > think TIF_SVE clearing should suffice).
> > 
> > Could do.  I feel that the current placement of the TIF_SVE clearing in
> > sve_set_vector_length() feels "more natural", but this is a pretty
> > flimsy argument.  How strongly do you feel about this?
> 
> I agree with you, keep the TIF_SVE clearing in sve_set_vector_length().

OK, will do

Cheers
---Dave
