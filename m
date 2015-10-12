From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 13/15] arm64: kvm: Rewrite fake pgd handling
Date: Mon, 12 Oct 2015 10:55:24 +0100
Message-ID: <561B838C.5090008@arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-14-git-send-email-suzuki.poulose@arm.com>
 <20151010145227.GB29128@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151010145227.GB29128@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Catalin.Marinas@arm.com, Will.Deacon@arm.com, Mark.Rutland@arm.com, Marc.Zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/10/15 15:52, Christoffer Dall wrote:
> Hi Suzuki,

Hi Christoffer,

Thanks for being patient enough to review the code :-) without much of
the comments. I now realise there needs much more documentation than
what I have put in already. I am taking care of this in the next
revision already.

> I had to refresh my mind a fair bit to be able to review this, so I
> thought it may be useful to just remind us all what the constraints of
> this whole thing is, and make sure we agree on this:
>
> 1. We fix the IPA max width to 40 bits
> 2. We don't support systems with a PARange smaller than 40 bits (do we
>     check this anywhere or document this anywhere?)

AFAIT, no we don't check it anywhere. May be we should. We could plug this
into my CPU feature infrastructure[1] and let the is_hype_mode_available()
use the info to decide if we can support 40bit IPA ?

> 3. We always assume we are running on a system with PARange of 40 bits
>     and we are therefore constrained to use concatination.
>
> As an implication of (3) above, this code will attempt to allocate 256K
> of physically contiguous memory for each VM on the system.  That is
> probably ok, but I just wanted to point it out in case it raises any
> eyebrows for other people following this thread.

Right, I will document this in a comment.

>> level:  0       1         2         3
>> bits : [47] [46 - 36] [35 - 25] [24 - 14] [13 - 0]
>>           ^       ^     ^
>>           |       |     |
>>     host entry    |     x---- stage-2 entry
>>                   |
>>          IPA -----x
>
> Isn't the stage-2 entry using bits [39:25], because you resolve
> more than 11 bits on the initial level of lookup when you concatenate
> tables?

Yes, the stage-2 entry is just supposed to show the entry level (2).

>>
>> The following conditions hold true for all cases(with 40bit IPA)
>> 1) The stage-2 entry level <= 2
>> 2) Number of fake page-table entries is in the inclusive range [0, 2].
>
> nit: Number of fake levels of page tables

Correct, I have fixed it already.


>> +/*
>> + * At stage-2 entry level, upto 16 tables can be concatenated and
>
> nit: Can you rewrite the first part of this comment to be in line with
> the ARM ARM, such as: "The stage-2 page tables can concatenate up to 16
> tables at the inital level"  ?

Yes, will do it.

>
>
>> + * the hardware expects us to use concatenation, whenever possible.
>
> I think the 'hardware expects us' is a bit vague.  At least I find this
> whole part of the architecture incredibly confusing already, so it would
> help me in the future if we put something like:
>
> "The hardware requires that we use concatenation depending on the
> supported PARange and page size.  We always assume the hardware's PASize
> is maximum 40 bits in this context, and with a fixed IPA width of 40
> bits, we concatenate 2 tables for 4K pages, 16 tables for 16K pages, and
> do not use concatenation for 64K pages."
>
> Did I get this right?

You are right. The rule is simple. Upto 16 tables can be concatenated at
the stage-2 entry level.

>
>> + * So, number of page table levels for KVM_PHYS_SHIFT is always
>> + * the number of normal page table levels for (KVM_PHYS_SHIFT - 4).
>> + */
>> +#define HYP_PGTABLE_LEVELS	ARM64_HW_PGTABLE_LEVELS(KVM_PHYS_SHIFT - 4)
>
> I see the math lines up, but I don't think it's intuitive, as I don't
> understand why it's obvious that it's the 'normal' page table for
> KVM_PHYS_SHIFT - 4.

Because, we can concatenate upto 16 page table entries. With the current
set of page sizes the above 'magic' formula works out. But yes, the following
suggestion makes more sense.

>
> I see this as an architectural limitation given in the ARM ARM, and we
> should just refer to that, and do:
>
> #if PAGE_SHIFT == 12
> #define S2_PGTABLE_LEVELS	3
> #else
> #define S2_PGTABLE_LEVELS	2
> #endif

OK, we could do that.

>
>> +/* Number of bits normally addressed by HYP_PGTABLE_LEVELS */
>> +#define HYP_PGTABLE_SHIFT	ARM64_HW_PGTABLE_LEVEL_SHIFT(HYP_PGTABLE_LEVELS + 1)
>> +#define HYP_PGDIR_SHIFT		ARM64_HW_PGTABLE_LEVEL_SHIFT(HYP_PGTABLE_LEVELS)
>> +#define HYP_PGTABLE_ENTRY_LEVEL	(4 - HYP_PGTABLE_LEVELS)
>
> We are introducing a huge number of defines here, which are all more or
> less opaque to anyone coming back to this code.
>
> I may be extraordinarily stupid, but I really need each define explained
> in a comment to be able to follow this code (those above and the
> S2_ENTRY_TABLES below).

No, you right. I need to document all the above properly, which I is something
I am in the middle of.

>
> I actually wonder from looking at this whole patch if we even want to go
> here.  Maybe this is really the time to say that we should get rid of
> the dependency between the host page table layout and the stage-2 page
> table layout.
>
> Since the rest of this series looks pretty good, I'm wondering if you
> should just disable KVM in the config system if 16K pages is selected,
> and then you can move ahead with this series while we fix KVM properly?

I can send an updated version (which is in the test furnace) soon, so that
you can take a look ?

Suzuki
