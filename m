Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2BEEC8
	for <kvmarm@lists.linux.dev>; Mon, 20 Feb 2023 06:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676874997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8GjODHe6S++XQylWhBaNjHr8qSr1b8DgtaT4TgXobEI=;
	b=aV/zFapgl07QDlrhbXMiaxZtN1gooRrta5Rgsw12ozowTXasxiaoEbXHWmONJTz7Cdr3+2
	MaoZNvVkOAs6Hzg/7l/s5IhFSTYp5Ib7go05ErXRCXU679royL0ljY4r1hi1aRhofTI+Pz
	R7PonNWawDTOrnJfbcqitwd4Zw5MT1M=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-tO37aXEaOZ-eLijZLTeiqA-1; Mon, 20 Feb 2023 01:36:36 -0500
X-MC-Unique: tO37aXEaOZ-eLijZLTeiqA-1
Received: by mail-pj1-f70.google.com with SMTP id y4-20020a17090ad0c400b00236eabf924bso565451pjw.1
        for <kvmarm@lists.linux.dev>; Sun, 19 Feb 2023 22:36:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676874995;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8GjODHe6S++XQylWhBaNjHr8qSr1b8DgtaT4TgXobEI=;
        b=6yjh+weHv3S5aut9vk+wMYAmBEHzjwhTvZDr17rVY6yNzptoe5mlfSPOh1Ja9uv/hL
         ynWot45XwmSklyTeSuWkPKOkxlYJrokE2VmSnyHX5V+a3KaEimFXiIQ1ls/7xnhG1bhh
         EfB6m33yQUBfmurXqopCB/LEfh8TARX4vVu+ogxYrUn2InWyJR7cCikABHtvLliL34I+
         sgjjQayhUsS4ZDxf6bQWRVovSUxyCq3Tt0vq7xlOpXthfvk06ddTth5nNRv5FNZtLs/r
         noFx3v2EpaAuEyA33VlxsoXCFnFpIHYaajQJqyVJ83mGux9Kee/VKQ1yoWVOW/YyIPf7
         gSuA==
X-Gm-Message-State: AO0yUKXDGdgNo0DuAdo0fuPlUazadYP7Z06r/dS7O/toxmWUa3EdvsYU
	kGVd3Bkg4K8mdb8Xr7/l+QnKCkOkkST3uKTr5QqEbrgZTSqXHqq5vPpxPVVWK8qPnqUEaYZWSlv
	9XYuM3uF4xXQjc9JY
X-Received: by 2002:a62:e713:0:b0:5a9:cebd:7b79 with SMTP id s19-20020a62e713000000b005a9cebd7b79mr874878pfh.0.1676874995678;
        Sun, 19 Feb 2023 22:36:35 -0800 (PST)
X-Google-Smtp-Source: AK7set8E02nUXFpUZT0DxvGjWE7nTzqX9K4BGP1W4oErCb+WGEbDoiKUSDEreN1T1nYqO+eYiw6y2Q==
X-Received: by 2002:a62:e713:0:b0:5a9:cebd:7b79 with SMTP id s19-20020a62e713000000b005a9cebd7b79mr874843pfh.0.1676874995304;
        Sun, 19 Feb 2023 22:36:35 -0800 (PST)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bm2-20020a056a00320200b005821c109cebsm1384665pfb.199.2023.02.19.22.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Feb 2023 22:36:34 -0800 (PST)
Message-ID: <e62b4495-3e99-d3da-8fc3-e40246ccb498@redhat.com>
Date: Mon, 20 Feb 2023 14:35:46 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com
References: <20230218032314.635829-1-ricarkol@google.com>
 <20230218032314.635829-4-ricarkol@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230218032314.635829-4-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ricardo,

On 2/18/23 11:23, Ricardo Koller wrote:
> Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for
> creating unlinked tables (which is the opposite of
> kvm_pgtable_stage2_free_unlinked()).  Creating an unlinked table is
> useful for splitting PMD and PUD blocks into subtrees of PAGE_SIZE
> PTEs.  For example, a PUD can be split into PAGE_SIZE PTEs by first
> creating a fully populated tree, and then use it to replace the PUD in
> a single step.  This will be used in a subsequent commit for eager
> huge-page splitting (a dirty-logging optimization).
> 
> No functional change intended. This new function will be used in a
> subsequent commit.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 28 +++++++++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 46 ++++++++++++++++++++++++++++
>   2 files changed, 74 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index dcd3aafd3e6c..b8cde914cca9 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -460,6 +460,34 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>    */
>   void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
>   
> +/**
> + * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> + * @phys:	Physical address of the memory to map.
> + * @level:	Starting level of the stage-2 paging structure to be created.
> + * @prot:	Permissions and attributes for the mapping.
> + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> + *		page-table pages.
> + * @force_pte:  Force mappings to PAGE_SIZE granularity.
> + *
> + * Create an unlinked page-table tree under @new. If @force_pte is
The @new parameter has been deleted, you should update the comments too.

Thanks,
Shaoqin
> + * true or @level is 2 (the PMD level), then the tree is mapped up to
> + * the PAGE_SIZE leaf PTE; the tree is mapped up one level otherwise.
> + * This new page-table tree is not reachable (i.e., it is unlinked)
> + * from the root pgd and it's therefore unreachableby the hardware
> + * page-table walker. No TLB invalidation or CMOs are performed.
> + *
> + * If device attributes are not explicitly requested in @prot, then the
> + * mapping will be normal, cacheable.
> + *
> + * Return: The fully populated (unlinked) stage-2 paging structure, or
> + * an ERR_PTR(error) on failure.
> + */
> +kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> +					      u64 phys, u32 level,
> +					      enum kvm_pgtable_prot prot,
> +					      void *mc, bool force_pte);
> +
>   /**
>    * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
>    * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 0a5ef9288371..80f2965ab0fe 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1181,6 +1181,52 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>   	return kvm_pgtable_walk(pgt, addr, size, &walker);
>   }
>   
> +kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> +					      u64 phys, u32 level,
> +					      enum kvm_pgtable_prot prot,
> +					      void *mc, bool force_pte)
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
> +		return ERR_PTR(ret);
> +
> +	pgtable = mm_ops->zalloc_page(mc);
> +	if (!pgtable)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ret = __kvm_pgtable_walk(&data, mm_ops, (kvm_pteref_t)pgtable,
> +				 level + 1);
> +	if (ret) {
> +		kvm_pgtable_stage2_free_unlinked(mm_ops, pgtable, level);
> +		mm_ops->put_page(pgtable);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return pgtable;
> +}
>   
>   int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   			      struct kvm_pgtable_mm_ops *mm_ops,

-- 
Regards,
Shaoqin

