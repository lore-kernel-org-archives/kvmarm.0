From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/3] arm64: alternative: add auto-nop infrastructure
Date: Tue, 13 Sep 2016 09:59:55 +0100
Message-ID: <CAKv+Gu_S535p04Kaef8t+AQypopVWQ7jA1VwG7Y2Yf5010THnA@mail.gmail.com>
References: <1473242830-26246-1-git-send-email-mark.rutland@arm.com>
 <1473242830-26246-2-git-send-email-mark.rutland@arm.com>
 <CAKv+Gu-KHePVj3gs+Q0wfgkVrD0nB0Yi+xLdbnGz-YZTTsPxFw@mail.gmail.com>
 <20160913085704.GC19689@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6420849B71
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:51:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nX-FWShAS99U for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 04:51:13 -0400 (EDT)
Received: from mail-it0-f46.google.com (mail-it0-f46.google.com
 [209.85.214.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2655349B68
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:51:12 -0400 (EDT)
Received: by mail-it0-f46.google.com with SMTP id n143so28176408ita.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 01:59:56 -0700 (PDT)
In-Reply-To: <20160913085704.GC19689@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <dave.martin@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 13 September 2016 at 09:57, Mark Rutland <mark.rutland@arm.com> wrote:
> On Tue, Sep 13, 2016 at 09:36:14AM +0100, Ard Biesheuvel wrote:
>> On 7 September 2016 at 11:07, Mark Rutland <mark.rutland@arm.com> wrote:
>> > In some cases, one side of an alternative sequence is simply a number of
>> > NOPs used to balance the other side. Keeping track of this manually is
>> > tedious, and the presence of large chains of NOPs makes the code more
>> > painful to read than necessary.
>> >
>> > To ameliorate matters, this patch adds a new alternative_else_nop_endif,
>> > which automatically balances an alternative sequence with a trivial NOP
>> > sled.
>> >
>> > In many cases, we would like a NOP-sled in the default case, and
>> > instructions patched in in the presence of a feature. To enable the NOPs
>> > to be generated automatically for this case, this patch also adds a new
>> > alternative_if, and updates alternative_else and alternative_endif to
>> > work with either alternative_if or alternative_endif.
>
> [...]
>
>> > +/*
>> > + * Begin an alternative code sequence.
>> >   */
>> >  .macro alternative_if_not cap
>> > +       .set .Lasm_alt_mode, 0
>>
>> Given that only a single copy of this symbol will exist in an object
>> file, is it still possible to use both variants in a single
>> compilation/assembly unit?
>
> Yes.
>
> GAS allows the symbol to be set multiple times (so long as the
> assignments are constant values). The last assignment "wins" when it
> comes to output, but assembler macros are evaluated before this, and use
> the most recent assignment.
>
> In testing I hacked __kvm_call_hyp to use both:
>
>         ENTRY(__kvm_call_hyp)
>         alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
>                 str     lr, [sp, #-16]!
>                 hvc     #0
>                 ldr     lr, [sp], #16
>                 ret
>         alternative_else_nop_endif
>         alternative_if ARM64_HAS_VIRT_HOST_EXTN
>                 hvc     #0x539
>         alternative_else_nop_endif
>                 b       __vhe_hyp_call
>         ENDPROC(__kvm_call_hyp)
>
> Which, according to objdump gives me the expected result:
>
>         Disassembly of section .text:
>
>         0000000000000000 <__kvm_call_hyp>:
>            0:   f81f0ffe        str     x30, [sp,#-16]!
>            4:   d4000002        hvc     #0x0
>            8:   f84107fe        ldr     x30, [sp],#16
>            c:   d65f03c0        ret
>           10:   d503201f        nop
>           14:   14000000        b       0 <__vhe_hyp_call>
>
>         Disassembly of section .altinstr_replacement:
>
>         0000000000000000 <.altinstr_replacement>:
>            0:   d503201f        nop
>            4:   d503201f        nop
>            8:   d503201f        nop
>            c:   d503201f        nop
>           10:   d400a722        hvc     #0x539
>

Thanks for the clarification,

Ard.
