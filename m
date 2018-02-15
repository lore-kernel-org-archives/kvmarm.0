From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v9 3/7] acpi: apei: Add SEI notification type support
 for ARMv8
Date: Thu, 15 Feb 2018 17:55:08 +0000
Message-ID: <5A85C97C.5080605@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F201AC71DE@DGGEMA503-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F201AC71DE@DGGEMA503-MBS.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "bp@alien8.de" <bp@alien8.de>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "corbet@lwn.net" <corbet@lwn.net>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu, liu jun

On 05/02/18 11:24, gengdongjiu wrote:
> James Morse wrote:
>> I'd like to pick these patches onto the end of that series, but first I want to
>> know what NOTIFY_SEI means for any OS. The ACPI spec doesn't say, and
>> because its asynchronous, route-able and mask-able, there are many more
>> corners than NOTFIY_SEA.
>>
>> This thing is a notification using an emulated SError exception. (emulated
>> because physical-SError must be routed to EL3 for firmware-first, and
>> virtual-SError belongs to EL2).
>>
>> Does your firmware emulate SError exactly as the TakeException() pseudo code
>> in the Arm-Arm?
> 
> Yes, it is.
> 
>> Is the emulated SError routed following the routing rules for HCR_EL2.{AMO,
>> TGE}?
> 
> Yes, it is.

... and yet ...


>> What does your firmware do when it wants to emulate SError but its masked?
>> (e.g.1: The physical-SError interrupted EL2 and the SPSR shows EL2 had
>> PSTATE.A  set.
>>  e.g.2: The physical-SError interrupted EL2 but HCR_EL2 indicates the
>> emulated  SError should go to EL1. This effectively masks SError.)
> 
> Currently we does not consider much about the mask status(SPSR).

.. this is a problem.

If you ignore SPSR_EL3 you may deliver an SError to EL1 when the exception
interrupted EL2. Even if you setup the EL1 register correctly, EL1 can't eret to
EL2. This should never happen, SError is effectively masked if you are running
at an EL higher than the one its routed to.

More obviously: if the exception came from the EL that SError should be routed
to, but PSTATE.A was set, you can't deliver SError. Masking SError is the only
way the OS has to indicate it can't take an exception right now. VBAR_EL1 may be
'wrong' if we're doing some power-management, the FAR/ELR/ESR/SPSR registers may
contain live values that the OS would lose if you deliver another exception over
the top.

If you deliver an emulated-SError as the OS eret's, your new ELR will point at
the eret instruction and the CPU will spin on this instruction forever.

You have to honour the masking and routing rules for SError, otherwise no OS can
run safely with this firmware.


> I remember that you ever suggested firmware should reboot if the mask status
> is set(SPSR), right?

Yes, this is my suggestion of what to do if you can't deliver an SError: store
the RAS error in the BERT and 'reboot'.


> I CC "liu jun" <liujun88@hisilicon.com> who is our UEFI firmware Architect,
> if you have firmware requirements, you can raise again.

(UEFI? I didn't think there was any of that at EL3, but I'm not familiar with
all the 'PI' bits).

The requirement is your emulated-SError from EL3 looks exactly like a
physical-SError as if EL3 wasn't implemented.
Your CPU has to handle cases where it can't deliver an SError, your emulation
has to do the same.

This is not something any OS can work around.


>> Answers to these let us determine whether a bug is in the firmware or the
>> kernel. If firmware is expecting the OS to do something special, I'd like to know
>> about it from the beginning!
> 
> I know your meaning, thanks for raising it again.


Happy new year,

James
