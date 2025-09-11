Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A183D76;
	Thu, 11 Sep 2025 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757604150; cv=none; b=miJmSmRmdSTbHNIgP9vs2dBnRmTZ2Y5oBgk1dvlh9iOS17zx4XsUCBqYJCwhHhi0LXR198TfCLHmhQKFdjVCWVjNSXMMXQvL/vc6o6nL/OcOptZxtzkRWAwc6SWVLVNnJlRF4YKPRXW20teQZSSZM1+xF66IhG/Ti9HACdc5Re8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757604150; c=relaxed/simple;
	bh=9ANPCayp/6AVvTnSZ16aUQ6wUqmjzSzIMaezeBu+G/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RmG+mwzu1+JV4nJiCISHTZtk6LuQy36fXB2HWeb5Tx1PnTSi2UmQcV9P/14Uj8zbwWC6T6E91u/aWFhBIk4eBVh+hw3gy3bxuJJdO5zKXa1jlD2BfoArZk9EeVFvsz2h9cFuZbIVWWt52+sQ3E8avcx1mvc0f0NJDu51g1GrEzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSYgkinh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSYgkinh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B68C4CEF0;
	Thu, 11 Sep 2025 15:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757604150;
	bh=9ANPCayp/6AVvTnSZ16aUQ6wUqmjzSzIMaezeBu+G/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MSYgkinh0gRSGkEGz5xc0r1m2bUsSNbqN6icKHW2IEYCC43zT+40wghBE71VtZV27
	 r8audT2mP+p/6TFd472uOjrrok+vn1YczMO87oW0tqrvrL9gEaysJImirDa68ZtbIw
	 eCgeWDK+5rnhpvuOffBHFgPUBeizw2/boIbc9EA8laHupMWXE+EeeLzVn36Cj4bgmL
	 kj95ip718dmRvlBJKgFv1SODHSB4IGvZnqc++2h9wzkDSrhPoyqp0SpQeuNZRGRJVW
	 QkNYscyfPvUylJf7+UwH4juY7aA9mKAAwJWWOqpuY101f/pFworZ8IdbIuAybdSabm
	 2mAEXgoJll7OQ==
Date: Thu, 11 Sep 2025 16:22:24 +0100
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: catalin.marinas@arm.com, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 6/6] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aMLpMBWtHDI9sPHK@willie-the-truck>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-7-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816151929.197589-7-yeoreum.yun@arm.com>

On Sat, Aug 16, 2025 at 04:19:29PM +0100, Yeoreum Yun wrote:
> Current futex atomic operations are implemented with ll/sc instructions
> and clearing PSTATE.PAN.
> 
> Since Armv9.6, FEAT_LSUI supplies not only load/store instructions but
> also atomic operation for user memory access in kernel it doesn't need
> to clear PSTATE.PAN bit anymore.
> 
> With theses instructions some of futex atomic operations don't need to
> be implmented with ldxr/stlxr pair instead can be implmented with
> one atomic operation supplied by FEAT_LSUI.
> 
> However, some of futex atomic operations still need to use ll/sc way
> via ldtxr/stltxr supplied by FEAT_LSUI since there is no correspondant
> atomic instruction or doesn't support word size operation.
> (i.e) eor, cas{mb}t
> 
> But It's good to work without clearing PSTATE.PAN bit.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  arch/arm64/include/asm/futex.h | 130 ++++++++++++++++++++++++++++++++-
>  1 file changed, 129 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index 22a6301a9f3d..ece35ca9b5d9 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -9,6 +9,8 @@
>  #include <linux/uaccess.h>
>  #include <linux/stringify.h>
> 
> +#include <asm/alternative.h>
> +#include <asm/alternative-macros.h>
>  #include <asm/errno.h>
> 
>  #define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */
> @@ -115,11 +117,137 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
>  	return ret;
>  }
> 
> +#ifdef CONFIG_AS_HAS_LSUI
> +
> +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> +
> +#define LSUI_FUTEX_ATOMIC_OP(op, asm_op, mb)				\
> +static __always_inline int						\
> +__lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> +{									\
> +	int ret = 0;							\
> +	int oldval;							\
> +									\
> +	uaccess_ttbr0_enable();						\
> +	asm volatile("// __lsui_futex_atomic_" #op "\n"			\
> +	__LSUI_PREAMBLE							\
> +"1:	" #asm_op #mb "	%w3, %w2, %1\n"					\
> +"2:\n"									\
> +	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)				\
> +	: "+r" (ret), "+Q" (*uaddr), "=r" (oldval)			\
> +	: "r" (oparg)							\
> +	: "memory");							\
> +	uaccess_ttbr0_disable();					\
> +									\
> +	if (!ret)							\
> +		*oval = oldval;						\
> +									\
> +	return ret;							\
> +}
> +
> +LSUI_FUTEX_ATOMIC_OP(add, ldtadd, al)
> +LSUI_FUTEX_ATOMIC_OP(or, ldtset, al)
> +LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr, al)
> +LSUI_FUTEX_ATOMIC_OP(set, swpt, al)
> +
> +static __always_inline int
> +__lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
> +{
> +	return __lsui_futex_atomic_andnot(~oparg, uaddr, oval);
> +}
> +
> +static __always_inline int
> +__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
> +{
> +	unsigned int loops = LLSC_MAX_LOOPS;
> +	int ret, oldval, tmp;
> +
> +	uaccess_ttbr0_enable();
> +	/*
> +	 * there are no ldteor/stteor instructions...
> +	 */

*sigh*

Were these new instructions not added with futex in mind?

I wonder whether CAS would be better than exclusives for xor...

> +static __always_inline int
> +__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> +{
> +	int ret = 0;
> +	unsigned int loops = LLSC_MAX_LOOPS;
> +	u32 val, tmp;
> +
> +	uaccess_ttbr0_enable();
> +	/*
> +	 * cas{al}t doesn't support word size...
> +	 */

What about just aligning down and doing a 64-bit cas in that case?

Will
