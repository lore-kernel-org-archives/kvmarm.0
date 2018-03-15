From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v9 5/7] arm64: kvm: Introduce KVM_ARM_SET_SERROR_ESR ioctl
Date: Thu, 15 Mar 2018 20:46:25 +0000
Message-ID: <5AAADBA1.1000804@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F201A9E8EA@DGGEMA503-MBS.china.huawei.com> <5A70C5A0.1050600@arm.com> <d1b17dae-9d9c-970a-d164-a41c618d449b@huawei.com> <5A7DDDEE.9050306@arm.com> <93d07d3e-8388-7814-d674-538071d84e2a@huawei.com> <5A85C974.70500@arm.com> <CAMj-D2COh4xDKreZXPHeiJK34mrPqDbHszDWY-fz_SfxTRaHQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMj-D2COh4xDKreZXPHeiJK34mrPqDbHszDWY-fz_SfxTRaHQA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdj.1984@gmail.com>, drjones@redhat.com
Cc: gengdongjiu <gengdongjiu@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "will.deacon@arm.com" <will.deacon@arm.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, "lv.zheng@intel.com" <lv.zheng@intel.com>, Huangshaoyu <huangshaoyu@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 08/03/18 06:18, gengdongjiu wrote:
> Hi James,
>    sorry for my late response due to chines new year.

Happy new year,


> 2018-02-16 1:55 GMT+08:00 James Morse <james.morse@arm.com>:
>> On 12/02/18 10:19, gengdongjiu wrote:
>>> On 2018/2/10 1:44, James Morse wrote:
>>>> The point? We can't know what a CPU without the RAS extensions puts in there.
>>>>
>>>> Why Does this matter? When migrating a pending SError we have to know the
>>>> difference between 'use this 64bit value', and 'the CPU will generate it'.
>>>> If I make an SError pending with ESR=0 on a CPU with VSESR, I can't migrated to
>>>> a system that generates an impdef SError-ESR, because I can't know it will be 0.
>>
>>> For the target system, before taking the SError, no one can know whether its syndrome value
>>> is IMPLEMENTATION DEFINED or architecturally defined.
>>
>> For a virtual-SError, the hypervisor knows what it generated. (do I have
>> VSESR_EL2? What did I put in there?).
>>
>>
>>> when the virtual SError is taken, the ESR_ELx.IDS will be updated, then we can know
>>> whether the ESR value is impdef or architecturally defined.
>>
>> True, the guest can't know anything about a pending virtual SError until it
>> takes it. Why is this a problem?
>>
>>
>>> It seems migration is only allowed only when target system and source system all support
>>> RAS extension, because we do not know whether its syndrome is IMPLEMENTATION DEFINED or
>>> architecturally defined.
>>
>> I don't think Qemu allows migration between hosts with differing guest-ID
>> registers. But we shouldn't depend on this, and we may want to hide the v8.2 RAS
>> features from the guest's ID register, but still use them from the host.
>>
>> The way I imagined it working was we would pack the following information into
>> that events struct:
>> {
>>         bool serror_pending;
>>         bool serror_has_esr;
>>         u64  serror_esr;
>> }
> 
> I have used your suggestion struct

Ah! This is where it came from. Sorry, this was just to illustrate the
information/sizes we wanted to transfer.... I didn't mean it literally.

I should have said "64 bits of ESR, so that we can transfer anything that is
added to VSESR_EL2 in the future, a flag somewhere to indicate an serror is
pending, and another flag to indicate the ESR has a value we should use".


Thanks/Sorry!

James


>> The problem I was trying to describe is because there is no value of serror_esr
>> we can use to mean 'Ignore this, I'm a v8.0 CPU'. VSESR_EL2 is a 64bit register,
>> any bits we abuse may get a meaning we want to use in the future.
>>
>> When it comes to migration, v8.{0,1} systems can only GET/SET events where
>> serror_has_esr == false, they can't use the serror_esr. On v8.2 systems we
>> should require serror_has_esr to be true.
> yes, I agreed.
> 
>>
>> If we need to support migration from v8.{0,1} to v8.2, we can make up an impdef
>> serror_esr.
> 
> For the Qemu migration, I need to check more the QEMU code.


> Hi Andrew,
>       I use KVM_GET/SET_VCPU_EVENTS IOCTL to migrate the Serror
> exception status of VM,
> The even struct is shown below:
> 
> {
>       bool serror_pending;
>       bool serror_has_esr;
>      u64  serror_esr;
> }
> 
> Only when the target machine is armv8.2, it needs to set the
> serror_esr(SError Exception Syndrome Register).
> for the armv8.0,  software can not set the serror_esr(SError Exception
> Syndrome Register).
> so when migration from v8.{0,1} to v8.2, QEMU should make up an impdef
> serror_esr for the v8.2 target.
> can you give me some suggestion how to set that register in the QEMU?
> I do not familar with the QEMU migration.
> Thanks very much.
