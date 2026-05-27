Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AAD13DC4CB
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 13:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887903; cv=none; b=rH2bZQ4V8Mqb4GD7cVCqAijPYHhBkJ75EKHe1uWCIPPgY2ndKCphellCxGhQ3X3pMfG4n9w+2hau0ncZml2JmGbvjYBl0BCPlOm4iGojdQz2bnqHXHHSGXwUJgw9a1twN54ffBI4mvZlv8I/ZuWDytpabEeRbHnV0KPFpxoXgN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887903; c=relaxed/simple;
	bh=qTKMZPFmYtgkMgWY9NY+6DhqpGrmznOWa2OVHhlCXJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VQqIJK4xwtq/3UtPNgE2L+8i+YBcSlcBE1mzPldR0qd5JfDIhIZxb+cNwTkfNWubaR6yfV99ZA8WCMclXU8o3z5WCzSi3WcdfVQbR33Mby0q16Sfp9lH0n7agp0l8I2CqIxM9qs6H1Ju0RXu7od7pw0YktmVXp1cCxXUiTr+6kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mu9WWtT6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mu9WWtT6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C48B2880;
	Wed, 27 May 2026 06:18:15 -0700 (PDT)
Received: from [10.1.38.169] (e121487-lin.cambridge.arm.com [10.1.38.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 521ED3F632;
	Wed, 27 May 2026 06:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779887900; bh=qTKMZPFmYtgkMgWY9NY+6DhqpGrmznOWa2OVHhlCXJk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mu9WWtT6zk/tWZvLuFeU80H+kbouC9LN4T1d3qHY/Kp4OR2L5SW9UgFVlicq0cjF3
	 vRrhNnvNDLYBslyn+dS/P3x1Hus86ONQM+e6ROt0BxCFqAWL1i3/dDbnAqgJsBHSzl
	 o0XQG9IYxXSEVIA8XPeXeWIW/90z9k35qSRDaRxY=
Message-ID: <4aeb92a2-e64e-4969-8588-88d780e4e54a@arm.com>
Date: Wed, 27 May 2026 14:18:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/18] arm64: fpsimd: Move sve_get_vl() and sme_get_vl()
 inline
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-10-mark.rutland@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260521132556.584676-10-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/26 14:25, Mark Rutland wrote:
> The sve_get_vl() and sme_get_vl() functions are wrappers for the RDVL
> and RDSVL instructions respectively. There's no need for those to be
> out-of-line.
> 
> Replace the out-of-line assembly functions with equivalent inline
> functions.
> 
> The _sve_rdvl assembly macro is unused, and so it is removed. The
> _sme_rdsvl assembly macro is still used elsewhere, and so is kept for
> now.
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
>  arch/arm64/include/asm/fpsimd.h       | 31 +++++++++++++++++++++++++--
>  arch/arm64/include/asm/fpsimdmacros.h |  6 ------
>  arch/arm64/kernel/entry-fpsimd.S      | 10 ---------
>  3 files changed, 29 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index 8efa3c0402a7a..36cf528e64971 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -22,6 +22,9 @@
>  #include <linux/stddef.h>
>  #include <linux/types.h>
>  
> +#define __SVE_PREAMBLE		".arch_extension sve\n"
> +#define __SME_PREAMBLE		".arch_extension sme\n"
> +
>  /* Masks for extracting the FPSR and FPCR from the FPSCR */
>  #define VFP_FPSCR_STAT_MASK	0xf800009f
>  #define VFP_FPSCR_CTRL_MASK	0x07f79f00
> @@ -141,11 +144,23 @@ static inline void *thread_zt_state(struct thread_struct *thread)
>  	return thread->sme_state + ZA_SIG_REGS_SIZE(sme_vq);
>  }
>  
> +static inline unsigned int sve_get_vl(void)
> +{
> +	unsigned int vl;
> +
> +	asm volatile(
> +	__SVE_PREAMBLE
> +	"	rdvl %x[vl], #1\n"
> +	: [vl] "=r" (vl)
> +	);
> +
> +	return vl;
> +}
> +
>  extern void sve_save_state(void *state, u32 *pfpsr, int save_ffr);
>  extern void sve_load_state(void const *state, u32 const *pfpsr,
>  			   int restore_ffr);
>  extern void sve_flush_live(bool flush_ffr, unsigned long vq_minus_1);
> -extern unsigned int sve_get_vl(void);
>  extern void sme_save_state(void *state, int zt);
>  extern void sme_load_state(void const *state, int zt);
>  
> @@ -400,8 +415,20 @@ static inline int sme_max_virtualisable_vl(void)
>  	return vec_max_virtualisable_vl(ARM64_VEC_SME);
>  }
>  
> +static inline unsigned int sme_get_vl(void)
> +{
> +	unsigned int vl;
> +
> +	asm volatile(
> +	__SME_PREAMBLE
> +	"	rdsvl %x[vl], #1\n"
> +	: [vl] "=r" (vl)
> +	);
> +
> +	return vl;
> +}
> +
>  extern void sme_alloc(struct task_struct *task, bool flush);
> -extern unsigned int sme_get_vl(void);
>  extern int sme_set_current_vl(unsigned long arg);
>  extern int sme_get_current_vl(void);
>  extern void sme_suspend_exit(void);
> diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
> index d0bdbbf2d44ad..d75c9d4c9989b 100644
> --- a/arch/arm64/include/asm/fpsimdmacros.h
> +++ b/arch/arm64/include/asm/fpsimdmacros.h
> @@ -125,12 +125,6 @@
>  	ldr p\np, [x\nxbase, #\offset, MUL VL]
>  .endm
>  
> -/* RDVL X\nx, #\imm */
> -.macro _sve_rdvl nx, imm
> -	.arch_extension sve
> -	rdvl x\nx, #\imm
> -.endm
> -
>  /* RDFFR (unpredicated): RDFFR P\np.B */
>  .macro _sve_rdffr np
>  	.arch_extension sve
> diff --git a/arch/arm64/kernel/entry-fpsimd.S b/arch/arm64/kernel/entry-fpsimd.S
> index 88c555745b584..7f2d31dff8c17 100644
> --- a/arch/arm64/kernel/entry-fpsimd.S
> +++ b/arch/arm64/kernel/entry-fpsimd.S
> @@ -57,11 +57,6 @@ SYM_FUNC_START(sve_load_state)
>  	ret
>  SYM_FUNC_END(sve_load_state)
>  
> -SYM_FUNC_START(sve_get_vl)
> -	_sve_rdvl	0, 1
> -	ret
> -SYM_FUNC_END(sve_get_vl)
> -
>  /*
>   * Zero all SVE registers but the first 128-bits of each vector
>   *
> @@ -84,11 +79,6 @@ SYM_FUNC_END(sve_flush_live)
>  
>  #ifdef CONFIG_ARM64_SME
>  
> -SYM_FUNC_START(sme_get_vl)
> -	_sme_rdsvl	0, 1
> -	ret
> -SYM_FUNC_END(sme_get_vl)
> -
>  /*
>   * Save the ZA and ZT state
>   *
> -- 2.30.2
> 

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

