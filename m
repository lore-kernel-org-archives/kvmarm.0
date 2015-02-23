From: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64: dts: Fix GIC reg sizes for APM X-Gene
Date: Mon, 23 Feb 2015 13:07:44 +0100
Message-ID: <20150223120744.GA5609@cbox>
References: <1422342206-4750-1-git-send-email-psawargaonkar@apm.com>
 <CAL_JsqJQcuX2cp50oHod-QAbhdMg48TaRP+gLGEO2kbFnQ3B+A@mail.gmail.com>
 <20150219190348.GB24460@cbox>
 <CAL_JsqLcBOC+AnVe7oATjg2g6Fz2vqwacu8QzS4tXMaxxOP_Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL_JsqLcBOC+AnVe7oATjg2g6Fz2vqwacu8QzS4tXMaxxOP_Xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pranavkumar Sawargaonkar <psawargaonkar-qTEPVZfXA3Y@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Feng Kan <fkan-qTEPVZfXA3Y@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, "jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "patches-qTEPVZfXA3Y@public.gmane.org" <patches-qTEPVZfXA3Y@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, Tushar Jagad <tjagad-qTEPVZfXA3Y@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Feb 21, 2015 at 03:56:17PM -0600, Rob Herring wrote:
> On Thu, Feb 19, 2015 at 1:03 PM, Christoffer Dall
> <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > On Thu, Feb 19, 2015 at 12:23:15PM -0600, Rob Herring wrote:
> >> On Tue, Jan 27, 2015 at 1:03 AM, Pranavkumar Sawargaonkar
> >> <psawargaonkar-qTEPVZfXA3Y@public.gmane.org> wrote:
> >> > In APM X-Gene, GIC register space is 64K aligned while the sizes mentioned
> >> > in the dt are 4K aligned. This breaks KVM when kernel is built with 64K page
> >> > size due to size alignment checking in vgic driver for VCPU Control and
> >> > VCPU register.
> >> >
> >> > This patch corrects the sizes to be inline with the hardware spec.
> >>
> >> This does not make sense. The GIC regions are still only 4 or 8KB and
> >> the h/w description should reflect that. For implementations using
> >> gic-400 and the addressing decode trick, the rest of the register
> >> range is also not safe to access given it is multiple mapped. Also,
> >> this wastes virtual space, but I guess we don't care on 64-bit.
> >>
> >> KVM should be fixed to only check base address alignment. Size
> >> alignment does not matter (if it does, then you need to fix all
> >> register blocks).
> >>
> > It matters if you want to ensure that the 64K page you are assigning to
> > a guest for the GIC virtual CPU interface contains only GIC virtual CPU
> > mappings, and not other random stuff that the guest is not allowed to
> > touch.
> 
> Good point.
> 
> > How else should this be enforced?
> 
> Rely on correct h/w design? You'll have to repeat this every time you
> want to do pass-thru of a device.
> 
> What do you do if 64K mapping is not supported? Fallback to emulation
> of the CPU interface?

Agree with Peter on these two points.

> 
> Are there other DTSs that need to be fixed?
> 
Not sure really, AMD Seattle works with 64K pages IIRC.

Thanks,
-Christoffer
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
