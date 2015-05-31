From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] arm/arm64: KVM: Properly account for guest CPU time
Date: Sun, 31 May 2015 08:59:23 +0200
Message-ID: <20150531065923.GB763@cbox>
References: <1432838950-28774-1-git-send-email-christoffer.dall@linaro.org>
 <5568E987.5010702@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5568E987.5010702@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, borntraeger@de.ibm.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mario,

On Fri, May 29, 2015 at 03:34:47PM -0700, Mario Smarduch wrote:
> On 05/28/2015 11:49 AM, Christoffer Dall wrote:
> > Until now we have been calling kvm_guest_exit after re-enabling
> > interrupts when we come back from the guest, but this has the
> > unfortunate effect that CPU time accounting done in the context of timer
> > interrupts occurring while the guest is running doesn't properly notice
> > that the time since the last tick was spent in the guest.
> > 
> > Inspired by the comment in the x86 code, move the kvm_guest_exit() call
> > below the local_irq_enable() call and change __kvm_guest_exit() to
> > kvm_guest_exit(), because we are now calling this function with
> > interrupts enabled.  We have to now explicitly disable preemption and
> > not enable preemption before we've called kvm_guest_exit(), since
> > otherwise we could be preempted and everything happening before we
> > eventually get scheduled again would be accounted for as guest time.
> > 
> > At the same time, move the trace_kvm_exit() call outside of the atomic
> > section, since there is no reason for us to do that with interrupts
> > disabled.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> > This patch is based on kvm/queue, because it has the kvm_guest_enter/exit
> > rework recently posted by Christian Borntraeger.  I hope I got the logic
> > of this right, there were 2 slightly worrying facts about this:
> > 
> > First, we now enable and disable and enable interrupts on each exit
> > path, but I couldn't see any performance overhead on hackbench - yes the
> > only benchmark we care about.
> > 
> > Second, looking at the ppc and mips code, they seem to also call
> > kvm_guest_exit() before enabling interrupts, so I don't understand how
> > guest CPU time accounting works on those architectures.
> > 
> > Changes since v1:
> >  - Tweak comment and commit text based on Marc's feedback.
> >  - Explicitly disable preemption and enable it only after kvm_guest_exit().
> > 
> >  arch/arm/kvm/arm.c | 21 +++++++++++++++++----
> >  1 file changed, 17 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> > index e41cb11..fe8028d 100644
> > --- a/arch/arm/kvm/arm.c
> > +++ b/arch/arm/kvm/arm.c
> > @@ -532,6 +532,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		kvm_vgic_flush_hwstate(vcpu);
> >  		kvm_timer_flush_hwstate(vcpu);
> >  
> > +		preempt_disable();
> >  		local_irq_disable();
> >  
> >  		/*
> > @@ -544,6 +545,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  
> >  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
> >  			local_irq_enable();
> > +			preempt_enable();
> >  			kvm_timer_sync_hwstate(vcpu);
> >  			kvm_vgic_sync_hwstate(vcpu);
> >  			continue;
> > @@ -559,8 +561,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
> >  
> >  		vcpu->mode = OUTSIDE_GUEST_MODE;
> > -		__kvm_guest_exit();
> > -		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> > +		/*
> > +		 * Back from guest
> > +		 *************************************************************/
> > +
> >  		/*
> >  		 * We may have taken a host interrupt in HYP mode (ie
> >  		 * while executing the guest). This interrupt is still
> > @@ -574,8 +578,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		local_irq_enable();
> >  
> >  		/*
> > -		 * Back from guest
> > -		 *************************************************************/
> > +		 * We do local_irq_enable() before calling kvm_guest_exit() so
> > +		 * that if a timer interrupt hits while running the guest we
> > +		 * account that tick as being spent in the guest.  We enable
> > +		 * preemption after calling kvm_guest_exit() so that if we get
> > +		 * preempted we make sure ticks after that is not counted as
> > +		 * guest time.
> > +		 */
> > +		kvm_guest_exit();
> > +		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> > +		preempt_enable();
> > +
> >  
> >  		kvm_timer_sync_hwstate(vcpu);
> >  		kvm_vgic_sync_hwstate(vcpu);
> > 
> 
> Hi Christoffer,
>  so currently we take a snap shot when we enter the guest
> (tsk->vtime_snap) and upon exit add the time we spent in
> the guest and update accrued time, which appears correct.

not on arm64, because we don't select HAVE_VIRT_CPU_ACCOUNTING_GEN.  Or
am I missing something obvious here?

> 
> With this patch it appears that interrupts running
> in host mode are accrued to Guest time, and additional preemption
> latency is added.
> 
It is true that interrupt processing in host mode (if they hit on a CPU
when it is running a guest) are accrued to guest time, but without this
patch on current arm64 we accrue no CPU time to guest time at all, which
is hardly more correct.

If this patch is incorrect, then how does it work on x86, where
handle_external_intr() is called (with a barrier in between) before
kvm_guest_exit(), and where handle_external_intr() is simply
local_irq_enable() on SVM and something more complicated on VMX ?

Finally, how exactly is preemption latency added here?  Won't IRQ
processing run with higher priority than any task on your system, so the
order of (1) process pending IRQs (2) call schedule if needed is still
preserved here, but we call kvm_guest_exit() between (1) and (2) instead
of before (1).

It is entirely possible that I'm missing the mark here and everything
gets solved by enabling HAVE_VIRT_CPU_ACCOUNTING_GEN or we need some
extra logic?

Thanks,
-Christoffer
