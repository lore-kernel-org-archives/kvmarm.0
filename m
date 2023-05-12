Received: from out-36.mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4A8200AE
	for <kvmarm@lists.linux.dev>; Fri, 12 May 2023 17:21:09 +0000 (UTC)
Date: Fri, 12 May 2023 17:21:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1683912067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZSiDQKzm5iZBeoOO1Iqg6S2UdkhlrBZ6VIgs6Brz7tk=;
	b=waRJ90YZCaVKNpGP/sf+nspzkk5AJ+wR8DzMo+3iy2r9XPvpHBtyAgLKA71aqn6gA533LI
	F5CCEgU3Z11CgGB1BQ2MsNXsyenYcgmoRGQPwzQ16mZX0pSGcAQ/9b2gHtrxK17n4g1zGB
	HOBw58bl7kTEcp40WbQGXmHfpF6wYJc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ricardo Koller <ricarkol@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 6/7] KVM: arm64: Add 'skip_flush' arg to
 stage2_put_pte()
Message-ID: <ZF51f5tYPjK1aCpd@linux.dev>
References: <20230414172922.812640-1-rananta@google.com>
 <20230414172922.812640-7-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414172922.812640-7-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Raghavendra,

On Fri, Apr 14, 2023 at 05:29:21PM +0000, Raghavendra Rao Ananta wrote:
> Add a 'skip_flush' argument in stage2_put_pte() to
> control the TLB invalidations. This will be leveraged
> by the upcoming patch to defer the individual PTE
> invalidations until the entire walk is finished.
> 
> No functional change intended.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b8f0dbd12f773..3f136e35feb5e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -772,7 +772,7 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
>  }
>  
>  static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
> -			   struct kvm_pgtable_mm_ops *mm_ops)
> +			   struct kvm_pgtable_mm_ops *mm_ops, bool skip_flush)

Assuming you are going to pull the cpufeature checks into this helper,
it might me helpful to narrow the scope of it. 'stage2_put_pte()' sounds
very generic, but it is about to have a very precise meaning in relation
to kvm_pgtable_stage2_unmap().

So maybe stage2_unmap_put_pte()? While at it, you'd want to have a
shared helper for the deferral check:

static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
{
	/* your blurb for why FWB is required too */
	return system_supports_tlb_range() && stage2_has_fwb(pgt);
}

The 'flush' part is annoying, because the exact term is an invalidation,
but we already have that pattern in all of our TLB invalidation helpers.

>  {
>  	/*
>  	 * Clear the existing PTE, and perform break-before-make with
> @@ -780,7 +780,10 @@ static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s
>  	 */
>  	if (kvm_pte_valid(ctx->old)) {
>  		kvm_clear_pte(ctx->ptep);
> -		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> +
> +		if (!skip_flush)
> +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> +					ctx->addr, ctx->level);
>  	}
>  
>  	mm_ops->put_page(ctx->ptep);
> @@ -1015,7 +1018,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	 * block entry and rely on the remaining portions being faulted
>  	 * back lazily.
>  	 */
> -	stage2_put_pte(ctx, mmu, mm_ops);
> +	stage2_put_pte(ctx, mmu, mm_ops, false);
>  
>  	if (need_flush && mm_ops->dcache_clean_inval_poc)
>  		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
> -- 
> 2.40.0.634.g4ca3ef3211-goog
> 

-- 
Thanks,
Oliver
