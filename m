From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 05/19] arm64: alternatives: Add dynamic patching
 feature
Date: Wed, 13 Dec 2017 17:53:31 +0000
Message-ID: <20171213175330.qlqay7ev7s6zra2n@armageddon.cambridge.arm.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com>
 <20171211144937.4537-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171211144937.4537-6-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Mark Rutland <mark.rutland@arm.com>, Steve Capper <steve.capper@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 11, 2017 at 02:49:23PM +0000, Marc Zyngier wrote:
> We've so far relied on a patching infrastructure that only gave us
> a single alternative, without any way to finely control what gets
> patched. For a single feature, this is an all or nothing thing.
> 
> It would be interesting to have a more fine grained way of patching
> the kernel though, where we could dynamically tune the code that gets
> injected.
> 
> In order to achive this, let's introduce a new form of alternative
> that is associated with a callback. This callback gets the instruction
> sequence number and the old instruction as a parameter, and returns
> the new instruction. This callback is always called, as the patching
> decision is now done at runtime (not patching is equivalent to returning
> the same instruction).
> 
> Patching with a callback is declared with the new ALTERNATIVE_CB
> and alternative_cb directives:
> 
> 	asm volatile(ALTERNATIVE_CB("mov %0, #0\n", callback)
> 		     : "r" (v));
> or
> 	alternative_cb callback
> 		mov	x0, #0
> 	alternative_else_nop_endif

Could we have a new "alternative_cb_endif" instead of
alternative_else_no_endif? IIUC, the nops generated in the
.altinstr_replacement section wouldn't be used, so I think it makes the
code clearer that there is no other alternative instruction set, just an
update in-place of the given instruction.

> diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
> index 395befde7595..ce612e10a2c9 100644
> --- a/arch/arm64/include/asm/alternative.h
> +++ b/arch/arm64/include/asm/alternative.h
[...]
> -.macro altinstruction_entry orig_offset alt_offset feature orig_len alt_len
> +.macro altinstruction_entry orig_offset, alt_offset, feature, orig_len, alt_len, cb = 0
>  	.align ALTINSTR_ALIGN
>  	.word \orig_offset - .
> +	.if \cb == 0
>  	.word \alt_offset - .
> +	.else
> +	.word \cb - .
> +	.endif
>  	.hword \feature
>  	.byte \orig_len
>  	.byte \alt_len
>  .endm
>  
> -.macro alternative_insn insn1, insn2, cap, enable = 1
> +.macro alternative_insn insn1, insn2, cap, enable = 1, cb = 0
>  	.if \enable
>  661:	\insn1
>  662:	.pushsection .altinstructions, "a"
> -	altinstruction_entry 661b, 663f, \cap, 662b-661b, 664f-663f
> +	altinstruction_entry 661b, 663f, \cap, 662b-661b, 664f-663f, \cb
>  	.popsection
>  	.pushsection .altinstr_replacement, "ax"
>  663:	\insn2

So here we could skip .pushsection .altinstr_replacement if cb. We could
even pass \cb directly to altinstruction_entry instead of 663f so that
we keep altinstruction_entry unmodified.

> @@ -109,10 +119,10 @@ void apply_alternatives(void *start, size_t length);
>  /*
>   * Begin an alternative code sequence.
>   */
> -.macro alternative_if_not cap
> +.macro alternative_if_not cap, cb = 0
>  	.set .Lasm_alt_mode, 0
>  	.pushsection .altinstructions, "a"
> -	altinstruction_entry 661f, 663f, \cap, 662f-661f, 664f-663f
> +	altinstruction_entry 661f, 663f, \cap, 662f-661f, 664f-663f, \cb
>  	.popsection
>  661:
>  .endm
> @@ -120,13 +130,17 @@ void apply_alternatives(void *start, size_t length);
>  .macro alternative_if cap
>  	.set .Lasm_alt_mode, 1
>  	.pushsection .altinstructions, "a"
> -	altinstruction_entry 663f, 661f, \cap, 664f-663f, 662f-661f
> +	altinstruction_entry 663f, 661f, \cap, 664f-663f, 662f-661f, 0
>  	.popsection
>  	.pushsection .altinstr_replacement, "ax"
>  	.align 2	/* So GAS knows label 661 is suitably aligned */
>  661:
>  .endm

and here we wouldn't need this hunk for alternative_if.

> --- a/arch/arm64/kernel/alternative.c
> +++ b/arch/arm64/kernel/alternative.c
> @@ -110,12 +110,15 @@ static void __apply_alternatives(void *alt_region, bool use_linear_alias)
>  	struct alt_instr *alt;
>  	struct alt_region *region = alt_region;
>  	__le32 *origptr, *replptr, *updptr;
> +	alternative_cb_t alt_cb;
>  
>  	for (alt = region->begin; alt < region->end; alt++) {
>  		u32 insn;
>  		int i, nr_inst;
>  
> -		if (!cpus_have_cap(alt->cpufeature))
> +		/* Use ARM64_NCAPS as an unconditional patch */
> +		if (alt->cpufeature != ARM64_NCAPS &&

Nitpick (personal preference): alt->cpufeature < ARM64_NCAPS.

> +		    !cpus_have_cap(alt->cpufeature))
>  			continue;
>  
>  		BUG_ON(alt->alt_len != alt->orig_len);
> @@ -124,11 +127,18 @@ static void __apply_alternatives(void *alt_region, bool use_linear_alias)
>  
>  		origptr = ALT_ORIG_PTR(alt);
>  		replptr = ALT_REPL_PTR(alt);
> +		alt_cb  = ALT_REPL_PTR(alt);
>  		updptr = use_linear_alias ? lm_alias(origptr) : origptr;
>  		nr_inst = alt->alt_len / sizeof(insn);
>  
>  		for (i = 0; i < nr_inst; i++) {
> -			insn = get_alt_insn(alt, origptr + i, replptr + i);
> +			if (alt->cpufeature == ARM64_NCAPS) {
> +				insn = le32_to_cpu(updptr[i]);
> +				insn = alt_cb(alt, i, insn);

I wonder whether we'd need the origptr + i as well at some point (e.g.
to generate some relative relocations).

-- 
Catalin
