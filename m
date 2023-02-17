Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A74C376
	for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 04:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676606843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TWQfzUcCwlzm6sKehp4ZpwCoGpqZRGcu2EZK4t1AGuM=;
	b=ANojH85Kr/GYsTm0WFc0nwcXyQyqf86SEGpH71KPtrCDpXDHiWHggyxO+pvblHZ3Bu7UCr
	WtWbRDpHgOnxcMCNc08+1yCXLIEJ6VSvRiSTYAsFj+8fG2Gdau50C8oOUKE2I+FoViE4Ew
	LjUKngal7AJeramGIhhTeXVm9aji1k4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-204-h9wPs1alOo-Oi3zAj6uO7A-1; Thu, 16 Feb 2023 23:07:21 -0500
X-MC-Unique: h9wPs1alOo-Oi3zAj6uO7A-1
Received: by mail-pj1-f69.google.com with SMTP id pv3-20020a17090b3c8300b002342e23955cso1992236pjb.7
        for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 20:07:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TWQfzUcCwlzm6sKehp4ZpwCoGpqZRGcu2EZK4t1AGuM=;
        b=Xr/+DY5mZe3cRlMI8hTxDMQUVNbSj/Q80PjDYKMc3XQzZu3QHuJRe/A9sUrJa9tUy1
         c3H6ORJRfCP0Qem7VVn5ZI8EHUBlPv0Da6eIvP3rmPhQH9fdPt35vJr8AK36Ri60j1Qk
         ffrKBG9t3LE8lO7r5eq8rbLph5+5VbFW871LzB//pghQl24rdFFK+H/dDkuOstwDXrd5
         fq9u4PFF+ZZkklf0JKXxsEtdkds8TYNW33mQPM5IfN96IvkEpdHw8x3mEKk+w1RzAKnc
         fjzlglfcnhpy2K8sqs+v+rxx6yvDoYAN54u6wYsSApwABGFoiYDTc6AfKtnXuu6xhKUJ
         9j2A==
X-Gm-Message-State: AO0yUKU2mXbifcZx/Hs/nwz99P/HDQ+PLwfu74m7WtmMrWEd7YDruPPJ
	xulCsUG/T/+K+yG07VivuD6xU9RMZhES641c8Gbl4EA5LNLc3DfyjP8HS/1RJ71Du+33AHFxMvT
	ITLr7WJCAxKMdN0Xo
X-Received: by 2002:a05:6a00:cce:b0:5a9:b4c6:c07c with SMTP id b14-20020a056a000cce00b005a9b4c6c07cmr3136857pfv.0.1676606840715;
        Thu, 16 Feb 2023 20:07:20 -0800 (PST)
X-Google-Smtp-Source: AK7set/HhmzhIvwODyOOUf9AdQnW43QbUPXFNc3K5/CqbRQRmJyVplWpkivs2LFTRWh1IEFIVBO3+Q==
X-Received: by 2002:a05:6a00:cce:b0:5a9:b4c6:c07c with SMTP id b14-20020a056a000cce00b005a9b4c6c07cmr3136817pfv.0.1676606840275;
        Thu, 16 Feb 2023 20:07:20 -0800 (PST)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b14-20020a65668e000000b004fb997a0bd8sm1905130pgw.30.2023.02.16.20.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 20:07:19 -0800 (PST)
Message-ID: <073043b0-522d-0c5c-7a85-35ef5112e6d9@redhat.com>
Date: Fri, 17 Feb 2023 12:07:12 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com
References: <20230215174046.2201432-1-ricarkol@google.com>
 <20230215174046.2201432-5-ricarkol@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230215174046.2201432-5-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Ricardo,

On 2/16/23 01:40, Ricardo Koller wrote:
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
>   arch/arm64/include/asm/kvm_pgtable.h |  30 ++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 105 +++++++++++++++++++++++++++
>   2 files changed, 135 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 2ea397ad3e63..b28489aa0994 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -658,6 +658,36 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
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
> index fed314f2b320..e2fb78398b3d 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1229,6 +1229,111 @@ int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>   	return 0;
>   }
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

Is the level 3 check really needed?
Because level 3 will be first detected by:

+ if (level == KVM_PGTABLE_MAX_LEVELS - 1)
+ return 0;

in the stage2_split_walker().

Even if the case 3 return 0 and continue execute, it will still trigger:
kvm_pgtable_stage2_create_unlinked(..level..)
   -> __kvm_pgtable_walk(..level+1..)
     -> WARN_ON_ONCE(level >= KVM_PGTABLE_MAX_LEVELS)

Thanks,
Shaoqin

> +	default:
> +		WARN_ON_ONCE(1);
> +		return ~0;
> +	}
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
> +
> +	if (data->mc_capacity < nr_pages)
> +		return -ENOMEM;
> +
> +	phys = kvm_pte_to_phys(pte);
> +	prot = kvm_pgtable_stage2_pte_prot(pte);
> +
> +	ret = kvm_pgtable_stage2_create_unlinked(data->mmu->pgt, &new, phys,
> +						 level, prot, mc, force_pte);
> +	if (ret)
> +		return ret;
> +
> +	if (!stage2_try_break_pte(ctx, data->mmu)) {
> +		childp = kvm_pte_follow(new, mm_ops);
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
Regards,
Shaoqin

