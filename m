Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0BEBD33
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 14:52:05 +0000 (UTC)
Received: by mail-qt1-f179.google.com with SMTP id cr22so16873695qtb.10
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 06:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ttTXw7V9j7Pt0S/XsqrBdNwvxiyaBtuzcOWre/JfoYI=;
        b=gVsGrDKVxYTE3aJOan5jFP8X/N5QWNGqJs7XOyEvKfUK6XnXlgroz016B8tye/pHZO
         gS+LAuqgv78F5DoNKfqufaKX24rzb6rCVNH77Zdu7jI21hR/bqw39AOYNGRp5arJg5t3
         srL6VpeVek0cD7Pduv5PUA2ilGQZ8WuSwVKED7FkBKX5dt8Dqh1K3eKRNnVxzfeIc3/4
         5z7i8om+/0tPwd+ApLXs2O6c76Y5vo3Nd+RNAd1wwDOyaecdeI9nJUZRP+LKn/ixC+c2
         1ASyDfZq5he4txU33z8d/2b4A1bD9JK5HuCFfjSAN3ufIypi1zSDCCEYkU0YyBrj48U8
         yanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ttTXw7V9j7Pt0S/XsqrBdNwvxiyaBtuzcOWre/JfoYI=;
        b=YPEAK9D7TLKwu6Py2h8ulyRuCU3qYN2bVU0CatkX9JEP+5TZYkbTCyTAf0hCCoIAkt
         lOd7OnOPXMsB4PVsJvxpv6XJMg66KWqDteBbi5OSynALneLr/JaM71Qhal53C0AJbHzm
         f5qY+eosfRORJpN6E3AkWMU1Gv7fMQGEnryT8XyO/SX3MXmdp07gVggtLhwThMJbJ6lN
         SGjkkkOWoV9N7iM/zOdChwoJriEsCiI0wVOgEO4xgEZVzPPdIzROy/Z27G34jQSKsGwy
         tCMaWq70sb1S6fluEJRYrsyBWWwDgVgggj1BX8DeKYX0X8Hccntlzl4BBIR2emcaTQwQ
         0Npw==
X-Gm-Message-State: AO0yUKXa4j8O7boGFcKZdnPGhRFQMa7PA9+G2xYcgwT+shjS4nNMnLqp
	nlfm66lsqUz9TnBEM1Nr8JoNuTmCYTKaXxeTfNq7aw==
X-Google-Smtp-Source: AK7set+JAIwfk3UdRuULnNSS3/mw0OQCU1VMPQwF12sU8n4bYbPOmdDbGwtcmH+xrBzoWE7jAx8ytFnNJZe1d19V/9M=
X-Received: by 2002:ac8:7c4e:0:b0:3ab:6bd6:d3bb with SMTP id
 o14-20020ac87c4e000000b003ab6bd6d3bbmr418335qtv.6.1675781524604; Tue, 07 Feb
 2023 06:52:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com> <20230206165851.3106338-4-ricarkol@google.com>
In-Reply-To: <20230206165851.3106338-4-ricarkol@google.com>
From: Ricardo Koller <ricarkol@google.com>
Date: Tue, 7 Feb 2023 06:51:52 -0800
Message-ID: <CAOHnOrx8hh77h5UwaRPxRf0xrDC33_UEc4O2npUVCd9v6zkQDg@mail.gmail.com>
Subject: Re: [PATCH v2 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 6, 2023 at 8:58 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for creating
> unlinked tables (the opposite of kvm_pgtable_stage2_free_unlinked()).
> Creating an unlinked table is useful for splitting block PTEs into
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
>  arch/arm64/include/asm/kvm_pgtable.h | 29 +++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 47 ++++++++++++++++++++++++++++
>  2 files changed, 76 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 7c45082e6c23..e94c92988745 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -460,6 +460,35 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>   */
>  void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
>
> +/**
> + * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
> + * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> + * @new:       Unlinked stage-2 paging structure to be created.
> + * @phys:      Physical address of the memory to map.
> + * @level:     Level of the stage-2 paging structure to be created.
> + * @prot:      Permissions and attributes for the mapping.
> + * @mc:                Cache of pre-allocated and zeroed memory from which to allocate
> + *             page-table pages.
> + * @force_pte:  Force mappings to PAGE_SIZE granularity.
> + *
> + * Create an unlinked page-table tree under @new. If @force_pte is
> + * true and @level is the PMD level, then the tree is mapped up to the

typo: this should be: "if @force_pte is true OR @level is the PMD, then
                       the tree is mapped up to the PAGE_SIZE leaf PTE"

> + * PAGE_SIZE leaf PTE; the tree is mapped up one level otherwise. This
> + * new page-table tree is not reachable (i.e., it is removed) from the
> + * root pgd and it's therefore unreachableby the hardware page-table
> + * walker. No TLB invalidation or CMOs are performed.
> + *
> + * If device attributes are not explicitly requested in @prot, then the
> + * mapping will be normal, cacheable.
> + *
> + * Return: 0 only if a fully populated tree was created (all memory
> + * under @level is mapped), negative error code on failure.
> + */
> +int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> +                                      kvm_pte_t *new, u64 phys, u32 level,
> +                                      enum kvm_pgtable_prot prot, void *mc,
> +                                      bool force_pte);
> +
>  /**
>   * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
>   * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 0a5ef9288371..fed314f2b320 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1181,6 +1181,53 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>         return kvm_pgtable_walk(pgt, addr, size, &walker);
>  }
>
> +int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> +                                     kvm_pte_t *new, u64 phys, u32 level,
> +                                     enum kvm_pgtable_prot prot, void *mc,
> +                                     bool force_pte)
> +{
> +       struct stage2_map_data map_data = {
> +               .phys           = phys,
> +               .mmu            = pgt->mmu,
> +               .memcache       = mc,
> +               .force_pte      = force_pte,
> +       };
> +       struct kvm_pgtable_walker walker = {
> +               .cb             = stage2_map_walker,
> +               .flags          = KVM_PGTABLE_WALK_LEAF |
> +                                 KVM_PGTABLE_WALK_SKIP_BBM |
> +                                 KVM_PGTABLE_WALK_SKIP_CMO,
> +               .arg            = &map_data,
> +       };
> +       /* .addr (the IPA) is irrelevant for a removed table */
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
> +       ret = __kvm_pgtable_walk(&data, mm_ops, (kvm_pteref_t)pgtable,
> +                                level + 1);
> +       if (ret) {
> +               kvm_pgtable_stage2_free_unlinked(mm_ops, pgtable, level);
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
> 2.39.1.519.gcb327c4b5f-goog
>
