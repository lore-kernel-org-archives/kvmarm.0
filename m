Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F40C365A1E
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 11:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772795740; cv=none; b=E9/JkwKy91b1cLTrRAkM5AEq6t+/BSlQdH5n9zXd19J6jar+OkdUHexPREGSPHNl8j3/22aqQ0tvFdDCdmmwF/7TiyF+LP/rMqfdX+0KLDcTmw9iuPhEI1IbJzyFlZ5GJa7Tv2QNslUf6CUbipFZJUxiAEYQvcONHcKzofhnvCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772795740; c=relaxed/simple;
	bh=qnF3zT9yVbh5XNCyJc0W7dzO9SINg69qu6Umi0BJ6Js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g4zYoFFwLkpj/iZwlTTuxvs+x31G5NaaRt2Wc27dZjs4Hrc9wzcDKRQm1dZrdh/HRBWzrwpAW6TXAb9Im3kdEeO+Uu2HvuCzxcrzQgx5/DILGBmDzzCx8p4OrLae1NeCEKPN4KPdbKfdHZf9U1JFuZ8OcBTodc81a0eS3KR630Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D08F497;
	Fri,  6 Mar 2026 03:15:32 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5E403F836;
	Fri,  6 Mar 2026 03:15:36 -0800 (PST)
Date: Fri, 6 Mar 2026 11:15:34 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/4] arm64: tlb: Pass the corresponding mm to
 __tlbi_sync_s1ish()
Message-ID: <aaq3Vun0ZSSdXyXV@arm.com>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-3-catalin.marinas@arm.com>
 <aamULrOkm8jd_9UY@willie-the-truck>
 <aanXM7YWMAJW6qk7@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aanXM7YWMAJW6qk7@arm.com>

On Thu, Mar 05, 2026 at 07:19:15PM +0000, Catalin Marinas wrote:
> On Thu, Mar 05, 2026 at 02:33:18PM +0000, Will Deacon wrote:
> > On Mon, Mar 02, 2026 at 04:57:55PM +0000, Catalin Marinas wrote:
> > > @@ -391,7 +391,7 @@ static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
> > >   */
> > >  static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
> > >  {
> > > -	__tlbi_sync_s1ish();
> > > +	__tlbi_sync_s1ish(NULL);
> > 
> > Hmm, it seems a bit rubbish to pass NULL here as that means that we'll
> > deploy the mitigation regardless of the mm flags when finishing the
> > batch.
> > 
> > It also looks like we could end up doing the workaround multiple times
> > if arch_tlbbatch_add_pending() is passed a large enough region that we
> > call __flush_tlb_range_limit_excess() fires.
> > 
> > So perhaps we should stash the mm in 'struct arch_tlbflush_unmap_batch'
> > alongside some state to track whether or not we have uncompleted TLB
> > maintenance in flight?
> 
> The problem is that arch_tlbbatch_flush() can be called to synchronise
> multiple mm structures that were touched by TTU. We can't have the mm in
> arch_tlbflush_unmap_batch. But we can track if any of the mms had
> MMCF_SME_DVMSYNC flag set, something like below (needs testing, tidying
> up). TBH, I did not notice any problem in benchmarking as I guess we
> haven't exercised the TTU path much, so did not bother to optimise it.
> 
> For the TTU case, I don't think we need to worry about the excess limit
> and doing the IPI twice. But I'll double check the code paths tomorrow.
> 
> diff --git a/arch/arm64/include/asm/tlbbatch.h b/arch/arm64/include/asm/tlbbatch.h
> index fedb0b87b8db..e756eaca6cb8 100644
> --- a/arch/arm64/include/asm/tlbbatch.h
> +++ b/arch/arm64/include/asm/tlbbatch.h
> @@ -7,6 +7,8 @@ struct arch_tlbflush_unmap_batch {
>  	 * For arm64, HW can do tlb shootdown, so we don't
>  	 * need to record cpumask for sending IPI
>  	 */
> +
> +	bool sme_dvmsync;
>  };
> 
>  #endif /* _ARCH_ARM64_TLBBATCH_H */
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index e3ea0246a4f4..c1141a684854 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -201,10 +201,15 @@ do {										\
>   * Complete broadcast TLB maintenance issued by the host which invalidates
>   * stage 1 information in the host's own translation regime.
>   */
> -static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
> +static inline void __tlbi_sync_s1ish_no_sme_dvmsync(void)
>  {
>  	dsb(ish);
>  	__repeat_tlbi_sync(vale1is, 0);
> +}
> +
> +static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
> +{
> +	__tlbi_sync_s1ish_no_sme_dvmsync();
>  	sme_dvmsync(mm);
>  }
> 
> @@ -408,7 +413,11 @@ static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
>   */
>  static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
>  {
> -	__tlbi_sync_s1ish(NULL);
> +	__tlbi_sync_s1ish_no_sme_dvmsync();
> +	if (batch->sme_dvmsync) {
> +		batch->sme_dvmsync = false;
> +		sme_dvmsync(NULL);
> +	}
>  }
> 
>  /*
> @@ -613,6 +622,8 @@ static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *b
>  		struct mm_struct *mm, unsigned long start, unsigned long end)
>  {
>  	__flush_tlb_range_nosync(mm, start, end, PAGE_SIZE, true, 3);
> +	if (test_bit(ilog2(MMCF_SME_DVMSYNC), &mm->context.flags))
> +		batch->sme_dvmsync = true;
>  }

While writing a reply to your other comments, I realised why this
wouldn't work (I had something similar but dropped it) - we can have the
flag cleared here (or mm_cpumask() if we are to track per-mm) but we
have not issued the DVMSync yet. The task may start using SME before
arch_tlbbatch_flush() and we just missed it. Any checks on whether to
issue the IPI like reading flags needs to be after the DVMSync.

Anyway, more on the next patch where you asked about the DMB.

-- 
Catalin
