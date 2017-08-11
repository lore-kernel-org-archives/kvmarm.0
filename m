From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 05/15] ARM: head: use PC-relative insn sequence for
 __smp_alt
Date: Fri, 11 Aug 2017 20:37:00 +0100
Message-ID: <CAKv+Gu8d8BxRTy6-h5BHTyPvtJrrQraMaMJP+EG2RRRo-Wvv0Q@mail.gmail.com>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
 <20170805205222.19868-6-ard.biesheuvel@linaro.org>
 <20170811151346.GR8569@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A88C40FAE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Aug 2017 15:35:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id repoRuELiii7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Aug 2017 15:35:25 -0400 (EDT)
Received: from mail-io0-f179.google.com (mail-io0-f179.google.com
 [209.85.223.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69A8040A86
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Aug 2017 15:35:25 -0400 (EDT)
Received: by mail-io0-f179.google.com with SMTP id g71so23401133ioe.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Aug 2017 12:37:01 -0700 (PDT)
In-Reply-To: <20170811151346.GR8569@atomide.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tony Lindgren <tony@atomide.com>
Cc: Andrew Lunn <andrew@lunn.ch>, baohua@kernel.org, Dave Martin <dave.martin@arm.com>, Jason Cooper <jason@lakedaemon.net>, KVM devel mailing list <kvm@vger.kernel.org>, "nico@linaro.org" <nico@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>, Russell King <linux@armlinux.org.uk>, Krzysztof Kozlowski <krzk@kernel.org>, Patrice CHOTARD <patrice.chotard@st.com>, linux-renesas-soc@vger.kernel.org, arm@kernel.org, vireshk@kernel.org, Gregory CLEMENT <gregory.clement@free-electrons.com>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, Shiraz Hashim <shiraz.linux.kernel@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 11 August 2017 at 16:13, Tony Lindgren <tony@atomide.com> wrote:
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170805 13:54]:
>> Replace the open coded PC relative offset calculations with a pair
>> of adr_l invocations.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm/kernel/head.S | 12 ++----------
>>  1 file changed, 2 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
>> index 6e9df3663a57..aed341e0f530 100644
>> --- a/arch/arm/kernel/head.S
>> +++ b/arch/arm/kernel/head.S
>> @@ -523,19 +523,11 @@ ARM_BE8(rev     r0, r0)                 @ byteswap if big endian
>>       retne   lr
>>
>>  __fixup_smp_on_up:
>> -     adr     r0, 1f
>> -     ldmia   r0, {r3 - r5}
>> -     sub     r3, r0, r3
>> -     add     r4, r4, r3
>> -     add     r5, r5, r3
>> +     adr_l   r4, __smpalt_begin
>> +     adr_l   r5, __smpalt_end
>>       b       __do_fixup_smp_on_up
>>  ENDPROC(__fixup_smp)
>>
>> -     .align
>> -1:   .word   .
>> -     .word   __smpalt_begin
>> -     .word   __smpalt_end
>> -
>>       .pushsection .data
>>       .globl  smp_on_up
>>  smp_on_up:
>
> Ard, it's this one that cause boot to fail on omap3.
> The rest of your set works for me with just this one
> left out.
>

I'm completely puzzled. The change is so simple that it is difficult
to reduce it in parts, but if you still have the time to spare, mind
trying the diff below?


diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 6e9df3663a57..c0361e608210 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -524,17 +524,15 @@ ARM_BE8(rev       r0, r0)                 @
byteswap if big endian

 __fixup_smp_on_up:
        adr     r0, 1f
-       ldmia   r0, {r3 - r5}
-       sub     r3, r0, r3
-       add     r4, r4, r3
-       add     r5, r5, r3
+       ldmia   r0, {r4 - r5}
+       add     r4, r4, r0
+       add     r5, r5, r0
        b       __do_fixup_smp_on_up
 ENDPROC(__fixup_smp)

        .align
-1:     .word   .
-       .word   __smpalt_begin
-       .word   __smpalt_end
+1:     .word   __smpalt_begin - 1b
+       .word   __smpalt_end - 1b

        .pushsection .data
        .globl  smp_on_up

The main point of these changes is to eliminate absolute references,
not to use the new macros, so if this does work, I will go with this
instead.
