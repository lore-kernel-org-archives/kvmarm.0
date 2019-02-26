From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 1/5] KVM: arm/arm64: Reset the VCPU without preemption
 and vcpu state loaded
Date: Tue, 26 Feb 2019 13:53:52 +0000
Message-ID: <20190226135352.GX3567@e103592.cambridge.arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-2-christoffer.dall@arm.com>
 <20190220191450.GT3567@e103592.cambridge.arm.com>
 <20190220194143.2e1a7d2c@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A134A36D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 08:53:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l0uTqij5W1g8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 08:53:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14D0A4A2BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 08:53:57 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190220194143.2e1a7d2c@why.wild-wind.fr.eu.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 20, 2019 at 07:41:43PM +0000, Marc Zyngier wrote:
> On Wed, 20 Feb 2019 19:14:53 +0000
> Dave Martin <Dave.Martin@arm.com> wrote:
> 
> > On Fri, Jan 25, 2019 at 10:46:52AM +0100, Christoffer Dall wrote:
> > > Resetting the VCPU state modifies the system register state in memory,
> > > but this may interact with vcpu_load/vcpu_put if running with preemption
> > > disabled, which in turn may lead to corrupted system register state.  
> > 
> > Should this be "enabled"?
> 
> Yup. Never mind. The patches are firmly in mainline now.

Understood.  Just wanted to check my intuition.

> > 
> > Too late now, but I want to make sure I understand this right for
> > patches that will go on top.
> > 
> > > Address this by disabling preemption and doing put/load if required
> > > around the reset logic.
> > > 
> > > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> > > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > > ---
> > >  arch/arm64/kvm/reset.c | 26 ++++++++++++++++++++++++--
> > >  1 file changed, 24 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > > index b72a3dd56204..f21a2a575939 100644
> > > --- a/arch/arm64/kvm/reset.c
> > > +++ b/arch/arm64/kvm/reset.c
> > > @@ -105,16 +105,33 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> > >   * This function finds the right table above and sets the registers on
> > >   * the virtual CPU struct to their architecturally defined reset
> > >   * values.
> > > + *
> > > + * Note: This function can be called from two paths: The KVM_ARM_VCPU_INIT
> > > + * ioctl or as part of handling a request issued by another VCPU in the PSCI
> > > + * handling code.  In the first case, the VCPU will not be loaded, and in the
> > > + * second case the VCPU will be loaded.  Because this function operates purely
> > > + * on the memory-backed valus of system registers, we want to do a full put if
> > > + * we were loaded (handling a request) and load the values back at the end of
> > > + * the function.  Otherwise we leave the state alone.  In both cases, we
> > > + * disable preemption around the vcpu reset as we would otherwise race with
> > > + * preempt notifiers which also call put/load.
> > >   */
> > >  int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> > >  {
> > >  	const struct kvm_regs *cpu_reset;
> > > +	int ret = -EINVAL;
> > > +	bool loaded;
> > > +
> > > +	preempt_disable();
> > > +	loaded = (vcpu->cpu != -1);
> > > +	if (loaded)
> > > +		kvm_arch_vcpu_put(vcpu);
> > >  
> > >  	switch (vcpu->arch.target) {
> > >  	default:
> > >  		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
> > >  			if (!cpu_has_32bit_el1())
> > > -				return -EINVAL;
> > > +				goto out;
> > >  			cpu_reset = &default_regs_reset32;
> > >  		} else {
> > >  			cpu_reset = &default_regs_reset;
> > > @@ -137,7 +154,12 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> > >  		vcpu->arch.workaround_flags |= VCPU_WORKAROUND_2_FLAG;
> > >  
> > >  	/* Reset timer */
> > > -	return kvm_timer_vcpu_reset(vcpu);
> > > +	ret = kvm_timer_vcpu_reset(vcpu);
> > > +out:
> > > +	if (loaded)
> > > +		kvm_arch_vcpu_load(vcpu, smp_processor_id());
> > > +	preempt_enable();
> > > +	return ret;
> > >  }
> > >  
> > >  void kvm_set_ipa_limit(void)  
> > 
> > I was really confused by this: as far as I can see, we don't really need
> > to disable preemption here once kvm_arch_vcpu_put() is complete -- at
> > least not for the purpose of avoiding corruption of the reg state.  But
> > we _do_ need to disable the preempt notifier so that it doesn't fire
> > before we are ready.
> 
> Just reading this patch alone won't help. You need to read it in
> conjunction with the following patch, which resets the vcpu from a
> preemptible section.
> 
> > It actually seems a bit surprising for a powered-off CPU to sit with the
> > VM regs live and preempt notifier armed, when the vcpu thread is
> > heading to interruptible sleep anyway until someone turns it on.
> 
> All it takes is a signal for that vcpu to wake up, power-off or not.

Sure, but the vcpu was scheduled out in the meantim, so we may end up
having to do all the loading twice:  not a problem, because this is a
rare, slow path.  But I wanted to make sure I wasn't more confused than
necessary.

> > Perhaps an alternative approach would be to nobble the preempt notifier
> > and stick an explicit vcpu_put()...vcpu_load() around the
> > swait_event_interruptible_exclusive() call in vcpu_req_sleep().  This
> > is not fast path.
> 
> What does it buy us? The problem we're solving here is a powered-off,
> spuriously woken-up vcpu racing against the reset performed from
> another vcpu. I don't see what adding more put/load would solve.

Not a lot.  Changes in this area would allow some code to move outside
preempt_disable(), but only at the expense of extra cost elsewhere...

> > Any, with the code as-is, it looks like the SVE regs resetting should
> > go in the preempt_disable() region, after the kvm_arch_vcpu_put() call.
> 
> All resets must go there. This is the only safe location.

OK, that's what I wanted to be sure of.

> > Does it sound like I've understood that right?
> 
> I'm not sure. Your analysis of what we're trying to achieve with this
> series seems a bit off. Or I'm completely misunderstanding what you're
> suggesting, which is the most likely explanation.

I'm not trying to achieve anything except rebase the SVE series
correctly on top of this patch (which I've now done -- thanks for
your confirmation above of where the extra resetting should go).

My suggestions above were only intended as thought experiments to check
my understanding of what's going on, *not* proposals for changing the
code.  I guess I didn't make that very clear.

[...]

Cheers
---Dave
