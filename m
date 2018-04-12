From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH v9 3/7] acpi: apei: Add SEI notification type support for ARMv8
Date: Thu, 12 Apr 2018 13:00:22 +0800
Message-ID: <CAMj-D2CEcNjdi8VkSMw0aTqeb678nFnBKiq5ggix3gJhzkgSEA@mail.gmail.com>
References: <0184EA26B2509940AA629AE1405DD7F201AC71DE@DGGEMA503-MBS.china.huawei.com>
 <5A85C97C.5080605@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5A85C97C.5080605@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>, lishuo1@hisilicon.com, merry.libing@hisilicon.com
Cc: gengdongjiu <gengdongjiu@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "Liujun (Jun Liu)" <liujun88@hisilicon.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "will.deacon@arm.com" <will.deacon@arm.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, "lv.zheng@intel.com" <lv.zheng@intel.com>, Huangshaoyu <huangshaoyu@huawei>
List-Id: kvmarm@lists.cs.columbia.edu

Dear James,
        Thanks for this mail and sorry for my late response.


2018-02-16 1:55 GMT+08:00 James Morse <james.morse@arm.com>:
> Hi gengdongjiu, liu jun
>
> On 05/02/18 11:24, gengdongjiu wrote:
[....]
>>
>>> Is the emulated SError routed following the routing rules for HCR_EL2.{AMO,
>>> TGE}?
>>
>> Yes, it is.
>
> ... and yet ...
>
>
>>> What does your firmware do when it wants to emulate SError but its masked?
>>> (e.g.1: The physical-SError interrupted EL2 and the SPSR shows EL2 had
>>> PSTATE.A  set.
>>>  e.g.2: The physical-SError interrupted EL2 but HCR_EL2 indicates the
>>> emulated  SError should go to EL1. This effectively masks SError.)
>>
>> Currently we does not consider much about the mask status(SPSR).
>
> .. this is a problem.
>
> If you ignore SPSR_EL3 you may deliver an SError to EL1 when the exception
> interrupted EL2. Even if you setup the EL1 register correctly, EL1 can't eret to
> EL2. This should never happen, SError is effectively masked if you are running
> at an EL higher than the one its routed to.
>
> More obviously: if the exception came from the EL that SError should be routed
> to, but PSTATE.A was set, you can't deliver SError. Masking SError is the only

James, I  summarized the masking and routing rules for SError to
confirm with you for the firmware first solution,

1. If the HCR_EL2.{AMO,TGE} is set, which means the SError should route to EL2,
When system happens SError and trap to EL3,   If EL3 find
HCR_EL2.{AMO,TGE} and SPSR_EL3.A are both set,
and find this SError come from EL2, it will not deliver an SError:
store the RAS error in the BERT and 'reboot'; but if
it find that this SError come from EL1 or EL0, it also need to deliver
an SError, right?


2. If the HCR_EL2.{AMO,TGE} is not set, which means the SError should
route to EL1,
When system happens SError and trap to EL3, If EL3 find
HCR_EL2.{AMO,TGE} and SPSR_EL3.A are both not set,
and find this SError come from EL1, it will not deliver an SError:
store the RAS error in the BERT and 'reboot'; but if
it find that this SError come from EL0, it also need to deliver an
SError, right?


> way the OS has to indicate it can't take an exception right now. VBAR_EL1 may be
> 'wrong' if we're doing some power-management, the FAR/ELR/ESR/SPSR registers may
> contain live values that the OS would lose if you deliver another exception over
> the top.
>
> If you deliver an emulated-SError as the OS eret's, your new ELR will point at
> the eret instruction and the CPU will spin on this instruction forever.
>
> You have to honour the masking and routing rules for SError, otherwise no OS can
> run safely with this firmware.
>
>
>> I remember that you ever suggested firmware should reboot if the mask status
>> is set(SPSR), right?
>
> Yes, this is my suggestion of what to do if you can't deliver an SError: store
> the RAS error in the BERT and 'reboot'.
>
>
>> I CC "liu jun" <liujun88@hisilicon.com> who is our UEFI firmware Architect,
>> if you have firmware requirements, you can raise again.
>
> (UEFI? I didn't think there was any of that at EL3, but I'm not familiar with
> all the 'PI' bits).
>
> The requirement is your emulated-SError from EL3 looks exactly like a
> physical-SError as if EL3 wasn't implemented.
> Your CPU has to handle cases where it can't deliver an SError, your emulation
> has to do the same.
>
> This is not something any OS can work around.
>
>
>>> Answers to these let us determine whether a bug is in the firmware or the
>>> kernel. If firmware is expecting the OS to do something special, I'd like to know
>>> about it from the beginning!
>>
>> I know your meaning, thanks for raising it again.
>
>
> Happy new year,
>
> James
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
