Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D817FC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:52:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9435E4BB03;
	Thu, 10 Nov 2022 09:52:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yquyFJ29IiSP; Thu, 10 Nov 2022 09:52:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69BA94BB51;
	Thu, 10 Nov 2022 09:51:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 887F24BA1F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:24:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nvikl5fjJ1hN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 17:24:22 -0500 (EST)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com
 [209.85.219.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0336D4BA1E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:24:21 -0500 (EST)
Received: by mail-qv1-f46.google.com with SMTP id mi9so227601qvb.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Nov 2022 14:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=h32GIp2TyxwvjVu+2SQ83F1Prpl+ZGMT6rZjLmybtZY=;
 b=P1w2sGPNEwYRsqKy/ihzaTBJLDCx1tctjHCt9jOc4E6rG5NYczhw37H/r9PljpZnZf
 T1RFofgYhg24tQZ/qe2s+grHPIYpBP4wt/bgYeLa+ATF3vI4bAD3RY6qb4+O7C59wBa8
 0edksoB4WwUSm3pqAJCrxL5VMKlvEA/qoenTmdOB1xWjZsHAZeIn/jZiAi+pOpMddhJV
 6gqSQtFtXuw1/DbyC1eRw1Qo8S7cAWuwSqKufcaYFN7ytp6Zjrc3KzkMdIg0xoUWK0AS
 mhiVn5S3uuFm8DaLkxqAZLA0z6Tti7vTh3tRSRu5+Zc4l4+pSA9iq7O3jX9rtjI2aUQo
 8K1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=h32GIp2TyxwvjVu+2SQ83F1Prpl+ZGMT6rZjLmybtZY=;
 b=Kq5ABjwl3ENjDW5AoCOu4CCfXif91ybJ/V9vhkQn+E9WKzU1R3MCWuDMUPB0bQ8rUT
 1PDsWBYtLyX3M69TgnbP9R6Pl6oVw1fdfd+GUYZqVmCoUZ/SfbSeTlmtoafo86CIiAAH
 NJuyJ9Q9XOiiQHyIu3JVvJir22eY7+UqkRRl51Ppz5S6+G2y53T3wChNsczuqi98CZMD
 24uPwoG4ZoKMdyErETouk/LLf0EKJ3vHu+6HFcbhcluRBvh3lpcv93QNiieytnVLzgnz
 HIcdVFV4D4ZjBa2bYhX7FU5yW/YPD7ztOaKkejdFtziMzV/AbF5f/BbJ2DWsUKfjKowx
 3nkg==
X-Gm-Message-State: ACrzQf0Tk2OBhzKeOHg4RiDSCBhFAUEBwpvZmyvMvoFEKA1v/uv6cLZ8
 VExrdYP2mbzUgvXJBgzdvmjs5OAA80vZiFn2KV3w3Q==
X-Google-Smtp-Source: AMsMyM4lBt6bdl9r3XMsWJy2Ks6Q4XduFtpy4Dxr8K+RUnzDZ+GL+osXxEdej3L2mbzaBJNVf+NRJPfjGPDYWbflUaY=
X-Received: by 2002:a05:6214:21a6:b0:4bb:85b4:fd96 with SMTP id
 t6-20020a05621421a600b004bb85b4fd96mr56194197qvc.28.1668032661440; Wed, 09
 Nov 2022 14:24:21 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-8-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-8-oliver.upton@linux.dev>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 14:24:10 -0800
Message-ID: <CANgfPd9ibkmn5Gvbbjv3E_gPh0iLVzQYYsBqMsEWCduucxGxsQ@mail.gmail.com>
Subject: Re: [PATCH v5 07/14] KVM: arm64: Tear down unlinked stage-2 subtree
 after break-before-make
To: Oliver Upton <oliver.upton@linux.dev>
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
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

On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
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

That anchor scheme is complicated. Glad to see it removed in favor of this.
Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/arm64/include/asm/kvm_pgtable.h  |  3 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 ++
>  arch/arm64/kvm/hyp/pgtable.c          | 85 +++++++--------------------
>  arch/arm64/kvm/mmu.c                  |  8 +++
>  4 files changed, 39 insertions(+), 63 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index cbd2851eefc1..e70cf57b719e 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -92,6 +92,8 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
>   *                             allocation is physically contiguous.
>   * @free_pages_exact:          Free an exact number of memory pages previously
>   *                             allocated by zalloc_pages_exact.
> + * @free_removed_table:                Free a removed paging structure by unlinking and
> + *                             dropping references.
>   * @get_page:                  Increment the refcount on a page.
>   * @put_page:                  Decrement the refcount on a page. When the
>   *                             refcount reaches 0 the page is automatically
> @@ -110,6 +112,7 @@ struct kvm_pgtable_mm_ops {
>         void*           (*zalloc_page)(void *arg);
>         void*           (*zalloc_pages_exact)(size_t size);
>         void            (*free_pages_exact)(void *addr, size_t size);
> +       void            (*free_removed_table)(void *addr, u32 level);
>         void            (*get_page)(void *addr);
>         void            (*put_page)(void *addr);
>         int             (*page_count)(void *addr);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index d21d1b08a055..735769886b55 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -79,6 +79,11 @@ static void host_s2_put_page(void *addr)
>         hyp_put_page(&host_s2_pool, addr);
>  }
>
> +static void host_s2_free_removed_table(void *addr, u32 level)
> +{
> +       kvm_pgtable_stage2_free_removed(&host_kvm.mm_ops, addr, level);
> +}
> +
>  static int prepare_s2_pool(void *pgt_pool_base)
>  {
>         unsigned long nr_pages, pfn;
> @@ -93,6 +98,7 @@ static int prepare_s2_pool(void *pgt_pool_base)
>         host_kvm.mm_ops = (struct kvm_pgtable_mm_ops) {
>                 .zalloc_pages_exact = host_s2_zalloc_pages_exact,
>                 .zalloc_page = host_s2_zalloc_page,
> +               .free_removed_table = host_s2_free_removed_table,
>                 .phys_to_virt = hyp_phys_to_virt,
>                 .virt_to_phys = hyp_virt_to_phys,
>                 .page_count = hyp_page_count,
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 7511494537e5..7c9782347570 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -750,13 +750,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>                                      struct stage2_map_data *data)
>  {
> -       if (data->anchor)
> -               return 0;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +       kvm_pte_t *childp = kvm_pte_follow(ctx->old, mm_ops);
> +       int ret;
>
>         if (!stage2_leaf_mapping_allowed(ctx, data))
>                 return 0;
>
> -       data->childp = kvm_pte_follow(ctx->old, ctx->mm_ops);
>         kvm_clear_pte(ctx->ptep);
>
>         /*
> @@ -765,8 +765,13 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>          * individually.
>          */
>         kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> -       data->anchor = ctx->ptep;
> -       return 0;
> +
> +       ret = stage2_map_walker_try_leaf(ctx, data);
> +
> +       mm_ops->put_page(ctx->ptep);
> +       mm_ops->free_removed_table(childp, ctx->level);
> +
> +       return ret;
>  }
>
>  static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> @@ -776,13 +781,6 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         kvm_pte_t *childp;
>         int ret;
>
> -       if (data->anchor) {
> -               if (stage2_pte_is_counted(ctx->old))
> -                       mm_ops->put_page(ctx->ptep);
> -
> -               return 0;
> -       }
> -
>         ret = stage2_map_walker_try_leaf(ctx, data);
>         if (ret != -E2BIG)
>                 return ret;
> @@ -811,49 +809,14 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         return 0;
>  }
>
> -static int stage2_map_walk_table_post(const struct kvm_pgtable_visit_ctx *ctx,
> -                                     struct stage2_map_data *data)
> -{
> -       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> -       kvm_pte_t *childp;
> -       int ret = 0;
> -
> -       if (!data->anchor)
> -               return 0;
> -
> -       if (data->anchor == ctx->ptep) {
> -               childp = data->childp;
> -               data->anchor = NULL;
> -               data->childp = NULL;
> -               ret = stage2_map_walk_leaf(ctx, data);
> -       } else {
> -               childp = kvm_pte_follow(ctx->old, mm_ops);
> -       }
> -
> -       mm_ops->put_page(childp);
> -       mm_ops->put_page(ctx->ptep);
> -
> -       return ret;
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
>  static int stage2_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                              enum kvm_pgtable_walk_flags visit)
> @@ -865,11 +828,9 @@ static int stage2_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                 return stage2_map_walk_table_pre(ctx, data);
>         case KVM_PGTABLE_WALK_LEAF:
>                 return stage2_map_walk_leaf(ctx, data);
> -       case KVM_PGTABLE_WALK_TABLE_POST:
> -               return stage2_map_walk_table_post(ctx, data);
> +       default:
> +               return -EINVAL;
>         }
> -
> -       return -EINVAL;
>  }
>
>  int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> @@ -886,8 +847,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>         struct kvm_pgtable_walker walker = {
>                 .cb             = stage2_map_walker,
>                 .flags          = KVM_PGTABLE_WALK_TABLE_PRE |
> -                                 KVM_PGTABLE_WALK_LEAF |
> -                                 KVM_PGTABLE_WALK_TABLE_POST,
> +                                 KVM_PGTABLE_WALK_LEAF,
>                 .arg            = &map_data,
>         };
>
> @@ -917,8 +877,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>         struct kvm_pgtable_walker walker = {
>                 .cb             = stage2_map_walker,
>                 .flags          = KVM_PGTABLE_WALK_TABLE_PRE |
> -                                 KVM_PGTABLE_WALK_LEAF |
> -                                 KVM_PGTABLE_WALK_TABLE_POST,
> +                                 KVM_PGTABLE_WALK_LEAF,
>                 .arg            = &map_data,
>         };
>
> @@ -1207,7 +1166,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>
>  void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
>  {
> -       kvm_pte_t *ptep = (kvm_pte_t *)pgtable;
> +       kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
>         struct kvm_pgtable_walker walker = {
>                 .cb     = stage2_free_walker,
>                 .flags  = KVM_PGTABLE_WALK_LEAF |
> @@ -1225,5 +1184,5 @@ void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pg
>                 .end    = kvm_granule_size(level),
>         };
>
> -       WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level));
> +       WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level + 1));
>  }
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 5e197ae190ef..73ae908eb5d9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -128,6 +128,13 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
>         free_pages_exact(virt, size);
>  }
>
> +static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
> +
> +static void stage2_free_removed_table(void *addr, u32 level)
> +{
> +       kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, addr, level);
> +}
> +
>  static void kvm_host_get_page(void *addr)
>  {
>         get_page(virt_to_page(addr));
> @@ -662,6 +669,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>         .zalloc_page            = stage2_memcache_zalloc_page,
>         .zalloc_pages_exact     = kvm_s2_zalloc_pages_exact,
>         .free_pages_exact       = kvm_s2_free_pages_exact,
> +       .free_removed_table     = stage2_free_removed_table,
>         .get_page               = kvm_host_get_page,
>         .put_page               = kvm_s2_put_page,
>         .page_count             = kvm_host_page_count,
> --
> 2.38.1.431.g37b22c650d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
