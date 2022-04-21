Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D5CC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 22 Apr 2022 17:50:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFCDF4B252;
	Fri, 22 Apr 2022 13:50:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ncM-tzb-WvNZ; Fri, 22 Apr 2022 13:50:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63C1D4B28B;
	Fri, 22 Apr 2022 13:50:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B66CD4B26A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:28:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bIW34tBON06u for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 12:28:49 -0400 (EDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com
 [209.85.219.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 699224B268
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:28:49 -0400 (EDT)
Received: by mail-yb1-f173.google.com with SMTP id v10so898376ybe.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 09:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Q8KjLP1ge6CAoQAgMyteAhGdc8R9b0Iwu1CbYU0QQX4=;
 b=CqNIj/zOCypJLipQuaEFIj7/HD2atvqJ0uUBCe49uKo0kO0SHINqVVrjlaDqeYDAZR
 bAKx3M9A9Q0gA3BiaqR5QGSxrnIpvK5r2BWpMk7PDvLvrl4ipiS2NYoUj4vqOk0KWWrM
 OrRdpyxWnHlZRnBeKonn4dOGH+FadwcvHiDztfe6fxP6wymeQ+THyqa6aFQrGbLVnw74
 BuzES2xxXbHQKYPW4j/2qy4TuJSynnKlRxo4wd2kBnKFSLtmHC6gkKPtW7vn5NWpc6sS
 qMBuXInD+TPKuDbCkD9fs5xkh+3UQHjBOFgrzdbBelaam+es7LEOjV6NLAykJR8cBM5v
 dvlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Q8KjLP1ge6CAoQAgMyteAhGdc8R9b0Iwu1CbYU0QQX4=;
 b=y+1NyKtbjv7kinUy294/1TwcfNWeImmn8WJfDiqQCUjpmi3WT+xhtnSKLXoE9Y2PUd
 j7eB4pvdX4MUOvO7vTt6zMrJ1Cdqt+q70OsbVd2sDTJXc4JWHxgnKEx2JKPh6O1Uw0yT
 UXPB1qxWR4svA5NuBWf2r67SpkbErLXb3ngRBwBTOkbF3xodjlXYlyrcjHijRFB3mw//
 gQeHOFttMGq1B2pURq3/cqo5Z4UooBBk51lq4rwsnta9HzoIoSDKpWkRQjRk3aiiT6Tr
 cYqdMuL8wvcKDOTodwLkcsQEx+B7QYwrEwRuV6llKpPoEJ884l2PJ1Eao7aRmezrWNgv
 6qIw==
X-Gm-Message-State: AOAM5337wChXKd2Kc5csp4WWC0gnnmxFQRrD579uWA3zYZEt8zm0iI5E
 8l3FJNqa6PJKPX32Fh3LvebkW8ywnzTUJQX+MGOGeA==
X-Google-Smtp-Source: ABdhPJyFf1PQK+nJfwVXpStSPYFXSi6lgr/C7HjJzsJXnb9Mp1L3UDEiWHJBDsupjDNpUxAX7Xzm8RxfgnwHZEmZUZw=
X-Received: by 2002:a25:2408:0:b0:641:d07e:6ca with SMTP id
 k8-20020a252408000000b00641d07e06camr454993ybk.341.1650558528698; Thu, 21 Apr
 2022 09:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-15-oupton@google.com>
In-Reply-To: <20220415215901.1737897-15-oupton@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Thu, 21 Apr 2022 09:28:37 -0700
Message-ID: <CANgfPd-pK6jT4Sw_WCzyyHY9v3dj6O6SDPEt5Br1ws76H1Xx6w@mail.gmail.com>
Subject: Re: [RFC PATCH 14/17] KVM: arm64: Punt last page reference to rcu
 callback for parallel walk
To: Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Fri, 22 Apr 2022 13:50:47 -0400
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel@lists.infradead.org
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
> It is possible that a table page remains visible to another thread until
> the next rcu synchronization event. To that end, we cannot drop the last
> page reference synchronous with post-order traversal for a parallel
> table walk.
>
> Schedule an rcu callback to clean up the child table page for parallel
> walks.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  3 ++
>  arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++--
>  arch/arm64/kvm/mmu.c                 | 44 +++++++++++++++++++++++++++-
>  3 files changed, 67 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 74955aba5918..52e55e00f0ca 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -81,6 +81,8 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
>   * @put_page:                  Decrement the refcount on a page. When the
>   *                             refcount reaches 0 the page is automatically
>   *                             freed.
> + * @free_table:                        Drop the last page reference, possibly in the
> + *                             next RCU sync if doing a shared walk.
>   * @page_count:                        Return the refcount of a page.
>   * @phys_to_virt:              Convert a physical address into a virtual
>   *                             address mapped in the current context.
> @@ -98,6 +100,7 @@ struct kvm_pgtable_mm_ops {
>         void            (*get_page)(void *addr);
>         void            (*put_page)(void *addr);
>         int             (*page_count)(void *addr);
> +       void            (*free_table)(void *addr, bool shared);
>         void*           (*phys_to_virt)(phys_addr_t phys);
>         phys_addr_t     (*virt_to_phys)(void *addr);
>         void            (*dcache_clean_inval_poc)(void *addr, size_t size);
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 121818d4c33e..a9a48edba63b 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -147,12 +147,19 @@ static inline void kvm_pgtable_walk_end(void)
>  {}
>
>  #define kvm_dereference_ptep   rcu_dereference_raw
> +
> +static inline void kvm_pgtable_destroy_barrier(void)
> +{}
> +
>  #else
>  #define kvm_pgtable_walk_begin rcu_read_lock
>
>  #define kvm_pgtable_walk_end   rcu_read_unlock
>
>  #define kvm_dereference_ptep   rcu_dereference
> +
> +#define kvm_pgtable_destroy_barrier    rcu_barrier
> +
>  #endif
>
>  static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
> @@ -1063,7 +1070,12 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
>                 childp = kvm_pte_follow(*old, mm_ops);
>         }
>
> -       mm_ops->put_page(childp);
> +       /*
> +        * If we do not have exclusive access to the page tables it is possible
> +        * the unlinked table remains visible to another thread until the next
> +        * rcu synchronization.
> +        */
> +       mm_ops->free_table(childp, shared);
>         mm_ops->put_page(ptep);
>
>         return ret;
> @@ -1203,7 +1215,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>                                                kvm_granule_size(level));
>
>         if (childp)
> -               mm_ops->put_page(childp);
> +               mm_ops->free_table(childp, shared);
>
>         return 0;
>  }
> @@ -1433,7 +1445,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>         mm_ops->put_page(ptep);
>
>         if (kvm_pte_table(*old, level))
> -               mm_ops->put_page(kvm_pte_follow(*old, mm_ops));
> +               mm_ops->free_table(kvm_pte_follow(*old, mm_ops), shared);
>
>         return 0;
>  }
> @@ -1452,4 +1464,10 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>         pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
>         pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
>         pgt->pgd = NULL;
> +
> +       /*
> +        * Guarantee that all unlinked subtrees associated with the stage2 page
> +        * table have also been freed before returning.
> +        */
> +       kvm_pgtable_destroy_barrier();

Why do we need to wait for in-flight RCU callbacks to finish here?
Is this function only used on VM teardown and we just want to make
sure all the memory is freed or is something actually depending on
this behavior?

>  }
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index cc6ed6b06ec2..6ecf37009c21 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -98,9 +98,50 @@ static bool kvm_is_device_pfn(unsigned long pfn)
>  static void *stage2_memcache_zalloc_page(void *arg)
>  {
>         struct kvm_mmu_caches *mmu_caches = arg;
> +       struct stage2_page_header *hdr;
> +       void *addr;
>
>         /* Allocated with __GFP_ZERO, so no need to zero */
> -       return kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
> +       addr = kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
> +       if (!addr)
> +               return NULL;
> +
> +       hdr = kvm_mmu_memory_cache_alloc(&mmu_caches->header_cache);
> +       if (!hdr) {
> +               free_page((unsigned long)addr);
> +               return NULL;
> +       }
> +
> +       hdr->page = virt_to_page(addr);
> +       set_page_private(hdr->page, (unsigned long)hdr);
> +       return addr;
> +}
> +
> +static void stage2_free_page_now(struct stage2_page_header *hdr)
> +{
> +       WARN_ON(page_ref_count(hdr->page) != 1);
> +
> +       __free_page(hdr->page);
> +       kmem_cache_free(stage2_page_header_cache, hdr);
> +}
> +
> +static void stage2_free_page_rcu_cb(struct rcu_head *head)
> +{
> +       struct stage2_page_header *hdr = container_of(head, struct stage2_page_header,
> +                                                     rcu_head);
> +
> +       stage2_free_page_now(hdr);
> +}
> +
> +static void stage2_free_table(void *addr, bool shared)
> +{
> +       struct page *page = virt_to_page(addr);
> +       struct stage2_page_header *hdr = (struct stage2_page_header *)page_private(page);
> +
> +       if (shared)
> +               call_rcu(&hdr->rcu_head, stage2_free_page_rcu_cb);
> +       else
> +               stage2_free_page_now(hdr);
>  }
>
>  static void *kvm_host_zalloc_pages_exact(size_t size)
> @@ -613,6 +654,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>         .free_pages_exact       = free_pages_exact,
>         .get_page               = kvm_host_get_page,
>         .put_page               = kvm_host_put_page,
> +       .free_table             = stage2_free_table,
>         .page_count             = kvm_host_page_count,
>         .phys_to_virt           = kvm_host_va,
>         .virt_to_phys           = kvm_host_pa,
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
