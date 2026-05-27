Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB5639903B
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 12:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779886696; cv=none; b=EmTHwxyPsxDJO6juOlLSt93DWOGiAufxRm+tX3m7/8yE92XjlxMUs/kSjh26hcwMkqAKb1ZBwIz94kihgqsxYvmQQfHhPhUa55C1qy0H5fc1pKh6OJ9dB9Bj2s24nATB00B/GMkJKM9HHjrDYooYRcmxrRvBSkCBxoIAOnDSaWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779886696; c=relaxed/simple;
	bh=zQQrzsmFJ7jMfax/fmWt/EiwGPfzxNJTM4orn2gv248=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SLZd8mj1pZMOV+/mCIvjNccXyxSNQy6Kbi0WEERYRkx+MAO6bYxPJi5wwgcqE7Sge4pNFytATSzjdhCNlkHVqDu8/A2OVfc6o/FnPePhl718YJRRK5ERpQywfO0TbSbBcS7uOzqPO3xa7OPKUe9YMdt/E/qTcma+j9xvfda4IwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tJkdiaBS; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tJkdiaBS"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DEEA2880;
	Wed, 27 May 2026 05:58:08 -0700 (PDT)
Received: from [10.1.38.169] (e121487-lin.cambridge.arm.com [10.1.38.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6A1E3F7D8;
	Wed, 27 May 2026 05:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779886693; bh=zQQrzsmFJ7jMfax/fmWt/EiwGPfzxNJTM4orn2gv248=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tJkdiaBSLoUZv1P0XYLtyz27hk/5G6pKPd3hXE0cuLK6O07xaLpcKM2AO3Shr71eZ
	 I+jxDIqPUSWdWnS/Y4LyL5fuN78E98kMrsQPZCt4h0Q7IDJ1u6D4Smgd4Y+OlXzhUf
	 q7QXSKx5e6Ye9zyQ61aG+U5eB3HQUpJUpTUN31E8=
Message-ID: <46c5ae49-e59c-4014-91d3-f00124897d20@arm.com>
Date: Wed, 27 May 2026 13:58:09 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/18] arm64: fpsimd: Use assembler for SVE instructions
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-8-mark.rutland@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260521132556.584676-8-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

On 5/21/26 14:25, Mark Rutland wrote:
> Historically we supported assemblers which could not assemble SVE
> instructions. We dropped support for such assemblers in commit:
> 
>   118c40b7b503 ("kbuild: require gcc-8 and binutils-2.30")
> 
> Since that commit, all supported assemblers (binutils and LLVM) are
> capable of assembling SVE instructions, and there's no need for us to
> manually encode SVE instructions.
> 
> Rely on the assembler to encode SVE instructions, and remove the manual
> encoding. The various _sve_<insn> macros are kept for now, and will be
> cleaned up in subsequent patches.
> 
> There should be no functional change as a result of this patch.
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
>  arch/arm64/include/asm/fpsimdmacros.h | 64 +++++++--------------------
>  1 file changed, 16 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
> index adf33d2da40c3..1122eea6daacf 100644
> --- a/arch/arm64/include/asm/fpsimdmacros.h
> +++ b/arch/arm64/include/asm/fpsimdmacros.h
> @@ -99,85 +99,53 @@
>  	.endif
>  .endm
>  
> -/* SVE instruction encodings for non-SVE-capable assemblers */
> -/* (pre binutils 2.28, all kernel capable clang versions support SVE) */
> +/* Deprecated macros for SVE instructions */
>  
>  /* STR (vector): STR Z\nz, [X\nxbase, #\offset, MUL VL] */

Nitpick:

all these comments now redundant and just repeat the code... I know they are gone by
the end of the series :)

>  .macro _sve_str_v nz, nxbase, offset=0
> -	_sve_check_zreg \nz
> -	_check_general_reg \nxbase
> -	_check_num (\offset), -0x100, 0xff
> -	.inst	0xe5804000			\
> -		| (\nz)				\
> -		| ((\nxbase) << 5)		\
> -		| (((\offset) & 7) << 10)	\
> -		| (((\offset) & 0x1f8) << 13)
> +	.arch_extension sve
> +	str	z\nz, [X\nxbase, #\offset, MUL VL]
>  .endm
>  
>  /* LDR (vector): LDR Z\nz, [X\nxbase, #\offset, MUL VL] */
>  .macro _sve_ldr_v nz, nxbase, offset=0
> -	_sve_check_zreg \nz
> -	_check_general_reg \nxbase
> -	_check_num (\offset), -0x100, 0xff
> -	.inst	0x85804000			\
> -		| (\nz)				\
> -		| ((\nxbase) << 5)		\
> -		| (((\offset) & 7) << 10)	\
> -		| (((\offset) & 0x1f8) << 13)
> +	.arch_extension sve
> +	ldr	z\nz, [X\nxbase, #\offset, MUL VL]
>  .endm
>  
>  /* STR (predicate): STR P\np, [X\nxbase, #\offset, MUL VL] */
>  .macro _sve_str_p np, nxbase, offset=0
> -	_sve_check_preg \np
> -	_check_general_reg \nxbase
> -	_check_num (\offset), -0x100, 0xff
> -	.inst	0xe5800000			\
> -		| (\np)				\
> -		| ((\nxbase) << 5)		\
> -		| (((\offset) & 7) << 10)	\
> -		| (((\offset) & 0x1f8) << 13)
> +	.arch_extension sve
> +	str	p\np, [X\nxbase, #\offset, MUL VL]
>  .endm
>  
>  /* LDR (predicate): LDR P\np, [X\nxbase, #\offset, MUL VL] */
>  .macro _sve_ldr_p np, nxbase, offset=0
> -	_sve_check_preg \np
> -	_check_general_reg \nxbase
> -	_check_num (\offset), -0x100, 0xff
> -	.inst	0x85800000			\
> -		| (\np)				\
> -		| ((\nxbase) << 5)		\
> -		| (((\offset) & 7) << 10)	\
> -		| (((\offset) & 0x1f8) << 13)
> +	.arch_extension sve
> +	ldr p\np, [x\nxbase, #\offset, MUL VL]
>  .endm
>  
>  /* RDVL X\nx, #\imm */
>  .macro _sve_rdvl nx, imm
> -	_check_general_reg \nx
> -	_check_num (\imm), -0x20, 0x1f
> -	.inst	0x04bf5000			\
> -		| (\nx)				\
> -		| (((\imm) & 0x3f) << 5)
> +	.arch_extension sve
> +	rdvl x\nx, #\imm
>  .endm
>  
>  /* RDFFR (unpredicated): RDFFR P\np.B */
>  .macro _sve_rdffr np
> -	_sve_check_preg \np
> -	.inst	0x2519f000			\
> -		| (\np)
> +	.arch_extension sve
> +	rdffr p\np\().b
>  .endm
>  
>  /* WRFFR P\np.B */
>  .macro _sve_wrffr np
> -	_sve_check_preg \np
> -	.inst	0x25289000			\
> -		| ((\np) << 5)

Missing ".arch_extension sve"?

> +	wrffr p\np\().b
>  .endm
>  
>  /* PFALSE P\np.B */
>  .macro _sve_pfalse np
> -	_sve_check_preg \np
> -	.inst	0x2518e400			\
> -		| (\np)
> +	.arch_extension sve
> +	pfalse	p\np\().b
>  .endm
>  
>  /* SME instruction encodings for non-SME-capable assemblers */
> -- 2.30.2
> 

