Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2646030ACF9;
	Fri, 12 Sep 2025 16:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757695461; cv=none; b=cxvbNw2c2kDI31QZKBbhUTfc43+pCfrT/3YUKzyCMa73pz53gPrC8kVKhz5xtJG5mcqn8mubtxv+Te5okfL7tgqkibMw3nO7FS9orZShquOV/DDr9P8wHcO+33cvuBxxDxBFv0P0zTN/rk9JZjoe0QIMQf+1LuUHMa1WCC0u/Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757695461; c=relaxed/simple;
	bh=HPmldDCz7zhpWDN7uGs/4kAMsot1fkoRvtKnK1a+TcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZxsOpTsYaDNZ98ic+tewSF3FiM+omflHvdy68OaCPRT+zMhYWchCK4uRURCLM9fVfEwe/Mp8JLsiZuAo2TGSRC6PFzG9Hgt0DsgC1KmY882Cfo+/Ws6ZQMIgf++r88/DpqMjmYAFeLideCi0MY/BUhgFg2CLZN8/DvCgFBN7KNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147A9C4CEF1;
	Fri, 12 Sep 2025 16:44:17 +0000 (UTC)
Date: Fri, 12 Sep 2025 17:44:15 +0100
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
Message-ID: <aMRN3z3WNRGuwBgQ@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816151929.197589-5-yeoreum.yun@arm.com>

On Sat, Aug 16, 2025 at 04:19:27PM +0100, Yeoreum Yun wrote:
> +#define FUTEX_ATOMIC_OP(op)						\
> +static __always_inline int						\
> +__futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)		\
> +{									\
> +	return __llsc_futex_atomic_##op(oparg, uaddr, oval);		\
> +}
> +
> +FUTEX_ATOMIC_OP(add)
> +FUTEX_ATOMIC_OP(or)
> +FUTEX_ATOMIC_OP(and)
> +FUTEX_ATOMIC_OP(eor)
> +FUTEX_ATOMIC_OP(set)
> +
> +static __always_inline int
> +__futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> +{
> +	return __llsc_futex_cmpxchg(uaddr, oldval, newval, oval);
> +}

The patch looks fine and my impression that the __futex_* functions will
be used in patch 6 to dispatch between lsui and llsc. But you got them
the other way around. I'll comment there. For this patch:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
