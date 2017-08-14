From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 05/15] ARM: head: use PC-relative insn sequence for __smp_alt
Date: Mon, 14 Aug 2017 17:20:55 +0100
Message-ID: <CAKv+Gu8FtmOSd3OPvN-p0WyVnAmJeyteDP9ey5XhF6fvmazA9g@mail.gmail.com>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
 <20170805205222.19868-6-ard.biesheuvel@linaro.org> <20170811151346.GR8569@atomide.com>
 <CAKv+Gu8d8BxRTy6-h5BHTyPvtJrrQraMaMJP+EG2RRRo-Wvv0Q@mail.gmail.com> <20170814161909.GV8569@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-renesas-soc-owner@vger.kernel.org>
In-Reply-To: <20170814161909.GV8569@atomide.com>
Sender: linux-renesas-soc-owner@vger.kernel.org
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-renesas-soc@vger.kernel.org, Russell King <linux@armlinux.org.uk>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Krzysztof Kozlowski <krzk@kernel.org>, Jason Cooper <jason@lakedaemon.net>, arm@kernel.org, Andrew Lunn <andrew@lunn.ch>, Gregory CLEMENT <gregory.clement@free-electrons.com>, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>, baohua@kernel.org, Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>, vireshk@kernel.org, Shiraz Hashim <shiraz.linux.kernel@gmail.com>, Patrice CHOTARD <patrice.chotard@st.com>, nico@linaro.o
List-Id: kvmarm@lists.cs.columbia.edu

On 14 August 2017 at 17:19, Tony Lindgren <tony@atomide.com> wrote:
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170811 12:37]:
>> On 11 August 2017 at 16:13, Tony Lindgren <tony@atomide.com> wrote:
>> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170805 13:54]:
>> >> Replace the open coded PC relative offset calculations with a pair
>> >> of adr_l invocations.
>> >>
>> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> >> ---
>> >>  arch/arm/kernel/head.S | 12 ++----------
>> >>  1 file changed, 2 insertions(+), 10 deletions(-)
>> >>
>> >> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
>> >> index 6e9df3663a57..aed341e0f530 100644
>> >> --- a/arch/arm/kernel/head.S
>> >> +++ b/arch/arm/kernel/head.S
>> >> @@ -523,19 +523,11 @@ ARM_BE8(rev     r0, r0)                 @ byteswap if big endian
>> >>       retne   lr
>> >>
>> >>  __fixup_smp_on_up:
>> >> -     adr     r0, 1f
>> >> -     ldmia   r0, {r3 - r5}
>> >> -     sub     r3, r0, r3
>> >> -     add     r4, r4, r3
>> >> -     add     r5, r5, r3
>> >> +     adr_l   r4, __smpalt_begin
>> >> +     adr_l   r5, __smpalt_end
>> >>       b       __do_fixup_smp_on_up
>> >>  ENDPROC(__fixup_smp)
>> >>
>> >> -     .align
>> >> -1:   .word   .
>> >> -     .word   __smpalt_begin
>> >> -     .word   __smpalt_end
>> >> -
>> >>       .pushsection .data
>> >>       .globl  smp_on_up
>> >>  smp_on_up:
>> >
>> > Ard, it's this one that cause boot to fail on omap3.
>> > The rest of your set works for me with just this one
>> > left out.
>> >
>>
>> I'm completely puzzled. The change is so simple that it is difficult
>> to reduce it in parts, but if you still have the time to spare, mind
>> trying the diff below?
>>
>>
>> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
>> index 6e9df3663a57..c0361e608210 100644
>> --- a/arch/arm/kernel/head.S
>> +++ b/arch/arm/kernel/head.S
>> @@ -524,17 +524,15 @@ ARM_BE8(rev       r0, r0)                 @
>> byteswap if big endian
>>
>>  __fixup_smp_on_up:
>>         adr     r0, 1f
>> -       ldmia   r0, {r3 - r5}
>> -       sub     r3, r0, r3
>> -       add     r4, r4, r3
>> -       add     r5, r5, r3
>> +       ldmia   r0, {r4 - r5}
>> +       add     r4, r4, r0
>> +       add     r5, r5, r0
>>         b       __do_fixup_smp_on_up
>>  ENDPROC(__fixup_smp)
>>
>>         .align
>> -1:     .word   .
>> -       .word   __smpalt_begin
>> -       .word   __smpalt_end
>> +1:     .word   __smpalt_begin - 1b
>> +       .word   __smpalt_end - 1b
>>
>>         .pushsection .data
>>         .globl  smp_on_up
>>
>> The main point of these changes is to eliminate absolute references,
>> not to use the new macros, so if this does work, I will go with this
>> instead.
>
> For reference, I manually did this changes as it did not apply
> after reverting your earlier version of this patch. No luck with
> this change, so I'll test again when you you have updated patches
> available.
>

Thanks Tony,

But Nico already found the issue: I was looking at the code with
another patch on top, which removed the reference to r3 in the
followup code.

In the KASLR series I just posted, I reordered that patch with this
one, so everything should be good.
