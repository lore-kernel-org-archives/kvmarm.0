Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA81C48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 09:31:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 42F56613E1
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 09:31:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42F56613E1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6838407A0;
	Fri, 18 Jun 2021 05:31:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D7zTaOoOmXOS; Fri, 18 Jun 2021 05:31:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CFBF40808;
	Fri, 18 Jun 2021 05:31:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 230174075E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 05:31:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fwzx-2RaI51I for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 05:31:18 -0400 (EDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com
 [209.85.210.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 40A99406E0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 05:31:18 -0400 (EDT)
Received: by mail-ot1-f51.google.com with SMTP id
 k10-20020a056830168ab029044d922f6a45so712924otr.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 02:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=GPeRH4hmuREp1clHnwfw9qScnyR9MdpgxRYZe37BmEE=;
 b=pMSTcZFHJwl7kCAJEOdswnD5xOFqmsX98UB70ZEyYyVDghAwEyBerXqBibqrwow426
 yYBrOM2azwYmGF0JUPol1DBiNdkCs2o+AbOr5zS2BZvBP7Bo/lOrQBaAFeDJMADVMUOc
 HMtUq1tBiceMSgQ+1vmfrwbVbBLDV2zCSmu6SY1yMrS29xfsUn+pHtiIPJ5C+zOlrIwF
 Doqgjl6y7HYDtSLnuUtyvBkn8GJGMrJiKa+yLUDCC96txA8mXVHkVfrYm4NJoXwNygFT
 PlyYTn2U4T+GPsGlZfm3oRU4ndDDo54s50l9cbhFV04x3ACVmJvG2EGZ9A7IJ84clsbc
 Cydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=GPeRH4hmuREp1clHnwfw9qScnyR9MdpgxRYZe37BmEE=;
 b=g+PSlOytwGtjAdvuNqAUP9LPzfqK75NX5V5FqhNd6wFhf7w8byxKxlaNTfzE7v5Qkw
 JmWGH9WqJsTvHnWWx3MYjJLVXdSBXiZrxTV1m1npjrDfvsjg9kI1/qQzln70Lj8iH23u
 WLaPuloaTm4TELusZb1Czn1PyXcFkwn8tLQo33N0S+SUgON37PGw+2ih6sKmK/DwtFsY
 l62rgB0tbQCbfzD7FN6Tj41oa1+zMn64tZReVBe/DOhG0Q52UlQxbKpdw08NnysbBubT
 pKxgoOIhA+GuXr1m+y6KWApGezsWYiZsYgo8M8SnQGebT72mCGhg5t69TsmlBqibem3L
 pwxA==
X-Gm-Message-State: AOAM533yMravee4xAJDYY0NnVeDv2joSyF3umlIe/zlDddzAZPNw/syv
 YkuFLMShRYjb0saxFtrYqDXleOfRYr4eH3xQSeMMZA==
X-Google-Smtp-Source: ABdhPJxVoa7NUzYSI/4DLiCN8uOQHMqLW6VjWnPqO/JD7BrK7yJsXK7EgA1NjRBHG201hJaR49+Az4O/feUcYx9iF30=
X-Received: by 2002:a05:6830:1598:: with SMTP id
 i24mr8609437otr.52.1624008677336; 
 Fri, 18 Jun 2021 02:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210617105824.31752-1-wangyanan55@huawei.com>
 <20210617105824.31752-5-wangyanan55@huawei.com>
In-Reply-To: <20210617105824.31752-5-wangyanan55@huawei.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 18 Jun 2021 10:30:41 +0100
Message-ID: <CA+EHjTynd1bosv862Py6_pxEe62aH466Jzw30MKkFskKzN6ODg@mail.gmail.com>
Subject: Re: [PATCH v7 4/4] KVM: arm64: Move guest CMOs to the fault handlers
To: Yanan Wang <wangyanan55@huawei.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Yanan,

On Thu, Jun 17, 2021 at 11:58 AM Yanan Wang <wangyanan55@huawei.com> wrote:
>
> We currently uniformly permorm CMOs of D-cache and I-cache in function

Nit: permorm -> perform

> user_mem_abort before calling the fault handlers. If we get concurrent
> guest faults(e.g. translation faults, permission faults) or some really
> unnecessary guest faults caused by BBM, CMOs for the first vcpu are
> necessary while the others later are not.
>
> By moving CMOs to the fault handlers, we can easily identify conditions
> where they are really needed and avoid the unnecessary ones. As it's a
> time consuming process to perform CMOs especially when flushing a block
> range, so this solution reduces much load of kvm and improve efficiency
> of the stage-2 page table code.
>
> We can imagine two specific scenarios which will gain much benefit:
> 1) In a normal VM startup, this solution will improve the efficiency of
> handling guest page faults incurred by vCPUs, when initially populating
> stage-2 page tables.
> 2) After live migration, the heavy workload will be resumed on the
> destination VM, however all the stage-2 page tables need to be rebuilt
> at the moment. So this solution will ease the performance drop during
> resuming stage.
>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 38 +++++++++++++++++++++++++++++-------
>  arch/arm64/kvm/mmu.c         | 37 ++++++++++++++---------------------
>  2 files changed, 46 insertions(+), 29 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index d99789432b05..760c551f61da 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -577,12 +577,24 @@ static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
>         mm_ops->put_page(ptep);
>  }
>
> +static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
> +{
> +       u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
> +       return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
> +}
> +
> +static bool stage2_pte_executable(kvm_pte_t pte)
> +{
> +       return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
> +}
> +
>  static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>                                       kvm_pte_t *ptep,
>                                       struct stage2_map_data *data)
>  {
>         kvm_pte_t new, old = *ptep;
>         u64 granule = kvm_granule_size(level), phys = data->phys;
> +       struct kvm_pgtable *pgt = data->mmu->pgt;
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>
>         if (!kvm_block_mapping_supported(addr, end, phys, level))
> @@ -606,6 +618,14 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>                 stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
>         }
>
> +       /* Perform CMOs before installation of the guest stage-2 PTE */
> +       if (mm_ops->clean_invalidate_dcache && stage2_pte_cacheable(pgt, new))
> +               mm_ops->clean_invalidate_dcache(kvm_pte_follow(new, mm_ops),
> +                                               granule);
> +
> +       if (mm_ops->invalidate_icache && stage2_pte_executable(new))
> +               mm_ops->invalidate_icache(kvm_pte_follow(new, mm_ops), granule);
> +
>         smp_store_release(ptep, new);
>         if (stage2_pte_is_counted(new))
>                 mm_ops->get_page(ptep);
> @@ -798,12 +818,6 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>         return ret;
>  }
>
> -static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
> -{
> -       u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
> -       return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
> -}
> -
>  static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>                                enum kvm_pgtable_walk_flags flag,
>                                void * const arg)
> @@ -874,6 +888,7 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  {
>         kvm_pte_t pte = *ptep;
>         struct stage2_attr_data *data = arg;
> +       struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>
>         if (!kvm_pte_valid(pte))
>                 return 0;
> @@ -888,8 +903,17 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>          * but worst-case the access flag update gets lost and will be
>          * set on the next access instead.
>          */
> -       if (data->pte != pte)
> +       if (data->pte != pte) {
> +               /*
> +                * Invalidate instruction cache before updating the guest
> +                * stage-2 PTE if we are going to add executable permission.
> +                */
> +               if (mm_ops->invalidate_icache &&
> +                   stage2_pte_executable(pte) && !stage2_pte_executable(*ptep))
> +                       mm_ops->invalidate_icache(kvm_pte_follow(pte, mm_ops),
> +                                                 kvm_granule_size(level));
>                 WRITE_ONCE(*ptep, pte);
> +       }
>
>         return 0;
>  }
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index b980f8a47cbb..c9f002d74ab4 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -434,14 +434,16 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>  }
>
>  static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
> -       .zalloc_page            = stage2_memcache_zalloc_page,
> -       .zalloc_pages_exact     = kvm_host_zalloc_pages_exact,
> -       .free_pages_exact       = free_pages_exact,
> -       .get_page               = kvm_host_get_page,
> -       .put_page               = kvm_host_put_page,
> -       .page_count             = kvm_host_page_count,
> -       .phys_to_virt           = kvm_host_va,
> -       .virt_to_phys           = kvm_host_pa,
> +       .zalloc_page                    = stage2_memcache_zalloc_page,
> +       .zalloc_pages_exact             = kvm_host_zalloc_pages_exact,
> +       .free_pages_exact               = free_pages_exact,
> +       .get_page                       = kvm_host_get_page,
> +       .put_page                       = kvm_host_put_page,
> +       .page_count                     = kvm_host_page_count,
> +       .phys_to_virt                   = kvm_host_va,
> +       .virt_to_phys                   = kvm_host_pa,
> +       .clean_invalidate_dcache        = clean_dcache_guest_page,
> +       .invalidate_icache              = invalidate_icache_guest_page,
>  };
>
>  /**
> @@ -1012,15 +1014,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (writable)
>                 prot |= KVM_PGTABLE_PROT_W;
>
> -       if (fault_status != FSC_PERM && !device)
> -               clean_dcache_guest_page(page_address(pfn_to_page(pfn)),
> -                                       vma_pagesize);
> -
> -       if (exec_fault) {
> +       if (exec_fault)
>                 prot |= KVM_PGTABLE_PROT_X;
> -               invalidate_icache_guest_page(page_address(pfn_to_page(pfn)),
> -                                            vma_pagesize);
> -       }
>
>         if (device)
>                 prot |= KVM_PGTABLE_PROT_DEVICE;
> @@ -1218,12 +1213,10 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>         WARN_ON(range->end - range->start != 1);
>
>         /*
> -        * We've moved a page around, probably through CoW, so let's treat it
> -        * just like a translation fault and clean the cache to the PoC.
> -        */
> -       clean_dcache_guest_page(page_address(pfn_to_page(pfn), PAGE_SIZE);
> -
> -       /*
> +        * We've moved a page around, probably through CoW, so let's treat
> +        * it just like a translation fault and the map handler will clean
> +        * the cache to the PoC.
> +        *
>          * The MMU notifiers will have unmapped a huge PMD before calling
>          * ->change_pte() (which in turn calls kvm_set_spte_gfn()) and
>          * therefore we never need to clear out a huge PMD through this

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

> --
> 2.23.0
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
