From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 2/4] arm64/sve: KVM: Avoid dereference of dead task
 during guest entry
Date: Thu, 23 Nov 2017 14:16:46 +0000
Message-ID: <20171123141643.GJ22781@e103592.cambridge.arm.com>
References: <1510936735-6762-1-git-send-email-Dave.Martin@arm.com>
 <1510936735-6762-3-git-send-email-Dave.Martin@arm.com>
 <20171122192338.GR28855@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 364AC49D7F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 09:14:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id luRwBcOcaCNG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Nov 2017 09:14:12 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8BA549D6A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 09:14:12 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171122192338.GR28855@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 22, 2017 at 08:23:38PM +0100, Christoffer Dall wrote:
> Hi Dave,
> 
> On Fri, Nov 17, 2017 at 04:38:53PM +0000, Dave Martin wrote:
> > When deciding whether to invalidate FPSIMD state cached in the cpu,
> > the backend function sve_flush_cpu_state() attempts to dereference
> > __this_cpu_read(fpsimd_last_state).  However, this is not safe:
> > there is no guarantee that the pointer is still valid, because the
> > task could have exited in the meantime.  For this reason, this
> > percpu pointer should only be assigned or compared, never
> > dereferenced.
> > 
> > This means that we need another means to get the appropriate value
> > of TIF_SVE for the associated task.
> > 
> > This patch solves this issue by adding a cached copy of the TIF_SVE
> > flag in fpsimd_last_state, which we can check without dereferencing
> > the task pointer.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/kernel/fpsimd.c | 28 ++++++++++++++++------------
> >  1 file changed, 16 insertions(+), 12 deletions(-
> > 
> > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> > index 007140b..3dc8058 100644
> > --- a/arch/arm64/kernel/fpsimd.c
> > +++ b/arch/arm64/kernel/fpsimd.c
> > @@ -114,7 +114,12 @@
> >   *   returned from the 2nd syscall yet, TIF_FOREIGN_FPSTATE is still set so
> >   *   whatever is in the FPSIMD registers is not saved to memory, but discarded.
> >   */
> > -static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
> > +struct fpsimd_last_state_struct {
> > +	struct fpsimd_state *st;
> > +	bool sve_in_use;
> > +};
> > +
> > +static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
> >  
> >  /* Default VL for tasks that don't set it explicitly: */
> >  static int sve_default_vl = -1;
> > @@ -905,7 +910,7 @@ void fpsimd_thread_switch(struct task_struct *next)
> >  		 */
> >  		struct fpsimd_state *st = &next->thread.fpsimd_state;
> >  
> > -		if (__this_cpu_read(fpsimd_last_state) == st
> > +		if (__this_cpu_read(fpsimd_last_state.st) == st
> >  		    && st->cpu == smp_processor_id())
> >  			clear_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE);
> >  		else
> > @@ -997,9 +1002,12 @@ void fpsimd_signal_preserve_current_state(void)
> >   */
> >  static void fpsimd_bind_to_cpu(void)
> >  {
> > +	struct fpsimd_last_state_struct *last =
> > +		this_cpu_ptr(&fpsimd_last_state);
> >  	struct fpsimd_state *st = &current->thread.fpsimd_state;
> >  
> > -	__this_cpu_write(fpsimd_last_state, st);
> > +	last->st = st;
> > +	last->sve_in_use = test_thread_flag(TIF_SVE);
> >  	st->cpu = smp_processor_id();
> >  }
> >  
> > @@ -1057,7 +1065,7 @@ void fpsimd_flush_task_state(struct task_struct *t)
> >  
> >  static inline void fpsimd_flush_cpu_state(void)
> >  {
> > -	__this_cpu_write(fpsimd_last_state, NULL);
> > +	__this_cpu_write(fpsimd_last_state.st, NULL);
> >  }
> >  
> >  /*
> > @@ -1070,14 +1078,10 @@ static inline void fpsimd_flush_cpu_state(void)
> >  #ifdef CONFIG_ARM64_SVE
> >  void sve_flush_cpu_state(void)
> >  {
> > -	struct fpsimd_state *const fpstate = __this_cpu_read(fpsimd_last_state);
> > -	struct task_struct *tsk;
> > -
> > -	if (!fpstate)
> > -		return;
> > +	struct fpsimd_last_state_struct const *last =
> > +		this_cpu_ptr(&fpsimd_last_state);
> >  
> > -	tsk = container_of(fpstate, struct task_struct, thread.fpsimd_state);
> > -	if (test_tsk_thread_flag(tsk, TIF_SVE))
> > +	if (last->st && last->sve_in_use)
> >  		fpsimd_flush_cpu_state();
> 
> I'm confused though; why can't we simply flush the state
> unconditionally?  What is the harm of setting the pointer to NULL if the
> task whose state may be pointed to didn't actually use SVE?

We can, but it defeats an existing optimisation on the host side,
which I was trying to avoid.


The scenario is as follows:

Task A is some random user task.
Task B is a vcpu thread, which is initially not running, having been
preempted in the kernel vcpu run loop.

 * A runs in userspace
 * B preempts A
 * A's FPSIMD state is still in the CPU
 * KVM saves A's FPSIMD state in the host context for this CPU
 * KVM enters vcpu for B
 * B's vcpu exits for some reason
 * KVM restores the host FPSIMD context (= A's FPSIMD state)
 * A is scheduled
 * A returns to userspace

If we NULL the fpsimd_last_state pointer, A's FPSIMD state is now
reloaded even though it is in the CPU already.

In the SVE case this is currently necessary though, because the
(non-SVE-aware) host context save/restore done by KVM is insufficient
to ensure that the whole SVE state is preserved for A.  My initial
patch for this was broken though: this one should fix it.


I don't want to add host context save/restore for full SVE, because it
will almost always be redundant: the vcpu thread won't have any SVE
state anyway because it is in a syscall (the run ioctl()); a second
user thread has already saved its FPSIMD state during sched- out and
would restore it at ret_to_user anyway, so it is pointless for KVM
either to save or restore this context in that case.


Ideally, KVM should be aware of and make use of the host's FPSIMD/SVE
context management rather than doing its own: this would eliminate
redundant save/restore.

However, I see that as a separate optimisation and didn't want to
address it yet.

Does that make sense?

[...]

Cheers
---Dave
