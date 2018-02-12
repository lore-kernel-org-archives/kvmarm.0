From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v9 5/7] arm64: kvm: Introduce KVM_ARM_SET_SERROR_ESR ioctl
Date: Mon, 12 Feb 2018 18:19:24 +0800
Message-ID: <93d07d3e-8388-7814-d674-538071d84e2a@huawei.com>
References: <0184EA26B2509940AA629AE1405DD7F201A9E8EA@DGGEMA503-MBS.china.huawei.com>
 <5A70C5A0.1050600@arm.com> <d1b17dae-9d9c-970a-d164-a41c618d449b@huawei.com>
 <5A7DDDEE.9050306@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5A7DDDEE.9050306@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "bp@alien8.de" <bp@alien8.de>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "corbet@lwn.net" <corbet@lwn.net>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
 Thanks for the mail.

On 2018/2/10 1:44, James Morse wrote:
[...]
> 
>> its ESR is 0, can not control the virtual SError's syndrom value, it does not have
>> such registers to control that.
> 
> My point was its more nuanced than this: the ARM-ARM's
> TakeVirtualSErrorException() pseudo-code lets virtual-SError have an
> implementation defined syndrome. I've never seen Juno generate anything other
> than '0', but it might do something different on a thursday.

I checked the "aarch64/exceptions/asynch/AArch64.TakeVirtualSErrorException",
you are right, the virtual SError's syndrome value can be 0 or implementation defined value, not always 0,
which is decided by the "exception.syndrome<24>".
thanks for the clarification.

> 
> The point? We can't know what a CPU without the RAS extensions puts in there.
> 
> Why Does this matter? When migrating a pending SError we have to know the
> difference between 'use this 64bit value', and 'the CPU will generate it'.
> If I make an SError pending with ESR=0 on a CPU with VSESR, I can't migrated to
> a system that generates an impdef SError-ESR, because I can't know it will be 0.
Yes,
But it will have a issue,
For the target system, before taking the SError, no one can know whether its syndrome value
is IMPLEMENTATION DEFINED or architecturally defined.

when the virtual SError is taken, the ESR_ELx.IDS will be updated, then we can know
whether the ESR value is impdef or architecturally defined.

It seems migration is only allowed only when target system and source system all support RAS extension, because we do not know
whether its syndrome is IMPLEMENTATION DEFINED or architecturally defined.

> 
> 
>> Does Juno not have RAS Extension? 
> 
> It's two types of v8.0 CPU, no RAS extensions.
> 
> 
>> if yes, I think we can only inject an SError, but can not change its ESR value,
>> because it does not have vsesr_el2.
> 
> I agree, this means we need to be able to tell the difference between 'pending'
> and 'pending with this ESR'.
> 
> 
>>> Just because we can't control the ESR doesn't mean injecting an SError isn't
>>> something user-space may want to do.
> 
>> yes, we may need to support user-space injects an SError even through CPU does not have RAS Extension.
>>
>>> If we tackle migration of pending-SError first, I think that will give us the
>>> API to create a new pending SError with/without an ESR as appropriate.
>>
>> sure, we should. Last week, I checked the KVM_GET/SET_VCPU_EVENTS IOCTL, it should meet our
>> migration requirements
> 
> Great!
> 
> 
> Thanks,
> 
> James
> 
> 
