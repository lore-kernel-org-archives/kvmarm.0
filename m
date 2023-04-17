Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658B51103
	for <kvmarm@lists.linux.dev>; Mon, 17 Apr 2023 06:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681713506;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqRvgvpkNmGxpsiBcOuuAEtfdPWdIq+R5UqWfViyFNI=;
	b=cVDJYCvKcF8LU22lHoN7FSihMaenTOjfDiF/6S5plIw5Bvi6a79NX5cq8GxBT/uBY5oWAQ
	94XFlt3qv0X/P2vpGP3BBXPeEyH7+k2e/eufzCNQR5jZRGeafF5fS9u7JLyy+tfKzejPfn
	XF2/Y+zt25XS8hvYN77rJd3kaLYa268=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-Ls_amiK6P-u7afxQGuly4w-1; Mon, 17 Apr 2023 02:38:22 -0400
X-MC-Unique: Ls_amiK6P-u7afxQGuly4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A83A1185A794;
	Mon, 17 Apr 2023 06:38:21 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E3CD14152F6;
	Mon, 17 Apr 2023 06:38:09 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com, Shaoqin Huang <shahuang@redhat.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-6-ricarkol@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <ef8ec8d0-51d9-0971-395e-04d035e948fe@redhat.com>
Date: Mon, 17 Apr 2023 14:38:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-6-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7

On 4/9/23 2:29 PM, Ricardo Koller wrote:
> Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
> range of huge pages. This will be used for eager-splitting huge pages
> into PAGE_SIZE pages. The goal is to avoid having to split huge pages
> on write-protection faults, and instead use this function to do it
> ahead of time for large ranges (e.g., all guest memory in 1G chunks at
> a time).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h |  19 +++++
>   arch/arm64/kvm/hyp/pgtable.c         | 103 +++++++++++++++++++++++++++
>   2 files changed, 122 insertions(+)
> 

With the following nits addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index c8e0e7d9303b2..32e5d42bf020f 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -653,6 +653,25 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
>    */
>   int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
>   
> +/**
> + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> + *				to PAGE_SIZE guest pages.
> + * @pgt:	 Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	 Intermediate physical address from which to split.
> + * @size:	 Size of the range.
> + * @mc:		 Cache of pre-allocated and zeroed memory from which to allocate
                  ^^^^^^^^
Alignment.

> + *		 page-table pages.
> + *
> + * The function tries to split any level 1 or 2 entry that overlaps
> + * with the input range (given by @addr and @size).
> + *
> + * Return: 0 on success, negative error code on failure. Note that
> + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> + * blocks in the input range as allowed by @mc_capacity.
> + */
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +			     struct kvm_mmu_memory_cache *mc);
> +
>   /**
>    * kvm_pgtable_walk() - Walk a page-table.
>    * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 477d2be67d401..48c5a95c6e8cd 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1272,6 +1272,109 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>   	return pgtable;
>   }
>   
> +/*
> + * Get the number of page-tables needed to replace a block with a
> + * fully populated tree up to the PTE entries. Note that @level is
> + * interpreted as in "level @level entry".
> + */
> +static int stage2_block_get_nr_page_tables(u32 level)
> +{
> +	switch (level) {
> +	case 1:
> +		return PTRS_PER_PTE + 1;
> +	case 2:
> +		return 1;
> +	case 3:
> +		return 0;
> +	default:
> +		WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
> +			     level >= KVM_PGTABLE_MAX_LEVELS);
> +		return -EINVAL;
> +	};
> +}
> +

When the starting level is 3, it's not a block mapping if I'm correct. Besides,
the caller (stage2_split_walker()) bails when the starting level is 3. In this
case, the changes may be integrated to stage2_split_walker(), which is the only
caller. Otherwise, 'inline' is worthy to have.

	nr_pages = kvm_granule_shift(level) == PUD_SHIFT && kvm_granule_shift(level) != PMD_SHIFT) ?
                    (PTRS_PER_PTE + 1) : 1;

> +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> +			       enum kvm_pgtable_walk_flags visit)
> +{
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +	struct kvm_mmu_memory_cache *mc = ctx->arg;
> +	struct kvm_s2_mmu *mmu;
> +	kvm_pte_t pte = ctx->old, new, *childp;
> +	enum kvm_pgtable_prot prot;
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
> +	if (mc->nobjs >= nr_pages) {
> +		/* Build a tree mapped down to the PTE granularity. */
> +		force_pte = true;
> +	} else {
> +		/*
> +		 * Don't force PTEs, so create_unlinked() below does
> +		 * not populate the tree up to the PTE level. The
> +		 * consequence is that the call will require a single
> +		 * page of level 2 entries at level 1, or a single
> +		 * page of PTEs at level 2. If we are at level 1, the
> +		 * PTEs will be created recursively.
> +		 */
> +		force_pte = false;
> +		nr_pages = 1;
> +	}
> +
> +	if (mc->nobjs < nr_pages)
> +		return -ENOMEM;
> +
> +	mmu = container_of(mc, struct kvm_s2_mmu, split_page_cache);
> +	phys = kvm_pte_to_phys(pte);
> +	prot = kvm_pgtable_stage2_pte_prot(pte);
> +
> +	childp = kvm_pgtable_stage2_create_unlinked(mmu->pgt, phys,
> +						    level, prot, mc, force_pte);
> +	if (IS_ERR(childp))
> +		return PTR_ERR(childp);
> +
> +	if (!stage2_try_break_pte(ctx, mmu)) {
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
> +	return 0;
> +}
> +
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +			     struct kvm_mmu_memory_cache *mc)
> +{
> +	struct kvm_pgtable_walker walker = {
> +		.cb	= stage2_split_walker,
> +		.flags	= KVM_PGTABLE_WALK_LEAF,
> +		.arg	= mc,
> +	};
> +
> +	return kvm_pgtable_walk(pgt, addr, size, &walker);
> +}
> +
>   int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   			      struct kvm_pgtable_mm_ops *mm_ops,
>   			      enum kvm_pgtable_stage2_flags flags,
> 

Thanks,
Gavin

