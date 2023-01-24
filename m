Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945E933C4
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 16:35:44 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id b24-20020a17090a551800b0022beefa7a23so2374034pji.5
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 08:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rsEVtGGTFIHpkRLJZTulPXLpxSRPNED4KjXw3ufmnMM=;
        b=eJLQzZ6Le+Wr94ardYEzmhRznMRAHnCxPi09A3omzjJWVx9Pfu4C1okubr9KuBX608
         QEyvU+vu8pDwqBW1ZtH0RLeirRZxk454/iTsZyTwmhS5VY8XpXfDTxFtW/3xOxNSn1ar
         28vcouyM+SqZLYSmINekYzZOf5JVn2p0KZeNL4tpOe/rRFVJEoji+Am1XoBwU3mKyuQm
         QvAUeJZxqIOwFMADqW1+nRR8mEagSVUwPwg1vZRJq9XPF4WG0bt2656KjY/1lARX/pvC
         ppEWAJIY9QN6veMmH+Xo8gWeEnN7Mx02zrpBfYC86m33ba29izr5LgJ1XL6QtEFVkQuL
         RxGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rsEVtGGTFIHpkRLJZTulPXLpxSRPNED4KjXw3ufmnMM=;
        b=IeF2gNAjLJxMppSrKXNv3jqL/q50x37pmCHHxr7M7Ks7Ys8khQmykWfvHOsCxrSQUU
         wKVBNHk4jtGNmqWD14bYd0witGBYzf0jlXLsOFw/dqMzXAyuYoJTXYGkRycWHqVffkfV
         skP2UVED0vmTTLcWXOFLVYGohZIzYWb7/eftn4/KuSNjeJS3ZrAihWQ1ir9zWUlJuMPs
         +96nUrz3+2d27WqGj9X1lrmhetmjvzBxNpeYDSL9kvJIrF4ZQKqLh8VA7Rx6y7p2JU+a
         xeQH7dGL+wg5sj3CCBYmBIaGpczC8fS7jz+rORviPGUszHdjxOHbeBNxYULvWnDhg5F2
         W9uQ==
X-Gm-Message-State: AO0yUKUIIo5+rsWBMv4DdeSDbA5+Oq/dDPPf4rjej0kal6pnDXSOLJ8t
	i7LJsKawheKkWVaJAjfCvldM1Q==
X-Google-Smtp-Source: AK7set8n2BrBRTSNTreW4tMk1tf3rE1i6CiDCf+wdpJvWB5aktsAehnhGADHQgW3O3+tm/hXPpvDgw==
X-Received: by 2002:a05:6a20:d688:b0:b9:14e:184b with SMTP id it8-20020a056a20d68800b000b9014e184bmr275160pzb.3.1674578143872;
        Tue, 24 Jan 2023 08:35:43 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id v10-20020a17090a00ca00b0022bab07f578sm4815954pjd.11.2023.01.24.08.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:35:43 -0800 (PST)
Date: Tue, 24 Jan 2023 08:35:40 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Ben Gardon <bgardon@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com,
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com,
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com,
	reijiw@google.com, rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 2/9] KVM: arm64: Add helper for creating removed stage2
 subtrees
Message-ID: <Y9AI3FWEeIaw9kRN@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-3-ricarkol@google.com>
 <CANgfPd-KSX=NOhjyoAQRrLyHArQ=Sw3uMjmdh5J0yrogUN8mbg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-KSX=NOhjyoAQRrLyHArQ=Sw3uMjmdh5J0yrogUN8mbg@mail.gmail.com>

On Mon, Jan 23, 2023 at 04:55:40PM -0800, Ben Gardon wrote:
> On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Add a stage2 helper, kvm_pgtable_stage2_create_removed(), for creating
> > removed tables (the opposite of kvm_pgtable_stage2_free_removed()).
> > Creating a removed table is useful for splitting block PTEs into
> > subtrees of 4K PTEs.  For example, a 1G block PTE can be split into 4K
> > PTEs by first creating a fully populated tree, and then use it to
> > replace the 1G PTE in a single step.  This will be used in a
> > subsequent commit for eager huge-page splitting (a dirty-logging
> > optimization).
> >
> > No functional change intended. This new function will be used in a
> > subsequent commit.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 25 +++++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 47 ++++++++++++++++++++++++++++
> >  2 files changed, 72 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 84a271647007..8ad78d61af7f 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -450,6 +450,31 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >   */
> >  void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> >
> > +/**
> > + * kvm_pgtable_stage2_free_removed() - Create a removed stage-2 paging structure.
> > + * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @new:       Unlinked stage-2 paging structure to be created.
> 
> Oh, I see so the "removed" page table is actually a new page table
> that has never been part of the paging structure. In that case I would
> find it much more intuitive to call it "unlinked" or similar.
>

Sounds good, I like "unlinked".

Oliver, are you OK if I rename free_removed() as well? just to keep them
symmetric.

> > + * @phys:      Physical address of the memory to map.
> > + * @level:     Level of the stage-2 paging structure to be created.
> > + * @prot:      Permissions and attributes for the mapping.
> > + * @mc:                Cache of pre-allocated and zeroed memory from which to allocate
> > + *             page-table pages.
> > + *
> > + * Create a removed page-table tree of PAGE_SIZE leaf PTEs under *new.
> > + * This new page-table tree is not reachable (i.e., it is removed) from the
> > + * root pgd and it's therefore unreachableby the hardware page-table
> > + * walker. No TLB invalidation or CMOs are performed.
> > + *
> > + * If device attributes are not explicitly requested in @prot, then the
> > + * mapping will be normal, cacheable.
> > + *
> > + * Return: 0 only if a fully populated tree was created, negative error
> > + * code on failure. No partially-populated table can be returned.
> > + */
> > +int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
> > +                                     kvm_pte_t *new, u64 phys, u32 level,
> > +                                     enum kvm_pgtable_prot prot, void *mc);
> > +
> >  /**
> >   * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> >   * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 87fd40d09056..0dee13007776 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1181,6 +1181,53 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
> >         return kvm_pgtable_walk(pgt, addr, size, &walker);
> >  }
> >
> > +/*
> > + * map_data->force_pte is true in order to force creating PAGE_SIZE PTEs.
> > + * data->addr is 0 because the IPA is irrelevant for a removed table.
> > + */
> > +int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
> > +                                     kvm_pte_t *new, u64 phys, u32 level,
> > +                                     enum kvm_pgtable_prot prot, void *mc)
> > +{
> > +       struct stage2_map_data map_data = {
> > +               .phys           = phys,
> > +               .mmu            = pgt->mmu,
> > +               .memcache       = mc,
> > +               .force_pte      = true,
> > +       };
> > +       struct kvm_pgtable_walker walker = {
> > +               .cb             = stage2_map_walker,
> > +               .flags          = KVM_PGTABLE_WALK_LEAF |
> > +                                 KVM_PGTABLE_WALK_REMOVED,
> > +               .arg            = &map_data,
> > +       };
> > +       struct kvm_pgtable_walk_data data = {
> > +               .walker = &walker,
> > +               .addr   = 0,
> > +               .end    = kvm_granule_size(level),
> > +       };
> > +       struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> > +       kvm_pte_t *pgtable;
> > +       int ret;
> > +
> > +       ret = stage2_set_prot_attr(pgt, prot, &map_data.attr);
> > +       if (ret)
> > +               return ret;
> > +
> > +       pgtable = mm_ops->zalloc_page(mc);
> > +       if (!pgtable)
> > +               return -ENOMEM;
> > +
> > +       ret = __kvm_pgtable_walk(&data, mm_ops, pgtable, level + 1);
> > +       if (ret) {
> > +               kvm_pgtable_stage2_free_removed(mm_ops, pgtable, level);
> > +               mm_ops->put_page(pgtable);
> > +               return ret;
> > +       }
> > +
> > +       *new = kvm_init_table_pte(pgtable, mm_ops);
> > +       return 0;
> > +}
> >
> >  int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >                               struct kvm_pgtable_mm_ops *mm_ops,
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
