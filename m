Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734AAC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 05:22:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECE6B4BA19;
	Thu, 10 Nov 2022 00:22:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gBqkKLWV9vID; Thu, 10 Nov 2022 00:22:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F2914BA76;
	Thu, 10 Nov 2022 00:22:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38DC34BA19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 00:22:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RKM5x7va4ffx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 00:22:20 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A347D4BA17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 00:22:20 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1668057740;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ONd34WmAiFDQgEU0HoLzYYbUoed/Yd6ZgPsuQfFMgko=;
 b=TDpA3sCowaaqVfHQyqvf/WhjjPT30F83ScNGG0SkG51Lqk+/nCcEVGR70rfqZI5xGdJNf+
 xP/R55miJJF4ENXVuDIWI+UiKfR39JM/nuL3HFLTxFzekTpwjng4BTjme4VgCu/QzBTkxa
 /C+jmkQCo9CEnnaCwMReDUKKbaDFLHw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-3VmQ2mPLNdufCmSkUPr_qQ-1; Thu, 10 Nov 2022 00:22:16 -0500
X-MC-Unique: 3VmQ2mPLNdufCmSkUPr_qQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D145B101A528;
 Thu, 10 Nov 2022 05:22:15 +0000 (UTC)
Received: from [10.64.54.49] (vpn2-54-49.bne.redhat.com [10.64.54.49])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 55D4F40C6F73;
 Thu, 10 Nov 2022 05:22:10 +0000 (UTC)
Subject: Re: [PATCH v5 03/14] KVM: arm64: Pass mm_ops through the visitor
 context
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-4-oliver.upton@linux.dev>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <a8b662f4-327a-3be8-442f-177c9ff05273@redhat.com>
Date: Thu, 10 Nov 2022 13:22:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20221107215644.1895162-4-oliver.upton@linux.dev>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Oliver,

On 11/8/22 5:56 AM, Oliver Upton wrote:
> As a prerequisite for getting visitors off of struct kvm_pgtable, pass
> mm_ops through the visitor context.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h |  1 +
>   arch/arm64/kvm/hyp/nvhe/setup.c      |  3 +-
>   arch/arm64/kvm/hyp/pgtable.c         | 63 +++++++++++-----------------
>   3 files changed, 26 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 14d4b68a1e92..a752793482cb 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -203,6 +203,7 @@ struct kvm_pgtable_visit_ctx {
>   	kvm_pte_t				*ptep;
>   	kvm_pte_t				old;
>   	void					*arg;
> +	struct kvm_pgtable_mm_ops		*mm_ops;
>   	u64					addr;
>   	u64					end;
>   	u32					level;
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 6af443c9d78e..1068338d77f3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -189,7 +189,7 @@ static void hpool_put_page(void *addr)
>   static int finalize_host_mappings_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   					 enum kvm_pgtable_walk_flags visit)
>   {
> -	struct kvm_pgtable_mm_ops *mm_ops = ctx->arg;
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>   	enum kvm_pgtable_prot prot;
>   	enum pkvm_page_state state;
>   	phys_addr_t phys;
> @@ -239,7 +239,6 @@ static int finalize_host_mappings(void)
>   	struct kvm_pgtable_walker walker = {
>   		.cb	= finalize_host_mappings_walker,
>   		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
> -		.arg	= pkvm_pgtable.mm_ops,
>   	};
>   	int i, ret;
>   
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index fb3696b3a997..db25e81a9890 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -181,9 +181,10 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
>   }
>   
>   static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> -			      kvm_pte_t *pgtable, u32 level);
> +			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level);
>   
>   static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> +				      struct kvm_pgtable_mm_ops *mm_ops,
>   				      kvm_pte_t *ptep, u32 level)
>   {
>   	enum kvm_pgtable_walk_flags flags = data->walker->flags;
> @@ -191,6 +192,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>   		.ptep	= ptep,
>   		.old	= READ_ONCE(*ptep),
>   		.arg	= data->walker->arg,
> +		.mm_ops	= mm_ops,
>   		.addr	= data->addr,
>   		.end	= data->end,
>   		.level	= level,

I don't understand why we need @mm_ops argument for this function:

   - @mm_ops is always fetched from the associated page table struct.
     (data->pgt->mm_ops) in upper layer (_kvm_pgtable_walk()). However,
     the argument starts to be used in lower layer (__kvm_pgtable_visit()),
     meaning the argument isn't needed by the upper layers.

   - @mm_ops isn't need by __kvm_pgtable_walk(). So the argument isn't needed by the
     function.


> @@ -218,8 +220,8 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>   		goto out;
>   	}
>   
> -	childp = kvm_pte_follow(ctx.old, data->pgt->mm_ops);
> -	ret = __kvm_pgtable_walk(data, childp, level + 1);
> +	childp = kvm_pte_follow(ctx.old, mm_ops);
> +	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
>   	if (ret)
>   		goto out;
>   
> @@ -231,7 +233,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>   }
>   
>   static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> -			      kvm_pte_t *pgtable, u32 level)
> +			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level)
>   {
>   	u32 idx;
>   	int ret = 0;
> @@ -245,7 +247,7 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
>   		if (data->addr >= data->end)
>   			break;
>   
> -		ret = __kvm_pgtable_visit(data, ptep, level);
> +		ret = __kvm_pgtable_visit(data, mm_ops, ptep, level);
>   		if (ret)
>   			break;
>   	}
> @@ -269,7 +271,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
>   	for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
>   		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
>   
> -		ret = __kvm_pgtable_walk(data, ptep, pgt->start_level);
> +		ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
>   		if (ret)
>   			break;
>   	}

As I mentioned above, @mm_ops isn't needed by __kvm_pgtable_walk() and __kvm_pgtable_visit()
can fetch it directly from data->pgtable->mm_ops.

> @@ -332,7 +334,6 @@ int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
>   struct hyp_map_data {
>   	u64				phys;
>   	kvm_pte_t			attr;
> -	struct kvm_pgtable_mm_ops	*mm_ops;
>   };
>   
>   static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
> @@ -400,7 +401,7 @@ static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>   	if (ctx->old == new)
>   		return true;
>   	if (!kvm_pte_valid(ctx->old))
> -		data->mm_ops->get_page(ctx->ptep);
> +		ctx->mm_ops->get_page(ctx->ptep);
>   	else if (WARN_ON((ctx->old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW))
>   		return false;
>   
> @@ -413,7 +414,7 @@ static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   {
>   	kvm_pte_t *childp;
>   	struct hyp_map_data *data = ctx->arg;
> -	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>   
>   	if (hyp_map_walker_try_leaf(ctx, data))
>   		return 0;
> @@ -436,7 +437,6 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
>   	int ret;
>   	struct hyp_map_data map_data = {
>   		.phys	= ALIGN_DOWN(phys, PAGE_SIZE),
> -		.mm_ops	= pgt->mm_ops,
>   	};
>   	struct kvm_pgtable_walker walker = {
>   		.cb	= hyp_map_walker,
> @@ -454,18 +454,13 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
>   	return ret;
>   }
>   
> -struct hyp_unmap_data {
> -	u64				unmapped;
> -	struct kvm_pgtable_mm_ops	*mm_ops;
> -};
> -
>   static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   			    enum kvm_pgtable_walk_flags visit)
>   {
>   	kvm_pte_t *childp = NULL;
>   	u64 granule = kvm_granule_size(ctx->level);
> -	struct hyp_unmap_data *data = ctx->arg;
> -	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +	u64 *unmapped = ctx->arg;
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>   
>   	if (!kvm_pte_valid(ctx->old))
>   		return -EINVAL;
> @@ -486,7 +481,7 @@ static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   		kvm_clear_pte(ctx->ptep);
>   		dsb(ishst);
>   		__tlbi_level(vale2is, __TLBI_VADDR(ctx->addr, 0), ctx->level);
> -		data->unmapped += granule;
> +		*unmapped += granule;
>   	}
>   
>   	dsb(ish);
> @@ -501,12 +496,10 @@ static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   
>   u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>   {
> -	struct hyp_unmap_data unmap_data = {
> -		.mm_ops	= pgt->mm_ops,
> -	};
> +	u64 unmapped = 0;
>   	struct kvm_pgtable_walker walker = {
>   		.cb	= hyp_unmap_walker,
> -		.arg	= &unmap_data,
> +		.arg	= &unmapped,
>   		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
>   	};
>   
> @@ -514,7 +507,7 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>   		return 0;
>   
>   	kvm_pgtable_walk(pgt, addr, size, &walker);
> -	return unmap_data.unmapped;
> +	return unmapped;
>   }
>   
>   int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
> @@ -538,7 +531,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
>   static int hyp_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   			   enum kvm_pgtable_walk_flags visit)
>   {
> -	struct kvm_pgtable_mm_ops *mm_ops = ctx->arg;
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>   
>   	if (!kvm_pte_valid(ctx->old))
>   		return 0;
> @@ -556,7 +549,6 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
>   	struct kvm_pgtable_walker walker = {
>   		.cb	= hyp_free_walker,
>   		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
> -		.arg	= pgt->mm_ops,
>   	};
>   
>   	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
> @@ -575,8 +567,6 @@ struct stage2_map_data {
>   	struct kvm_s2_mmu		*mmu;
>   	void				*memcache;
>   
> -	struct kvm_pgtable_mm_ops	*mm_ops;
> -
>   	/* Force mappings to page granularity */
>   	bool				force_pte;
>   };
> @@ -725,7 +715,7 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>   	kvm_pte_t new;
>   	u64 granule = kvm_granule_size(ctx->level), phys = data->phys;
>   	struct kvm_pgtable *pgt = data->mmu->pgt;
> -	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>   
>   	if (!stage2_leaf_mapping_allowed(ctx, data))
>   		return -E2BIG;
> @@ -773,7 +763,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>   	if (!stage2_leaf_mapping_allowed(ctx, data))
>   		return 0;
>   
> -	data->childp = kvm_pte_follow(ctx->old, data->mm_ops);
> +	data->childp = kvm_pte_follow(ctx->old, ctx->mm_ops);
>   	kvm_clear_pte(ctx->ptep);
>   
>   	/*
> @@ -789,7 +779,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>   static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>   				struct stage2_map_data *data)
>   {
> -	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>   	kvm_pte_t *childp;
>   	int ret;
>   
> @@ -831,7 +821,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>   static int stage2_map_walk_table_post(const struct kvm_pgtable_visit_ctx *ctx,
>   				      struct stage2_map_data *data)
>   {
> -	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>   	kvm_pte_t *childp;
>   	int ret = 0;
>   
> @@ -898,7 +888,6 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   		.phys		= ALIGN_DOWN(phys, PAGE_SIZE),
>   		.mmu		= pgt->mmu,
>   		.memcache	= mc,
> -		.mm_ops		= pgt->mm_ops,
>   		.force_pte	= pgt->force_pte_cb && pgt->force_pte_cb(addr, addr + size, prot),
>   	};
>   	struct kvm_pgtable_walker walker = {
> @@ -929,7 +918,6 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   		.phys		= KVM_PHYS_INVALID,
>   		.mmu		= pgt->mmu,
>   		.memcache	= mc,
> -		.mm_ops		= pgt->mm_ops,
>   		.owner_id	= owner_id,
>   		.force_pte	= true,
>   	};
> @@ -953,7 +941,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   {
>   	struct kvm_pgtable *pgt = ctx->arg;
>   	struct kvm_s2_mmu *mmu = pgt->mmu;
> -	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>   	kvm_pte_t *childp = NULL;
>   	bool need_flush = false;
>   
> @@ -1007,7 +995,6 @@ struct stage2_attr_data {
>   	kvm_pte_t			attr_clr;
>   	kvm_pte_t			pte;
>   	u32				level;
> -	struct kvm_pgtable_mm_ops	*mm_ops;
>   };
>   
>   static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
> @@ -1015,7 +1002,7 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   {
>   	kvm_pte_t pte = ctx->old;
>   	struct stage2_attr_data *data = ctx->arg;
> -	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>   
>   	if (!kvm_pte_valid(ctx->old))
>   		return 0;
> @@ -1055,7 +1042,6 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>   	struct stage2_attr_data data = {
>   		.attr_set	= attr_set & attr_mask,
>   		.attr_clr	= attr_clr & attr_mask,
> -		.mm_ops		= pgt->mm_ops,
>   	};
>   	struct kvm_pgtable_walker walker = {
>   		.cb		= stage2_attr_walker,
> @@ -1198,7 +1184,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   			      enum kvm_pgtable_walk_flags visit)
>   {
> -	struct kvm_pgtable_mm_ops *mm_ops = ctx->arg;
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>   
>   	if (!stage2_pte_is_counted(ctx->old))
>   		return 0;
> @@ -1218,7 +1204,6 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>   		.cb	= stage2_free_walker,
>   		.flags	= KVM_PGTABLE_WALK_LEAF |
>   			  KVM_PGTABLE_WALK_TABLE_POST,
> -		.arg	= pgt->mm_ops,
>   	};
>   
>   	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
