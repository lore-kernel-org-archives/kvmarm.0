From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: initialize new VGIC even without host GIC
Date: Fri, 5 Aug 2016 11:34:51 +0200
Message-ID: <20160805093451.GA12269@lvm>
References: <20160802143445.14005-1-andre.przywara@arm.com>
 <20160804112450.GC8211@lvm>
 <dda85147-d7a9-73b2-15bb-8de53782d1af@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dda85147-d7a9-73b2-15bb-8de53782d1af@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Stefan Agner <stefan@agner.ch>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Aug 04, 2016 at 01:51:37PM +0100, Andre Przywara wrote:
> Hi,
> 
> On 04/08/16 12:24, Christoffer Dall wrote:
> > On Tue, Aug 02, 2016 at 03:34:45PM +0100, Andre Przywara wrote:
> >> The new VGIC code is always in the VCPU entry/exit path, even when the
> >> actual GIC hardware initialization found the VGIC unusable (due to
> >> non-aligned base addresses or a missing maintenance interrupt, for
> >> instance).
> >> Since in this case the VGIC structures aren't initialized properly, the
> >> host kernel crashes on a NULL pointer dereference.
> >> Initialize each VCPU's ap_list even with the VGIC unavailable, so the
> >> VGIC code now just iterates an empty list in that case and no longer
> >> crashes the kernel.
> >> Also take care of the arch timer (which becomes unusable as well without
> >> a VGIC) by using a static key to prevent arch timer code to run in the
> >> hot path.
> >> Much of the code was inspired by Marc Zyngier.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> Reported-by: Stefan Agner <stefan@agner.ch>
> >> ---
> >> Hi Stefan, Drew,
> >>
> >> can you test this on your systems which showed the issue?
> >>
> >> Cheers,
> >> Andre.
> >>
> >>  arch/arm/kvm/arm.c            | 14 ++++++++++----
> >>  include/kvm/arm_arch_timer.h  |  2 ++
> >>  virt/kvm/arm/arch_timer.c     | 11 +++++++++++
> >>  virt/kvm/arm/vgic/vgic-init.c |  9 ++++-----
> >>  4 files changed, 27 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >> index f1bde7c..cef35ce 100644
> >> --- a/arch/arm/kvm/arm.c
> >> +++ b/arch/arm/kvm/arm.c
> >> @@ -294,7 +294,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> >>  	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> >>  
> >>  	/* Set up the timer */
> >> -	kvm_timer_vcpu_init(vcpu);
> >> +	if (vgic_present)
> >> +		kvm_timer_vcpu_init(vcpu);
> >>  
> >>  	kvm_arm_reset_debug_ptr(vcpu);
> >>  
> >> @@ -1208,6 +1209,7 @@ static int init_subsystems(void)
> >>  		break;
> >>  	case -ENODEV:
> >>  	case -ENXIO:
> >> +		kvm_err("No useable vgic detected\n");
> >>  		vgic_present = false;
> >>  		err = 0;
> >>  		break;
> >> @@ -1218,9 +1220,13 @@ static int init_subsystems(void)
> >>  	/*
> >>  	 * Init HYP architected timer support
> >>  	 */
> >> -	err = kvm_timer_hyp_init();
> >> -	if (err)
> >> -		goto out;
> >> +	if (vgic_present) {
> >> +		err = kvm_timer_hyp_init();
> >> +		if (err)
> >> +			goto out;
> >> +	} else {
> >> +		static_branch_enable(&kvm_arch_timer_disabled);
> >> +	}
> >>  
> >>  	kvm_perf_init();
> >>  	kvm_coproc_table_init();
> >> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> >> index dda39d8..64f361f 100644
> >> --- a/include/kvm/arm_arch_timer.h
> >> +++ b/include/kvm/arm_arch_timer.h
> >> @@ -23,6 +23,8 @@
> >>  #include <linux/hrtimer.h>
> >>  #include <linux/workqueue.h>
> >>  
> >> +extern struct static_key_false kvm_arch_timer_disabled;
> >> +
> >>  struct arch_timer_kvm {
> >>  	/* Virtual offset */
> >>  	cycle_t			cntvoff;
> >> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> >> index 4fde8c7..71fb04c 100644
> >> --- a/virt/kvm/arm/arch_timer.c
> >> +++ b/virt/kvm/arm/arch_timer.c
> >> @@ -34,6 +34,8 @@ static struct timecounter *timecounter;
> >>  static struct workqueue_struct *wqueue;
> >>  static unsigned int host_vtimer_irq;
> >>  
> >> +DEFINE_STATIC_KEY_FALSE(kvm_arch_timer_disabled);
> >> +
> >>  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
> >>  {
> >>  	vcpu->arch.timer_cpu.active_cleared_last = false;
> >> @@ -41,6 +43,9 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
> >>  
> >>  static cycle_t kvm_phys_timer_read(void)
> >>  {
> >> +	if (static_branch_unlikely(&kvm_arch_timer_disabled))
> >> +		return 0;
> >> +
> >>  	return timecounter->cc->read(timecounter->cc);
> >>  }
> >>  
> >> @@ -104,6 +109,9 @@ static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu)
> >>  {
> >>  	cycle_t cval, now;
> >>  
> >> +	if (static_branch_unlikely(&kvm_arch_timer_disabled))
> >> +		return 0;
> >> +
> >>  	cval = vcpu->arch.timer_cpu.cntv_cval;
> >>  	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
> >>  
> >> @@ -148,6 +156,9 @@ static bool kvm_timer_irq_can_fire(struct kvm_vcpu *vcpu)
> >>  {
> >>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >>  
> >> +	if (static_branch_unlikely(&kvm_arch_timer_disabled))
> >> +		return false;
> >> +
> >>  	return !(timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
> >>  		(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE);
> >>  }
> > 
> > why do we have these hooks fairly deep into the arch timer static
> > functions?
> > 
> > I would think that it makes more sense to catch stuff in the early entry
> > points to the timer logic, which would be:
> > 
> >   kvm_timer_should_fire
> >   kvm_timer_schedule
> >   kvm_timer_unschedule
> >   kvm_arm_timer_set_reg
> >   kvm_arm_timer_get_reg
> > 
> > Also, most of these don't seem to be in a general critical path, so I'm
> > not really sure why we're using static branches here?
> 
> To be honest I am not of fan of those sprinkled static branches either.
> They should be fairly cheap, though, as they are a NOP normally and
> AFAICS we need at least one anyway, so adding some more users didn't
> seem overly problematic to me.
> In a previous version I got along without most of those, by just letting
> timecounter always point to something legal, thus avoiding all but one
> explicit "vgic/arch_timer enabled" check at all.
> I fixed this up after some comments from Marc, but agree that now it's
> not nice.
> 
> But see below for a possible better solution.
> 
> >> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> >> index 2c7f0d5..b92133c 100644
> >> --- a/virt/kvm/arm/vgic/vgic-init.c
> >> +++ b/virt/kvm/arm/vgic/vgic-init.c
> >> @@ -56,6 +56,10 @@ void kvm_vgic_early_init(struct kvm *kvm)
> >>  
> >>  void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu)
> >>  {
> >> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> >> +
> >> +	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
> >> +	spin_lock_init(&vgic_cpu->ap_list_lock);
> >>  }
> > 
> > there are two pieces of comments above that needs to be tweaked now (or
> > just remove the remaining function and comment)
> 
> TBH hooking into here was an easy solution, which I chose to allow
> fixing this easily, for instance for a 4.7 stable fix.
> 
> Somehow I feel this is an abuse and we can find another solution.
> What about explicit "disable arch timer/vgic" function(s), which could
> set this list and spin_lock up, also make sure timecounter in
> arch_timer.c points to something and toggle the static branch.
> Then we would use something like:
> 	if (vgic_present)
> 		kvm_timer_hyp_init();
> 	else
> 		kvm_disable_arch_timer();
> 
> and similar for the VGIC.
> 
> Does that sound useful or are we going totally off the tracks with this?
> 

I think this general approach sounds useful.  It depends a bit on how
the overall code ends up looking like, but right now, with this patch,
you have to wade through several functions in both the timer and the
vgic to convince yourself that when either is disabled, we do the right
thing.

> >>  
> >>  /* CREATION */
> >> @@ -392,11 +396,6 @@ int kvm_vgic_hyp_init(void)
> >>  	if (!gic_kvm_info)
> >>  		return -ENODEV;
> >>  
> >> -	if (!gic_kvm_info->maint_irq) {
> >> -		kvm_err("No vgic maintenance irq\n");
> >> -		return -ENXIO;
> >> -	}
> >> -
> > 
> > I don't understand why we can remove this chunk?
> 
> This was in Marc's version of the fix originally and I didn't dare to
> question this ;-)
> Originally I was under the impression that we are reporting this
> condition in the host GIC driver already, but checking back this doesn't
> seem to be the case. In fact we just seem to report the unusable VGIC,
> without any further rationale.
> 
> So if Marc agrees, should we remove this hunk and keep the message?
> 
I need someone to explain me why a maintenance IRQ of zero is not a
problem and/or why we don't need to check for it.

-Christoffer
