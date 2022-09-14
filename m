Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF86C6FA86
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 00:20:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 073414BC57;
	Tue, 13 Sep 2022 20:20:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bj2NZoa34Ot3; Tue, 13 Sep 2022 20:20:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B6A14BC51;
	Tue, 13 Sep 2022 20:20:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6741D4BC51
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 20:20:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J-SQCb7JZXaN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2022 20:20:17 -0400 (EDT)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFA8F4BC4B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 20:20:17 -0400 (EDT)
Received: by mail-pl1-f173.google.com with SMTP id f24so13479293plr.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 17:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=Qh1/s6M70qDgDeLcah8lIOeqDjJuG7SFaXNSDeF85IM=;
 b=hmnbcNQ3+hkMCTGJ/nShNJrdUAPB537RhF9GVtG4p8/BI7EYdGHrjC8Ug8ZuSsUqhU
 KKUGItY5hPPLm7tuQ2mDcJHY+oVu1uBXZ0KRYHntZfJouOy5Q92ITkK5R9/X9pK1ZY75
 fB/1O2HLHO9O3OnrzT5NZNDDdnia6qOX09dKbg3L9mga6duqANJSHD1ctAgzmNAuz24I
 giVgi0yddUf7+Eytcs2FOlC+N+Q3NXTI8zMXv8RlrZa1uueVgQNKq2sEaf4ujLvt/S9Q
 REXYQ+tJq4Rew4a6vmc7qt740OPm1E59FU1BKW1Sxgo/Pm5KTi4YyoDfu9z7MBM93sn5
 /yEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=Qh1/s6M70qDgDeLcah8lIOeqDjJuG7SFaXNSDeF85IM=;
 b=2auGxvhGquumjx+zpOg71f1omxk9MRRt2ue0LQrgPER+14NyTlv8yRW/qk1OrslwIR
 P5mYhgpzldwoCeXn5NqiQpvNK44fScM3igbFSlyDOIjswTA7dLncc/4HrznlN0iPZFul
 38sNhiwTsrfwzuc21arVG5/3XSW7vCJfoxF2vMesqXNE5I0/2NUvTuzvLw2qqpPVMEjp
 mcDkuPKAkajr2iI9kKdRa7tJsgDKYUbCzJHLlDgng6iD/PpneQFr9dWKABL/zllwvg72
 b0p5GeBDFwXrcl6SztKvKiWqVxqOHUxdyLE76FVEfEAG14KgtInOpSQ6DgPhnnZkT/u2
 uUbA==
X-Gm-Message-State: ACgBeo0dy6LVsGutNN9agAQF3WxTvo8sjADGA48RTJtTzPEwJ8oMgkDq
 a/qdyXCCUpLN2edecwLaCKvLSQ==
X-Google-Smtp-Source: AA6agR7JzRXYj4TvqMraV3xRI34hOtrIB2Jvj+p8BtFP0beIxXKZJTeBBYUFIxpu7QYTqmzydycRAg==
X-Received: by 2002:a17:903:234c:b0:178:1a7c:28a5 with SMTP id
 c12-20020a170903234c00b001781a7c28a5mr18615900plh.32.1663114816299; 
 Tue, 13 Sep 2022 17:20:16 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 k8-20020a170902c40800b00176a715653dsm9251820plk.145.2022.09.13.17.20.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 13 Sep 2022 17:20:15 -0700 (PDT)
Date: Tue, 13 Sep 2022 17:20:11 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 02/14] KVM: arm64: Tear down unlinked stage-2 subtree
 after break-before-make
Message-ID: <YyEeOxDndbEVHuxE@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220830194132.962932-3-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

Hi Oliver,

On Tue, Aug 30, 2022 at 07:41:20PM +0000, Oliver Upton wrote:
> The break-before-make sequence is a bit annoying as it opens a window
> wherein memory is unmapped from the guest. KVM should replace the PTE
> as quickly as possible and avoid unnecessary work in between.
> 
> Presently, the stage-2 map walker tears down a removed table before
> installing a block mapping when coalescing a table into a block. As the
> removed table is no longer visible to hardware walkers after the
> DSB+TLBI, it is possible to move the remaining cleanup to happen after
> installing the new PTE.
> 
> Reshuffle the stage-2 map walker to install the new block entry in
> the pre-order callback. Unwire all of the teardown logic and replace
> it with a call to kvm_pgtable_stage2_free_removed() after fixing
> the PTE. The post-order visitor is now completely unnecessary, so drop
> it. Finally, touch up the comments to better represent the now
> simplified map walker.
> 
> Note that the call to tear down the unlinked stage-2 is indirected
> as a subsequent change will use an RCU callback to trigger tear down.
> RCU is not available to pKVM, so there is a need to use different
> implementations on pKVM and non-pKVM VMs.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h  |  3 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  1 +
>  arch/arm64/kvm/hyp/pgtable.c          | 83 ++++++++-------------------
>  arch/arm64/kvm/mmu.c                  |  1 +
>  4 files changed, 28 insertions(+), 60 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index d71fb92dc913..c25633f53b2b 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -77,6 +77,8 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
>   *				allocation is physically contiguous.
>   * @free_pages_exact:		Free an exact number of memory pages previously
>   *				allocated by zalloc_pages_exact.
> + * @free_removed_table:		Free a removed paging structure by unlinking and
> + *				dropping references.
>   * @get_page:			Increment the refcount on a page.
>   * @put_page:			Decrement the refcount on a page. When the
>   *				refcount reaches 0 the page is automatically
> @@ -95,6 +97,7 @@ struct kvm_pgtable_mm_ops {
>  	void*		(*zalloc_page)(void *arg);
>  	void*		(*zalloc_pages_exact)(size_t size);
>  	void		(*free_pages_exact)(void *addr, size_t size);
> +	void		(*free_removed_table)(void *addr, u32 level, void *arg);
>  	void		(*get_page)(void *addr);
>  	void		(*put_page)(void *addr);
>  	int		(*page_count)(void *addr);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 1e78acf9662e..a930fdee6fce 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -93,6 +93,7 @@ static int prepare_s2_pool(void *pgt_pool_base)
>  	host_kvm.mm_ops = (struct kvm_pgtable_mm_ops) {
>  		.zalloc_pages_exact = host_s2_zalloc_pages_exact,
>  		.zalloc_page = host_s2_zalloc_page,
> +		.free_removed_table = kvm_pgtable_stage2_free_removed,
>  		.phys_to_virt = hyp_phys_to_virt,
>  		.virt_to_phys = hyp_virt_to_phys,
>  		.page_count = hyp_page_count,
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index d8127c25424c..5c0c8028d71c 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -763,17 +763,21 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  	return 0;
>  }
>  
> +static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +				struct stage2_map_data *data);
> +
>  static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  				     kvm_pte_t *ptep,
>  				     struct stage2_map_data *data)
>  {
> -	if (data->anchor)
> -		return 0;
> +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +	kvm_pte_t *childp = kvm_pte_follow(*ptep, mm_ops);
> +	struct kvm_pgtable *pgt = data->mmu->pgt;
> +	int ret;
>  
>  	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
>  		return 0;
>  
> -	data->childp = kvm_pte_follow(*ptep, data->mm_ops);
>  	kvm_clear_pte(ptep);
>  
>  	/*
> @@ -782,8 +786,13 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  	 * individually.
>  	 */
>  	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> -	data->anchor = ptep;
> -	return 0;
> +
> +	ret = stage2_map_walk_leaf(addr, end, level, ptep, data);

I think this always ends up calling stage2_map_walker_try_leaf() (at
least it should). In that case, I think it might be clearer to do so, as
the intention is to just install a block.

> +
> +	mm_ops->put_page(ptep);
> +	mm_ops->free_removed_table(childp, level + 1, pgt);

*old = *ptep;

> +
> +	return ret;
>  }
>  
>  static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> @@ -793,13 +802,6 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	kvm_pte_t *childp, pte = *ptep;
>  	int ret;
>  
> -	if (data->anchor) {
> -		if (stage2_pte_is_counted(pte))
> -			mm_ops->put_page(ptep);
> -
> -		return 0;
> -	}
> -
>  	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, data);
>  	if (ret != -E2BIG)
>  		return ret;
> @@ -828,50 +830,14 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	return 0;
>  }
>  
> -static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
> -				      kvm_pte_t *ptep,
> -				      struct stage2_map_data *data)
> -{
> -	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> -	kvm_pte_t *childp;
> -	int ret = 0;
> -
> -	if (!data->anchor)
> -		return 0;
> -
> -	if (data->anchor == ptep) {
> -		childp = data->childp;
> -		data->anchor = NULL;
> -		data->childp = NULL;
> -		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
> -	} else {
> -		childp = kvm_pte_follow(*ptep, mm_ops);
> -	}
> -
> -	mm_ops->put_page(childp);
> -	mm_ops->put_page(ptep);
> -
> -	return ret;
> -}
> -
>  /*
> - * This is a little fiddly, as we use all three of the walk flags. The idea
> - * is that the TABLE_PRE callback runs for table entries on the way down,
> - * looking for table entries which we could conceivably replace with a
> - * block entry for this mapping. If it finds one, then it sets the 'anchor'
> - * field in 'struct stage2_map_data' to point at the table entry, before
> - * clearing the entry to zero and descending into the now detached table.
> - *
> - * The behaviour of the LEAF callback then depends on whether or not the
> - * anchor has been set. If not, then we're not using a block mapping higher
> - * up the table and we perform the mapping at the existing leaves instead.
> - * If, on the other hand, the anchor _is_ set, then we drop references to
> - * all valid leaves so that the pages beneath the anchor can be freed.
> + * The TABLE_PRE callback runs for table entries on the way down, looking
> + * for table entries which we could conceivably replace with a block entry
> + * for this mapping. If it finds one it replaces the entry and calls
> + * kvm_pgtable_mm_ops::free_removed_table() to tear down the detached table.
>   *
> - * Finally, the TABLE_POST callback does nothing if the anchor has not
> - * been set, but otherwise frees the page-table pages while walking back up
> - * the page-table, installing the block entry when it revisits the anchor
> - * pointer and clearing the anchor to NULL.
> + * Otherwise, the LEAF callback performs the mapping at the existing leaves
> + * instead.
>   */
>  static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  			     enum kvm_pgtable_walk_flags flag, void * const arg)
> @@ -883,11 +849,9 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  		return stage2_map_walk_table_pre(addr, end, level, ptep, data);
>  	case KVM_PGTABLE_WALK_LEAF:
>  		return stage2_map_walk_leaf(addr, end, level, ptep, data);
> -	case KVM_PGTABLE_WALK_TABLE_POST:
> -		return stage2_map_walk_table_post(addr, end, level, ptep, data);
> +	default:
> +		return -EINVAL;

nice!

>  	}
> -
> -	return -EINVAL;
>  }
>  
>  int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> @@ -905,8 +869,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	struct kvm_pgtable_walker walker = {
>  		.cb		= stage2_map_walker,
>  		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
> -				  KVM_PGTABLE_WALK_LEAF |
> -				  KVM_PGTABLE_WALK_TABLE_POST,
> +				  KVM_PGTABLE_WALK_LEAF,
>  		.arg		= &map_data,
>  	};
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c9a13e487187..91521f4aab97 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -627,6 +627,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>  	.zalloc_page		= stage2_memcache_zalloc_page,
>  	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
>  	.free_pages_exact	= free_pages_exact,
> +	.free_removed_table	= kvm_pgtable_stage2_free_removed,
>  	.get_page		= kvm_host_get_page,
>  	.put_page		= kvm_host_put_page,
>  	.page_count		= kvm_host_page_count,
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
