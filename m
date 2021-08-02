Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA0FC432BE
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 09:50:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B998C61050
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 09:50:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B998C61050
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3439340C88;
	Mon,  2 Aug 2021 05:50:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IPFH5p2tLPZX; Mon,  2 Aug 2021 05:50:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A04D54A4A4;
	Mon,  2 Aug 2021 05:50:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38CE64A523
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 05:50:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hfHaKxbOyeqh for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 05:50:05 -0400 (EDT)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com
 [209.85.210.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50CCE40CF9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 05:50:05 -0400 (EDT)
Received: by mail-ot1-f45.google.com with SMTP id
 48-20020a9d0bb30000b02904cd671b911bso17001530oth.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 02:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=27VDiaPBGDTPhcohzobMgkm8ZmwHuUJ7udrzJi4tuvc=;
 b=KwaDrU/GuaBreNc4rFLuoOXteM2wGnTioVMmiP58NHqPjUdDlM+fTBRDEm3KhRsERE
 JZn0HQYkWimyXNerlHOP1wDWIZy03v4m36raIH29HA2ccj8+k1+CN21EwSqr44YaQE/U
 rSDotWVmWZtjqwqSkBhH7xSNtxBs8mnZymVlZ6zr0LJhMfbZjwifATcksJKZPxJj4xHG
 TMRYgt2kRLmc4WAgF/C49v3A8tP0r8cl8TdHaetcSGSBP0yJmeQBceO48RDX59M0Tg8a
 gqjlTn5IU54g3y1vVYbJ2En8o1VWGsSsaF3861RHfmgvggBKMNcGmKVZORRaT97wUBkj
 a9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=27VDiaPBGDTPhcohzobMgkm8ZmwHuUJ7udrzJi4tuvc=;
 b=lDx33xPYzxVaiun5EYr9oFYkkSi8h2XTp5QU3CWQXtTdS/227ioaMFTqPCir31dLvW
 kGXDm4xhwQ4I/1oI7Iz0KBn6w+T3mbyw8Y2dHhxgwZEZ0bCd8VBARTUFBRGXVhP6IoL6
 Kiw14mJMnwdd3yZwMTfJfdohl4MvLmvPrMbhDVZy1K7BVTSEESiXncU4IXxkM9AWpyMf
 jqedJdognonWI1S3yqEUeyT2BId6B1q1AEtvRSH+fa4zorzFE8FaLTnd2aWHCXYH92Rr
 W7yEUWkH6vretgXpiY9qv3cIQ4jTyPBXuJCeURijxP3BdygMpLAmdVbBmfft0SNlqicY
 myIQ==
X-Gm-Message-State: AOAM531V42sDLRcrgo6TxIcEVmuBZkvwjDhnyo797cE78ziA5I98Zp1+
 kytbzW0WwlFt8Q2bWRbfkz83eUCjLW8or5O367hADg==
X-Google-Smtp-Source: ABdhPJwxTh4gYveW/2GLgdko+ZVBpUlMTzZU+i3LzdxGvyu4z73pDYvqkviRV96bkFN38FlvRYPdbuSsRyWR0FmF3iI=
X-Received: by 2002:a9d:600a:: with SMTP id h10mr10828789otj.144.1627897804366; 
 Mon, 02 Aug 2021 02:50:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-11-qperret@google.com>
In-Reply-To: <20210729132818.4091769-11-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Aug 2021 11:49:28 +0200
Message-ID: <CA+EHjTxCvqQ=jmBPJ1N6ShBf=f4J5cjT4pt9akfnqNjQUoqzWw@mail.gmail.com>
Subject: Re: [PATCH v3 10/21] KVM: arm64: Enable forcing page-level stage-2
 mappings
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
> Much of the stage-2 manipulation logic relies on being able to destroy
> block mappings if e.g. installing a smaller mapping in the range. The
> rationale for this behaviour is that stage-2 mappings can always be
> re-created lazily. However, this gets more complicated when the stage-2
> page-table is used to store metadata about the underlying pages. In such
> cases, destroying a block mapping may lead to losing part of the state,
> and confuse the user of those metadata (such as the hypervisor in nVHE
> protected mode).
>
> To avoid this, introduce a callback function in the pgtable struct which
> is called during all map operations to determine whether the mappings
> can use blocks, or should be forced to page granularity. This is used by
> the hypervisor when creating the host stage-2 to force page-level
> mappings when using non-default protection attributes.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h  | 65 ++++++++++++++++-----------
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 30 +++++++++++--
>  arch/arm64/kvm/hyp/pgtable.c          | 29 +++++++++---
>  3 files changed, 91 insertions(+), 33 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 83c5c97d9eac..ba7dcade2798 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -115,25 +115,6 @@ enum kvm_pgtable_stage2_flags {
>         KVM_PGTABLE_S2_IDMAP                    = BIT(1),
>  };
>
> -/**
> - * struct kvm_pgtable - KVM page-table.
> - * @ia_bits:           Maximum input address size, in bits.
> - * @start_level:       Level at which the page-table walk starts.
> - * @pgd:               Pointer to the first top-level entry of the page-table.
> - * @mm_ops:            Memory management callbacks.
> - * @mmu:               Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
> - */
> -struct kvm_pgtable {
> -       u32                                     ia_bits;
> -       u32                                     start_level;
> -       kvm_pte_t                               *pgd;
> -       struct kvm_pgtable_mm_ops               *mm_ops;
> -
> -       /* Stage-2 only */
> -       struct kvm_s2_mmu                       *mmu;
> -       enum kvm_pgtable_stage2_flags           flags;
> -};
> -
>  /**
>   * enum kvm_pgtable_prot - Page-table permissions and attributes.
>   * @KVM_PGTABLE_PROT_X:                Execute permission.
> @@ -149,11 +130,41 @@ enum kvm_pgtable_prot {
>         KVM_PGTABLE_PROT_DEVICE                 = BIT(3),
>  };
>
> -#define PAGE_HYP               (KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
> +#define KVM_PGTABLE_PROT_RW    (KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
> +#define KVM_PGTABLE_PROT_RWX   (KVM_PGTABLE_PROT_RW | KVM_PGTABLE_PROT_X)
> +
> +#define PAGE_HYP               KVM_PGTABLE_PROT_RW
>  #define PAGE_HYP_EXEC          (KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_X)
>  #define PAGE_HYP_RO            (KVM_PGTABLE_PROT_R)
>  #define PAGE_HYP_DEVICE                (PAGE_HYP | KVM_PGTABLE_PROT_DEVICE)

I wonder if it would be useful to add a couple of other aliases for
default memory and default mmio protections, e.g.,

#define  KVM_PGTABLE_PROT_MEM KVM_PGTABLE_PROT_RWX
#define  KVM_PGTABLE_PROT_MMIO KVM_PGTABLE_PROT_RW

I think that using these below, e.g., host_stage2_force_pte_cb(),
might make it clearer and answer comments you had in earlier patches
about why "RWX" for memory.

>
> +typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
> +                                          enum kvm_pgtable_prot prot);
> +
> +/**
> + * struct kvm_pgtable - KVM page-table.
> + * @ia_bits:           Maximum input address size, in bits.
> + * @start_level:       Level at which the page-table walk starts.
> + * @pgd:               Pointer to the first top-level entry of the page-table.
> + * @mm_ops:            Memory management callbacks.
> + * @mmu:               Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
> + * @flags:             Stage-2 page-table flags.
> + * @force_pte_cb:      Callback function used during map operations to decide
> + *                     whether block mappings can be used to map the given IPA
> + *                     range.
> + */

nit: I think it might be clearer (and probably not longer) to rephrase
to describe in terms of the return value of the callback, e.g., "...
function that returns true if page level mappings must be used instead
of block mappings."

> +struct kvm_pgtable {
> +       u32                                     ia_bits;
> +       u32                                     start_level;
> +       kvm_pte_t                               *pgd;
> +       struct kvm_pgtable_mm_ops               *mm_ops;
> +
> +       /* Stage-2 only */
> +       struct kvm_s2_mmu                       *mmu;
> +       enum kvm_pgtable_stage2_flags           flags;
> +       kvm_pgtable_force_pte_cb_t              force_pte_cb;
> +};
> +
>  /**
>   * enum kvm_pgtable_walk_flags - Flags to control a depth-first page-table walk.
>   * @KVM_PGTABLE_WALK_LEAF:             Visit leaf entries, including invalid
> @@ -246,21 +257,25 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
>  u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
>
>  /**
> - * kvm_pgtable_stage2_init_flags() - Initialise a guest stage-2 page-table.
> + * __kvm_pgtable_stage2_init() - Initialise a guest stage-2 page-table.
>   * @pgt:       Uninitialised page-table structure to initialise.
>   * @arch:      Arch-specific KVM structure representing the guest virtual
>   *             machine.
>   * @mm_ops:    Memory management callbacks.
>   * @flags:     Stage-2 configuration flags.
> + * @force_pte_cb: Callback function used during map operations to decide
> + *             whether block mappings can be used to map the given IPA
> + *             range.

nit: same nit as above with describing the callback in terms of its return value

>   *
>   * Return: 0 on success, negative error code on failure.
>   */
> -int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch,
> -                                 struct kvm_pgtable_mm_ops *mm_ops,
> -                                 enum kvm_pgtable_stage2_flags flags);
> +int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
> +                             struct kvm_pgtable_mm_ops *mm_ops,
> +                             enum kvm_pgtable_stage2_flags flags,
> +                             kvm_pgtable_force_pte_cb_t force_pte_cb);
>
>  #define kvm_pgtable_stage2_init(pgt, arch, mm_ops) \
> -       kvm_pgtable_stage2_init_flags(pgt, arch, mm_ops, 0)
> +       __kvm_pgtable_stage2_init(pgt, arch, mm_ops, 0, NULL)
>
>  /**
>   * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 2148d3968aa5..70c57d2c3024 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -89,6 +89,7 @@ static void prepare_host_vtcr(void)
>                                           id_aa64mmfr1_el1_sys_val, phys_shift);
>  }
>
> +static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot);

nit: newline

>  int kvm_host_prepare_stage2(void *pgt_pool_base)
>  {
>         struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
> @@ -101,8 +102,9 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
>         if (ret)
>                 return ret;
>
> -       ret = kvm_pgtable_stage2_init_flags(&host_kvm.pgt, &host_kvm.arch,
> -                                           &host_kvm.mm_ops, KVM_HOST_S2_FLAGS);
> +       ret = __kvm_pgtable_stage2_init(&host_kvm.pgt, &host_kvm.arch,
> +                                       &host_kvm.mm_ops, KVM_HOST_S2_FLAGS,
> +                                       host_stage2_force_pte_cb);
>         if (ret)
>                 return ret;
>
> @@ -270,9 +272,31 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
>         return 0;
>  }
>
> +static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
> +{
> +       /*
> +        * Block mappings must be used with care in the host stage-2 as a
> +        * kvm_pgtable_stage2_map() operation targeting a page in the range of
> +        * an existing block will delete the block under the assumption that
> +        * mappings in the rest of the block range can always be rebuilt lazily.
> +        * That assumption is correct for the host stage-2 with RWX mappings
> +        * targeting memory or RW mappings targeting MMIO ranges (see
> +        * host_stage2_idmap() below which implements some of the host memory
> +        * abort logic). However, this is not safe for any other mappings where
> +        * the host stage-2 page-table is in fact the only place where this
> +        * state is stored. In all those cases, it is safer to use page-level
> +        * mappings, hence avoiding to lose the state because of side-effects in
> +        * kvm_pgtable_stage2_map().
> +        */
> +       if (range_is_memory(addr, end))
> +               return prot != KVM_PGTABLE_PROT_RWX;
> +       else
> +               return prot != KVM_PGTABLE_PROT_RW;
> +}

Just checking, I don't think that it's possible for the range to be
big enough to somehow include both memory and mmio, neither now nor in
future use cases, is it?

> +
>  static int host_stage2_idmap(u64 addr)
>  {
> -       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
> +       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_RW;
>         struct kvm_mem_range range;
>         bool is_memory = find_mem_range(addr, &range);
>         int ret;
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 2689fcb7901d..bcc02e6e0f62 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -452,6 +452,8 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
>         pgt->start_level        = KVM_PGTABLE_MAX_LEVELS - levels;
>         pgt->mm_ops             = mm_ops;
>         pgt->mmu                = NULL;
> +       pgt->force_pte_cb       = NULL;
> +
>         return 0;
>  }
>
> @@ -489,6 +491,9 @@ struct stage2_map_data {
>         void                            *memcache;
>
>         struct kvm_pgtable_mm_ops       *mm_ops;
> +
> +       /* Force mappings to page granularity */
> +       bool                            force_pte;
>  };
>
>  u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
> @@ -602,6 +607,15 @@ static bool stage2_pte_executable(kvm_pte_t pte)
>         return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
>  }
>
> +static bool stage2_block_mapping_allowed(u64 addr, u64 end, u32 level,
> +                                        struct stage2_map_data *data)
> +{
> +       if (data->force_pte && (level < (KVM_PGTABLE_MAX_LEVELS - 1)))
> +               return false;

I'm not sure I understand why checking the level is necessary. Can
there be block mapping at the last possible level?

Thanks,
/fuad

> +
> +       return kvm_block_mapping_supported(addr, end, data->phys, level);
> +}
> +
>  static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>                                       kvm_pte_t *ptep,
>                                       struct stage2_map_data *data)
> @@ -611,7 +625,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>         struct kvm_pgtable *pgt = data->mmu->pgt;
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>
> -       if (!kvm_block_mapping_supported(addr, end, phys, level))
> +       if (!stage2_block_mapping_allowed(addr, end, level, data))
>                 return -E2BIG;
>
>         if (kvm_phys_is_valid(phys))
> @@ -655,7 +669,7 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>         if (data->anchor)
>                 return 0;
>
> -       if (!kvm_block_mapping_supported(addr, end, data->phys, level))
> +       if (!stage2_block_mapping_allowed(addr, end, level, data))
>                 return 0;
>
>         data->childp = kvm_pte_follow(*ptep, data->mm_ops);
> @@ -785,6 +799,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>                 .mmu            = pgt->mmu,
>                 .memcache       = mc,
>                 .mm_ops         = pgt->mm_ops,
> +               .force_pte      = pgt->force_pte_cb && pgt->force_pte_cb(addr, addr + size, prot),
>         };
>         struct kvm_pgtable_walker walker = {
>                 .cb             = stage2_map_walker,
> @@ -816,6 +831,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>                 .memcache       = mc,
>                 .mm_ops         = pgt->mm_ops,
>                 .owner_id       = owner_id,
> +               .force_pte      = true,
>         };
>         struct kvm_pgtable_walker walker = {
>                 .cb             = stage2_map_walker,
> @@ -1057,9 +1073,11 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>         return kvm_pgtable_walk(pgt, addr, size, &walker);
>  }
>
> -int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch,
> -                                 struct kvm_pgtable_mm_ops *mm_ops,
> -                                 enum kvm_pgtable_stage2_flags flags)
> +
> +int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
> +                             struct kvm_pgtable_mm_ops *mm_ops,
> +                             enum kvm_pgtable_stage2_flags flags,
> +                             kvm_pgtable_force_pte_cb_t force_pte_cb)
>  {
>         size_t pgd_sz;
>         u64 vtcr = arch->vtcr;
> @@ -1077,6 +1095,7 @@ int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch
>         pgt->mm_ops             = mm_ops;
>         pgt->mmu                = &arch->mmu;
>         pgt->flags              = flags;
> +       pgt->force_pte_cb       = force_pte_cb;
>
>         /* Ensure zeroed PGD pages are visible to the hardware walker */
>         dsb(ishst);
> --
> 2.32.0.432.gabb21c7263-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
