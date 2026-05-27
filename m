Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC22409639
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 13:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887167; cv=none; b=jY9HFAN7TaZ8SlEaTCDmrbJ/OwLVcQIO6GOCPyhEHxbMql8Xnhi7l9nDNhXSEHLWFktjjjX3O4Mwe1bYUz1uCa2+NNdtBWEpBMRvfAzNA1aDbk7JULIBX1q9l54JtGr3C7K/v5mRwIwC2QbpT+2FradYKqTGw3HoWgBiBxZ4CVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887167; c=relaxed/simple;
	bh=+Jmd8FdsttIL4C0+iErorLC9Q8DG1wkQLz9MK4rBsWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hhYKn6nCSE3Fp6hIe5iyYjHBqIplGaTGqjAMxq3qAKouof7GawbXi+wr6Om7RqDbmXaqo7QkwKMBlN2sPKbosAvQX197AAaAGTvWPCZv+jryCgcvL+v75OAgtYBlcA9rNwP7vz5+k8oeJfYHphZW74d1yyLL3VyzUbEPVANCtWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p4ZNy6oV; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p4ZNy6oV"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8EFD26AC;
	Wed, 27 May 2026 06:05:59 -0700 (PDT)
Received: from [10.1.38.169] (e121487-lin.cambridge.arm.com [10.1.38.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B61743F632;
	Wed, 27 May 2026 06:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779887164; bh=+Jmd8FdsttIL4C0+iErorLC9Q8DG1wkQLz9MK4rBsWI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p4ZNy6oVX8zHp1XsJ4yojF499gnLFm5jw2zGuh2ZNe//HzrMS4xgChgy+1e49Gotk
	 4zg2WmodpWp3E+sUiERrKW/318DZb0m1SYZ92jfkRVpxV1uvcQN+jPDPn6ac9KzBw/
	 uSCE7xd8tjBvPzAuX+qUwT0x1GHzuat/xZp7+/Ig=
Message-ID: <5261a835-2b61-419c-9305-b8e651842dff@arm.com>
Date: Wed, 27 May 2026 14:06:00 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/18] arm64: fpsimd: Use assembler for baseline SME
 instructions
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-9-mark.rutland@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260521132556.584676-9-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/26 14:25, Mark Rutland wrote:
> We currently support assemblers which do not support SME instructions,
> and have macros to manually encode SME instructions. This was
> necessary historically as SME support was developed before assembler
> support was widely available, but things have changed:
> 
> * All currently supported versions of LLVM support baseline SME
>   instructions. Building the kernel requires LLVM 15+, while LLVM 13+
>   supports SME.
> 
> * GNU binutils has supported baseline SME instructions since 2.38, which
>   was released on 09 February 2022. Toolchains using this or later are
>   widely available. For example Debian 12 (released on 10 June 2023)
>   provides binutils 2.40. Toolchains provided kernel.org provide
>   binutils 2.38+ since the GCC 12.1.0 release (released between 06 May
>   2022 and 17 August 2022).
> 
> * For various reasons, SME support was marked as BROKEN, and re-enabled
>   in v6.16 (released on 27 July 2025). The earliest support LTS kernel
>   with SME support is v6.18.y, v6.18 was tagged on 30 November 2025, and
>   contemporary toolchains (GCC 15.2 and binutils 2.45) supported
>   baseline SME instructions.
> 
> * Any distribution which intends to support SME will presumably have a
>   toolchain that supports baseline SME instructions such that userspace
>   can be built.
> 
> Considering the above, there's no practical benefit to allowing SME to
> be built when the toolchain doesn't support baseline SME instructions.
> 
> Make CONFIG_ARM64_SME depend on assembler support for SME, and remove
> the manual encoding of SME instructions. The various _sme_<insn> macros
> are kept for now, and will be cleaned up in subsequent patches.
> 
> A couple of SME2 instructions require a more recent toolchain, and are
> left as-is for now. I've looked through releases of binutils and LLVM to
> find when support was added, and noted this in a comment.
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
>  arch/arm64/Kconfig                    |  5 ++++
>  arch/arm64/include/asm/fpsimdmacros.h | 38 +++++++++++----------------
>  2 files changed, 20 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index fe60738e5943b..378e50fef247a 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -2247,10 +2247,15 @@ config ARM64_SVE
>  	  booting the kernel.  If unsure and you are not observing these
>  	  symptoms, you should assume that it is safe to say Y.
>  
> +config AS_HAS_SME
> +	# Supported by LLVM 13+ and binutils 2.38+
> +	def_bool $(as-instr,.arch_extension sme)
> +
>  config ARM64_SME
>  	bool "ARM Scalable Matrix Extension support"
>  	default y
>  	depends on ARM64_SVE
> +	depends on AS_HAS_SME
>  	help
>  	  The Scalable Matrix Extension (SME) is an extension to the AArch64
>  	  execution state which utilises a substantial subset of the SVE
> diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
> index 1122eea6daacf..d0bdbbf2d44ad 100644
> --- a/arch/arm64/include/asm/fpsimdmacros.h
> +++ b/arch/arm64/include/asm/fpsimdmacros.h
> @@ -148,46 +148,38 @@
>  	pfalse	p\np\().b
>  .endm
>  
> -/* SME instruction encodings for non-SME-capable assemblers */
> -/* (pre binutils 2.38/LLVM 13) */
> +/* Deprecated macros for SME instructions */
>  
>  /* RDSVL X\nx, #\imm */
>  .macro _sme_rdsvl nx, imm
> -	_check_general_reg \nx
> -	_check_num (\imm), -0x20, 0x1f
> -	.inst	0x04bf5800			\
> -		| (\nx)				\
> -		| (((\imm) & 0x3f) << 5)
> +	.arch_extension sme
> +	rdsvl x\nx, #\imm
>  .endm
>  
>  /*
>   * STR (vector from ZA array):
> - *	STR ZA[\nw, #\offset], [X\nxbase, #\offset, MUL VL]
> + *	STR ZA[W\nw, #\offset], [X\nxbase, #\offset, MUL VL]
>   */
>  .macro _sme_str_zav nw, nxbase, offset=0
> -	_sme_check_wv \nw
> -	_check_general_reg \nxbase
> -	_check_num (\offset), -0x100, 0xff
> -	.inst	0xe1200000			\
> -		| (((\nw) & 3) << 13)		\
> -		| ((\nxbase) << 5)		\
> -		| ((\offset) & 7)
> +	.arch_extension sme
> +	str	za[w\nw, #\offset], [x\nxbase, #\offset, MUL VL]
>  .endm
>  
>  /*
>   * LDR (vector to ZA array):
> - *	LDR ZA[\nw, #\offset], [X\nxbase, #\offset, MUL VL]
> + *	LDR ZA[w\nw, #\offset], [X\nxbase, #\offset, MUL VL]
>   */
>  .macro _sme_ldr_zav nw, nxbase, offset=0
> -	_sme_check_wv \nw
> -	_check_general_reg \nxbase
> -	_check_num (\offset), -0x100, 0xff
> -	.inst	0xe1000000			\
> -		| (((\nw) & 3) << 13)		\
> -		| ((\nxbase) << 5)		\
> -		| ((\offset) & 7)
> +	.arch_extension sme
> +	ldr	za[w\nw, #\offset], [x\nxbase, #\offset, MUL VL]
>  .endm
>  
> +/*
> + * SME2 instruction encodings for older assemblers.
> + * Supported by binutils 2.41+.
> + * Supported by LLVM 16+
> + */
> +
>  /*
>   * LDR (ZT0)
>   *
> -- 2.30.2
> 

Same nitpick about redundancy of instruction comments, but I assume you want to keep them :)

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

