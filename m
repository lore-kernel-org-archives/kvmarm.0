From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 18/19] arm64: KVM: Introduce EL2 VA randomisation
Date: Thu, 15 Feb 2018 15:32:52 +0000
Message-ID: <c695d034-8352-abc1-ecf7-e166085b531a@arm.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-19-marc.zyngier@arm.com> <20180118202824.GF21802@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18E8540C5B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Feb 2018 10:26:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eLQ70sCpOvlH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Feb 2018 10:26:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 622D6401CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Feb 2018 10:26:34 -0500 (EST)
In-Reply-To: <20180118202824.GF21802@cbox>
Content-Language: en-GB
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 18/01/18 20:28, Christoffer Dall wrote:
> On Thu, Jan 04, 2018 at 06:43:33PM +0000, Marc Zyngier wrote:
>> The main idea behind randomising the EL2 VA is that we usually have
>> a few spare bits between the most significant bit of the VA mask
>> and the most significant bit of the linear mapping.
>>
>> Those bits could be a bunch of zeroes, and could be useful
>> to move things around a bit. Of course, the more memory you have,
>> the less randomisation you get...
>>
>> Alternatively, these bits could be the result of KASLR, in which
>> case they are already random. But it would be nice to have a
>> *different* randomization, just to make the job of a potential
>> attacker a bit more difficult.
>>
>> Inserting these random bits is a bit involved. We don't have a spare
>> register (short of rewriting all the kern_hyp_va call sites), and
>> the immediate we want to insert is too random to be used with the
>> ORR instruction. The best option I could come up with is the following
>> sequence:
>>
>> 	and x0, x0, #va_mask
> 
> So if I get this right, you want to insert an arbitrary random value
> without an extra register in bits [(VA_BITS-1):first_random_bit] and
> BIT(VA_BITS-1) is always set in the input because it's a kernel address.

Correct.

> 
>> 	ror x0, x0, #first_random_bit
> 
> Then you rotate so that the random bits become the LSBs and the random
> value should be inserted into bits [NR_RAND_BITS-1:0] in x0 ?

Correct again. The important thing to notice is that the bottom bits are
guaranteed to be zero, making sure that the subsequent adds act as ors.

> 
>> 	add x0, x0, #(random & 0xfff)
> 
> So you do this via two rounds, first the lower 12 bits
> 
>> 	add x0, x0, #(random >> 12), lsl #12
> 
> Then the upper 12 bits (permitting a maximum of 24 randomized bits)

Still correct. It is debatable whether allowing more than 12 bits is
really useful, as only platforms with very little memory will be able to
reach past 12 bits of entropy.

> 
>> 	ror x0, x0, #(63 - first_random_bit)
> 
> And then you rotate things back into their place.
> 
> Only, I don't understand why this isn't then (64 - first_random_bit) ?

That looks like a typo.

> 
>>
>> making it a fairly long sequence, but one that a decent CPU should
>> be able to execute without breaking a sweat. It is of course NOPed
>> out on VHE. The last 4 instructions can also be turned into NOPs
>> if it appears that there is no free bits to use.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_mmu.h | 10 +++++-
>>  arch/arm64/kvm/va_layout.c       | 68 +++++++++++++++++++++++++++++++++++++---
>>  virt/kvm/arm/mmu.c               |  2 +-
>>  3 files changed, 73 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index cc882e890bb1..4fca6ddadccc 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -85,6 +85,10 @@
>>  .macro kern_hyp_va	reg
>>  alternative_cb kvm_update_va_mask
>>  	and     \reg, \reg, #1
>> +	ror	\reg, \reg, #1
>> +	add	\reg, \reg, #0
>> +	add	\reg, \reg, #0
>> +	ror	\reg, \reg, #63
>>  alternative_cb_end
>>  .endm
>>  
>> @@ -101,7 +105,11 @@ void kvm_update_va_mask(struct alt_instr *alt,
>>  
>>  static inline unsigned long __kern_hyp_va(unsigned long v)
>>  {
>> -	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n",
>> +	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"
>> +				    "ror %0, %0, #1\n"
>> +				    "add %0, %0, #0\n"
>> +				    "add %0, %0, #0\n"
>> +				    "ror %0, %0, #63\n",
> 
> This now sort of serves as the documentation if you don't have the
> commit message, so I think you should annotate each line like the commit
> message does.
> 
> Alternative, since you're duplicating a bunch of code which will be
> replaced at runtime anyway, you could make all of these "and %0, %0, #1"
> and then copy the documentation assembly code as a comment to
> compute_instruction() and put a comment reference here.

I found that adding something that looks a bit like the generated code
helps a lot. I'll add some documentation there.

> 
>>  				    kvm_update_va_mask)
>>  		     : "+r" (v));
>>  	return v;
>> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
>> index 75bb1c6772b0..bf0d6bdf5f14 100644
>> --- a/arch/arm64/kvm/va_layout.c
>> +++ b/arch/arm64/kvm/va_layout.c
>> @@ -16,11 +16,15 @@
>>   */
>>  
>>  #include <linux/kvm_host.h>
>> +#include <linux/random.h>
>> +#include <linux/memblock.h>
>>  #include <asm/alternative.h>
>>  #include <asm/debug-monitors.h>
>>  #include <asm/insn.h>
>>  #include <asm/kvm_mmu.h>
>>  
> 
> It would be nice to have a comment on these, something like:
> 
> /* The LSB of the random hyp VA tag or 0 if no randomization is used. */
>> +static u8 tag_lsb;
> /* The random hyp VA tag value with the region bit, if hyp randomization is used */
>> +static u64 tag_val;

Sure.

> 
> 
>>  static u64 va_mask;
>>  
>>  static void compute_layout(void)
>> @@ -32,8 +36,31 @@ static void compute_layout(void)
>>  	region  = idmap_addr & BIT(VA_BITS - 1);
>>  	region ^= BIT(VA_BITS - 1);
>>  
>> -	va_mask  = BIT(VA_BITS - 1) - 1;
>> -	va_mask |= region;
>> +	tag_lsb = fls64((u64)phys_to_virt(memblock_start_of_DRAM()) ^
>> +			(u64)(high_memory - 1));
>> +
>> +	if (tag_lsb == (VA_BITS - 1)) {
>> +		/*
>> +		 * No space in the address, let's compute the mask so
>> +		 * that it covers (VA_BITS - 1) bits, and the region
>> +		 * bit. The tag is set to zero.
>> +		 */
>> +		tag_lsb = tag_val = 0;
> 
> tag_val should already be 0, right?
> 
> and wouldn't it be slightly nicer to have a temporary variable and only
> set tag_lsb when needed, called something like linear_bits ?

OK.

> 
>> +		va_mask  = BIT(VA_BITS - 1) - 1;
>> +		va_mask |= region;
>> +	} else {
>> +		/*
>> +		 * We do have some free bits. Let's have the mask to
>> +		 * cover the low bits of the VA, and the tag to
>> +		 * contain the random stuff plus the region bit.
>> +		 */
> 
> Since you have two masks below this comment is a bit hard to parse, how
> about explaining what makes up a Hyp address from a kernel linear
> address instead, something like:
> 
> 		/*
> 		 * We do have some free bits to insert a random tag.
> 		 * Hyp VAs are now created from kernel linear map VAs
> 		 * using the following formula (with V == VA_BITS):
> 		 *
> 		 *  63 ... V |   V-1  | V-2 ... tag_lsb | tag_lsb - 1 ... 0
> 		 *  -------------------------------------------------------
> 		 * | 0000000 | region |    random tag   |  kern linear VA  |
> 		 */
> 
> (assuming I got this vaguely correct).

/me copy-pastes...

> 
>> +		u64 mask = GENMASK_ULL(VA_BITS - 2, tag_lsb);
> 
> for consistency it would be nicer to use GENMASK_ULL(VA_BITS - 2, 0)
> above as suggested in the other patch then.  And we could also call this
> tag_mask to be super explicit.
> 
>> +
>> +		va_mask = BIT(tag_lsb) - 1;
> 
> and here, GENMASK_ULL(tag_lsb - 1, 0).

Yup.

> 
>> +		tag_val  = get_random_long() & mask;
>> +		tag_val |= region;
> 
> it's actually unclear to me why you need the region bit included in
> tag_val?

Because the initial masking strips it from the VA, and we need to add it
back. storing it as part of the tag makes it easy to ORR in.

> 
>> +		tag_val >>= tag_lsb;
>> +	}
>>  }
>>  
>>  static u32 compute_instruction(int n, u32 rd, u32 rn)
>> @@ -46,6 +73,33 @@ static u32 compute_instruction(int n, u32 rd, u32 rn)
>>  							  AARCH64_INSN_VARIANT_64BIT,
>>  							  rn, rd, va_mask);
>>  		break;
>> +
>> +	case 1:
>> +		/* ROR is a variant of EXTR with Rm = Rn */
>> +		insn = aarch64_insn_gen_extr(AARCH64_INSN_VARIANT_64BIT,
>> +					     rn, rn, rd,
>> +					     tag_lsb);
>> +		break;
>> +
>> +	case 2:
>> +		insn = aarch64_insn_gen_add_sub_imm(rd, rn,
>> +						    tag_val & (SZ_4K - 1),
>> +						    AARCH64_INSN_VARIANT_64BIT,
>> +						    AARCH64_INSN_ADSB_ADD);
>> +		break;
>> +
>> +	case 3:
>> +		insn = aarch64_insn_gen_add_sub_imm(rd, rn,
>> +						    tag_val & GENMASK(23, 12),
>> +						    AARCH64_INSN_VARIANT_64BIT,
>> +						    AARCH64_INSN_ADSB_ADD);
>> +		break;
>> +
>> +	case 4:
>> +		/* ROR is a variant of EXTR with Rm = Rn */
>> +		insn = aarch64_insn_gen_extr(AARCH64_INSN_VARIANT_64BIT,
>> +					     rn, rn, rd, 64 - tag_lsb);
> 
> Ah, you do use 64 - first_rand in the code.  Well, I approve of this
> line of code then.
> 
>> +		break;
>>  	}
>>  
>>  	return insn;
>> @@ -56,8 +110,8 @@ void __init kvm_update_va_mask(struct alt_instr *alt,
>>  {
>>  	int i;
>>  
>> -	/* We only expect a 1 instruction sequence */
>> -	BUG_ON(nr_inst != 1);
>> +	/* We only expect a 5 instruction sequence */
> 
> Still sounds strange to me, just drop the comment I think if we keep the
> BUG_ON.

Sure.

> 
>> +	BUG_ON(nr_inst != 5);
>>  
>>  	if (!has_vhe() && !va_mask)
>>  		compute_layout();
>> @@ -68,8 +122,12 @@ void __init kvm_update_va_mask(struct alt_instr *alt,
>>  		/*
>>  		 * VHE doesn't need any address translation, let's NOP
>>  		 * everything.
>> +		 *
>> +		 * Alternatively, if we don't have any spare bits in
>> +		 * the address, NOP everything after masking tha
> 
> s/tha/the/
> 
>> +		 * kernel VA.
>>  		 */
>> -		if (has_vhe()) {
>> +		if (has_vhe() || (!tag_lsb && i > 1)) {
>>  			updptr[i] = aarch64_insn_gen_nop();
>>  			continue;
>>  		}
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 14c5e5534f2f..d01c7111b1f7 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1811,7 +1811,7 @@ int kvm_mmu_init(void)
>>  		  kern_hyp_va((unsigned long)high_memory - 1));
>>  
>>  	if (hyp_idmap_start >= kern_hyp_va(PAGE_OFFSET) &&
>> -	    hyp_idmap_start <  kern_hyp_va(~0UL) &&
>> +	    hyp_idmap_start <  kern_hyp_va((unsigned long)high_memory - 1) &&
> 
> Is this actually required for this patch or are we just trying to be
> nice?

You really need something like that. Remember that we compute the tag
based on the available memory, so something that goes beyond that is not
a valid input to kern_hyp_va anymore.
> 
> I'm actually not sure I remember what this is about beyond the VA=idmap
> for everything on 32-bit case; I thought we chose the hyp address space
> exactly so that it wouldn't overlap with the idmap?

This is just a sanity check that kern_hyp_va returns the right thing
with respect to the idmap (i.e. we cannot hit the idmap by feeding
something to the macro). Is that clear enough (I'm not sure it is...)?

> 
>>  	    hyp_idmap_start != (unsigned long)__hyp_idmap_text_start) {
>>  		/*
>>  		 * The idmap page is intersecting with the VA space,
>> -- 
>> 2.14.2
>>
> 
> Thanks,
> -Christoffer
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
