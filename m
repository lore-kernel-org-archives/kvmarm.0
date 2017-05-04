From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 5/5] KVM: arm/arm64: Allow setting the timer IRQ numbers
 from userspace
Date: Thu, 4 May 2017 11:54:06 +0100
Message-ID: <79ec69f2-d727-46ec-b1d5-4c535a904e63@arm.com>
References: <20170503183300.4618-1-cdall@linaro.org>
 <20170503183300.4618-6-cdall@linaro.org>
 <b08c50b4-6aba-1a59-80f4-343cd906f1fa@arm.com> <20170504095918.GJ5923@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170504095918.GJ5923@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Alexander Graf <agraf@suse.de>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/05/17 10:59, Christoffer Dall wrote:
> On Thu, May 04, 2017 at 10:34:32AM +0100, Marc Zyngier wrote:
>> On 03/05/17 19:33, Christoffer Dall wrote:
>>> First we define an ABI using the vcpu devices that lets userspace set
>>> the interrupt numbers for the various timers on both the 32-bit and
>>> 64-bit KVM/ARM implementations.
>>>
>>> Second, we add the definitions for the groups and attributes introduced
>>> by the above ABI.  (We add the PMU define on the 32-bit side as well for
>>> symmetry and it may get used some day.)
>>>
>>> Third, we set up the arch-specific vcpu device operation handlers to
>>> call into the timer code for anything related to the
>>> KVM_ARM_VCPU_TIMER_CTRL group.
>>>
>>> Fourth, we implement support for getting and setting the timer interrupt
>>> numbers using the above defined ABI in the arch timer code.
>>>
>>> Fifth, we introduce error checking upon enabling the arch timer (which
>>> is called when first running a VCPU) to check that all VCPUs are
>>> configured to use the same PPI for the timer (as mandated by the
>>> architecture) and that the virtual and physical timers are not
>>> configured to use the same IRQ number.
>>>
>>> Signed-off-by: Christoffer Dall <cdall@linaro.org>
>>> ---
>>>  Documentation/virtual/kvm/devices/vcpu.txt |  25 +++++++
>>>  arch/arm/include/uapi/asm/kvm.h            |   8 +++
>>>  arch/arm/kvm/guest.c                       |   9 +++
>>>  arch/arm64/include/uapi/asm/kvm.h          |   3 +
>>>  arch/arm64/kvm/guest.c                     |   9 +++
>>>  include/kvm/arm_arch_timer.h               |   4 ++
>>>  virt/kvm/arm/arch_timer.c                  | 104 +++++++++++++++++++++++++++++
>>>  7 files changed, 162 insertions(+)
>>>
>>> diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
>>> index 352af6e..013e3f1 100644
>>> --- a/Documentation/virtual/kvm/devices/vcpu.txt
>>> +++ b/Documentation/virtual/kvm/devices/vcpu.txt
>>> @@ -35,3 +35,28 @@ Returns: -ENODEV: PMUv3 not supported or GIC not initialized
>>>  Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
>>>  virtual GIC implementation, this must be done after initializing the in-kernel
>>>  irqchip.
>>> +
>>> +
>>> +2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>>> +Architectures: ARM,ARM64
>>> +
>>> +2.1. ATTRIBUTE: KVM_ARM_VCPU_TIMER_IRQ_VTIMER
>>> +2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_IRQ_PTIMER
>>> +Parameters: in kvm_device_attr.addr the address for the timer interrupt is a
>>> +            pointer to an int
>>> +Returns: -EINVAL: Invalid timer interrupt number
>>> +         -EBUSY:  One or more VCPUs has already run
>>> +
>>> +A value describing the architected timer interrupt number when connected to an
>>> +in-kernel virtual GIC.  These must be a PPI (16 <= intid < 32).  If an
>>> +attribute is not set, a default value is applied (see below).
>>> +
>>> +KVM_ARM_VCPU_TIMER_IRQ_VTIMER: The EL1 virtual timer intid (default: 27)
>>> +KVM_ARM_VCPU_TIMER_IRQ_PTIMER: The EL1 physical timer intid (default: 30)
>>
>> uber nit: my reading of the code is that the default is set at VCPU
>> creation time. So setting the attribute overrides the default, not that
>> the default is applied if no attribute is set (i.e. there is always a
>> valid value).
>>
> 
> uh, right, I don't see the distinction though, so not sure how to
> correct the text.
> 
> Would "Setting the attribute overrides the default values (see below)."
> work instead?

Looks good to me.

[...]

>>
>> Another issue that just popped in my head: how do we ensure that we
>> don't clash between the PMU and the timers? Yes, that's a foolish thing
>> to do, but that's no different from avoiding the same interrupt on the
>> timers...
>>
> Argh, good point.
> 
> So actually, nothing *really bad* happens from using the same IRQ number
> except that the VM gets confused.  However, it's living life dangerously
> because we use the HW bit for the vtimer, so we if ever start using it
> for other timers or the PMU, then you could end up in a situation where
> you unmap the phys mapping on behalf of another device, and the physical
> interrupt could be left in an active state.
> 
> On the other hand, the vtimer currently belongs only to VMs and we set
> the required physical active state before entering the VM, so maybe it
> doesn't matter.

So far, we always assume that there is never more than a single source
per interrupt. We'll end-up with weird behaviours because our line_level
field is not an OR of the various inputs, but a direct assignment
(device A and B raise the line, then A drops it -> B's interrupt is gone).

I think that only the guest will be confused by it, but accepting it may
be interpreted as "this should work correctly". Would documenting that
it is a bad idea be enough?

> Should we just forego these checks and let the user shoot itself in the
> foot if he/she wants to?

If the documentation is enough, why not. Otherwise, we need some form of
allocator. Boring. ;-)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
