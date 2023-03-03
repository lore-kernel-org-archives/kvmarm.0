Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F541FB3
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 09:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677834157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zVx7liUtAHi9MlgajvxM1lPoJHO/9CA0IPkpax0IClE=;
	b=cY1EGyeV6QpEZmC/IZ+0aqmH7V/3NByXbz97juOBfbi36ebMOQ+qFRIFsvUzfHjr6j9pd5
	ykc9Mi6oI8XbXHnHdPTK9h/wkwK3F7X8s38w2jTISaxYRItChAMv8trufMy0DwOUiNbbUO
	a3tTE+u0Uq8c/lx5wZiBn6tTPBOz2gE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-608-AYlI8IMzOP-ltqJ87pTTpA-1; Fri, 03 Mar 2023 04:02:34 -0500
X-MC-Unique: AYlI8IMzOP-ltqJ87pTTpA-1
Received: by mail-pl1-f198.google.com with SMTP id s15-20020a170902ea0f00b0019d0c7a83dfso1097944plg.14
        for <kvmarm@lists.linux.dev>; Fri, 03 Mar 2023 01:02:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677834153;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zVx7liUtAHi9MlgajvxM1lPoJHO/9CA0IPkpax0IClE=;
        b=8J7xs+/y0jhSpO6cJy3U+8RApzrVrKXOsqZtv7VFNPTYJi7aTxJvskRxgRNZ2Vh7v+
         jgp4LEq3z8yMSooeNxBEJlBuhdBjGCZVk2/06FafHWbeQOmppS/fp9xclJDID3KRzv3F
         jIxAoxPI0WJ1fD8TOKiik2rpKnYZbprsKxQk55ULjbHPBlGWFeMzR+HmuYhPvDnOdbji
         /VMSiD6wcxnFlb4N49/aN8KRN/qe5OCu0V3rQ80GlHa3qMeGNQLJwekk0M87Ton3oNOU
         hqR/kw3COHGa+qXCtmLp0YvheX1EBRRUhQBYFq2RjEhFBb2SfoTPwx8QmVto852ij/gN
         AsAg==
X-Gm-Message-State: AO0yUKX1Po2ZXLZNKPLYrL/PNY4FmNOIbWP6i2li2jSgv1grKchAAoi5
	69eENXiqrYqXom2QlUnfAsmhKNV/qL37NffQwPCMuJDdPt8RRnobeO4Mswmw9KAyh4CgoaFwZAy
	99waQm4t1j9+4nExK
X-Received: by 2002:a05:6a20:4423:b0:cb:92d1:12fa with SMTP id ce35-20020a056a20442300b000cb92d112famr1914501pzb.5.1677834153652;
        Fri, 03 Mar 2023 01:02:33 -0800 (PST)
X-Google-Smtp-Source: AK7set+5f8FlHxnZmYaBGFOuhT0DGa9DRRHob6U6wIAnDZR5WSytvfvwZtYXLu8siMeoQ0u9unftjQ==
X-Received: by 2002:a05:6a20:4423:b0:cb:92d1:12fa with SMTP id ce35-20020a056a20442300b000cb92d112famr1914477pzb.5.1677834153361;
        Fri, 03 Mar 2023 01:02:33 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e18-20020a62aa12000000b00593cd0f37dcsm1058769pff.169.2023.03.03.01.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:02:32 -0800 (PST)
Message-ID: <55728b43-0d03-50e3-f76d-85fc9caacc59@redhat.com>
Date: Fri, 3 Mar 2023 17:02:25 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-4-ricarkol@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301210928.565562-4-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/23 05:09, Ricardo Koller wrote:
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
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 28 +++++++++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 46 ++++++++++++++++++++++++++++
>   2 files changed, 74 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index dcd3aafd3e6c..2b98357a5497 100644
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
> + * Returns an unlinked page-table tree. If @force_pte is true or
> + * @level is 2 (the PMD level), then the tree is mapped up to the
> + * PAGE_SIZE leaf PTE; the tree is mapped up one level otherwise.
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
> index 0a5ef9288371..3554b74e13c6 100644
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
> +	/* .addr (the IPA) is irrelevant for an unlinked table */
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
Shaoqin

