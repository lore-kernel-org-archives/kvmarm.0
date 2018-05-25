From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v10 07/18] arm64: fpsimd: Eliminate task->mm checks
Date: Fri, 25 May 2018 11:00:20 +0200
Message-ID: <20180525090020.GA54529@C02W217FHV2R.local>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-8-git-send-email-Dave.Martin@arm.com>
 <20180523114812.GH55598@C02W217FHV2R.local>
 <20180523133158.GJ13470@e103592.cambridge.arm.com>
 <20180523145657.g7b6v2q2vxfqpoc4@armageddon.cambridge.arm.com>
 <20180523150337.GO13470@e103592.cambridge.arm.com>
 <20180524083350.GK55598@C02W217FHV2R.local>
 <20180524095056.GR13470@e103592.cambridge.arm.com>
 <20180524100659.GO55598@C02W217FHV2R.local>
 <20180524143714.GV13470@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180524143714.GV13470@e103592.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 24, 2018 at 03:37:15PM +0100, Dave Martin wrote:
> On Thu, May 24, 2018 at 12:06:59PM +0200, Christoffer Dall wrote:
> > On Thu, May 24, 2018 at 10:50:56AM +0100, Dave Martin wrote:
> > > On Thu, May 24, 2018 at 10:33:50AM +0200, Christoffer Dall wrote:
> 
> [...]
> 
> > > > ...with a risk of being a bit over-pedantic and annoying, may I suggest
> > > > the following complete commit text:
> > > > 
> > > > ------8<------
> > > > Currently the FPSIMD handling code uses the condition task->mm ==
> > > > NULL as a hint that task has no FPSIMD register context.
> > > > 
> > > > The ->mm check is only there to filter out tasks that cannot
> > > > possibly have FPSIMD context loaded, for optimisation purposes.
> > > > However, TIF_FOREIGN_FPSTATE must always be checked anyway before
> > > > saving FPSIMD context back to memory.  For this reason, the ->mm
> > > > checks are not useful, providing that that TIF_FOREIGN_FPSTATE is
> > > > maintained properly for kernel threads.
> > > > 
> > > > FPSIMD context is never preserved for kernel threads across a context
> > > > switch and therefore TIF_FOREIGN_FPSTATE should always be true for
> > > 
> > > (This refactoring opens up the interesting possibility of making
> > > kernel-mode NEON in task context preemptible for kernel threads so
> > > that we actually do preserve state... but that's a discussion for
> > > another day.  There may be code around that relies on
> > > kernel_neon_begin() disabling preemption for real.)
> > > 
> > > > kernel threads.  This is indeed the case, as the wrong_task and
> > > 
> > > This suggests that TIF_FOREIGN_FPSTATE is always true for kernel
> > > threads today.  This is not quite because use_mm() can make mm non-
> > > NULL.
> > > 
> > 
> > I was suggesting that it's always true after this patch.
> 
> I tend to read the present tense as describing the situation before the
> patch, but this convention isn't followed universally.
> 
> This was part of the problem with my "true by construction" weasel
> words: the described property wasn't true by construction prior to the
> patch, and there wasn't sufficient explanation to convince people it's
> true afterwards.  If people are bring rigorous, it takes a _lot_ of
> explanation...
> 
> > 
> > > > wrong_cpu tests in fpsimd_thread_switch() will always yield false for
> > > > kernel threads.
> > > 
> > > ("false" -> "true".  My bad.)
> > > 
> > > > Further, the context switch logic is already deliberately optimised to
> > > > defer reloads of the FPSIMD context until ret_to_user (or sigreturn as a
> > > > special case), which kernel threads by definition never reach, and
> > > > therefore this change introduces no additional work in the critical
> > > > path.
> > > > 
> > > > This patch removes the redundant checks and special-case code.
> > > > ------8<------
> > > 
> > > Looking at my existing text, I rather reworded it like this.
> > > Does this work any better for you?
> > > 
> > > --8<--
> > > 
> > > Currently the FPSIMD handling code uses the condition task->mm ==
> > > NULL as a hint that task has no FPSIMD register context.
> > > 
> > > The ->mm check is only there to filter out tasks that cannot
> > > possibly have FPSIMD context loaded, for optimisation purposes.
> > > Also, TIF_FOREIGN_FPSTATE must always be checked anyway before
> > > saving FPSIMD context back to memory.  For these reasons, the ->mm
> > > checks are not useful, providing that TIF_FOREIGN_FPSTATE is
> > > maintained in a consistent way for kernel threads.
> > 
> > Consistent with what?  Without more context or explanation,
> 
> Consistent with the handling of user threads (though I admit it's not
> explicit in the text.)
> 
> > I'm not sure what the reader is to make of that.  Do you not mean the
> > TIF_FOREIGN_FPSTATE is always true for kernel threads?
> 
> Again, this is probably a red herring.  TIF_FOREIGN_FPSTATE is always
> true for kernel threads prior to the patch, except (randomly) for the
> init task.

That was really what my initial question was about, and what I thought
the commit message should make abundantly clear, because that ties the
message together with the code.

> 
> This change is not really about TIF_FOREIGN_FPSTATE at all, rather
> that there is nothing to justify handling kernel threads differently,
> or even distinguishing kernel threads from user threads at all in this
> code.

Understood.

> 
> Part of the confusion (and I had confused myself) comes from the fact
> that TIF_FOREIGN_FPSTATE is really a per-cpu property and doesn't make
> sense as a per-task property -- i.e., the flag is meaningless for
> scheduled-out tasks and we must explicitly "repair" it when scheduling
> a task in anyway.  I think it's a thread flag primarily so that it's
> convenient to check alongside other thread flags in the ret_to_user
> work loop.  This is somewhat less of a justification now that loop was
> ported to C.
> 
> > > 
> > > The context switch logic is already deliberately optimised to defer
> > > reloads of the regs until ret_to_user (or sigreturn as a special
> > > case), and save them only if they have been previously loaded.
> 
> Does it help to insert the following here?
> 
> "These paths are the only places where the wrong_task and wrong_cpu
> conditions can be made false, by calling fpsimd_bind_task_to_cpu()."
> 

yes it does.

> > > Kernel threads by definition never reach these paths.  As a result,
> > 
> > I'm struggling with the "As a result," here.  Is this because reloads of
> > regs in ret_to_user (or sigreturn) are the only places that can make
> > wrong_cpu or wrong_task be false?
> 
> See the proposed clarification above.  Is that sufficient?
> 

yes.

> > (I'm actually wanting to understand this, not just bikeshedding the
> > commit message, as new corner cases keep coming up on this logic.)
> 
> That's a good thing, and I would really like to explain it in a
> concise manner.  See [*] below for the "concise" explanation -- it may
> demonstrate why I've been evasive...
> 

I don't think you've been evasive at all, I just think we reason about
this in slightly different ways, and I was trying to convince myself why
this change is safe and summarize that concisely.  I think we've
accomplished both :)

> > > the wrong_task and wrong_cpu tests in fpsimd_thread_switch() will
> > > always yield true for kernel threads.
> > > 
> > > This patch removes the redundant checks and special-case code,                  ensuring that TIF_FOREIGN_FPSTATE is set whenever a kernel thread               is scheduled in, and ensures that this flag is set for the init
> > > task.  The fpsimd_flush_task_state() call already present in                    copy_thread() ensures the same for any new task.
> > 
> > nit: funny formatting
> 
> Dang, I was repeatedly pasing between Mutt and git commit terminals,
> which doesn't always work as I'd like...
> 
> > nit: ensuring that TIF_FOREIGN_FPSTATE *remains* set whenever a kernel
> > thread is scheduled in?
> 
> Er, yes.
> 
> > > With TIF_FOREIGN_FPSTATE always set for kernel threads, this patch
> > > ensures that no extra context save work is added for kernel
> > > threads, and eliminates the redundant context saving that may
> > > currently occur for kernel threads that have acquired an mm via
> > > use_mm().
> > > 
> > > -->8--
> > 
> > If you can slightly connect the dots with the "As a result" above, I'm
> > fine with your version of the text.
> 
> 
> As an aside, the big wall of text before the definition of struct
> fpsimd_last_state_struct is looking out of date and could use an
> update to cover at least some of what is explained in [*] better.
> 
> I'm currently considering that out of scope for this series, but I will
> keep it in mind to refresh it in the not too distant future.
> 

Fine with me.

> 
> Cheers
> ---Dave
> 
> --8<--
> 
> [*] The bigger picture:
> 
> * Consider a relation (C,T) between cpus C and tasks T, such that
>   (C,T) means "T's FPSIMD regs are loaded on cpu C".
> 
>   At a given point of execution of some cpu C, there is at most one task
>   T for which (C,T) holds.
>  
>   At a given point of execution of some task T, there is at most one
>   cpu C for which (C,T) holds.
> 
> * (C,T) becomes true whenever T's registers are loaded into cpu C.
> 
> * At sched-out, we must ensure that the registers of current are
>   loaded before writing them to current's thread_struct.  Thus, we
>   must save the registers if and only if (smp_processor_id(), current)
>   holds at this time.
> 
> * Before entering userspace, we must ensure that current's regs
>   are loaded, and we must only load the regs if they are not loaded
>   already (since if so, they might have been dirtied by current in
>   userspace since last loaded).
> 
>   Thus, when entering userspace, we must load the regs from memory
>   if and only if (smp_processor_id(), current) does not hold.
> 
> * Checking this relation involves per-CPU access and inspection of
>   current->thread, and was presumably considered too cumbersome for
>   implemenation an entry.S, particluarly in the ret_to_user work
>   pending loop (which is where the FPSIMD regs are finally loaded
>   before entering userspace, if they weren't loaded already).
> 
>   To mitigate this, the status of the check is cached in a thread flag
>   TIF_FOREIGN_FPSTATE: with softirqs disabled, (smp_processor_id(),
>   current) holds if and only if TIF_FOREIGN_FPSTATE is false.
>   TIF_FOREIGN_FPSTATE is corrected on sched-in by the code in
>   fpsimd_thread_switch().
> 
> [2] Anything that changes the state of the relation for current
>   requires its TIF_FOREIGN_FPSTATE to be changed to match.
> 
> * (smp_processor_id(), current) is established in
>   fpsimd_bind_task_to_cpu().  This is the only way the relation can be
>   made to hold between a task and a CPU.
> 
> * (C,T) is broken whenever
> 
> [1] T is created;
> 
>   * T's regs are loaded onto a different cpu C2, so (C2,T) becomes
>     true and (C,T) necessarily becomes false;
> 
>   * another task's regs are loaded into C, so (C,T2) becomes true
>     and (C,T) necessarily becomes false;
> 
>   * the kernel clobbers the regs on C for its own purposes, so
>     (C,T) becomes false but there is no T2 for which (C,T2) becomes
>     true as a result.  Examples are kernel-mode NEON and loading
>     the regs for a KVM vcpu;
> 
>   * T's register context changes via a thread_struct update instead
>     of running instructions in userspace, requiring the contents of
>     the hardware regs to be thrown away.  Examples are exec() (which
>     requires the registers to be zeroed), sigreturn (which populates the
>     regs from the user signal frame) and modification of the registers
>     via PTRACE_SETREGSET;
> 
>     As a (probably unnecesary) optimisation, sigreturn immediately
>     loads the registers and reestablishes (smp_processor_id(), current)
>     in anticipation of the return to userspace which is likely to
>     occur soon.  This allows the relation breaking logic to be omitted
>     in fpsimd_update_current_state() which does the work.
> 
> * In general, these relation breakings involve an unknown: knowing
>   either C or T but *not* both, we want to break (C,T).  If the
>   relation were recorded in task_struct only, we would need to scan all
>   tasks in the "T unknown" case.  If the relation were recorded in a
>   percpu variable only, we would need to scan all CPUs in the "C
>   unknown" case.  As well as having gnarly synchronisation
>   requirements, these would get expensive in many-tasks or many-cpus
>   situations.
> 
>   This is why the relation is recorded in both places, and is only
>   deemed to hold if the two records match up.  This is what
>   fpsimd_thread_switch() is checking for the task being scheduled in.
> 
>   The invalidation (breaking) operations are now factored as
> 
>   fpsimd_flush_task_state(): falsify (C,current) for every cpu C.
>   This is done by zapping current->thread.fpsimd_cpu with NR_CPUS
>   (chosen because it cannot match smp_processor_id()).
> 
>   fpsumd_flush_cpu_state(): falsify (smp_processor_id(),T) for every
>   task T.  This is done by zapping this_cpu(fpsimd_last_state.st)
>   with NULL (chosen because it cannot match &T->thread.uw.fpsimd_state
>   for any task).
> 
>   By [2] above, it is necessary to ensure that TIF_FOREIGN_FPSTATE is
>   set after calling either of the above functions.  Of the two,
>   fpsimd_flush_cpu_state() now does this implicitly but
>   fpsimd_flush_task_state() does not: but the caller must do it
>   instead.  I have a vague memory of some refactoring obstacle that
>   dissuaded me from pulling the set_thread_flag in, but I can't
>   remember it now.  I may review this later.
> 
> * Because the (C,T) relation may need to be manipulated by
>   kernel_neon_{begin,end}() in softirq context, examining or
>   manipulating for current or the running CPU must be done under
>   local_bh_disable().  The same goes for TIF_FOREIGN_FPSTATE which is
>   supposed to represent the same condition but may spontaneously become
>   stale if softirqs are not masked.  (The rule is not quite as strict
>   as this, but in order to make the code easier to reason about, I skip
>   the local_bh_disable() only where absolutely necessary --
>   restore_sve_fpsimd_context() is the only example today.)
> 
> Now, imagine that T is a kernel thread, and consider what needs to
> be done differently.  The observation of this patch is that nothing
> needs to be done differently at all.
> 
> There is a single anomaly relating to [1] above, in the form of a task
> that can run without ever being scheduled in: the init task.  Beyond
> that, kernel_neon_begin() before the first reschedule would spuriously
> save the FPSIMD regs into the init_task's thread struct, even though it
> is pointless to do so.  This patch fixes those anomalies by updating
> INIT_THREAD and INIT_THREAD_INFO to set up the init task so that it
> looks the same as some other kernel thread that has been scheduled in.
> 
> There is a strong design motivation to avoid unnecessary loads and
> saves of the state, so if removing the special-casing of kernel threads
> were to add cost it would imply that the code were _already_ suboptimal
> for user tasks.  This patch does not attempt to address that at all,
> but by assuming that the code is already well-optimised, "unnecessary"
> save/restore work will not be added.  If this were not the case, it
> could in any case be fixed independently.
> 
> The observation of this _series_ is that we don't need to do very
> much in order to be able to generalise the logic to accept KVM vcpus
> in place of T.
> 

Thanks for the explanation.
-Christoffer
