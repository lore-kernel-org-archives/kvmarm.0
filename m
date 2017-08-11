From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 05/15] ARM: head: use PC-relative insn sequence for
 __smp_alt
Date: Fri, 11 Aug 2017 16:06:02 -0400 (EDT)
Message-ID: <alpine.LFD.2.20.1708111603270.8927@knanqh.ubzr>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org> <20170805205222.19868-6-ard.biesheuvel@linaro.org> <20170811151346.GR8569@atomide.com> <CAKv+Gu8d8BxRTy6-h5BHTyPvtJrrQraMaMJP+EG2RRRo-Wvv0Q@mail.gmail.com> <alpine.LFD.2.20.1708111553360.8927@knanqh.ubzr>
 <CAKv+Gu-Qksstx799FEkadwX0QVr77ccH+oD7Cf5+XRJFv4iA8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-renesas-soc-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-Qksstx799FEkadwX0QVr77ccH+oD7Cf5+XRJFv4iA8w@mail.gmail.com>
Sender: linux-renesas-soc-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-renesas-soc@vger.kernel.org, Russell King <linux@armlinux.org.uk>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Krzysztof Kozlowski <krzk@kernel.org>, Jason Cooper <jason@lakedaemon.net>, arm@kernel.org, Andrew Lunn <andrew@lunn.ch>, Gregory CLEMENT <gregory.clement@free-electrons.com>, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>, baohua@kernel.org, Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>, vireshk@kernel.org, Shiraz Hashim <shiraz.linux.kernel@gmail.com>, Patrice CHOTARD <patri>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 11 Aug 2017, Ard Biesheuvel wrote:

> On 11 August 2017 at 20:58, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > On Fri, 11 Aug 2017, Ard Biesheuvel wrote:
> >
> >> On 11 August 2017 at 16:13, Tony Lindgren <tony@atomide.com> wrote:
> >> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170805 13:54]:
> >> >> Replace the open coded PC relative offset calculations with a pair
> >> >> of adr_l invocations.
> >> >>
> >> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> >> ---
> >> >>  arch/arm/kernel/head.S | 12 ++----------
> >> >>  1 file changed, 2 insertions(+), 10 deletions(-)
> >> >>
> >> >> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> >> >> index 6e9df3663a57..aed341e0f530 100644
> >> >> --- a/arch/arm/kernel/head.S
> >> >> +++ b/arch/arm/kernel/head.S
> >> >> @@ -523,19 +523,11 @@ ARM_BE8(rev     r0, r0)                 @ byteswap if big endian
> >> >>       retne   lr
> >> >>
> >> >>  __fixup_smp_on_up:
> >> >> -     adr     r0, 1f
> >> >> -     ldmia   r0, {r3 - r5}
> >> >> -     sub     r3, r0, r3
> >> >> -     add     r4, r4, r3
> >> >> -     add     r5, r5, r3
> >> >> +     adr_l   r4, __smpalt_begin
> >> >> +     adr_l   r5, __smpalt_end
> >> >>       b       __do_fixup_smp_on_up
> >> >>  ENDPROC(__fixup_smp)
> >> >>
> >> >> -     .align
> >> >> -1:   .word   .
> >> >> -     .word   __smpalt_begin
> >> >> -     .word   __smpalt_end
> >> >> -
> >> >>       .pushsection .data
> >> >>       .globl  smp_on_up
> >> >>  smp_on_up:
> >> >
> >> > Ard, it's this one that cause boot to fail on omap3.
> >> > The rest of your set works for me with just this one
> >> > left out.
> >> >
> >>
> >> I'm completely puzzled.
> >
> > Found it.
> >
> > You replaced:
> >
> > -       adr     r0, 1f
> > -       ldmia   r0, {r3 - r5}
> > -       sub     r3, r0, r3
> > -       add     r4, r4, r3
> > -       add     r5, r5, r3
> > +       adr_l   r4, __smpalt_begin
> > +       adr_l   r5, __smpalt_end
> >         b       __do_fixup_smp_on_up
> >
> > Notice that r3 is now uninitialized.
> >
> > Now have a look at the code for __do_fixup_smp_on_up.
> >
> 
> I still don't see it :-)
> 
> __do_fixup_smp_on_up() mentions r3 in the comment block, but it does
> not actually refer to it in the code, does it?

__do_fixup_smp_on_up:
        cmp     r4, r5
        reths   lr
        ldmia   r4!, {r0, r6}
 ARM(   str     r6, [r0, r3]    )	<<============
 THUMB( add     r0, r0, r3      )	<<============
[...]


Nicolas
