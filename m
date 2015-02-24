From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] arm64: dts: Fix GIC reg sizes for APM X-Gene
Date: Tue, 24 Feb 2015 08:30:41 -0600
Message-ID: <CAL_JsqLs4HdT6N=Vb4s--x3ugXKbWYQ5R2WGbiWFhhnYxnK-xw@mail.gmail.com>
References: <1422342206-4750-1-git-send-email-psawargaonkar@apm.com>
 <CAL_JsqJQcuX2cp50oHod-QAbhdMg48TaRP+gLGEO2kbFnQ3B+A@mail.gmail.com>
 <20150219190348.GB24460@cbox> <CAL_JsqLcBOC+AnVe7oATjg2g6Fz2vqwacu8QzS4tXMaxxOP_Xg@mail.gmail.com>
 <20150223120744.GA5609@cbox> <CAL_JsqJ6E+05psDCXS7k74Mz-DgSEroQ2ODpe2Bp2_50fL3imA@mail.gmail.com>
 <CANFfpkQF-8Kzq-UoP=xLpkTafGn6ScyiEb6oCs-Lxygb+ummLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANFfpkQF-8Kzq-UoP=xLpkTafGn6ScyiEb6oCs-Lxygb+ummLA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pranavkumar Sawargaonkar <psawargaonkar-qTEPVZfXA3Y@public.gmane.org>
Cc: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Feng Kan <fkan-qTEPVZfXA3Y@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, "jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "patches-qTEPVZfXA3Y@public.gmane.org" <patches-qTEPVZfXA3Y@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, Tushar Jagad <tjagad-qTEPVZfXA3Y@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 24, 2015 at 12:34 AM, Pranavkumar Sawargaonkar
<psawargaonkar-qTEPVZfXA3Y@public.gmane.org> wrote:
> Hi Rob,
>
> On Mon, Feb 23, 2015 at 10:09 PM, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Mon, Feb 23, 2015 at 6:07 AM, Christoffer Dall
>> <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>> On Sat, Feb 21, 2015 at 03:56:17PM -0600, Rob Herring wrote:
>>>> On Thu, Feb 19, 2015 at 1:03 PM, Christoffer Dall
>>>> <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>>> > On Thu, Feb 19, 2015 at 12:23:15PM -0600, Rob Herring wrote:
>>>> >> On Tue, Jan 27, 2015 at 1:03 AM, Pranavkumar Sawargaonkar
>>>> >> <psawargaonkar-qTEPVZfXA3Y@public.gmane.org> wrote:
>>>> >> > In APM X-Gene, GIC register space is 64K aligned while the sizes mentioned
>>>> >> > in the dt are 4K aligned. This breaks KVM when kernel is built with 64K page
>>>> >> > size due to size alignment checking in vgic driver for VCPU Control and
>>>> >> > VCPU register.
>>>> >> >
>>>> >> > This patch corrects the sizes to be inline with the hardware spec.
>>>> >>
>>>> >> This does not make sense. The GIC regions are still only 4 or 8KB and
>>>> >> the h/w description should reflect that. For implementations using
>>>> >> gic-400 and the addressing decode trick, the rest of the register
>>>> >> range is also not safe to access given it is multiple mapped. Also,
>>>> >> this wastes virtual space, but I guess we don't care on 64-bit.
>>>> >>
>>>> >> KVM should be fixed to only check base address alignment. Size
>>>> >> alignment does not matter (if it does, then you need to fix all
>>>> >> register blocks).
>>>> >>
>>>> > It matters if you want to ensure that the 64K page you are assigning to
>>>> > a guest for the GIC virtual CPU interface contains only GIC virtual CPU
>>>> > mappings, and not other random stuff that the guest is not allowed to
>>>> > touch.
>>>>
>>>> Good point.
>>>>
>>>> > How else should this be enforced?
>>>>
>>>> Rely on correct h/w design? You'll have to repeat this every time you
>>>> want to do pass-thru of a device.
>>>>
>>>> What do you do if 64K mapping is not supported? Fallback to emulation
>>>> of the CPU interface?
>>>
>>> Agree with Peter on these two points.
>>>
>>>>
>>>> Are there other DTSs that need to be fixed?
>>>>
>>> Not sure really, AMD Seattle works with 64K pages IIRC.
>>
>> Well, looks we have been inconsistent here:
>>
>> arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi-           reg = <0x0
>> 0xe1110000 0 0x1000>,
>> arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi-                 <0x0
>> 0xe112f000 0 0x2000>,
>> arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi-                 <0x0
>> 0xe1140000 0 0x10000>,
>> arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi-                 <0x0
>> 0xe1160000 0 0x10000>;
>>
>> arch/arm64/boot/dts/arm/juno.dts-               reg = <0x0 0x2c010000 0 0x1000>,
>> arch/arm64/boot/dts/arm/juno.dts-                     <0x0 0x2c02f000 0 0x2000>,
>> arch/arm64/boot/dts/arm/juno.dts-                     <0x0 0x2c04f000 0 0x2000>,
>> arch/arm64/boot/dts/arm/juno.dts-                     <0x0 0x2c06f000 0 0x2000>;
>>
>> If we are going to use 64K sizes, can we have some consistency here
>> please. Which ranges really need 64KB sizes? It should only be the
>> VCPU interface. right? Why does XGene need 128K? If XGene is doing
>> address swizzling, then the CPU and VCPU base addresses are wrong.
>> Seattle is also wrong for the VCPU, but no one has noticed because we
>> don't use the DIR register IIRC.
>>
>> XGene should also add an "arm,gic-400" compatible string or something
>> XGene specific if in fact it is not GIC-400.
>
> X-Gene has gic-400 as an interrupt controller.
> Only thing is GIC pages are mapped at 64K boundary (with 64K page size)
> Hence CPU, VCPU interfaces has a size of 128K (2GIC pages)
> Regarding GICC_DIR, yes there is a problem which needs to be solved
> since the first page size is 64K.
> In XEN we already have a small fix to access GICC_DIR with 64K page
> offset instead of standard 4K.

Right, and in order for this to work, you should use the last 4K alias
for the cpu interface(s). This is why other platforms use xxxf000 as
their cpu interface base.

It is of course possible that xgene does not properly do the address
swizzling and therefore you have to use 64K aligned addresses. But in
that case you need a unique compatible string.

> I remember a small discussion in this regard in past
> (http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/266468.html)
> which was deferred at that time.
> Once this patch is accepted we can post RFC patch to address GICC_DIR
> and discuss further.

No, let's get this right now and not keep changing the dts.

Rob

>
>>
>> I think perhaps we need a specific compatible property to indicate a
>> GIC-400 with address swizzling. While we could get away with using the
>> aliased addresses, that seems to be hard to get right and we may
>> regret not doing it in the long term. It would indicate at least it is
>> 64K page safe for example.
>>
>> Rob
>
> Thanks,
> Pranav
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
