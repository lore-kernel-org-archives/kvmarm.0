From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 1/9] KVM: arm64: Allow creating the PMU without the
 in-kernel GIC
Date: Thu, 1 Jun 2017 12:53:49 +0200
Message-ID: <20170601105349.GJ20919@cbox>
References: <20170516184556.26785-1-cdall@linaro.org>
 <20170516184556.26785-2-cdall@linaro.org>
 <51d0d9eb-3e72-2f37-3fac-89de28cea91b@arm.com>
 <20170524083805.GA7991@cbox>
 <4cf8f05e-1af1-eaed-151f-54e7a60d7b63@arm.com>
 <20170524114534.GB7991@cbox>
 <aa9a9339-0850-d4e2-0814-60437f4673bc@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aa9a9339-0850-d4e2-0814-60437f4673bc@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Alexander Graf <agraf@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 24, 2017 at 05:37:03PM +0100, Marc Zyngier wrote:
> On 24/05/17 12:45, Christoffer Dall wrote:
> > On Wed, May 24, 2017 at 10:16:56AM +0100, Marc Zyngier wrote:
> >> On 24/05/17 09:38, Christoffer Dall wrote:
> >>> On Tue, May 23, 2017 at 05:52:01PM +0100, Marc Zyngier wrote:
> >>>> On 16/05/17 19:45, Christoffer Dall wrote:
> >>>>> Since we got support for devices in userspace which allows reporting the
> >>>>> PMU overflow output status to userspace, we should actually allow
> >>>>> creating the PMU on systems without an in-kernel irqchip, which in turn
> >>>>> requires us to slightly clarify error codes for the ABI and move things
> >>>>> around for the initialization phase.
> >>>>>
> >>>>> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> >>>>> ---
> >>>>>  Documentation/virtual/kvm/devices/vcpu.txt | 16 +++++++++-------
> >>>>>  virt/kvm/arm/pmu.c                         | 30 ++++++++++++++++++++----------
> >>>>>  2 files changed, 29 insertions(+), 17 deletions(-)
> >>>>>
> >>>>> diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
> >>>>> index 02f5068..352af6e 100644
> >>>>> --- a/Documentation/virtual/kvm/devices/vcpu.txt
> >>>>> +++ b/Documentation/virtual/kvm/devices/vcpu.txt
> >>>>> @@ -16,7 +16,9 @@ Parameters: in kvm_device_attr.addr the address for PMU overflow interrupt is a
> >>>>>  Returns: -EBUSY: The PMU overflow interrupt is already set
> >>>>>           -ENXIO: The overflow interrupt not set when attempting to get it
> >>>>>           -ENODEV: PMUv3 not supported
> >>>>> -         -EINVAL: Invalid PMU overflow interrupt number supplied
> >>>>> +         -EINVAL: Invalid PMU overflow interrupt number supplied or
> >>>>> +                  trying to set the IRQ number without using an in-kernel
> >>>>> +                  irqchip.
> >>>>>  
> >>>>>  A value describing the PMUv3 (Performance Monitor Unit v3) overflow interrupt
> >>>>>  number for this vcpu. This interrupt could be a PPI or SPI, but the interrupt
> >>>>> @@ -25,11 +27,11 @@ all vcpus, while as an SPI it must be a separate number per vcpu.
> >>>>>  
> >>>>>  1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
> >>>>>  Parameters: no additional parameter in kvm_device_attr.addr
> >>>>> -Returns: -ENODEV: PMUv3 not supported
> >>>>> -         -ENXIO: PMUv3 not properly configured as required prior to calling this
> >>>>> -                 attribute
> >>>>> +Returns: -ENODEV: PMUv3 not supported or GIC not initialized
> >>>>> +         -ENXIO: PMUv3 not properly configured or in-kernel irqchip not
> >>>>> +                 conigured as required prior to calling this attribute
> >>>>
> >>>>                     configured
> >>>>
> >>>>>           -EBUSY: PMUv3 already initialized
> >>>>>  
> >>>>> -Request the initialization of the PMUv3.  This must be done after creating the
> >>>>> -in-kernel irqchip.  Creating a PMU with a userspace irqchip is currently not
> >>>>> -supported.
> >>>>> +Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
> >>>>> +virtual GIC implementation, this must be done after initializing the in-kernel
> >>>>> +irqchip.
> >>>>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> >>>>> index 4b43e7f..7209185 100644
> >>>>> --- a/virt/kvm/arm/pmu.c
> >>>>> +++ b/virt/kvm/arm/pmu.c
> >>>>> @@ -456,21 +456,25 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
> >>>>>  	if (!kvm_arm_support_pmu_v3())
> >>>>>  		return -ENODEV;
> >>>>>  
> >>>>> -	/*
> >>>>> -	 * We currently require an in-kernel VGIC to use the PMU emulation,
> >>>>> -	 * because we do not support forwarding PMU overflow interrupts to
> >>>>> -	 * userspace yet.
> >>>>> -	 */
> >>>>> -	if (!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))
> >>>>> -		return -ENODEV;
> >>>>> -
> >>>>> -	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features) ||
> >>>>> -	    !kvm_arm_pmu_irq_initialized(vcpu))
> >>>>> +	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
> >>>>>  		return -ENXIO;
> >>>>>  
> >>>>>  	if (kvm_arm_pmu_v3_ready(vcpu))
> >>>>>  		return -EBUSY;
> >>>>>  
> >>>>> +	if (irqchip_in_kernel(vcpu->kvm)) {
> >>>>> +		/*
> >>>>> +		 * If using the PMU with an in-kernel virtual GIC
> >>>>> +		 * implementation, we require the GIC to be already
> >>>>> +		 * initialized when initializing the PMU.
> >>>>> +		 */
> >>>>> +		if (!vgic_initialized(vcpu->kvm))
> >>>>> +			return -ENODEV;
> >>>>> +
> >>>>> +		if (!kvm_arm_pmu_irq_initialized(vcpu))
> >>>>> +			return -ENXIO;
> >>>>> +	}
> >>>>> +
> >>>>
> >>>> Do we also need to prevent a vgic to be created if the PMU has been
> >>>> initialized beforehand?
> >>>>
> >>>
> >>> Sigh.  We probably have to.
> >>>
> >>> I don't like having a cross-VGIC-PMU check, but we could do something
> >>> like setting a flag on the kvm struct so that irqchip_in_user() always
> >>> return true, and if that is set, it is not possible to create the VGIC.
> >>>
> >>> Alternatively we can make the PMU init a no-op, and try to enable it via
> >>> the first-vcpu-run path, like the timer, and check that everything lines
> >>> up then (i.e. you have in-kernel irqchip with a non-conflicting irq
> >>> number or you have a userspace irqchip).
> >>
> >> I like this second solution better, as it gives us a common approach to
> >> similar problems.
> > 
> > Yes, but on the other hand it's a bit like the lazy init stuff, where we
> > defer things to happen at some point in time, and the whole PMU init
> > thing was to avoid that.  On the first hand, it seems to work well for
> > lots of things, so why not...
> 
> The main problem is that we now have lots of things that can be
> configured in arbitrary orders. We can either check the consistency of
> the current configuration at each step, or delay it until we are ready
> to run, and then check everything in one go.
> 
> Overall, this is the same set of checks. We just need to decide which
> way we want to go, and stick with it. Which is of course easier said
> than done... ;-)
> 

Coming back to this, I agree with you, that we should check things when
we first start running.

Raising an error when trying to do something is slightly more user
friendly (you have a better hint of where the error comes from), but I'm
not convinced we already have that info at hand.

I think at this point we just have to make sure everything is consistent
before we run the VM.

> > 
> >> Would that also help with not having to implement the
> >> allocator you introduced in patches 6-9 (which I haven't reviewed yet)?
> >>
> > 
> > Not really.  I mean, we could add some cross calls between the timer and
> > PMU code, but I think that's fairly disgusting, and it doesn't prevent
> > userspace from fiddling with an interrupt signal used in the kernel
> > anyway.
> > 
> > With patchs 6-9, I feel like we should take one of two overall stands;
> > either we don't care that userspace can wire things up share an
> > interrupt line, even with in-kernel driven devices, as it would be the
> > equivalent of putting an OR gate before the GIC in hardware (not that I
> > recommend anyone doing that), or we should implement the full story and
> > prevent userspace from ever shooting itself in the foot.
> 
> Having had a quick look at 6-9, I'm hesitant (again). On one hand, the
> each patch is fairly simple and not very invasive, but on the other
> hand, the result is a tiny bit ugly (all these "owner" parameters passed
> around).

I'm open to sugestions on how to make it more clean.

> 
> So the real question is still: does anything break on the host if
> userspace configures something in a nonsensical way? My main concern is
> the effect of having the virtual PMU sharing a line with the virtual
> timer, which has the HW bit set. So let's assume that for a minute:
> 
> - PMU interrupt is asserted
> - Timer interrupt is not asserted
> - We inject the shared intid with the HW bit set, and the hwintid of the
> virtual timer.
> - We do *not* set the active bit on the redistributor (because the timer
> code has noticed we don't need to)
> 
> When the guest does EOI the interrupt, it will propagate into the
> physical distributor, and deactivate... I don't know what, since we
> don't have an active interrupt there.

I believe the spec explicitly says that this is a programming error and
that OS code should never allow this.

> 
> Things become even uglier if the timer fires between the activation of
> the virtual interrupt and its EOI. The PMU interrupt EOI ends up
> deactivating the timer on the physical distributor, leading to the timer
> firing again... At that stage, I think things get pretty bad, as we've
> lost track of the state.

Yeah, not nice.

I think this interaction also can happen if we let userspace set the
timer irq state using KVM_IRQ_LINE (as we already do), right?

> 
> That being said, I don't think we break anything on the host, but the
> above seem disturbing enough that we don't want to let it happen. So I
> guess that patches 6-9 are actually required.

I agree, I think we need it, unfortunately.

-Christoffer
