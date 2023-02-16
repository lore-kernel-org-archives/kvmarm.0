Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA5F7B
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 18:34:54 +0000 (UTC)
Received: by mail-qv1-f50.google.com with SMTP id l18so1895352qvo.13
        for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 10:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676572493;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uh6CVq236Xc+PlHfu22OJTizp6ukvt6v9jKAGHyOHFI=;
        b=hAog2nBNM9iYMZ5mjeQQtLK7QqhTg/bsvOt5XSm+16NBfUA/6Jc27+jdYMvk4Tb5T6
         nfEdjm4/Kgfh0iIX7JYzg5wBrHSKJFLbTgre7x0kZqvJvYkvxVCga9uK8TyWszXdkQiN
         330h1arWruSZNMZoc6K4ifMDJxo029Ywa+Ju21yPuBiHJoHSh2K9ElHuyzf9hRVkceJi
         iEczpSY3RMbvX7/nBwr1tRfmi+nfyeuxCEZRsj2yrniQlpDS+Uai6qZnvgwOdAWzKuMx
         +rs7yKi9RSvxoUB86O8YTTCLLt7qmIOgsODtHOel21ZBxxE/JHqse5UlDeWN75ozZWNl
         F3SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676572493;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uh6CVq236Xc+PlHfu22OJTizp6ukvt6v9jKAGHyOHFI=;
        b=baPQOu1h9zWfEA2IdVdqlombCB6aNTVtNEHMx92asi7YsxQfkC6fRCpDgr9Rj4yswL
         knaeHqvkBnurzZWsbn5hlzh1v2pdygDGWg/usAOGn3sYw71V5XSgzNJJxV5m/xC0h7LL
         3g2DrAPEBDNBzNevcPpjGO0pazNzReM5WLPIBwYA7AojoIXQxubLSb3G4vC/zqHGwHZ8
         rFSB1Xm+l1XKKb+2W4RDT4VTVZ9qcwh2ihh9vLJGeFWXihylT2sDZMPpMqIEK6jsbLlR
         AWxieXEz5IZDNSgjzB/T6DtN9RTLGLZuTATRbviipcceP1XnDWZbnILwsVkskr3ekyKF
         b8Rg==
X-Gm-Message-State: AO0yUKW6QTpTvozJQYu5uZLIyLmR3Rryh2e7f/h22ZTWH5HOtCPtoTgO
	tbwtOW0SbfajcSs4KozWjD+nlEHFOoxbwWVyf+M7ng==
X-Google-Smtp-Source: AK7set9/GdS42A1qzhY3wk36BebROfIrLv7dNAK6iTXxZQ+YhGO468XUASVOXDfCalgRjrIs9BD1XKhOm+A8Jv7vTLY=
X-Received: by 2002:a0c:e086:0:b0:56e:a207:142d with SMTP id
 l6-20020a0ce086000000b0056ea207142dmr577696qvk.6.1676572493140; Thu, 16 Feb
 2023 10:34:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com> <20230215174046.2201432-4-ricarkol@google.com>
 <Y+11HkcHMwUrEkPz@linux.dev>
In-Reply-To: <Y+11HkcHMwUrEkPz@linux.dev>
From: Ricardo Koller <ricarkol@google.com>
Date: Thu, 16 Feb 2023 10:34:42 -0800
Message-ID: <CAOHnOrxtaM1J-PGM0sKjcLV0TddXhSRTiYDrJD=TOZ_wTPeLuQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
To: Oliver Upton <oliver.upton@linux.dev>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 15, 2023 at 4:13 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Wed, Feb 15, 2023 at 05:40:37PM +0000, Ricardo Koller wrote:
> > Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for creating
> > unlinked tables (the opposite of kvm_pgtable_stage2_free_unlinked()).
>
> You don't need to mention the free_unlinked() side of things, IMO.
>
> > Creating an unlinked table is useful for splitting block PTEs into
> > subtrees of 4K PTEs.  For example, a 1G block PTE can be split into 4K
> > PTEs by first creating a fully populated tree, and then use it to
> > replace the 1G PTE in a single step.  This will be used in a
> > subsequent commit for eager huge-page splitting (a dirty-logging
> > optimization).
>
> This is all very PAGE_SIZE=4K centric :) Could you instead describe the
> operation in terms of the Linux page table hierarchy?
>
> i.e. '... useful for splitting hugepages into PTE-level mappings'
>
> > No functional change intended. This new function will be used in a
> > subsequent commit.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 29 +++++++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 47 ++++++++++++++++++++++++++++
> >  2 files changed, 76 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 7c45082e6c23..2ea397ad3e63 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -460,6 +460,35 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >   */
> >  void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> >
> > +/**
> > + * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
> > + * @pgt:     Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @new:     Unlinked stage-2 paging structure to be created.
> > + * @phys:    Physical address of the memory to map.
> > + * @level:   Level of the stage-2 paging structure to be created.
>
> I believe this is the starting level of the page table to be created,
> right? Might be worth calling that out explicitly as level could also be
> interpreted as mapping level.
>
> > + * @prot:    Permissions and attributes for the mapping.
> > + * @mc:              Cache of pre-allocated and zeroed memory from which to allocate
> > + *           page-table pages.
> > + * @force_pte:  Force mappings to PAGE_SIZE granularity.
> > + *
> > + * Create an unlinked page-table tree under @new. If @force_pte is
> > + * true or @level is the PMD level, then the tree is mapped up to the
> > + * PAGE_SIZE leaf PTE; the tree is mapped up one level otherwise. This
> > + * new page-table tree is not reachable (i.e., it is removed) from the
>
> 'i.e. it is unlinked'

ACK

>
> > + * root pgd and it's therefore unreachableby the hardware page-table
> > + * walker. No TLB invalidation or CMOs are performed.
> > + *
> > + * If device attributes are not explicitly requested in @prot, then the
> > + * mapping will be normal, cacheable.
> > + *
> > + * Return: 0 only if a fully populated tree was created (all memory
> > + * under @level is mapped), negative error code on failure.
> > + */
> > +int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> > +                                    kvm_pte_t *new, u64 phys, u32 level,
> > +                                    enum kvm_pgtable_prot prot, void *mc,
> > +                                    bool force_pte);
> > +
> >  /**
> >   * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> >   * @pgt:     Page-table structure initialised by kvm_pgtable_stage2_init*().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 0a5ef9288371..fed314f2b320 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1181,6 +1181,53 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
> >       return kvm_pgtable_walk(pgt, addr, size, &walker);
> >  }
> >
> > +int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> > +                                   kvm_pte_t *new, u64 phys, u32 level,
> > +                                   enum kvm_pgtable_prot prot, void *mc,
> > +                                   bool force_pte)
> > +{
> > +     struct stage2_map_data map_data = {
> > +             .phys           = phys,
> > +             .mmu            = pgt->mmu,
> > +             .memcache       = mc,
> > +             .force_pte      = force_pte,
> > +     };
> > +     struct kvm_pgtable_walker walker = {
> > +             .cb             = stage2_map_walker,
> > +             .flags          = KVM_PGTABLE_WALK_LEAF |
> > +                               KVM_PGTABLE_WALK_SKIP_BBM |
> > +                               KVM_PGTABLE_WALK_SKIP_CMO,
> > +             .arg            = &map_data,
> > +     };
> > +     /* .addr (the IPA) is irrelevant for a removed table */
> > +     struct kvm_pgtable_walk_data data = {
> > +             .walker = &walker,
> > +             .addr   = 0,
> > +             .end    = kvm_granule_size(level),
> > +     };
> > +     struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> > +     kvm_pte_t *pgtable;
> > +     int ret;
> > +
> > +     ret = stage2_set_prot_attr(pgt, prot, &map_data.attr);
> > +     if (ret)
> > +             return ret;
> > +
> > +     pgtable = mm_ops->zalloc_page(mc);
> > +     if (!pgtable)
> > +             return -ENOMEM;
> > +
> > +     ret = __kvm_pgtable_walk(&data, mm_ops, (kvm_pteref_t)pgtable,
> > +                              level + 1);
> > +     if (ret) {
> > +             kvm_pgtable_stage2_free_unlinked(mm_ops, pgtable, level);
> > +             mm_ops->put_page(pgtable);
> > +             return ret;
> > +     }
> > +
> > +     *new = kvm_init_table_pte(pgtable, mm_ops);
> > +     return 0;
>
> Hmm. I don't think you really need the 'out' pointer here. Either the
> function fails and it returns a negative error, or it succeeds and
> returns a pointer.

Ah, good point. I don't think it's needed.

>
>   kvm_pte_t *kvm_pgtable_stage2_create_unlinked(...)
>   {
>           int ret;
>
>           [...]
>
>           ret = __kvm_pgtable_walk(...);
>           if (ret) {
>                   kvm_pgtable_stage2_free_unlinked(...);
>                   mm_ops->put_page(pgtable);
>                   return ERR_PTR(ret);
>           }
>
>
>           return pgtable;
>   }
>
>   [...]
>
>   pgtable = kvm_pgtable_stage2_create_unlinked(...);
>   if (IS_ERR(pgtable))
>         return PTR_ERR(pgtable);
>
> --
> Thanks,
> Oliver
