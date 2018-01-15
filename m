From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 05/19] arm64: alternatives: Add dynamic patching feature
Date: Mon, 15 Jan 2018 12:26:06 +0100
Message-ID: <20180115112606.GF21403@cbox>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78A0349DC4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 06:21:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y2ckZi7jnPAl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jan 2018 06:21:11 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2898749DC3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 06:21:11 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id v71so1219825wmv.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 03:26:09 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20180104184334.16571-6-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 04, 2018 at 06:43:20PM +0000, Marc Zyngier wrote:
> We've so far relied on a patching infrastructure that only gave us
> a single alternative, without any way to finely control what gets
> patched. 

Not sure I understand this point.  Do you mean without any way to
provide a range of potential replacement instructions?

> For a single feature, this is an all or nothing thing.
> 
> It would be interesting to have a more fine grained way of patching
> the kernel though, where we could dynamically tune the code that gets
> injected.

Again, I'm not really sure how this is more fine grained than what we
had before, but it's certainly more flexible, in that we can now apply
arbitrary run-time logic in the form of a C-function to decide which
instructions should be used in a given location.

> 
> In order to achive this, let's introduce a new form of alternative
> that is associated with a callback.

And we call this new form of alternative "dynamic patching" ?  I think
it's good to introduce a bit of consistent nomenclature here.

> This callback gets the instruction
> sequence number and the old instruction as a parameter, and returns
> the new instruction. This callback is always called, as the patching
> decision is now done at runtime (not patching is equivalent to returning
> the same instruction).

Sorry to be a bit nit-picky here, but didn't we also patch instructions
at runtime before this feature, it's just that we apply logic to
figure out the replacement instruction now, which can now even compose
an instruction at runtime?

> 
> Patching with a callback is declared with the new ALTERNATIVE_CB

So here we could say "callback patching" or "dynamic patching", and...

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
>  arch/arm64/include/asm/alternative.h       | 36 ++++++++++++++++++++++---
>  arch/arm64/include/asm/alternative_types.h |  4 +++
>  arch/arm64/kernel/alternative.c            | 43 ++++++++++++++++++++++--------
>  3 files changed, 68 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
> index 395befde7595..04f66f6173fc 100644
> --- a/arch/arm64/include/asm/alternative.h
> +++ b/arch/arm64/include/asm/alternative.h
> @@ -18,10 +18,14 @@
>  void __init apply_alternatives_all(void);
>  void apply_alternatives(void *start, size_t length);
>  
> -#define ALTINSTR_ENTRY(feature)						      \
> +#define ALTINSTR_ENTRY(feature,cb)					      \
>  	" .align " __stringify(ALTINSTR_ALIGN) "\n"			      \
>  	" .word 661b - .\n"				/* label           */ \
> +	" .if " __stringify(cb) " == 0\n"				      \
>  	" .word 663f - .\n"				/* new instruction */ \
> +	" .else\n"							      \
> +	" .word " __stringify(cb) "- .\n"		/* callback */	      \
> +	" .endif\n"							      \
>  	" .hword " __stringify(feature) "\n"		/* feature bit     */ \
>  	" .byte 662b-661b\n"				/* source len      */ \
>  	" .byte 664f-663f\n"				/* replacement len */
> @@ -39,15 +43,18 @@ void apply_alternatives(void *start, size_t length);
>   * but most assemblers die if insn1 or insn2 have a .inst. This should
>   * be fixed in a binutils release posterior to 2.25.51.0.2 (anything
>   * containing commit 4e4d08cf7399b606 or c1baaddf8861).
> + *
> + * Alternatives with callbacks do not generate replacement instructions.
>   */
> -#define __ALTERNATIVE_CFG(oldinstr, newinstr, feature, cfg_enabled)	\
> +#define __ALTERNATIVE_CFG(oldinstr, newinstr, feature, cfg_enabled, cb)	\
>  	".if "__stringify(cfg_enabled)" == 1\n"				\
>  	"661:\n\t"							\
>  	oldinstr "\n"							\
>  	"662:\n"							\
>  	".pushsection .altinstructions,\"a\"\n"				\
> -	ALTINSTR_ENTRY(feature)						\
> +	ALTINSTR_ENTRY(feature,cb)					\
>  	".popsection\n"							\
> +	" .if " __stringify(cb) " == 0\n"				\
>  	".pushsection .altinstr_replacement, \"a\"\n"			\
>  	"663:\n\t"							\
>  	newinstr "\n"							\
> @@ -55,11 +62,17 @@ void apply_alternatives(void *start, size_t length);
>  	".popsection\n\t"						\
>  	".org	. - (664b-663b) + (662b-661b)\n\t"			\
>  	".org	. - (662b-661b) + (664b-663b)\n"			\
> +	".else\n\t"							\
> +	"663:\n\t"							\
> +	"664:\n\t"							\
> +	".endif\n"							\
>  	".endif\n"
>  
>  #define _ALTERNATIVE_CFG(oldinstr, newinstr, feature, cfg, ...)	\
> -	__ALTERNATIVE_CFG(oldinstr, newinstr, feature, IS_ENABLED(cfg))
> +	__ALTERNATIVE_CFG(oldinstr, newinstr, feature, IS_ENABLED(cfg), 0)
>  
> +#define ALTERNATIVE_CB(oldinstr, cb) \
> +	__ALTERNATIVE_CFG(oldinstr, "NOT_AN_INSTRUCTION", ARM64_NCAPS, 1, cb)
>  #else
>  
>  #include <asm/assembler.h>
> @@ -127,6 +140,14 @@ void apply_alternatives(void *start, size_t length);
>  661:
>  .endm
>  
> +.macro alternative_cb cb
> +	.set .Lasm_alt_mode, 0
> +	.pushsection .altinstructions, "a"
> +	altinstruction_entry 661f, \cb, ARM64_NCAPS, 662f-661f, 0
> +	.popsection
> +661:
> +.endm
> +
>  /*
>   * Provide the other half of the alternative code sequence.
>   */
> @@ -152,6 +173,13 @@ void apply_alternatives(void *start, size_t length);
>  	.org	. - (662b-661b) + (664b-663b)
>  .endm
>  
> +/*
> + * Callback-based alternative epilogue
> + */
> +.macro alternative_cb_end
> +662:
> +.endm
> +
>  /*
>   * Provides a trivial alternative or default sequence consisting solely
>   * of NOPs. The number of NOPs is chosen automatically to match the
> diff --git a/arch/arm64/include/asm/alternative_types.h b/arch/arm64/include/asm/alternative_types.h
> index 26cf76167f2d..e400b9061957 100644
> --- a/arch/arm64/include/asm/alternative_types.h
> +++ b/arch/arm64/include/asm/alternative_types.h
> @@ -2,6 +2,10 @@
>  #ifndef __ASM_ALTERNATIVE_TYPES_H
>  #define __ASM_ALTERNATIVE_TYPES_H
>  
> +struct alt_instr;
> +typedef void (*alternative_cb_t)(struct alt_instr *alt,
> +				 __le32 *origptr, __le32 *updptr, int nr_inst);
> +
>  struct alt_instr {
>  	s32 orig_offset;	/* offset to original instruction */
>  	s32 alt_offset;		/* offset to replacement instruction */
> diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
> index 6dd0a3a3e5c9..0f52627fbb29 100644
> --- a/arch/arm64/kernel/alternative.c
> +++ b/arch/arm64/kernel/alternative.c
> @@ -105,32 +105,53 @@ static u32 get_alt_insn(struct alt_instr *alt, __le32 *insnptr, __le32 *altinsnp
>  	return insn;
>  }
>  
> +static void patch_alternative(struct alt_instr *alt,
> +			      __le32 *origptr, __le32 *updptr, int nr_inst)
> +{
> +	__le32 *replptr;
> +	int i;
> +
> +	replptr = ALT_REPL_PTR(alt);
> +	for (i = 0; i < nr_inst; i++) {
> +		u32 insn;
> +
> +		insn = get_alt_insn(alt, origptr + i, replptr + i);
> +		updptr[i] = cpu_to_le32(insn);
> +	}
> +}
> +
>  static void __apply_alternatives(void *alt_region, bool use_linear_alias)
>  {
>  	struct alt_instr *alt;
>  	struct alt_region *region = alt_region;
> -	__le32 *origptr, *replptr, *updptr;
> +	__le32 *origptr, *updptr;
> +	alternative_cb_t alt_cb;
>  
>  	for (alt = region->begin; alt < region->end; alt++) {
> -		u32 insn;
> -		int i, nr_inst;
> +		int nr_inst;
>  
> -		if (!cpus_have_cap(alt->cpufeature))
> +		/* Use ARM64_NCAPS as an unconditional patch */

... here I think we can re-use this term, if I correctly understand that
ARM64_NCAPS means it's a "callback patch" (or "dynamic patch").

You could consider #define ARM64_CB_PATCH ARM64_NCAPS as well I suppose.

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
> -		replptr = ALT_REPL_PTR(alt);
>  		updptr = use_linear_alias ? lm_alias(origptr) : origptr;
> -		nr_inst = alt->alt_len / sizeof(insn);
> +		nr_inst = alt->orig_len / AARCH64_INSN_SIZE;
>  
> -		for (i = 0; i < nr_inst; i++) {
> -			insn = get_alt_insn(alt, origptr + i, replptr + i);
> -			updptr[i] = cpu_to_le32(insn);
> -		}
> +		if (alt->cpufeature < ARM64_NCAPS)
> +			alt_cb = patch_alternative;
> +		else
> +			alt_cb  = ALT_REPL_PTR(alt);
> +
> +		alt_cb(alt, origptr, updptr, nr_inst);
>  
>  		flush_icache_range((uintptr_t)origptr,
>  				   (uintptr_t)(origptr + nr_inst));
> -- 
> 2.14.2
> 

So despite my language nit-picks above, I haven't been able to spot
anything problematic with this patch:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
