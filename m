Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D9421353
	for <kvmarm@lists.linux.dev>; Tue, 26 Mar 2024 08:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711442067; cv=none; b=efeaj0cdzDr3qsc1+Hg2SFH/GfDYlmiYgdqwOYVNzw9hjGMcpaGBzyRWYLrbn+kHw9BbFWNcTVdAGuARMJxj2VC3JNLyzYNX2EpJGbNhyidJfsQZHuiJcR4bzCi7ppyuMxvh14pe/3y7M/RKqOLLogPMXOIPHI9rIy38VAi8SmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711442067; c=relaxed/simple;
	bh=flxk4m6JSt3pxxcIddnfswfAnLGdcwgqkAa4FWF+B7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FtWVOqIqnsX0avX+TttNhLnC+7tVvIuD6tiGR9dsB++DzVTeiAuEVhNf+pz3NKvM7IH+5OZZqV2+gkSpv2htfj6/wxipxbySqBdUW7Nqcin9EKNB1sIKQ2ZvOmwrcAcz9PYLwROjzQKOVZslaFKlbSxdavZItp8jxRwFX7FeInA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=USXG375V; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="USXG375V"
Date: Tue, 26 Mar 2024 01:34:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711442062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a5Qd+NuqhOMxkePHM7IZmqHPBd6oxS5Xxd9L3bfHHfY=;
	b=USXG375Vv8L3dUSSTZ8DW/Q1PMHqssfPfdtzbygRL9hSHys72/eP0YL+TFLqhz6A43lvcq
	uAqURNDGbwpwmo5LZtDqCKF6Nv3cWJhCoMDGjHe/s64oMXxkR6tcuKROQ67IwGS9wzv8aF
	lrAQlYLR4QIScvxWKjozlZrBVC/QTxc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
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
Message-ID: <ZgKIides0YAA2j5Y@linux.dev>
References: <20240325185158.8565-1-will@kernel.org>
 <20240325185158.8565-2-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325185158.8565-2-will@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Will,

On Mon, Mar 25, 2024 at 06:51:56PM +0000, Will Deacon wrote:
> Commit 7657ea920c54 ("KVM: arm64: Use TLBI range-based instructions for
> unmap") introduced deferred TLB invalidation for the stage-2 page-table
> so that range-based invalidation can be used for the accumulated
> addresses. This works fine if the structure of the page-tables remains
> unchanged, but if entire tables are zapped and subsequently freed then
> we transiently leave the hardware page-table walker with a reference
> to freed memory thanks to the translation walk caches.

Yikes! Well spotted. This is rather unfortunate because the unmap path
has been found to be a massive pain w/o aggregating invalidations. But
sacrificing correctness in the name of performance... No thanks :)

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 3fae5830f8d2..de0b667ba296 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -896,9 +896,11 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
>  	if (kvm_pte_valid(ctx->old)) {
>  		kvm_clear_pte(ctx->ptep);
>  
> -		if (!stage2_unmap_defer_tlb_flush(pgt))
> +		if (!stage2_unmap_defer_tlb_flush(pgt) ||
> +		    kvm_pte_table(ctx->old, ctx->level)) {
>  			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
>  					ctx->addr, ctx->level);
> +		}

I'm not sure this is correct, though. My understanding of TTL is that
we're telling hardware where the *leaf* entry we're invalidating is
found, however here we know that the addressed PTE is a table entry.

So maybe in the case of a table PTE this invalidation should
TLBI_TTL_UNKNOWN.

>  	}
>  
>  	mm_ops->put_page(ctx->ptep);

At least for the 'normal' MMU where we use RCU, this could be changed to
->free_unlinked_table() which would defer the freeing of memory til
after the invalidation completes. But that still hoses pKVM's stage-2
MMU freeing in-place.

-- 
Thanks,
Oliver
