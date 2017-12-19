From: Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH v3 05/19] arm64: alternatives: Add dynamic patching
 feature
Date: Tue, 19 Dec 2017 13:04:37 +0000
Message-ID: <20171219130437.nna4hwxhbbnawbq2@capper-debian.cambridge.arm.com>
References: <20171218173926.16911-1-marc.zyngier@arm.com>
 <20171218173926.16911-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171218173926.16911-6-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Peter Maydell <peter.maydell@linaro.org>nd@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Mon, Dec 18, 2017 at 05:39:12PM +0000, Marc Zyngier wrote:
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
> 	alternative_cb_end
> 
> where callback is the C function computing the alternative.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/alternative.h       | 36 ++++++++++++++++++++++++++----
>  arch/arm64/include/asm/alternative_types.h |  3 +++
>  arch/arm64/kernel/alternative.c            | 21 +++++++++++++----
>  3 files changed, 52 insertions(+), 8 deletions(-)
> 

[...]

> diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
> index 6dd0a3a3e5c9..cd299af96c95 100644
> --- a/arch/arm64/kernel/alternative.c
> +++ b/arch/arm64/kernel/alternative.c
> @@ -110,25 +110,38 @@ static void __apply_alternatives(void *alt_region, bool use_linear_alias)
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
> +		if (alt->cpufeature < ARM64_NCAPS &&
> +		    !cpus_have_cap(alt->cpufeature))
>  			continue;
>  
> -		BUG_ON(alt->alt_len != alt->orig_len);
> +		if (alt->cpufeature == ARM64_NCAPS)
> +			BUG_ON(alt->alt_len != 0);
> +		else
> +			BUG_ON(alt->alt_len != alt->orig_len);
>  
>  		pr_info_once("patching kernel code\n");
>  
>  		origptr = ALT_ORIG_PTR(alt);
>  		replptr = ALT_REPL_PTR(alt);
> +		alt_cb  = ALT_REPL_PTR(alt);
>  		updptr = use_linear_alias ? lm_alias(origptr) : origptr;
> -		nr_inst = alt->alt_len / sizeof(insn);
> +		nr_inst = alt->orig_len / sizeof(insn);
>  
>  		for (i = 0; i < nr_inst; i++) {
> -			insn = get_alt_insn(alt, origptr + i, replptr + i);
> +			if (alt->cpufeature == ARM64_NCAPS) {
> +				insn = le32_to_cpu(updptr[i]);
> +				insn = alt_cb(alt, i, insn);
> +			} else {
> +				insn = get_alt_insn(alt, origptr + i,
> +						    replptr + i);
> +			}
>  			updptr[i] = cpu_to_le32(insn);
>  		}

Is it possible to call the callback only once per entry (rather than
once per instruction)? That would allow one to retain some more
execution state in the callback, which may be handy if things get more
elaborate.

Cheers,
-- 
Steve
