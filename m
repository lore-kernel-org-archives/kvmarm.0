From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 09/41] KVM: arm64: Defer restoring host VFP state to
 vcpu_put
Date: Wed, 7 Feb 2018 18:56:44 +0100
Message-ID: <20180207175644.GF29286@cbox>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-10-christoffer.dall@linaro.org>
 <20180122173326.GO22781@e103592.cambridge.arm.com>
 <20180125194653.GR21802@cbox>
 <20180207164955.GT5862@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180207164955.GT5862@e103592.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 07, 2018 at 04:49:55PM +0000, Dave Martin wrote:
> On Thu, Jan 25, 2018 at 08:46:53PM +0100, Christoffer Dall wrote:
> > On Mon, Jan 22, 2018 at 05:33:28PM +0000, Dave Martin wrote:
> > > On Fri, Jan 12, 2018 at 01:07:15PM +0100, Christoffer Dall wrote:
> > > > Avoid saving the guest VFP registers and restoring the host VFP
> > > > registers on every exit from the VM.  Only when we're about to run
> > > > userspace or other threads in the kernel do we really have to switch the
> > > > state back to the host state.
> > > > 
> > > > We still initially configure the VFP registers to trap when entering the
> > > > VM, but the difference is that we now leave the guest state in the
> > > > hardware registers as long as we're running this VCPU, even if we
> > > > occasionally trap to the host, and we only restore the host state when
> > > > we return to user space or when scheduling another thread.
> > > > 
> > > > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > > > Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> > > > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > > 
> > > [...]
> > > 
> > > > diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> > > > index 883a6383cd36..848a46eb33bf 100644
> > > > --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> > > > +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> > > 
> > > [...]
> > > 
> > > > @@ -213,6 +215,19 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
> > > >   */
> > > >  void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
> > > >  {
> > > > +	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
> > > > +	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
> > > > +
> > > > +	/* Restore host FP/SIMD state */
> > > > +	if (vcpu->arch.guest_vfp_loaded) {
> > > > +		if (vcpu_el1_is_32bit(vcpu)) {
> > > > +			kvm_call_hyp(__fpsimd32_save_state,
> > > > +				     kern_hyp_va(guest_ctxt));
> > > > +		}
> > > > +		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
> > > > +		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
> > > > +		vcpu->arch.guest_vfp_loaded = 0;
> > > 
> > > Provided we've already marked the host FPSIMD state as dirty on the way
> > > in, we probably don't need to restore it here.
> > > 
> > > In v4.15, the kvm_fpsimd_flush_cpu_state() call in
> > > kvm_arch_vcpu_ioctl_run() is supposed to do this marking: currently
> > > it's only done for SVE, since KVM was previously restoring the host
> > > FPSIMD subset of the state anyway, but it could be made unconditional.
> > > 
> > > For a returning run ioctl, this would have the effect of deferring the
> > > host FPSIMD reload until we return to userspace, which is probably
> > > no more costly since the kernel must check whether to do this in
> > > ret_to_user anyway; OTOH if the vcpu thread was preempted by some
> > > other thread we save the cost of restoring the host state entirely here
> > > ... I think.
> > 
> > Yes, I agree.  However, currently the low-level logic in
> > arch/arm64/kvm/hyp/entry.S:__fpsimd_guest_restore which saves the host
> > state into vcpu->arch.host_cpu_context->gp_regs.fp_regs (where
> > host_cpu_context is a KVM-specific per-cpu variable).  I think means
> > that simply marking the state as invalid would cause the kernel to
> > restore some potentially stale values when returning to userspace.  Am I
> > missing something?
> 
> I think my point was that there would be no need for the low-level
> save of the host fpsimd state currently done by hyp.  At all.  The
> state would already have been saved off to thread_struct before
> entering the guest.

Ah, so if userspace touched any FPSIMD state, then we always save that
state when entering the kernel, even if we're just going to return to
the same userspace process anyway?  (For any system call etc.?)

> 
> This would result in a redundant save, but only when the host fpsimd
> state is dirty and the guest vcpu doesn't touch fpsimd before trapping
> back to the host.
> 
> For the host, the fpsimd state is only dirty after entering the kernel
> from userspace (or after certain other things like sigreturn or ptrace).
> So this approach would still avoid repeated save/restore when cycling
> between the guest and the kvm code in the host.
> 

I see.

> > It might very well be possible to change the logic so that we store the
> > host logic the same place where task_fpsimd_save() would have, and I
> > think that would make what you suggest possible.
> 
> That's certainly possible, but I viewed that as harder.  It would be
> necessary to map the host thread_struct into hyp etc. etc.
> 

And even then, unnecessary because it would duplicate the existing state
save, IIUC above.

> > I'd like to make that a separate change from this patch though, as we're
> > already changing quite a bit with this series, so I'm trying to make any
> > logical change as contained per patch as possible, so that problems can
> > be spotted by bisecting.
> 
> Yes, I think that's wise.
> 

ok, I'll try to incorporate this as a separate patch for the next
revision.

> > > Ultimately I'd like to go one better and actually treat a vcpu as a
> > > first-class fpsimd context, so that taking an interrupt to the host
> > > and then reentering the guest doesn't cause any reload at all.  
> > 
> > That should be the case already; kvm_vcpu_put_sysregs() is only called
> > when you run another thread (preemptively or voluntarily), or when you
> > return to user space, but making the vcpu fpsimd context a first-class
> > citizen fpsimd context would mean that you can run another thread (and
> > maybe run userspace if it doesn't use fpsimd?) without having to
> > save/restore anything.  Am I getting this right?
> 
> Yes (except that if a return to userspace happens then FPSIMD will be
> restored at that point: there is no laziness there -- it _could_
> be lazy, but it's deemed unlikely to be a performance win due to the
> fact that the compiler can and does generate FPSIMD code quite
> liberally by default).
> 
> For the case of being preempted within the kernel with no ret_to_user,
> you are correct.
> 

ok, that would indeed also be useful for things like switching to a
vhost thread and returning to the vcpu thread.

> > 
> > > But
> > > that feels like too big a step for this series, and there are likely
> > > side-issues I've not thought about yet.
> > > 
> > 
> > It should definitely be in separate patches, but I would be optn to
> > tagging something on to the end of this series if we can stabilize this
> > series early after -rc1 is out.
> 
> I haven't fully got my head around it, but we can see where we get to.
> Best not to rush into it if there's any doubt...
> 
Agreed, we can always add things later.

Thanks,
-Christoffer
