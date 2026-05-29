Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC9D3451B3
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 08:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780044673; cv=none; b=Ny4Z4tPSNzVj2mQo8Z49Cu4yHIY0bHwZwICJK/9pySaNh5OC2zGu4PdYK+365BrMVXIiolhmU9p0XxpbzP/MC/gd+Em6/5v9opdv2f702EyuZ0clTYzD81dEnI/Wv55uXFpTliz7XU9xozTteuWO2PZYz8FGd++x/hJNXjDieGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780044673; c=relaxed/simple;
	bh=pdl+PbEIhEYFJrEvk5kgpdCOCgNnkLs+H3lbzdQRE48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kuk8lqSd1fNlCNOtTnvZZeWaIjpRKMw5nDXrvKeCI9LQFKS0F45EymNB1gIuTUxSdc8inDX0zelLgQPuqdH+4nUpWDH87Wg8jt84IUZLLzVGKSPB5l8mpllS3afgrTWWjUXd/gEmyqSFTVwAFSRhoGJBWM6/WDiECT6DegNzsSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cQs3sIvT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cQs3sIvT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB022204C;
	Fri, 29 May 2026 01:51:05 -0700 (PDT)
Received: from [10.1.26.144] (unknown [10.1.26.144])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE6F73F632;
	Fri, 29 May 2026 01:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780044670; bh=pdl+PbEIhEYFJrEvk5kgpdCOCgNnkLs+H3lbzdQRE48=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cQs3sIvTPVFRm4P1Lv3hL3Uxa1x2mj04emkriFGPKrSzwp6i9BGdja1sQ84jdkASS
	 IlF0pCbYt42HM4+3vaT2verhYZNIbJD9v0KO5SXBYr9BWEUN7LXEGWTWpJOmQzazZs
	 1yo7FH/rLAOTTmG3ljrT9dDUtm0pbwUbcOPbOC+A=
Message-ID: <370bf29a-780f-4517-8e85-db68fad6f8d9@arm.com>
Date: Fri, 29 May 2026 09:51:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/18] arm64: fpsimd: Move SME save/restore inline
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260528165446.701944-1-mark.rutland@arm.com>
 <20260528165446.701944-18-mark.rutland@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260528165446.701944-18-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/26 17:54, Mark Rutland wrote:
> Currently the SVE register save/restore sequences are written in
> out-of-line assembly routines. While this works, it's somewhat painful:
> 
> * For KVM to use the sequences, portions of the logic will need to be
>   duplicated in KVM hyp code. While the common logic can be shared in
>   assembly macros, this is very likely to lead to unnecessary divergence
>   and be a maintenance burden.
> 
> * For historical reasons, the assembly macros take some register
>   arguments as numerical indices (e.g. "sme_save_za 0, x2, 12" uses x0, x1, and
>   x12), which is simply confusing.
> 
> * Address generation and control flow are far clearer in C than in
>   assembly.
> 
> * The assembly sequences can't be instrumented, and so it's harder than
>   necessary to catch memory safety issues.
> 
> To handle the above, move the SME register save/restore sequences
> to inline assembly.
> 
> Neither GCC nor LLVM instrument memory arguments to inline assembly, so
> explicit instrumentation is added in the same manner as other assembly
> routines. This instrumentation is implicitly disabled by Kbuild for nVHE
> hyp code.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h       | 106 +++++++++++++++++++++++++-
>  arch/arm64/include/asm/fpsimdmacros.h |  76 ------------------
>  arch/arm64/kernel/Makefile            |   2 +-
>  arch/arm64/kernel/entry-fpsimd.S      |  48 ------------
>  4 files changed, 104 insertions(+), 128 deletions(-)
>  delete mode 100644 arch/arm64/kernel/entry-fpsimd.S
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index 550987b36206a..3ab271320d1de 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -357,9 +357,6 @@ static inline void sve_flush_live(void)
>  	);
>  }
>  
> -extern void sme_save_state(struct sme_state *state, int zt);
> -extern void sme_load_state(const struct sme_state *state, int zt);
> -
>  struct arm64_cpu_capabilities;
>  extern void cpu_enable_fpsimd(const struct arm64_cpu_capabilities *__unused);
>  extern void cpu_enable_sve(const struct arm64_cpu_capabilities *__unused);
> @@ -639,6 +636,106 @@ static inline size_t __sme_state_size(unsigned int sme_vl)
>  	return size;
>  }
>  
> +static inline void __sme_save_za(struct sme_state *state, unsigned long svl)
> +{
> +	/*
> +	 * The <Wv> argument to LDR/STR (array vector) can only encode W12-W15.
> +	 * The "Ucj" constraint exists for this, but is only supported by GCC
> +	 * 14.1.0+ and LLVM 18.1.0+.
> +	 */
> +	register unsigned int v asm ("w12");
> +
> +	instrument_write(state, svl * svl);
> +	for (v = 0; v < svl; v++) {
> +		void *pav = (void *)state + v * svl;
> +
> +		asm volatile(
> +		__SME_PREAMBLE
> +		"	str	za[%w[v], #0], [%[pav]]\n"
> +		:
> +		: [v] "r" (v),
> +		  [pav] "r" (pav)
> +		: "memory"
> +		);
> +	}
> +}
> +
> +static inline void __sme_load_za(const struct sme_state *state, unsigned long svl)
> +{
> +	/* See comment in __sme_save_za */
> +	register unsigned int v asm ("w12");
> +
> +	instrument_read(state, svl * svl);
> +	for (v = 0; v < svl; v++) {
> +		void *pav = (void *)state + v * svl;
> +
> +		asm volatile(
> +		__SME_PREAMBLE
> +		"	ldr	za[%w[v], #0], [%[pav]]\n"
> +		:
> +		: [v] "r" (v),
> +		  [pav] "r" (pav)
> +		: "memory"
> +		);
> +	}
> +}
> +
> +static inline void __sme_save_zt(struct sme_state *state, unsigned long svl)
> +{
> +	void *pzt = (void *)state + svl * svl;
> +
> +	instrument_write(pzt, svl);
> +	asm volatile(
> +	__DEFINE_ASM_GPR_NUMS
> +	/*
> +	 * STR ZT0, [<Xn|SP>]
> +	 * Supported by binutils 2.41+.
> +	 * Supported by LLVM 16+
> +	 */
> +	"	.inst	0xe13f8000 | ((.L__gpr_num_%[pzt]) << 5)\n"
> +	:
> +	: [pzt] "r" (pzt)
> +	: "memory"
> +	);
> +}
> +
> +static inline void __sme_load_zt(const struct sme_state *state, unsigned long svl)
> +{
> +	void *pzt = (void *)state + svl * svl;
> +
> +	instrument_read(pzt, svl);
> +	asm volatile(
> +	__DEFINE_ASM_GPR_NUMS
> +	/*
> +	 * LDR ZT0, [<Xn|SP>]
> +	 * Supported by binutils 2.41+.
> +	 * Supported by LLVM 16+
> +	 */
> +	"	.inst	0xe11f8000 | ((.L__gpr_num_%[pzt]) << 5)\n"
> +	:
> +	: [pzt] "r" (pzt)
> +	: "memory"
> +	);
> +}
> +
> +static inline void sme_save_state(struct sme_state *state, bool zt)
> +{
> +	unsigned long svl = sme_get_vl();
> +
> +	__sme_save_za(state, svl);
> +	if (zt)
> +		__sme_save_zt(state, svl);
> +}
> +
> +static inline void sme_load_state(const struct sme_state *state, bool zt)
> +{
> +	unsigned long svl = sme_get_vl();
> +
> +	__sme_load_za(state, svl);
> +	if (zt)
> +		__sme_load_zt(state, svl);
> +}
> +
>  /*
>   * Return how many bytes of memory are required to store the full SME
>   * specific state for task, given task's currently configured vector
> @@ -695,6 +792,9 @@ static inline size_t sme_state_size(struct task_struct const *task)
>  	return 0;
>  }
>  
> +static inline void sme_save_state(struct sme_state *state, bool zt) { BUILD_BUG(); }
> +static inline void sme_load_state(const struct sme_state *state, bool zt) { BUILD_BUG(); }
> +
>  static inline void sme_enter_from_user_mode(void) { }
>  static inline void sme_exit_to_user_mode(void) { }
>  
> diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
> index 9e352b5c6b764..a763fd03ffef3 100644
> --- a/arch/arm64/include/asm/fpsimdmacros.h
> +++ b/arch/arm64/include/asm/fpsimdmacros.h
> @@ -40,60 +40,6 @@
>  	.endif
>  .endm
>  
> -/* Deprecated macros for SME instructions */
> -
> -/* RDSVL X\nx, #\imm */
> -.macro _sme_rdsvl nx, imm
> -	.arch_extension sme
> -	rdsvl x\nx, #\imm
> -.endm
> -
> -/*
> - * STR (vector from ZA array):
> - *	STR ZA[W\nw, #\offset], [X\nxbase, #\offset, MUL VL]
> - */
> -.macro _sme_str_zav nw, nxbase, offset=0
> -	.arch_extension sme
> -	str	za[w\nw, #\offset], [x\nxbase, #\offset, MUL VL]
> -.endm
> -
> -/*
> - * LDR (vector to ZA array):
> - *	LDR ZA[w\nw, #\offset], [X\nxbase, #\offset, MUL VL]
> - */
> -.macro _sme_ldr_zav nw, nxbase, offset=0
> -	.arch_extension sme
> -	ldr	za[w\nw, #\offset], [x\nxbase, #\offset, MUL VL]
> -.endm
> -
> -/*
> - * SME2 instruction encodings for older assemblers.
> - * Supported by binutils 2.41+.
> - * Supported by LLVM 16+
> - */
> -
> -/*
> - * LDR (ZT0)
> - *
> - *	LDR ZT0, nx
> - */
> -.macro _ldr_zt nx
> -	_check_general_reg \nx
> -	.inst	0xe11f8000	\
> -		 | (\nx << 5)
> -.endm
> -
> -/*
> - * STR (ZT0)
> - *
> - *	STR ZT0, nx
> - */
> -.macro _str_zt nx
> -	_check_general_reg \nx
> -	.inst	0xe13f8000		\
> -		| (\nx << 5)
> -.endm
> -
>  .macro __for from:req, to:req
>  	.if (\from) == (\to)
>  		_for__body %\from
> @@ -116,25 +62,3 @@
>  
>  	.purgem _for__body
>  .endm
> -
> -.macro sme_save_za nxbase, xvl, nw
> -	mov	w\nw, #0
> -
> -423:
> -	_sme_str_zav \nw, \nxbase
> -	add	x\nxbase, x\nxbase, \xvl
> -	add	x\nw, x\nw, #1
> -	cmp	\xvl, x\nw
> -	bne	423b
> -.endm
> -
> -.macro sme_load_za nxbase, xvl, nw
> -	mov	w\nw, #0
> -
> -423:
> -	_sme_ldr_zav \nw, \nxbase
> -	add	x\nxbase, x\nxbase, \xvl
> -	add	x\nw, x\nw, #1
> -	cmp	\xvl, x\nw
> -	bne	423b
> -.endm
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 74b76bb704523..d2690c3ec5288 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -27,7 +27,7 @@ KCOV_INSTRUMENT_idle.o := n
>  
>  # Object file lists.
>  obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
> -			   entry-common.o entry-fpsimd.o process.o ptrace.o	\
> +			   entry-common.o process.o ptrace.o			\
>  			   setup.o signal.o sys.o stacktrace.o time.o traps.o	\
>  			   io.o vdso.o hyp-stub.o psci.o cpu_ops.o		\
>  			   return_address.o cpuinfo.o cpu_errata.o		\
> diff --git a/arch/arm64/kernel/entry-fpsimd.S b/arch/arm64/kernel/entry-fpsimd.S
> deleted file mode 100644
> index bff941eea9566..0000000000000
> --- a/arch/arm64/kernel/entry-fpsimd.S
> +++ /dev/null
> @@ -1,48 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-only */
> -/*
> - * FP/SIMD state saving and restoring
> - *
> - * Copyright (C) 2012 ARM Ltd.
> - * Author: Catalin Marinas <catalin.marinas@arm.com>
> - */
> -
> -#include <linux/linkage.h>
> -
> -#include <asm/assembler.h>
> -#include <asm/fpsimdmacros.h>
> -
> -#ifdef CONFIG_ARM64_SME
> -
> -/*
> - * Save the ZA and ZT state
> - *
> - * x0 - pointer to buffer for state
> - * x1 - number of ZT registers to save
> - */
> -SYM_FUNC_START(sme_save_state)
> -	_sme_rdsvl	2, 1		// x2 = VL/8
> -	sme_save_za 0, x2, 12		// Leaves x0 pointing to the end of ZA
> -
> -	cbz	x1, 1f
> -	_str_zt 0
> -1:
> -	ret
> -SYM_FUNC_END(sme_save_state)
> -
> -/*
> - * Load the ZA and ZT state
> - *
> - * x0 - pointer to buffer for state
> - * x1 - number of ZT registers to save
> - */
> -SYM_FUNC_START(sme_load_state)
> -	_sme_rdsvl	2, 1		// x2 = VL/8
> -	sme_load_za 0, x2, 12		// Leaves x0 pointing to the end of ZA
> -
> -	cbz	x1, 1f
> -	_ldr_zt 0
> -1:
> -	ret
> -SYM_FUNC_END(sme_load_state)
> -
> -#endif /* CONFIG_ARM64_SME */
> -- 2.30.2
> 

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

