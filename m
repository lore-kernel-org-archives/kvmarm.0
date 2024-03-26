Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BE113C696
	for <kvmarm@lists.linux.dev>; Tue, 26 Mar 2024 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711469407; cv=none; b=lopT4AceHCCoQymCvGXF5wQ/TujvVxRlu08dFqfXMB2d1kMXxLEa3kY5CwIUq9DzgGh8NCjSoptRE5/SiPMHGmxsrIaFMv50cN9d8Pu4RtKZYVRPX4xDKvuWqMQcrPJ+oW02FbrlCvKv8ZKG+vWb7grUgwWqrcM4ZMLWKvqu0kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711469407; c=relaxed/simple;
	bh=yIc1T3rbGBsJt2JIZmWDELw5PA9dbbkZaW489v6thG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dK0S5ycjExjTkHLPXFTY9R9MBNEF0Skt/j7ni6KYgvwhm2+tAZ8le8dEZNrCLbJVaqE/YAFe/gnyXJBLrtuFZWINLTHGvyUYF2Sf6AAs15QzuW1jG8Eu5IZ2T79H3Rd1iDspeggPq/utE7rPwnkt+ealXtLehTtI6LCwd+4Rd5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OteM+pLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OteM+pLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1B9C433F1;
	Tue, 26 Mar 2024 16:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711469407;
	bh=yIc1T3rbGBsJt2JIZmWDELw5PA9dbbkZaW489v6thG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OteM+pLW+ZRdxUHq1062qBHLsgCzRYgmSyjd2+ncLEcBFMsIaN64bFy0eesTeL10n
	 YNI1zDwjz19qNWG6GGLq9BSepqIhLpfL7XCl2/EmMPUFai2lzDE+H4OhaMm3cj6i/W
	 /etpuauzFSpRXUqBjo4rZQIRuOurAAKW5xzOzmhtbQNYhDVhko3bD2HTe2M0ARmtQD
	 f7bu+jvgBDDHhBuyJoyHQ62JMtmtuUq3uIouWaV79rrIqsbxrMNnoHDezJLbT5Asqe
	 bRCSFuF/oDQ5eiHPvTtU8+Lq/uNs0zxHAo+FJ5hITbGft3sFcYZKkfc2VHJdYKDzX2
	 BNjjz3UVzYHnA==
Date: Tue, 26 Mar 2024 16:10:01 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Gavin Shan <gshan@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't defer TLB invalidation when
 zapping table entries
Message-ID: <20240326161000.GA9723@willie-the-truck>
References: <20240325185158.8565-1-will@kernel.org>
 <20240325185158.8565-2-will@kernel.org>
 <ZgKIides0YAA2j5Y@linux.dev>
 <ZgLcP9TfMwhfbnEK@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgLcP9TfMwhfbnEK@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 26, 2024 at 07:31:27AM -0700, Oliver Upton wrote:
> On Tue, Mar 26, 2024 at 01:34:17AM -0700, Oliver Upton wrote:
> > >  	}
> > >  
> > >  	mm_ops->put_page(ctx->ptep);
> > 
> > At least for the 'normal' MMU where we use RCU, this could be changed to
> > ->free_unlinked_table() which would defer the freeing of memory til
> > after the invalidation completes. But that still hoses pKVM's stage-2
> > MMU freeing in-place.
> 
> How about this (untested) diff? I _think_ it should address the
> invalidation issue while leaving the performance optimization in place
> for a 'normal' stage-2.
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 3fae5830f8d2..896fdc0d157d 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -872,14 +872,19 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
>  static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
>  {
>  	/*
> -	 * If FEAT_TLBIRANGE is implemented, defer the individual
> -	 * TLB invalidations until the entire walk is finished, and
> -	 * then use the range-based TLBI instructions to do the
> -	 * invalidations. Condition deferred TLB invalidation on the
> -	 * system supporting FWB as the optimization is entirely
> -	 * pointless when the unmap walker needs to perform CMOs.
> +	 * It is possible to use FEAT_TLBIRANGE to do TLB invalidations at the
> +	 * end of the walk if certain conditions are met:
> +	 *
> +	 *  - The stage-2 is for a 'normal' VM (i.e. managed in the kernel
> +	 *    context). RCU provides sufficient guarantees to ensure that all
> +	 *    hardware and software references on the stage-2 page tables are
> +	 *    relinquished before freeing a table page.
> +	 *
> +	 *  - The system supports FEAT_FWB. Otherwise, KVM needs to do CMOs
> +	 *    during the page table table walk.
>  	 */
> -	return system_supports_tlb_range() && stage2_has_fwb(pgt);
> +	return !is_hyp_code() && system_supports_tlb_range() &&
> +		stage2_has_fwb(pgt);
>  }
>  
>  static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
> @@ -1163,7 +1168,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  					       kvm_granule_size(ctx->level));
>  
>  	if (childp)
> -		mm_ops->put_page(childp);
> +		mm_ops->free_unlinked_table(childp, ctx->level);

Hmm, but doesn't the deferred TLBI still happen after the RCU critical
section?

I also think I found another bug, so I'll send a v2 with an extra patch...

Will
