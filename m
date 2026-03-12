Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4323E3FEB04
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 18:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773339456; cv=none; b=NbmDJpRHUyHeW7D9bpu5ZRuvnSpDuc/xoKr+k3KDY+AU+D4easM8XxUZw1XH0l8c9a5pQStzhHBu637tzmLjIPN0eRMyseEXoTDMzT2PufTfbb+nt3nc0xlRnVcp4ODOviPtpnu+WUyrCbgWY/UaNKyLddl/0GvqAgCndD+AU/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773339456; c=relaxed/simple;
	bh=oseE2rbEt6AvnSSYQiq+1Dcp8V/0TQwolE8LQt7EC+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tByBQODuvM4sooflSIXLSG91uRfS3mEDZR1cTt5jDoi0/CG7jJRVa2BnXGh2MqGwqOGOQwQfVYvmUvr1TDhf7h5Trk3yMKu0o14PX+N6hrAq320NPibHwSqkzpmFYpilYUHHa9F0Ec3vEnY9uH+5GiTpe3uUSA1b1gF4Qxq6HaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75E22165C;
	Thu, 12 Mar 2026 11:17:26 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B4223F73B;
	Thu, 12 Mar 2026 11:17:30 -0700 (PDT)
Date: Thu, 12 Mar 2026 18:17:28 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v15 5/8] arm64: futex: support futex with FEAT_LSUI
Message-ID: <abMDOC5DYEm74And@arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
 <20260227151705.1275328-6-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227151705.1275328-6-yeoreum.yun@arm.com>

On Fri, Feb 27, 2026 at 03:17:02PM +0000, Yeoreum Yun wrote:
> +#ifdef CONFIG_ARM64_LSUI
> +
> +/*
> + * FEAT_LSUI is supported since Armv9.6, where FEAT_PAN is mandatory.
> + * However, this assumption may not always hold:
> + *
> + *   - Some CPUs advertise FEAT_LSUI but lack FEAT_PAN.
> + *   - Virtualisation or ID register overrides may expose invalid
> + *     feature combinations.
> + *
> + * Rather than disabling FEAT_LSUI when FEAT_PAN is absent, wrap LSUI
> + * instructions with uaccess_ttbr0_enable()/disable() when
> + * ARM64_SW_TTBR0_PAN is enabled.
> + */

I'd just keep this comment in the commit log. Here you could simply say
that user access instructions don't require (hardware) PAN toggling. It
should be obvious why we use ttbr0 toggling like for other uaccess
routines.

> +#define LSUI_FUTEX_ATOMIC_OP(op, asm_op)				\
> +static __always_inline int						\
> +__lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> +{									\
> +	int ret = 0;							\
> +	int oldval;							\
> +									\
> +	uaccess_ttbr0_enable();						\
> +									\
> +	asm volatile("// __lsui_futex_atomic_" #op "\n"			\
> +	__LSUI_PREAMBLE							\
> +"1:	" #asm_op "al	%w3, %w2, %1\n"					\

As I mentioned on a previous patch, can we not use named operators here?

> +"2:\n"									\
> +	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)				\
> +	: "+r" (ret), "+Q" (*uaddr), "=r" (oldval)			\
> +	: "r" (oparg)							\
> +	: "memory");							\
> +									\
> +	uaccess_ttbr0_disable();					\
> +									\
> +	if (!ret)							\
> +		*oval = oldval;						\
> +	return ret;							\
> +}
> +
> +LSUI_FUTEX_ATOMIC_OP(add, ldtadd)
> +LSUI_FUTEX_ATOMIC_OP(or, ldtset)
> +LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr)
> +LSUI_FUTEX_ATOMIC_OP(set, swpt)
> +
> +static __always_inline int
> +__lsui_cmpxchg64(u64 __user *uaddr, u64 *oldval, u64 newval)
> +{
> +	int ret = 0;
> +
> +	uaccess_ttbr0_enable();
> +
> +	asm volatile("// __lsui_cmpxchg64\n"
> +	__LSUI_PREAMBLE
> +"1:	casalt	%2, %3, %1\n"
> +"2:\n"
> +	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)
> +	: "+r" (ret), "+Q" (*uaddr), "+r" (*oldval)
> +	: "r" (newval)
> +	: "memory");
> +
> +	uaccess_ttbr0_disable();
> +
> +	return ret;

So here it returns EFAULT only if the check failed. The EAGAIN is only
possible in cmpxchg32. That's fine but I have more comments below.

> +}
> +
> +static __always_inline int
> +__lsui_cmpxchg32(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> +{
> +	u64 __user *uaddr64;
> +	bool futex_pos, other_pos;
> +	int ret, i;
> +	u32 other, orig_other;
> +	union {
> +		u32 futex[2];
> +		u64 raw;
> +	} oval64, orig64, nval64;
> +
> +	uaddr64 = (u64 __user *) PTR_ALIGN_DOWN(uaddr, sizeof(u64));

Nit: we don't use space after the type cast.

> +	futex_pos = !IS_ALIGNED((unsigned long)uaddr, sizeof(u64));
> +	other_pos = !futex_pos;
> +
> +	oval64.futex[futex_pos] = oldval;
> +	ret = get_user(oval64.futex[other_pos], (u32 __user *)uaddr64 + other_pos);
> +	if (ret)
> +		return -EFAULT;
> +
> +	ret = -EAGAIN;
> +	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {

I was wondering if we still need the FUTEX_MAX_LOOPS bound with LSUI. I
guess with CAS we can have some malicious user that keeps updating the
futex location or the adjacent one on another CPU. However, I think we'd
need to differentiate between futex_atomic_cmpxchg_inatomic() use and
the eor case.

> +		orig64.raw = nval64.raw = oval64.raw;
> +
> +		nval64.futex[futex_pos] = newval;

I'd keep orig64.raw = oval64.raw and set the nval64 separately (I find
it clearer, not sure the compiler cares much):

		nval64.futex[futex_pos] = newval;
		nval64.futex[other_pos] = oval64.futex[other_pos];

> +
> +		if (__lsui_cmpxchg64(uaddr64, &oval64.raw, nval64.raw))
> +			return -EFAULT;
> +
> +		oldval = oval64.futex[futex_pos];
> +		other = oval64.futex[other_pos];
> +		orig_other = orig64.futex[other_pos];
> +
> +		if (other == orig_other) {
> +			ret = 0;
> +			break;
> +		}

Is this check correct? What if the cmpxchg64 failed because futex_pos
was changed but other_pos remained the same, it will just report success
here. You need to compare the full 64-bit value to ensure the cmpxchg64
succeeded.

> +	}
> +
> +	if (!ret)
> +		*oval = oldval;
> +
> +	return ret;
> +}
> +
> +static __always_inline int
> +__lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
> +{
> +	/*
> +	 * Undo the bitwise negation applied to the oparg passed from
> +	 * arch_futex_atomic_op_inuser() with FUTEX_OP_ANDN.
> +	 */
> +	return __lsui_futex_atomic_andnot(~oparg, uaddr, oval);
> +}
> +
> +static __always_inline int
> +__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
> +{
> +	u32 oldval, newval, val;
> +	int ret, i;
> +
> +	if (get_user(oldval, uaddr))
> +		return -EFAULT;
> +
> +	/*
> +	 * there are no ldteor/stteor instructions...
> +	 */
> +	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {
> +		newval = oldval ^ oparg;
> +
> +		ret = __lsui_cmpxchg32(uaddr, oldval, newval, &val);

Since we have a FUTEX_MAX_LOOPS here, do we need it in cmpxchg32 as
well?

For eor, we need a loop irrespective of whether futex_pos or other_pos
have changed. For cmpxchg, we need the loop only if other_pos has
changed and return -EAGAIN if futex_pos has changed since the caller
needs to update oldval and call again.

So try to differentiate these cases, maybe only keep the loop outside
cmpxchg32 (I haven't put much though into it).

> +		if (ret)
> +			return ret;
> +
> +		if (val == oldval) {
> +			*oval = val;
> +			return 0;
> +		}

I can see you are adding another check here for the actual value which
solves the other_pos comparison earlier but that's only for eor and not
the __lsui_futex_cmpxchg() case.

> +
> +		oldval = val;
> +	}
> +
> +	return -EAGAIN;
> +}
> +
> +static __always_inline int
> +__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> +{
> +	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
> +}
> +#endif	/* CONFIG_ARM64_LSUI */

-- 
Catalin
