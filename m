From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 09/41] KVM: arm64: Defer restoring host VFP state to
 vcpu_put
Date: Thu, 15 Feb 2018 09:51:26 +0000
Message-ID: <20180215095114.GA11612@e103592.cambridge.arm.com>
References: <20180122173326.GO22781@e103592.cambridge.arm.com>
 <20180125194653.GR21802@cbox>
 <20180207164955.GT5862@e103592.cambridge.arm.com>
 <20180207175644.GF29286@cbox>
 <20180209155930.GD5862@e103592.cambridge.arm.com>
 <20180213085130.GB23189@cbox>
 <20180213140843.GN5862@e103592.cambridge.arm.com>
 <20180214101554.GL23189@cbox>
 <20180214144242.GA11748@e103592.cambridge.arm.com>
 <20180214173811.GO23189@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180214173811.GO23189@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 14, 2018 at 06:38:11PM +0100, Christoffer Dall wrote:
> On Wed, Feb 14, 2018 at 02:43:42PM +0000, Dave Martin wrote:
> > [CC Ard, in case he has a view on how much we care about softirq NEON
> > performance regressions ... and whether my suggestions make sense]
> > 
> > On Wed, Feb 14, 2018 at 11:15:54AM +0100, Christoffer Dall wrote:
> > > On Tue, Feb 13, 2018 at 02:08:47PM +0000, Dave Martin wrote:
> > > > On Tue, Feb 13, 2018 at 09:51:30AM +0100, Christoffer Dall wrote:
> > > > > On Fri, Feb 09, 2018 at 03:59:30PM +0000, Dave Martin wrote:
> 
> [...]
> 
> > > > 
> > > > kvm_fpsimd_flush_cpu_state() is just an invalidation.  No state is
> > > > actually saved today because we explicitly don't care about preserving
> > > > the SVE state, because the syscall ABI throws the SVE regs away as
> > > > a side effect any syscall including ioctl(KVM_RUN); also (currently) KVM
> > > > ensures that the non-SVE FPSIMD bits _are_ restored by itself.
> > > > 
> > > > I think my proposal is that this hook might take on the role of
> > > > actually saving the state too, if we move that out of the KVM host
> > > > context save/restore code.
> > > > 
> > > > Perhaps we could even replace
> > > > 
> > > > 	preempt_disable();
> > > > 	kvm_fpsimd_flush_cpu_state();
> > > > 	/* ... */
> > > > 	preempt_enable();
> > > > 
> > > > with
> > > > 
> > > > 	kernel_neon_begin();
> > > > 	/* ... */
> > > > 	kernel_neon_end();
> > > 
> > > I'm not entirely sure where the begin and end points would be in the
> > > context of KVM?
> > 
> > Hmmm, actually there's a bug in your VHE changes now I look more
> > closely in this area:
> > 
> > You assume that the only way for the FPSIMD regs to get unexpectedly
> > dirtied is through a context switch, but actually this is not the case:
> > a softirq can use kernel-mode NEON any time that softirqs are enabled.
> > 
> > This means that in between kvm_arch_vcpu_load() and _put() (whether via
> > preempt notification or not), the guest's FPSIMD state in the regs may
> > be trashed by a softirq.
> 
> ouch.
> 
> > 
> > The simplest fix is to disable softirqs and preemption for that whole
> > region, but since we can stay in it indefinitely that's obviously not
> > the right approach.  Putting kernel_neon_begin() in _load() and
> > kernel_neon_end() in _put() achieves the same without disabling
> > softirq, but preemption is still disabled throughout, which is bad.
> > This effectively makes the run ioctl nonpreemptible...
> > 
> > A better fix would be to set the cpu's kernel_neon_busy flag, which
> > makes softirq code use non-NEON fallback code.
> > 
> > We could expose an interface from fpsimd.c to support that.
> > 
> > It still comes at a cost though: due to the switching from NEON to
> > fallback code in softirq handlers, we may get a big performance
> > regression in setups that rely heavily on NEON in softirq for
> > performance.
> > 
> 
> I wasn't aware that softirqs would use fpsimd.
> 
> > 
> > Alternatively we could do something like the following, but it's a
> > rather gross abstraction violation:
> > 
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 2e43f9d..6a1ff3a 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -746,9 +746,24 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		 * the effect of taking the interrupt again, in SVC
> >  		 * mode this time.
> >  		 */
> > +		local_bh_disable();
> >  		local_irq_enable();
> >  
> >  		/*
> > +		 * If we exited due to one or mode pending interrupts, they
> > +		 * have now been handled.  If such an interrupt pended a
> > +		 * softirq, we shouldn't prevent that softirq from using
> > +		 * kernel-mode NEON indefinitely: instead, give FPSIMD back to
> > +		 * the host to manage as it likes.  We'll grab it again on the
> > +		 * next FPSIMD trap from the guest (if any).
> > +		 */
> > +		if (local_softirq_pending() && FPSIMD untrapped for guest) {
> > +			/* save vcpu FPSIMD context */
> > +			/* enable FPSIMD trap for guest */
> > +		}
> > +		local_bh_enable();
> > +
> > +		/*
> >  		 * We do local_irq_enable() before calling guest_exit() so
> >  		 * that if a timer interrupt hits while running the guest we
> >  		 * account that tick as being spent in the guest.  We enable
> > 
> > [...]
> > 
> 
> I can't see this working, what if an IRQ comes in and a softirq gets
> pending immediately after local_bh_enable() above?

Sorry, I missed a crucial bit of information here.

For context: here's the remainder of my argument.  This is not a
recommendation...


--8<--

We can inhibit softirqs from trashing the FPSIMD regs by setting the
per-cpu kernel_neon_busy flag: that's forces softirq code to use
non-NEON fallback code without actually disabling softirq.

I'd come up with a local hack

 * kernel_neon_grab();

	to set the flag, which would happen in vcpu_load().

 * kernel_neon_ungrab();

	to clear the flag, which would happen as above and in
	vcpu_put().

It would be up to the caller to ensure that preemption cannot occur
between those calls (satisfied by use of a preempt notifier here), and
to save the host context when needed.

This would bound the kernel-mode NEON blackout to the time KVM spends
in the host kernel only: the above conditional relinquishing of the
FPSIMD regs ensures that a softirq trigger event occuring during the
(unbounded) guest execution time _does_ get to use NEON.

-->8--

> And as you say, it's really not pretty.

Agreed!

> This is really making me think that I'll drop this part of the
> optimization and when we do optimize fpsimd handling, we do it properly
> by integrating it with the kernel tracking.

Since I will be hacking at this area as part of the SVE KVM support
anyway, I will sooner or later end up working on it -- at that point it
will likely be worth unifying the two mechanisms, at least for the VHE
case (SVE architecturally required v8.2, so VHE can be assumed in that
case).

It would be interesting to know what the numbers look like without
the FPSIMD optimisation.

Cheers
---Dave
