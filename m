Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3258862F
	for <kvmarm@lists.linux.dev>; Sat, 18 Feb 2023 03:28:20 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id a20so175279pls.2
        for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 19:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rfCMHgIz5kiDxJwrkO/9/DfGjzMle5yHTdkfBDkL2xk=;
        b=KPMxqKoZhW06fnf/R4mUih0Wq+NPd/lIsqRYf5c1GKQbe8WA0NyxhpsJYqjMg6kf3t
         0GyNTIHhZdNBbRJ6P4LH14zg5tvZxFW/DiK//hWG0MKUgdYWMdl8tqvy15fg8zpjlEa+
         ILMxFXGT6tgUv9GCX+A9QB3Jaql1hrwpGWAcGwBLJDJmNUzuIkdh3Fl4k245WIQcZLLp
         94Jt3g16WFtNa+5vC1j4NGtPLiXJmRvXVF5br9o6Di/oCkGOo3EzMu8dQlQ5THTMxrQF
         RnvK5zVLNHzRd5LLzYdLSBC3bJiYlrdXbW6MkE00e0F3kay3V0kb4eSp9phL83eys+59
         Actw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rfCMHgIz5kiDxJwrkO/9/DfGjzMle5yHTdkfBDkL2xk=;
        b=09AADgoJvPotZbnE+Eio9nxXaij2mqIE6RT3UyJl3vIC2OT5exA8mu/iEFP6I9BXJ4
         tVM+ufglqmF0xWZuY/M6ppTCBzzypXR9rFKtuveDHUGgDLCienSGEWhVs+7ljyzkXOTQ
         2rpCjDt25OtyCMBfE5JdU84BxPaFl5CPHuaWejvMqmjRKgSWx3SbeOBOgp9fm9PZBWy7
         awiNa+lJEKrmg65eYXDcUwP+P2/DnIxrfxc8SNPbrYhVcsgvYXIFLABaUqNlpMiKrR2k
         Ljc9pL4C7YD/cnbXxDxq+P5jpMC+J1tGJwimMiVbw4iboQy6mE2SinC+1S6t+ChRKodF
         c/AA==
X-Gm-Message-State: AO0yUKXDCAB49T6B/zZ7mT42XiecRcsJoxQNfCLiywc+mdQk/e16vhA9
	pSfOXzcc85somo3qdZt/JnkqCg==
X-Google-Smtp-Source: AK7set8DENOPudv/9pNYoQdUkuHucMW3IYcRqd/evB9ZUjF/5gLd4X20Of1eJm/DGnBQbbQpiX0oAg==
X-Received: by 2002:a17:902:e74d:b0:198:af50:e4e2 with SMTP id p13-20020a170902e74d00b00198af50e4e2mr112298plf.8.1676690899332;
        Fri, 17 Feb 2023 19:28:19 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id x7-20020a170902a38700b0019926c7757asm3748296pla.289.2023.02.17.19.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 19:28:18 -0800 (PST)
Date: Fri, 17 Feb 2023 19:28:15 -0800
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
	alexandru.elisei@arm.com, suzuki.poulose@arm.com,
	eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Subject: Re: [PATCH v4 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y/BFz5uC+iL2+q2o@google.com>
References: <20230218032314.635829-1-ricarkol@google.com>
 <20230218032314.635829-5-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230218032314.635829-5-ricarkol@google.com>

On Sat, Feb 18, 2023 at 03:23:06AM +0000, Ricardo Koller wrote:
> Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
> range of huge pages. This will be used for eager-splitting huge pages
> into PAGE_SIZE pages. The goal is to avoid having to split huge pages
> on write-protection faults, and instead use this function to do it
> ahead of time for large ranges (e.g., all guest memory in 1G chunks at
> a time).
> 
> No functional change intended. This new function will be used in a
> subsequent commit.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  30 +++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 113 +++++++++++++++++++++++++++
>  2 files changed, 143 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index b8cde914cca9..6908109ac11e 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -657,6 +657,36 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
>   */
>  int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
>  
> +/**
> + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> + *				to PAGE_SIZE guest pages.
> + * @pgt:	 Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	 Intermediate physical address from which to split.
> + * @size:	 Size of the range.
> + * @mc:		 Cache of pre-allocated and zeroed memory from which to allocate
> + *		 page-table pages.
> + * @mc_capacity: Number of pages in @mc.
> + *
> + * @addr and the end (@addr + @size) are effectively aligned down and up to
> + * the top level huge-page block size. This is an example using 1GB
> + * huge-pages and 4KB granules.
> + *
> + *                          [---input range---]
> + *                          :                 :
> + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> + *                          :                 :
> + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> + *                          :                 :
> + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> + *                          :                 :
> + *
> + * Return: 0 on success, negative error code on failure. Note that
> + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> + * blocks in the input range as allowed by @mc_capacity.
> + */
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +			     void *mc, u64 mc_capacity);
> +
>  /**
>   * kvm_pgtable_walk() - Walk a page-table.
>   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 80f2965ab0fe..9f1c8fdd9330 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1228,6 +1228,119 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>  	return pgtable;
>  }
>  
> +struct stage2_split_data {
> +	struct kvm_s2_mmu		*mmu;
> +	void				*memcache;
> +	u64				mc_capacity;
> +};
> +
> +/*
> + * Get the number of page-tables needed to replace a block with a
> + * fully populated tree, up to the PTE level, at particular level.
> + */
> +static inline int stage2_block_get_nr_page_tables(u32 level)
> +{
> +	if (WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
> +			 level >= KVM_PGTABLE_MAX_LEVELS))
> +		return -EINVAL;
> +
> +	switch (level) {
> +	case 1:
> +		return PTRS_PER_PTE + 1;
> +	case 2:
> +		return 1;
> +	case 3:
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	};
> +}

Shaoqin,

"Is the level 3 check really needed?"

Regarding your question about the need for "case 3". You are right,
it's not actually needed in this particular case (when called from
stage2_split_walker()). However, it would be nice to reuse this
function and so it should cover all functions.

Thanks,
Ricardo

> +
> +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> +			       enum kvm_pgtable_walk_flags visit)
> +{
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +	struct stage2_split_data *data = ctx->arg;
> +	kvm_pte_t pte = ctx->old, new, *childp;
> +	enum kvm_pgtable_prot prot;
> +	void *mc = data->memcache;
> +	u32 level = ctx->level;
> +	bool force_pte;
> +	int nr_pages;
> +	u64 phys;
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
> +	if (nr_pages < 0)
> +		return nr_pages;
> +
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
> +
> +	if (data->mc_capacity < nr_pages)
> +		return -ENOMEM;
> +
> +	phys = kvm_pte_to_phys(pte);
> +	prot = kvm_pgtable_stage2_pte_prot(pte);
> +
> +	childp = kvm_pgtable_stage2_create_unlinked(data->mmu->pgt, phys,
> +						    level, prot, mc, force_pte);
> +	if (IS_ERR(childp))
> +		return PTR_ERR(childp);
> +
> +	if (!stage2_try_break_pte(ctx, data->mmu)) {
> +		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
> +		mm_ops->put_page(childp);
> +		return -EAGAIN;
> +	}
> +
> +	/*
> +	 * Note, the contents of the page table are guaranteed to be made
> +	 * visible before the new PTE is assigned because stage2_make_pte()
> +	 * writes the PTE using smp_store_release().
> +	 */
> +	new = kvm_init_table_pte(childp, mm_ops);
> +	stage2_make_pte(ctx, new);
> +	dsb(ishst);
> +	data->mc_capacity -= nr_pages;
> +	return 0;
> +}
> +
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +			     void *mc, u64 mc_capacity)
> +{
> +	struct stage2_split_data split_data = {
> +		.mmu		= pgt->mmu,
> +		.memcache	= mc,
> +		.mc_capacity	= mc_capacity,
> +	};
> +
> +	struct kvm_pgtable_walker walker = {
> +		.cb	= stage2_split_walker,
> +		.flags	= KVM_PGTABLE_WALK_LEAF,
> +		.arg	= &split_data,
> +	};
> +
> +	return kvm_pgtable_walk(pgt, addr, size, &walker);
> +}
> +
>  int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>  			      struct kvm_pgtable_mm_ops *mm_ops,
>  			      enum kvm_pgtable_stage2_flags flags,
> -- 
> 2.39.2.637.g21b0678d19-goog
> 
