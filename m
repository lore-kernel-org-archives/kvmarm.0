From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 01/15] ARM: assembler: introduce adr_l, ldr_l and str_l macros
Date: Tue, 8 Aug 2017 16:19:24 +0100
Message-ID: <CAKv+Gu8W68ruOsD9Fit0MrJ=JVDO3xF-SmQ-8qcpBSQm0si-UA@mail.gmail.com>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
 <20170805205222.19868-2-ard.biesheuvel@linaro.org> <alpine.LFD.2.20.1708081030030.8927@knanqh.ubzr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1708081030030.8927@knanqh.ubzr>
Sender: kvm-owner@vger.kernel.org
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-renesas-soc@vger.kernel.org, Russell King - ARM Linux <linux@armlinux.org.uk>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Krzysztof Kozlowski <krzk@kernel.org>, Jason Cooper <jason@lakedaemon.net>, arm@kernel.org, Andrew Lunn <andrew@lunn.ch>, Gregory CLEMENT <gregory.clement@free-electrons.com>, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>, Tony Lindgren <tony@atomide.com>, baohua@kernel.org, Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>, vireshk@kernel.org, Shiraz Hashim <shiraz.linux.kernel@gmail.com>, Patrice
List-Id: kvmarm@lists.cs.columbia.edu

On 8 August 2017 at 16:10, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Sat, 5 Aug 2017, Ard Biesheuvel wrote:
>
>> Like arm64, ARM supports position independent code sequences that
>> produce symbol references with a greater reach than the ordinary
>> adr/ldr instructions.
>>
>> Currently, we use open coded instruction sequences involving literals
>> and arithmetic operations. Instead, we can use movw/movt pairs on v7
>> CPUs, circumventing the D-cache entirely. For older CPUs, we can emit
>> the literal into a subsection, allowing it to be emitted out of line
>> while retaining the ability to perform arithmetic on label offsets.
>>
>> E.g., on pre-v7 CPUs, we can emit a PC-relative reference as follows:
>>
>>        ldr          <reg>, 222f
>>   111: add          <reg>, <reg>, pc
>>        .subsection  1
>>   222: .long        <sym> - (111b + 8)
>>        .previous
>>
>> This is allowed by the assembler because, unlike ordinary sections,
>> subsections are combined into a single section into the object file,
>> and so the label references are not true cross-section references that
>> are visible as relocations. Note that we could even do something like
>>
>>        add          <reg>, pc, #(222f - 111f) & ~0xfff
>>        ldr          <reg>, [<reg>, #(222f - 111f) & 0xfff]
>>   111: add          <reg>, <reg>, pc
>>        .subsection  1
>>   222: .long        <sym> - (111b + 8)
>>        .previous
>>
>> if it turns out that the 4 KB range of the ldr instruction is insufficient
>> to reach the literal in the subsection, although this is currently not a
>> problem (of the 98 objects built from .S files in a multi_v7_defconfig
>> build, only 11 have .text sections that are over 1 KB, and the largest one
>> [entry-armv.o] is 3308 bytes)
>>
>> Subsections have been available in binutils since 2004 at least, so
>> they should not cause any issues with older toolchains.
>>
>> So use the above to implement the macros mov_l, adr_l, adrm_l (using ldm
>> to load multiple literals at once), ldr_l and str_l, all of which will
>> use movw/movt pairs on v7 and later CPUs, and use PC-relative literals
>> otherwise.
>
> There is no adrm_l definition in this patch.
>

Ah yes, I played around with it but it becomes a bit clunky so I removed it:

        adrl         <reg1>, 222f
        ldm          <reg1>, {<reg1>, <reg2>}
   111: add          <reg1>, <reg1>, pc
        add          <reg2>, <reg2>, pc
        .subsection  1
   222: .long        <sym1> - (111b + 8)
        .long        <sym2> - (111b + 12)
        .previous

The adrl pseudo op always assembles to two instructions, so you need 5
instructions while using adr_l twice uses only 4. I am not sure if
eliminating one of the loads would make a huge difference, given that
there are no use cases for adrm_l on hot paths, at least not in this
series.

> Also, might it be better to change mov_l to movl? Tthis looks similar to
> the ARM64 movl pseudo-instruction, and unlike all the other _l variants,
> this is not producing a pc relative result.
>

On arm64, we have mov_q for a 64-bit absolute load, and I thought
mov_l was less confusing than mov_w. In general, I like the underscore
in the middle because on the one hand, it looks like a ordinary
mnemonic but on the other hand, it is obvious that it is not a true
instruction. mov_abs perhaps?

> Talking about the _l suffix: I wonder if this could be more meaningful,
> like _rel maybe? At least in the adr_l case, this could easily be
> confused with adrl.
>

On arm64, we have ldr_l, str_l and adr_l as well, and I usually try to
align between ARM and arm64 if I can.

> Otherwise I like it pretty much.
>

Thanks!
