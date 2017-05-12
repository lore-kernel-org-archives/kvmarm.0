From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/5] arm64: KVM: Do not use stack-protector to compile EL2
 code
Date: Fri, 12 May 2017 16:07:24 +0100
Message-ID: <808c6633-952a-d168-4cec-e4ce310910df@arm.com>
References: <20170502133041.10980-1-marc.zyngier@arm.com>
 <20170502133041.10980-2-marc.zyngier@arm.com>
 <20170502144029.GB29224@e104818-lin.cambridge.arm.com>
 <334c4025-873d-d30c-534b-4194c78eb64b@arm.com>
 <62f8cd12-7d1a-e31e-c318-c5b11560b549@arm.com>
 <CAKv+Gu-6nOtsk_8R3RC9je_DOjYcqabF+=DH-bBdnqTEi5BusQ@mail.gmail.com>
 <CAKv+Gu9q+3iqgwc9_tRkGcd2GnDoy8T47r5qj_fhNb3-h+Octw@mail.gmail.com>
 <7c15b5a7-5557-7615-802b-60bd7252115c@arm.com>
 <CAKv+Gu8js81AzSOrD5nv0BsdhnU5VdNTycktja6q49vpqy4AkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8js81AzSOrD5nv0BsdhnU5VdNTycktja6q49vpqy4AkA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, KVM devel mailing list <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/05/17 18:01, Ard Biesheuvel wrote:
> On 11 May 2017 at 17:42, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 11/05/17 17:36, Ard Biesheuvel wrote:
>>> On 11 May 2017 at 17:11, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>>> On 11 May 2017 at 17:02, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>>> On 02/05/17 15:50, Marc Zyngier wrote:
>>>>>> On 02/05/17 15:40, Catalin Marinas wrote:
>>>>>>> On Tue, May 02, 2017 at 02:30:37PM +0100, Marc Zyngier wrote:
>>>>>>>> We like living dangerously. Nothing explicitely forbids stack-protector
>>>>>>>> to be used in the EL2 code, while distributions routinely compile their
>>>>>>>> kernel with it. We're just lucky that no code actually triggers the
>>>>>>>> instrumentation.
>>>>>>>>
>>>>>>>> Let's not try our luck for much longer, and disable stack-protector
>>>>>>>> for code living at EL2.
>>>>>>>>
>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>>>>> ---
>>>>>>>>  arch/arm64/kvm/hyp/Makefile | 2 ++
>>>>>>>>  1 file changed, 2 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>>>>>>>> index aaf42ae8d8c3..14c4e3b14bcb 100644
>>>>>>>> --- a/arch/arm64/kvm/hyp/Makefile
>>>>>>>> +++ b/arch/arm64/kvm/hyp/Makefile
>>>>>>>> @@ -2,6 +2,8 @@
>>>>>>>>  # Makefile for Kernel-based Virtual Machine module, HYP part
>>>>>>>>  #
>>>>>>>>
>>>>>>>> +ccflags-y += -fno-stack-protector
>>>>>>>> +
>>>>>>>
>>>>>>> While you are at it, should we have a -fpic here as well? The hyp code
>>>>>>> runs at a different location than the rest of the kernel.
>>>>>>
>>>>>> We definitely should. I've just tried this, and this doesn't seem to
>>>>>> work very well. At least this seems to break our jump label
>>>>>> implementation. I need to page in that part of the code base and see
>>>>>> what happens.
>>>>>
>>>>> So here's the issue:
>>>>>
>>>>>   CC      arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/vgic-v3-sr.o
>>>>> In file included from ./include/linux/jump_label.h:120:0,
>>>>>                  from ./include/linux/dynamic_debug.h:5,
>>>>>                  from ./include/linux/printk.h:329,
>>>>>                  from ./include/linux/kernel.h:13,
>>>>>                  from ./include/asm-generic/bug.h:15,
>>>>>                  from ./arch/arm64/include/asm/bug.h:66,
>>>>>                  from ./include/linux/bug.h:4,
>>>>>                  from ./include/linux/mmdebug.h:4,
>>>>>                  from ./include/linux/mm.h:8,
>>>>>                  from ./arch/arm64/include/asm/cacheflush.h:22,
>>>>>                  from ./arch/arm64/include/asm/arch_gicv3.h:27,
>>>>>                  from ./include/linux/irqchip/arm-gic-v3.h:453,
>>>>>                  from arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/vgic-v3-sr.c:19:
>>>>> ./arch/arm64/include/asm/jump_label.h: In function '__vgic_v3_save_state':
>>>>> ./arch/arm64/include/asm/jump_label.h:31:2: warning: asm operand 0 probably doesn't match constraints
>>>>>   asm goto("1: nop\n\t"
>>>>>   ^~~
>>>>> ./arch/arm64/include/asm/jump_label.h:31:2: error: impossible constraint in 'asm'
>>>>> ./arch/arm64/include/asm/jump_label.h: In function '__vgic_v3_restore_state':
>>>>> ./arch/arm64/include/asm/jump_label.h:31:2: warning: asm operand 0 probably doesn't match constraints
>>>>>   asm goto("1: nop\n\t"
>>>>>   ^~~
>>>>> scripts/Makefile.build:294: recipe for target 'arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/vgic-v3-sr.o' failed
>>>>> make[1]: *** [arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/vgic-v3-sr.o] Error 1
>>>>> Makefile:1664: recipe for target 'arch/arm64/kvm/hyp/' failed
>>>>>
>>>>> The corresponding code does this:
>>>>>
>>>>> static __always_inline bool arch_static_branch(struct static_key *key, bool branch)
>>>>> {
>>>>>         asm goto("1: nop\n\t"
>>>>>                  ".pushsection __jump_table,  \"aw\"\n\t"
>>>>>                  ".align 3\n\t"
>>>>>                  ".quad 1b, %l[l_yes], %c0\n\t"
>>>>>                  ".popsection\n\t"
>>>>>                  :  :  "i"(&((char *)key)[branch]) :  : l_yes);
>>>>>
>>>>>         return false;
>>>>> l_yes:
>>>>>         return true;
>>>>> }
>>>>>
>>>>> and the problem lies in the evaluation of "key", which probably
>>>>> cannot be guaranteed a constant at that point. There is also the
>>>>> issue that even if it was known, the branch cannot be easily
>>>>> patched in from the rest of the kernel (how is the l_yes address
>>>>> represented?).
>>>>>
>>>>> It looks to me like we either need to rewrite the whole of our
>>>>> static key infrastructure to cope with PIC, or switch over to
>>>>> the hyp_alternate_select() hack, which I'd rather avoid spreading
>>>>> further.
>>>>>
>>>>> In the end, I wonder if that's even worth it...
>>>>>
>>>>
>>>> Could you check if it builds with
>>>>
>>>>>                  ".long 1b - ., %l[l_yes] - ., %c0 - .\n\t"
>>>>
>>>> instead? We'd still need to update the code that interprets the
>>>> __jump_table fields, but it changes the references into relative ones,
>>>> which also reduces the size as a bonus.
>>>
>>> OK, strike that, this is more tricky than I thought. I am failing to
>>> reproduce this locally, though. Which gcc and tree are you using?
>>
>> That's current mainline + a number of patches which I don't think are
>> relevant to this discussion, and -fPIC added to
>> arch/arm64/kvm/hyp/Makefile. You should see it exploding in timer-sr.c
>> because of the has_vhe() helper.
>>
>> GCC is "aarch64-linux-gnu-gcc (Linaro GCC 6.2-2016.11) 6.2.1 20161016".
>>
> 
> Nope, builds fine, with Linaro GCC 5.4.0 and 'ccflags-y += -fPIC'
> added to arch/arm64/kvm/hyp/Makefile.

Weird. I can't get it to build (just tried with GCC 5.4.1 as well):

  CC      arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/timer-sr.o
In file included from ./include/linux/jump_label.h:120:0,
                 from ./include/linux/static_key.h:1,
                 from ./include/linux/context_tracking_state.h:5,
                 from ./include/linux/vtime.h:4,
                 from ./include/linux/hardirq.h:7,
                 from ./include/linux/kvm_host.h:10,
                 from arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/timer-sr.c:20:
./arch/arm64/include/asm/jump_label.h: In function ‘__timer_save_state’:
./arch/arm64/include/asm/jump_label.h:31:2: warning: asm operand 0 probably doesn’t match constraints
  asm goto("1: nop\n\t"
  ^
./arch/arm64/include/asm/jump_label.h:31:2: error: impossible constraint in ‘asm’
./arch/arm64/include/asm/jump_label.h: In function ‘__timer_restore_state’:
./arch/arm64/include/asm/jump_label.h:31:2: warning: asm operand 0 probably doesn’t match constraints
  asm goto("1: nop\n\t"
  ^
scripts/Makefile.build:302: recipe for target 'arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/timer-sr.o' failed

(defconfig build)

> In any case, it is worth trying whether -fpie behaves differently: as
> per my other reply, aarch64 small model code is already mostly
> position independent anyway, and so -fpic (which is intended for
> dynamic linking under ELF preemption rules*) is more likely to emit
> absolute symbol references than ordinary code. -fpie is supposed to be
> the middle ground here, but I dismissed it for the EFI stub because I
> could not get it to work at the time.

-fpie have the same effect here. I really wonder what's wrong with my setup.

	M.
-- 
Jazz is not dead. It just smells funny...
