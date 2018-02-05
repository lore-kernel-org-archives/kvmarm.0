From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v9 3/7] acpi: apei: Add SEI notification type support
 for ARMv8
Date: Mon, 5 Feb 2018 11:24:26 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F201AC71DE@DGGEMA503-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-doc-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "bp@alien8.de" <bp@alien8.de>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "corbet@lwn.net" <corbet@lwn.net>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

[...]
> 
> > Yes, I know you are dong that. Your serial's patch will consider all above
> things, right?
> 
> Assuming I got it right, yes. It currently makes the race Xie XiuQi spotted worse,
> which I want to fix too. (details on the cover letter)

Ok.

> 
> 
> > If your patch can be consider that, this patch can based on your patchset.
> thanks.
> 
> I'd like to pick these patches onto the end of that series, but first I want to
> know what NOTIFY_SEI means for any OS. The ACPI spec doesn't say, and
> because its asynchronous, route-able and mask-able, there are many more
> corners than NOTFIY_SEA.
> 
> This thing is a notification using an emulated SError exception. (emulated
> because physical-SError must be routed to EL3 for firmware-first, and
> virtual-SError belongs to EL2).
> 
> Does your firmware emulate SError exactly as the TakeException() pseudo code
> in the Arm-Arm?

Yes, it is.

> Is the emulated SError routed following the routing rules for HCR_EL2.{AMO,
> TGE}?

Yes, it is.

> What does your firmware do when it wants to emulate SError but its masked?
> (e.g.1: The physical-SError interrupted EL2 and the SPSR shows EL2 had
> PSTATE.A  set.
>  e.g.2: The physical-SError interrupted EL2 but HCR_EL2 indicates the
> emulated  SError should go to EL1. This effectively masks SError.)

Currently we does not consider much about the mask status(SPSR).
I remember that you ever suggested firmware should reboot if the mask status is set(SPSR), right?
I ever suggest our firmware team to evaluate that, but there is no response.

I CC "liu jun" <liujun88@hisilicon.com> who is our UEFI firmware Architect, if you have firmware requirements, you can
raise again.

> 
> Answers to these let us determine whether a bug is in the firmware or the
> kernel. If firmware is expecting the OS to do something special, I'd like to know
> about it from the beginning!

I know your meaning, thanks for raising it again.

> 
> 
> >>> Expose API ghes_notify_sei() to external users. External modules can
> >>> call this exposed API to parse APEI table and handle the SEI
> >>> notification.
> >>
> >> external modules? You mean called by the arch code when it gets this
> NOTIFY_SEI?
> 
> > yes, called by kernel ARCH code, such as below, I remember I have discussed
> with you.
> 
> Sure. The phrase 'external modules' usually means the '.ko' files that live in
> /lib/modules, nothing outside the kernel tree should be doing this stuff.

I will rename 'external modules' to other name. Thanks.

> 
> 
> Thanks,
> 
> James

