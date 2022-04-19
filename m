Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EE0C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 02:59:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFBBA404CD;
	Mon, 18 Apr 2022 22:59:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QtE+jd1mLHCv; Mon, 18 Apr 2022 22:59:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2F4149E43;
	Mon, 18 Apr 2022 22:59:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E3574045D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 22:59:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zIRZqqqDvE17 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Apr 2022 22:59:09 -0400 (EDT)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F1C049E43
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 22:59:09 -0400 (EDT)
Received: by mail-pj1-f50.google.com with SMTP id
 o5-20020a17090ad20500b001ca8a1dc47aso1008994pju.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 19:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=30NANpb3guTm1HkD//0Tkz7Tq5iFV9a0M+tAkNM4TWs=;
 b=JS0LYWd264sdPP0im2qroeF3UNRJDPbQxx5AupfOvNQcNsmYIum94UShXY+1Dm82ty
 DtmTeGsoeXl6m6eicjCJdIPSrR9q9bhgLp7DkiYnNHZUEsyyJEF+x605mRYPJ8K5FZFE
 AvIGYytIBWxhIjh0lOLyy7dWwYotioEXAC/ymK2/aJC/Sgd1IK/Fp7DqrHlPOmm7MRDZ
 NYStwJNVPIKQaY9ZmumBlbWBQwJc6ig5n/TZAMeJtVRq/oGOfnAmaYFx9BFemm/SDX6w
 jFmoI73Kviie4w362RBe4oQrvSTPh5dMJdZFs4vBDw/NYkdV4ghZUaSfKJobaVoqW2HT
 7+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=30NANpb3guTm1HkD//0Tkz7Tq5iFV9a0M+tAkNM4TWs=;
 b=mNQ5hDyshkUrpBcqe+oteAt4ND7zqJGnrD2b+6PI4uni4aKbTWfenHu+KxnXIWBRpA
 3Lcj9KNIDOXyHfc0tJHELuIOxiuhMPCgEDZejRDmoyYg1Yc92GHUSoZcFBB1JehwqhBb
 zgZzdPSBH8IRB0xQkR/HZb5+U0SUeua+fPX4eK4wRM5h/SmzB1Ve0coQA7Ksum4UCBSR
 u99Ef0lEgNc81Ukta2UCrftsRGTSCxwQT8cJc/kuSCycS0XkS7b8sFwDdEskaHP0bsqY
 E7PLuhYash3FkNn4SOfJH6vPYimyhj8or4AVnDxsrKxiFV0WAVbsNV43lAXYhrauK80o
 VQpg==
X-Gm-Message-State: AOAM5306PRWsv5sO8VKg1errWMfaIHwPgtqqpeH0iE55dcLDrfR4ezF2
 OH3O3FDEMX3xbCVf1sQU4Johmg==
X-Google-Smtp-Source: ABdhPJw5CAB26DaIZpb1eUhrO6l65kWcbXnQD0G590D5PH0Cb7PbrlfSpJvtab8bxxwq5s1ouUj3bw==
X-Received: by 2002:a17:903:2cb:b0:14f:4fb6:2fb0 with SMTP id
 s11-20020a17090302cb00b0014f4fb62fb0mr13505483plk.172.1650337148366; 
 Mon, 18 Apr 2022 19:59:08 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 q4-20020a17090a7a8400b001cd4a0c3270sm13901593pjf.7.2022.04.18.19.59.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Apr 2022 19:59:07 -0700 (PDT)
Date: Mon, 18 Apr 2022 19:59:04 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [RFC PATCH 14/17] KVM: arm64: Punt last page reference to rcu
 callback for parallel walk
Message-ID: <Yl4leEoIg+dr/1QM@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-15-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220415215901.1737897-15-oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Apr 15, 2022 at 09:58:58PM +0000, Oliver Upton wrote:
> It is possible that a table page remains visible to another thread until
> the next rcu synchronization event. To that end, we cannot drop the last
> page reference synchronous with post-order traversal for a parallel
> table walk.
> 
> Schedule an rcu callback to clean up the child table page for parallel
> walks.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  3 ++
>  arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++--
>  arch/arm64/kvm/mmu.c                 | 44 +++++++++++++++++++++++++++-
>  3 files changed, 67 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 74955aba5918..52e55e00f0ca 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -81,6 +81,8 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
>   * @put_page:			Decrement the refcount on a page. When the
>   *				refcount reaches 0 the page is automatically
>   *				freed.
> + * @free_table:			Drop the last page reference, possibly in the
> + *				next RCU sync if doing a shared walk.
>   * @page_count:			Return the refcount of a page.
>   * @phys_to_virt:		Convert a physical address into a virtual
>   *				address	mapped in the current context.
> @@ -98,6 +100,7 @@ struct kvm_pgtable_mm_ops {
>  	void		(*get_page)(void *addr);
>  	void		(*put_page)(void *addr);
>  	int		(*page_count)(void *addr);
> +	void		(*free_table)(void *addr, bool shared);
>  	void*		(*phys_to_virt)(phys_addr_t phys);
>  	phys_addr_t	(*virt_to_phys)(void *addr);
>  	void		(*dcache_clean_inval_poc)(void *addr, size_t size);
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 121818d4c33e..a9a48edba63b 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -147,12 +147,19 @@ static inline void kvm_pgtable_walk_end(void)
>  {}
>  
>  #define kvm_dereference_ptep	rcu_dereference_raw
> +
> +static inline void kvm_pgtable_destroy_barrier(void)
> +{}
> +
>  #else
>  #define kvm_pgtable_walk_begin	rcu_read_lock
>  
>  #define kvm_pgtable_walk_end	rcu_read_unlock
>  
>  #define kvm_dereference_ptep	rcu_dereference
> +
> +#define kvm_pgtable_destroy_barrier	rcu_barrier
> +
>  #endif
>  
>  static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
> @@ -1063,7 +1070,12 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
>  		childp = kvm_pte_follow(*old, mm_ops);
>  	}
>  
> -	mm_ops->put_page(childp);
> +	/*
> +	 * If we do not have exclusive access to the page tables it is possible
> +	 * the unlinked table remains visible to another thread until the next
> +	 * rcu synchronization.
> +	 */
> +	mm_ops->free_table(childp, shared);
>  	mm_ops->put_page(ptep);
>  
>  	return ret;
> @@ -1203,7 +1215,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  					       kvm_granule_size(level));
>  
>  	if (childp)
> -		mm_ops->put_page(childp);
> +		mm_ops->free_table(childp, shared);
>  
>  	return 0;
>  }
> @@ -1433,7 +1445,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	mm_ops->put_page(ptep);
>  
>  	if (kvm_pte_table(*old, level))
> -		mm_ops->put_page(kvm_pte_follow(*old, mm_ops));
> +		mm_ops->free_table(kvm_pte_follow(*old, mm_ops), shared);
>  
>  	return 0;
>  }
> @@ -1452,4 +1464,10 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>  	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
>  	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
>  	pgt->pgd = NULL;
> +
> +	/*
> +	 * Guarantee that all unlinked subtrees associated with the stage2 page
> +	 * table have also been freed before returning.
> +	 */
> +	kvm_pgtable_destroy_barrier();
>  }
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index cc6ed6b06ec2..6ecf37009c21 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -98,9 +98,50 @@ static bool kvm_is_device_pfn(unsigned long pfn)
>  static void *stage2_memcache_zalloc_page(void *arg)
>  {
>  	struct kvm_mmu_caches *mmu_caches = arg;
> +	struct stage2_page_header *hdr;
> +	void *addr;
>  
>  	/* Allocated with __GFP_ZERO, so no need to zero */
> -	return kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
> +	addr = kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
> +	if (!addr)
> +		return NULL;
> +
> +	hdr = kvm_mmu_memory_cache_alloc(&mmu_caches->header_cache);
> +	if (!hdr) {
> +		free_page((unsigned long)addr);
> +		return NULL;
> +	}
> +
> +	hdr->page = virt_to_page(addr);
> +	set_page_private(hdr->page, (unsigned long)hdr);
> +	return addr;
> +}
> +
> +static void stage2_free_page_now(struct stage2_page_header *hdr)
> +{
> +	WARN_ON(page_ref_count(hdr->page) != 1);
> +
> +	__free_page(hdr->page);
> +	kmem_cache_free(stage2_page_header_cache, hdr);
> +}
> +
> +static void stage2_free_page_rcu_cb(struct rcu_head *head)
> +{
> +	struct stage2_page_header *hdr = container_of(head, struct stage2_page_header,
> +						      rcu_head);
> +
> +	stage2_free_page_now(hdr);
> +}
> +
> +static void stage2_free_table(void *addr, bool shared)
> +{
> +	struct page *page = virt_to_page(addr);
> +	struct stage2_page_header *hdr = (struct stage2_page_header *)page_private(page);
> +
> +	if (shared)
> +		call_rcu(&hdr->rcu_head, stage2_free_page_rcu_cb);

Can the number of callbacks grow to "dangerous" numbers? can it be
bounded with something like the following?

if number of readers is really high:
	synchronize_rcu() 
else
	call_rcu()

maybe the rcu API has an option for that.

> +	else
> +		stage2_free_page_now(hdr);
>  }
>  
>  static void *kvm_host_zalloc_pages_exact(size_t size)
> @@ -613,6 +654,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>  	.free_pages_exact	= free_pages_exact,
>  	.get_page		= kvm_host_get_page,
>  	.put_page		= kvm_host_put_page,
> +	.free_table		= stage2_free_table,
>  	.page_count		= kvm_host_page_count,
>  	.phys_to_virt		= kvm_host_va,
>  	.virt_to_phys		= kvm_host_pa,
> -- 
> 2.36.0.rc0.470.gd361397f0d-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
