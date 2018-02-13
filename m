From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 09/41] KVM: arm64: Defer restoring host VFP state to
 vcpu_put
Date: Tue, 13 Feb 2018 14:08:47 +0000
Message-ID: <20180213140843.GN5862@e103592.cambridge.arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-10-christoffer.dall@linaro.org>
 <20180122173326.GO22781@e103592.cambridge.arm.com>
 <20180125194653.GR21802@cbox>
 <20180207164955.GT5862@e103592.cambridge.arm.com>
 <20180207175644.GF29286@cbox>
 <20180209155930.GD5862@e103592.cambridge.arm.com>
 <20180213085130.GB23189@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180213085130.GB23189@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 13, 2018 at 09:51:30AM +0100, Christoffer Dall wrote:
> On Fri, Feb 09, 2018 at 03:59:30PM +0000, Dave Martin wrote:
> > On Wed, Feb 07, 2018 at 06:56:44PM +0100, Christoffer Dall wrote:
> > > On Wed, Feb 07, 2018 at 04:49:55PM +0000, Dave Martin wrote:

[...]

> > Simply entering the kernel and returning to userspace doesn't have
> > this effect by itself.
> > 
> > 
> > Prior to the SVE patches, KVM makes itself orthogonal to the host
> > context switch machinery by ensuring that whatever the host had
> > in the FPSIMD regs at guest entry is restored before returning to
> > the host. (IIUC)  
> 
> Only if the guest actually touches FPSIMD state.  If the guest doesn't
> touch FPSIMD (no trap to EL2), then we never touch the state at all.

I should have been clearer: KVM ensures that the state is _unchanged_
before returning to the host, but can elide the save/restore when the
guest doesn't touch the state...

> 
> > This means that redundant save/restore work is
> > done by KVM, but does have the advantage of simplicity.
> 
> I don't understand what the redundant part here is?  Isn't it only
> redundant in the case where the host (for some reason) has already saved
> its FPSIMD state?  I assume that won't be the common case, since
> "userspace->kernel->kvm_run" won't save the FPSIMD state, as you just
> explained above.

...however, when this elision does not occur, it may duplicate
save/restore done by the kernel, or it may save/restore worthless data
if the host's FPSIMD state is non-live at the time.

It's hard to gauge the impact of this: it seems unlikely to make a
massive difference, but will be highly workload-dependent.


The redundancy occurs because of the deferred restore of the FPSIMD
registers for host userspace: as a result, the host FPSIMD regs are
either discardable (i.e., already saved) or not live at all between
and context switch and the next ret_to_user.

This means that if the vcpu run loop is preempted, then when the host
switches back to the run loop it is pointless to save or restore the
host FPSIMD state.

A typical sequence of events exposing this redundancy would be as
follows.  I assume here that there are two cpu-bound tasks A and B
competing for a host CPU, where A is a vcpu thread:

 - vcpu A is in the guest running a compute-heavy task
 - FPSIMD typically traps to the host before context switch
 X kvm saves the host FPSIMD state
 - kvm loads the guest FPSIMD state
 - vcpu A reenters the guest
 - host context switch IRQ preempts A back to the run loop
 Y kvm loads the host FPSIMD state via vcpu_put

 - host context switch:
 - TIF_FOREIGN_FPSTATE is set -> no save of user FPSIMD state
 - switch to B
 - B reaches ret_to_user
 Y B's user FPSIMD state is loaded: TIF_FOREIGN_FPSTATE now clear
 - B enters userspace

 - host context switch:
 - B enters kernel
 X TIF_FOREIGN_FPSTATE now set -> host saves B's FPSIMD state
 - switch to A -> set TIF_FOREIGN_FPSTATE for A
 - back to the KVM run loop

 - vcpu A enters guest
 - redo from start

Here, the two saves marked X are redundant with respect to each other,
and the two restores marked Y are redundant with respect to each other.

> > This breaks for SVE though: the high bits of the Z-registers will be
> > zeroed as a side effect of the FPSIMD save/restore done by KVM.
> > This means that if the host has state in those bits then it must
> > be saved before entring the guest: that's what the new
> > kvm_fpsimd_flush_cpu_state() hook in kvm_arch_vcpu_ioctl_run() is for.
> 
> Again, I'm confused, because to me it looks like
> kvm_fpsimd_flush_cpu_state() boils down to fpsimd_flush_cpu_state()
> which just sets a pointer to NULL, but doesn't actually save the state.
> 
> So, when is the state in the hardware registers saved to memory?

This _is_ quite confusing: in writing this answer I identified a bug
and then realised why there is no bug...

kvm_fpsimd_flush_cpu_state() is just an invalidation.  No state is
actually saved today because we explicitly don't care about preserving
the SVE state, because the syscall ABI throws the SVE regs away as
a side effect any syscall including ioctl(KVM_RUN); also (currently) KVM
ensures that the non-SVE FPSIMD bits _are_ restored by itself.

I think my proposal is that this hook might take on the role of
actually saving the state too, if we move that out of the KVM host
context save/restore code.

Perhaps we could even replace

	preempt_disable();
	kvm_fpsimd_flush_cpu_state();
	/* ... */
	preempt_enable();

with

	kernel_neon_begin();
	/* ... */
	kernel_neon_end();

which does have the host user context saving built in -- though this
may have unwanted side effects, such as masking softirqs.  Possibly not
a big deal though if the region is kept small (?)


<aside>

Understanding precisely what kvm_fpsimd_flush_cpu_state() does is
not trivial...  the explanation goes something like this:

(*takes deep breath*)

A link is maintained between tasks and CPUs to indicate whether a
given CPU has the task's FPSIMD state in its regs.

For brevity, I'll describe this link as a relation loaded(task, cpu).

	loaded(current, smp_processor_id()) <->
		!test_thread_flag(TIF_FOREIGN_FPSTATE).

(In effect, TIF_FOREIGN_FPSTATE caches this relation for current.)

For non-current tasks, the relation is something like

	loaded(task, cpu) <->
		&task->thread.fpsimd_state ==
			per_cpu(fpsimd_last_state.st, cpu) &&
		task->thread.fpsimd_state.cpu == cpu.

There are subtleties about when these equivalences are meaningful
and how they can be checked safely that I'll gloss over here --
to get an idea, see cb968afc7898 ("arm64/sve: Avoid dereference of dead
task_struct in KVM guest entry").

 * loaded(task, cpu) is made false for all cpus and a given task
   by fpsimd_flush_task_state(task).

   This is how we invalidate a stale copy of some task's state when
   the kernel deliberately changes the state (e.g., exec, sigreturn,
   PTRACE_SETREGSET).

 * loaded(task, smp_processor_id()) is made false for all tasks
   by fpsimd_flush_cpu_state().

   This is how we avoid using the FPSIMD regs of some CPU that
   the kernel trashed (e.g., kernel_mode_neon, KVM) as a source
   of any task's FPSIMD state.

 * loaded(current, smp_processor_id()) is made true by
   fpsimd_bind_to_cpu().

   fpsimd_bind_to_cpu() also implies the effects of
   fpsimd_flush_task_state(current) and
   fpsimd_flush_cpu_state(smp_processor_id()) before the new relation is
   established.  This is not explicit in the code, but falls out from
   the way the relation is represented.


( There is a wrinkle here: fpsimd_flush_task_state(task) should always
be followed by set_thread_flag(TIF_FOREIGN_FPSTATE) if task == current.
fpsimd_flush_cpu_state() should similarly set that flag, otherwise the
garbage left in the SVE bits by KVM's save/restore may spuriously
appear in the vcpu thread's user regs.  But since that data will be (a)
zeros or (b) the task's own data; and because TIF_SVE is cleared in
entry.S:el0_svc is a side-effect of the ioctl(KVM_RUN) syscall, I don't
think this matters in practice.

If we extend kvm_fpsimd_flush_cpu_state() to invalidate in the non-SVE
case too then this becomes significant and we _would_ need to clear
TIF_FOREIGN_FPSTATE to avoid the guests FPSIMD regs appearing in the
vcpu user thread. )

</aside>

> > The alternative would have been for KVM to save/restore the host SVE
> > state directly, but this seemed premature and invasive in the absence
> > of full KVM SVE support.
> > 
> > This means that KVM's own save/restore of the host's FPSIMD state
> > becomes redundant in this case, but since there is no SVE hardware
> > yet, I favoured correctness over optimal performance here.
> > 
> 
> I agree with the approach, I guess I just can't seem to follow the code
> correctly...

Understandable... even trying to remember how it works is giving me a
headache #P

> 
> > 
> > My point here was that we could modify this hook to always save off the
> > host FPSIMD state unconditionally before entering the guts of KVM,
> > instead of only doing it when there is live SVE state.  The benefit of
> > this is that the host context switch machinery knows if the state has
> > already been saved and won't do it again.  Thus a kvm userspace -> vcpu
> > (-> guest exit -> vcpu)* -> guest_exit sequence of arbitrary length
> > will only save the host FPSIMD (or SVE) state once, and won't restore
> > it at all (assuming no context switches).
> > 
> > Instead, the user thread's FPSIMD state is only reloaded on the final
> > return to userspace.
> > 
> 
> I think that would invert the logic we have now, so instead of only
> saving/restoring the FPSIMD state when the guest uses it (as we do now),
> we would only save/restore the FPSIMD state when the host uses it,
> regardless of what the guest does.

I'm not sure that's a complete characterisation of what's going on,
but I'm struggling to describe my view in simple terms.

> Ideally, we could have a combination of both, but it's unclear to me if
> we have good indications that one case is more likely than the other.
> 
> My gut feeling though, is that the guest will be likely to often access
> FPSIMD state for as long as we're in KVM_RUN, and that host userspace
> also often uses FPSIMD (memcopy, etc.), but the rest of the host kernel
> (kernel threads etc.) is unlikely to use FPSIMD for a system that is
> primarily running VMs.

I think my suggestion:

 * neither adds nor elides any saves or restores of the guest context;
 * elides some saves and restores of the host context;
 * moves the host context save with respect to your series in those
   cases where it does occur; and
 * adds 1 host context save for each preempt-or-enter-userspace ...
   preempt-or-enter-userspace interval of a vcpu thread during which
   the guest does not use FPSIMD.
  
The last bullet is the only one that can add cost.  I can imagine
hitting this during an I/O emulation storm.  I feel that most of the
rest of the time the change would be a net win, but it's hard to gauge
the overall impact.


Migrating to using the host context switch machinery as-is for
managing the guest FPSIMD context would allow all the redundant
saves/restores would be eliminated.

It would be a more invasive change though, and I don't think this
series should attempt it.

> > > > Yes (except that if a return to userspace happens then FPSIMD will be
> > > > restored at that point: there is no laziness there -- it _could_
> > > > be lazy, but it's deemed unlikely to be a performance win due to the
> > > > fact that the compiler can and does generate FPSIMD code quite
> > > > liberally by default).
> > > > 
> > > > For the case of being preempted within the kernel with no ret_to_user,
> > > > you are correct.
> > > > 
> > > 
> > > ok, that would indeed also be useful for things like switching to a
> > > vhost thread and returning to the vcpu thread.
> > 
> > What's a vhost thread?
> > 
> 
> vhost is the offload mechanism for the data-path of virtio devices, and
> for example if you have an application in your VM which is sending data,
> the VM will typically fill some buffer and then cause a trap to the host
> kernel by writing to an emulated PCI MMIO register, and that trap is
> handled by KVM's IO bus infrastructure, which schedules a vhost kernel
> thread which actually sends the data from the buffer shared between the
> VM and the host kernel onto the physical network.

Ah, right.

Cheers
---Dave
