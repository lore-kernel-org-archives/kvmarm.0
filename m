Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471B7343D7C;
	Thu, 11 Sep 2025 15:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757604536; cv=none; b=jxjX8zazG5fovtNz1iVa1pHLK1UXjdhL6hB7Bp82JSX+/QfoLRfSlFQVdpwUE7rALd0uNpKYvdGacR2MfVP3m71LjDmfEStmPHICv6kXbWM+TXXUl7VYl+e0gf3EZgTusvg6OffdibIdCt7wiYrcRCjpq0l2NSamgD9TJMXLoOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757604536; c=relaxed/simple;
	bh=7zogeD5U+3a3b8x9LW5ah9FYZnDdsBjL9Qsg7Ua4oy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8ecLkBBMk9G/bSV0PfLMsI+c/mtS9JY78drgf3uyyR7lPIM0Y0yotLCWy80sBEPc4c21psdDIvCWlo9zOlvKKwqF/lKZhWrOJGRwt7hpgsA3pILvRnvUI69Q+UsO9IddMeU66+SsTRDwA2TXddgzcloraU+xOzkvbYMpNJahQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pHRwvcbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pHRwvcbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0BBC4CEF0;
	Thu, 11 Sep 2025 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757604535;
	bh=7zogeD5U+3a3b8x9LW5ah9FYZnDdsBjL9Qsg7Ua4oy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pHRwvcbfBxyQUYkjkexYTVYl9ySPcLwALUBC4vaBD1UyWRvgoRdRvwd70UoKnqD5Q
	 FUDwHqjMtZSoO7VTmFDwt1oZ/6G/kdyQJ473Rzg6wfd6q4NpwXtotx3v4WBYp6IWGk
	 PrhGM4z6ZXc0yVSj2AQd3OQwgwXimWGgBX82ZgtE0yy3ZYyUWVKeHX+mb9HRDeZmdE
	 xlcJuztvM3qEDnS9zTrh0CcDCldYE0/o6NpiE/oJnBqd1N3b9xRPiOZpWRQCLMWJ9Y
	 Vh5dbqboW1BkhyaT6KmsJxTMUZqHro3kF+fpJ5ArvSlVwQGF4/zNlRaYd3G3OiRSkJ
	 2ylPwTbCDibeg==
Date: Thu, 11 Sep 2025 16:28:49 +0100
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: catalin.marinas@arm.com, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 RESEND 5/6] arm64: futex: small optimisation for
 __llsc_futex_atomic_set()
Message-ID: <aMLqsez5y9R6FIdJ@willie-the-truck>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-6-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816151929.197589-6-yeoreum.yun@arm.com>

On Sat, Aug 16, 2025 at 04:19:28PM +0100, Yeoreum Yun wrote:
> __llsc_futex_atomic_set() is implmented using
> LLSC_FUTEX_ATOMIC_OP() macro with "mov  %w3, %w5".
> But this instruction isn't required to implement fux_atomic_set()
> so make a small optimisation by implementing __llsc_futex_atomic_set()
> as separate function.
> 
> This will make usage of LLSC_FUTEX_ATOMIC_OP() macro more simple.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  arch/arm64/include/asm/futex.h | 43 ++++++++++++++++++++++++++++------
>  1 file changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index ab7003cb4724..22a6301a9f3d 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -13,7 +13,7 @@
> 
>  #define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */
> 
> -#define LLSC_FUTEX_ATOMIC_OP(op, insn)					\
> +#define LLSC_FUTEX_ATOMIC_OP(op, asm_op)				\
>  static __always_inline int						\
>  __llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
>  {									\
> @@ -24,7 +24,7 @@ __llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
>  	asm volatile("// __llsc_futex_atomic_" #op "\n"			\
>  "	prfm	pstl1strm, %2\n"					\
>  "1:	ldxr	%w1, %2\n"						\
> -	insn "\n"							\
> +"	" #asm_op "	%w3, %w1, %w5\n"				\
>  "2:	stlxr	%w0, %w3, %2\n"						\
>  "	cbz	%w0, 3f\n"						\
>  "	sub	%w4, %w4, %w0\n"					\
> @@ -46,11 +46,40 @@ __llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
>  	return ret;							\
>  }
> 
> -LLSC_FUTEX_ATOMIC_OP(add, "add	%w3, %w1, %w5")
> -LLSC_FUTEX_ATOMIC_OP(or, "orr	%w3, %w1, %w5")
> -LLSC_FUTEX_ATOMIC_OP(and, "and	%w3, %w1, %w5")
> -LLSC_FUTEX_ATOMIC_OP(eor, "eor	%w3, %w1, %w5")
> -LLSC_FUTEX_ATOMIC_OP(set, "mov	%w3, %w5")
> +LLSC_FUTEX_ATOMIC_OP(add, add)
> +LLSC_FUTEX_ATOMIC_OP(or, orr)
> +LLSC_FUTEX_ATOMIC_OP(and, and)
> +LLSC_FUTEX_ATOMIC_OP(eor, eor)
> +
> +static __always_inline int
> +__llsc_futex_atomic_set(int oparg, u32 __user *uaddr, int *oval)
> +{
> +	unsigned int loops = LLSC_MAX_LOOPS;
> +	int ret, oldval;
> +
> +	uaccess_enable_privileged();
> +	asm volatile("//__llsc_futex_xchg\n"
> +"	prfm	pstl1strm, %2\n"
> +"1:	ldxr	%w1, %2\n"
> +"2:	stlxr	%w0, %w4, %2\n"
> +"	cbz	%w3, 3f\n"
> +"	sub	%w3, %w3, %w0\n"
> +"	cbnz	%w3, 1b\n"
> +"	mov	%w0, %w5\n"
> +"3:\n"
> +"	dmb	ish\n"
> +	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
> +	_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
> +	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "+r" (loops)
> +	: "r" (oparg), "Ir" (-EAGAIN)
> +	: "memory");
> +	uaccess_disable_privileged();
> +
> +	if (!ret)
> +		*oval = oldval;

Hmm, I'm really not sure this is worthwhile. I doubt the "optimisation"
actually does anything and adding a whole new block of asm just for the
SET case isn't much of an improvement on the maintainability side, either.

Will
