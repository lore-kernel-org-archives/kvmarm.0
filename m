From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 07/19] arm64: insn: Add encoder for bitwise operations
 using litterals
Date: Tue, 12 Dec 2017 18:32:58 +0000
Message-ID: <5A3020DA.8010309@arm.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com>
 <20171211144937.4537-8-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8342549D27
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 13:31:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tjJWrb5fRpaG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Dec 2017 13:31:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A57C40D25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 13:31:33 -0500 (EST)
In-Reply-To: <20171211144937.4537-8-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 11/12/17 14:49, Marc Zyngier wrote:
> We lack a way to encode operations such as AND, ORR, EOR that take
> an immediate value. Doing so is quite involved, and is all about
> reverse engineering the decoding algorithm described in the
> pseudocode function DecodeBitMasks().


As this is over my head, I've been pushing random encodings through gas/objdump
and then tracing them through here.... can this encode 0xf80000000fffffff?

gas thinks this is legal:
|   0:   92458000        and     x0, x0, #0xf80000000fffffff

I make that N=1, S=0x20, R=0x05.
(I'm still working out what 'S' means)


> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index 7e432662d454..326b17016485 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c

> +static u32 aarch64_encode_immediate(u64 imm,
> +				    enum aarch64_insn_variant variant,
> +				    u32 insn)
> +{
> +	unsigned int immr, imms, n, ones, ror, esz, tmp;
> +	u64 mask;

[...]

> +	/* N is only set if we're encoding a 64bit value */
> +	n = esz == 64;
> +
> +	/* Trim imm to the element size */
> +	mask = BIT(esz - 1) - 1;
> +	imm &= mask;

Won't this lose the top bit of a 64bit immediate?

(but then you put it back later, so something funny is going on)

This becomes 0x780000000fffffff,


> +
> +	/* That's how many ones we need to encode */
> +	ones = hweight64(imm);

meaning we're short a one here,


> +
> +	/*
> +	 * imms is set to (ones - 1), prefixed with a string of ones
> +	 * and a zero if they fit. Cap it to 6 bits.
> +	 */
> +	imms  = ones - 1;
> +	imms |= 0xf << ffs(esz);
> +	imms &= BIT(6) - 1;

so imms is 0x1f, not 0x20.


> +	/* Compute the rotation */
> +	if (range_of_ones(imm)) {
> +		/*
> +		 * Pattern: 0..01..10..0
> +		 *
> +		 * Compute how many rotate we need to align it right
> +		 */
> +		ror = ffs(imm) - 1;

(how come range_of_ones() uses __ffs64() on the same value?)


> +	} else {
> +		/*
> +		 * Pattern: 0..01..10..01..1
> +		 *
> +		 * Fill the unused top bits with ones, and check if
> +		 * the result is a valid immediate (all ones with a
> +		 * contiguous ranges of zeroes).
> +		 */

> +		imm |= ~mask;

but here we put the missing one back,


> +		if (!range_of_ones(~imm))
> +			return AARCH64_BREAK_FAULT;

meaning we pass this check and carry on, (even though 0x780000000fffffff isn't a
legal value)


(this next bit I haven't worked out yet)
> +		/*
> +		 * Compute the rotation to get a continuous set of
> +		 * ones, with the first bit set at position 0
> +		 */
> +		ror = fls(~imm);
> +	}
> +
> +	/*
> +	 * immr is the number of bits we need to rotate back to the
> +	 * original set of ones. Note that this is relative to the
> +	 * element size...
> +	 */
> +	immr = (esz - ror) & (esz - 1);


If I've followed this through correctly, this results in:
|   0:   92457c00        and     x0, x0, #0xf800000007ffffff

... which wasn't the immediate I started with.


Unless I've gone wrong, I think the 'Trim imm to the element size' code needs to
move up into the esz-reducing loop so it doesn't happen for a 64bit immediate.



Thanks,

James
