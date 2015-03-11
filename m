From: Feng Kan <fkan@apm.com>
Subject: Re: [PATCH] arm64: dts: Fix GIC reg sizes for APM X-Gene
Date: Wed, 11 Mar 2015 10:57:22 -0700
Message-ID: <CAL85gmDVfop1_roHyLTRzFY3BahzTWs7nwbpmZD7emFKcFHyLg@mail.gmail.com>
References: <1422342206-4750-1-git-send-email-psawargaonkar@apm.com>
 <550056FD.8060804@arm.com>
 <CAL85gmCuB4LfNp+6B8cL9+emFqWPM6W9gevTzibyaAzL+7jVdg@mail.gmail.com>
 <55007BE3.30300@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8E724888B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 13:51:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b9RfmHWupd4s for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2015 13:51:03 -0400 (EDT)
Received: from mail-ob0-f176.google.com (exprod5og120.obsmtp.com [64.18.0.137])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F123648888
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 13:51:02 -0400 (EDT)
Received: by obcva8 with SMTP id va8so10620300obc.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 10:57:23 -0700 (PDT)
In-Reply-To: <55007BE3.30300@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Tushar Jagad <tjagad@apm.com>, Pranavkumar Sawargaonkar <psawargaonkar@apm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 11, 2015 at 10:31 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 11/03/15 17:19, Feng Kan wrote:
>> On Wed, Mar 11, 2015 at 7:53 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> On 27/01/15 07:03, Pranavkumar Sawargaonkar wrote:
>>>> In APM X-Gene, GIC register space is 64K aligned while the sizes mentioned
>>>> in the dt are 4K aligned. This breaks KVM when kernel is built with 64K page
>>>> size due to size alignment checking in vgic driver for VCPU Control and
>>>> VCPU register.
>>>>
>>>> This patch corrects the sizes to be inline with the hardware spec.
>>>
>>> This patch may be correct, but it is useless. The firmware on my APM
>>> system (some version of u-boot) repaints the DT at boot time, negating
>>> the effect of this patch.
>> We have updated u-boot to reflect this change. I can supply you with a updated
>> image if you wish.
>
> That would be useful, thanks.
>
> But more importantly, why bother upstreaming your DT into the kernel
> tree if your firmware is going to overwrite whatever we provide?
We did tried to submit a version upstream but was rejected.

>
> Either the firmware let the user provide its own DT (and doesn't touch
> it other than to change the CPU enable method, insert a /memreserve/ or
> similar things), or the firmware always provide its own DT, and doesn't
> let the user provide its own. Corrupting the user DT is a disaster, as
> we just found.
Yes, the intent of the change is listed in the link below. It is not a
justification by any means,
just the effects of things appearing in layers.
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/288574.html

>
> Thanks,
>
>         M.
>
>>>
>>> Another system I can remove from my 64k-capable list.
>>>
>>>         M.
>>>
>>>> CC: linux-arm-kernel@lists.infradead.org
>>>> CC: kvmarm@lists.cs.columbia.edu
>>>> CC: arnd@arndb.de
>>>> CC: marc.zyngier@arm.com
>>>> CC: christoffer.dall@linaro.org
>>>> CC: jcm@redhat.com
>>>> Signed-off-by: Pranavkumar Sawargaonkar <psawargaonkar@apm.com>
>>>> Signed-off-by: Tushar Jagad <tjagad@apm.com>
>>>> Signed-off-by: Feng Kan <fkan@apm.com>
>>>> ---
>>>>  arch/arm64/boot/dts/apm/apm-storm.dtsi |    8 ++++----
>>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/boot/dts/apm/apm-storm.dtsi b/arch/arm64/boot/dts/apm/apm-storm.dtsi
>>>> index f1ad9c2..65f0e6d 100644
>>>> --- a/arch/arm64/boot/dts/apm/apm-storm.dtsi
>>>> +++ b/arch/arm64/boot/dts/apm/apm-storm.dtsi
>>>> @@ -81,10 +81,10 @@
>>>>               compatible = "arm,cortex-a15-gic";
>>>>               #interrupt-cells = <3>;
>>>>               interrupt-controller;
>>>> -             reg = <0x0 0x78010000 0x0 0x1000>,      /* GIC Dist */
>>>> -                   <0x0 0x78020000 0x0 0x1000>,      /* GIC CPU */
>>>> -                   <0x0 0x78040000 0x0 0x2000>,      /* GIC VCPU Control */
>>>> -                   <0x0 0x78060000 0x0 0x2000>;      /* GIC VCPU */
>>>> +             reg = <0x0 0x78010000 0x0 0x10000>,     /* GIC Dist */
>>>> +                   <0x0 0x78020000 0x0 0x20000>,     /* GIC CPU */
>>>> +                   <0x0 0x78040000 0x0 0x10000>,     /* GIC VCPU Control */
>>>> +                   <0x0 0x78060000 0x0 0x20000>;     /* GIC VCPU */
>>>>               interrupts = <1 9 0xf04>;       /* GIC Maintenence IRQ */
>>>>       };
>>>>
>>>> --
>>>> 1.7.9.5
>>>>
>>>>
>>>
>>>
>>> --
>>> Jazz is not dead. It just smells funny...
>>
>
>
> --
> Jazz is not dead. It just smells funny...
