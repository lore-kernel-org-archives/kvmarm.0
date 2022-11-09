Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BABA463
	for <kvmarm@lists.linux.dev>; Wed,  9 Nov 2022 22:23:33 +0000 (UTC)
Received: by mail-qt1-f170.google.com with SMTP id h24so33078qta.9
        for <kvmarm@lists.linux.dev>; Wed, 09 Nov 2022 14:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VgnazAEADG8sJUv0PXaSsSOl5lA5Gz7Epusk3OY6WjA=;
        b=qdh+TQ8ZXR20xzFigaCdXjxTDRZC/OdMHqww7dW5YyK/BVOUzXDZreKnz+CRvWSf68
         dvzjT/k9j/0Xwp0F8yBJuJgPjS67ueC5I7mHytXwpZIDCrVnpSlFrfdiKr3cRazimdNF
         71oGHRYO0+xuzViyMCI2p26klMdQvFr/J1/bL2S+zYiz+TckYgqHT1ZDmV/n9yCWyjsn
         M53tPRMrHepiy8WdFI8cKVzB90Pfym5AWESr75Ol1orJXjXgP5if6bE8kM4eenodQiEZ
         f5NaOgMPNe0myNlJmCGEjVqCfx+mXY7qPQaWIovZ/Wv7btjuyN86BmV710fIh+e11DGV
         0HVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VgnazAEADG8sJUv0PXaSsSOl5lA5Gz7Epusk3OY6WjA=;
        b=0mdQBICrh5To0t+EJLtSRiuzq+uRG0jinxhMJFCKUMgssiyuBOeWK48tyoHFgsU7FP
         MIdSTRMtcC1VQ+mxvdJ1dR/W6TWvd09TXfjaeLbBhZBgeWQ9El31J6i9szagA6wbPcFq
         5fCBlXRxG8KpAoGNa/5Rix/nA/w89WduMHiv8jOvDAaetQCkEqcBOk+1XEup2U/J59uu
         KjzC9yUuvS94rtkvXDwxy9VI7QnqEdjCSFV0kwhdlgF0jRjVJjMuGcR16CIKtJo+J26D
         w0SmS2kd/OSaEKhcO6i93j50zoI6rH5BQbPwO/MMRDzdGFpF7BhSDG6yXBJNMwjK6ViB
         KKEA==
X-Gm-Message-State: ANoB5plwFZojmy5aQ9X+sgv5PBjAvJ0YT3W46hWXPwhxY0CUdSCsav6F
	ookmu8Necp7IgCn0vLXJrNrQOLOU9k9gylrYr2Dxlg==
X-Google-Smtp-Source: AA0mqf4yzNGgsfQm/TzCFXGgtfMZAj91POlJ3hIBn/yDgKZgX6lpM7ObieTsFHzhonD3dFhonFZdboneREVQXb0cKsA=
X-Received: by 2002:ac8:5ac2:0:b0:3a5:afca:2322 with SMTP id
 d2-20020ac85ac2000000b003a5afca2322mr4273518qtd.500.1668032611970; Wed, 09
 Nov 2022 14:23:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev> <20221107215644.1895162-4-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-4-oliver.upton@linux.dev>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 14:23:21 -0800
Message-ID: <CANgfPd9mDY5389RnDHoLLZrS8vbXcpwGE-yFfhPnO2jscXnbXg@mail.gmail.com>
Subject: Re: [PATCH v5 03/14] KVM: arm64: Pass mm_ops through the visitor context
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 
	Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
	David Matlack <dmatlack@google.com>, Quentin Perret <qperret@google.com>, Gavin Shan <gshan@redhat.com>, 
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221109222321.EBCgxOT3VxRI38ljAzHLm1-UVZDCXKfBo75Fu6Lky2U@z>

On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> As a prerequisite for getting visitors off of struct kvm_pgtable, pass
> mm_ops through the visitor context.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/setup.c      |  3 +-
>  arch/arm64/kvm/hyp/pgtable.c         | 63 +++++++++++-----------------
>  3 files changed, 26 insertions(+), 41 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 14d4b68a1e92..a752793482cb 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -203,6 +203,7 @@ struct kvm_pgtable_visit_ctx {
>         kvm_pte_t                               *ptep;
>         kvm_pte_t                               old;
>         void                                    *arg;
> +       struct kvm_pgtable_mm_ops               *mm_ops;
>         u64                                     addr;
>         u64                                     end;
>         u32                                     level;
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 6af443c9d78e..1068338d77f3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -189,7 +189,7 @@ static void hpool_put_page(void *addr)
>  static int finalize_host_mappings_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                                          enum kvm_pgtable_walk_flags visit)
>  {
> -       struct kvm_pgtable_mm_ops *mm_ops = ctx->arg;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>         enum kvm_pgtable_prot prot;
>         enum pkvm_page_state state;
>         phys_addr_t phys;
> @@ -239,7 +239,6 @@ static int finalize_host_mappings(void)
>         struct kvm_pgtable_walker walker = {
>                 .cb     = finalize_host_mappings_walker,
>                 .flags  = KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
> -               .arg    = pkvm_pgtable.mm_ops,
>         };
>         int i, ret;
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index fb3696b3a997..db25e81a9890 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -181,9 +181,10 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
>  }
>
>  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> -                             kvm_pte_t *pgtable, u32 level);
> +                             struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level);
>
>  static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> +                                     struct kvm_pgtable_mm_ops *mm_ops,
>                                       kvm_pte_t *ptep, u32 level)
>  {
>         enum kvm_pgtable_walk_flags flags = data->walker->flags;
> @@ -191,6 +192,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>                 .ptep   = ptep,
>                 .old    = READ_ONCE(*ptep),
>                 .arg    = data->walker->arg,
> +               .mm_ops = mm_ops,
>                 .addr   = data->addr,
>                 .end    = data->end,
>                 .level  = level,
> @@ -218,8 +220,8 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>                 goto out;
>         }
>
> -       childp = kvm_pte_follow(ctx.old, data->pgt->mm_ops);
> -       ret = __kvm_pgtable_walk(data, childp, level + 1);
> +       childp = kvm_pte_follow(ctx.old, mm_ops);
> +       ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
>         if (ret)
>                 goto out;
>
> @@ -231,7 +233,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>  }
>
>  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> -                             kvm_pte_t *pgtable, u32 level)
> +                             struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level)
>  {
>         u32 idx;
>         int ret = 0;
> @@ -245,7 +247,7 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
>                 if (data->addr >= data->end)
>                         break;
>
> -               ret = __kvm_pgtable_visit(data, ptep, level);
> +               ret = __kvm_pgtable_visit(data, mm_ops, ptep, level);
>                 if (ret)
>                         break;
>         }
> @@ -269,7 +271,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
>         for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
>                 kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
>
> -               ret = __kvm_pgtable_walk(data, ptep, pgt->start_level);
> +               ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
>                 if (ret)
>                         break;
>         }
> @@ -332,7 +334,6 @@ int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
>  struct hyp_map_data {
>         u64                             phys;
>         kvm_pte_t                       attr;
> -       struct kvm_pgtable_mm_ops       *mm_ops;
>  };
>
>  static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
> @@ -400,7 +401,7 @@ static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         if (ctx->old == new)
>                 return true;
>         if (!kvm_pte_valid(ctx->old))
> -               data->mm_ops->get_page(ctx->ptep);
> +               ctx->mm_ops->get_page(ctx->ptep);
>         else if (WARN_ON((ctx->old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW))
>                 return false;
>
> @@ -413,7 +414,7 @@ static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  {
>         kvm_pte_t *childp;
>         struct hyp_map_data *data = ctx->arg;
> -       struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>
>         if (hyp_map_walker_try_leaf(ctx, data))
>                 return 0;
> @@ -436,7 +437,6 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
>         int ret;
>         struct hyp_map_data map_data = {
>                 .phys   = ALIGN_DOWN(phys, PAGE_SIZE),
> -               .mm_ops = pgt->mm_ops,
>         };
>         struct kvm_pgtable_walker walker = {
>                 .cb     = hyp_map_walker,
> @@ -454,18 +454,13 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
>         return ret;
>  }
>
> -struct hyp_unmap_data {
> -       u64                             unmapped;
> -       struct kvm_pgtable_mm_ops       *mm_ops;
> -};
> -
>  static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                             enum kvm_pgtable_walk_flags visit)
>  {
>         kvm_pte_t *childp = NULL;
>         u64 granule = kvm_granule_size(ctx->level);
> -       struct hyp_unmap_data *data = ctx->arg;
> -       struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +       u64 *unmapped = ctx->arg;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>
>         if (!kvm_pte_valid(ctx->old))
>                 return -EINVAL;
> @@ -486,7 +481,7 @@ static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                 kvm_clear_pte(ctx->ptep);
>                 dsb(ishst);
>                 __tlbi_level(vale2is, __TLBI_VADDR(ctx->addr, 0), ctx->level);
> -               data->unmapped += granule;
> +               *unmapped += granule;
>         }
>
>         dsb(ish);
> @@ -501,12 +496,10 @@ static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>
>  u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
> -       struct hyp_unmap_data unmap_data = {
> -               .mm_ops = pgt->mm_ops,
> -       };
> +       u64 unmapped = 0;
>         struct kvm_pgtable_walker walker = {
>                 .cb     = hyp_unmap_walker,
> -               .arg    = &unmap_data,
> +               .arg    = &unmapped,
>                 .flags  = KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
>         };
>
> @@ -514,7 +507,7 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>                 return 0;
>
>         kvm_pgtable_walk(pgt, addr, size, &walker);
> -       return unmap_data.unmapped;
> +       return unmapped;
>  }
>
>  int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
> @@ -538,7 +531,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
>  static int hyp_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                            enum kvm_pgtable_walk_flags visit)
>  {
> -       struct kvm_pgtable_mm_ops *mm_ops = ctx->arg;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>
>         if (!kvm_pte_valid(ctx->old))
>                 return 0;
> @@ -556,7 +549,6 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
>         struct kvm_pgtable_walker walker = {
>                 .cb     = hyp_free_walker,
>                 .flags  = KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
> -               .arg    = pgt->mm_ops,
>         };
>
>         WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
> @@ -575,8 +567,6 @@ struct stage2_map_data {
>         struct kvm_s2_mmu               *mmu;
>         void                            *memcache;
>
> -       struct kvm_pgtable_mm_ops       *mm_ops;
> -
>         /* Force mappings to page granularity */
>         bool                            force_pte;
>  };
> @@ -725,7 +715,7 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         kvm_pte_t new;
>         u64 granule = kvm_granule_size(ctx->level), phys = data->phys;
>         struct kvm_pgtable *pgt = data->mmu->pgt;
> -       struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>
>         if (!stage2_leaf_mapping_allowed(ctx, data))
>                 return -E2BIG;
> @@ -773,7 +763,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>         if (!stage2_leaf_mapping_allowed(ctx, data))
>                 return 0;
>
> -       data->childp = kvm_pte_follow(ctx->old, data->mm_ops);
> +       data->childp = kvm_pte_follow(ctx->old, ctx->mm_ops);
>         kvm_clear_pte(ctx->ptep);
>
>         /*
> @@ -789,7 +779,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>  static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>                                 struct stage2_map_data *data)
>  {
> -       struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>         kvm_pte_t *childp;
>         int ret;
>
> @@ -831,7 +821,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  static int stage2_map_walk_table_post(const struct kvm_pgtable_visit_ctx *ctx,
>                                       struct stage2_map_data *data)
>  {
> -       struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>         kvm_pte_t *childp;
>         int ret = 0;
>
> @@ -898,7 +888,6 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>                 .phys           = ALIGN_DOWN(phys, PAGE_SIZE),
>                 .mmu            = pgt->mmu,
>                 .memcache       = mc,
> -               .mm_ops         = pgt->mm_ops,
>                 .force_pte      = pgt->force_pte_cb && pgt->force_pte_cb(addr, addr + size, prot),
>         };
>         struct kvm_pgtable_walker walker = {
> @@ -929,7 +918,6 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>                 .phys           = KVM_PHYS_INVALID,
>                 .mmu            = pgt->mmu,
>                 .memcache       = mc,
> -               .mm_ops         = pgt->mm_ops,
>                 .owner_id       = owner_id,
>                 .force_pte      = true,
>         };
> @@ -953,7 +941,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  {
>         struct kvm_pgtable *pgt = ctx->arg;
>         struct kvm_s2_mmu *mmu = pgt->mmu;
> -       struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>         kvm_pte_t *childp = NULL;
>         bool need_flush = false;
>
> @@ -1007,7 +995,6 @@ struct stage2_attr_data {
>         kvm_pte_t                       attr_clr;
>         kvm_pte_t                       pte;
>         u32                             level;
> -       struct kvm_pgtable_mm_ops       *mm_ops;
>  };
>
>  static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
> @@ -1015,7 +1002,7 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  {
>         kvm_pte_t pte = ctx->old;
>         struct stage2_attr_data *data = ctx->arg;
> -       struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>
>         if (!kvm_pte_valid(ctx->old))
>                 return 0;
> @@ -1055,7 +1042,6 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>         struct stage2_attr_data data = {
>                 .attr_set       = attr_set & attr_mask,
>                 .attr_clr       = attr_clr & attr_mask,
> -               .mm_ops         = pgt->mm_ops,
>         };
>         struct kvm_pgtable_walker walker = {
>                 .cb             = stage2_attr_walker,
> @@ -1198,7 +1184,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>  static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                               enum kvm_pgtable_walk_flags visit)
>  {
> -       struct kvm_pgtable_mm_ops *mm_ops = ctx->arg;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>
>         if (!stage2_pte_is_counted(ctx->old))
>                 return 0;
> @@ -1218,7 +1204,6 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>                 .cb     = stage2_free_walker,
>                 .flags  = KVM_PGTABLE_WALK_LEAF |
>                           KVM_PGTABLE_WALK_TABLE_POST,
> -               .arg    = pgt->mm_ops,
>         };
>
>         WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
> --
> 2.38.1.431.g37b22c650d-goog
>
