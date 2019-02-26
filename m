From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 1/5] KVM: arm/arm64: Reset the VCPU without preemption
 and vcpu state loaded
Date: Tue, 26 Feb 2019 14:00:55 +0000
Message-ID: <20190226140055.GY3567@e103592.cambridge.arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-2-christoffer.dall@arm.com>
 <20190220191450.GT3567@e103592.cambridge.arm.com>
 <20190226123449.GA551@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190226123449.GA551@e113682-lin.lund.arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 26, 2019 at 01:34:49PM +0100, Christoffer Dall wrote:
> On Wed, Feb 20, 2019 at 07:14:53PM +0000, Dave Martin wrote:
> > On Fri, Jan 25, 2019 at 10:46:52AM +0100, Christoffer Dall wrote:
> > > Resetting the VCPU state modifies the system register state in memory,
> > > but this may interact with vcpu_load/vcpu_put if running with preemption
> > > disabled, which in turn may lead to corrupted system register state.
> > 
> > Should this be "enabled"?
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
> > 
> > It actually seems a bit surprising for a powered-off CPU to sit with the
> > VM regs live and preempt notifier armed, when the vcpu thread is
> > heading to interruptible sleep anyway until someone turns it on.
> > Perhaps an alternative approach would be to nobble the preempt notifier
> > and stick an explicit vcpu_put()...vcpu_load() around the
> > swait_event_interruptible_exclusive() call in vcpu_req_sleep().  This
> > is not fast path.
> > 
> > 
> 
> I think you've understood the problem correctly, and the thing here is
> that we (sort-of) "abuse" disabling preemption as a way to disable
> preempt notifiers, which I don't think we have.  So we could add that,
> and do something like:
> 
>   preempt_disable();
>   vcpu_put(vcpu);
>   disable_preempt_notifiers(vcpu);
>   preempt_disable();
>   funky_stuff();
>   vcpu_load();
>   preempt_enable();

Did you mean

	preempt_disable();
	disable_preempt_notifiers(vcpu);
	vcpu_put(vcpu);
	preempt_enable();

	funky_stuff();

	preempt_disable();
	vcpu_load(vcpu);
	enable_preempt_notifiers(vcpu);
	preempt_enable();

> But I think that's additional complexity to get a slightly shorter
> section with disabled preemption.

Agreed.

disable/enable_preempt_notifiers() may do little more than toggle a flag
that the preempt notifiers check, but I totally agree that it's unlikely
to be worth it just to be preemptible in this small region.

> We could also re-architect a lot of the vcpu_load/vpcu_put functionality
> more drastically, but that is difficult and requires understanding of
> how the other architectures work, so at the end of the day we just use
> this pattern in multiple places, which is:
> 
>   preempt_disable();
>   vcpu_put();

We still have the anomaly that we save all the state we're about to
reset here.

(i.e., we have no pure "invalidate" operation for the loaded CPU regs;
vcpu_put() is more "clean and invalidate", but we may not care much
about the "clean" part in this particular sequence).

Again, this only makes a difference to a rare slow path, so I don't
see it as a problem.

>   modify_vcpu_state_in_memory();
>   vcpu_load();
>   preempt_enable();
> 
> Does that help?

Yes, I think I've understood correctly what's going on here now.

The code is fine as it is.

Cheers
---Dave
