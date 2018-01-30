From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v9 5/7] arm64: kvm: Introduce KVM_ARM_SET_SERROR_ESR ioctl
Date: Tue, 30 Jan 2018 19:21:04 +0000
Message-ID: <5A70C5A0.1050600@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F201A9E8EA@DGGEMA503-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F201A9E8EA@DGGEMA503-MBS.china.huawei.com>
Sender: linux-doc-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "bp@alien8.de" <bp@alien8.de>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "corbet@lwn.net" <corbet@lwn.net>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 24/01/18 20:06, gengdongjiu wrote:
>> On 06/01/18 16:02, Dongjiu Geng wrote:
>>> The ARM64 RAS SError Interrupt(SEI) syndrome value is specific to the
>>> guest and user space needs a way to tell KVM this value. So we add a
>>> new ioctl. Before user space specifies the Exception Syndrome Register
>>> ESR(ESR), it firstly checks that whether KVM has the capability to set
>>> the guest ESR, If has, will set it. Otherwise, nothing to do.
>>>
>>> For this ESR specifying, Only support for AArch64, not support AArch32.
>>
>> After this patch user-space can trigger an SError in the guest. If it wants to migrate the guest, how does the pending SError get migrated?
>>
>> I think we need to fix migration first. Andrew Jones suggested using
>> KVM_GET/SET_VCPU_EVENTS:
>> https://www.spinics.net/lists/arm-kernel/msg616846.html
>>
>> Given KVM uses kvm_inject_vabt() on v8.0 hardware too, we should cover systems without the v8.2 RAS Extensions with the same API. I
>> think this means a bit to read/write whether SError is pending, and another to indicate the ESR should be set/read.
>> CPUs without the v8.2 RAS Extensions can reject pending-SError that had an ESR.
> 
> For the CPUs without the v8.2 RAS Extensions, its ESR is always 0, 
> we only can inject a SError with ESR 0 to guest, cannot set its ESR.

0? It's always implementation-defined. On Juno it seems to be always-0, but
other systems may behave differently. (Juno may generate another ESR value when
I'm not watching it...)

Just because we can't control the ESR doesn't mean injecting an SError isn't
something user-space may want to do.
If we tackle migration of pending-SError first, I think that will give us the
API to create a new pending SError with/without an ESR as appropriate.


> About how about to use the KVM_GET/SET_VCPU_EVENTS, I will check the code, and
> consider your suggestion at the same time.

(Not my suggestion, It was Andrew Jones idea.)

> The IOCTL KVM_GET/SET_VCPU_EVENTS has been used by X86.

We would be re-using the struct to have values with slightly different meanings.
But for migration the upshot is the same, call KVM_GET_VCPU_EVENTS on one
system, and pass the struct to KVM_SET_VCPU_EVENTS on the new system. If we're
lucky Qemu may be able to do this in shared x86/arm64 code.


>>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c index
>>> 5c7f657..738ae90 100644
>>> --- a/arch/arm64/kvm/guest.c
>>> +++ b/arch/arm64/kvm/guest.c
>>> @@ -277,6 +277,11 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
>>>  	return -EINVAL;
>>>  }
>>>
>>> +int kvm_arm_set_sei_esr(struct kvm_vcpu *vcpu, u32 *syndrome) {
>>> +	return -EINVAL;
>>> +}
>>
>> Does nothing in the patch that adds the support? This is a bit odd.
>> (oh, its hiding in patch 6...)
> 
> To make this patch simple and small, I add it in patch 6.

But that made the functionality of this patch: A new API to return -EINVAL from
the kernel.

Swapping the patches round would have avoided this.
Regardless, I think this will fold out in a rebase.


Thanks,

James
