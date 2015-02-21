From: Peter Maydell <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64: dts: Fix GIC reg sizes for APM X-Gene
Date: Sun, 22 Feb 2015 08:58:15 +0900
Message-ID: <CAFEAcA9pg5v_+RAehwf5XWopgeJtWfDb+Xej+579ikeiRjhg_Q@mail.gmail.com>
References: <1422342206-4750-1-git-send-email-psawargaonkar@apm.com>
 <CAL_JsqJQcuX2cp50oHod-QAbhdMg48TaRP+gLGEO2kbFnQ3B+A@mail.gmail.com>
 <20150219190348.GB24460@cbox> <CAL_JsqLcBOC+AnVe7oATjg2g6Fz2vqwacu8QzS4tXMaxxOP_Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqLcBOC+AnVe7oATjg2g6Fz2vqwacu8QzS4tXMaxxOP_Xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Feng Kan <fkan-qTEPVZfXA3Y@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, "jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "patches-qTEPVZfXA3Y@public.gmane.org" <patches-qTEPVZfXA3Y@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, Tushar Jagad <tjagad-qTEPVZfXA3Y@public.gmane.org>, Pranavkumar Sawargaonkar <psawargaonkar-qTEPVZfXA3Y@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 22 February 2015 at 06:56, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Feb 19, 2015 at 1:03 PM, Christoffer Dall
> <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> It matters if you want to ensure that the 64K page you are assigning to
>> a guest for the GIC virtual CPU interface contains only GIC virtual CPU
>> mappings, and not other random stuff that the guest is not allowed to
>> touch.
>
> Good point.
>
>> How else should this be enforced?
>
> Rely on correct h/w design? You'll have to repeat this every time you
> want to do pass-thru of a device.

The idea is that the device tree lets us describe whether
the hardware design is correct or not :-)

> What do you do if 64K mapping is not supported? Fallback to emulation
> of the CPU interface?

In this case KVM can't be supported -- use 4K host pages with this
hardware, or don't use KVM...

-- PMM
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
