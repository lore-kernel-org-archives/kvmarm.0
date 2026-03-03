Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F277344021
	for <kvmarm@lists.linux.dev>; Tue,  3 Mar 2026 13:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772543581; cv=none; b=JjcultJAUqHmdjHMAGVvqOH+KHT7NnsTtoOVJJ8wu7YC4kqYjQPNOpw9eOxKNrpX2TjJhslmLuVn6j3M8qL/g/xDx9Ss2sBBAUOwMCyJMyWWs9lXy4esNAc0QgZaRcbmnr8hUoDVoq9eoGpIjvXEEhMSKKB50o9KsBBkWCtfIXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772543581; c=relaxed/simple;
	bh=LxGQH987MlEAWkIkQHURZn7yn+tIM9bfVlopXkBLz4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OI6A5sh/04+T7HHrJj2aOr30pUmMQy7xE7VDBnsjBTI0LzmY5vjH55GHk9qqvApqYZHrxWA8Lzn593GvjiG9K4DNTFNwRyGSSvBIayHnbUs11IoORd+NhJQbclxoEcwyFdYyRyeLBblSdorrtU5wJc/SsYjBixizESL9TVMi6Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 584FA497;
	Tue,  3 Mar 2026 05:12:52 -0800 (PST)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1D613F73B;
	Tue,  3 Mar 2026 05:12:56 -0800 (PST)
Date: Tue, 3 Mar 2026 13:12:50 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 1/4] arm64: tlb: Use __tlbi_sync_s1ish_kernel() for
 kernel TLB maintenance
Message-ID: <aabeUlR3QcBg7GmM@J2N7QTR9R3.cambridge.arm.com>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-2-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302165801.3014607-2-catalin.marinas@arm.com>

Hi Catalin,

On Mon, Mar 02, 2026 at 04:57:54PM +0000, Catalin Marinas wrote:
> Add __tlbi_sync_s1ish_kernel() similar to __tlbi_sync_s1ish() and use it
> for kernel TLB maintenance. Also use this function in flush_tlb_all()
> which is only used in relation to kernel mappings. Subsequent patches
> can differentiate between workarounds that apply to user only or both
> user and kernel.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>

This looks fine to me. I have one minor comment/naming nit below, but
this looks functionally correct, and I'm happy to spin a follow-up for
that.

With or without the changes below:

Acked-by: Mark Rutland <mark.rutland@arm.com>

> ---
>  arch/arm64/include/asm/tlbflush.h | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index 1416e652612b..19be0f7bfca5 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -191,6 +191,12 @@ static inline void __tlbi_sync_s1ish(void)
>  	__repeat_tlbi_sync(vale1is, 0);
>  }
>  
> +static inline void __tlbi_sync_s1ish_kernel(void)
> +{
> +	dsb(ish);
> +	__repeat_tlbi_sync(vale1is, 0);
> +}
> +
>  /*
>   * Complete broadcast TLB maintenance issued by hyp code which invalidates
>   * stage 1 translation information in any translation regime.
> @@ -299,7 +305,7 @@ static inline void flush_tlb_all(void)
>  {
>  	dsb(ishst);
>  	__tlbi(vmalle1is);
> -	__tlbi_sync_s1ish();
> +	__tlbi_sync_s1ish_kernel();
>  	isb();
>  }

The commit message is correct that flush_tlb_all() is only used for
kernel mappings today, via flush_tlb_kernel_range(), so this is safe.

However, the big comment block around line 200 says:

	flush_tlb_all()
		Invalidate the entire TLB (kernel + user) on all CPUs

... and:

	local_flush_tlb_all()
		Same as flush_tlb_all(), but only applies to the calling CPU.

... where the latter is used for user mappings (upon ASID overflow), so
I think there's some risk of future confusion.

To minimize the risk that flush_tlb_all() gets used for user mappings in
future, how about we rename flush_tlb_all() => flush_tlb_kernel_all(), and
update those comments:

	flush_tlb_kernel_all()
		Invalidate all kernel mappings on all CPUs.
		Should not be used to invalidate user mappings.

	local_flush_tlb_all()
		Invalidate all (kernel + user) mappings on the calling CPU.

Note: I chose flush_tlb_kernel_all() rather than flush_tlb_all_kernel()
__flush_tlb_kernel_{pgtable,range}, with 'kernel' before the operation/scope.

Thanks,
Mark.

> @@ -568,7 +574,7 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
>  	dsb(ishst);
>  	__flush_tlb_range_op(vaale1is, start, pages, stride, 0,
>  			     TLBI_TTL_UNKNOWN, false, lpa2_is_enabled());
> -	__tlbi_sync_s1ish();
> +	__tlbi_sync_s1ish_kernel();
>  	isb();
>  }
>  
> @@ -582,7 +588,7 @@ static inline void __flush_tlb_kernel_pgtable(unsigned long kaddr)
>  
>  	dsb(ishst);
>  	__tlbi(vaae1is, addr);
> -	__tlbi_sync_s1ish();
> +	__tlbi_sync_s1ish_kernel();
>  	isb();
>  }
>  
