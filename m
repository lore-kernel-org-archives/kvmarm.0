From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 09/41] KVM: arm64: Defer restoring host VFP state to
 vcpu_put
Date: Tue, 13 Feb 2018 09:51:30 +0100
Message-ID: <20180213085130.GB23189@cbox>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-10-christoffer.dall@linaro.org>
 <20180122173326.GO22781@e103592.cambridge.arm.com>
 <20180125194653.GR21802@cbox>
 <20180207164955.GT5862@e103592.cambridge.arm.com>
 <20180207175644.GF29286@cbox>
 <20180209155930.GD5862@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180209155930.GD5862@e103592.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 09, 2018 at 03:59:30PM +0000, Dave Martin wrote:
> On Wed, Feb 07, 2018 at 06:56:44PM +0100, Christoffer Dall wrote:
> > On Wed, Feb 07, 2018 at 04:49:55PM +0000, Dave Martin wrote:
> > > On Thu, Jan 25, 2018 at 08:46:53PM +0100, Christoffer Dall wrote:
> > > > On Mon, Jan 22, 2018 at 05:33:28PM +0000, Dave Martin wrote:
> > > > > On Fri, Jan 12, 2018 at 01:07:15PM +0100, Christoffer Dall wrote:
> > > > > > Avoid saving the guest VFP registers and restoring the host VFP
> > > > > > registers on every exit from the VM.  Only when we're about to run
> > > > > > userspace or other threads in the kernel do we really have to switch the
> > > > > > state back to the host state.
> > > > > > 
> > > > > > We still initially configure the VFP registers to trap when entering the
> > > > > > VM, but the difference is that we now leave the guest state in the
> > > > > > hardware registers as long as we're running this VCPU, even if we
> > > > > > occasionally trap to the host, and we only restore the host state when
> > > > > > we return to user space or when scheduling another thread.
> > > > > > 
> > > > > > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > > > > > Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> > > > > > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > > > > 
> > > > > [...]
> > > > > 
> > > > > > diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> > > > > > index 883a6383cd36..848a46eb33bf 100644
> > > > > > --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> > > > > > +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> > > > > 
> > > > > [...]
> > > > > 
> > > > > > @@ -213,6 +215,19 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
> > > > > >   */
> > > > > >  void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
> > > > > >  {
> > > > > > +	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
> > > > > > +	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
> > > > > > +
> > > > > > +	/* Restore host FP/SIMD state */
> > > > > > +	if (vcpu->arch.guest_vfp_loaded) {
> > > > > > +		if (vcpu_el1_is_32bit(vcpu)) {
> > > > > > +			kvm_call_hyp(__fpsimd32_save_state,
> > > > > > +				     kern_hyp_va(guest_ctxt));
> > > > > > +		}
> > > > > > +		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
> > > > > > +		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
> > > > > > +		vcpu->arch.guest_vfp_loaded = 0;
> > > > > 
> > > > > Provided we've already marked the host FPSIMD state as dirty on the way
> > > > > in, we probably don't need to restore it here.
> > > > > 
> > > > > In v4.15, the kvm_fpsimd_flush_cpu_state() call in
> > > > > kvm_arch_vcpu_ioctl_run() is supposed to do this marking: currently
> > > > > it's only done for SVE, since KVM was previously restoring the host
> > > > > FPSIMD subset of the state anyway, but it could be made unconditional.
> > > > > 
> > > > > For a returning run ioctl, this would have the effect of deferring the
> > > > > host FPSIMD reload until we return to userspace, which is probably
> > > > > no more costly since the kernel must check whether to do this in
> > > > > ret_to_user anyway; OTOH if the vcpu thread was preempted by some
> > > > > other thread we save the cost of restoring the host state entirely here
> > > > > ... I think.
> > > > 
> > > > Yes, I agree.  However, currently the low-level logic in
> > > > arch/arm64/kvm/hyp/entry.S:__fpsimd_guest_restore which saves the host
> > > > state into vcpu->arch.host_cpu_context->gp_regs.fp_regs (where
> > > > host_cpu_context is a KVM-specific per-cpu variable).  I think means
> > > > that simply marking the state as invalid would cause the kernel to
> > > > restore some potentially stale values when returning to userspace.  Am I
> > > > missing something?
> > > 
> > > I think my point was that there would be no need for the low-level
> > > save of the host fpsimd state currently done by hyp.  At all.  The
> > > state would already have been saved off to thread_struct before
> > > entering the guest.
> > 
> > Ah, so if userspace touched any FPSIMD state, then we always save that
> > state when entering the kernel, even if we're just going to return to
> > the same userspace process anyway?  (For any system call etc.?)
> 
> Not exactly.  The state is saved when the corresponding user task is
> scheduled out, or when it would become stale because we're about to
> modify the task_struct view of the state (sigreturn/PTRACE_SETREGST).
> The state is also saved if necessary by kernel_neon_begin().
> 
> Simply entering the kernel and returning to userspace doesn't have
> this effect by itself.
> 
> 
> Prior to the SVE patches, KVM makes itself orthogonal to the host
> context switch machinery by ensuring that whatever the host had
> in the FPSIMD regs at guest entry is restored before returning to
> the host. (IIUC)  

Only if the guest actually touches FPSIMD state.  If the guest doesn't
touch FPSIMD (no trap to EL2), then we never touch the state at all.

> This means that redundant save/restore work is
> done by KVM, but does have the advantage of simplicity.

I don't understand what the redundant part here is?  Isn't it only
redundant in the case where the host (for some reason) has already saved
its FPSIMD state?  I assume that won't be the common case, since
"userspace->kernel->kvm_run" won't save the FPSIMD state, as you just
explained above.

> 
> This breaks for SVE though: the high bits of the Z-registers will be
> zeroed as a side effect of the FPSIMD save/restore done by KVM.
> This means that if the host has state in those bits then it must
> be saved before entring the guest: that's what the new
> kvm_fpsimd_flush_cpu_state() hook in kvm_arch_vcpu_ioctl_run() is for.

Again, I'm confused, because to me it looks like
kvm_fpsimd_flush_cpu_state() boils down to fpsimd_flush_cpu_state()
which just sets a pointer to NULL, but doesn't actually save the state.

So, when is the state in the hardware registers saved to memory?

> The alternative would have been for KVM to save/restore the host SVE
> state directly, but this seemed premature and invasive in the absence
> of full KVM SVE support.
> 
> This means that KVM's own save/restore of the host's FPSIMD state
> becomes redundant in this case, but since there is no SVE hardware
> yet, I favoured correctness over optimal performance here.
> 

I agree with the approach, I guess I just can't seem to follow the code
correctly...

> 
> My point here was that we could modify this hook to always save off the
> host FPSIMD state unconditionally before entering the guts of KVM,
> instead of only doing it when there is live SVE state.  The benefit of
> this is that the host context switch machinery knows if the state has
> already been saved and won't do it again.  Thus a kvm userspace -> vcpu
> (-> guest exit -> vcpu)* -> guest_exit sequence of arbitrary length
> will only save the host FPSIMD (or SVE) state once, and won't restore
> it at all (assuming no context switches).
> 
> Instead, the user thread's FPSIMD state is only reloaded on the final
> return to userspace.
> 

I think that would invert the logic we have now, so instead of only
saving/restoring the FPSIMD state when the guest uses it (as we do now),
we would only save/restore the FPSIMD state when the host uses it,
regardless of what the guest does.

Ideally, we could have a combination of both, but it's unclear to me if
we have good indications that one case is more likely than the other.

My gut feeling though, is that the guest will be likely to often access
FPSIMD state for as long as we're in KVM_RUN, and that host userspace
also often uses FPSIMD (memcopy, etc.), but the rest of the host kernel
(kernel threads etc.) is unlikely to use FPSIMD for a system that is
primarily running VMs.

> > > 
> > > This would result in a redundant save, but only when the host fpsimd
> > > state is dirty and the guest vcpu doesn't touch fpsimd before trapping
> > > back to the host.
> > > 
> > > For the host, the fpsimd state is only dirty after entering the kernel
> > > from userspace (or after certain other things like sigreturn or ptrace).
> > > So this approach would still avoid repeated save/restore when cycling
> > > between the guest and the kvm code in the host.
> > > 
> > 
> > I see.
> > 
> > > > It might very well be possible to change the logic so that we store the
> > > > host logic the same place where task_fpsimd_save() would have, and I
> > > > think that would make what you suggest possible.
> > > 
> > > That's certainly possible, but I viewed that as harder.  It would be
> > > necessary to map the host thread_struct into hyp etc. etc.
> > > 
> > 
> > And even then, unnecessary because it would duplicate the existing state
> > save, IIUC above.
> 
> Agreed.  The main disadvantage of my approach is that the host state
> cannot be saved lazily any more, but it least it is only saved once
> for a given vcpu run loop.
> 
> > > > I'd like to make that a separate change from this patch though, as we're
> > > > already changing quite a bit with this series, so I'm trying to make any
> > > > logical change as contained per patch as possible, so that problems can
> > > > be spotted by bisecting.
> > > 
> > > Yes, I think that's wise.
> > > 
> > 
> > ok, I'll try to incorporate this as a separate patch for the next
> > revision.
> > 
> > > > > Ultimately I'd like to go one better and actually treat a vcpu as a
> > > > > first-class fpsimd context, so that taking an interrupt to the host
> > > > > and then reentering the guest doesn't cause any reload at all.  
> > > > 
> > > > That should be the case already; kvm_vcpu_put_sysregs() is only called
> > > > when you run another thread (preemptively or voluntarily), or when you
> > > > return to user space, but making the vcpu fpsimd context a first-class
> > > > citizen fpsimd context would mean that you can run another thread (and
> > > > maybe run userspace if it doesn't use fpsimd?) without having to
> > > > save/restore anything.  Am I getting this right?
> > > 
> > > Yes (except that if a return to userspace happens then FPSIMD will be
> > > restored at that point: there is no laziness there -- it _could_
> > > be lazy, but it's deemed unlikely to be a performance win due to the
> > > fact that the compiler can and does generate FPSIMD code quite
> > > liberally by default).
> > > 
> > > For the case of being preempted within the kernel with no ret_to_user,
> > > you are correct.
> > > 
> > 
> > ok, that would indeed also be useful for things like switching to a
> > vhost thread and returning to the vcpu thread.
> 
> What's a vhost thread?
> 

vhost is the offload mechanism for the data-path of virtio devices, and
for example if you have an application in your VM which is sending data,
the VM will typically fill some buffer and then cause a trap to the host
kernel by writing to an emulated PCI MMIO register, and that trap is
handled by KVM's IO bus infrastructure, which schedules a vhost kernel
thread which actually sends the data from the buffer shared between the
VM and the host kernel onto the physical network.

Thanks,
-Christoffer
