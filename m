Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F654C601
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 20:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707768885; cv=none; b=gfPMR/h0fvKdXFhAeFFbqQ0wxSLgjy00WLHld8IXSx3F2obl0i649M9Zp/OVHVyeytxP0O3cDwFjKEPDSg5Bw3tAEkE7tEcUi9GRaNgMfCWTymxky2lQ9OuL7u4nN2zlxF8T+mms0CM5Upmry+w4aLfEOhvPcZ6bvtTTut8X1yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707768885; c=relaxed/simple;
	bh=pM+JwIpEhS4K66fk0hub7cdKHekvQSrc3X6VYgClJgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZOnyldbJYMVHRYrZoxfeTUa2vbRoEQwBBsdgN9DZFyWLbvaxXpFMYDHQuEy6Fs4ih7njdnm0brcPCCN1szdTQevuk1K6gsAXmD3HxtlN8pEnlVOrqYtpKZ+J32sl/dbcw4dWRV3QI4CA0jDusoMysaTx28dO1qd1mlNG7ywsCyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E7WP7Tud; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E7WP7Tud"
Date: Mon, 12 Feb 2024 20:14:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707768881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jB6lm62DkG62rqMTYd6eJaWPvnP+AAaRdrvKn0LsuG4=;
	b=E7WP7TudAWDuX/Ylql0OZ0KhRkLPhK6IXL+TZpzCPqtTJWDHcDM7uArNyMKfZdKsKzBdo3
	CoTUrrTt78lNuCY1M/7DWdd50K+WUnam2PwOiMsb5+OxsAGX+FWB6NdVIV0bGwCLbbhnWe
	WKpu0G1iGNQGkGx2h4Cu+Faewh8N00c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Ricardo Koller <ricarkol@google.com>
Subject: Re: [RFC PATCH] KVM: arm64: Fix double-free following
 kvm_pgtable_stage2_free_unlinked()
Message-ID: <Zcp8LcvsZiZVkNKe@linux.dev>
References: <20240212193052.27765-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240212193052.27765-1-will@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 12, 2024 at 07:30:52PM +0000, Will Deacon wrote:
> kvm_pgtable_stage2_free_unlinked() does the final put_page() on the
> root page of the sub-tree before returning, so remove the additional
> put_page() invocations in the callers.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
> 
> Hi folks,
> 
> Sending this as an RFC as I only spotted it from code inspection and I'm
> surprised others aren't seeing fireworks if it's a genuine bug. I also
> couldn't come up with a sensible Fixes tag, as all of:
> 
>  e7c05540c694b ("KVM: arm64: Add helper for creating unlinked stage2 subtrees")
>  8f5a3eb7513fc ("KVM: arm64: Add kvm_pgtable_stage2_split()")
>  f6a27d6dc51b2 ("KVM: arm64: Drop last page ref in kvm_pgtable_stage2_free_removed()")
> 
> are actually ok in isolation. Hrm. Please tell me I'm wrong?
> 
>  arch/arm64/kvm/hyp/pgtable.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c651df904fe3..ab9d05fcf98b 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1419,7 +1419,6 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>  				 level + 1);
>  	if (ret) {
>  		kvm_pgtable_stage2_free_unlinked(mm_ops, pgtable, level);
> -		mm_ops->put_page(pgtable);
>  		return ERR_PTR(ret);
>  	}

AFAICT, this entire branch is effectively dead code, unless there's a
KVM bug lurking behind the page table walk. The sub-tree isn't visible
to other software or hardware walkers yet, so none of the PTE races
could cause this to pop.

So while this is very obviously a bug, it might be pure luck that folks
haven't seen smoke here. Perhaps while fixing the bug we should take the
opportunity to promote the condition to WARN_ON_ONCE().

> @@ -1502,7 +1501,6 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  
>  	if (!stage2_try_break_pte(ctx, mmu)) {
>  		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
> -		mm_ops->put_page(childp);
>  		return -EAGAIN;
>  	}

This, on the other hand, seems possible. There exists a race where an
old block PTE could have the AF set on it and the underlying cmpxchg()
could fail. There shouldn't be a race with any software walkers, as we
hold the MMU lock for write here.

-- 
Thanks,
Oliver
