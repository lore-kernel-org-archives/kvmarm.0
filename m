From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 01/15] ARM: assembler: introduce adr_l, ldr_l and str_l
 macros
Date: Tue, 8 Aug 2017 11:10:50 -0400 (EDT)
Message-ID: <alpine.LFD.2.20.1708081030030.8927@knanqh.ubzr>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org> <20170805205222.19868-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170805205222.19868-2-ard.biesheuvel@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org, Russell King - ARM Linux <linux@armlinux.org.uk>, linux-omap@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, krzk@kernel.org, jason@lakedaemon.net, arm@kernel.org, andrew@lunn.ch, gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com, tony@atomide.com, baohua@kernel.org, horms@verge.net.au, magnus.damm@gmail.com, vireshk@kernel.org, shiraz.linux.kernel@gmail.com, patrice.chotard@st.com, Dave Martin <dave.martin@arm.com>, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, 5 Aug 2017, Ard Biesheuvel wrote:

> Like arm64, ARM supports position independent code sequences that
> produce symbol references with a greater reach than the ordinary
> adr/ldr instructions.
> 
> Currently, we use open coded instruction sequences involving literals
> and arithmetic operations. Instead, we can use movw/movt pairs on v7
> CPUs, circumventing the D-cache entirely. For older CPUs, we can emit
> the literal into a subsection, allowing it to be emitted out of line
> while retaining the ability to perform arithmetic on label offsets.
> 
> E.g., on pre-v7 CPUs, we can emit a PC-relative reference as follows:
> 
>        ldr          <reg>, 222f
>   111: add          <reg>, <reg>, pc
>        .subsection  1
>   222: .long        <sym> - (111b + 8)
>        .previous
> 
> This is allowed by the assembler because, unlike ordinary sections,
> subsections are combined into a single section into the object file,
> and so the label references are not true cross-section references that
> are visible as relocations. Note that we could even do something like
> 
>        add          <reg>, pc, #(222f - 111f) & ~0xfff
>        ldr          <reg>, [<reg>, #(222f - 111f) & 0xfff]
>   111: add          <reg>, <reg>, pc
>        .subsection  1
>   222: .long        <sym> - (111b + 8)
>        .previous
> 
> if it turns out that the 4 KB range of the ldr instruction is insufficient
> to reach the literal in the subsection, although this is currently not a
> problem (of the 98 objects built from .S files in a multi_v7_defconfig
> build, only 11 have .text sections that are over 1 KB, and the largest one
> [entry-armv.o] is 3308 bytes)
> 
> Subsections have been available in binutils since 2004 at least, so
> they should not cause any issues with older toolchains.
> 
> So use the above to implement the macros mov_l, adr_l, adrm_l (using ldm
> to load multiple literals at once), ldr_l and str_l, all of which will
> use movw/movt pairs on v7 and later CPUs, and use PC-relative literals
> otherwise.

There is no adrm_l definition in this patch.

Also, might it be better to change mov_l to movl? Tthis looks similar to 
the ARM64 movl pseudo-instruction, and unlike all the other _l variants, 
this is not producing a pc relative result.

Talking about the _l suffix: I wonder if this could be more meaningful, 
like _rel maybe? At least in the adr_l case, this could easily be 
confused with adrl.

Otherwise I like it pretty much.


> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/include/asm/assembler.h | 70 ++++++++++++++++++++
>  1 file changed, 70 insertions(+)
> 
> diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
> index ad301f107dd2..cedf59a7f853 100644
> --- a/arch/arm/include/asm/assembler.h
> +++ b/arch/arm/include/asm/assembler.h
> @@ -518,4 +518,74 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
>  #endif
>  	.endm
>  
> +#ifdef CONFIG_THUMB2_KERNEL
> +#define	ARM_PC_BIAS		4
> +#else
> +#define	ARM_PC_BIAS		8
> +#endif
> +
> +	.macro		__adldst_l, op, reg, sym, tmp
> +	.if		__LINUX_ARM_ARCH__ < 7
> +	ldr		\tmp, 111f
> +	.subsection	1
> +	.align		2
> +111:	.long		\sym - (222f + ARM_PC_BIAS)
> +	.previous
> +	.else
> +	movw		\tmp, #:lower16:\sym - (222f + ARM_PC_BIAS)
> +	movt		\tmp, #:upper16:\sym - (222f + ARM_PC_BIAS)
> +	.endif
> +222:;	.ifc		\op, add
> +	add		\reg, \tmp, pc
> +	.elseif		CONFIG_THUMB2_KERNEL == 1
> +	add		\tmp, \tmp, pc
> +	\op		\reg, [\tmp]
> +	.else
> +	\op		\reg, [pc, \tmp]
> +	.endif
> +	.endm
> +
> +	/*
> +	 * mov_l - move a constant value or [relocated] address into a register
> +	 */
> +	.macro		mov_l, dst:req, imm:req
> +	.if		__LINUX_ARM_ARCH__ < 7
> +	ldr		\dst, =\imm
> +	.else
> +	movw		\dst, #:lower16:\imm
> +	movt		\dst, #:upper16:\imm
> +	.endif
> +	.endm
> +
> +	/*
> +	 * adr_l - adr pseudo-op with unlimited range
> +	 *
> +	 * @dst: destination register
> +	 * @sym: name of the symbol
> +	 */
> +	.macro		adr_l, dst:req, sym:req
> +	__adldst_l	add, \dst, \sym, \dst
> +	.endm
> +
> +	/*
> +	 * ldr_l - ldr <literal> pseudo-op with unlimited range
> +	 *
> +	 * @dst: destination register
> +	 * @sym: name of the symbol
> +	 */
> +	.macro		ldr_l, dst:req, sym:req
> +	__adldst_l	ldr, \dst, \sym, \dst
> +	.endm
> +
> +	/*
> +	 * str_l - str <literal> pseudo-op with unlimited range
> +	 *
> +	 * @src: source register
> +	 * @sym: name of the symbol
> +	 * @tmp: mandatory scratch register
> +	 */
> +	.macro		str_l, src:req, sym:req, tmp:req
> +	__adldst_l	str, \src, \sym, \tmp
> +	.endm
> +
>  #endif /* __ASM_ASSEMBLER_H__ */
> -- 
> 2.11.0
> 
> 
