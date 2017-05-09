From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 07/10] KVM: arm/arm64: optimize VCPU RUN
Date: Tue, 9 May 2017 19:40:57 +0200
Message-ID: <20170509174057.kzjomkgxieqzlzag@kamzik.brq.redhat.com>
References: <20170503160635.21669-1-drjones@redhat.com>
 <20170503160635.21669-8-drjones@redhat.com>
 <20170506182715.GD5923@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170506182715.GD5923@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, May 06, 2017 at 08:27:15PM +0200, Christoffer Dall wrote:
> On Wed, May 03, 2017 at 06:06:32PM +0200, Andrew Jones wrote:
> 
> nit: can you make the subject of this patch a bit more specific?
> 
> For example:  Optimize checking power_off flag in KVM_RUN

OK

> 
> > We can make a small optimization by not checking the state of
> > the power_off field on each run. This is done by treating
> > power_off like pause, only checking it when we get the EXIT
> > VCPU request. When a VCPU powers off another VCPU the EXIT
> > request is already made, so we just need to make sure the
> > request is also made on self power off. kvm_vcpu_kick() isn't
> > necessary for these cases, as the VCPU would just be kicking
> > itself, but we add it anyway as a self kick doesn't cost much,
> > and it makes the code more future-proof.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm/kvm/arm.c  | 16 ++++++++++------
> >  arch/arm/kvm/psci.c |  2 ++
> >  2 files changed, 12 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> > index 26d9d4d72853..24bbc7671d89 100644
> > --- a/arch/arm/kvm/arm.c
> > +++ b/arch/arm/kvm/arm.c
> > @@ -371,6 +371,13 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  	kvm_timer_vcpu_put(vcpu);
> >  }
> >  
> > +static void vcpu_power_off(struct kvm_vcpu *vcpu)
> > +{
> > +	vcpu->arch.power_off = true;
> > +	kvm_make_request(KVM_REQ_VCPU_EXIT, vcpu);
> > +	kvm_vcpu_kick(vcpu);
> > +}
> > +
> >  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
> >  				    struct kvm_mp_state *mp_state)
> >  {
> > @@ -390,7 +397,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >  		vcpu->arch.power_off = false;
> >  		break;
> >  	case KVM_MP_STATE_STOPPED:
> > -		vcpu->arch.power_off = true;
> > +		vcpu_power_off(vcpu);
> >  		break;
> >  	default:
> >  		return -EINVAL;
> > @@ -626,14 +633,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  
> >  		if (kvm_request_pending(vcpu)) {
> >  			if (kvm_check_request(KVM_REQ_VCPU_EXIT, vcpu)) {
> > -				if (vcpu->arch.pause)
> > +				if (vcpu->arch.power_off || vcpu->arch.pause)
> >  					vcpu_sleep(vcpu);
> >  			}
> >  		}
> >  
> > -		if (vcpu->arch.power_off)
> > -			vcpu_sleep(vcpu);
> > -
> 
> Hmmm, even though I just gave a reviewed-by on the pause side, I'm not
> realizing that I don't think this works.  Because you're now only
> checking requests in the vcpu loop, but the vcpu_sleep() function is
> implemented using swait_event_interruptible(), which can wake up if you
> have a pending signal for example, and then the loop can wrap around and
> you can run the VCPU even though you should be paused.  Am I missing
> something?

Hmm, I think I missed something. I missed that swait_event_interruptible()
doesn't check its condition again when awoken by a signal (which, as far
as I can tell, is the only other way we can stop vcpu_sleep() while
power_off and/or pause are true.  Had I noticed that, I could have
addressed it in one of two ways:

 1) Leave power_off and pause in the condition that stops guest entry.
    Easy to see we'll never enter guest mode with one or both set.
    
 2) Add a comment somewhere to explain the subtle dependency vcpu_sleep()
    has on the pending signal check done after its call and before the
    condition that stops guest entry is run. (IOW, I don't think we have
    a bug with this series, but we do have a non-commented subtlety.)

Thanks,
drew

> 
> Thanks,
> -Christoffer
> 
> >  		/*
> >  		 * Preparing the interrupts to be injected also
> >  		 * involves poking the GIC, which must be done in a
> > @@ -903,7 +907,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
> >  	 * Handle the "start in power-off" case.
> >  	 */
> >  	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
> > -		vcpu->arch.power_off = true;
> > +		vcpu_power_off(vcpu);
> >  	else
> >  		vcpu->arch.power_off = false;
> >  
> > diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
> > index f189d0ad30d5..4a436685c552 100644
> > --- a/arch/arm/kvm/psci.c
> > +++ b/arch/arm/kvm/psci.c
> > @@ -65,6 +65,8 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
> >  static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
> >  {
> >  	vcpu->arch.power_off = true;
> > +	kvm_make_request(KVM_REQ_VCPU_EXIT, vcpu);
> > +	kvm_vcpu_kick(vcpu);
> >  }
> >  
> >  static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > -- 
> > 2.9.3
> > 
