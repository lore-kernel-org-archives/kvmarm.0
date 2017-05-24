From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 1/9] KVM: arm64: Allow creating the PMU without the
 in-kernel GIC
Date: Wed, 24 May 2017 13:45:34 +0200
Message-ID: <20170524114534.GB7991@cbox>
References: <20170516184556.26785-1-cdall@linaro.org>
 <20170516184556.26785-2-cdall@linaro.org>
 <51d0d9eb-3e72-2f37-3fac-89de28cea91b@arm.com>
 <20170524083805.GA7991@cbox>
 <4cf8f05e-1af1-eaed-151f-54e7a60d7b63@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D635040BBC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 07:42:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Hoh38uhn-Bt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 May 2017 07:42:11 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3688540A86
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 07:42:10 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id 7so61440939wmo.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 04:45:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4cf8f05e-1af1-eaed-151f-54e7a60d7b63@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 24, 2017 at 10:16:56AM +0100, Marc Zyngier wrote:
> On 24/05/17 09:38, Christoffer Dall wrote:
> > On Tue, May 23, 2017 at 05:52:01PM +0100, Marc Zyngier wrote:
> >> On 16/05/17 19:45, Christoffer Dall wrote:
> >>> Since we got support for devices in userspace which allows reporting the
> >>> PMU overflow output status to userspace, we should actually allow
> >>> creating the PMU on systems without an in-kernel irqchip, which in turn
> >>> requires us to slightly clarify error codes for the ABI and move things
> >>> around for the initialization phase.
> >>>
> >>> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> >>> ---
> >>>  Documentation/virtual/kvm/devices/vcpu.txt | 16 +++++++++-------
> >>>  virt/kvm/arm/pmu.c                         | 30 ++++++++++++++++++++----------
> >>>  2 files changed, 29 insertions(+), 17 deletions(-)
> >>>
> >>> diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
> >>> index 02f5068..352af6e 100644
> >>> --- a/Documentation/virtual/kvm/devices/vcpu.txt
> >>> +++ b/Documentation/virtual/kvm/devices/vcpu.txt
> >>> @@ -16,7 +16,9 @@ Parameters: in kvm_device_attr.addr the address for PMU overflow interrupt is a
> >>>  Returns: -EBUSY: The PMU overflow interrupt is already set
> >>>           -ENXIO: The overflow interrupt not set when attempting to get it
> >>>           -ENODEV: PMUv3 not supported
> >>> -         -EINVAL: Invalid PMU overflow interrupt number supplied
> >>> +         -EINVAL: Invalid PMU overflow interrupt number supplied or
> >>> +                  trying to set the IRQ number without using an in-kernel
> >>> +                  irqchip.
> >>>  
> >>>  A value describing the PMUv3 (Performance Monitor Unit v3) overflow interrupt
> >>>  number for this vcpu. This interrupt could be a PPI or SPI, but the interrupt
> >>> @@ -25,11 +27,11 @@ all vcpus, while as an SPI it must be a separate number per vcpu.
> >>>  
> >>>  1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
> >>>  Parameters: no additional parameter in kvm_device_attr.addr
> >>> -Returns: -ENODEV: PMUv3 not supported
> >>> -         -ENXIO: PMUv3 not properly configured as required prior to calling this
> >>> -                 attribute
> >>> +Returns: -ENODEV: PMUv3 not supported or GIC not initialized
> >>> +         -ENXIO: PMUv3 not properly configured or in-kernel irqchip not
> >>> +                 conigured as required prior to calling this attribute
> >>
> >>                     configured
> >>
> >>>           -EBUSY: PMUv3 already initialized
> >>>  
> >>> -Request the initialization of the PMUv3.  This must be done after creating the
> >>> -in-kernel irqchip.  Creating a PMU with a userspace irqchip is currently not
> >>> -supported.
> >>> +Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
> >>> +virtual GIC implementation, this must be done after initializing the in-kernel
> >>> +irqchip.
> >>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> >>> index 4b43e7f..7209185 100644
> >>> --- a/virt/kvm/arm/pmu.c
> >>> +++ b/virt/kvm/arm/pmu.c
> >>> @@ -456,21 +456,25 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
> >>>  	if (!kvm_arm_support_pmu_v3())
> >>>  		return -ENODEV;
> >>>  
> >>> -	/*
> >>> -	 * We currently require an in-kernel VGIC to use the PMU emulation,
> >>> -	 * because we do not support forwarding PMU overflow interrupts to
> >>> -	 * userspace yet.
> >>> -	 */
> >>> -	if (!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))
> >>> -		return -ENODEV;
> >>> -
> >>> -	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features) ||
> >>> -	    !kvm_arm_pmu_irq_initialized(vcpu))
> >>> +	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
> >>>  		return -ENXIO;
> >>>  
> >>>  	if (kvm_arm_pmu_v3_ready(vcpu))
> >>>  		return -EBUSY;
> >>>  
> >>> +	if (irqchip_in_kernel(vcpu->kvm)) {
> >>> +		/*
> >>> +		 * If using the PMU with an in-kernel virtual GIC
> >>> +		 * implementation, we require the GIC to be already
> >>> +		 * initialized when initializing the PMU.
> >>> +		 */
> >>> +		if (!vgic_initialized(vcpu->kvm))
> >>> +			return -ENODEV;
> >>> +
> >>> +		if (!kvm_arm_pmu_irq_initialized(vcpu))
> >>> +			return -ENXIO;
> >>> +	}
> >>> +
> >>
> >> Do we also need to prevent a vgic to be created if the PMU has been
> >> initialized beforehand?
> >>
> > 
> > Sigh.  We probably have to.
> > 
> > I don't like having a cross-VGIC-PMU check, but we could do something
> > like setting a flag on the kvm struct so that irqchip_in_user() always
> > return true, and if that is set, it is not possible to create the VGIC.
> > 
> > Alternatively we can make the PMU init a no-op, and try to enable it via
> > the first-vcpu-run path, like the timer, and check that everything lines
> > up then (i.e. you have in-kernel irqchip with a non-conflicting irq
> > number or you have a userspace irqchip).
> 
> I like this second solution better, as it gives us a common approach to
> similar problems.

Yes, but on the other hand it's a bit like the lazy init stuff, where we
defer things to happen at some point in time, and the whole PMU init
thing was to avoid that.  On the first hand, it seems to work well for
lots of things, so why not...


> Would that also help with not having to implement the
> allocator you introduced in patches 6-9 (which I haven't reviewed yet)?
> 

Not really.  I mean, we could add some cross calls between the timer and
PMU code, but I think that's fairly disgusting, and it doesn't prevent
userspace from fiddling with an interrupt signal used in the kernel
anyway.

With patchs 6-9, I feel like we should take one of two overall stands;
either we don't care that userspace can wire things up share an
interrupt line, even with in-kernel driven devices, as it would be the
equivalent of putting an OR gate before the GIC in hardware (not that I
recommend anyone doing that), or we should implement the full story and
prevent userspace from ever shooting itself in the foot.

Thanks,
-Christoffer
