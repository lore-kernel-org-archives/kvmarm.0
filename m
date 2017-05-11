From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/5] arm64: KVM: Do not use stack-protector to compile EL2
 code
Date: Thu, 11 May 2017 17:36:17 +0100
Message-ID: <CAKv+Gu9q+3iqgwc9_tRkGcd2GnDoy8T47r5qj_fhNb3-h+Octw@mail.gmail.com>
References: <20170502133041.10980-1-marc.zyngier@arm.com>
 <20170502133041.10980-2-marc.zyngier@arm.com>
 <20170502144029.GB29224@e104818-lin.cambridge.arm.com>
 <334c4025-873d-d30c-534b-4194c78eb64b@arm.com>
 <62f8cd12-7d1a-e31e-c318-c5b11560b549@arm.com>
 <CAKv+Gu-6nOtsk_8R3RC9je_DOjYcqabF+=DH-bBdnqTEi5BusQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD9840296
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 May 2017 12:33:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UsOUOHeYc4ey for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 May 2017 12:32:59 -0400 (EDT)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com
 [209.85.223.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDBA5400E9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 May 2017 12:32:59 -0400 (EDT)
Received: by mail-io0-f170.google.com with SMTP id k91so24995453ioi.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 May 2017 09:36:18 -0700 (PDT)
In-Reply-To: <CAKv+Gu-6nOtsk_8R3RC9je_DOjYcqabF+=DH-bBdnqTEi5BusQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, KVM devel mailing list <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 11 May 2017 at 17:11, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 11 May 2017 at 17:02, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 02/05/17 15:50, Marc Zyngier wrote:
>>> On 02/05/17 15:40, Catalin Marinas wrote:
>>>> On Tue, May 02, 2017 at 02:30:37PM +0100, Marc Zyngier wrote:
>>>>> We like living dangerously. Nothing explicitely forbids stack-protector
>>>>> to be used in the EL2 code, while distributions routinely compile their
>>>>> kernel with it. We're just lucky that no code actually triggers the
>>>>> instrumentation.
>>>>>
>>>>> Let's not try our luck for much longer, and disable stack-protector
>>>>> for code living at EL2.
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>> ---
>>>>>  arch/arm64/kvm/hyp/Makefile | 2 ++
>>>>>  1 file changed, 2 insertions(+)
>>>>>
>>>>> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>>>>> index aaf42ae8d8c3..14c4e3b14bcb 100644
>>>>> --- a/arch/arm64/kvm/hyp/Makefile
>>>>> +++ b/arch/arm64/kvm/hyp/Makefile
>>>>> @@ -2,6 +2,8 @@
>>>>>  # Makefile for Kernel-based Virtual Machine module, HYP part
>>>>>  #
>>>>>
>>>>> +ccflags-y += -fno-stack-protector
>>>>> +
>>>>
>>>> While you are at it, should we have a -fpic here as well? The hyp code
>>>> runs at a different location than the rest of the kernel.
>>>
>>> We definitely should. I've just tried this, and this doesn't seem to
>>> work very well. At least this seems to break our jump label
>>> implementation. I need to page in that part of the code base and see
>>> what happens.
>>
>> So here's the issue:
>>
>>   CC      arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/vgic-v3-sr.o
>> In file included from ./include/linux/jump_label.h:120:0,
>>                  from ./include/linux/dynamic_debug.h:5,
>>                  from ./include/linux/printk.h:329,
>>                  from ./include/linux/kernel.h:13,
>>                  from ./include/asm-generic/bug.h:15,
>>                  from ./arch/arm64/include/asm/bug.h:66,
>>                  from ./include/linux/bug.h:4,
>>                  from ./include/linux/mmdebug.h:4,
>>                  from ./include/linux/mm.h:8,
>>                  from ./arch/arm64/include/asm/cacheflush.h:22,
>>                  from ./arch/arm64/include/asm/arch_gicv3.h:27,
>>                  from ./include/linux/irqchip/arm-gic-v3.h:453,
>>                  from arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/vgic-v3-sr.c:19:
>> ./arch/arm64/include/asm/jump_label.h: In function '__vgic_v3_save_state':
>> ./arch/arm64/include/asm/jump_label.h:31:2: warning: asm operand 0 probably doesn't match constraints
>>   asm goto("1: nop\n\t"
>>   ^~~
>> ./arch/arm64/include/asm/jump_label.h:31:2: error: impossible constraint in 'asm'
>> ./arch/arm64/include/asm/jump_label.h: In function '__vgic_v3_restore_state':
>> ./arch/arm64/include/asm/jump_label.h:31:2: warning: asm operand 0 probably doesn't match constraints
>>   asm goto("1: nop\n\t"
>>   ^~~
>> scripts/Makefile.build:294: recipe for target 'arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/vgic-v3-sr.o' failed
>> make[1]: *** [arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/vgic-v3-sr.o] Error 1
>> Makefile:1664: recipe for target 'arch/arm64/kvm/hyp/' failed
>>
>> The corresponding code does this:
>>
>> static __always_inline bool arch_static_branch(struct static_key *key, bool branch)
>> {
>>         asm goto("1: nop\n\t"
>>                  ".pushsection __jump_table,  \"aw\"\n\t"
>>                  ".align 3\n\t"
>>                  ".quad 1b, %l[l_yes], %c0\n\t"
>>                  ".popsection\n\t"
>>                  :  :  "i"(&((char *)key)[branch]) :  : l_yes);
>>
>>         return false;
>> l_yes:
>>         return true;
>> }
>>
>> and the problem lies in the evaluation of "key", which probably
>> cannot be guaranteed a constant at that point. There is also the
>> issue that even if it was known, the branch cannot be easily
>> patched in from the rest of the kernel (how is the l_yes address
>> represented?).
>>
>> It looks to me like we either need to rewrite the whole of our
>> static key infrastructure to cope with PIC, or switch over to
>> the hyp_alternate_select() hack, which I'd rather avoid spreading
>> further.
>>
>> In the end, I wonder if that's even worth it...
>>
>
> Could you check if it builds with
>
>>                  ".long 1b - ., %l[l_yes] - ., %c0 - .\n\t"
>
> instead? We'd still need to update the code that interprets the
> __jump_table fields, but it changes the references into relative ones,
> which also reduces the size as a bonus.

OK, strike that, this is more tricky than I thought. I am failing to
reproduce this locally, though. Which gcc and tree are you using?
