Received: from out-152.mta0.migadu.com (out-152.mta0.migadu.com [91.218.175.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2830817D7
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 02:54:27 +0000 (UTC)
Date: Thu, 16 Feb 2023 00:36:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676507794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jUWghOA0XMQm7ZnAAYelpbgLNnK2ho6Hsw1M8ipcYbM=;
	b=tpHgqc1NbfynRGVXEBegZGlS4EH/rrYKUj17F6cPjtFbCGvZsSQK4op38ZarbDWQ97rYnL
	Ow76UigCBqT3IqOJrVdVsxbgPSRSWzQXs8CJJD7GaO9dAXjFLXL9JV6OJT3bf0JxRPPE5s
	nFlZ5XPc67wfqLRGDNSWH/pyUT+NpZg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com,
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com,
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com,
	reijiw@google.com, rananta@google.com, bgardon@google.com,
	ricarkol@gmail.com
Subject: Re: [PATCH v3 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y+16gsTbsZyUBMAt@linux.dev>
References: <20230215174046.2201432-1-ricarkol@google.com>
 <20230215174046.2201432-5-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215174046.2201432-5-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 15, 2023 at 05:40:38PM +0000, Ricardo Koller wrote:

[...]

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index fed314f2b320..e2fb78398b3d 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1229,6 +1229,111 @@ int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>  	return 0;
>  }
>  
> +struct stage2_split_data {
> +	struct kvm_s2_mmu		*mmu;
> +	void				*memcache;
> +	u64				mc_capacity;
> +};
> +
> +/*
> + * Get the number of page-tables needed to replace a bock with a fully
> + * populated tree, up to the PTE level, at particular level.
> + */
> +static inline u32 stage2_block_get_nr_page_tables(u32 level)
> +{
> +	switch (level) {
> +	/* There are no blocks at level 0 */
> +	case 1: return 1 + PTRS_PER_PTE;
> +	case 2: return 1;
> +	case 3: return 0;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return ~0;
> +	}
> +}

This doesn't take into account our varying degrees of hugepage support
across page sizes. Perhaps:

  static inline int stage2_block_get_nr_page_tables(u32 level)
  {
          if (WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
	                   level >= KVM_PGTABLE_MAX_LEVELS))
	          return -EINVAL;

          switch (level) {
	  case 1:
	  	return PTRS_PER_PTE + 1;
	  case 2:
	  	return 1;
	  case 3:
	  	return 0;
	  }
  }

paired with an explicit error check and early return on the caller side.

> +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> +			       enum kvm_pgtable_walk_flags visit)
> +{
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +	struct stage2_split_data *data = ctx->arg;
> +	kvm_pte_t pte = ctx->old, new, *childp;
> +	enum kvm_pgtable_prot prot;
> +	void *mc = data->memcache;
> +	u32 level = ctx->level;
> +	u64 phys, nr_pages;
> +	bool force_pte;
> +	int ret;
> +
> +	/* No huge-pages exist at the last level */
> +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> +		return 0;
> +
> +	/* We only split valid block mappings */
> +	if (!kvm_pte_valid(pte))
> +		return 0;
> +
> +	nr_pages = stage2_block_get_nr_page_tables(level);
> +	if (data->mc_capacity >= nr_pages) {
> +		/* Build a tree mapped down to the PTE granularity. */
> +		force_pte = true;
> +	} else {
> +		/*
> +		 * Don't force PTEs. This requires a single page of PMDs at the
> +		 * PUD level, or a single page of PTEs at the PMD level. If we
> +		 * are at the PUD level, the PTEs will be created recursively.
> +		 */
> +		force_pte = false;
> +		nr_pages = 1;
> +	}

Do we know if the 'else' branch here is even desirable? I.e. has
recursive shattering been tested with PUD hugepages (HugeTLB 1G) and
shown to improve guest performance while dirty tracking?

The observations we've made on existing systems were that the successive
break-before-make operations led to a measurable slowdown in guest
pre-copy performance. Recursively building the page tables should
actually result in *more* break-before-makes than if we just let the vCPU
fault path lazily shatter hugepages.

-- 
Thanks,
Oliver
