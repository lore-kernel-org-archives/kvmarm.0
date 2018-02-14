From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 09/41] KVM: arm64: Defer restoring host VFP state to
 vcpu_put
Date: Wed, 14 Feb 2018 11:15:54 +0100
Message-ID: <20180214101554.GL23189@cbox>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-10-christoffer.dall@linaro.org>
 <20180122173326.GO22781@e103592.cambridge.arm.com>
 <20180125194653.GR21802@cbox>
 <20180207164955.GT5862@e103592.cambridge.arm.com>
 <20180207175644.GF29286@cbox>
 <20180209155930.GD5862@e103592.cambridge.arm.com>
 <20180213085130.GB23189@cbox>
 <20180213140843.GN5862@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180213140843.GN5862@e103592.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 13, 2018 at 02:08:47PM +0000, Dave Martin wrote:
> On Tue, Feb 13, 2018 at 09:51:30AM +0100, Christoffer Dall wrote:
> > On Fri, Feb 09, 2018 at 03:59:30PM +0000, Dave Martin wrote:
> > > On Wed, Feb 07, 2018 at 06:56:44PM +0100, Christoffer Dall wrote:
> > > > On Wed, Feb 07, 2018 at 04:49:55PM +0000, Dave Martin wrote:
> 
> [...]
> 
> > > Simply entering the kernel and returning to userspace doesn't have
> > > this effect by itself.
> > > 
> > > 
> > > Prior to the SVE patches, KVM makes itself orthogonal to the host
> > > context switch machinery by ensuring that whatever the host had
> > > in the FPSIMD regs at guest entry is restored before returning to
> > > the host. (IIUC)  
> > 
> > Only if the guest actually touches FPSIMD state.  If the guest doesn't
> > touch FPSIMD (no trap to EL2), then we never touch the state at all.
> 
> I should have been clearer: KVM ensures that the state is _unchanged_
> before returning to the host, but can elide the save/restore when the
> guest doesn't touch the state...
> 
> > 
> > > This means that redundant save/restore work is
> > > done by KVM, but does have the advantage of simplicity.
> > 
> > I don't understand what the redundant part here is?  Isn't it only
> > redundant in the case where the host (for some reason) has already saved
> > its FPSIMD state?  I assume that won't be the common case, since
> > "userspace->kernel->kvm_run" won't save the FPSIMD state, as you just
> > explained above.
> 
> ...however, when this elision does not occur, it may duplicate
> save/restore done by the kernel, or it may save/restore worthless data
> if the host's FPSIMD state is non-live at the time.
> 
> It's hard to gauge the impact of this: it seems unlikely to make a
> massive difference, but will be highly workload-dependent.

So I thought it might be useful to have some idea of the frequency of
events on a balanced workload, so I ran an 8-way SMP guest on Ubuntu
14.04 running SPECjvm2008, a memcached benchmark, a MySQL workloads, and
some networking benchmarks, and I counted a few events:

 - Out of all the exits, from the guest to run-loop in EL1 on a non-VHE
   system, fewer than 1% of them result in an exit to userspace (0.57%).

 - The VCPU thread was preempted (voluntarily or forced) in the kernel
   less than 3% of the exits (2.72%).  That's just below 5 preemptions
   per ioctl(KVM_RUN).

 - In 29% of the preemptions (vcpu_put), the guest had touched FPSIMD
   registers and the host context was restored.

 - We store the host context about 1.38 times per ioctl(KVM_RUN).

So that tells me that (1) it's worth restoring the guest FPSIMD state
lazily as opposed to proactively on vcpu_load, and (2) that there's a
small opportunity for improvement by reducing redundant host vfp state
saves.

> 
> 
> The redundancy occurs because of the deferred restore of the FPSIMD
> registers for host userspace: as a result, the host FPSIMD regs are
> either discardable (i.e., already saved) or not live at all between
> and context switch and the next ret_to_user.
> 
> This means that if the vcpu run loop is preempted, then when the host
> switches back to the run loop it is pointless to save or restore the
> host FPSIMD state.
> 
> A typical sequence of events exposing this redundancy would be as
> follows.  I assume here that there are two cpu-bound tasks A and B
> competing for a host CPU, where A is a vcpu thread:
> 
>  - vcpu A is in the guest running a compute-heavy task
>  - FPSIMD typically traps to the host before context switch
>  X kvm saves the host FPSIMD state
>  - kvm loads the guest FPSIMD state
>  - vcpu A reenters the guest
>  - host context switch IRQ preempts A back to the run loop
>  Y kvm loads the host FPSIMD state via vcpu_put
> 
>  - host context switch:
>  - TIF_FOREIGN_FPSTATE is set -> no save of user FPSIMD state
>  - switch to B
>  - B reaches ret_to_user
>  Y B's user FPSIMD state is loaded: TIF_FOREIGN_FPSTATE now clear
>  - B enters userspace
> 
>  - host context switch:
>  - B enters kernel
>  X TIF_FOREIGN_FPSTATE now set -> host saves B's FPSIMD state
>  - switch to A -> set TIF_FOREIGN_FPSTATE for A
>  - back to the KVM run loop
> 
>  - vcpu A enters guest
>  - redo from start
> 
> Here, the two saves marked X are redundant with respect to each other,
> and the two restores marked Y are redundant with respect to each other.
> 

Right, ok, but if we have

 - ioctl(KVM_RUN)
 - mark hardware FPSIMD register state as invalid
 - load guest FPSIMD state
 - enter guest
 - exit guest
 - save guest FPSIMD state
 - return to user space

(I.e. we don't do any preemption in the guest)

Then we'll loose the host FPSIMD register state, potentially, right?

Your original comment on this patch was that we didn't need to restore
the host FPSIMD state in kvm_vcpu_put_sysregs, which would result in the
scenario above.  The only way I can see this working is by making sure
that kvm_fpsimd_flush_cpu_state() also saves the FPSIMD hardware
register state if the state is live.

Am I still missing something?

> > > This breaks for SVE though: the high bits of the Z-registers will be
> > > zeroed as a side effect of the FPSIMD save/restore done by KVM.
> > > This means that if the host has state in those bits then it must
> > > be saved before entring the guest: that's what the new
> > > kvm_fpsimd_flush_cpu_state() hook in kvm_arch_vcpu_ioctl_run() is for.
> > 
> > Again, I'm confused, because to me it looks like
> > kvm_fpsimd_flush_cpu_state() boils down to fpsimd_flush_cpu_state()
> > which just sets a pointer to NULL, but doesn't actually save the state.
> > 
> > So, when is the state in the hardware registers saved to memory?
> 
> This _is_ quite confusing: in writing this answer I identified a bug
> and then realised why there is no bug...
> 
> kvm_fpsimd_flush_cpu_state() is just an invalidation.  No state is
> actually saved today because we explicitly don't care about preserving
> the SVE state, because the syscall ABI throws the SVE regs away as
> a side effect any syscall including ioctl(KVM_RUN); also (currently) KVM
> ensures that the non-SVE FPSIMD bits _are_ restored by itself.
> 
> I think my proposal is that this hook might take on the role of
> actually saving the state too, if we move that out of the KVM host
> context save/restore code.
> 
> Perhaps we could even replace
> 
> 	preempt_disable();
> 	kvm_fpsimd_flush_cpu_state();
> 	/* ... */
> 	preempt_enable();
> 
> with
> 
> 	kernel_neon_begin();
> 	/* ... */
> 	kernel_neon_end();

I'm not entirely sure where the begin and end points would be in the
context of KVM?

> 
> which does have the host user context saving built in -- though this
> may have unwanted side effects, such as masking softirqs.  Possibly not
> a big deal though if the region is kept small (?)
> 

I'm not sure I fully understand how this would work, so it's hard for me
to comment on.

> 
> <aside>
> 
> Understanding precisely what kvm_fpsimd_flush_cpu_state() does is
> not trivial...  the explanation goes something like this:
> 
> (*takes deep breath*)
> 
> A link is maintained between tasks and CPUs to indicate whether a
> given CPU has the task's FPSIMD state in its regs.
> 
> For brevity, I'll describe this link as a relation loaded(task, cpu).
> 
> 	loaded(current, smp_processor_id()) <->
> 		!test_thread_flag(TIF_FOREIGN_FPSTATE).
> 
> (In effect, TIF_FOREIGN_FPSTATE caches this relation for current.)
> 
> For non-current tasks, the relation is something like
> 
> 	loaded(task, cpu) <->
> 		&task->thread.fpsimd_state ==
> 			per_cpu(fpsimd_last_state.st, cpu) &&
> 		task->thread.fpsimd_state.cpu == cpu.
> 
> There are subtleties about when these equivalences are meaningful
> and how they can be checked safely that I'll gloss over here --
> to get an idea, see cb968afc7898 ("arm64/sve: Avoid dereference of dead
> task_struct in KVM guest entry").
> 
>  * loaded(task, cpu) is made false for all cpus and a given task
>    by fpsimd_flush_task_state(task).
> 
>    This is how we invalidate a stale copy of some task's state when
>    the kernel deliberately changes the state (e.g., exec, sigreturn,
>    PTRACE_SETREGSET).
> 
>  * loaded(task, smp_processor_id()) is made false for all tasks
>    by fpsimd_flush_cpu_state().
> 
>    This is how we avoid using the FPSIMD regs of some CPU that
>    the kernel trashed (e.g., kernel_mode_neon, KVM) as a source
>    of any task's FPSIMD state.
> 
>  * loaded(current, smp_processor_id()) is made true by
>    fpsimd_bind_to_cpu().
> 
>    fpsimd_bind_to_cpu() also implies the effects of
>    fpsimd_flush_task_state(current) and
>    fpsimd_flush_cpu_state(smp_processor_id()) before the new relation is
>    established.  This is not explicit in the code, but falls out from
>    the way the relation is represented.
> 
> 
> ( There is a wrinkle here: fpsimd_flush_task_state(task) should always
> be followed by set_thread_flag(TIF_FOREIGN_FPSTATE) if task == current.
> fpsimd_flush_cpu_state() should similarly set that flag, otherwise the
> garbage left in the SVE bits by KVM's save/restore may spuriously
> appear in the vcpu thread's user regs.  But since that data will be (a)
> zeros or (b) the task's own data; and because TIF_SVE is cleared in
> entry.S:el0_svc is a side-effect of the ioctl(KVM_RUN) syscall, I don't
> think this matters in practice.
> 
> If we extend kvm_fpsimd_flush_cpu_state() to invalidate in the non-SVE
> case too then this becomes significant and we _would_ need to clear
> TIF_FOREIGN_FPSTATE to avoid the guests FPSIMD regs appearing in the

clear?  Wouldn't we need to set it?

> vcpu user thread. )
> 
> </aside>
> 

Thanks for this, it's helpful.

What's missing for my understanding is when fpsimd_save_state() gets
called, which must be required in some cases of invalidating the
relation, since otherwise there must be a risk of losing state?

> > > The alternative would have been for KVM to save/restore the host SVE
> > > state directly, but this seemed premature and invasive in the absence
> > > of full KVM SVE support.
> > > 
> > > This means that KVM's own save/restore of the host's FPSIMD state
> > > becomes redundant in this case, but since there is no SVE hardware
> > > yet, I favoured correctness over optimal performance here.
> > > 
> > 
> > I agree with the approach, I guess I just can't seem to follow the code
> > correctly...
> 
> Understandable... even trying to remember how it works is giving me a
> headache #P
> 
> > 
> > > 
> > > My point here was that we could modify this hook to always save off the
> > > host FPSIMD state unconditionally before entering the guts of KVM,
> > > instead of only doing it when there is live SVE state.  The benefit of
> > > this is that the host context switch machinery knows if the state has
> > > already been saved and won't do it again.  Thus a kvm userspace -> vcpu
> > > (-> guest exit -> vcpu)* -> guest_exit sequence of arbitrary length
> > > will only save the host FPSIMD (or SVE) state once, and won't restore
> > > it at all (assuming no context switches).
> > > 
> > > Instead, the user thread's FPSIMD state is only reloaded on the final
> > > return to userspace.
> > > 
> > 
> > I think that would invert the logic we have now, so instead of only
> > saving/restoring the FPSIMD state when the guest uses it (as we do now),
> > we would only save/restore the FPSIMD state when the host uses it,
> > regardless of what the guest does.
> 
> I'm not sure that's a complete characterisation of what's going on,
> but I'm struggling to describe my view in simple terms.
> 
> > Ideally, we could have a combination of both, but it's unclear to me if
> > we have good indications that one case is more likely than the other.
> > 
> > My gut feeling though, is that the guest will be likely to often access
> > FPSIMD state for as long as we're in KVM_RUN, and that host userspace
> > also often uses FPSIMD (memcopy, etc.), but the rest of the host kernel
> > (kernel threads etc.) is unlikely to use FPSIMD for a system that is
> > primarily running VMs.
> 
> I think my suggestion:
> 
>  * neither adds nor elides any saves or restores of the guest context;
>  * elides some saves and restores of the host context;
>  * moves the host context save with respect to your series in those
>    cases where it does occur; and
>  * adds 1 host context save for each preempt-or-enter-userspace ...
>    preempt-or-enter-userspace interval of a vcpu thread during which
>    the guest does not use FPSIMD.
>   
> The last bullet is the only one that can add cost.  I can imagine
> hitting this during an I/O emulation storm.  I feel that most of the
> rest of the time the change would be a net win, but it's hard to gauge
> the overall impact.
> 

It's certainly possible to have a flow where the guest kernel is not
using FPSIMD and keeps bouncing back to host userspace which does FPSIMD
in memcpy().  This is a pretty likely case for small disk I/O, so I'm
not crazy about this.

> 
> Migrating to using the host context switch machinery as-is for
> managing the guest FPSIMD context would allow all the redundant
> saves/restores would be eliminated.
> 
> It would be a more invasive change though, and I don't think this
> series should attempt it.
> 

I agree that we should attempt to use the host machinery to switch
FPSIMD state for the guest state, as long as we can keep doing that
lazily for the guest state.  Not sure if it belongs in these patches or
not (probably not), but I think it would be helpful if we could write up
a patch to see how that would look.  I don't think any intermediate
optimizations are worth it at this point.

Thanks,
-Christoffer
