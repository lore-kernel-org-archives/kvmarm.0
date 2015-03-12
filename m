From: Pranavkumar Sawargaonkar <psawargaonkar-qTEPVZfXA3Y@public.gmane.org>
Subject: Re: [PATCH] arm64: dts: Fix GIC reg sizes for APM X-Gene
Date: Thu, 12 Mar 2015 09:22:02 +0530
Message-ID: <CANFfpkQ1QyWEGwwQx1g1By=uXvctJjF8AOO+uA5CFUgO4v9DFg@mail.gmail.com>
References: <1422342206-4750-1-git-send-email-psawargaonkar@apm.com>
	<550056FD.8060804@arm.com>
	<CAL85gmCuB4LfNp+6B8cL9+emFqWPM6W9gevTzibyaAzL+7jVdg@mail.gmail.com>
	<55007BE3.30300@arm.com>
	<CAL85gmDVfop1_roHyLTRzFY3BahzTWs7nwbpmZD7emFKcFHyLg@mail.gmail.com>
	<550086B9.4010001@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <550086B9.4010001-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>
Cc: Feng Kan <fkan-qTEPVZfXA3Y@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-qTEPVZfXA3Y@public.gmane.org" <patches-qTEPVZfXA3Y@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tushar Jagad <tjagad-qTEPVZfXA3Y@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Wed, Mar 11, 2015 at 11:47 PM, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org> wrote:
> On 11/03/15 17:57, Feng Kan wrote:
>> On Wed, Mar 11, 2015 at 10:31 AM, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org> wrote:
>>> On 11/03/15 17:19, Feng Kan wrote:
>>>> On Wed, Mar 11, 2015 at 7:53 AM, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org> wrote:
>>>>> On 27/01/15 07:03, Pranavkumar Sawargaonkar wrote:
>>>>>> In APM X-Gene, GIC register space is 64K aligned while the sizes mentioned
>>>>>> in the dt are 4K aligned. This breaks KVM when kernel is built with 64K page
>>>>>> size due to size alignment checking in vgic driver for VCPU Control and
>>>>>> VCPU register.
>>>>>>
>>>>>> This patch corrects the sizes to be inline with the hardware spec.
>>>>>
>>>>> This patch may be correct, but it is useless. The firmware on my APM
>>>>> system (some version of u-boot) repaints the DT at boot time, negating
>>>>> the effect of this patch.
>>>> We have updated u-boot to reflect this change. I can supply you with a updated
>>>> image if you wish.
>>>
>>> That would be useful, thanks.
>>>
>>> But more importantly, why bother upstreaming your DT into the kernel
>>> tree if your firmware is going to overwrite whatever we provide?
>> We did tried to submit a version upstream but was rejected.
>>
>>>
>>> Either the firmware let the user provide its own DT (and doesn't touch
>>> it other than to change the CPU enable method, insert a /memreserve/ or
>>> similar things), or the firmware always provide its own DT, and doesn't
>>> let the user provide its own. Corrupting the user DT is a disaster, as
>>> we just found.
>> Yes, the intent of the change is listed in the link below. It is not a
>> justification by any means,
>> just the effects of things appearing in layers.
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/288574.html
>
> Yeah. This is as wrong as it can possibly be. Oh well...

Yes there is an issue with u-boot patching the dt for end user who
wants his DT to be used, for this we can (in fact we should) provide
an option in u-boot (may be setting some environment variable) which
will make sure end user's DT does not get modified (apart from
standard things like patching mac-addresses) by u-boot.

Another point I want to reopen here is the how to handle 64K GIC page
size pointed out in this thread, what would be the best way to tackle
this (adding a new DT string or any other way) ?


Thanks,
Pranav

>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
