From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v6 7/8] KVM: arm/arm64: Provide a get_input_level for the
 arch timer
Date: Wed, 6 Dec 2017 17:17:28 +0300
Message-ID: <20171206141728.mmjp6x4ksyhdvjmv@yury-thinkpad>
References: <20171204200506.3224-1-cdall@kernel.org>
 <20171204200506.3224-8-cdall@kernel.org>
 <20171205152446.rcmkowdnuhkqbrdb@yury-thinkpad>
 <20171206105904.GM32397@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171206105904.GM32397@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Christoffer Dall <cdall@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 06, 2017 at 11:59:04AM +0100, Christoffer Dall wrote:
> On Tue, Dec 05, 2017 at 06:24:46PM +0300, Yury Norov wrote:
> > On Mon, Dec 04, 2017 at 09:05:05PM +0100, Christoffer Dall wrote:
> > > From: Christoffer Dall <christoffer.dall@linaro.org>
> > > 
> > > The VGIC can now support the life-cycle of mapped level-triggered
> > > interrupts, and we no longer have to read back the timer state on every
> > > exit from the VM if we had an asserted timer interrupt signal, because
> > > the VGIC already knows if we hit the unlikely case where the guest
> > > disables the timer without ACKing the virtual timer interrupt.
> > > 
> > > This means we rework a bit of the code to factor out the functionality
> > > to snapshot the timer state from vtimer_save_state(), and we can reuse
> > > this functionality in the sync path when we have an irqchip in
> > > userspace, and also to support our implementation of the
> > > get_input_level() function for the timer.
> > > 
> > > This change also means that we can no longer rely on the timer's view of
> > > the interrupt line to set the active state, because we no longer
> > > maintain this state for mapped interrupts when exiting from the guest.
> > > Instead, we only set the active state if the virtual interrupt is
> > > active, and otherwise we simply let the timer fire again and raise the
> > > virtual interrupt from the ISR.
> > > 
> > > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > > ---
> > >  include/kvm/arm_arch_timer.h |  2 ++
> > >  virt/kvm/arm/arch_timer.c    | 75 +++++++++++++++++++++-----------------------
> > >  2 files changed, 38 insertions(+), 39 deletions(-)
> > > 
> > > diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> > > index 01ee473517e2..f57f795d704c 100644
> > > --- a/include/kvm/arm_arch_timer.h
> > > +++ b/include/kvm/arm_arch_timer.h
> > > @@ -90,6 +90,8 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
> > >  
> > >  void kvm_timer_init_vhe(void);
> > >  
> > > +bool kvm_arch_timer_get_input_level(int vintid);
> > > +
> > >  #define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.vtimer)
> > >  #define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.ptimer)
> > >  
> > 
> > [...]
> > 
> > > +bool kvm_arch_timer_get_input_level(int vintid)
> > > +{
> > > +	struct kvm_vcpu *vcpu = kvm_arm_get_running_vcpu();
> > > +	struct arch_timer_context *timer;
> > > +
> > > +	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
> > > +		timer = vcpu_vtimer(vcpu);
> > > +	else
> > > +		BUG() We only map the vtimer so far */
> > > +
> > > +	if (timer->loaded)
> > > +		__timer_snapshot_state(timer);
> > > +
> > > +	return kvm_timer_should_fire(timer);
> > > +}
> > 
> > I think it worth to reword to highlight your intention about BUG,
> > and save 1 call to vcpu_vtimer()
> > 
> > bool kvm_arch_timer_get_input_level(int vintid)
> > {
> > 	struct kvm_vcpu *vcpu = kvm_arm_get_running_vcpu();
> > 	struct arch_timer_context *timer = vcpu_vtimer(vcpu);
> > 
> >         /* We only map the vtimer so far */
> > 	BUG_ON(vintid != timer->irq.irq)
> > 
> > 	if (timer->loaded)
> > 		__timer_snapshot_state(timer);
> > 
> > 	return kvm_timer_should_fire(timer);
> > }
> > 
> 
> Besides the incredible bikesheding nature of your comments, I disagree.
> The current code suggests where to add functionality once we move to
> using the physical timer hardware to drive an EL1 physical timer on VHE
> systems, and is purposely written this way.
> 
> I'm sure we have real bugs and real issues in the code, perhaps you
> could spend your energy looking for those, and if you cannot find any,
> then provide a reviewed-by instead of these pointless cosmetic
> adjustments.

OK. I understood. Let me elaborate.

0. As you say in patch 0, This series is based on 4.15-rc, so I decided that
the code above is assumed to be release version. You may change it in
future, or may not, but the code will exist as is in mainline kernel for
some time, right?

1. BUG() is needed to kill system, and it really kills it. This is wrong
to kill system in else-branch of some minor helper due to unimplemented
feature. You should use pr_err() or WARN_ON() instead. The best - return
reasonable error and do everything possible on upper levels to keep system
alive. What's really wrong in my comment is that I didn't suggest you switch
to WARN_ON().

Did you follow this thread?
https://lkml.org/lkml/2016/10/4/1

2. Calling the same function with the same argument twice in code path is
also an issue. Besides the nasty feeling of that code, it might be dangerous.
The most obvious scenario is when it returns different values due to change
of internal state. I realize that vcpu_vtimer() is just a pointer dereference.
But it may bite you painfully as well. I know it for sure because it bitten
me once. Consider racing scenario in this patch:
https://patchwork.kernel.org/patch/9974327/

It may never become the problem, or may become one day. But fix is
clear and obvious - why not taking it?

3. I will be really happy to provide tested-by and reviewed-by. But
for doing that I need to actually test and review. It would be extremely
helpful if you share your testing modules and scripts. I have access
to several Cavium machines and can do before/after measurements. Right
now I have few tests, but kvm is very complex system, and I'm not sure I
measure what I'm actually going to. Guidance from KVM experts is what
really lacks. 

Thanks,
Yury
