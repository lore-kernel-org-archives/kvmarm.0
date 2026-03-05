Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364A73A1A59
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721204; cv=none; b=hvoosJ7w2EmIBtygYEshWcilxP+2RIbJR9/x6FXcRWTL/s/Jr/yyRHapnLg2GGJzqXY/l54FDNsJwo8r3F7LqlenZhkkE4x7NpoBtf9TZn/ybPfCoued0fnAa5Nm6TTkYgdfmboFwoBhhPvA427jTxYSEaAjiAIQ09NgZ6stlJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721204; c=relaxed/simple;
	bh=OySpI3JAnSwg1LMlIlUl9oekpXMcX1pam0E670cUMlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OmhJNiJlLSznC7Sk7ha7NgaO/bVNMgEHwCEQ0RKd58iQlqgH4B8t0ArvpLg3QmRhDD9eO/UZZXNlgdqWW/H2ttumgGwy+k5nVRDHQABqP7oohxR1u7/adicKbIxpQEt+FKlMt8QhWH1Dh7PasZCkQmUFXmFOOZQYlHI4xsl65KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UcLlkiAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UcLlkiAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C03C116C6;
	Thu,  5 Mar 2026 14:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721203;
	bh=OySpI3JAnSwg1LMlIlUl9oekpXMcX1pam0E670cUMlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UcLlkiAZydHSIkmBx6iTHRlXL4y3Xwh715dQq62HjfdsJBtNkTt6iw1gg1roh8eeR
	 zG0m0Bo5DOXFm6l/PcEXfObxLrqSkfIeSBHINfFi3zyEvsItPVAgyPqS6oY+z9HMff
	 nvEjSQ/TCsNopnVGNEEOfJI79ulhjopHRontWqiU0CNB4bJpIdoU0V/hsA1uUO3weA
	 lW9VteU9+InuEjGwo0G5K2zNr9qg+Kf1WSSzAdcfKvbeEcX1qmMWD3R8rxqJdRTcJm
	 1w3tD6Ce5WdXCils/R0lC1EE21biRLhnOhjyy5gNzb0yHPNWqacJPN0+o8LXSDX/F3
	 4W1uzIwAT9OOg==
Date: Thu, 5 Mar 2026 14:33:18 +0000
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/4] arm64: tlb: Pass the corresponding mm to
 __tlbi_sync_s1ish()
Message-ID: <aamULrOkm8jd_9UY@willie-the-truck>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-3-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302165801.3014607-3-catalin.marinas@arm.com>

On Mon, Mar 02, 2026 at 04:57:55PM +0000, Catalin Marinas wrote:
> The mm structure will be used for workarounds that need limiting to
> specific tasks.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> ---
>  arch/arm64/include/asm/tlbflush.h | 10 +++++-----
>  arch/arm64/kernel/sys_compat.c    |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index 19be0f7bfca5..14f116bfec73 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -185,7 +185,7 @@ do {										\
>   * Complete broadcast TLB maintenance issued by the host which invalidates
>   * stage 1 information in the host's own translation regime.
>   */
> -static inline void __tlbi_sync_s1ish(void)
> +static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
>  {
>  	dsb(ish);
>  	__repeat_tlbi_sync(vale1is, 0);
> @@ -317,7 +317,7 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
>  	asid = __TLBI_VADDR(0, ASID(mm));
>  	__tlbi(aside1is, asid);
>  	__tlbi_user(aside1is, asid);
> -	__tlbi_sync_s1ish();
> +	__tlbi_sync_s1ish(mm);
>  	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
>  }
>  
> @@ -371,7 +371,7 @@ static inline void flush_tlb_page(struct vm_area_struct *vma,
>  				  unsigned long uaddr)
>  {
>  	flush_tlb_page_nosync(vma, uaddr);
> -	__tlbi_sync_s1ish();
> +	__tlbi_sync_s1ish(vma->vm_mm);
>  }
>  
>  static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
> @@ -391,7 +391,7 @@ static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
>   */
>  static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
>  {
> -	__tlbi_sync_s1ish();
> +	__tlbi_sync_s1ish(NULL);

Hmm, it seems a bit rubbish to pass NULL here as that means that we'll
deploy the mitigation regardless of the mm flags when finishing the
batch.

It also looks like we could end up doing the workaround multiple times
if arch_tlbbatch_add_pending() is passed a large enough region that we
call __flush_tlb_range_limit_excess() fires.

So perhaps we should stash the mm in 'struct arch_tlbflush_unmap_batch'
alongside some state to track whether or not we have uncompleted TLB
maintenance in flight?

Will
