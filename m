From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 07/19] arm64: insn: Add encoder for bitwise operations
 using litterals
Date: Wed, 13 Dec 2017 14:32:05 +0000
Message-ID: <07971a66-1b36-d2cd-e590-2b7b65d14b97@arm.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com>
 <20171211144937.4537-8-marc.zyngier@arm.com> <5A3020DA.8010309@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5A3020DA.8010309@arm.com>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steve Capper <steve.capper@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 12/12/17 18:32, James Morse wrote:
> Hi Marc,
> 
> On 11/12/17 14:49, Marc Zyngier wrote:
>> We lack a way to encode operations such as AND, ORR, EOR that take
>> an immediate value. Doing so is quite involved, and is all about
>> reverse engineering the decoding algorithm described in the
>> pseudocode function DecodeBitMasks().
> 
> 
> As this is over my head, I've been pushing random encodings through gas/objdump
> and then tracing them through here.... can this encode 0xf80000000fffffff?
> 
> gas thinks this is legal:
> |   0:   92458000        and     x0, x0, #0xf80000000fffffff
> 
> I make that N=1, S=0x20, R=0x05.
> (I'm still working out what 'S' means)
> 
> 
>> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
>> index 7e432662d454..326b17016485 100644
>> --- a/arch/arm64/kernel/insn.c
>> +++ b/arch/arm64/kernel/insn.c
> 
>> +static u32 aarch64_encode_immediate(u64 imm,
>> +				    enum aarch64_insn_variant variant,
>> +				    u32 insn)
>> +{
>> +	unsigned int immr, imms, n, ones, ror, esz, tmp;
>> +	u64 mask;
> 
> [...]
> 
>> +	/* N is only set if we're encoding a 64bit value */
>> +	n = esz == 64;
>> +
>> +	/* Trim imm to the element size */
>> +	mask = BIT(esz - 1) - 1;
>> +	imm &= mask;
> 
> Won't this lose the top bit of a 64bit immediate?

Humfff... Yup, nicely spotted.

> 
> (but then you put it back later, so something funny is going on)
> 
> This becomes 0x780000000fffffff,
> 
> 
>> +
>> +	/* That's how many ones we need to encode */
>> +	ones = hweight64(imm);
> 
> meaning we're short a one here,
> 
> 
>> +
>> +	/*
>> +	 * imms is set to (ones - 1), prefixed with a string of ones
>> +	 * and a zero if they fit. Cap it to 6 bits.
>> +	 */
>> +	imms  = ones - 1;
>> +	imms |= 0xf << ffs(esz);
>> +	imms &= BIT(6) - 1;
> 
> so imms is 0x1f, not 0x20.
> 
> 
>> +	/* Compute the rotation */
>> +	if (range_of_ones(imm)) {
>> +		/*
>> +		 * Pattern: 0..01..10..0
>> +		 *
>> +		 * Compute how many rotate we need to align it right
>> +		 */
>> +		ror = ffs(imm) - 1;
> 
> (how come range_of_ones() uses __ffs64() on the same value?)

News flash: range_of_ones is completely buggy. It will fail on the 
trivial value 1 (__ffs64(1) = 0; 0 - 1 = -1; val >> -1 is... ermmmm).
I definitely got mixed up between the two.

>> +	} else {
>> +		/*
>> +		 * Pattern: 0..01..10..01..1
>> +		 *
>> +		 * Fill the unused top bits with ones, and check if
>> +		 * the result is a valid immediate (all ones with a
>> +		 * contiguous ranges of zeroes).
>> +		 */
> 
>> +		imm |= ~mask;
> 
> but here we put the missing one back,
> 
> 
>> +		if (!range_of_ones(~imm))
>> +			return AARCH64_BREAK_FAULT;
> 
> meaning we pass this check and carry on, (even though 0x780000000fffffff isn't a
> legal value)
> 
> 
> (this next bit I haven't worked out yet)
>> +		/*
>> +		 * Compute the rotation to get a continuous set of
>> +		 * ones, with the first bit set at position 0
>> +		 */
>> +		ror = fls(~imm);
>> +	}
>> +
>> +	/*
>> +	 * immr is the number of bits we need to rotate back to the
>> +	 * original set of ones. Note that this is relative to the
>> +	 * element size...
>> +	 */
>> +	immr = (esz - ror) & (esz - 1);
> 
> 
> If I've followed this through correctly, this results in:
> |   0:   92457c00        and     x0, x0, #0xf800000007ffffff
> 
> ... which wasn't the immediate I started with.
> 
> 
> Unless I've gone wrong, I think the 'Trim imm to the element size' code needs to
> move up into the esz-reducing loop so it doesn't happen for a 64bit immediate.

Yup. I've stashed the following patch:

diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index b8fb2d89b3a6..e58be1c57f18 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -1503,8 +1503,7 @@ pstate_check_t * const aarch32_opcode_cond_checks[16] = {
 static bool range_of_ones(u64 val)
 {
 	/* Doesn't handle full ones or full zeroes */
-	int x = __ffs64(val) - 1;
-	u64 sval = val >> x;
+	u64 sval = val >> __ffs64(val);
 
 	/* One of Sean Eron Anderson's bithack tricks */
 	return ((sval + 1) & (sval)) == 0;
@@ -1515,7 +1514,7 @@ static u32 aarch64_encode_immediate(u64 imm,
 				    u32 insn)
 {
 	unsigned int immr, imms, n, ones, ror, esz, tmp;
-	u64 mask;
+	u64 mask = ~0UL;
 
 	/* Can't encode full zeroes or full ones */
 	if (!imm || !~imm)
@@ -1543,8 +1542,12 @@ static u32 aarch64_encode_immediate(u64 imm,
 	for (tmp = esz; tmp > 2; tmp /= 2) {
 		u64 emask = BIT(tmp / 2) - 1;
 
-		if ((imm & emask) != ((imm >> (tmp / 2)) & emask))
+		if ((imm & emask) != ((imm >> (tmp / 2)) & emask)) {
+			/* Trim imm to the element size */
+			mask = BIT(esz - 1) - 1;
+			imm &= mask;
 			break;
+		}
 
 		esz = tmp;
 	}
@@ -1552,10 +1555,6 @@ static u32 aarch64_encode_immediate(u64 imm,
 	/* N is only set if we're encoding a 64bit value */
 	n = esz == 64;
 
-	/* Trim imm to the element size */
-	mask = BIT(esz - 1) - 1;
-	imm &= mask;
-
 	/* That's how many ones we need to encode */
 	ones = hweight64(imm);
 
I really need to run this against gas in order to make sure
I get the same parameters for all the possible values.

Many thanks for this careful review!

	M.
-- 
Jazz is not dead. It just smells funny...
