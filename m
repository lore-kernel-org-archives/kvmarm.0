Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBA7258ED9;
	Fri, 12 Sep 2025 17:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757696960; cv=none; b=AyIpbAZKl53KMq+blEemSNkF6qdG7GiQ/mqxAzifgldZM4mPrEFywJdIt/P39NyG70QkTwGmca0WPc9sYN4y+ROeCg5TENm2XDUs9M8rSA3whmKSXCdA70nrAum8su62Z1HGq7nbj8d3IvKwUS37oA6n8ryk9QPlLNhePfkeVIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757696960; c=relaxed/simple;
	bh=oQZsYjxcOavc/70W54+q6w37YxcaTEy/JHsar8LA8/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q/RC5k5Y1jxkeTHOkiLxaKywnr3GwXpG6lNVaMNR8RFvRREr5KmFfYn1vUA2xb5nD2etoDBT2ywt8TI8AKXQu9vdNJNcX15/JhCQGrTf5NCkOUfTv7CYn7QJ++PzQgXwLq13EvNhT3IpZNCfnUAVbhX4nKE6tvdDCrpva/3dBjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1EAC4CEF1;
	Fri, 12 Sep 2025 17:09:17 +0000 (UTC)
Date: Fri, 12 Sep 2025 18:09:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 6/6] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aMRTu3lcwqhu-dYY@arm.com>
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

I think we can drop uaccess_ttbr0_*() from these functions. At the
kconfig level, TTBR0_PAN selects PAN. Hardware with LSUI will also
have PAN (since 8.1), so the above is an unnecessary branch or nop,
depending on how the alternatives play out. But add a comment instead.

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
> +	asm volatile("// __lsui_futex_atomic_eor\n"
> +	__LSUI_PREAMBLE
> +"	prfm	pstl1strm, %2\n"
> +"1:	ldtxr	%w1, %2\n"
> +"	eor	%w3, %w1, %w5\n"
> +"2:	stltxr	%w0, %w3, %2\n"
> +"	cbz	%w0, 3f\n"
> +"	sub	%w4, %w4, %w0\n"
> +"	cbnz	%w4, 1b\n"
> +"	mov	%w0, %w6\n"
> +"3:\n"
> +"	dmb	ish\n"
> +	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
> +	_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
> +	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),
> +	  "+r" (loops)
> +	: "r" (oparg), "Ir" (-EAGAIN)
> +	: "memory");
> +	uaccess_ttbr0_disable();
> +
> +	if (!ret)
> +		*oval = oldval;
> +
> +	return ret;
> +}

That's an unfortunate omission from the architecture.

> +#define __lsui_llsc_body(op, ...)					\
> +({									\
> +	alternative_has_cap_likely(ARM64_HAS_LSUI) ?			\
> +		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
> +})
> +
> +#else	/* CONFIG_AS_HAS_LSUI */
> +
> +#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
> +
> +#endif	/* CONFIG_AS_HAS_LSUI */
> +
> +
>  #define FUTEX_ATOMIC_OP(op)						\
>  static __always_inline int						\
>  __futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)		\
>  {									\
> -	return __llsc_futex_atomic_##op(oparg, uaddr, oval);		\
> +	return __lsui_llsc_body(futex_atomic_##op, oparg, uaddr, oval);	\
>  }

That's what I got confused about. It looks fine:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
