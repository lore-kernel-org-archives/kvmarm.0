Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97287C
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 00:55:53 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id vw16so35040764ejc.12
        for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 16:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HCywdVt2XRGX+2M8xTCi0BXcDhuvXKwGd7VD7ATsG8E=;
        b=R5aWagTnYS+CEfEdJcB6D34J1WdyrjuKyfcF1CyWk7jMVp7Z7TZ31nswYjaHQOglM9
         LpqY7vIoDYQ5sMiIftx8EUiC7rPhFlEyb8Uc8EVlj1/oSF6ITQUmPpdH5U2QRgLqMv1o
         4ucQYp22d1a7lEYgfHPEsycINL/kwHuTuTBCyjUedZvtRFvG4DKY0ZU2dLCHMcn8h2Qb
         SdoYk3tY2gQz7bw822ZDSTQshXxSwrBw27FpT2t3HIYLtvAOR3krS3UvVRl7LnL9IN9C
         eUbgcRgM+uHdoHZ5x1oqbV947JkHNJFTX1Zq47OdF9phNkjxxB1HVgL3quo2/GCSjARf
         /xFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HCywdVt2XRGX+2M8xTCi0BXcDhuvXKwGd7VD7ATsG8E=;
        b=J3pLeQYQxgsp1N35NTKFX2akRTPxmb5CzgCSmIqyDYHqo9ydeHtO8c5nHjtN1Uakwh
         y6Kz3Xu7ho0U+OGrfcpWJrKr6OAt21i8m5ZzrUEn0cVU1owXD20c7Juq+Ms1OLyfYgOS
         q9JnhpG6Xf8OF2JWE0vo5ZCaaWsTAKp4DhcnD8XPaT/j3kY48hI402P2EVzcz9UE9aEi
         pQswa+RDtBHcLBj05ZYwUQ1FIOkmv2Q1zBTw52zlxbUgvKj/4YT5dGWs7H4EWWhV4/6k
         onrPuFSBKQbJ9zrfXOD7O/+cWTtX9HxXGT2ooCFJcl2A6DFaouUPH6x3BdrQpu6x3/Wf
         8dpg==
X-Gm-Message-State: AFqh2kosT8V5RnPdiGka3k1/gIcz3OR7EPNnRRe5HOD3fzKH3HRkICNa
	WWcM1ui/LF5Nj/dZmasNZ42udkgXlTj6Bw/DXxUWNA==
X-Google-Smtp-Source: AMrXdXtbJf86/aYud+ZHNkaChxTmnpKPeYPUuB87/JypdyEMk76ABkYRlnYxJfkr6EIA8dd4K/AzrdPotjanepnOR4A=
X-Received: by 2002:a17:906:2e94:b0:84d:ac8:ec37 with SMTP id
 o20-20020a1709062e9400b0084d0ac8ec37mr2843846eji.138.1674521751761; Mon, 23
 Jan 2023 16:55:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-3-ricarkol@google.com>
In-Reply-To: <20230113035000.480021-3-ricarkol@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Mon, 23 Jan 2023 16:55:40 -0800
Message-ID: <CANgfPd-KSX=NOhjyoAQRrLyHArQ=Sw3uMjmdh5J0yrogUN8mbg@mail.gmail.com>
Subject: Re: [PATCH 2/9] KVM: arm64: Add helper for creating removed stage2 subtrees
To: Ricardo Koller <ricarkol@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Add a stage2 helper, kvm_pgtable_stage2_create_removed(), for creating
> removed tables (the opposite of kvm_pgtable_stage2_free_removed()).
> Creating a removed table is useful for splitting block PTEs into
> subtrees of 4K PTEs.  For example, a 1G block PTE can be split into 4K
> PTEs by first creating a fully populated tree, and then use it to
> replace the 1G PTE in a single step.  This will be used in a
> subsequent commit for eager huge-page splitting (a dirty-logging
> optimization).
>
> No functional change intended. This new function will be used in a
> subsequent commit.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 25 +++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 47 ++++++++++++++++++++++++++++
>  2 files changed, 72 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 84a271647007..8ad78d61af7f 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -450,6 +450,31 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>   */
>  void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
>
> +/**
> + * kvm_pgtable_stage2_free_removed() - Create a removed stage-2 paging structure.
> + * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> + * @new:       Unlinked stage-2 paging structure to be created.

Oh, I see so the "removed" page table is actually a new page table
that has never been part of the paging structure. In that case I would
find it much more intuitive to call it "unlinked" or similar.

> + * @phys:      Physical address of the memory to map.
> + * @level:     Level of the stage-2 paging structure to be created.
> + * @prot:      Permissions and attributes for the mapping.
> + * @mc:                Cache of pre-allocated and zeroed memory from which to allocate
> + *             page-table pages.
> + *
> + * Create a removed page-table tree of PAGE_SIZE leaf PTEs under *new.
> + * This new page-table tree is not reachable (i.e., it is removed) from the
> + * root pgd and it's therefore unreachableby the hardware page-table
> + * walker. No TLB invalidation or CMOs are performed.
> + *
> + * If device attributes are not explicitly requested in @prot, then the
> + * mapping will be normal, cacheable.
> + *
> + * Return: 0 only if a fully populated tree was created, negative error
> + * code on failure. No partially-populated table can be returned.
> + */
> +int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
> +                                     kvm_pte_t *new, u64 phys, u32 level,
> +                                     enum kvm_pgtable_prot prot, void *mc);
> +
>  /**
>   * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
>   * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 87fd40d09056..0dee13007776 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1181,6 +1181,53 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>         return kvm_pgtable_walk(pgt, addr, size, &walker);
>  }
>
> +/*
> + * map_data->force_pte is true in order to force creating PAGE_SIZE PTEs.
> + * data->addr is 0 because the IPA is irrelevant for a removed table.
> + */
> +int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
> +                                     kvm_pte_t *new, u64 phys, u32 level,
> +                                     enum kvm_pgtable_prot prot, void *mc)
> +{
> +       struct stage2_map_data map_data = {
> +               .phys           = phys,
> +               .mmu            = pgt->mmu,
> +               .memcache       = mc,
> +               .force_pte      = true,
> +       };
> +       struct kvm_pgtable_walker walker = {
> +               .cb             = stage2_map_walker,
> +               .flags          = KVM_PGTABLE_WALK_LEAF |
> +                                 KVM_PGTABLE_WALK_REMOVED,
> +               .arg            = &map_data,
> +       };
> +       struct kvm_pgtable_walk_data data = {
> +               .walker = &walker,
> +               .addr   = 0,
> +               .end    = kvm_granule_size(level),
> +       };
> +       struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> +       kvm_pte_t *pgtable;
> +       int ret;
> +
> +       ret = stage2_set_prot_attr(pgt, prot, &map_data.attr);
> +       if (ret)
> +               return ret;
> +
> +       pgtable = mm_ops->zalloc_page(mc);
> +       if (!pgtable)
> +               return -ENOMEM;
> +
> +       ret = __kvm_pgtable_walk(&data, mm_ops, pgtable, level + 1);
> +       if (ret) {
> +               kvm_pgtable_stage2_free_removed(mm_ops, pgtable, level);
> +               mm_ops->put_page(pgtable);
> +               return ret;
> +       }
> +
> +       *new = kvm_init_table_pte(pgtable, mm_ops);
> +       return 0;
> +}
>
>  int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>                               struct kvm_pgtable_mm_ops *mm_ops,
> --
> 2.39.0.314.g84b9a713c41-goog
>
