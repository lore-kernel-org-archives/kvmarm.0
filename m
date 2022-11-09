Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1C9C43219
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:52:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE6494BAC8;
	Thu, 10 Nov 2022 09:52:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xNawC4Z-9JBP; Thu, 10 Nov 2022 09:52:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89F084BB74;
	Thu, 10 Nov 2022 09:51:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E445C4BA23
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:25:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id neHMuB4gu2pp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 17:25:49 -0500 (EST)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
 [209.85.160.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C0A44BA1F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:25:49 -0500 (EST)
Received: by mail-qt1-f181.google.com with SMTP id cg5so27957qtb.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Nov 2022 14:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=EJ5hbNpYS+ert13sTz7i63mDVdE2zo94Ie0Np0yf4C4=;
 b=cfMqImfZTMZnlKj2jdeEaJuDUP7VnyM66+m8J86n6SFssRHn0iIC2F9wa9MXxIn31Z
 V8kmlz7nUwwssqiKl9tzw+mx5niRTVNADgJ9I3AlHHXI8VfDjaRlHu/bmn4MRdJ47DPe
 CrMuHQLM7WtrkEWKHMDMahOPpewkokSAjHfMdpZfro0KZq9ttZ+fCtEwiKZn7goTjBM0
 Aii7jVwY8t4PkHEUuasKl2+LOiTKvLvL9xHqXWcrjrkXQ1X+K0JlRwjQvreQ3wtuY4zv
 YYs7AZMiXseOHBgOhkwLdHU6SoeaLqqIHpXqqrLvMtrtgY748im08EE1NJB+W2EDoeyZ
 00PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=EJ5hbNpYS+ert13sTz7i63mDVdE2zo94Ie0Np0yf4C4=;
 b=lVpQjaTiHZhjFXBAddtLojVCb4W90T6ERLcVnB1kbKpJRX4SeEDezCdUT83zpD6hD9
 Qh2wUewJUIvvhp2vpnMIv9F0qwSyYEQQH2pDDSoHz4FYqGMHBRcXazh4UiPBoqGZrHwW
 8xMgM5lFQNxc+BiV0/Zit/HbJQDW32uQKRHKh9L+8zsi526kvbGAzIny0yENce8gh7xS
 13oc3C9rmZFDa0cYuT58LWkLJ8EVNZRPRLTaUYPjhpTOjjUPrmaFJEBRbSo05YSViKXW
 JeVYSQGIGilaqENAxhShE724XVsgaGMa3DuH3D+JgTnugrVXJSvkW750WcLc0mYlmWoJ
 tiuw==
X-Gm-Message-State: ANoB5plQsKzjedRi1TJqphQIrDz/zIkkGrjn/ETV05lbeANlDpI/zZXM
 kEq7toNI3+LsX1kK+8XAaA38c/843f7Sy0cafLKbsA==
X-Google-Smtp-Source: AA0mqf6b1QwQU+t2rhpz0pYfoh8FoW+OMhhjudxrUGJuaDbrsZeDMXk8N/bPz9y5AXGikecVlQYPq4Ul5OIWkT/wRxI=
X-Received: by 2002:ac8:5ac2:0:b0:3a5:afca:2322 with SMTP id
 d2-20020ac85ac2000000b003a5afca2322mr4280890qtd.500.1668032749051; Wed, 09
 Nov 2022 14:25:49 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-9-oliver.upton@linux.dev>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 14:25:38 -0800
Message-ID: <CANgfPd9fynvsBLjio1zz0hPy4SGAd8XZfzYQaR_gg0UJrOyAcA@mail.gmail.com>
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
To: Oliver Upton <oliver.upton@linux.dev>
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
> release the RCU read lock when traversing the page tables. Defer the
> freeing of table memory to an RCU callback. Indirect the calls into RCU
> and provide stubs for hypervisor code, as RCU is not available in such a
> context.
>
> The RCU protection doesn't amount to much at the moment, as readers are
> already protected by the read-write lock (all walkers that free table
> memory take the write lock). Nonetheless, a subsequent change will
> futher relax the locking requirements around the stage-2 MMU, thereby
> depending on RCU.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 49 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 10 +++++-
>  arch/arm64/kvm/mmu.c                 | 14 +++++++-
>  3 files changed, 71 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index e70cf57b719e..7634b6964779 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -37,6 +37,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
>
>  typedef u64 kvm_pte_t;
>
> +/*
> + * RCU cannot be used in a non-kernel context such as the hyp. As such, page
> + * table walkers used in hyp do not call into RCU and instead use other
> + * synchronization mechanisms (such as a spinlock).
> + */
> +#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
> +
>  typedef kvm_pte_t *kvm_pteref_t;
>
>  static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> @@ -44,6 +51,40 @@ static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared
>         return pteref;
>  }
>
> +static inline void kvm_pgtable_walk_begin(void) {}
> +static inline void kvm_pgtable_walk_end(void) {}
> +
> +static inline bool kvm_pgtable_walk_lock_held(void)
> +{
> +       return true;

Forgive my ignorance, but does hyp not use a MMU lock at all? Seems
like this would be a good place to add a lockdep check.

> +}
> +
> +#else
> +
> +typedef kvm_pte_t __rcu *kvm_pteref_t;
> +
> +static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> +{
> +       return rcu_dereference_check(pteref, !shared);

Same here, could add a lockdep check depending on shared.

> +}
> +
> +static inline void kvm_pgtable_walk_begin(void)
> +{
> +       rcu_read_lock();
> +}
> +
> +static inline void kvm_pgtable_walk_end(void)
> +{
> +       rcu_read_unlock();
> +}
> +
> +static inline bool kvm_pgtable_walk_lock_held(void)
> +{
> +       return rcu_read_lock_held();

Likewise could do some lockdep here.

> +}
> +
> +#endif
> +
>  #define KVM_PTE_VALID                  BIT(0)
>
>  #define KVM_PTE_ADDR_MASK              GENMASK(47, PAGE_SHIFT)
> @@ -202,11 +243,14 @@ struct kvm_pgtable {
>   *                                     children.
>   * @KVM_PGTABLE_WALK_TABLE_POST:       Visit table entries after their
>   *                                     children.
> + * @KVM_PGTABLE_WALK_SHARED:           Indicates the page-tables may be shared
> + *                                     with other software walkers.
>   */
>  enum kvm_pgtable_walk_flags {
>         KVM_PGTABLE_WALK_LEAF                   = BIT(0),
>         KVM_PGTABLE_WALK_TABLE_PRE              = BIT(1),
>         KVM_PGTABLE_WALK_TABLE_POST             = BIT(2),
> +       KVM_PGTABLE_WALK_SHARED                 = BIT(3),

Not sure if necessary, but it might pay to have 3 shared options:
exclusive, shared mmu lock, no mmu lock if we ever want lockless fast
page faults.


>  };
>
>  struct kvm_pgtable_visit_ctx {
> @@ -223,6 +267,11 @@ struct kvm_pgtable_visit_ctx {
>  typedef int (*kvm_pgtable_visitor_fn_t)(const struct kvm_pgtable_visit_ctx *ctx,
>                                         enum kvm_pgtable_walk_flags visit);
>
> +static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *ctx)
> +{
> +       return ctx->flags & KVM_PGTABLE_WALK_SHARED;
> +}
> +
>  /**
>   * struct kvm_pgtable_walker - Hook into a page-table walk.
>   * @cb:                Callback function to invoke during the walk.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 7c9782347570..d8d963521d4e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -171,6 +171,9 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
>                                   enum kvm_pgtable_walk_flags visit)
>  {
>         struct kvm_pgtable_walker *walker = data->walker;
> +
> +       /* Ensure the appropriate lock is held (e.g. RCU lock for stage-2 MMU) */
> +       WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx) && !kvm_pgtable_walk_lock_held());
>         return walker->cb(ctx, visit);
>  }
>
> @@ -281,8 +284,13 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>                 .end    = PAGE_ALIGN(walk_data.addr + size),
>                 .walker = walker,
>         };
> +       int r;
> +
> +       kvm_pgtable_walk_begin();
> +       r = _kvm_pgtable_walk(pgt, &walk_data);
> +       kvm_pgtable_walk_end();
>
> -       return _kvm_pgtable_walk(pgt, &walk_data);
> +       return r;
>  }
>
>  struct leaf_walk_data {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 73ae908eb5d9..52e042399ba5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -130,9 +130,21 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
>
>  static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
>
> +static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
> +{
> +       struct page *page = container_of(head, struct page, rcu_head);
> +       void *pgtable = page_to_virt(page);
> +       u32 level = page_private(page);
> +
> +       kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, pgtable, level);
> +}
> +
>  static void stage2_free_removed_table(void *addr, u32 level)
>  {
> -       kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, addr, level);
> +       struct page *page = virt_to_page(addr);
> +
> +       set_page_private(page, (unsigned long)level);
> +       call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
>  }
>
>  static void kvm_host_get_page(void *addr)
> --
> 2.38.1.431.g37b22c650d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
