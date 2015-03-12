From: Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64: dts: Fix GIC reg sizes for APM X-Gene
Date: Thu, 12 Mar 2015 09:25:07 +0000
Message-ID: <55015B73.1060606@arm.com>
References: <1422342206-4750-1-git-send-email-psawargaonkar@apm.com>	<550056FD.8060804@arm.com>	<CAL85gmCuB4LfNp+6B8cL9+emFqWPM6W9gevTzibyaAzL+7jVdg@mail.gmail.com>	<55007BE3.30300@arm.com>	<CAL85gmDVfop1_roHyLTRzFY3BahzTWs7nwbpmZD7emFKcFHyLg@mail.gmail.com>	<550086B9.4010001@arm.com> <CANFfpkQ1QyWEGwwQx1g1By=uXvctJjF8AOO+uA5CFUgO4v9DFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANFfpkQ1QyWEGwwQx1g1By=uXvctJjF8AOO+uA5CFUgO4v9DFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pranavkumar Sawargaonkar <psawargaonkar-qTEPVZfXA3Y@public.gmane.org>
Cc: Feng Kan <fkan-qTEPVZfXA3Y@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-qTEPVZfXA3Y@public.gmane.org" <patches-qTEPVZfXA3Y@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tushar Jagad <tjagad-qTEPVZfXA3Y@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

[adding RobH to the CC list, as he was commenting on the subject earlier]

Hi Pranav,

On 12/03/15 03:52, Pranavkumar Sawargaonkar wrote:
> Hi Marc,
> 
> On Wed, Mar 11, 2015 at 11:47 PM, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org> wrote:
>> On 11/03/15 17:57, Feng Kan wrote:
>>> On Wed, Mar 11, 2015 at 10:31 AM, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org> wrote:
>>>> On 11/03/15 17:19, Feng Kan wrote:
>>>>> On Wed, Mar 11, 2015 at 7:53 AM, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org> wrote:
>>>>>> On 27/01/15 07:03, Pranavkumar Sawargaonkar wrote:
>>>>>>> In APM X-Gene, GIC register space is 64K aligned while the sizes mentioned
>>>>>>> in the dt are 4K aligned. This breaks KVM when kernel is built with 64K page
>>>>>>> size due to size alignment checking in vgic driver for VCPU Control and
>>>>>>> VCPU register.
>>>>>>>
>>>>>>> This patch corrects the sizes to be inline with the hardware spec.
>>>>>>
>>>>>> This patch may be correct, but it is useless. The firmware on my APM
>>>>>> system (some version of u-boot) repaints the DT at boot time, negating
>>>>>> the effect of this patch.
>>>>> We have updated u-boot to reflect this change. I can supply you with a updated
>>>>> image if you wish.
>>>>
>>>> That would be useful, thanks.
>>>>
>>>> But more importantly, why bother upstreaming your DT into the kernel
>>>> tree if your firmware is going to overwrite whatever we provide?
>>> We did tried to submit a version upstream but was rejected.
>>>
>>>>
>>>> Either the firmware let the user provide its own DT (and doesn't touch
>>>> it other than to change the CPU enable method, insert a /memreserve/ or
>>>> similar things), or the firmware always provide its own DT, and doesn't
>>>> let the user provide its own. Corrupting the user DT is a disaster, as
>>>> we just found.
>>> Yes, the intent of the change is listed in the link below. It is not a
>>> justification by any means,
>>> just the effects of things appearing in layers.
>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/288574.html
>>
>> Yeah. This is as wrong as it can possibly be. Oh well...
> 
> Yes there is an issue with u-boot patching the dt for end user who
> wants his DT to be used, for this we can (in fact we should) provide
> an option in u-boot (may be setting some environment variable) which
> will make sure end user's DT does not get modified (apart from
> standard things like patching mac-addresses) by u-boot.

Definitely. I would even argue that not overwriting the DT should be the
default behaviour, and that you could have a compatibility mode that
repaint ancient DTs  if you want to. But at least having something would
be good. At the moment, my X-Gene board is screwed, as I don't have any
way to fix the bootloader (or even to download a binary).

> Another point I want to reopen here is the how to handle 64K GIC page
> size pointed out in this thread, what would be the best way to tackle
> this (adding a new DT string or any other way) ?

The main problem is that there is several flavours of brokenness:

- GICC_CTLR@0, GICC_DIR@0x10000, size 128kB (X-Gene)
- GICC_CTLR@0, GICC_DIR@0x1000, size 64kB (Seattle)
- GICC_CTL@0xF000, GICC_DIR@0x10000, size 8kB (Juno)
- GICC_CTL@0, GICC_DIR@0x1000, size 8kB (HiKey)

Yes, they all have a GIC400, and yet they are all irritatingly non
compliant with SBSA. As far as I can tell, nobody has correctly
implemented the expected aliasing that would have made it work.

So either we add new compatibility strings describing all the possible
way people can break things, or we introduce something like dir-offset
and ctlr-offset that would tell the driver where the two sub-regions are
placed. The default values would be:

- When size is < 8kB -> invalid configuration, this is not a GIC400.
- When size is = 8kB -> ctlr-offset = 0, dir-offset = 0x1000
- When size is = 128kB -> ctlr-offset = 0xf000, dir-offset = 0x10000

For the two first braindead systems above:
- ctlr-offset = 0, dir-offset = 0x10000 (X-Gene)
- ctlr-offset = 0, dir-offset = 0x1000; (Seattle)

and that's just enough to get bare metal going.

When it comes to virtualization, this is hell:
- We need an API to be able to expose these various offsets to
userspace, so that QEMU/kvmtool can place the GICV region at the right
location (offset within a page).
- We will also miss the capability to trap GICV_DIR independently from
the rest of the VCPU interface on systems like Seattle, which is rather bad.
- Systems that look like Juno or HiKey cannot use virtualization with
64k pages, end of story.

After writing this, I'm feeling slightly depressed...

	M.
-- 
Jazz is not dead. It just smells funny...
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
