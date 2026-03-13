Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B69C3A6B86
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773412945; cv=none; b=AR0rp8lMPmCt+g/8SyN400w0aOTZVSpRco2MfVf2FFbt2+KVLO7s8mW1gnrJYSpivhFjKt8FxAt1UEEUpbINM9GmwphAxZhPfC5kTu2HrLdX2DB9eEcpRkKX8XmgMYy/msCaScxvLqdSPHreB6TNZaf6uHkHx4Gb1ZSz/5dMv6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773412945; c=relaxed/simple;
	bh=9amcathOnSuA9o0wdffWhIzxuO1Tcw+QsTIsAnvrXUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tp8IKkIKbNjQpvY0R3b5M0Sl+dChRtjRX1Bve024XLkQ4NJZTB8YWzNATX5gE8qKDV8HgGpgGu+vD4nkWN84EMY6Z0on7z3YEa4nhyc98R982phrQFZ0KfWfp8BiwyKtpHYoR//fhJYd6mE1BGqwB/Clgbk2ygVMR4Er3pC1Ma8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87823165C;
	Fri, 13 Mar 2026 07:42:17 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B60C3F7BD;
	Fri, 13 Mar 2026 07:42:21 -0700 (PDT)
Date: Fri, 13 Mar 2026 14:42:18 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v15 5/8] arm64: futex: support futex with FEAT_LSUI
Message-ID: <abQiSiX_xxjSY96-@arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
 <20260227151705.1275328-6-yeoreum.yun@arm.com>
 <abMDOC5DYEm74And@arm.com>
 <abPXrvl9tC+nv6q9@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abPXrvl9tC+nv6q9@e129823.arm.com>

On Fri, Mar 13, 2026 at 09:23:58AM +0000, Yeoreum Yun wrote:
> > On Fri, Feb 27, 2026 at 03:17:02PM +0000, Yeoreum Yun wrote:
> > > +
> > > +		if (__lsui_cmpxchg64(uaddr64, &oval64.raw, nval64.raw))
> > > +			return -EFAULT;
> > > +
> > > +		oldval = oval64.futex[futex_pos];
> > > +		other = oval64.futex[other_pos];
> > > +		orig_other = orig64.futex[other_pos];
> > > +
> > > +		if (other == orig_other) {
> > > +			ret = 0;
> > > +			break;
> > > +		}
> >
> > Is this check correct? What if the cmpxchg64 failed because futex_pos
> > was changed but other_pos remained the same, it will just report success
> > here. You need to compare the full 64-bit value to ensure the cmpxchg64
> > succeeded.
> 
> This is not matter since "futex_cmpxchg_value_locked()" checks
> the "curval" and "oldval" IOW, though it returns success,
> caller of this function always checks the "curval" and "oldval"
> and when it's different, It handles to change return as -EAGAIN.

Ah, ok, it makes sense (I did not check the callers).

> > > +	}
> > > +
> > > +	if (!ret)
> > > +		*oval = oldval;
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static __always_inline int
> > > +__lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
> > > +{
> > > +	/*
> > > +	 * Undo the bitwise negation applied to the oparg passed from
> > > +	 * arch_futex_atomic_op_inuser() with FUTEX_OP_ANDN.
> > > +	 */
> > > +	return __lsui_futex_atomic_andnot(~oparg, uaddr, oval);
> > > +}
> > > +
> > > +static __always_inline int
> > > +__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
> > > +{
> > > +	u32 oldval, newval, val;
> > > +	int ret, i;
> > > +
> > > +	if (get_user(oldval, uaddr))
> > > +		return -EFAULT;
> > > +
> > > +	/*
> > > +	 * there are no ldteor/stteor instructions...
> > > +	 */
> > > +	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {
> > > +		newval = oldval ^ oparg;
> > > +
> > > +		ret = __lsui_cmpxchg32(uaddr, oldval, newval, &val);
> >
> > Since we have a FUTEX_MAX_LOOPS here, do we need it in cmpxchg32 as
> > well?
> >
> > For eor, we need a loop irrespective of whether futex_pos or other_pos
> > have changed. For cmpxchg, we need the loop only if other_pos has
> > changed and return -EAGAIN if futex_pos has changed since the caller
> > needs to update oldval and call again.
> >
> > So try to differentiate these cases, maybe only keep the loop outside
> > cmpxchg32 (I haven't put much though into it).
> 
> I think we can remove loops on __lsui_cmpxchg32() and return -EAGAIN
> when other_pos is different. the __lsui_cmpxchg32() will be called
> "futex_cmpxchg_value_locked()" and as I said, this always checks
> whether curval & oldval when it successed.

Yes, I think for the futex_cmpxchg_value_locked(), the bounded loop
doesn't matter since the core would invoke it back on -EAGAIN. It's nice
not to fail if the actual futex did not change but in practice it
doesn't make any difference and I'd rather keep the code simple.

> But in "eor" when it receive "-EAGAIN" from __lsui_cmxchg32()
> we can simply continue the loop.

Yes, for eor we need the bounded loop. Only return -EAGAIN to the user
if we finished the loop and either __lsui_cmpxchg32() returned -EAGAIN
or the updated on futex_pos failed.

Thanks.

-- 
Catalin
