From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 01/15] ARM: assembler: introduce adr_l, ldr_l and str_l
 macros
Date: Tue, 8 Aug 2017 11:39:19 -0400 (EDT)
Message-ID: <alpine.LFD.2.20.1708081131340.8927@knanqh.ubzr>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
 <20170805205222.19868-2-ard.biesheuvel@linaro.org>
 <alpine.LFD.2.20.1708081030030.8927@knanqh.ubzr>
 <CAKv+Gu8W68ruOsD9Fit0MrJ=JVDO3xF-SmQ-8qcpBSQm0si-UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BE3549C0F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 11:37:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pIPF7w8RQ9Y4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Aug 2017 11:37:53 -0400 (EDT)
Received: from mail-it0-f50.google.com (mail-it0-f50.google.com
 [209.85.214.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBF1740FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 11:37:52 -0400 (EDT)
Received: by mail-it0-f50.google.com with SMTP id 77so6116944itj.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Aug 2017 08:39:22 -0700 (PDT)
In-Reply-To: <CAKv+Gu8W68ruOsD9Fit0MrJ=JVDO3xF-SmQ-8qcpBSQm0si-UA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, baohua@kernel.org, Dave Martin <dave.martin@arm.com>, Jason Cooper <jason@lakedaemon.net>, KVM devel mailing list <kvm@vger.kernel.org>, Tony Lindgren <tony@atomide.com>, Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Krzysztof Kozlowski <krzk@kernel.org>, Patrice CHOTARD <patrice.chotard@st.com>, linux-renesas-soc@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, arm@kernel.org, vireshk@kernel.org, Gregory CLEMENT <gregory.clement@free-electrons.com>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, Shiraz Hashim <shiraz.linux.kernel@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 8 Aug 2017, Ard Biesheuvel wrote:

> On 8 August 2017 at 16:10, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > On Sat, 5 Aug 2017, Ard Biesheuvel wrote:
> >
> >> Like arm64, ARM supports position independent code sequences that
> >> produce symbol references with a greater reach than the ordinary
> >> adr/ldr instructions.
> >>
> >> Currently, we use open coded instruction sequences involving literals
> >> and arithmetic operations. Instead, we can use movw/movt pairs on v7
> >> CPUs, circumventing the D-cache entirely. For older CPUs, we can emit
> >> the literal into a subsection, allowing it to be emitted out of line
> >> while retaining the ability to perform arithmetic on label offsets.
> >>
> >> E.g., on pre-v7 CPUs, we can emit a PC-relative reference as follows:
> >>
> >>        ldr          <reg>, 222f
> >>   111: add          <reg>, <reg>, pc
> >>        .subsection  1
> >>   222: .long        <sym> - (111b + 8)
> >>        .previous
> >>
> >> This is allowed by the assembler because, unlike ordinary sections,
> >> subsections are combined into a single section into the object file,
> >> and so the label references are not true cross-section references that
> >> are visible as relocations. Note that we could even do something like
> >>
> >>        add          <reg>, pc, #(222f - 111f) & ~0xfff
> >>        ldr          <reg>, [<reg>, #(222f - 111f) & 0xfff]
> >>   111: add          <reg>, <reg>, pc
> >>        .subsection  1
> >>   222: .long        <sym> - (111b + 8)
> >>        .previous
> >>
> >> if it turns out that the 4 KB range of the ldr instruction is insufficient
> >> to reach the literal in the subsection, although this is currently not a
> >> problem (of the 98 objects built from .S files in a multi_v7_defconfig
> >> build, only 11 have .text sections that are over 1 KB, and the largest one
> >> [entry-armv.o] is 3308 bytes)
> >>
> >> Subsections have been available in binutils since 2004 at least, so
> >> they should not cause any issues with older toolchains.
> >>
> >> So use the above to implement the macros mov_l, adr_l, adrm_l (using ldm
> >> to load multiple literals at once), ldr_l and str_l, all of which will
> >> use movw/movt pairs on v7 and later CPUs, and use PC-relative literals
> >> otherwise.
> >
> > There is no adrm_l definition in this patch.
> >
> 
> Ah yes, I played around with it but it becomes a bit clunky so I removed it:
> 
>         adrl         <reg1>, 222f
>         ldm          <reg1>, {<reg1>, <reg2>}
>    111: add          <reg1>, <reg1>, pc
>         add          <reg2>, <reg2>, pc
>         .subsection  1
>    222: .long        <sym1> - (111b + 8)
>         .long        <sym2> - (111b + 12)
>         .previous
> 
> The adrl pseudo op always assembles to two instructions, so you need 5
> instructions while using adr_l twice uses only 4. I am not sure if
> eliminating one of the loads would make a huge difference, given that
> there are no use cases for adrm_l on hot paths, at least not in this
> series.

I'd suggest you keep it to a minimum.  Using adr_l twice is clear and 
obvious.

> > Also, might it be better to change mov_l to movl? Tthis looks similar to
> > the ARM64 movl pseudo-instruction, and unlike all the other _l variants,
> > this is not producing a pc relative result.
> >
> 
> On arm64, we have mov_q for a 64-bit absolute load, and I thought
> mov_l was less confusing than mov_w. In general, I like the underscore
> in the middle because on the one hand, it looks like a ordinary
> mnemonic but on the other hand, it is obvious that it is not a true
> instruction. mov_abs perhaps?
> 
> > Talking about the _l suffix: I wonder if this could be more meaningful,
> > like _rel maybe? At least in the adr_l case, this could easily be
> > confused with adrl.
> >
> 
> On arm64, we have ldr_l, str_l and adr_l as well, and I usually try to
> align between ARM and arm64 if I can.

OK. I'm much less versed into ARM64 assembly so I'll defer to your 
judgment.  It's good if this mnemonic scheme already exists there with 
a similar meaning.


Nicolas
