Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5387C432BE
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 09:37:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 409AF61102
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 09:37:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 409AF61102
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5B9540874;
	Mon,  2 Aug 2021 05:37:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oQ6zlkBDkxaH; Mon,  2 Aug 2021 05:37:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E8E64A1B0;
	Mon,  2 Aug 2021 05:37:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EE4A40874
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 05:37:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eJFtXURXjbVw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 05:37:38 -0400 (EDT)
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com
 [209.85.210.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F16C40856
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 05:37:38 -0400 (EDT)
Received: by mail-ot1-f49.google.com with SMTP id
 o2-20020a9d22020000b0290462f0ab0800so16923843ota.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 02:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ND2xr2Gchr8zIUl07q1TFZItRtPtYYT0O1VElqJbYnw=;
 b=S+vEXTSPVsHG592NB5lLgNE8Ks7GHrf3a+oBPWKhnHO/fynx3Al7qpm3fvsQyLy4Ek
 lbamxkex2aORWFP7PzrHpGgbxm2dWh6lmpQkIsd8lwav6Vsv8n9MyGesHTMhMzPc71DD
 0Y6mLkL/TGynorxYzaCiWslnprs9gu48GvGYYXc9pgLxRlZRcxa4x9srzXQfttVbM659
 M0m/o+Zm4eXkRTPHSk36YWyvYZG2zae9TnRFlLVdwaAPv98hZjH5JAUCo+YDb57p/Olj
 aGk0NXEVFujbG4bXYqrPZuInxzofhbDqYk8yYgT/jS4TaGu+ziJnJkPKtJknkPzqt+fC
 rZjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ND2xr2Gchr8zIUl07q1TFZItRtPtYYT0O1VElqJbYnw=;
 b=TqPNeDeLGmQqaSXQGdSwcNJQBQbKZuk6pGNkw6cCx4cRl3Xmbzi0dpm+AGUpTj9eyL
 Ixlu7l/y9hV22F5vYzVcyeB18a7u4gbUM6ogVuoAg1zpTsciIshsjKIqCeE4yAMOK+Q/
 OeaVh9R8S86nIPCGaUdBQi1PTHZ9Buw6lJd+TAbzOBFGCepMydB/pBVDHWAAlDZugg4K
 797flmKxUXkEuR3uQbaD+GdVwI9q1m4v3gaLNMyxVt8YvctL2UvbxDR4kd1vsDTMjcU+
 00kv7oC6Lopj8oowaRhzRIU0tTxxswVlDpZO+0OjA6SDpp3DRO6L3401iTVyPe+SB9p7
 AvWw==
X-Gm-Message-State: AOAM531GOZUg9a4Ip+A+qYa4OuXsYzTxlaz7ehCJcusJz0K6ngnOr4YG
 krLVHNjwcM0toiIeeIphLhroPUZ37yLZ/EFKtJ6dsQ==
X-Google-Smtp-Source: ABdhPJzjahBOfTcU+7lCaW+sLnpsSLRxbwaVqHbBKLyebX5eYH8Qjb6azpeyh0oAvOvCzvsH0Or5DvwNQzUTC0YHsag=
X-Received: by 2002:a9d:4b02:: with SMTP id q2mr11089669otf.52.1627897057328; 
 Mon, 02 Aug 2021 02:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-7-qperret@google.com>
In-Reply-To: <20210729132818.4091769-7-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Aug 2021 11:37:01 +0200
Message-ID: <CA+EHjTz20cf78XtAEgTZ4sqaL=N3fY0hd=_=rZge53nUv=vsjQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/21] KVM: arm64: Optimize host memory aborts
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
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

Hi Quentin,

On Thu, Jul 29, 2021 at 3:28 PM Quentin Perret <qperret@google.com> wrote:
>
> The kvm_pgtable_stage2_find_range() function is used in the host memory
> abort path to try and look for the largest block mapping that can be
> used to map the faulting address. In order to do so, the function
> currently walks the stage-2 page-table and looks for existing
> incompatible mappings within the range of the largest possible block.
> If incompatible mappings are found, it tries the same procedure again,
> but using a smaller block range, and repeats until a matching range is
> found (potentially up to page granularity). While this approach has
> benefits (mostly in the fact that it proactively coalesces host stage-2
> mappings), it can be slow if the ranges are fragmented, and it isn't
> optimized to deal with CPUs faulting on the same IPA as all of them will
> do all the work every time.
>
> To avoid these issues, remove kvm_pgtable_stage2_find_range(), and walk
> the page-table only once in the host_mem_abort() path to find the
> closest leaf to the input address. With this, use the corresponding
> range if it is invalid and not owned by another entity. If a valid leaf
> is found, return -EAGAIN similar to what is done in the
> kvm_pgtable_stage2_map() path to optimize concurrent faults.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewing the code it seems to work as described, with the lock
assertion ensuring that the caller knows which lock to hold.

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad


> ---
>  arch/arm64/include/asm/kvm_pgtable.h  | 30 -----------
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 45 +++++++++++++++-
>  arch/arm64/kvm/hyp/pgtable.c          | 74 ---------------------------
>  3 files changed, 44 insertions(+), 105 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 6938eac72c1f..83c5c97d9eac 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -154,16 +154,6 @@ enum kvm_pgtable_prot {
>  #define PAGE_HYP_RO            (KVM_PGTABLE_PROT_R)
>  #define PAGE_HYP_DEVICE                (PAGE_HYP | KVM_PGTABLE_PROT_DEVICE)
>
> -/**
> - * struct kvm_mem_range - Range of Intermediate Physical Addresses
> - * @start:     Start of the range.
> - * @end:       End of the range.
> - */
> -struct kvm_mem_range {
> -       u64 start;
> -       u64 end;
> -};
> -
>  /**
>   * enum kvm_pgtable_walk_flags - Flags to control a depth-first page-table walk.
>   * @KVM_PGTABLE_WALK_LEAF:             Visit leaf entries, including invalid
> @@ -490,24 +480,4 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   */
>  int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
>                          kvm_pte_t *ptep, u32 *level);
> -
> -/**
> - * kvm_pgtable_stage2_find_range() - Find a range of Intermediate Physical
> - *                                  Addresses with compatible permission
> - *                                  attributes.
> - * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> - * @addr:      Address that must be covered by the range.
> - * @prot:      Protection attributes that the range must be compatible with.
> - * @range:     Range structure used to limit the search space at call time and
> - *             that will hold the result.
> - *
> - * The offset of @addr within a page is ignored. An IPA is compatible with @prot
> - * iff its corresponding stage-2 page-table entry has default ownership and, if
> - * valid, is mapped with protection attributes identical to @prot.
> - *
> - * Return: 0 on success, negative error code on failure.
> - */
> -int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
> -                                 enum kvm_pgtable_prot prot,
> -                                 struct kvm_mem_range *range);
>  #endif /* __ARM64_KVM_PGTABLE_H__ */
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 74280a753efb..2148d3968aa5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -159,6 +159,11 @@ static int host_stage2_unmap_dev_all(void)
>         return kvm_pgtable_stage2_unmap(pgt, addr, BIT(pgt->ia_bits) - addr);
>  }
>
> +struct kvm_mem_range {
> +       u64 start;
> +       u64 end;
> +};
> +
>  static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
>  {
>         int cur, left = 0, right = hyp_memblock_nr;
> @@ -227,6 +232,44 @@ static inline int __host_stage2_idmap(u64 start, u64 end,
>                 __ret;                                                  \
>          })
>
> +static inline bool range_included(struct kvm_mem_range *child,
> +                                 struct kvm_mem_range *parent)
> +{
> +       return parent->start <= child->start && child->end <= parent->end;
> +}
> +
> +static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
> +{
> +       struct kvm_mem_range cur;
> +       kvm_pte_t pte;
> +       u32 level;
> +       int ret;
> +
> +       hyp_assert_lock_held(&host_kvm.lock);
> +       ret = kvm_pgtable_get_leaf(&host_kvm.pgt, addr, &pte, &level);
> +       if (ret)
> +               return ret;
> +
> +       if (kvm_pte_valid(pte))
> +               return -EAGAIN;
> +
> +       if (pte)
> +               return -EPERM;
> +
> +       do {
> +               u64 granule = kvm_granule_size(level);
> +               cur.start = ALIGN_DOWN(addr, granule);
> +               cur.end = cur.start + granule;
> +               level++;
> +       } while ((level < KVM_PGTABLE_MAX_LEVELS) &&
> +                       !(kvm_level_supports_block_mapping(level) &&
> +                         range_included(&cur, range)));
> +
> +       *range = cur;
> +
> +       return 0;
> +}
> +
>  static int host_stage2_idmap(u64 addr)
>  {
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
> @@ -238,7 +281,7 @@ static int host_stage2_idmap(u64 addr)
>                 prot |= KVM_PGTABLE_PROT_X;
>
>         hyp_spin_lock(&host_kvm.lock);
> -       ret = kvm_pgtable_stage2_find_range(&host_kvm.pgt, addr, prot, &range);
> +       ret = host_stage2_adjust_range(addr, &range);
>         if (ret)
>                 goto unlock;
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 49d768b92997..4dff2ad39ee4 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1102,77 +1102,3 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>         pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
>         pgt->pgd = NULL;
>  }
> -
> -#define KVM_PTE_LEAF_S2_COMPAT_MASK    (KVM_PTE_LEAF_ATTR_S2_PERMS | \
> -                                        KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR | \
> -                                        KVM_PTE_LEAF_ATTR_S2_IGNORED)
> -
> -static int stage2_check_permission_walker(u64 addr, u64 end, u32 level,
> -                                         kvm_pte_t *ptep,
> -                                         enum kvm_pgtable_walk_flags flag,
> -                                         void * const arg)
> -{
> -       kvm_pte_t old_attr, pte = *ptep, *new_attr = arg;
> -
> -       /*
> -        * Compatible mappings are either invalid and owned by the page-table
> -        * owner (whose id is 0), or valid with matching permission attributes.
> -        */
> -       if (kvm_pte_valid(pte)) {
> -               old_attr = pte & KVM_PTE_LEAF_S2_COMPAT_MASK;
> -               if (old_attr != *new_attr)
> -                       return -EEXIST;
> -       } else if (pte) {
> -               return -EEXIST;
> -       }
> -
> -       return 0;
> -}
> -
> -int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
> -                                 enum kvm_pgtable_prot prot,
> -                                 struct kvm_mem_range *range)
> -{
> -       kvm_pte_t attr;
> -       struct kvm_pgtable_walker check_perm_walker = {
> -               .cb             = stage2_check_permission_walker,
> -               .flags          = KVM_PGTABLE_WALK_LEAF,
> -               .arg            = &attr,
> -       };
> -       u64 granule, start, end;
> -       u32 level;
> -       int ret;
> -
> -       ret = stage2_set_prot_attr(pgt, prot, &attr);
> -       if (ret)
> -               return ret;
> -       attr &= KVM_PTE_LEAF_S2_COMPAT_MASK;
> -
> -       for (level = pgt->start_level; level < KVM_PGTABLE_MAX_LEVELS; level++) {
> -               granule = kvm_granule_size(level);
> -               start = ALIGN_DOWN(addr, granule);
> -               end = start + granule;
> -
> -               if (!kvm_level_supports_block_mapping(level))
> -                       continue;
> -
> -               if (start < range->start || range->end < end)
> -                       continue;
> -
> -               /*
> -                * Check the presence of existing mappings with incompatible
> -                * permissions within the current block range, and try one level
> -                * deeper if one is found.
> -                */
> -               ret = kvm_pgtable_walk(pgt, start, granule, &check_perm_walker);
> -               if (ret != -EEXIST)
> -                       break;
> -       }
> -
> -       if (!ret) {
> -               range->start = start;
> -               range->end = end;
> -       }
> -
> -       return ret;
> -}
> --
> 2.32.0.432.gabb21c7263-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
