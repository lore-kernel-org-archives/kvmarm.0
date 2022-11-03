Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35BCC4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 21:42:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13A374B0BA;
	Thu,  3 Nov 2022 17:42:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 78oJ6z0ABEi1; Thu,  3 Nov 2022 17:42:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 868F249F3F;
	Thu,  3 Nov 2022 17:42:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD5C749ECB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 17:42:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zr4dAbYN89wk for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 17:42:18 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 152FF48FA4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 17:42:17 -0400 (EDT)
Date: Thu, 3 Nov 2022 21:42:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1667511736;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=w8AWXsnPXVcjSchhyDozT4RxZUh9AGuFIXlFP6gfWD8=;
 b=HcCECZDjlEMZnQvdIn2Df4iIweuClpiefBFvzUqwqlNDmk64Oa1e4LT3b+qQD6C6DxOdFw
 +pksoMG0U5mBrFIdgMN9K5Nud1gJ0dwcSngXMh/EEpkRjENljGkgowfFQLbPMQt1GB4UKR
 xGCXJrerDZyZY5sRoUxZXxCfzpU7m8k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 07/14] KVM: arm64: Tear down unlinked stage-2 subtree
 after break-before-make
Message-ID: <Y2Q1s+Z5ldHEhNsv@google.com>
References: <20221103091140.1040433-1-oliver.upton@linux.dev>
 <20221103091140.1040433-8-oliver.upton@linux.dev>
 <Y2QzFHTDa2aJbRNf@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y2QzFHTDa2aJbRNf@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Nov 03, 2022 at 02:31:00PM -0700, Ricardo Koller wrote:
> On Thu, Nov 03, 2022 at 09:11:33AM +0000, Oliver Upton wrote:
> > The break-before-make sequence is a bit annoying as it opens a window
> > wherein memory is unmapped from the guest. KVM should replace the PTE
> > as quickly as possible and avoid unnecessary work in between.
> > 
> > Presently, the stage-2 map walker tears down a removed table before
> > installing a block mapping when coalescing a table into a block. As the
> > removed table is no longer visible to hardware walkers after the
> > DSB+TLBI, it is possible to move the remaining cleanup to happen after
> > installing the new PTE.
> > 
> > Reshuffle the stage-2 map walker to install the new block entry in
> > the pre-order callback. Unwire all of the teardown logic and replace
> > it with a call to kvm_pgtable_stage2_free_removed() after fixing
> > the PTE. The post-order visitor is now completely unnecessary, so drop
> > it. Finally, touch up the comments to better represent the now
> > simplified map walker.
> > 
> > Note that the call to tear down the unlinked stage-2 is indirected
> > as a subsequent change will use an RCU callback to trigger tear down.
> > RCU is not available to pKVM, so there is a need to use different
> > implementations on pKVM and non-pKVM VMs.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h  |  3 +
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 ++
> >  arch/arm64/kvm/hyp/pgtable.c          | 83 +++++++--------------------
> >  arch/arm64/kvm/mmu.c                  |  8 +++
> >  4 files changed, 38 insertions(+), 62 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index cbd2851eefc1..e70cf57b719e 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -92,6 +92,8 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
> >   *				allocation is physically contiguous.
> >   * @free_pages_exact:		Free an exact number of memory pages previously
> >   *				allocated by zalloc_pages_exact.
> > + * @free_removed_table:		Free a removed paging structure by unlinking and
> > + *				dropping references.
> >   * @get_page:			Increment the refcount on a page.
> >   * @put_page:			Decrement the refcount on a page. When the
> >   *				refcount reaches 0 the page is automatically
> > @@ -110,6 +112,7 @@ struct kvm_pgtable_mm_ops {
> >  	void*		(*zalloc_page)(void *arg);
> >  	void*		(*zalloc_pages_exact)(size_t size);
> >  	void		(*free_pages_exact)(void *addr, size_t size);
> > +	void		(*free_removed_table)(void *addr, u32 level);
> >  	void		(*get_page)(void *addr);
> >  	void		(*put_page)(void *addr);
> >  	int		(*page_count)(void *addr);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index d21d1b08a055..735769886b55 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -79,6 +79,11 @@ static void host_s2_put_page(void *addr)
> >  	hyp_put_page(&host_s2_pool, addr);
> >  }
> >  
> > +static void host_s2_free_removed_table(void *addr, u32 level)
> > +{
> > +	kvm_pgtable_stage2_free_removed(&host_kvm.mm_ops, addr, level);
> > +}
> > +
> >  static int prepare_s2_pool(void *pgt_pool_base)
> >  {
> >  	unsigned long nr_pages, pfn;
> > @@ -93,6 +98,7 @@ static int prepare_s2_pool(void *pgt_pool_base)
> >  	host_kvm.mm_ops = (struct kvm_pgtable_mm_ops) {
> >  		.zalloc_pages_exact = host_s2_zalloc_pages_exact,
> >  		.zalloc_page = host_s2_zalloc_page,
> > +		.free_removed_table = host_s2_free_removed_table,
> >  		.phys_to_virt = hyp_phys_to_virt,
> >  		.virt_to_phys = hyp_virt_to_phys,
> >  		.page_count = hyp_page_count,
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 7511494537e5..de8a2e1c7435 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -750,13 +750,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >  static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
> >  				     struct stage2_map_data *data)
> >  {
> > -	if (data->anchor)
> > -		return 0;
> > +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > +	kvm_pte_t *childp = kvm_pte_follow(ctx->old, mm_ops);
> > +	int ret;
> >  
> >  	if (!stage2_leaf_mapping_allowed(ctx, data))
> >  		return 0;
> >  
> > -	data->childp = kvm_pte_follow(ctx->old, ctx->mm_ops);
> >  	kvm_clear_pte(ctx->ptep);
> >  
> >  	/*
> > @@ -765,8 +765,13 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
> >  	 * individually.
> >  	 */
> >  	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> > -	data->anchor = ctx->ptep;
> > -	return 0;
> > +
> > +	ret = stage2_map_walker_try_leaf(ctx, data);
> > +
> > +	mm_ops->put_page(ctx->ptep);
> > +	mm_ops->free_removed_table(childp, ctx->level + 1);
> 
> I think "level + 1" ends up using the wrong granule size.  For example, if we
> were at level 1 where granule is 1G, we should be freeing everything between
> addr and addr+1G. But, the "level + 1" ends up freeing only between addr and
> addr+2M.

Ouch! Great catch.

> Specifically, IIUC, this should be like this:
> 
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -858,7 +858,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>         if (ret)
>                 return ret;
>  
> -       mm_ops->free_removed_table(childp, ctx->level + 1);
> +       mm_ops->free_removed_table(childp, ctx->level);
>         return 0;
>  }
> 
> @@ -1396,5 +1411,5 @@ void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pg
>                 .end    = kvm_granule_size(level),
>         };
>  
> -       WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level));
> +       WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level + 1));

LGTM, I'll squash this in.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
