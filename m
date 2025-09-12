Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2489523D7FB;
	Fri, 12 Sep 2025 17:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757697375; cv=none; b=a1npiLTF5xJy0RY/g1Pd9aSywnWZbdGOvSVmAXEIfmkpC0z7F83UOd6Gc25ixzwDbyOHgtgALYP3kwudSZUM9LQQFeMkqGBrX0qsPt1pidA357k2BRY+oy2d7/u6q2U5yp7FrftojzAu+DZQFusTlLOIb5x4/8kYsMMtsqFlBtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757697375; c=relaxed/simple;
	bh=APqFZotspuu2XL9PLZpEyk5snfgcO+bmGNbHs452ndE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nosQSMnpcdRgopLezL6gFPMCd3Yb3/EFHeLJLk2W1qWJ04PoQn65D+QmFhuaYAw8TA3ZmWcvKrRmR3P55e9VezmgkYBGeT2zbkyWhj/JwizzZNhtuGgd4iV3q4XW5gXfGAlOZRI+IKHmO6w1f/VtGxReYnzLwe0vJBfWuvMqgHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BC4C4CEF1;
	Fri, 12 Sep 2025 17:16:11 +0000 (UTC)
Date: Fri, 12 Sep 2025 18:16:09 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 6/6] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aMRVWRldi0wJqBpD@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-7-yeoreum.yun@arm.com>
 <aMLpMBWtHDI9sPHK@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMLpMBWtHDI9sPHK@willie-the-truck>

On Thu, Sep 11, 2025 at 04:22:24PM +0100, Will Deacon wrote:
> On Sat, Aug 16, 2025 at 04:19:29PM +0100, Yeoreum Yun wrote:
> > +static __always_inline int
> > +__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
> > +{
> > +	unsigned int loops = LLSC_MAX_LOOPS;
> > +	int ret, oldval, tmp;
> > +
> > +	uaccess_ttbr0_enable();
> > +	/*
> > +	 * there are no ldteor/stteor instructions...
> > +	 */
> 
> *sigh*
> 
> Were these new instructions not added with futex in mind?

I guess it was _most_ of the futex.

> I wonder whether CAS would be better than exclusives for xor...

I was first thinking we could share some of the code with
__futex_cmpxchg() but...

> > +static __always_inline int
> > +__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > +{
> > +	int ret = 0;
> > +	unsigned int loops = LLSC_MAX_LOOPS;
> > +	u32 val, tmp;
> > +
> > +	uaccess_ttbr0_enable();
> > +	/*
> > +	 * cas{al}t doesn't support word size...
> > +	 */
> 
> What about just aligning down and doing a 64-bit cas in that case?

I think it gets more complicated. Here we get the oldval from the
caller, so no need to do a read. With CAS, we'd need to read the full
64-bit, replace half of it with oldval and newval just to be able to do
the operation. On top of this, we need to check which half of the 64-bit
value. I think it to hairy for little benefit.

-- 
Catalin
