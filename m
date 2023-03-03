Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AEE1FB3
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 09:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677834591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJe1IfdCoJR8Gs3rY8myzr5sYaOrRXm56RaO5zyn4p8=;
	b=HXe4VrLF3qA1kBF0Kc6XuXmudgEt6RzYAd09uy+Z3Gd2VPorTk2sV3ODLASxemyx4GR3Gr
	OBxy1wu0U9TB1xwyLrCGIqYcZmBPECAB5438BkwibBI3gjhZP/DIMMgqwWn9juNXO7eaue
	/QTgQzSK72cE8H/WrEgi5Zui0+y7my4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-644--ZITQncbNpGLEDTtZTXdrw-1; Fri, 03 Mar 2023 04:09:50 -0500
X-MC-Unique: -ZITQncbNpGLEDTtZTXdrw-1
Received: by mail-qk1-f200.google.com with SMTP id dw26-20020a05620a601a00b0074300c772c0so989807qkb.11
        for <kvmarm@lists.linux.dev>; Fri, 03 Mar 2023 01:09:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677834590;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pJe1IfdCoJR8Gs3rY8myzr5sYaOrRXm56RaO5zyn4p8=;
        b=Wx04APWrmhB6ruZ3Rn3Z5lA5T6megwGfofrrY1ah4wNqKrvEkQelq7qzY8wWu15fYD
         o053bi6sTKIbJU8FVP3pBKB8Yys2D7X2faP+4CeOitznDT3wSQBawBKvM3vKU0csV/Rw
         fAzZ85lODH/UI7UUpjYeSaxwcEjbjWLuhrILXUjY1mVedwRQAuEtme9BpIsrfzU2dqkk
         o27iEMxQII2jfq4UdMQo0l+XcMyqXGEYQ/bOhL1GvWO9VlVL/PPFCXMhnk/1reHcegLK
         2Ns/yfPIHh20j1n4Q56kNZ+PHYEZmqetJGeahdkbiIfK2bC6kuNB4DRSKFRpiEbzCB/n
         evaw==
X-Gm-Message-State: AO0yUKXVpvIwSm0gtDEBbtjZD79tg9QLEquO6GAYiibYbgxPymClHY7L
	dg/hdaC3/3d3pYVqxK668hYpPBILRGJsopWys4nFIj4uXRYNdkIyMz5skeFzkzw9bLYwu6fHAWT
	DMPIoOIfu1Mnm2pRn
X-Received: by 2002:ac8:5b08:0:b0:3bf:cc1b:9512 with SMTP id m8-20020ac85b08000000b003bfcc1b9512mr1783775qtw.1.1677834590353;
        Fri, 03 Mar 2023 01:09:50 -0800 (PST)
X-Google-Smtp-Source: AK7set8p2UjpHPijUcOQBqy9GwkoNikUUadtv/Y8U9dSsIyTKEF761hVPtYYk6UWS5ANNDIb+RbwWg==
X-Received: by 2002:ac8:5b08:0:b0:3bf:cc1b:9512 with SMTP id m8-20020ac85b08000000b003bfcc1b9512mr1783754qtw.1.1677834590083;
        Fri, 03 Mar 2023 01:09:50 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c6-20020ac81e86000000b003b9bb59543fsm1327816qtm.61.2023.03.03.01.09.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:09:49 -0800 (PST)
Message-ID: <9f9fe336-f1e2-d064-8185-e34d1e19813a@redhat.com>
Date: Fri, 3 Mar 2023 17:09:41 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-5-ricarkol@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301210928.565562-5-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/23 05:09, Ricardo Koller wrote:
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
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h |  30 +++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 113 +++++++++++++++++++++++++++
>   2 files changed, 143 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 2b98357a5497..ce0a8e17fb6d 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -657,6 +657,36 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
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
>   /**
>    * kvm_pgtable_walk() - Walk a page-table.
>    * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 3554b74e13c6..75726edba2f3 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1228,6 +1228,119 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>   	return pgtable;
>   }
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
>   int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   			      struct kvm_pgtable_mm_ops *mm_ops,
>   			      enum kvm_pgtable_stage2_flags flags,

-- 
Shaoqin

