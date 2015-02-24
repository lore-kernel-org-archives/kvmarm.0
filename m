From: Pranavkumar Sawargaonkar <psawargaonkar@apm.com>
Subject: Re: [PATCH] arm64: dts: Fix GIC reg sizes for APM X-Gene
Date: Tue, 24 Feb 2015 12:04:52 +0530
Message-ID: <CANFfpkQF-8Kzq-UoP=xLpkTafGn6ScyiEb6oCs-Lxygb+ummLA@mail.gmail.com>
References: <1422342206-4750-1-git-send-email-psawargaonkar@apm.com>
 <CAL_JsqJQcuX2cp50oHod-QAbhdMg48TaRP+gLGEO2kbFnQ3B+A@mail.gmail.com>
 <20150219190348.GB24460@cbox>
 <CAL_JsqLcBOC+AnVe7oATjg2g6Fz2vqwacu8QzS4tXMaxxOP_Xg@mail.gmail.com>
 <20150223120744.GA5609@cbox>
 <CAL_JsqJ6E+05psDCXS7k74Mz-DgSEroQ2ODpe2Bp2_50fL3imA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2457F464CF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 01:29:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K6UYrCKvA0VB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 01:29:13 -0500 (EST)
Received: from mail-pd0-f173.google.com (exprod5og115.obsmtp.com [64.18.0.246])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F3E0464CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 01:29:12 -0500 (EST)
Received: by pdjy10 with SMTP id y10so31184712pdj.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 22:34:52 -0800 (PST)
In-Reply-To: <CAL_JsqJ6E+05psDCXS7k74Mz-DgSEroQ2ODpe2Bp2_50fL3imA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Rob Herring <robherring2@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Feng Kan <fkan@apm.com>, Marc Zyngier <marc.zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Tushar Jagad <tjagad@apm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Rob,

On Mon, Feb 23, 2015 at 10:09 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Mon, Feb 23, 2015 at 6:07 AM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
>> On Sat, Feb 21, 2015 at 03:56:17PM -0600, Rob Herring wrote:
>>> On Thu, Feb 19, 2015 at 1:03 PM, Christoffer Dall
>>> <christoffer.dall@linaro.org> wrote:
>>> > On Thu, Feb 19, 2015 at 12:23:15PM -0600, Rob Herring wrote:
>>> >> On Tue, Jan 27, 2015 at 1:03 AM, Pranavkumar Sawargaonkar
>>> >> <psawargaonkar@apm.com> wrote:
>>> >> > In APM X-Gene, GIC register space is 64K aligned while the sizes mentioned
>>> >> > in the dt are 4K aligned. This breaks KVM when kernel is built with 64K page
>>> >> > size due to size alignment checking in vgic driver for VCPU Control and
>>> >> > VCPU register.
>>> >> >
>>> >> > This patch corrects the sizes to be inline with the hardware spec.
>>> >>
>>> >> This does not make sense. The GIC regions are still only 4 or 8KB and
>>> >> the h/w description should reflect that. For implementations using
>>> >> gic-400 and the addressing decode trick, the rest of the register
>>> >> range is also not safe to access given it is multiple mapped. Also,
>>> >> this wastes virtual space, but I guess we don't care on 64-bit.
>>> >>
>>> >> KVM should be fixed to only check base address alignment. Size
>>> >> alignment does not matter (if it does, then you need to fix all
>>> >> register blocks).
>>> >>
>>> > It matters if you want to ensure that the 64K page you are assigning to
>>> > a guest for the GIC virtual CPU interface contains only GIC virtual CPU
>>> > mappings, and not other random stuff that the guest is not allowed to
>>> > touch.
>>>
>>> Good point.
>>>
>>> > How else should this be enforced?
>>>
>>> Rely on correct h/w design? You'll have to repeat this every time you
>>> want to do pass-thru of a device.
>>>
>>> What do you do if 64K mapping is not supported? Fallback to emulation
>>> of the CPU interface?
>>
>> Agree with Peter on these two points.
>>
>>>
>>> Are there other DTSs that need to be fixed?
>>>
>> Not sure really, AMD Seattle works with 64K pages IIRC.
>
> Well, looks we have been inconsistent here:
>
> arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi-           reg = <0x0
> 0xe1110000 0 0x1000>,
> arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi-                 <0x0
> 0xe112f000 0 0x2000>,
> arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi-                 <0x0
> 0xe1140000 0 0x10000>,
> arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi-                 <0x0
> 0xe1160000 0 0x10000>;
>
> arch/arm64/boot/dts/arm/juno.dts-               reg = <0x0 0x2c010000 0 0x1000>,
> arch/arm64/boot/dts/arm/juno.dts-                     <0x0 0x2c02f000 0 0x2000>,
> arch/arm64/boot/dts/arm/juno.dts-                     <0x0 0x2c04f000 0 0x2000>,
> arch/arm64/boot/dts/arm/juno.dts-                     <0x0 0x2c06f000 0 0x2000>;
>
> If we are going to use 64K sizes, can we have some consistency here
> please. Which ranges really need 64KB sizes? It should only be the
> VCPU interface. right? Why does XGene need 128K? If XGene is doing
> address swizzling, then the CPU and VCPU base addresses are wrong.
> Seattle is also wrong for the VCPU, but no one has noticed because we
> don't use the DIR register IIRC.
>
> XGene should also add an "arm,gic-400" compatible string or something
> XGene specific if in fact it is not GIC-400.

X-Gene has gic-400 as an interrupt controller.
Only thing is GIC pages are mapped at 64K boundary (with 64K page size)
Hence CPU, VCPU interfaces has a size of 128K (2GIC pages)
Regarding GICC_DIR, yes there is a problem which needs to be solved
since the first page size is 64K.
In XEN we already have a small fix to access GICC_DIR with 64K page
offset instead of standard 4K.
I remember a small discussion in this regard in past
(http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/266468.html)
which was deferred at that time.
Once this patch is accepted we can post RFC patch to address GICC_DIR
and discuss further.

>
> I think perhaps we need a specific compatible property to indicate a
> GIC-400 with address swizzling. While we could get away with using the
> aliased addresses, that seems to be hard to get right and we may
> regret not doing it in the long term. It would indicate at least it is
> 64K page safe for example.
>
> Rob

Thanks,
Pranav
