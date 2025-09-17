Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85EC31960D
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 13:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114322; cv=none; b=Y865PyjPZjaaCaBvcjGShoxk9jqWdbIJsBI/uKnyO4YnQdBsEBYxkotY6KOIf3xGEYFX9h5JK0L4mIseyWOtwcYEZ389vneO1O3KNbimQrOLNv4sFnZuK+wpeXMTkoQvxHHhFZXzQl4EmaV/KbLEYy8dwbyAhGpa7aqG1xFjwLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114322; c=relaxed/simple;
	bh=Zn7DP+iBhiHFFUKJovPoWHiMC8OI4Yo9zSaY/tnecGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UoigDRiKxbL8rWnScEfBSUn6fgQstVNtzSxYJQ8zDKY0FsrFVvLEmup4ra/xMY8nVgn+Ug2sg2HcuBra5L6bhSpbzqb6FZErzZNsTrvYPuJD7khQITsjRQmK7bE5O73+z+vlI5RikSy7CzuBRzJRJa45QafwjdiwK6+/TzM6QdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83712267F;
	Wed, 17 Sep 2025 06:05:09 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E86B3F66E;
	Wed, 17 Sep 2025 06:05:15 -0700 (PDT)
Date: Wed, 17 Sep 2025 14:04:43 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 5/5] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aMqx67lZZEgYW-x5@J2N7QTR9R3>
References: <20250917110838.917281-1-yeoreum.yun@arm.com>
 <20250917110838.917281-6-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917110838.917281-6-yeoreum.yun@arm.com>

On Wed, Sep 17, 2025 at 12:08:38PM +0100, Yeoreum Yun wrote:
> +static __always_inline int
> +__lsui_cmpxchg64(u64 __user *uaddr, u64 *oldval, u64 newval)
> +{
> +	int ret = 0;
> +
> +	asm volatile("// __lsui_cmpxchg64\n"
> +	__LSUI_PREAMBLE
> +"1:	casalt	%x2, %x3, %1\n"
> +"2:\n"
> +	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)
> +	: "+r" (ret), "+Q" (*uaddr), "+r" (*oldval)
> +	: "r" (newval)
> +	: "memory");
> +
> +	return ret;
> +}
> +
> +static __always_inline int
> +__lsui_cmpxchg32(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> +{
> +	u64 __user *uaddr_al;

Please use 'uaddr64' to match the other 64-bit variables.

I assume that the '_al' suffix is meant to be short for 'aligned', but I
think using '64' is more consistent and clearer.

> +	u64 oval64, nval64, tmp;

Likewise, 'orig64' would be clearer than 'tmp' here.

> +	static const u64 hi_mask = IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ?
> +		GENMASK_U64(63, 32): GENMASK_U64(31, 0);
> +	static const u8 hi_shift = IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ? 32 : 0;
> +	static const u8 lo_shift = IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ? 0 : 32;
> +
> +	uaddr_al = (u64 __user *) PTR_ALIGN_DOWN(uaddr, sizeof(u64));
> +	if (get_user(oval64, uaddr_al))
> +		return -EFAULT;
> +
> +	if ((u32 __user *)uaddr_al != uaddr) {
> +		nval64 = ((oval64 & ~hi_mask) | ((u64)newval << hi_shift));
> +		oval64 = ((oval64 & ~hi_mask) | ((u64)oldval << hi_shift));
> +	} else {
> +		nval64 = ((oval64 & hi_mask) | ((u64)newval << lo_shift));
> +		oval64 = ((oval64 & hi_mask) | ((u64)oldval << lo_shift));
> +	}
> +
> +	tmp = oval64;
> +
> +	if (__lsui_cmpxchg64(uaddr_al, &oval64, nval64))
> +		return -EFAULT;
> +
> +	if (tmp != oval64)
> +		return -EAGAIN;

This means that we'll immediately return -EAGAIN upon a spurious failure
(where the adjacent 4 bytes have changed), whereas the LL/SC ops would
retry FUTEX_MAX_LOOPS before returning -EGAIN.

I suspect we want to retry here (or in the immediate caller).

> +
> +	*oval = oldval;
> +
> +	return 0;
> +}

Aside from the retry issue, I *think* you can simplify this to something
like:

static __always_inline int
__lsui_cmpxchg32(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
{
	uaddr64 = (u64 __user *)PTR_ALIGN_DOWN(uaddr, sizeof(u64));
	u64 oval64, nval64, orig64;

	if (get_user(oval64, uaddr64)
		return -EFAULT;
	
	if (IS_ALIGNED(addr, sizeof(u64)) == IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))  {
		FIELD_MODIFY(GENMASK_U64(31, 0), &oval64, oldval);
		FIELD_MODIFY(GENMASK_U64(31, 0), &nval64, newval);
	} else {
		FIELD_MODIFY(GENMASK_U64(63, 32), &oval64, oldval);
		FIELD_MODIFY(GENMASK_U64(63, 32), &nval64, newval);
	}
	orig64 = oval64;

	if (__lsui_cmpxchg64(uaddr_al, &oval64, nval64))
		return -EFAULT;
	
	if (oval64 != orig64)
		return -EAGAIN;

	*oval = oldval;
	return 0;
}

Mark.

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
> +	u32 oldval, newval;
> +
> +	/*
> +	 * there are no ldteor/stteor instructions...
> +	 */
> +	if (get_user(oldval, uaddr))
> +		return -EFAULT;
> +
> +	newval = oldval ^ oparg;
> +
> +	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
> +
> +}
> +
> +static __always_inline int
> +__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> +{
> +	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
> +}
> +
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
>  
>  FUTEX_ATOMIC_OP(add)
> -- 
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
> 
