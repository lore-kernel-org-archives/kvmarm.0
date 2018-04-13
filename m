From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v9 3/7] acpi: apei: Add SEI notification type support for
 ARMv8
Date: Fri, 13 Apr 2018 21:50:30 +0800
Message-ID: <c3cc260b-ed4f-c77c-2fac-36a68eb50c8a@huawei.com>
References: <0184EA26B2509940AA629AE1405DD7F201AC71DE@DGGEMA503-MBS.china.huawei.com>
 <5A85C97C.5080605@arm.com>
 <CAMj-D2CEcNjdi8VkSMw0aTqeb678nFnBKiq5ggix3gJhzkgSEA@mail.gmail.com>
 <649fa2f6-1823-116e-fe69-aeaaa6a508af@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <649fa2f6-1823-116e-fe69-aeaaa6a508af@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>, gengdongjiu <gengdj.1984@gmail.com>
Cc: lishuo1@hisilicon.com, merry.libing@hisilicon.com, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "Liujun (Jun Liu)" <liujun88@hisilicon.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "will.deacon@arm.com" <will.deacon@arm.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, "lv.zheng@intel.com" <lv.zheng@intel.com>Huangshaoyu <h>
List-Id: kvmarm@lists.cs.columbia.edu

James,
   Thanks for this mail.

On 2018/4/13 0:14, James Morse wrote:
> Hi gengdongjiu,
> 
> On 12/04/18 06:00, gengdongjiu wrote:
>> 2018-02-16 1:55 GMT+08:00 James Morse <james.morse@arm.com>:
>>> On 05/02/18 11:24, gengdongjiu wrote:
>>>>> Is the emulated SError routed following the routing rules for HCR_EL2.{AMO,
>>>>> TGE}?
>>>>
>>>> Yes, it is.
>>>
>>> ... and yet ...
>>>
>>>
>>>>> What does your firmware do when it wants to emulate SError but its masked?
>>>>> (e.g.1: The physical-SError interrupted EL2 and the SPSR shows EL2 had
>>>>> PSTATE.A  set.
>>>>>  e.g.2: The physical-SError interrupted EL2 but HCR_EL2 indicates the
>>>>> emulated  SError should go to EL1. This effectively masks SError.)
>>>>
>>>> Currently we does not consider much about the mask status(SPSR).
>>>
>>> .. this is a problem.
>>>
>>> If you ignore SPSR_EL3 you may deliver an SError to EL1 when the exception
>>> interrupted EL2. Even if you setup the EL1 register correctly, EL1 can't eret to
>>> EL2. This should never happen, SError is effectively masked if you are running
>>> at an EL higher than the one its routed to.
>>>
>>> More obviously: if the exception came from the EL that SError should be routed
>>> to, but PSTATE.A was set, you can't deliver SError. Masking SError is the only
> 
>> James, I  summarized the masking and routing rules for SError to
>> confirm with you for the firmware first solution,
> 
> You also said "Currently we does not consider much about the mask status(SPSR)."
Yes, we currently do not consider much it. After clarification with you, we want to modify the EL3 firmware to follow this rule.

> 
> 
>> 1. If the HCR_EL2.{AMO,TGE} is set,
> 
> If one or the other of these bits is set: (AMO==1 || TGE==1)
> 
>> which means the SError should route to EL2,
>> When system happens SError and trap to EL3,   If EL3 find
>> HCR_EL2.{AMO,TGE} and SPSR_EL3.A are both set,
>> and find this SError come from EL2, it will not deliver an SError:
>> store the RAS error in the BERT and 'reboot'; but if
>> it find that this SError come from EL1 or EL0, it also need to deliver
>> an SError, right?
> 
> Yes.
> 
> 
>> 2. If the HCR_EL2.{AMO,TGE} is not set,
> 
> If neither of these bits is set: (AMO==0 && TGE == 0)
> 
>> which means the SError should route to EL1,
>> When system happens SError and trap to EL3, If EL3 find
>> HCR_EL2.{AMO,TGE} and SPSR_EL3.A are both not set,
> 
> (I'm reading this as all three of these bits are clear)
sorry, it is a typo issue.
it should be HCR_EL2.AMO and HCR_EL2.TGE are both clear, but SPSR_EL3.A is set.

> 
>> and find this SError come from EL1, it will not deliver an SError:
>> store the RAS error in the BERT and 'reboot'; 
> 
> No, (AMO==0 && TGE == 0) means SError is routed to EL1, this exception
> interrupted EL1 and the A bit was clear, so EL1 can take an SError.

Agree.

> 
> The two cases here are:
> AMO==0,TGE==0 means SError should be routed to EL1. If SPSR_EL3 says the
> exception interrupted EL1 and the A bit was set, you need to do the BERT trick.

> 
> If SPSR_EL3 says the exception interrupted EL2, you need to do the BERT trick
"BERT trick" is storing the RAS error in the BERT and 'reboot, right?

> regardless of the A bit, as SError is implicitly masked by running at a higher
> exception level than it was routed to.


> 
> 
>>From your v11 reply:
>> 2. The exception came from the EL that SError should not be routed
>> to(according to hcr_EL2.{AMO, TGE}),even though the PSTATE.A was set,EL3
>> firmware still deliver SError
> 
> (this is re-iterating the two-cases above:)
> 'not be routed to' is one of two things: Route-to-EL2+interruted-EL1, or
> Route-to-EL1+interrupted-EL2.
> 
> Route-to-EL2+interrupted-EL1 is fine, regardless of SPSR_EL3.A the emulated
> SError can be delivered to EL2, as EL2 can't mask SError when executing at a
> lower EL.
Agree.

> 
> Route-to-EL1+interrupted-EL2 is the problem. SError is implicitly masked by
> running at a higher EL. Regardless of SPSR_EL3.A, the emulated SError can not be
> delivered.
"can not be delivered" means storing the RAS error in the BERT and 'reboot, right?
In the Table D1-15 in "D1.14.2 Asynchronous exception masking", for the case, it is "C"
"C"means SError is not taken regardless of the value of the Process state interrupt mask.
for this case, whether it will be unsafe if  BIOS directly reboot?


> KVM does this on the way out of a guest, if an SError occurs during this time
> the CPU will wait until execution returns to EL1 before delivering the SError.
> Your firmware has to do the same.
> 
> Table D1-15 in "D1.14.2 Asynchronous exception masking" has a table with all the
> combinations. The ARM-ARM is what we need to match with this behaviour.
> 
> 
>> but if it find that this SError come from EL0, it also need to deliver an
>> SError, right?
> 
> I thought interrupted-EL0 could always be delivered: but re-reading the
> ARM-ARM's "D1.14.2 Asynchronous exception masking", if asynchronous exceptions
> are routed to EL1 then EL0&EL1 are treated the same.
> So if SError is routed to EL1, the exception interrupted EL0, and SPSR_EL3.A was
> set, you still can't deliver the emulated-SError you have to do the BERT-trick.
> Linux doesn't do this today, but another OS might (e.g. UEFI), and we might do
> this in the future.
For this case, whether it will be unsafe if  BIOS directly reboot?
For example, for some test purpose, EL0 set PSTATE.A, just right happen SError, then BIOS will reboot system.
I am afraid that system will become unsafe because BIOS will reboot system.

> 
> This is really tricky for firmware to get right. Another alternative would be to
> put the CPER records in a Polled buffer, unless something needs doing right now,
> in which case a BERT-reboot is probably best.

In summary:

[1]:
Route-to-EL1 + interrupted-EL1, if SPSR_EL3.A is set, EL3 firmware can't deliver the emulated-SError, store the RAS error in the BERT and 'reboot.
Route-to-EL2 + interrupted-EL2, if SPSR_EL3.A is set, EL3 firmware can't deliver the emulated-SError, store the RAS error in the BERT and 'reboot.

I agree above two cases, but maybe we need to ensure that only in EL2 SError handler and EL1 SError exception handler the PSTATE.A is set, for other places, the PSTATE.A is not set.
then BIOS can know this is nested-SError when find the SPSR_EL3.A is set, can we ensure that in the Linux kernel code and KVM code?

[2]:
Route-to-EL2 + interrupted-EL1, regardless of SPSR_EL3.A the emulated SError can be delivered to EL2.
Route-to-EL2 + interrupted-EL0, regardless of SPSR_EL3.A the emulated SError can be delivered to EL2.

I agree above two cases.

[3]:
Route-to-EL1+interrupted-EL0, if SPSR_EL3.A is set, EL3 firmware can't deliver the emulated-SError, store the RAS error in the BERT and 'reboot
Route-to-EL1+interrupted-EL2, EL3 firmware store the RAS error in the BERT and 'reboot regardless of SPSR_EL3.A.

For above two cases, I am worried system will become unsafe because BIOS will reboot system.


> 
> 
> Thanks,
> 
> James
> 
> .
> 
