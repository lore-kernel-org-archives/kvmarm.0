From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v9 5/7] arm64: kvm: Introduce KVM_ARM_SET_SERROR_ESR ioctl
Date: Fri, 09 Feb 2018 17:44:14 +0000
Message-ID: <5A7DDDEE.9050306@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F201A9E8EA@DGGEMA503-MBS.china.huawei.com> <5A70C5A0.1050600@arm.com> <d1b17dae-9d9c-970a-d164-a41c618d449b@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <d1b17dae-9d9c-970a-d164-a41c618d449b@huawei.com>
Sender: linux-doc-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "bp@alien8.de" <bp@alien8.de>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "corbet@lwn.net" <corbet@lwn.net>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 05/02/18 06:19, gengdongjiu wrote:
> On 2018/1/31 3:21, James Morse wrote:
>> On 24/01/18 20:06, gengdongjiu wrote:
>>>> On 06/01/18 16:02, Dongjiu Geng wrote:
>>>>> The ARM64 RAS SError Interrupt(SEI) syndrome value is specific to the
>>>>> guest and user space needs a way to tell KVM this value. So we add a
>>>>> new ioctl. Before user space specifies the Exception Syndrome Register
>>>>> ESR(ESR), it firstly checks that whether KVM has the capability to set
>>>>> the guest ESR, If has, will set it. Otherwise, nothing to do.
>>>>>
>>>>> For this ESR specifying, Only support for AArch64, not support AArch32.
>>>>
>>>> After this patch user-space can trigger an SError in the guest. If it wants to migrate the guest, how does the pending SError get migrated?
>>>>
>>>> I think we need to fix migration first. Andrew Jones suggested using
>>>> KVM_GET/SET_VCPU_EVENTS:
>>>> https://www.spinics.net/lists/arm-kernel/msg616846.html
>>>>
>>>> Given KVM uses kvm_inject_vabt() on v8.0 hardware too, we should cover systems without the v8.2 RAS Extensions with the same API. I
>>>> think this means a bit to read/write whether SError is pending, and another to indicate the ESR should be set/read.
>>>> CPUs without the v8.2 RAS Extensions can reject pending-SError that had an ESR.
>>>
>>> For the CPUs without the v8.2 RAS Extensions, its ESR is always 0, 
>>> we only can inject a SError with ESR 0 to guest, cannot set its ESR.
>>
>> 0? It's always implementation-defined. On Juno it seems to be always-0, but
>> other systems may behave differently. (Juno may generate another ESR value when
>> I'm not watching it...)

> For the armv8.0 cpu without RAS Extensions, it does not have vsesr_el2, so when
> guest take a virtual SError,

> its ESR is 0, can not control the virtual SError's syndrom value, it does not have
> such registers to control that.

My point was its more nuanced than this: the ARM-ARM's
TakeVirtualSErrorException() pseudo-code lets virtual-SError have an
implementation defined syndrome. I've never seen Juno generate anything other
than '0', but it might do something different on a thursday.

The point? We can't know what a CPU without the RAS extensions puts in there.

Why Does this matter? When migrating a pending SError we have to know the
difference between 'use this 64bit value', and 'the CPU will generate it'.
If I make an SError pending with ESR=0 on a CPU with VSESR, I can't migrated to
a system that generates an impdef SError-ESR, because I can't know it will be 0.


> Does Juno not have RAS Extension? 

It's two types of v8.0 CPU, no RAS extensions.


> if yes, I think we can only inject an SError, but can not change its ESR value,
> because it does not have vsesr_el2.

I agree, this means we need to be able to tell the difference between 'pending'
and 'pending with this ESR'.


>> Just because we can't control the ESR doesn't mean injecting an SError isn't
>> something user-space may want to do.

> yes, we may need to support user-space injects an SError even through CPU does not have RAS Extension.
> 
>> If we tackle migration of pending-SError first, I think that will give us the
>> API to create a new pending SError with/without an ESR as appropriate.
> 
> sure, we should. Last week, I checked the KVM_GET/SET_VCPU_EVENTS IOCTL, it should meet our
> migration requirements

Great!


Thanks,

James



>>> The IOCTL KVM_GET/SET_VCPU_EVENTS has been used by X86.
>>
>> We would be re-using the struct to have values with slightly different meanings.
>> But for migration the upshot is the same, call KVM_GET_VCPU_EVENTS on one
>> system, and pass the struct to KVM_SET_VCPU_EVENTS on the new system. If we're
>> lucky Qemu may be able to do this in shared x86/arm64 code.
>>
> Thanks for the reminder, I know your meaning.
> In the x86, the kvm_vcpu_events includes exception/interrupt/nmi/smi. For the RAS, we
> only involves the exception, so Qemu handling logic is different. Anyway, I will try to
> share code for the two platform in Qemu.
> 
> 
> /* for KVM_GET/SET_VCPU_EVENTS */
> struct kvm_vcpu_events {
> 	struct {
> 		__u8 injected;
> 		__u8 nr;
> 		__u8 has_error_code;
> 		__u8 pad;
> 		__u32 error_code;
> 	} exception;
> 	struct {
> 		__u8 injected;
> 		__u8 nr;
> 		__u8 soft;
> 		__u8 shadow;
> 	} interrupt;
> 	struct {
> 		__u8 injected;
> 		__u8 pending;
> 		__u8 masked;
> 		__u8 pad;
> 	} nmi;
> 	__u32 sipi_vector;
> 	__u32 flags;
> 	struct {
> 		__u8 smm;
> 		__u8 pending;
> 		__u8 smm_inside_nmi;
> 		__u8 latched_init;
> 	} smi;
> 	__u32 reserved[9];
> };
> 
