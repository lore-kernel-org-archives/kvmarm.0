Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9DB330668;
	Fri, 17 Jul 2026 20:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784321767; cv=none; b=jCOle1MxDYVpTtqpHaGrVaTwMrGNEOgGQN+3NzADx0FVHWDdFFYCV9VSxxKlDiMU4Wmfjl32ArTZ6M4+Q+DlETB8D/+/oRn8P+87r1I72lxe3U7qMcA6e6wYVw8AhXyU07TJkbmH3HStc6GlqVVZhJ66eHWX1O1/90jZ+zDq2Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784321767; c=relaxed/simple;
	bh=9lz/zL8470hEbZErrlToyCTQ+zDoMBLIq6oQJAe2Xv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HXYWmg4XRAEIIXZohrzm8yOl4BiqBdMuTcyUcBbl8oblRgBm3U3Y7S+a6+j+bGOkna8cUX3fgkfTjpBt/tOTUjY6LeoLLb+FMjxxIelM4Bca3snrIlPDFTwWJelelxyAGnfia4EGhGPuMCK3//yKMZ2+htFI85RqPVEcBF6cilk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DpUbxi5w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DpUbxi5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4F21F000E9;
	Fri, 17 Jul 2026 20:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784321765;
	bh=W4ktFL4oH9ldaHz/Q/tS5unjDRgWUUYeFG95R6a98rM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DpUbxi5wsgZ1+KTYV8FHVj1DoWv4MLJLX0K1+N4yOp8CVIO6WhaJ4dSywKYIFlscs
	 hxJjPFG4A7Vy2CqMETl6XVxWLEE7HbBVDVnUYJm7CT6T71fGq/eB/15kNRB6Dp6JwO
	 +Ctt4RwYHxDbswtcTLzP8ZQK8I73x5P6mPIiGizTYJ4ZBf2CN6VabxeqmYj/nc4iaN
	 LCLWKJNU+pLwve8RMBQARYpwZsfSraoXHvmfPxb8FscpUyMLem12Ib/0SOsbpq8goQ
	 PyywC89m2Z7xt8ASOWVIli+dBmpk4e583kHO51PqdGP21FQtNfKRaFxFbG7BdyU2Nz
	 arT+AhV4bbvPg==
Date: Fri, 17 Jul 2026 13:56:03 -0700
From: Oliver Upton <oupton@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	vdonnefort@google.com, tabba@google.com
Subject: Re: [RFC PATCH 2/2] KVM: arm64: Support BBM level 3
Message-ID: <alqW49CH7eViDpAZ@kernel.org>
References: <20260717130901.2239134-1-smostafa@google.com>
 <20260717130901.2239134-3-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717130901.2239134-3-smostafa@google.com>

Hi Mostafa,

On Fri, Jul 17, 2026 at 01:09:00PM +0000, Mostafa Saleh wrote:
> If the system supports hardware Break-Before-Make (BBM) level 3, use it
> to replace stage-2 PTEs directly instead of falling back to the software
> break-before-make sequence.
> 
> 1) Get a reference count on the containing table for the new PTE.
> 2) Atomically update the PTE with the new valid descriptor.
> 3) Invalidate the TLB for the old PTE.
> 4) Drop the reference count holding the old PTE.
> 
> One interesting case, as BBML3 will update the PTE atomically, it
> can only know it raced with another core at the point of the cmpxchg
> failing, unlike the SW implementation which locks the PTE first.
> And as we must issue CMOs to the new mapped page before the update,
> that means with BBML3 racing cores will issue redundant CMOs,

I'd rather we just predicate BBML3-style transformations on an
implementation having FEAT_S2FWB and DIC. You can definitely come along
later and enable it when using a stage-2 in an SMMU makes this
mandatory, possibly at the expense of some extra CMOs.

There's also an extremely subtle detail that BBML3 enablement relies on,
which is that KVM will never change the OA of active translation. IOW,
if the host is moving the PFN we expect an invalidation before
re-mapping it.

I have no issue with relying on that behavior but we should make that
assumption abundantly clear.

One of the things on my wish list for a while has been rebuilding
hugepages after dirty logging is disabled on a memslot. That seems like
like a very good optimization to do when BBML3 is present.

> to improve this:
> - We only use BBML3 if the old PTE was live.
> - To reduce the window of the race, an early check is added before
>   the CMO to exit early, but that does not eliminate the race.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 53 +++++++++++++++++++++++++++++++-----
>  1 file changed, 46 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 127b7f9541b1..69d52308236f 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -838,7 +838,8 @@ static void stage2_clean_old_pte(const struct kvm_pgtable_visit_ctx *ctx,
>  /**
>   * stage2_try_break_pte() - Invalidates a pte according to the
>   *			    'break-before-make' requirements of the
> - *			    architecture.
> + *			    architecture, if BMML3 is supported it
> + *			    will be used, otherwise fallback to SW.
>   *
>   * @ctx: context of the visited pte.
>   * @mmu: stage-2 mmu
> @@ -854,6 +855,18 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
>  {
>  	kvm_pte_t locked_pte;
>  
> +	if (system_supports_bbml3() && kvm_pte_valid(ctx->old)) {
> +		kvm_pte_t curr_pte = READ_ONCE(*ctx->ptep);
> +
> +		/*
> +		 * All handled in stage2_make_pte(). However exit early if we already
> +		 * lost the race to avoid extra CMOs.
> +		 */
> +		 if (curr_pte != ctx->old)
> +			return false;

Does this race detection actually move the needle? We haven't gotten
very far from the read in __kvm_pgtable_visit().

Thanks,
Oliver
