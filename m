From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 07/18] arm64: fpsimd: Eliminate task->mm checks
Date: Wed, 23 May 2018 14:31:59 +0100
Message-ID: <20180523133158.GJ13470@e103592.cambridge.arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-8-git-send-email-Dave.Martin@arm.com>
 <20180523114812.GH55598@C02W217FHV2R.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180523114812.GH55598@C02W217FHV2R.local>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 23, 2018 at 01:48:12PM +0200, Christoffer Dall wrote:
> On Tue, May 22, 2018 at 05:05:08PM +0100, Dave Martin wrote:
> > Currently the FPSIMD handling code uses the condition task->mm ==
> > NULL as a hint that task has no FPSIMD register context.
> > 
> > The ->mm check is only there to filter out tasks that cannot
> > possibly have FPSIMD context loaded, for optimisation purposes.
> > Also, TIF_FOREIGN_FPSTATE must always be checked anyway before
> > saving FPSIMD context back to memory.  For these reasons, the ->mm
> > checks are not useful, providing that that TIF_FOREIGN_FPSTATE is

Hmmm, "that that".  I'll fix that.

> > maintained in a consistent way for kernel threads.
> > 
> > This is true by construction however: TIF_FOREIGN_FPSTATE is never
> > cleared except when returning to userspace or returning from a
> > signal: thus, for a true kernel thread no FPSIMD context is ever
> > loaded, TIF_FOREIGN_FPSTATE will remain set and no context will
> > ever be saved.
> 
> I don't understand this construction proof; from looking at the patch
> below it is not obvious to me why fpsimd_thread_switch() can never have
> !wrong_task && !wrong_cpu and therefore clear TIF_FOREIGN_FPSTATE for a
> kernel thread?

Looking at this again, I think it is poorly worded.  This patch aims to
make it true by construction, but it isn't prior to the patch.

I'm tempted to delete the paragraph: the assertion of both untrue and
not the best way to justify that this patch works.


How about:

-8<-

The context switch logic already isolates user threads from each other.
This, it is sufficient for isolating user threads from the kernel,
since the goal either way is to ensure that code executing in userspace
cannot see any FPSIMD state except its own.  Thus, there is no special
property of kernel threads that we care about except that it is
pointless to save or load FPSIMD register state for them.

At worst, the removal of all the kernel thread special cases by this
patch would thus spuriously load and save state for kernel threads when
unnecessary.

But the context switch logic is already deliberately optimised to defer
reloads of the regs until ret_to_user (or sigreturn as a special case),
which kernel threads by definition never reach.

->8-


As an aside, I notice that we allow thread.fpsimd_cpu to be initialised
to 0 for the init task.  This means that the wrong_cpu check may yield
false for the init task when it shouldn't, because the init task's
FPSIMD state (which doesn't logically exist) is never loaded anywhere.
But the wrong_task check will always yield true for the init task for
the same reason, so this is just an inconsistency in the code rather
than a bug AFAICT.

copy_thread() calls fpsimd_flush_task_state() to make sure that
wrong_cpu is initially true for new tasks.  We should do the same for
the init task by adding

	.fpsimd_cpu = NR_CPUS,

to INIT_THREAD.


Cheers
---Dave

> 
> 
> Thanks,
> -Christoffer
> 
> > 
> > This patch removes the redundant checks and special-case code.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > 
> > ---
> > 
> > Changes since v9:
> > 
> >  * New patch.  Introduced during debugging, since the ->mm checks
> >    appear bogus and/or redundant, so are likely to be hiding or
> >    causing bugs.
> > ---
> >  arch/arm64/include/asm/thread_info.h |  1 +
> >  arch/arm64/kernel/fpsimd.c           | 38 ++++++++++++------------------------
> >  2 files changed, 14 insertions(+), 25 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> > index 740aa03c..a2ac914 100644
> > --- a/arch/arm64/include/asm/thread_info.h
> > +++ b/arch/arm64/include/asm/thread_info.h
> > @@ -47,6 +47,7 @@ struct thread_info {
> >  
> >  #define INIT_THREAD_INFO(tsk)						\
> >  {									\
> > +	.flags		= _TIF_FOREIGN_FPSTATE,				\
> >  	.preempt_count	= INIT_PREEMPT_COUNT,				\
> >  	.addr_limit	= KERNEL_DS,					\
> >  }
> > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> > index 3aa100a..1222491 100644
> > --- a/arch/arm64/kernel/fpsimd.c
> > +++ b/arch/arm64/kernel/fpsimd.c
> > @@ -891,31 +891,21 @@ asmlinkage void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
> >  
> >  void fpsimd_thread_switch(struct task_struct *next)
> >  {
> > +	bool wrong_task, wrong_cpu;
> > +
> >  	if (!system_supports_fpsimd())
> >  		return;
> > -	/*
> > -	 * Save the current FPSIMD state to memory, but only if whatever is in
> > -	 * the registers is in fact the most recent userland FPSIMD state of
> > -	 * 'current'.
> > -	 */
> > -	if (current->mm)
> > -		fpsimd_save();
> >  
> > -	if (next->mm) {
> > -		/*
> > -		 * If we are switching to a task whose most recent userland
> > -		 * FPSIMD state is already in the registers of *this* cpu,
> > -		 * we can skip loading the state from memory. Otherwise, set
> > -		 * the TIF_FOREIGN_FPSTATE flag so the state will be loaded
> > -		 * upon the next return to userland.
> > -		 */
> > -		bool wrong_task = __this_cpu_read(fpsimd_last_state.st) !=
> > +	/* Save unsaved fpsimd state, if any: */
> > +	fpsimd_save();
> > +
> > +	/* Fix up TIF_FOREIGN_FPSTATE to correctly describe next's state: */
> > +	wrong_task = __this_cpu_read(fpsimd_last_state.st) !=
> >  					&next->thread.uw.fpsimd_state;
> > -		bool wrong_cpu = next->thread.fpsimd_cpu != smp_processor_id();
> > +	wrong_cpu = next->thread.fpsimd_cpu != smp_processor_id();
> >  
> > -		update_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE,
> > -				       wrong_task || wrong_cpu);
> > -	}
> > +	update_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE,
> > +			       wrong_task || wrong_cpu);
> >  }
> >  
> >  void fpsimd_flush_thread(void)
> > @@ -1120,9 +1110,8 @@ void kernel_neon_begin(void)
> >  
> >  	__this_cpu_write(kernel_neon_busy, true);
> >  
> > -	/* Save unsaved task fpsimd state, if any: */
> > -	if (current->mm)
> > -		fpsimd_save();
> > +	/* Save unsaved fpsimd state, if any: */
> > +	fpsimd_save();
> >  
> >  	/* Invalidate any task state remaining in the fpsimd regs: */
> >  	fpsimd_flush_cpu_state();
> > @@ -1244,8 +1233,7 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
> >  {
> >  	switch (cmd) {
> >  	case CPU_PM_ENTER:
> > -		if (current->mm)
> > -			fpsimd_save();
> > +		fpsimd_save();
> >  		fpsimd_flush_cpu_state();
> >  		break;
> >  	case CPU_PM_EXIT:
> > -- 
> > 2.1.4

[...]

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
