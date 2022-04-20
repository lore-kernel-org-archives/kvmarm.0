Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B763C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 20 Apr 2022 00:53:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7C814B162;
	Tue, 19 Apr 2022 20:53:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id it-ZvfYqI499; Tue, 19 Apr 2022 20:53:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73E144B17C;
	Tue, 19 Apr 2022 20:53:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BA7F4B162
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 20:53:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Du5XTwCMMnen for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 20:53:34 -0400 (EDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com
 [209.85.208.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7B344B0F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 20:53:33 -0400 (EDT)
Received: by mail-lj1-f178.google.com with SMTP id r18so143025ljp.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 17:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=zpc+S3XJslQGdN+1ztESj3Pk9nCpe442FKn8vvptZb8=;
 b=P28QdVMWNr0YgsHKanEo+yOxtNfa4F3rvjM30FjeaO6v1SHiEtDJ3+n7jYy0mETf6c
 FvoBYei0cQyVzbAZL1NFF0l/tALYtbHYei0jtXE1WkjIaFmZ/l2wyIx1riMWc7shJ9sL
 KIQdTxPN3ibAGLmWPAWB++5P31k1+QgoNj9orfz/c4u7+PZM4qMRLKwB4TPsQMQ0e3lf
 J85DkgIa9fgAyyfsRmff568f0dzomeZwqyU+QMLEm3XWbS7uEKURUXIYcCCMADTvshgC
 aO6oCa/MIM8UTtXv/UwbgBRBkc28Aa31sdLPBuMzwfSAnXf8VXha1+sbz2aJzyU/R2Zp
 n3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=zpc+S3XJslQGdN+1ztESj3Pk9nCpe442FKn8vvptZb8=;
 b=RJG/hj0ct8J0OB87f1YwRjpRUfMdVIUEO2Qhm9ruOl/QkbGqv3lu5kpZsqYgvVqg0A
 42ZbDyTJkKpBDUQ1bMZlbCixuww7cIPqchf68YIqgtHHu9slG40n9TCdfU23wYB6qtXw
 MG9jEMO/l11IA0EBWo25WGPhGRx+hiwffn12Mwh4qXJ+XzR2Q0vhD4kWfXL+y48WNfo/
 7cFifSDwKEHcWuG/6mdviCJSVIjGGAdo0JSUB2vRKYEMW41NJLNbzYAQsMdexMMqPVJq
 KsXUYNamzfQJjBhJgLzSXIRbSXRXfnY3Wg65l1yb3DXoATNkRLbRIhfVq1yq9HTlLGU+
 68ZQ==
X-Gm-Message-State: AOAM5312iwdGnRiuAXGG0y47RQfNaas8vpsyCq0xW4vvJrmL9pzwZFY4
 fXgqvpPKxWlDw/oPH2N3B+OgsPmTuVbazBwNyLXDcA==
X-Google-Smtp-Source: ABdhPJzSB3bpTAFQds70RgQUcFtFTLQMXXuZvgkeOXz4jvpIPqicfbjSYteCmN540wrY48ftzEFTHW5UkTrJ4DfgZlw=
X-Received: by 2002:a05:651c:1a0c:b0:24d:c538:d504 with SMTP id
 by12-20020a05651c1a0c00b0024dc538d504mr4357315ljb.479.1650416011972; Tue, 19
 Apr 2022 17:53:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-15-oupton@google.com>
 <Yl4leEoIg+dr/1QM@google.com> <Yl4n7o45K0HFK52S@google.com>
In-Reply-To: <Yl4n7o45K0HFK52S@google.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 19 Apr 2022 17:53:20 -0700
Message-ID: <CAOQ_QsiNS2foL8CocwErdEQnpdgbOySjV9Y-4ZG0f-y-XJPQOg@mail.gmail.com>
Subject: Re: [RFC PATCH 14/17] KVM: arm64: Punt last page reference to rcu
 callback for parallel walk
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Hi Ricardo,

On Mon, Apr 18, 2022 at 8:09 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Mon, Apr 18, 2022 at 07:59:04PM -0700, Ricardo Koller wrote:
> > On Fri, Apr 15, 2022 at 09:58:58PM +0000, Oliver Upton wrote:
> > > It is possible that a table page remains visible to another thread until
> > > the next rcu synchronization event. To that end, we cannot drop the last
> > > page reference synchronous with post-order traversal for a parallel
> > > table walk.
> > >
> > > Schedule an rcu callback to clean up the child table page for parallel
> > > walks.
> > >
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_pgtable.h |  3 ++
> > >  arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++--
> > >  arch/arm64/kvm/mmu.c                 | 44 +++++++++++++++++++++++++++-
> > >  3 files changed, 67 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > > index 74955aba5918..52e55e00f0ca 100644
> > > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > > @@ -81,6 +81,8 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
> > >   * @put_page:                      Decrement the refcount on a page. When the
> > >   *                         refcount reaches 0 the page is automatically
> > >   *                         freed.
> > > + * @free_table:                    Drop the last page reference, possibly in the
> > > + *                         next RCU sync if doing a shared walk.
> > >   * @page_count:                    Return the refcount of a page.
> > >   * @phys_to_virt:          Convert a physical address into a virtual
> > >   *                         address mapped in the current context.
> > > @@ -98,6 +100,7 @@ struct kvm_pgtable_mm_ops {
> > >     void            (*get_page)(void *addr);
> > >     void            (*put_page)(void *addr);
> > >     int             (*page_count)(void *addr);
> > > +   void            (*free_table)(void *addr, bool shared);
> > >     void*           (*phys_to_virt)(phys_addr_t phys);
> > >     phys_addr_t     (*virt_to_phys)(void *addr);
> > >     void            (*dcache_clean_inval_poc)(void *addr, size_t size);
> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > index 121818d4c33e..a9a48edba63b 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -147,12 +147,19 @@ static inline void kvm_pgtable_walk_end(void)
> > >  {}
> > >
> > >  #define kvm_dereference_ptep       rcu_dereference_raw
> > > +
> > > +static inline void kvm_pgtable_destroy_barrier(void)
> > > +{}
> > > +
> > >  #else
> > >  #define kvm_pgtable_walk_begin     rcu_read_lock
> > >
> > >  #define kvm_pgtable_walk_end       rcu_read_unlock
> > >
> > >  #define kvm_dereference_ptep       rcu_dereference
> > > +
> > > +#define kvm_pgtable_destroy_barrier        rcu_barrier
> > > +
> > >  #endif
> > >
> > >  static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
> > > @@ -1063,7 +1070,12 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
> > >             childp = kvm_pte_follow(*old, mm_ops);
> > >     }
> > >
> > > -   mm_ops->put_page(childp);
> > > +   /*
> > > +    * If we do not have exclusive access to the page tables it is possible
> > > +    * the unlinked table remains visible to another thread until the next
> > > +    * rcu synchronization.
> > > +    */
> > > +   mm_ops->free_table(childp, shared);
> > >     mm_ops->put_page(ptep);
> > >
> > >     return ret;
> > > @@ -1203,7 +1215,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> > >                                            kvm_granule_size(level));
> > >
> > >     if (childp)
> > > -           mm_ops->put_page(childp);
> > > +           mm_ops->free_table(childp, shared);
> > >
> > >     return 0;
> > >  }
> > > @@ -1433,7 +1445,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> > >     mm_ops->put_page(ptep);
> > >
> > >     if (kvm_pte_table(*old, level))
> > > -           mm_ops->put_page(kvm_pte_follow(*old, mm_ops));
> > > +           mm_ops->free_table(kvm_pte_follow(*old, mm_ops), shared);
> > >
> > >     return 0;
> > >  }
> > > @@ -1452,4 +1464,10 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
> > >     pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
> > >     pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
> > >     pgt->pgd = NULL;
> > > +
> > > +   /*
> > > +    * Guarantee that all unlinked subtrees associated with the stage2 page
> > > +    * table have also been freed before returning.
> > > +    */
> > > +   kvm_pgtable_destroy_barrier();
> > >  }
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index cc6ed6b06ec2..6ecf37009c21 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -98,9 +98,50 @@ static bool kvm_is_device_pfn(unsigned long pfn)
> > >  static void *stage2_memcache_zalloc_page(void *arg)
> > >  {
> > >     struct kvm_mmu_caches *mmu_caches = arg;
> > > +   struct stage2_page_header *hdr;
> > > +   void *addr;
> > >
> > >     /* Allocated with __GFP_ZERO, so no need to zero */
> > > -   return kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
> > > +   addr = kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
> > > +   if (!addr)
> > > +           return NULL;
> > > +
> > > +   hdr = kvm_mmu_memory_cache_alloc(&mmu_caches->header_cache);
> > > +   if (!hdr) {
> > > +           free_page((unsigned long)addr);
> > > +           return NULL;
> > > +   }
> > > +
> > > +   hdr->page = virt_to_page(addr);
> > > +   set_page_private(hdr->page, (unsigned long)hdr);
> > > +   return addr;
> > > +}
> > > +
> > > +static void stage2_free_page_now(struct stage2_page_header *hdr)
> > > +{
> > > +   WARN_ON(page_ref_count(hdr->page) != 1);
> > > +
> > > +   __free_page(hdr->page);
> > > +   kmem_cache_free(stage2_page_header_cache, hdr);
> > > +}
> > > +
> > > +static void stage2_free_page_rcu_cb(struct rcu_head *head)
> > > +{
> > > +   struct stage2_page_header *hdr = container_of(head, struct stage2_page_header,
> > > +                                                 rcu_head);
> > > +
> > > +   stage2_free_page_now(hdr);
> > > +}
> > > +
> > > +static void stage2_free_table(void *addr, bool shared)
> > > +{
> > > +   struct page *page = virt_to_page(addr);
> > > +   struct stage2_page_header *hdr = (struct stage2_page_header *)page_private(page);
> > > +
> > > +   if (shared)
> > > +           call_rcu(&hdr->rcu_head, stage2_free_page_rcu_cb);
> >
> > Can the number of callbacks grow to "dangerous" numbers? can it be
> > bounded with something like the following?
> >
> > if number of readers is really high:
> >       synchronize_rcu()
> > else
> >       call_rcu()
>
> sorry, meant to say "number of callbacks"

Good point. I don't have data for this, but generally speaking I do
not believe we need to enqueue a callback for every page. In fact,
since we already make the invalid PTE visible in pre-order traversal
we could theoretically free all tables from a single RCU callback (per
fault).

I think if we used synchronize_rcu() then we would need to drop the
mmu lock since it will block the thread.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
