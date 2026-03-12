Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF7037B00E
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773327254; cv=none; b=SZA5HW+/Yqgx4daRZyxthoaJW7gf32iCuUsGCPrQL+dKM+iqpRJR7WM/XhDozkppRiFGjW8Ci4ek5lc9yEwvL7Z0YVH+XytWF6Hnjq1tC5ujytrFQRPRjkFFBXI98dhSdJ0ytY6Uj4TJjRZwLWlEvQmcHGcd6q+YypkrU8FK1jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773327254; c=relaxed/simple;
	bh=xxLOrONxRT3JGVLsmcC6b0ejVRt0gBwgcDzh78cwGXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tkqQ8ubR3pGavBoDLpOzq18eUQKpOuLxdxAs3dEDyneasSIXxTzWVHqTegolMgkBezKLbyVAHw9onur+IMt8Cn21ZH16JJzY+SE9o/8Ob8POaakOLWQNN0OFtJS/v3nIrQ+N+YhHhL+N2J6MKj9KP8mdZH+KFWygCVNc6qrPkZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96F68165C;
	Thu, 12 Mar 2026 07:54:05 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4AFE73F7BD;
	Thu, 12 Mar 2026 07:54:09 -0700 (PDT)
Date: Thu, 12 Mar 2026 14:54:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v15 4/8] arm64: futex: refactor futex atomic operation
Message-ID: <abLTji8bbO3b3i3r@arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
 <20260227151705.1275328-5-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227151705.1275328-5-yeoreum.yun@arm.com>

On Fri, Feb 27, 2026 at 03:17:01PM +0000, Yeoreum Yun wrote:
> -#define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
> -do {									\
> +#define LLSC_FUTEX_ATOMIC_OP(op, insn)					\
> +static __always_inline int						\
> +__llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> +{									\
>  	unsigned int loops = FUTEX_MAX_LOOPS;				\
> +	int ret, oldval, newval;					\
>  									\
>  	uaccess_enable_privileged();					\
> -	asm volatile(							\
> +	asm volatile("// __llsc_futex_atomic_" #op "\n"			\
>  "	prfm	pstl1strm, %2\n"					\
> -"1:	ldxr	%w1, %2\n"						\
> +"1:	ldxr	%w[oldval], %2\n"					\
>  	insn "\n"							\
> -"2:	stlxr	%w0, %w3, %2\n"						\
> +"2:	stlxr	%w0, %w[newval], %2\n"					\

Looking again at this as I originally reviewed the series without the
positional operands.

Can you not use only named operands instead of mixing them? The same
comment for all other asm changes in this file.

-- 
Catalin
