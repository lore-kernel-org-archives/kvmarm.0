From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 05/15] arm64: KVM: Refactor kern_hyp_va/hyp_kern_va to
 deal with multiple offsets
Date: Thu, 30 Jun 2016 12:57:42 +0100
Message-ID: <57750936.9070800@arm.com>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
 <1465297115-13091-6-git-send-email-marc.zyngier@arm.com>
 <20160628124210.GP26498@cbox> <5774E4CE.8020200@arm.com>
 <5774F18C.7030603@arm.com>
 <CAKv+Gu84EzsO4Sy07ACJ_nsok0Xr2KOkaeKRz0ObHU=0kzEZ-g@mail.gmail.com>
 <5774FC2C.2070607@arm.com>
 <CAKv+Gu-GugAUDavzTWb_HD76vg7w7tWWD3xiLGp=QE2x44ZVWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35F3549B53
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 07:52:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wgBbLZoIdVSy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 07:52:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C428D49B51
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 07:52:31 -0400 (EDT)
In-Reply-To: <CAKv+Gu-GugAUDavzTWb_HD76vg7w7tWWD3xiLGp=QE2x44ZVWQ@mail.gmail.com>
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
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, KVM devel mailing list <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 30/06/16 12:10, Ard Biesheuvel wrote:
> On 30 June 2016 at 13:02, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 30/06/16 11:42, Ard Biesheuvel wrote:
>>> On 30 June 2016 at 12:16, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>> On 30/06/16 10:22, Marc Zyngier wrote:
>>>>> On 28/06/16 13:42, Christoffer Dall wrote:
>>>>>> On Tue, Jun 07, 2016 at 11:58:25AM +0100, Marc Zyngier wrote:
>>>>>>> As we move towards a selectable HYP VA range, it is obvious that
>>>>>>> we don't want to test a variable to find out if we need to use
>>>>>>> the bottom VA range, the top VA range, or use the address as is
>>>>>>> (for VHE).
>>>>>>>
>>>>>>> Instead, we can expand our current helpers to generate the right
>>>>>>> mask or nop with code patching. We default to using the top VA
>>>>>>> space, with alternatives to switch to the bottom one or to nop
>>>>>>> out the instructions.
>>>>>>>
>>>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>>>> ---
>>>>>>>  arch/arm64/include/asm/kvm_hyp.h | 27 ++++++++++++--------------
>>>>>>>  arch/arm64/include/asm/kvm_mmu.h | 42 +++++++++++++++++++++++++++++++++++++---
>>>>>>>  2 files changed, 51 insertions(+), 18 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
>>>>>>> index 61d01a9..dd4904b 100644
>>>>>>> --- a/arch/arm64/include/asm/kvm_hyp.h
>>>>>>> +++ b/arch/arm64/include/asm/kvm_hyp.h
>>>>>>> @@ -25,24 +25,21 @@
>>>>>>>
>>>>>>>  #define __hyp_text __section(.hyp.text) notrace
>>>>>>>
>>>>>>> -static inline unsigned long __kern_hyp_va(unsigned long v)
>>>>>>> -{
>>>>>>> -   asm volatile(ALTERNATIVE("and %0, %0, %1",
>>>>>>> -                            "nop",
>>>>>>> -                            ARM64_HAS_VIRT_HOST_EXTN)
>>>>>>> -                : "+r" (v) : "i" (HYP_PAGE_OFFSET_MASK));
>>>>>>> -   return v;
>>>>>>> -}
>>>>>>> -
>>>>>>> -#define kern_hyp_va(v) (typeof(v))(__kern_hyp_va((unsigned long)(v)))
>>>>>>> -
>>>>>>>  static inline unsigned long __hyp_kern_va(unsigned long v)
>>>>>>>  {
>>>>>>> -   asm volatile(ALTERNATIVE("orr %0, %0, %1",
>>>>>>> -                            "nop",
>>>>>>> +   u64 mask;
>>>>>>> +
>>>>>>> +   asm volatile(ALTERNATIVE("mov %0, %1",
>>>>>>> +                            "mov %0, %2",
>>>>>>> +                            ARM64_HYP_OFFSET_LOW)
>>>>>>> +                : "=r" (mask)
>>>>>>> +                : "i" (~HYP_PAGE_OFFSET_HIGH_MASK),
>>>>>>> +                  "i" (~HYP_PAGE_OFFSET_LOW_MASK));
>>>>>>> +   asm volatile(ALTERNATIVE("nop",
>>>>>>> +                            "mov %0, xzr",
>>>>>>>                              ARM64_HAS_VIRT_HOST_EXTN)
>>>>>>> -                : "+r" (v) : "i" (~HYP_PAGE_OFFSET_MASK));
>>>>>>> -   return v;
>>>>>>> +                : "+r" (mask));
>>>>>>> +   return v | mask;
>>>>>>
>>>>>> If mask is ~HYP_PAGE_OFFSET_LOW_MASK how can you be sure that setting
>>>>>> bit (VA_BITS - 1) is always the right thing to do to generate a kernel
>>>>>> address?
>>>>>
>>>>> It has taken be a while, but I think I finally see what you mean. We
>>>>> have no idea whether that bit was set or not.
>>>>>
>>>>>> This is kind of what I asked before only now there's an extra bit not
>>>>>> guaranteed by the architecture to be set for the kernel range, I
>>>>>> think.
>>>>>
>>>>> Yeah, I finally connected the couple of neurons left up there (that's
>>>>> what remains after the whole brexit braindamage). This doesn't work (or
>>>>> rather it only works sometimes). The good new is that I also realized we
>>>>> don't need any of that crap.
>>>>>
>>>>> The only case we currently use a HVA->KVA transformation is to pass the
>>>>> panic string down to panic(), and we can perfectly prevent
>>>>> __kvm_hyp_teardown from ever be evaluated as a HVA with a bit of
>>>>> asm-foo. This allows us to get rid of this whole function.
>>>>
>>>> Here's what I meant by this:
>>>>
>>>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>>>> index 437cfad..c19754d 100644
>>>> --- a/arch/arm64/kvm/hyp/switch.c
>>>> +++ b/arch/arm64/kvm/hyp/switch.c
>>>> @@ -299,9 +299,16 @@ static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%
>>>>
>>>>  static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par)
>>>>  {
>>>> -       unsigned long str_va = (unsigned long)__hyp_panic_string;
>>>> +       unsigned long str_va;
>>>>
>>>> -       __hyp_do_panic(hyp_kern_va(str_va),
>>>> +       /*
>>>> +        * Force the panic string to be loaded from the literal pool,
>>>> +        * making sure it is a kernel address and not a PC-relative
>>>> +        * reference.
>>>> +        */
>>>> +       asm volatile("ldr %0, =__hyp_panic_string" : "=r" (str_va));
>>>> +
>>>
>>> Wouldn't it suffice to make  __hyp_panic_string a non-static pointer
>>> to const char? That way, it will be statically initialized with a
>>> kernel VA, and the external linkage forces the compiler to evaluate
>>> its value at runtime.
>>
>> Yup, that would work as well. The only nit is that the pointer needs to be
>> in the __hyp_text section, and my compiler is shouting at me with this:
>>
>>   CC      arch/arm64/kvm/hyp/switch.o
>> arch/arm64/kvm/hyp/switch.c: In function '__hyp_call_panic_vhe':
>> arch/arm64/kvm/hyp/switch.c:298:13: error: __hyp_panic_string causes a section type conflict with __fpsimd_enabled_nvhe
>>  const char *__hyp_panic_string __section(.hyp.text) = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
>>              ^
>> arch/arm64/kvm/hyp/switch.c:22:24: note: '__fpsimd_enabled_nvhe' was declared here
>>  static bool __hyp_text __fpsimd_enabled_nvhe(void)
>>
>> Any clue?
>>
> 
> The pointer is writable/non-exec and the code is readonly/exec, so it
> makes sense for the compiler to complain about this. It needs to be
> non-const, though, to prevent the compiler from short-circuiting the
> evaluation, so the only solution would be to add a .hyp.data section
> to the linker script, and put the __hyp_panic_string pointer in there.
> 
> Not worth the trouble, perhaps ...

Yeah. Slightly overkill for something that is not meant to be used...
I'll keep the asm hack for now, with a mental note of moving this to a
.hyp.data section if we ever create one for other reasons.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
