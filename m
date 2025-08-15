Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E3C1C5D55;
	Fri, 15 Aug 2025 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755275942; cv=none; b=ZaU4+yKt/25/PfCTSxNEEDl/bjDcD1O80lJAr7nMfsvqhSyDZHM8z77t40eVzaUeNf/0SfL+JZuXb7AKCAMTCz4JgAnNK3aURDhwU0SkBDd+zKx/RGrHtJFffx0YGwhUh+G2FnrH4zE4Su24dQaP12c7+geDQHg/TpT6A6zpwKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755275942; c=relaxed/simple;
	bh=Wpg/avr97Ist51A5D10+gpdWU+KBf3aC8GYmR7eeR6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t02gg2RuGZStTjTWK77RSoAEqFOHGlP0SqoFPZwp38BOpHRLIZQ6vBDv04POZNpUkT/9RMCXn+bGGjnwGUEFVFrLGzmW1faatawk+hqFvlFmjvjQzb7VlK+IvTdsibD6aN4xcdYFAnLrcDt8xokv59RoNG9Y77Q7+0CVLkc6NEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6195C4CEEB;
	Fri, 15 Aug 2025 16:38:57 +0000 (UTC)
Date: Fri, 15 Aug 2025 17:38:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
	joey.gouly@arm.com, james.morse@arm.com, ardb@kernel.org,
	scott@os.amperecomputing.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 4/5] arm64: futex: refactor futex atomic operation
Message-ID: <aJ9in0fUI01J3a4S@arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-5-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811163635.1562145-5-yeoreum.yun@arm.com>

On Mon, Aug 11, 2025 at 05:36:34PM +0100, Yeoreum Yun wrote:
> Refactor futex atomic operations using ll/sc method with
> clearing PSTATE.PAN to prepare to apply FEAT_LSUI on them.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  arch/arm64/include/asm/futex.h | 183 ++++++++++++++++++++++-----------
>  1 file changed, 124 insertions(+), 59 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index bc06691d2062..fdec4f3f2b15 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -7,73 +7,164 @@
>  
>  #include <linux/futex.h>
>  #include <linux/uaccess.h>
> +#include <linux/stringify.h>
>  
>  #include <asm/errno.h>
>  
> -#define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
> +#define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */
>  
> -#define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
> -do {									\
> -	unsigned int loops = FUTEX_MAX_LOOPS;				\
> +#define LLSC_FUTEX_ATOMIC_OP(op, asm_op)				\
> +static __always_inline int						\
> +__llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> +{									\
> +	unsigned int loops = LLSC_MAX_LOOPS;				\
> +	int ret, val, tmp;						\
>  									\
>  	uaccess_enable_privileged();					\
> -	asm volatile(							\
> -"	prfm	pstl1strm, %2\n"					\
> -"1:	ldxr	%w1, %2\n"						\
> -	insn "\n"							\
> -"2:	stlxr	%w0, %w3, %2\n"						\
> -"	cbz	%w0, 3f\n"						\
> -"	sub	%w4, %w4, %w0\n"					\
> -"	cbnz	%w4, 1b\n"						\
> -"	mov	%w0, %w6\n"						\
> -"3:\n"									\
> -"	dmb	ish\n"							\
> +	asm volatile("// __llsc_futex_atomic_" #op "\n"		\
> +	"	prfm	pstl1strm, %2\n"				\
> +	"1:	ldxr	%w1, %2\n"					\
> +	"	" #asm_op "	%w3, %w1, %w5\n"			\
> +	"2:	stlxr	%w0, %w3, %2\n"					\
> +	"	cbz	%w0, 3f\n"					\
> +	"	sub	%w4, %w4, %w0\n"				\
> +	"	cbnz	%w4, 1b\n"					\
> +	"	mov	%w0, %w6\n"					\
> +	"3:\n"								\
> +	"	dmb	ish\n"						\

Don't change indentation and code in the same patch, it makes it harder
to follow what you actually changed. I guess the only difference is
asm_op instead of insn.

>  	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)				\
>  	_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)				\
> -	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),	\
> +	: "=&r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp),		\

And here you changed oldval to val (was this necessary?)

>  	  "+r" (loops)							\
>  	: "r" (oparg), "Ir" (-EAGAIN)					\
>  	: "memory");							\
>  	uaccess_disable_privileged();					\
> -} while (0)
> +									\
> +	if (!ret)							\
> +		*oval = val;						\
> +									\
> +	return ret;							\
> +}
> +
> +LLSC_FUTEX_ATOMIC_OP(add, add)
> +LLSC_FUTEX_ATOMIC_OP(or, orr)
> +LLSC_FUTEX_ATOMIC_OP(and, and)
> +LLSC_FUTEX_ATOMIC_OP(eor, eor)
> +
> +static __always_inline int
> +__llsc_futex_atomic_set(int oparg, u32 __user *uaddr, int *oval)
> +{
> +	unsigned int loops = LLSC_MAX_LOOPS;
> +	int ret, val;
> +
> +	uaccess_enable_privileged();
> +	asm volatile("//__llsc_futex_xchg\n"
> +	"	prfm	pstl1strm, %2\n"
> +	"1:	ldxr	%w1, %2\n"
> +	"2:	stlxr	%w0, %w4, %2\n"
> +	"	cbz	%w3, 3f\n"
> +	"	sub	%w3, %w3, %w0\n"
> +	"	cbnz	%w3, 1b\n"
> +	"	mov	%w0, %w5\n"
> +	"3:\n"
> +	"	dmb	ish\n"
> +	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
> +	_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
> +	: "=&r" (ret), "=&r" (val), "+Q" (*uaddr), "+r" (loops)
> +	: "r" (oparg), "Ir" (-EAGAIN)
> +	: "memory");
> +	uaccess_disable_privileged();

Was this separate function just to avoid the "mov" instruction for the
"set" case? The patch description states that the reworking is necessary
for the FEAT_LSUI use but it looks to me like it does more. Please split
it in separate patches, though I'd leave any potential optimisation for
a separate series and keep the current code as close as possible to the
original one.

-- 
Catalin
