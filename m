From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Allow creating the PMU without the
 in-kernel GIC
Date: Thu, 4 May 2017 09:28:50 +0100
Message-ID: <db5a1fb7-e77e-b9f8-9be4-161e94279d10@arm.com>
References: <20170503183300.4618-1-cdall@linaro.org>
 <20170503183300.4618-2-cdall@linaro.org>
 <dcaefb19-6dab-a990-2e10-497d02b14242@arm.com> <20170504081337.GF5923@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170504081337.GF5923@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Alexander Graf <agraf@suse.de>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/05/17 09:13, Christoffer Dall wrote:
> On Thu, May 04, 2017 at 09:09:47AM +0100, Marc Zyngier wrote:
>> On 03/05/17 19:32, Christoffer Dall wrote:
>>> Since we got support for devices in userspace which allows reporting the
>>> PMU overflow output status to userspace, we should actually allow
>>> creating the PMU on systems without an in-kernel irqchip, which in turn
>>> requires us to slightly clarify error codes for the ABI and move things
>>> around for the initialization phase.
>>>
>>> Signed-off-by: Christoffer Dall <cdall@linaro.org>
>>> ---
>>>  Documentation/virtual/kvm/devices/vcpu.txt | 16 +++++++++-------
>>>  virt/kvm/arm/pmu.c                         | 27 +++++++++++++++++----------
>>>  2 files changed, 26 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
>>> index 02f5068..352af6e 100644
>>> --- a/Documentation/virtual/kvm/devices/vcpu.txt
>>> +++ b/Documentation/virtual/kvm/devices/vcpu.txt
>>> @@ -16,7 +16,9 @@ Parameters: in kvm_device_attr.addr the address for PMU overflow interrupt is a
>>>  Returns: -EBUSY: The PMU overflow interrupt is already set
>>>           -ENXIO: The overflow interrupt not set when attempting to get it
>>>           -ENODEV: PMUv3 not supported
>>> -         -EINVAL: Invalid PMU overflow interrupt number supplied
>>> +         -EINVAL: Invalid PMU overflow interrupt number supplied or
>>> +                  trying to set the IRQ number without using an in-kernel
>>> +                  irqchip.
>>>  
>>>  A value describing the PMUv3 (Performance Monitor Unit v3) overflow interrupt
>>>  number for this vcpu. This interrupt could be a PPI or SPI, but the interrupt
>>> @@ -25,11 +27,11 @@ all vcpus, while as an SPI it must be a separate number per vcpu.
>>>  
>>>  1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
>>>  Parameters: no additional parameter in kvm_device_attr.addr
>>> -Returns: -ENODEV: PMUv3 not supported
>>> -         -ENXIO: PMUv3 not properly configured as required prior to calling this
>>> -                 attribute
>>> +Returns: -ENODEV: PMUv3 not supported or GIC not initialized
>>> +         -ENXIO: PMUv3 not properly configured or in-kernel irqchip not
>>> +                 conigured as required prior to calling this attribute
>>>           -EBUSY: PMUv3 already initialized
>>>  
>>> -Request the initialization of the PMUv3.  This must be done after creating the
>>> -in-kernel irqchip.  Creating a PMU with a userspace irqchip is currently not
>>> -supported.
>>> +Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
>>> +virtual GIC implementation, this must be done after initializing the in-kernel
>>> +irqchip.
>>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>>> index 4b43e7f..f046b08 100644
>>> --- a/virt/kvm/arm/pmu.c
>>> +++ b/virt/kvm/arm/pmu.c
>>> @@ -456,21 +456,25 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>>>  	if (!kvm_arm_support_pmu_v3())
>>>  		return -ENODEV;
>>>  
>>> -	/*
>>> -	 * We currently require an in-kernel VGIC to use the PMU emulation,
>>> -	 * because we do not support forwarding PMU overflow interrupts to
>>> -	 * userspace yet.
>>> -	 */
>>> -	if (!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))
>>> -		return -ENODEV;
>>> -
>>> -	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features) ||
>>> -	    !kvm_arm_pmu_irq_initialized(vcpu))
>>> +	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
>>>  		return -ENXIO;
>>>  
>>>  	if (kvm_arm_pmu_v3_ready(vcpu))
>>>  		return -EBUSY;
>>>  
>>> +	if (irqchip_in_kernel(vcpu->kvm)) {
>>> +		/*
>>> +		 * If using the PMU with an in-kernel virtual GIC
>>> +		 * implementation, we require the GIC to be already
>>> +		 * initialized when initializing the PMU.
>>> +		 */
>>> +		if (!vgic_initialized(vcpu->kvm))
>>> +			return -ENODEV;
>>> +
>>> +		if (!kvm_arm_pmu_irq_initialized(vcpu))
>>> +			return -ENXIO;
>>> +	}
>>> +
>>>  	kvm_pmu_vcpu_reset(vcpu);
>>>  	vcpu->arch.pmu.ready = true;
>>>  
>>> @@ -512,6 +516,9 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>>>  		int __user *uaddr = (int __user *)(long)attr->addr;
>>>  		int irq;
>>>  
>>> +		if (!irqchip_in_kernel(vcpu->kvm))
>>> +			return -EINVAL;
>>> +
>>
>> Shouldn't we fail the same way for {get,has}_attr? get_attr is going to
>> generate a -ENXIO, and has_attr is going to lie about the availability
>> of KVM_ARM_VCPU_PMU_V3_IRQ...
>>
> 
> Here's the text from api.txt:
> 
>   Tests whether a device supports a particular attribute.  A successful
>   return indicates the attribute is implemented.  It does not necessarily
>   indicate that the attribute can be read or written in the device's
>   current state.  "addr" is ignored.
> 
> My interpretation therefore is that QEMU can use this ioctl to figure
> out if the feature is supported (sort of like a capability), but that
> doesn't mean that the configuration of the VM is such that the attribute
> can be get or set at that moment.
> 
> For example, there will also alway be situations where you can get an
> attr, but not set an attr, what should the has_attr return then?

My issue here is that whether we can get/set the interrupt or not is not
a function of the device itself, but of the way it is "wired". No matter
what "the device's current state" is, we'll never be able to get/set the
interrupt.

I'd tend to err on the side of caution and return something that is
unambiguous, be maybe I have too strict an interpretation of the API.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
