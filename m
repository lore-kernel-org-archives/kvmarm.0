From: James Morse <james.morse@arm.com>
Subject: Re: =?UTF-8?B?562U5aSNOiBbUEFUQ0ggdjYgNi83XSBLVk06IGFybTY0OiBhbGw=?=
 =?UTF-8?B?b3cgZ2V0IGV4Y2VwdGlvbiBpbmZvcm1hdGlvbiBmcm9tIHVzZXJzcGFjZQ==?=
Date: Fri, 06 Oct 2017 17:46:29 +0100
Message-ID: <59D7B365.3020503@arm.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-7-git-send-email-gengdongjiu@huawei.com>
 <59B17438.5070501@arm.com> <2a42d1ea-3456-2873-c9ea-d8a027b59789@huawei.com>
 <59BA7D72.4090403@arm.com> <5af0cb96-be13-4cc4-13bb-1f608cdc171c@huawei.com>
 <59C53CB9.5000003@arm.com>
 <0184EA26B2509940AA629AE1405DD7F20164F660@DGGEMA503-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0145C49D18
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Oct 2017 12:47:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AgAa8bl9Latt for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Oct 2017 12:47:41 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 521D940A74
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Oct 2017 12:47:41 -0400 (EDT)
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F20164F660@DGGEMA503-MBS.china.huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: "Wangkefeng (Kevin)" <wangkefeng.wang@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "david.daney@cavium.com" <david.daney@cavium.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tbaicar@codeaurora.org" <tbaicar@codeaurora.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Linuxarm <linuxarm@huawei.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "mingo@kernel.org" <mingo@kernel.org>, "stefan@hello-penguin.com" <stefan@hello-penguin.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Huangshaoyu <huangshaoyu@huawei.com>, huangdaode <huangdaode@hisilicon.com>, "bp@suse.de" <bp@suse.de>, "Dave.Martin@arm.com" <Dave.Martin@ar>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 25/09/17 16:13, gengdongjiu wrote:
> On 2017/9/23 0:39, James Morse wrote:
>> On 18/09/17 14:36, gengdongjiu wrote:
>>> On 2017/9/14 21:00, James Morse wrote:
>>>> On 13/09/17 08:32, gengdongjiu wrote:
>>> Then for "BUS_MCEERR_AO", how to distinguish it is asynchronous data access(SError) and PCIE AER error?
>>
>> How would userspace get one of these memory errors for a PCIe error?
> 
> seems Ok.
> Now I only add the support for the host SEI and SEA virtualization. For the PCIe error, I still do not consider much it.
> maybe we need to consider that afterwards.

Any PCIe AER error should be handled by the device driver. If user-space is
interacting with the device-driver directly, its up to them to come up with a
way of reporting errors.


>>> In the user space, we can check the si_code, if it is 
>>> "BUS_MCEERR_AR", we use SEA notification type for the guest; if it is "BUS_MCEERR_AO", we use SEI notification type for the guest.
>>> Because there are only two values for si_code("BUS_MCEERR_AR" and BUS_MCEERR_AO), in which case we can use the GSIV(IRQ) notification type?
>>
>> This is for Qemu/kvmtool to decide, it depends on what sort of machine 
>> they are emulating.
>>
>> For example, the physical machine's memory-controller may notify the 
>> CPU about memory errors by triggering SError trapped to EL3, or with a 
>> dedicated FIQ, also routed to EL3. By the time this gets to the host 
>> kernel the distinction doesn't matter. The host has handled the error.
>>
>> For a guest, your memory-controller is effectively the host kernel. It 
>> will give you an BUS_MCEERR_AO signal for any guest memory that is 
>> affected, and a BUS_MCEERR_AR if the guest directly accesses a page of affected memory.
>>
>> What Qemu/kvmtool do with this is up to them. If they're emulating a 
>> machine with no RAS features, printing an error and exit.
>>
>> Otherwise BUS_MCEERR_AR could be notified as one of the flavours of 
>> IRQ, unless the affected vcpu has interrupts masked, in which case an 
>> SEA notification gives you some NMI-like behaviour.

> Thanks for explanation. 
> Now that SEA notification can provide NMI-like behaviour. How about we use it for
> BUS_MCEERR_AR to avoid check the interrupts mask status?

... yes, that's the suggestion. Qemu/kvmtool can take MCEERR_AR from KVM and
SET_ONE_REG the vcpu into taking a synchronous-external-abort instead.

(but there is trouble ahead where this suggestion unravels)


> Even though guest OS not support SEA notification, It is still a valid
> guest:Synchronous-external-abort

When it comes from KVM, Yes.

If you think of linux+KVM's stage2 translation as your guests memory controller.
It is effectively guaranteeing you to:
1. 'interrupt' userspace with MCEERR_AO when it detects an error,
2. contain it (by unmapping and marking the page PG_poison) then,
3. give you a synchronous external abort with MCEERR_AR if the guest touches the
contained memory.

This is fine when the MCEERR_AR came from KVM, what we need to find out is
whether this will still be true for some future kernel code that sends MCEERR_AR...


>> For BUS_MCEERR_AO you could use SEI, IRQ or polled notification. My 
>> choice would be IRQ, as you can't know if the guest supports SEI and 
>> it would be a shame to
> 
> How about we first check whether user space can specify the virtual SError Exception Syndrome(have vsesr_el2 register)?
> If can specify, using SEI notification, otherwise use IRQ notification. 
> The advantage is that it can pass more error information than IRQ if can specify Syndrome information.

If this is for APEI firmware-first, its the severity in the CPER records that
matters, so the SEI/IRQ choice doesn't matter if the guest supports both.

But its unlikely the guest supports both. (v4.14 doesn't).
If you pick IRQ and the guest doesn't support it, nothing happens, the guest
never takes the IRQ. You take the memory-error as a MCEERR_AR some time later.

If you pick SEI and the guest doesn't support it, the guest dies of an unknown
SError.

I would pick POLLed by default, as this would let the Qemu/kvmtool code that
does this work be portable between x86 and arm64.

[...]

>>> If call memory_failure(), memory_failure can translate the PA to host 
>>> VA, then deliver host VA to Qemu.
>>
>> Yes, this is how it works for any user-space process as two processes 
>> sharing the same page may map it in different locations.
>>
>>
>>> Qemu can translate the host VA to IPA. so we rely on memory_failure() 
>>> to get the IPA.
>>
>> Yes. I don't see why this is a problem: The kernel isn't going to pass 
>> RAS events into the guest, so it never needs to know the IPA.
>>
>> Instead we notify user-space about ranges of memory affected by 
>> memory_failure(), KVM's user-space isn't a special case here.
>>
>> As you point out, if Qemu wants to notify the guest it can calculate 
>> the IPA and either use CPER for firmware-first, or in the future, 
>> update some representation of the v8.2 ERR records once we can virtualise kernel-first.
>>
>> (I'm not sure I understand your point here, but I don't think we 
>> disagree,)

> Yes, I only describe the workflow, not think we do not disagree.

(double negative?)


> If not pass exception information to user space, there is another issue.
> As our agreement, if we want to inject a Synchronous-external-abort, we let Qemu/kvmtool injects it.

Yes, because all we do for user space is send it MCEERR_AR when this happens.

KVM only does this to make guest-accesses the same as user-space accesses.
(See arm64's do_page_fault() and x86's do_sigbus() for the regular path)


> when Qemu injecting it, it needs to set the value of FAR_EL1 with the value of FAR_EL2. but if we do not 
> pass the far_el2's value to user space, Qemu will have to set the FAR_EL1 to 0, then FAR_EL1's value is invalid.
> The FAR_EL1 usually is used to save the fault guest VA. 

Yes, Qemu doesn't know the the guest VA, but it doesn't need to for this
mechanism to work: Set the DFSC to '0b010000 Synchronous external abort, not on
translation table walk', then set 'FnV - Far Not Valid'.

...

But there is one piece of information Qemu needs here but doesn't have: whether
this was an instruction or a data abort, which you need to pick the correct EC.

Ideally, this would come with the signal, but that doesn't happen today.

I don't think user-space generally needs to know this, only a JIT is likely to
be able to handle these errors, and it would know which regions were code or data.

So it looks like we really do need more information from KVM, and guests have to
be a special-case here. Bother.

I'll try and put together an RFC to let user-space generate a believable
architectural exception when it gets this signal.


> Of course, if guest cannot get the fault VA from the FAR_EL1. it still can read the CPER to get
> the guest fault PA and translate it to fault VA.

_A_ fault VA, there may be a set of them. This is why memory_failure() walks the
rmap to find all the users of the page, and why the faulting VA isn't really
relevant for this sort of RAS error.


Thanks,

James
