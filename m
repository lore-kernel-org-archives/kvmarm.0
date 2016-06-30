From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 05/15] arm64: KVM: Refactor kern_hyp_va/hyp_kern_va to
 deal with multiple offsets
Date: Thu, 30 Jun 2016 10:22:22 +0100
Message-ID: <5774E4CE.8020200@arm.com>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
 <1465297115-13091-6-git-send-email-marc.zyngier@arm.com>
 <20160628124210.GP26498@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160628124210.GP26498@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 28/06/16 13:42, Christoffer Dall wrote:
> On Tue, Jun 07, 2016 at 11:58:25AM +0100, Marc Zyngier wrote:
>> As we move towards a selectable HYP VA range, it is obvious that
>> we don't want to test a variable to find out if we need to use
>> the bottom VA range, the top VA range, or use the address as is
>> (for VHE).
>>
>> Instead, we can expand our current helpers to generate the right
>> mask or nop with code patching. We default to using the top VA
>> space, with alternatives to switch to the bottom one or to nop
>> out the instructions.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_hyp.h | 27 ++++++++++++--------------
>>  arch/arm64/include/asm/kvm_mmu.h | 42 +++++++++++++++++++++++++++++++++++++---
>>  2 files changed, 51 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
>> index 61d01a9..dd4904b 100644
>> --- a/arch/arm64/include/asm/kvm_hyp.h
>> +++ b/arch/arm64/include/asm/kvm_hyp.h
>> @@ -25,24 +25,21 @@
>>  
>>  #define __hyp_text __section(.hyp.text) notrace
>>  
>> -static inline unsigned long __kern_hyp_va(unsigned long v)
>> -{
>> -	asm volatile(ALTERNATIVE("and %0, %0, %1",
>> -				 "nop",
>> -				 ARM64_HAS_VIRT_HOST_EXTN)
>> -		     : "+r" (v) : "i" (HYP_PAGE_OFFSET_MASK));
>> -	return v;
>> -}
>> -
>> -#define kern_hyp_va(v) (typeof(v))(__kern_hyp_va((unsigned long)(v)))
>> -
>>  static inline unsigned long __hyp_kern_va(unsigned long v)
>>  {
>> -	asm volatile(ALTERNATIVE("orr %0, %0, %1",
>> -				 "nop",
>> +	u64 mask;
>> +
>> +	asm volatile(ALTERNATIVE("mov %0, %1",
>> +				 "mov %0, %2",
>> +				 ARM64_HYP_OFFSET_LOW)
>> +		     : "=r" (mask)
>> +		     : "i" (~HYP_PAGE_OFFSET_HIGH_MASK),
>> +		       "i" (~HYP_PAGE_OFFSET_LOW_MASK));
>> +	asm volatile(ALTERNATIVE("nop",
>> +				 "mov %0, xzr",
>>  				 ARM64_HAS_VIRT_HOST_EXTN)
>> -		     : "+r" (v) : "i" (~HYP_PAGE_OFFSET_MASK));
>> -	return v;
>> +		     : "+r" (mask));
>> +	return v | mask;
> 
> If mask is ~HYP_PAGE_OFFSET_LOW_MASK how can you be sure that setting
> bit (VA_BITS - 1) is always the right thing to do to generate a kernel
> address?

It has taken be a while, but I think I finally see what you mean. We
have no idea whether that bit was set or not.

> This is kind of what I asked before only now there's an extra bit not
> guaranteed by the architecture to be set for the kernel range, I
> think.

Yeah, I finally connected the couple of neurons left up there (that's
what remains after the whole brexit braindamage). This doesn't work (or
rather it only works sometimes). The good new is that I also realized we
don't need any of that crap.

The only case we currently use a HVA->KVA transformation is to pass the
panic string down to panic(), and we can perfectly prevent
__kvm_hyp_teardown from ever be evaluated as a HVA with a bit of
asm-foo. This allows us to get rid of this whole function.

> 
>>  }
>>  
>>  #define hyp_kern_va(v) (typeof(v))(__hyp_kern_va((unsigned long)(v)))
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index e45df1b..889330b 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -95,13 +95,33 @@
>>  /*
>>   * Convert a kernel VA into a HYP VA.
>>   * reg: VA to be converted.
>> + *
>> + * This generates the following sequences:
>> + * - High mask:
>> + *		and x0, x0, #HYP_PAGE_OFFSET_HIGH_MASK
>> + *		nop
>> + * - Low mask:
>> + *		and x0, x0, #HYP_PAGE_OFFSET_HIGH_MASK
>> + *		and x0, x0, #HYP_PAGE_OFFSET_LOW_MASK
>> + * - VHE:
>> + *		nop
>> + *		nop
>> + *
>> + * The "low mask" version works because the mask is a strict subset of
>> + * the "high mask", hence performing the first mask for nothing.
>> + * Should be completely invisible on any viable CPU.
>>   */
>>  .macro kern_hyp_va	reg
>> -alternative_if_not ARM64_HAS_VIRT_HOST_EXTN	
>> -	and	\reg, \reg, #HYP_PAGE_OFFSET_MASK
>> +alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
>> +	and     \reg, \reg, #HYP_PAGE_OFFSET_HIGH_MASK
>>  alternative_else
>>  	nop
>>  alternative_endif
>> +alternative_if_not ARM64_HYP_OFFSET_LOW
>> +	nop
>> +alternative_else
>> +	and     \reg, \reg, #HYP_PAGE_OFFSET_LOW_MASK
>> +alternative_endif
>>  .endm
>>  
>>  #else
>> @@ -112,7 +132,23 @@ alternative_endif
>>  #include <asm/mmu_context.h>
>>  #include <asm/pgtable.h>
>>  
>> -#define KERN_TO_HYP(kva)	((unsigned long)kva & HYP_PAGE_OFFSET_MASK)
>> +static inline unsigned long __kern_hyp_va(unsigned long v)
>> +{
>> +	asm volatile(ALTERNATIVE("and %0, %0, %1",
>> +				 "nop",
>> +				 ARM64_HAS_VIRT_HOST_EXTN)
>> +		     : "+r" (v)
>> +		     : "i" (HYP_PAGE_OFFSET_HIGH_MASK));
>> +	asm volatile(ALTERNATIVE("nop",
>> +				 "and %0, %0, %1",
>> +				 ARM64_HYP_OFFSET_LOW)
>> +		     : "+r" (v)
>> +		     : "i" (HYP_PAGE_OFFSET_LOW_MASK));
> 
> how is the second operation a nop for VHE? Is this because
> ARM64_HYP_OFFSET_LOW will never be set for VHE?

That's because VHE has no notion of an offset at all (we end up with two
nops).

>> +	return v;
>> +}
>> +
>> +#define kern_hyp_va(v) 	(typeof(v))(__kern_hyp_va((unsigned long)(v)))
>> +#define KERN_TO_HYP(v)	kern_hyp_va(v)
> 
> looks like there's room for some unification/cleanup here as well.

Indeed. I'll queue up an additional patch at the end to clean the bulk
of the code.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
