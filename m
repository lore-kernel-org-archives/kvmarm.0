From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 10/21] arm64: KVM: Add patchable function selector
Date: Wed, 02 Dec 2015 13:19:22 +0000
Message-ID: <565EEFDA.8040706@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
 <1448650215-15218-11-git-send-email-marc.zyngier@arm.com>
 <20151201153900.GT11704@cbox> <565DEC14.8090206@arm.com>
 <20151202092720.GX11704@cbox> <565EBE3F.2050708@arm.com>
 <20151202115325.GG18376@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC7DE49761
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 08:17:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ie4xjKP2PAo9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2015 08:17:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70094413E1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 08:17:58 -0500 (EST)
In-Reply-To: <20151202115325.GG18376@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 02/12/15 11:53, Christoffer Dall wrote:
> On Wed, Dec 02, 2015 at 09:47:43AM +0000, Marc Zyngier wrote:
>> On 02/12/15 09:27, Christoffer Dall wrote:
>>> On Tue, Dec 01, 2015 at 06:51:00PM +0000, Marc Zyngier wrote:
>>>> On 01/12/15 15:39, Christoffer Dall wrote:
>>>>> On Fri, Nov 27, 2015 at 06:50:04PM +0000, Marc Zyngier wrote:
>>>>>> KVM so far relies on code patching, and is likely to use it more
>>>>>> in the future. The main issue is that our alternative system works
>>>>>> at the instruction level, while we'd like to have alternatives at
>>>>>> the function level.
>>>>>>
>>>>>> In order to cope with this, add the "hyp_alternate_select" macro that
>>>>>> outputs a brief sequence of code that in turn can be patched, allowing
>>>>>> al alternative function to be selected.
>>>>>
>>>>> s/al/an/ ?
>>>>>
>>>>>>
>>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>>> ---
>>>>>>  arch/arm64/kvm/hyp/hyp.h | 16 ++++++++++++++++
>>>>>>  1 file changed, 16 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
>>>>>> index 7ac8e11..f0427ee 100644
>>>>>> --- a/arch/arm64/kvm/hyp/hyp.h
>>>>>> +++ b/arch/arm64/kvm/hyp/hyp.h
>>>>>> @@ -27,6 +27,22 @@
>>>>>>  
>>>>>>  #define kern_hyp_va(v) (typeof(v))((unsigned long)v & HYP_PAGE_OFFSET_MASK)
>>>>>>  
>>>>>> +/*
>>>>>> + * Generates patchable code sequences that are used to switch between
>>>>>> + * two implementations of a function, depending on the availability of
>>>>>> + * a feature.
>>>>>> + */
>>>>>
>>>>> This looks right to me, but I'm a bit unclear what the types of this is
>>>>> and how to use it.
>>>>>
>>>>> Are orig and alt function pointers and cond is a CONFIG_FOO ?  fname is
>>>>> a symbol, which is defined as a prototype somewhere and then implemented
>>>>> here, or?
>>>>>
>>>>> Perhaps a Usage: part of the docs would be helpful.
>>>>
>>>> How about:
>>>>
>>>> @fname: a symbol name that will be defined as a function returning a
>>>> function pointer whose type will match @orig and @alt
>>>> @orig: A pointer to the default function, as returned by @fname when
>>>> @cond doesn't hold
>>>> @alt: A pointer to the alternate function, as returned by @fname when
>>>> @cond holds
>>>> @cond: a CPU feature (as described in asm/cpufeature.h)
>>>
>>> looks good.
>>>
>>>>
>>>>>
>>>>>> +#define hyp_alternate_select(fname, orig, alt, cond)			\
>>>>>> +typeof(orig) * __hyp_text fname(void)					\
>>>>>> +{									\
>>>>>> +	typeof(alt) *val = orig;					\
>>>>>> +	asm volatile(ALTERNATIVE("nop		\n",			\
>>>>>> +				 "mov	%0, %1	\n",			\
>>>>>> +				 cond)					\
>>>>>> +		     : "+r" (val) : "r" (alt));				\
>>>>>> +	return val;							\
>>>>>> +}
>>>>>> +
>>>>>>  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
>>>>>>  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
>>>>>>  
>>>>>> -- 
>>>>>> 2.1.4
>>>>>>
>>>>>
>>>>> I haven't thought much about how all of this is implemented, but from my
>>>>> point of views the ideal situation would be something like:
>>>>>
>>>>> void foo(int a, int b)
>>>>> {
>>>>> 	ALTERNATIVE_IF_NOT CONFIG_BAR
>>>>> 	foo_legacy(a, b);
>>>>> 	ALTERNATIVE_ELSE
>>>>> 	foo_new(a, b);
>>>>> 	ALTERNATIVE_END
>>>>> }
>>>>>
>>>>> I realize this may be impossible because the C code could implement all
>>>>> sort of fun stuff around the actual function calls, but would there be
>>>>> some way to annotate the functions and find the actual branch statement
>>>>> and change the target?
>>>>
>>>> The main issue is that C doesn't give you any access to the branch
>>>> function itself, except for the asm-goto statements. It also makes it
>>>> very hard to preserve the return type. For your idea to work, we'd need
>>>> some support in the compiler itself. I'm sure that it is doable, just
>>>> not by me! ;-)
>>>
>>> Not by me either, I'm just asking stupid questions - as always.
>>
>> I don't find that stupid. Asking that kind of stuff is useful to put
>> things in perspective.
>>
> 
> Thanks!
> 
>>>>
>>>> This is why I've ended up creating something that returns a function
>>>> *pointer*, because that's something that exists in the language (no new
>>>> concept). I simply made sure I could return it at minimal cost.
>>>>
>>>
>>> I don't have a problem with this either.  I'm curious though, how much
>>> of a performance improvement (and why) we get from doing this as opposed
>>> to a simple if-statement?
>>
>> An if statement will involve fetching some configuration from memory.
>> You can do that, but you are going to waste a cache line and memory
>> bandwidth (both which are scarce resources) for something that never
>> ever changes over the life of the system. These things tend to accumulate.
> 
> Sure, but won't you be fetching the function pointer from memory anyway?

No, and that's the whole point of this patch: the function pointers are
loaded into registers as PC-relative constants (adrp+add), the selection
being done by a mov or a nop. For example:

ffffffc0007f1f60:       90000001        adrp    x1, ffffffc0007f1000
ffffffc0007f1f64:       90000000        adrp    x0, ffffffc0007f1000
ffffffc0007f1f68:       91036021        add     x1, x1, #0xd8
ffffffc0007f1f6c:       910b0000        add     x0, x0, #0x2c0
ffffffc0007f1f70:       d503201f        nop
ffffffc0007f1f74:       aa1303e0        mov     x0, x19
ffffffc0007f1f78:       d63f0020        blr     x1

For the default condition (the above code), the CPU is likely to discard
the second adrp+add (because of the mov x0, x19). For the alternate, the
nop is replaced by a "mov x1, x0", which makes the first adrp+add
irrelevant (it will be eliminated in the pipeline of any decent CPU).

While this has a cost in terms of instruction footprint, the branch
predictor is quickly going to find out where we're branching. We also
avoid fetching both from the I and D sides, which could kill the branch
predictor if not speculated in time. In the end, we get something that
is a lot more predictable, even for simpler CPU designs.

	M.
-- 
Jazz is not dead. It just smells funny...
