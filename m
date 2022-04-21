Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC67C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 16:21:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C1BA4B2A7;
	Thu, 21 Apr 2022 12:21:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t-+xYNcJQNpk; Thu, 21 Apr 2022 12:21:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84E094B28C;
	Thu, 21 Apr 2022 12:21:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F6994B18F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:12:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DyDVv0e9GiQF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 12:12:34 -0400 (EDT)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com
 [209.85.128.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC4704B120
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:12:34 -0400 (EDT)
Received: by mail-yw1-f180.google.com with SMTP id
 00721157ae682-2ebf3746f87so57452237b3.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 09:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=1LEpEDUHo2gcpiXlfn1kBdfZyXWOgvfnz55c2R2IVPY=;
 b=Wvfc82/VgFUvjIN62rZQNjP1PoLktA7i3hhp6X/9vpe2LWZecy7RTwRJ3oHOkl4+P6
 +tfrZTfBIG3YvMpf0+8dSthSSJ2u1H/ItSYOiy8k9hcXe7fMf0gxUYxcYtzRsxIFOSYO
 dfK2p9OGwwr91pi4zJzsVwG9XOir31qt1XZzQmqmOnfeRXujExqZ6eNatJLptUJ6FPZp
 vm8OotSH7VlwQBUbkk2RtVb4Vcj9ThJ1rZ4qCGhArAlfG4nsQd/0/5mV8IXEnG7/SfgC
 hO6niamolQo5lCCvq6wgjuJuf4rBdi8K3nT2I0xT11ir/cIyo4hTSMVcKuBVin4w1kHR
 262w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1LEpEDUHo2gcpiXlfn1kBdfZyXWOgvfnz55c2R2IVPY=;
 b=1Ur+YYSVSBj/BiIDPfcDLCSOi8CrAFIGdGVAXYdDCi2H5RcUhnSlmq4Y3XqfsvVQ41
 90h5Frn1h3wG/zVD/HUvpUXpCgbBkoynAx52LLu5W9bV7gsW+4bQMtIi1Gdep3Ou8R2Y
 eqke1c+XUqJMM0tXFOcHHcpz8xe7rRaA7vCY9tMUx5n1llqUhcgvKqPOHzQu0vpIFcAL
 ES6j66F4tq9g2iDPMJRLf4SVn78L8iH14n48jq655+OIQOY9mg5WhVYoxuuxNaf5DGyR
 tgCxgKQ9MSZNQh0W6p6BWUXXDZ9amfaJm6WjQX5/mEAiUg1vHYo3VBEN4O+NActkEaIz
 rkeA==
X-Gm-Message-State: AOAM533Dy8F5hDYo7x/UAWOCCbyA/RjuvERokTQtK3bi1rGksFON4/lK
 1EpjBonnY9NVI3nTsH7M1Z49tPmqTDSWIG4Pb7A6yBas3Gw=
X-Google-Smtp-Source: ABdhPJxUG6Jwlz7cjIDrRyhIKQ8bQaX2pj8mHUYi+XOsOXjVyH17huFW1uvK1/T9muAHNAc5woIAyXcrRtDR38WYS8I=
X-Received: by 2002:a81:3d0b:0:b0:2f4:b2ab:1c44 with SMTP id
 k11-20020a813d0b000000b002f4b2ab1c44mr414265ywa.11.1650557553909; Thu, 21 Apr
 2022 09:12:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-3-oupton@google.com>
In-Reply-To: <20220415215901.1737897-3-oupton@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Thu, 21 Apr 2022 09:12:23 -0700
Message-ID: <CANgfPd8RnH5ChHskgzO80p2zPrHMRB9ZkU7kNksNAaz1MiOb6g@mail.gmail.com>
Subject: Re: [RFC PATCH 02/17] KVM: arm64: Only read the pte once per visit
To: Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Thu, 21 Apr 2022 12:21:15 -0400
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
>
> A subsequent change to KVM will parallize modifications to the stage-2
> page tables. The various page table walkers read the ptep multiple
> times, which could lead to a visitor seeing multiple values during the
> visit.
>
> Pass through the observed pte to the visitor callbacks. Promote reads of
> the ptep to a full READ_ONCE(), which will matter more when we start
> tweaking ptes atomically. Note that a pointer to the old pte is given to
> visitors, as parallel visitors will need to steer the page table
> traversal as they adjust the page tables.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h  |   2 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |   7 +-
>  arch/arm64/kvm/hyp/nvhe/setup.c       |   9 +-
>  arch/arm64/kvm/hyp/pgtable.c          | 113 +++++++++++++-------------
>  4 files changed, 63 insertions(+), 68 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 9f339dffbc1a..ea818a5f7408 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -192,7 +192,7 @@ enum kvm_pgtable_walk_flags {
>  };
>
>  typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
> -                                       kvm_pte_t *ptep,
> +                                       kvm_pte_t *ptep, kvm_pte_t *old,
>                                         enum kvm_pgtable_walk_flags flag,
>                                         void * const arg);
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 78edf077fa3b..601a586581d8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -422,17 +422,16 @@ struct check_walk_data {
>  };
>
>  static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
> -                                     kvm_pte_t *ptep,
> +                                     kvm_pte_t *ptep, kvm_pte_t *old,
>                                       enum kvm_pgtable_walk_flags flag,
>                                       void * const arg)

David mentioned combining the ARM and x86 TDP MMUs, and I wonder if a
first step in that direction could be to adopt the TDP iter here. The
signatures of most of these functions are very similar to the fields
in the TDP iter and the TDP MMU might benefit from adopting some
version of kvm_pgtable_walk_flags.


>  {
>         struct check_walk_data *d = arg;
> -       kvm_pte_t pte = *ptep;
>
> -       if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
> +       if (kvm_pte_valid(*old) && !addr_is_memory(kvm_pte_to_phys(*old)))
>                 return -EINVAL;
>
> -       return d->get_page_state(pte) == d->desired ? 0 : -EPERM;
> +       return d->get_page_state(*old) == d->desired ? 0 : -EPERM;
>  }
>
>  static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 27af337f9fea..ecab7a4049d6 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -162,17 +162,16 @@ static void hpool_put_page(void *addr)
>  }
>
>  static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
> -                                        kvm_pte_t *ptep,
> +                                        kvm_pte_t *ptep, kvm_pte_t *old,
>                                          enum kvm_pgtable_walk_flags flag,
>                                          void * const arg)
>  {
>         struct kvm_pgtable_mm_ops *mm_ops = arg;
>         enum kvm_pgtable_prot prot;
>         enum pkvm_page_state state;
> -       kvm_pte_t pte = *ptep;
>         phys_addr_t phys;
>
> -       if (!kvm_pte_valid(pte))
> +       if (!kvm_pte_valid(*old))
>                 return 0;
>
>         /*
> @@ -187,7 +186,7 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
>         if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
>                 return -EINVAL;
>
> -       phys = kvm_pte_to_phys(pte);
> +       phys = kvm_pte_to_phys(*old);
>         if (!addr_is_memory(phys))
>                 return -EINVAL;
>
> @@ -195,7 +194,7 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
>          * Adjust the host stage-2 mappings to match the ownership attributes
>          * configured in the hypervisor stage-1.
>          */
> -       state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
> +       state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(*old));
>         switch (state) {
>         case PKVM_PAGE_OWNED:
>                 return host_stage2_set_owner_locked(phys, PAGE_SIZE, pkvm_hyp_id);
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index e1506da3e2fb..ad911cd44425 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -178,11 +178,11 @@ static u8 kvm_invalid_pte_owner(kvm_pte_t pte)
>  }
>
>  static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
> -                                 u32 level, kvm_pte_t *ptep,
> +                                 u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
>                                   enum kvm_pgtable_walk_flags flag)
>  {
>         struct kvm_pgtable_walker *walker = data->walker;
> -       return walker->cb(addr, data->end, level, ptep, flag, walker->arg);
> +       return walker->cb(addr, data->end, level, ptep, old, flag, walker->arg);
>  }
>
>  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> @@ -193,17 +193,17 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>  {
>         int ret = 0;
>         u64 addr = data->addr;
> -       kvm_pte_t *childp, pte = *ptep;
> +       kvm_pte_t *childp, pte = READ_ONCE(*ptep);
>         bool table = kvm_pte_table(pte, level);
>         enum kvm_pgtable_walk_flags flags = data->walker->flags;
>
>         if (table && (flags & KVM_PGTABLE_WALK_TABLE_PRE)) {
> -               ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
> +               ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
>                                              KVM_PGTABLE_WALK_TABLE_PRE);
>         }
>
>         if (!table && (flags & KVM_PGTABLE_WALK_LEAF)) {
> -               ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
> +               ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
>                                              KVM_PGTABLE_WALK_LEAF);
>                 pte = *ptep;
>                 table = kvm_pte_table(pte, level);
> @@ -224,7 +224,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>                 goto out;
>
>         if (flags & KVM_PGTABLE_WALK_TABLE_POST) {
> -               ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
> +               ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
>                                              KVM_PGTABLE_WALK_TABLE_POST);
>         }
>
> @@ -297,12 +297,12 @@ struct leaf_walk_data {
>         u32             level;
>  };
>
> -static int leaf_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +static int leaf_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
>                        enum kvm_pgtable_walk_flags flag, void * const arg)
>  {
>         struct leaf_walk_data *data = arg;
>
> -       data->pte   = *ptep;
> +       data->pte   = *old;
>         data->level = level;
>
>         return 0;
> @@ -388,10 +388,10 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
>         return prot;
>  }
>
> -static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> -                                   kvm_pte_t *ptep, struct hyp_map_data *data)
> +static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +                                   kvm_pte_t old, struct hyp_map_data *data)
>  {
> -       kvm_pte_t new, old = *ptep;
> +       kvm_pte_t new;
>         u64 granule = kvm_granule_size(level), phys = data->phys;
>
>         if (!kvm_block_mapping_supported(addr, end, phys, level))
> @@ -410,14 +410,14 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>         return true;
>  }
>
> -static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
>                           enum kvm_pgtable_walk_flags flag, void * const arg)
>  {
>         kvm_pte_t *childp;
>         struct hyp_map_data *data = arg;
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>
> -       if (hyp_map_walker_try_leaf(addr, end, level, ptep, arg))
> +       if (hyp_map_walker_try_leaf(addr, end, level, ptep, *old, arg))
>                 return 0;
>
>         if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
> @@ -461,19 +461,19 @@ struct hyp_unmap_data {
>         struct kvm_pgtable_mm_ops       *mm_ops;
>  };
>
> -static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
>                             enum kvm_pgtable_walk_flags flag, void * const arg)
>  {
> -       kvm_pte_t pte = *ptep, *childp = NULL;
> +       kvm_pte_t *childp = NULL;
>         u64 granule = kvm_granule_size(level);
>         struct hyp_unmap_data *data = arg;
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>
> -       if (!kvm_pte_valid(pte))
> +       if (!kvm_pte_valid(*old))
>                 return -EINVAL;
>
> -       if (kvm_pte_table(pte, level)) {
> -               childp = kvm_pte_follow(pte, mm_ops);
> +       if (kvm_pte_table(*old, level)) {
> +               childp = kvm_pte_follow(*old, mm_ops);
>
>                 if (mm_ops->page_count(childp) != 1)
>                         return 0;
> @@ -537,19 +537,18 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
>         return 0;
>  }
>
> -static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
>                            enum kvm_pgtable_walk_flags flag, void * const arg)
>  {
>         struct kvm_pgtable_mm_ops *mm_ops = arg;
> -       kvm_pte_t pte = *ptep;
>
> -       if (!kvm_pte_valid(pte))
> +       if (!kvm_pte_valid(*old))
>                 return 0;
>
>         mm_ops->put_page(ptep);
>
> -       if (kvm_pte_table(pte, level))
> -               mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
> +       if (kvm_pte_table(*old, level))
> +               mm_ops->put_page(kvm_pte_follow(*old, mm_ops));
>
>         return 0;
>  }
> @@ -723,10 +722,10 @@ static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
>  }
>
>  static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> -                                     kvm_pte_t *ptep,
> +                                     kvm_pte_t *ptep, kvm_pte_t old,
>                                       struct stage2_map_data *data)
>  {
> -       kvm_pte_t new, old = *ptep;
> +       kvm_pte_t new;
>         u64 granule = kvm_granule_size(level), phys = data->phys;
>         struct kvm_pgtable *pgt = data->mmu->pgt;
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> @@ -769,7 +768,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  }
>
>  static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
> -                                    kvm_pte_t *ptep,
> +                                    kvm_pte_t *ptep, kvm_pte_t *old,
>                                      struct stage2_map_data *data)
>  {
>         if (data->anchor)
> @@ -778,7 +777,7 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>         if (!stage2_leaf_mapping_allowed(addr, end, level, data))
>                 return 0;
>
> -       data->childp = kvm_pte_follow(*ptep, data->mm_ops);
> +       data->childp = kvm_pte_follow(*old, data->mm_ops);
>         kvm_clear_pte(ptep);
>
>         /*
> @@ -792,20 +791,20 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  }
>
>  static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> -                               struct stage2_map_data *data)
> +                               kvm_pte_t *old, struct stage2_map_data *data)
>  {
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> -       kvm_pte_t *childp, pte = *ptep;
> +       kvm_pte_t *childp;
>         int ret;
>
>         if (data->anchor) {
> -               if (stage2_pte_is_counted(pte))
> +               if (stage2_pte_is_counted(*old))
>                         mm_ops->put_page(ptep);
>
>                 return 0;
>         }
>
> -       ret = stage2_map_walker_try_leaf(addr, end, level, ptep, data);
> +       ret = stage2_map_walker_try_leaf(addr, end, level, ptep, *old, data);
>         if (ret != -E2BIG)
>                 return ret;
>
> @@ -824,7 +823,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>          * a table. Accesses beyond 'end' that fall within the new table
>          * will be mapped lazily.
>          */
> -       if (stage2_pte_is_counted(pte))
> +       if (stage2_pte_is_counted(*old))
>                 stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
>
>         kvm_set_table_pte(ptep, childp, mm_ops);
> @@ -834,7 +833,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  }
>
>  static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
> -                                     kvm_pte_t *ptep,
> +                                     kvm_pte_t *ptep, kvm_pte_t *old,
>                                       struct stage2_map_data *data)
>  {
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> @@ -848,9 +847,9 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
>                 childp = data->childp;
>                 data->anchor = NULL;
>                 data->childp = NULL;
> -               ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
> +               ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data);
>         } else {
> -               childp = kvm_pte_follow(*ptep, mm_ops);
> +               childp = kvm_pte_follow(*old, mm_ops);
>         }
>
>         mm_ops->put_page(childp);
> @@ -878,18 +877,18 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
>   * the page-table, installing the block entry when it revisits the anchor
>   * pointer and clearing the anchor to NULL.
>   */
> -static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
>                              enum kvm_pgtable_walk_flags flag, void * const arg)
>  {
>         struct stage2_map_data *data = arg;
>
>         switch (flag) {
>         case KVM_PGTABLE_WALK_TABLE_PRE:
> -               return stage2_map_walk_table_pre(addr, end, level, ptep, data);
> +               return stage2_map_walk_table_pre(addr, end, level, ptep, old, data);
>         case KVM_PGTABLE_WALK_LEAF:
> -               return stage2_map_walk_leaf(addr, end, level, ptep, data);
> +               return stage2_map_walk_leaf(addr, end, level, ptep, old, data);
>         case KVM_PGTABLE_WALK_TABLE_POST:
> -               return stage2_map_walk_table_post(addr, end, level, ptep, data);
> +               return stage2_map_walk_table_post(addr, end, level, ptep, old, data);
>         }
>
>         return -EINVAL;
> @@ -955,29 +954,29 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  }
>
>  static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> -                              enum kvm_pgtable_walk_flags flag,
> +                              kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
>                                void * const arg)
>  {
>         struct kvm_pgtable *pgt = arg;
>         struct kvm_s2_mmu *mmu = pgt->mmu;
>         struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> -       kvm_pte_t pte = *ptep, *childp = NULL;
> +       kvm_pte_t *childp = NULL;
>         bool need_flush = false;
>
> -       if (!kvm_pte_valid(pte)) {
> -               if (stage2_pte_is_counted(pte)) {
> +       if (!kvm_pte_valid(*old)) {
> +               if (stage2_pte_is_counted(*old)) {
>                         kvm_clear_pte(ptep);
>                         mm_ops->put_page(ptep);
>                 }
>                 return 0;
>         }
>
> -       if (kvm_pte_table(pte, level)) {
> -               childp = kvm_pte_follow(pte, mm_ops);
> +       if (kvm_pte_table(*old, level)) {
> +               childp = kvm_pte_follow(*old, mm_ops);
>
>                 if (mm_ops->page_count(childp) != 1)
>                         return 0;
> -       } else if (stage2_pte_cacheable(pgt, pte)) {
> +       } else if (stage2_pte_cacheable(pgt, *old)) {
>                 need_flush = !stage2_has_fwb(pgt);
>         }
>
> @@ -989,7 +988,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>         stage2_put_pte(ptep, mmu, addr, level, mm_ops);
>
>         if (need_flush && mm_ops->dcache_clean_inval_poc)
> -               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
> +               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(*old, mm_ops),
>                                                kvm_granule_size(level));
>
>         if (childp)
> @@ -1018,10 +1017,10 @@ struct stage2_attr_data {
>  };
>
>  static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> -                             enum kvm_pgtable_walk_flags flag,
> +                             kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
>                               void * const arg)
>  {
> -       kvm_pte_t pte = *ptep;
> +       kvm_pte_t pte = *old;
>         struct stage2_attr_data *data = arg;
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>
> @@ -1146,18 +1145,17 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>  }
>
>  static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> -                              enum kvm_pgtable_walk_flags flag,
> +                              kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
>                                void * const arg)
>  {
>         struct kvm_pgtable *pgt = arg;
>         struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> -       kvm_pte_t pte = *ptep;
>
> -       if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
> +       if (!kvm_pte_valid(*old) || !stage2_pte_cacheable(pgt, *old))
>                 return 0;
>
>         if (mm_ops->dcache_clean_inval_poc)
> -               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
> +               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(*old, mm_ops),
>                                                kvm_granule_size(level));
>         return 0;
>  }
> @@ -1206,19 +1204,18 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>  }
>
>  static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> -                             enum kvm_pgtable_walk_flags flag,
> +                             kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
>                               void * const arg)
>  {
>         struct kvm_pgtable_mm_ops *mm_ops = arg;
> -       kvm_pte_t pte = *ptep;
>
> -       if (!stage2_pte_is_counted(pte))
> +       if (!stage2_pte_is_counted(*old))
>                 return 0;
>
>         mm_ops->put_page(ptep);
>
> -       if (kvm_pte_table(pte, level))
> -               mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
> +       if (kvm_pte_table(*old, level))
> +               mm_ops->put_page(kvm_pte_follow(*old, mm_ops));
>
>         return 0;
>  }
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
