From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 09/41] KVM: arm64: Defer restoring host VFP state to
 vcpu_put
Date: Wed, 14 Feb 2018 14:43:42 +0000
Message-ID: <20180214144242.GA11748@e103592.cambridge.arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-10-christoffer.dall@linaro.org>
 <20180122173326.GO22781@e103592.cambridge.arm.com>
 <20180125194653.GR21802@cbox>
 <20180207164955.GT5862@e103592.cambridge.arm.com>
 <20180207175644.GF29286@cbox>
 <20180209155930.GD5862@e103592.cambridge.arm.com>
 <20180213085130.GB23189@cbox>
 <20180213140843.GN5862@e103592.cambridge.arm.com>
 <20180214101554.GL23189@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180214101554.GL23189@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

[CC Ard, in case he has a view on how much we care about softirq NEON
performance regressions ... and whether my suggestions make sense]

On Wed, Feb 14, 2018 at 11:15:54AM +0100, Christoffer Dall wrote:
> On Tue, Feb 13, 2018 at 02:08:47PM +0000, Dave Martin wrote:
> > On Tue, Feb 13, 2018 at 09:51:30AM +0100, Christoffer Dall wrote:
> > > On Fri, Feb 09, 2018 at 03:59:30PM +0000, Dave Martin wrote:

[...]

> > It's hard to gauge the impact of this: it seems unlikely to make a
> > massive difference, but will be highly workload-dependent.
> 
> So I thought it might be useful to have some idea of the frequency of
> events on a balanced workload, so I ran an 8-way SMP guest on Ubuntu
> 14.04 running SPECjvm2008, a memcached benchmark, a MySQL workloads, and
> some networking benchmarks, and I counted a few events:
> 
>  - Out of all the exits, from the guest to run-loop in EL1 on a non-VHE
>    system, fewer than 1% of them result in an exit to userspace (0.57%).
> 
>  - The VCPU thread was preempted (voluntarily or forced) in the kernel
>    less than 3% of the exits (2.72%).  That's just below 5 preemptions
>    per ioctl(KVM_RUN).
> 
>  - In 29% of the preemptions (vcpu_put), the guest had touched FPSIMD
>    registers and the host context was restored.
> 
>  - We store the host context about 1.38 times per ioctl(KVM_RUN).
> 
> So that tells me that (1) it's worth restoring the guest FPSIMD state
> lazily as opposed to proactively on vcpu_load, and (2) that there's a
> small opportunity for improvement by reducing redundant host vfp state
> saves.

That's really useful.  I guess it confirms that lazy guest FPSIMD
restore is desirable (though I wasn't disputing this) and that the
potential benefit from eliminating redundant host FPSIMD saves is
modest, assume that this workload is representative.

So we shouldn't over-optimise for the latter if there are side costs
from doing so.

> > The redundancy occurs because of the deferred restore of the FPSIMD
> > registers for host userspace: as a result, the host FPSIMD regs are
> > either discardable (i.e., already saved) or not live at all between
> > and context switch and the next ret_to_user.
> > 
> > This means that if the vcpu run loop is preempted, then when the host
> > switches back to the run loop it is pointless to save or restore the
> > host FPSIMD state.
> > 
> > A typical sequence of events exposing this redundancy would be as
> > follows.  I assume here that there are two cpu-bound tasks A and B
> > competing for a host CPU, where A is a vcpu thread:
> > 
> >  - vcpu A is in the guest running a compute-heavy task
> >  - FPSIMD typically traps to the host before context switch
> >  X kvm saves the host FPSIMD state
> >  - kvm loads the guest FPSIMD state
> >  - vcpu A reenters the guest
> >  - host context switch IRQ preempts A back to the run loop
> >  Y kvm loads the host FPSIMD state via vcpu_put
> > 
> >  - host context switch:
> >  - TIF_FOREIGN_FPSTATE is set -> no save of user FPSIMD state
> >  - switch to B
> >  - B reaches ret_to_user
> >  Y B's user FPSIMD state is loaded: TIF_FOREIGN_FPSTATE now clear
> >  - B enters userspace
> > 
> >  - host context switch:
> >  - B enters kernel
> >  X TIF_FOREIGN_FPSTATE now set -> host saves B's FPSIMD state
> >  - switch to A -> set TIF_FOREIGN_FPSTATE for A
> >  - back to the KVM run loop
> > 
> >  - vcpu A enters guest
> >  - redo from start
> > 
> > Here, the two saves marked X are redundant with respect to each other,
> > and the two restores marked Y are redundant with respect to each other.
> > 
> 
> Right, ok, but if we have
> 
>  - ioctl(KVM_RUN)
>  - mark hardware FPSIMD register state as invalid
>  - load guest FPSIMD state
>  - enter guest
>  - exit guest
>  - save guest FPSIMD state
>  - return to user space
> 
> (I.e. we don't do any preemption in the guest)
> 
> Then we'll loose the host FPSIMD register state, potentially, right?

Yes.

However, (disregarding kernel-mode NEON) no host task's state can be
live in the FPSIMD regs other than current's.  If another context's
state is in the regs, it is either stale or a clean copy and we can
harmlessly invalidate the association with no ill effects.

The subtlety here comes from the SVE syscall ABI, which allows
current's non-FPSIMD SVE bits to be discarded across a syscall: in this
code, current _is_ in a syscall, so the fact that we can lose current's
SVE bits here is fine: TIF_SVE will have been cleared in entry.S on the
way in, and that means that SVE will trap for userspace giving a chance
to zero those regs lazily for userspace when/if they're used again.
Conversely, current's FPSIMD regs are preserved separately by KVM.

> Your original comment on this patch was that we didn't need to restore
> the host FPSIMD state in kvm_vcpu_put_sysregs, which would result in the
> scenario above.  The only way I can see this working is by making sure
> that kvm_fpsimd_flush_cpu_state() also saves the FPSIMD hardware
> register state if the state is live.
> 
> Am I still missing something?

[1] No, you're correct.  If we move the responsibility for context
handling to kvm_fpsimd_flush_cpu_state(), then we do have to put the
host context save there, which means it couldn't then be done lazily
(at least, not without more invasive changes)...

> > > > This breaks for SVE though: the high bits of the Z-registers will be
> > > > zeroed as a side effect of the FPSIMD save/restore done by KVM.
> > > > This means that if the host has state in those bits then it must
> > > > be saved before entring the guest: that's what the new
> > > > kvm_fpsimd_flush_cpu_state() hook in kvm_arch_vcpu_ioctl_run() is for.
> > > 
> > > Again, I'm confused, because to me it looks like
> > > kvm_fpsimd_flush_cpu_state() boils down to fpsimd_flush_cpu_state()
> > > which just sets a pointer to NULL, but doesn't actually save the state.
> > > 
> > > So, when is the state in the hardware registers saved to memory?
> > 
> > This _is_ quite confusing: in writing this answer I identified a bug
> > and then realised why there is no bug...
> > 
> > kvm_fpsimd_flush_cpu_state() is just an invalidation.  No state is
> > actually saved today because we explicitly don't care about preserving
> > the SVE state, because the syscall ABI throws the SVE regs away as
> > a side effect any syscall including ioctl(KVM_RUN); also (currently) KVM
> > ensures that the non-SVE FPSIMD bits _are_ restored by itself.
> > 
> > I think my proposal is that this hook might take on the role of
> > actually saving the state too, if we move that out of the KVM host
> > context save/restore code.
> > 
> > Perhaps we could even replace
> > 
> > 	preempt_disable();
> > 	kvm_fpsimd_flush_cpu_state();
> > 	/* ... */
> > 	preempt_enable();
> > 
> > with
> > 
> > 	kernel_neon_begin();
> > 	/* ... */
> > 	kernel_neon_end();
> 
> I'm not entirely sure where the begin and end points would be in the
> context of KVM?

Hmmm, actually there's a bug in your VHE changes now I look more
closely in this area:

You assume that the only way for the FPSIMD regs to get unexpectedly
dirtied is through a context switch, but actually this is not the case:
a softirq can use kernel-mode NEON any time that softirqs are enabled.

This means that in between kvm_arch_vcpu_load() and _put() (whether via
preempt notification or not), the guest's FPSIMD state in the regs may
be trashed by a softirq.

The simplest fix is to disable softirqs and preemption for that whole
region, but since we can stay in it indefinitely that's obviously not
the right approach.  Putting kernel_neon_begin() in _load() and
kernel_neon_end() in _put() achieves the same without disabling
softirq, but preemption is still disabled throughout, which is bad.
This effectively makes the run ioctl nonpreemptible...

A better fix would be to set the cpu's kernel_neon_busy flag, which
makes softirq code use non-NEON fallback code.

We could expose an interface from fpsimd.c to support that.

It still comes at a cost though: due to the switching from NEON to
fallback code in softirq handlers, we may get a big performance
regression in setups that rely heavily on NEON in softirq for
performance.


Alternatively we could do something like the following, but it's a
rather gross abstraction violation:

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 2e43f9d..6a1ff3a 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -746,9 +746,24 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * the effect of taking the interrupt again, in SVC
 		 * mode this time.
 		 */
+		local_bh_disable();
 		local_irq_enable();
 
 		/*
+		 * If we exited due to one or mode pending interrupts, they
+		 * have now been handled.  If such an interrupt pended a
+		 * softirq, we shouldn't prevent that softirq from using
+		 * kernel-mode NEON indefinitely: instead, give FPSIMD back to
+		 * the host to manage as it likes.  We'll grab it again on the
+		 * next FPSIMD trap from the guest (if any).
+		 */
+		if (local_softirq_pending() && FPSIMD untrapped for guest) {
+			/* save vcpu FPSIMD context */
+			/* enable FPSIMD trap for guest */
+		}
+		local_bh_enable();
+
+		/*
 		 * We do local_irq_enable() before calling guest_exit() so
 		 * that if a timer interrupt hits while running the guest we
 		 * account that tick as being spent in the guest.  We enable

[...]

> > ( There is a wrinkle here: fpsimd_flush_task_state(task) should always
> > be followed by set_thread_flag(TIF_FOREIGN_FPSTATE) if task == current.
> > fpsimd_flush_cpu_state() should similarly set that flag, otherwise the
> > garbage left in the SVE bits by KVM's save/restore may spuriously
> > appear in the vcpu thread's user regs.  But since that data will be (a)
> > zeros or (b) the task's own data; and because TIF_SVE is cleared in
> > entry.S:el0_svc is a side-effect of the ioctl(KVM_RUN) syscall, I don't
> > think this matters in practice.
> > 
> > If we extend kvm_fpsimd_flush_cpu_state() to invalidate in the non-SVE
> > case too then this becomes significant and we _would_ need to clear
> > TIF_FOREIGN_FPSTATE to avoid the guests FPSIMD regs appearing in the
> 
> clear?  Wouldn't we need to set it?

Err, yes.  Just testing.

Again, kernel_mode_neon() does do that, as well as calling
fpsimd_flush_cpu_state(), showing some convergence with what kvm needs
to do here.

> > <aside>

[...]

> > </aside>
> > 
> 
> Thanks for this, it's helpful.
> 
> What's missing for my understanding is when fpsimd_save_state() gets
> called, which must be required in some cases of invalidating the
> relation, since otherwise there must be a risk of losing state?

See [1].

[...]

> > I think my suggestion:

[...]

> >  * adds 1 host context save for each preempt-or-enter-userspace ...
> >    preempt-or-enter-userspace interval of a vcpu thread during which
> >    the guest does not use FPSIMD.
> >   
> > The last bullet is the only one that can add cost.  I can imagine
> > hitting this during an I/O emulation storm.  I feel that most of the
> > rest of the time the change would be a net win, but it's hard to gauge
> > the overall impact.
> 
> It's certainly possible to have a flow where the guest kernel is not
> using FPSIMD and keeps bouncing back to host userspace which does FPSIMD
> in memcpy().  This is a pretty likely case for small disk I/O, so I'm
> not crazy about this.

Sure, understood.

> > 
> > Migrating to using the host context switch machinery as-is for
> > managing the guest FPSIMD context would allow all the redundant
> > saves/restores would be eliminated.
> > 
> > It would be a more invasive change though, and I don't think this
> > series should attempt it.
> > 
> 
> I agree that we should attempt to use the host machinery to switch
> FPSIMD state for the guest state, as long as we can keep doing that
> lazily for the guest state.  Not sure if it belongs in these patches or
> not (probably not), but I think it would be helpful if we could write up
> a patch to see how that would look.  I don't think any intermediate
> optimizations are worth it at this point.

Agreed; I think this is for the future.  If I can find a moment I may
hack on it to see how bad it looks.

But see above for my current understanding on what we need to do for
correctness today without introducing significant performance
regressions for kernel-mode NEON softirq scenarios.

Cheers
---Dave
