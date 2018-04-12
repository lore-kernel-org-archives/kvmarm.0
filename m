From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v9 3/7] acpi: apei: Add SEI notification type support for
 ARMv8
Date: Thu, 12 Apr 2018 17:14:10 +0100
Message-ID: <649fa2f6-1823-116e-fe69-aeaaa6a508af@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F201AC71DE@DGGEMA503-MBS.china.huawei.com>
 <5A85C97C.5080605@arm.com>
 <CAMj-D2CEcNjdi8VkSMw0aTqeb678nFnBKiq5ggix3gJhzkgSEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMj-D2CEcNjdi8VkSMw0aTqeb678nFnBKiq5ggix3gJhzkgSEA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdj.1984@gmail.com>
Cc: lishuo1@hisilicon.com, merry.libing@hisilicon.com, gengdongjiu <gengdongjiu@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "Liujun (Jun Liu)" <liujun88@hisilicon.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "will.deacon@arm.com" <will.deacon@arm.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>"lv.zheng@intel.com" <l>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 12/04/18 06:00, gengdongjiu wrote:
> 2018-02-16 1:55 GMT+08:00 James Morse <james.morse@arm.com>:
>> On 05/02/18 11:24, gengdongjiu wrote:
>>>> Is the emulated SError routed following the routing rules for HCR_EL2.{AMO,
>>>> TGE}?
>>>
>>> Yes, it is.
>>
>> ... and yet ...
>>
>>
>>>> What does your firmware do when it wants to emulate SError but its masked?
>>>> (e.g.1: The physical-SError interrupted EL2 and the SPSR shows EL2 had
>>>> PSTATE.A  set.
>>>>  e.g.2: The physical-SError interrupted EL2 but HCR_EL2 indicates the
>>>> emulated  SError should go to EL1. This effectively masks SError.)
>>>
>>> Currently we does not consider much about the mask status(SPSR).
>>
>> .. this is a problem.
>>
>> If you ignore SPSR_EL3 you may deliver an SError to EL1 when the exception
>> interrupted EL2. Even if you setup the EL1 register correctly, EL1 can't eret to
>> EL2. This should never happen, SError is effectively masked if you are running
>> at an EL higher than the one its routed to.
>>
>> More obviously: if the exception came from the EL that SError should be routed
>> to, but PSTATE.A was set, you can't deliver SError. Masking SError is the only

> James, I  summarized the masking and routing rules for SError to
> confirm with you for the firmware first solution,

You also said "Currently we does not consider much about the mask status(SPSR)."


> 1. If the HCR_EL2.{AMO,TGE} is set,

If one or the other of these bits is set: (AMO==1 || TGE==1)

> which means the SError should route to EL2,
> When system happens SError and trap to EL3,   If EL3 find
> HCR_EL2.{AMO,TGE} and SPSR_EL3.A are both set,
> and find this SError come from EL2, it will not deliver an SError:
> store the RAS error in the BERT and 'reboot'; but if
> it find that this SError come from EL1 or EL0, it also need to deliver
> an SError, right?

Yes.


> 2. If the HCR_EL2.{AMO,TGE} is not set,

If neither of these bits is set: (AMO==0 && TGE == 0)

> which means the SError should route to EL1,
> When system happens SError and trap to EL3, If EL3 find
> HCR_EL2.{AMO,TGE} and SPSR_EL3.A are both not set,

(I'm reading this as all three of these bits are clear)

> and find this SError come from EL1, it will not deliver an SError:
> store the RAS error in the BERT and 'reboot'; 

No, (AMO==0 && TGE == 0) means SError is routed to EL1, this exception
interrupted EL1 and the A bit was clear, so EL1 can take an SError.

The two cases here are:
AMO==0,TGE==0 means SError should be routed to EL1. If SPSR_EL3 says the
exception interrupted EL1 and the A bit was set, you need to do the BERT trick.

If SPSR_EL3 says the exception interrupted EL2, you need to do the BERT trick
regardless of the A bit, as SError is implicitly masked by running at a higher
exception level than it was routed to.


>From your v11 reply:
> 2. The exception came from the EL that SError should not be routed
> to(according to hcr_EL2.{AMO, TGE}),even though the PSTATE.A was set,EL3
> firmware still deliver SError

(this is re-iterating the two-cases above:)
'not be routed to' is one of two things: Route-to-EL2+interruted-EL1, or
Route-to-EL1+interrupted-EL2.

Route-to-EL2+interrupted-EL1 is fine, regardless of SPSR_EL3.A the emulated
SError can be delivered to EL2, as EL2 can't mask SError when executing at a
lower EL.

Route-to-EL1+interrupted-EL2 is the problem. SError is implicitly masked by
running at a higher EL. Regardless of SPSR_EL3.A, the emulated SError can not be
delivered.
KVM does this on the way out of a guest, if an SError occurs during this time
the CPU will wait until execution returns to EL1 before delivering the SError.
Your firmware has to do the same.

Table D1-15 in "D1.14.2 Asynchronous exception masking" has a table with all the
combinations. The ARM-ARM is what we need to match with this behaviour.


> but if it find that this SError come from EL0, it also need to deliver an
> SError, right?

I thought interrupted-EL0 could always be delivered: but re-reading the
ARM-ARM's "D1.14.2 Asynchronous exception masking", if asynchronous exceptions
are routed to EL1 then EL0&EL1 are treated the same.
So if SError is routed to EL1, the exception interrupted EL0, and SPSR_EL3.A was
set, you still can't deliver the emulated-SError you have to do the BERT-trick.
Linux doesn't do this today, but another OS might (e.g. UEFI), and we might do
this in the future.

This is really tricky for firmware to get right. Another alternative would be to
put the CPER records in a Polled buffer, unless something needs doing right now,
in which case a BERT-reboot is probably best.


Thanks,

James
