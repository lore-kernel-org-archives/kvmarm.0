From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 07/19] arm64: insn: Add encoder for bitwise operations
 using litterals
Date: Wed, 13 Dec 2017 15:45:03 +0000
Message-ID: <5A314AFF.60300@arm.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com> <20171211144937.4537-8-marc.zyngier@arm.com> <5A3020DA.8010309@arm.com> <07971a66-1b36-d2cd-e590-2b7b65d14b97@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <07971a66-1b36-d2cd-e590-2b7b65d14b97@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steve Capper <steve.capper@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 13/12/17 14:32, Marc Zyngier wrote:
> On 12/12/17 18:32, James Morse wrote:
>> On 11/12/17 14:49, Marc Zyngier wrote:
>>> We lack a way to encode operations such as AND, ORR, EOR that take
>>> an immediate value. Doing so is quite involved, and is all about
>>> reverse engineering the decoding algorithm described in the
>>> pseudocode function DecodeBitMasks().

>>> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
>>> index 7e432662d454..326b17016485 100644
>>> --- a/arch/arm64/kernel/insn.c
>>> +++ b/arch/arm64/kernel/insn.c
>>
>>> +static u32 aarch64_encode_immediate(u64 imm,
>>> +				    enum aarch64_insn_variant variant,
>>> +				    u32 insn)
>>> +{
>>> +	unsigned int immr, imms, n, ones, ror, esz, tmp;
>>> +	u64 mask;
>>
>> [...]
>>
>>> +	/* Compute the rotation */
>>> +	if (range_of_ones(imm)) {
>>> +		/*
>>> +		 * Pattern: 0..01..10..0
>>> +		 *
>>> +		 * Compute how many rotate we need to align it right
>>> +		 */
>>> +		ror = ffs(imm) - 1;
>>
>> (how come range_of_ones() uses __ffs64() on the same value?)
> 
> News flash: range_of_ones is completely buggy. It will fail on the 
> trivial value 1 (__ffs64(1) = 0; 0 - 1 = -1; val >> -1 is... ermmmm).
> I definitely got mixed up between the two.

They do different things!? Aaaaaahhhh....

[ ...]

>> Unless I've gone wrong, I think the 'Trim imm to the element size' code needs to
>> move up into the esz-reducing loop so it doesn't happen for a 64bit immediate.


> Yup. I've stashed the following patch:
> 
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index b8fb2d89b3a6..e58be1c57f18 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c
> @@ -1503,8 +1503,7 @@ pstate_check_t * const aarch32_opcode_cond_checks[16] = {
>  static bool range_of_ones(u64 val)
>  {
>  	/* Doesn't handle full ones or full zeroes */
> -	int x = __ffs64(val) - 1;
> -	u64 sval = val >> x;
> +	u64 sval = val >> __ffs64(val);
>  
>  	/* One of Sean Eron Anderson's bithack tricks */
>  	return ((sval + 1) & (sval)) == 0;
> @@ -1515,7 +1514,7 @@ static u32 aarch64_encode_immediate(u64 imm,
>  				    u32 insn)
>  {
>  	unsigned int immr, imms, n, ones, ror, esz, tmp;
> -	u64 mask;
> +	u64 mask = ~0UL;
>  
>  	/* Can't encode full zeroes or full ones */
>  	if (!imm || !~imm)
> @@ -1543,8 +1542,12 @@ static u32 aarch64_encode_immediate(u64 imm,
>  	for (tmp = esz; tmp > 2; tmp /= 2) {
>  		u64 emask = BIT(tmp / 2) - 1;
>  
> -		if ((imm & emask) != ((imm >> (tmp / 2)) & emask))
> +		if ((imm & emask) != ((imm >> (tmp / 2)) & emask)) {
> +			/* Trim imm to the element size */
> +			mask = BIT(esz - 1) - 1;
> +			imm &= mask;

Won't this still lose the top bit? It generates 0x7fffffff for esz=32, and for
esz=32 we run through here when the two 16bit values are different.

This still runs for a 64bit immediate. The 0xf80000000fffffff example compares
0xf8000000 with 0fffffff then breaks here on the first iteration of this loop.
With this change it still attempts to generate a 64bit mask.

I was thinking of something like [0]. That only runs when we know the two
tmp:halves match, it just keeps the bottom tmp:half for the next run and never
runs for a 64bit immediate.


>  			break;
> +		}
>  
>  		esz = tmp;
>  	}
> @@ -1552,10 +1555,6 @@ static u32 aarch64_encode_immediate(u64 imm,
>  	/* N is only set if we're encoding a 64bit value */
>  	n = esz == 64;
>  
> -	/* Trim imm to the element size */
> -	mask = BIT(esz - 1) - 1;
> -	imm &= mask;
> -
>  	/* That's how many ones we need to encode */
>  	ones = hweight64(imm);
>  
> I really need to run this against gas in order to make sure
> I get the same parameters for all the possible values.

Sounds good,


Thanks,

James


[0] Not even built:
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 12d3ec2154c2..d9fbdea7b18d 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -1529,15 +1529,15 @@ static u32 aarch64_encode_immediate(u64 imm,
                        break;

                esz = tmp;
+
+               /* Trim imm to the element size */
+               mask = BIT(esz) - 1;
+               imm &= mask;
        }

        /* N is only set if we're encoding a 64bit value */
        n = esz == 64;

-       /* Trim imm to the element size */
-       mask = BIT(esz - 1) - 1;
-       imm &= mask;
-
        /* That's how many ones we need to encode */
        ones = hweight64(imm);
