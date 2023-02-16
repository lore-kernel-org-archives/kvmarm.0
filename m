Received: from out-73.mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CAF7B
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 00:32:19 +0000 (UTC)
Date: Thu, 16 Feb 2023 00:13:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676506404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tsgik+TkLTT38ETaf6PMozlp7a9H3CC1m2Yq9zLY5NE=;
	b=mVqJFtv48sjG0eIb+Z5HJxl+L1nSGmiQRTq7wcm8Cqt0FYDUcmFmvk479FcYaFRY1uua51
	vNZJeOBEatShDipD19E/MROmWKv/qPbDNc9Bp7J0iOuCzETtIgJByYThJTJyL4OmhFEp6j
	1z6H9D2E1DHi1JIcJ7jDMwalTzJ9cuk=
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
Subject: Re: [PATCH v3 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
Message-ID: <Y+11HkcHMwUrEkPz@linux.dev>
References: <20230215174046.2201432-1-ricarkol@google.com>
 <20230215174046.2201432-4-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215174046.2201432-4-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 15, 2023 at 05:40:37PM +0000, Ricardo Koller wrote:
> Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for creating
> unlinked tables (the opposite of kvm_pgtable_stage2_free_unlinked()).

You don't need to mention the free_unlinked() side of things, IMO.

> Creating an unlinked table is useful for splitting block PTEs into
> subtrees of 4K PTEs.  For example, a 1G block PTE can be split into 4K
> PTEs by first creating a fully populated tree, and then use it to
> replace the 1G PTE in a single step.  This will be used in a
> subsequent commit for eager huge-page splitting (a dirty-logging
> optimization).

This is all very PAGE_SIZE=4K centric :) Could you instead describe the
operation in terms of the Linux page table hierarchy?

i.e. '... useful for splitting hugepages into PTE-level mappings'

> No functional change intended. This new function will be used in a
> subsequent commit.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 29 +++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 47 ++++++++++++++++++++++++++++
>  2 files changed, 76 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 7c45082e6c23..2ea397ad3e63 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -460,6 +460,35 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>   */
>  void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
>  
> +/**
> + * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> + * @new:	Unlinked stage-2 paging structure to be created.
> + * @phys:	Physical address of the memory to map.
> + * @level:	Level of the stage-2 paging structure to be created.

I believe this is the starting level of the page table to be created,
right? Might be worth calling that out explicitly as level could also be
interpreted as mapping level.

> + * @prot:	Permissions and attributes for the mapping.
> + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> + *		page-table pages.
> + * @force_pte:  Force mappings to PAGE_SIZE granularity.
> + *
> + * Create an unlinked page-table tree under @new. If @force_pte is
> + * true or @level is the PMD level, then the tree is mapped up to the
> + * PAGE_SIZE leaf PTE; the tree is mapped up one level otherwise. This
> + * new page-table tree is not reachable (i.e., it is removed) from the

'i.e. it is unlinked'

> + * root pgd and it's therefore unreachableby the hardware page-table
> + * walker. No TLB invalidation or CMOs are performed.
> + *
> + * If device attributes are not explicitly requested in @prot, then the
> + * mapping will be normal, cacheable.
> + *
> + * Return: 0 only if a fully populated tree was created (all memory
> + * under @level is mapped), negative error code on failure.
> + */
> +int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> +				       kvm_pte_t *new, u64 phys, u32 level,
> +				       enum kvm_pgtable_prot prot, void *mc,
> +				       bool force_pte);
> +
>  /**
>   * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
>   * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 0a5ef9288371..fed314f2b320 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1181,6 +1181,53 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  	return kvm_pgtable_walk(pgt, addr, size, &walker);
>  }
>  
> +int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> +				      kvm_pte_t *new, u64 phys, u32 level,
> +				      enum kvm_pgtable_prot prot, void *mc,
> +				      bool force_pte)
> +{
> +	struct stage2_map_data map_data = {
> +		.phys		= phys,
> +		.mmu		= pgt->mmu,
> +		.memcache	= mc,
> +		.force_pte	= force_pte,
> +	};
> +	struct kvm_pgtable_walker walker = {
> +		.cb		= stage2_map_walker,
> +		.flags		= KVM_PGTABLE_WALK_LEAF |
> +				  KVM_PGTABLE_WALK_SKIP_BBM |
> +				  KVM_PGTABLE_WALK_SKIP_CMO,
> +		.arg		= &map_data,
> +	};
> +	/* .addr (the IPA) is irrelevant for a removed table */
> +	struct kvm_pgtable_walk_data data = {
> +		.walker	= &walker,
> +		.addr	= 0,
> +		.end	= kvm_granule_size(level),
> +	};
> +	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> +	kvm_pte_t *pgtable;
> +	int ret;
> +
> +	ret = stage2_set_prot_attr(pgt, prot, &map_data.attr);
> +	if (ret)
> +		return ret;
> +
> +	pgtable = mm_ops->zalloc_page(mc);
> +	if (!pgtable)
> +		return -ENOMEM;
> +
> +	ret = __kvm_pgtable_walk(&data, mm_ops, (kvm_pteref_t)pgtable,
> +				 level + 1);
> +	if (ret) {
> +		kvm_pgtable_stage2_free_unlinked(mm_ops, pgtable, level);
> +		mm_ops->put_page(pgtable);
> +		return ret;
> +	}
> +
> +	*new = kvm_init_table_pte(pgtable, mm_ops);
> +	return 0;

Hmm. I don't think you really need the 'out' pointer here. Either the
function fails and it returns a negative error, or it succeeds and
returns a pointer.

  kvm_pte_t *kvm_pgtable_stage2_create_unlinked(...)
  {
          int ret;

	  [...]

	  ret = __kvm_pgtable_walk(...);
	  if (ret) {
	          kvm_pgtable_stage2_free_unlinked(...);
		  mm_ops->put_page(pgtable);
		  return ERR_PTR(ret);
	  }


          return pgtable;
  }

  [...]

  pgtable = kvm_pgtable_stage2_create_unlinked(...);
  if (IS_ERR(pgtable))
  	return PTR_ERR(pgtable);

-- 
Thanks,
Oliver
