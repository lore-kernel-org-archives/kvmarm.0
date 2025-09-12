Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA09258ED9;
	Fri, 12 Sep 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757696495; cv=none; b=uAdgYcu8plncqWQJpLbxauWY0tvc4Nehmp1JQ1d3yRKrni6XsImjeI/72M/ZWvvdfWfOmfxkojgvZ5nDV+/foe8wHU/TweLp4Fik/TAEe36Ehcnl+u1irmh1n+id//p9LCN0k//qhvhzULueFXZF921bDxQkV6ChEdpFc5zD8dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757696495; c=relaxed/simple;
	bh=GDXBmCH206GGprNNPTiOugVZFynZifc0T69jzDP9fUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+qX7slx5b2ZAA9gKp6PNOsTDfWqKAvjeN39fUPSy7jCiMy51QRfYz7vVZieiEQlWxMOqY2fsj2p8973zolHiXYqeUVT2FRDiGB4D/iun88C1SHzZkrepxzaA9yVidoKyW4yn0Vb4RbyZdtpEmkrwTwyORFjI7w4sKV1wie3y4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FE7C4CEF1;
	Fri, 12 Sep 2025 17:01:32 +0000 (UTC)
Date: Fri, 12 Sep 2025 18:01:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMRR6nzqRrFGPTsN@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRN3z3WNRGuwBgQ@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMRN3z3WNRGuwBgQ@arm.com>

On Fri, Sep 12, 2025 at 05:44:15PM +0100, Catalin Marinas wrote:
> On Sat, Aug 16, 2025 at 04:19:27PM +0100, Yeoreum Yun wrote:
> > +#define FUTEX_ATOMIC_OP(op)						\
> > +static __always_inline int						\
> > +__futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)		\
> > +{									\
> > +	return __llsc_futex_atomic_##op(oparg, uaddr, oval);		\
> > +}
> > +
> > +FUTEX_ATOMIC_OP(add)
> > +FUTEX_ATOMIC_OP(or)
> > +FUTEX_ATOMIC_OP(and)
> > +FUTEX_ATOMIC_OP(eor)
> > +FUTEX_ATOMIC_OP(set)
> > +
> > +static __always_inline int
> > +__futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > +{
> > +	return __llsc_futex_cmpxchg(uaddr, oldval, newval, oval);
> > +}
> 
> The patch looks fine and my impression that the __futex_* functions will
> be used in patch 6 to dispatch between lsui and llsc. But you got them
> the other way around. I'll comment there.

Ah, ignore me, I misread patch 6. It looks good.

> For this patch:
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
