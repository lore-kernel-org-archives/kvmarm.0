From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 10/19] KVM: arm/arm64: Do not use kern_hyp_va() with
 kvm_vgic_global_state
Date: Tue, 20 Feb 2018 11:40:02 +0000
Message-ID: <3b8c1304-704a-9db6-2215-ec9439b30ae6@arm.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-11-marc.zyngier@arm.com> <20180115153632.GK21403@cbox>
 <af5ddd03-ddaa-0fe9-51ec-4946b5adfe1c@arm.com> <20180216090543.GC10440@cbox>
 <3b5ec8d7-01b0-86ce-f709-185821e68d47@arm.com> <20180219143941.GA16779@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180219143941.GA16779@cbox>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 19/02/18 14:39, Christoffer Dall wrote:
> On Fri, Feb 16, 2018 at 09:33:39AM +0000, Marc Zyngier wrote:
>> On 16/02/18 09:05, Christoffer Dall wrote:
>>> On Thu, Feb 15, 2018 at 01:22:56PM +0000, Marc Zyngier wrote:
>>>> On 15/01/18 15:36, Christoffer Dall wrote:
>>>>> On Thu, Jan 04, 2018 at 06:43:25PM +0000, Marc Zyngier wrote:
>>>>>> kvm_vgic_global_state is part of the read-only section, and is
>>>>>> usually accessed using a PC-relative address generation (adrp + add).
>>>>>>
>>>>>> It is thus useless to use kern_hyp_va() on it, and actively problematic
>>>>>> if kern_hyp_va() becomes non-idempotent. On the other hand, there is
>>>>>> no way that the compiler is going to guarantee that such access is
>>>>>> always be PC relative.
>>>>>
>>>>> nit: is always be
>>>>>
>>>>>>
>>>>>> So let's bite the bullet and provide our own accessor.
>>>>>>
>>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>>> ---
>>>>>>  arch/arm/include/asm/kvm_hyp.h   | 6 ++++++
>>>>>>  arch/arm64/include/asm/kvm_hyp.h | 9 +++++++++
>>>>>>  virt/kvm/arm/hyp/vgic-v2-sr.c    | 4 ++--
>>>>>>  3 files changed, 17 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
>>>>>> index ab20ffa8b9e7..1d42d0aa2feb 100644
>>>>>> --- a/arch/arm/include/asm/kvm_hyp.h
>>>>>> +++ b/arch/arm/include/asm/kvm_hyp.h
>>>>>> @@ -26,6 +26,12 @@
>>>>>>  
>>>>>>  #define __hyp_text __section(.hyp.text) notrace
>>>>>>  
>>>>>> +#define hyp_symbol_addr(s)						\
>>>>>> +	({								\
>>>>>> +		typeof(s) *addr = &(s);					\
>>>>>> +		addr;							\
>>>>>> +	})
>>>>>> +
>>>>>>  #define __ACCESS_VFP(CRn)			\
>>>>>>  	"mrc", "mcr", __stringify(p10, 7, %0, CRn, cr0, 0), u32
>>>>>>  
>>>>>> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
>>>>>> index 08d3bb66c8b7..a2d98c539023 100644
>>>>>> --- a/arch/arm64/include/asm/kvm_hyp.h
>>>>>> +++ b/arch/arm64/include/asm/kvm_hyp.h
>>>>>> @@ -25,6 +25,15 @@
>>>>>>  
>>>>>>  #define __hyp_text __section(.hyp.text) notrace
>>>>>>  
>>>>>> +#define hyp_symbol_addr(s)						\
>>>>>> +	({								\
>>>>>> +		typeof(s) *addr;					\
>>>>>> +		asm volatile("adrp	%0, %1\n"			\
>>>>>> +			     "add	%0, %0, :lo12:%1\n"		\
>>>>>> +			     : "=r" (addr) : "S" (&s));			\
>>>>>
>>>>> Can't we use adr_l here?
>>>>
>>>> Unfortunately not. All the asm/assembler.h macros are unavailable to
>>>> inline assembly. We could start introducing equivalent macros for that
>>>> purpose, but that's starting to be outside of the scope of this series.
>>>>
>>>
>>> Absolutely.  Forget I asked.
>>>
>>>>>
>>>>>> +		addr;							\
>>>>>> +	})
>>>>>> +
>>>>>
>>>>> I don't fully appreciate the semantics of this macro going by its name
>>>>> only.  My understanding is that if you want to resolve a symbol to an
>>>>> address which is mapped in hyp, then use this.  Is this correct?
>>>>
>>>> The goal of this macro is to return a symbol's address based on a
>>>> PC-relative computation, as opposed to a loading the VA from a constant
>>>> pool or something similar. This works well for HYP, as an absolute VA is
>>>> guaranteed to be wrong.
>>>>
>>>>>
>>>>> If so, can we add a small comment (because I can't come up with a better
>>>>> name).
>>>>
>>>> I'll add the above if that works for you.
>>>>
>>>
>>> Yes it does.  The only thing that remains a bit unclear is what the
>>> difference between this and kern_hyp_va is, and when you'd choose to use
>>> one over the other.  Perhaps we need a single place which documents our
>>> primitives and tells us what to use when.  At least, I'm for sure not
>>> going to be able to figure this out later on.
>>
>> Let me try to explain that:
>>
>> The two primitives work on different "objects". kern_hyp_va() works on
>> an address. If what you have is a pointer, then kern_hyp_va is your
>> friend. On the contrary, if what you have is a symbol instead of the
>> address of that object (and thus not something we obtain by reading a
>> variable), then hyp_symbol_addr is probably what you need.
>>
>> Of course, a symbol can also be a variable, which makes things a bit
>> harder. The asm constraint are such as compilation will break if you try
>> to treat a local variable as a symbol (the 'S' constraint is defined as
>> "An absolute symbolic address or a label reference", and the '&s' makes
>> it pretty hard to fool).
>>
>> I've tried to make it make it foolproof, but who knows... ;-)
>>
> ok, so what exactly is this macro doing different then simply using the
> symbol directly?  Only ensuring that the generated code is using
> PC-relative addressing?  If so, should we be using this macro everywhere
> in Hyp code where we dereference a symbol?

I think we should. We so far rely on the fact that the compiler won't be
stupid enough to generate a constant pool load to compute an address
that it can reach using PC-relative addressing, but you never know.

> What is it about hyp code that makes us need this when it's not needed
> for the kernel itself, and both support address space randomization?  Is
> that because the main kernel is properly relocated after deciding on the
> randomization, but Hyp is not?

The issue is that the kernel is linked at a particular VA, and we run it
at another. This hasn't much to do with randomization.

> It may be worth trying to put hyp_symbol_addr and kern_hyp_va in the
> same header file and have something explaining when to use what and why
> in that single place, but if that breaks the world, then never mind...

Seems sensible.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
