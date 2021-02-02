Return-Path: <SRS0=mEDx=HE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D74C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 18:13:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A5A664F94
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 18:13:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A5A664F94
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A50874B1BD;
	Tue,  2 Feb 2021 13:13:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uICLhduqMO1C; Tue,  2 Feb 2021 13:13:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F04E74B1B3;
	Tue,  2 Feb 2021 13:13:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A5B84B170
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 13:13:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CziUAwmsTEe4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2021 13:13:15 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 889684A4E5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 13:13:15 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE7CC64F68;
 Tue,  2 Feb 2021 18:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612289594;
 bh=X+fMApebb90vPZ0Sh79TkziyYlatPLPROh2OUP+kTws=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=tBXlUZtpL5/enc5sFJwLtKtSCcWZR0Qa4OFhvibRmeelvROdaQo73wkq6pTD4gnY/
 wynVbTM94ykUT8XpblDbaK4ccaPtAuqg+KaCeEW2OVSiRBWvEMmylP0uA4WE5ytDQ1
 rVzENhU3g8W1E4Ue5kgN4m7aa6cXFwrJNIuzG75YCg3mx85Mxj/OvbuEuLtStMV4Li
 hwYQS5/3wCcx6W2eVBfsPhUR9CXKcv6urogwpcjcScCsr+MatWTenI7iTv2RqpGtpH
 I3m6m0Ojv+C759Smadr84qhgXNdBCwjkQY3rJia3CkRCSTktozhLhucX1nsXbbeFeh
 uLYcukG0kSj7w==
Date: Tue, 2 Feb 2021 18:13:08 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 12/26] KVM: arm64: Introduce a Hyp buddy page
 allocator
Message-ID: <20210202181307.GA17311@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-13-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210108121524.656872-13-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

Sorry for the delay, this one took me a while to grok.

On Fri, Jan 08, 2021 at 12:15:10PM +0000, Quentin Perret wrote:
> When memory protection is enabled, the hyp code will require a basic
> form of memory management in order to allocate and free memory pages at
> EL2. This is needed for various use-cases, including the creation of hyp
> mappings or the allocation of stage 2 page tables.
> 
> To address these use-case, introduce a simple memory allocator in the
> hyp code. The allocator is designed as a conventional 'buddy allocator',
> working with a page granularity. It allows to allocate and free
> physically contiguous pages from memory 'pools', with a guaranteed order
> alignment in the PA space. Each page in a memory pool is associated
> with a struct hyp_page which holds the page's metadata, including its
> refcount, as well as its current order, hence mimicking the kernel's
> buddy system in the GFP infrastructure. The hyp_page metadata are made
> accessible through a hyp_vmemmap, following the concept of
> SPARSE_VMEMMAP in the kernel.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  32 ++++
>  arch/arm64/kvm/hyp/include/nvhe/memory.h |  25 +++
>  arch/arm64/kvm/hyp/nvhe/Makefile         |   2 +-
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 185 +++++++++++++++++++++++
>  4 files changed, 243 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/gfp.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/page_alloc.c
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> new file mode 100644
> index 000000000000..95587faee171
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __KVM_HYP_GFP_H
> +#define __KVM_HYP_GFP_H
> +
> +#include <linux/list.h>
> +
> +#include <nvhe/memory.h>
> +#include <nvhe/spinlock.h>
> +
> +#define HYP_MAX_ORDER	11U

Could we just use MAX_ORDER here?

> +#define HYP_NO_ORDER	UINT_MAX
> +
> +struct hyp_pool {
> +	hyp_spinlock_t lock;

A comment about what this lock protects would be handy, especially as the
'refcount' field of 'struct hyp_page' isn't updated atomically. I think it
also means that we don't have a safe way to move a page from one pool to
another; it's fixed forever once the page has been made available for
allocation.

> +	struct list_head free_area[HYP_MAX_ORDER + 1];
> +	phys_addr_t range_start;
> +	phys_addr_t range_end;
> +};
> +
> +/* GFP flags */
> +#define HYP_GFP_NONE	0
> +#define HYP_GFP_ZERO	1
> +
> +/* Allocation */
> +void *hyp_alloc_pages(struct hyp_pool *pool, gfp_t mask, unsigned int order);
> +void hyp_get_page(void *addr);
> +void hyp_put_page(void *addr);
> +
> +/* Used pages cannot be freed */
> +int hyp_pool_init(struct hyp_pool *pool, phys_addr_t phys,
> +		  unsigned int nr_pages, unsigned int used_pages);

Maybe "reserved_pages" would be a better name than "used_pages"?

> +#endif /* __KVM_HYP_GFP_H */
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> index 64c44c142c95..ed47674bc988 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> @@ -6,7 +6,17 @@
>  
>  #include <linux/types.h>
>  
> +struct hyp_pool;
> +struct hyp_page {
> +	unsigned int refcount;
> +	unsigned int order;
> +	struct hyp_pool *pool;
> +	struct list_head node;
> +};
> +
>  extern s64 hyp_physvirt_offset;
> +extern u64 __hyp_vmemmap;
> +#define hyp_vmemmap ((struct hyp_page *)__hyp_vmemmap)
>  
>  #define __hyp_pa(virt)	((phys_addr_t)(virt) + hyp_physvirt_offset)
>  #define __hyp_va(virt)	((void *)((phys_addr_t)(virt) - hyp_physvirt_offset))
> @@ -21,4 +31,19 @@ static inline phys_addr_t hyp_virt_to_phys(void *addr)
>  	return __hyp_pa(addr);
>  }
>  
> +#define hyp_phys_to_pfn(phys)	((phys) >> PAGE_SHIFT)
> +#define hyp_phys_to_page(phys)	(&hyp_vmemmap[hyp_phys_to_pfn(phys)])
> +#define hyp_virt_to_page(virt)	hyp_phys_to_page(__hyp_pa(virt))
> +
> +#define hyp_page_to_phys(page)  ((phys_addr_t)((page) - hyp_vmemmap) << PAGE_SHIFT)

Maybe implement this in terms of a new hyp_page_to_pfn() macro?

> +#define hyp_page_to_virt(page)	__hyp_va(hyp_page_to_phys(page))
> +#define hyp_page_to_pool(page)	(((struct hyp_page *)page)->pool)
> +
> +static inline int hyp_page_count(void *addr)
> +{
> +	struct hyp_page *p = hyp_virt_to_page(addr);
> +
> +	return p->refcount;
> +}
> +
>  #endif /* __KVM_HYP_MEMORY_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 33bd381d8f73..9e5eacfec6ec 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -10,7 +10,7 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
>  lib-objs := $(addprefix ../../../lib/, $(lib-objs))
>  
>  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
> -	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o
> +	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>  	 ../fpsimd.o ../hyp-entry.o ../exception.o
>  obj-y += $(lib-objs)
> diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> new file mode 100644
> index 000000000000..6de6515f0432
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> @@ -0,0 +1,185 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020 Google LLC
> + * Author: Quentin Perret <qperret@google.com>
> + */
> +
> +#include <asm/kvm_hyp.h>
> +#include <nvhe/gfp.h>
> +
> +u64 __hyp_vmemmap;
> +
> +/*
> + * Example buddy-tree for a 4-pages physically contiguous pool:
> + *
> + *                 o : Page 3
> + *                /
> + *               o-o : Page 2
> + *              /
> + *             /   o : Page 1
> + *            /   /
> + *           o---o-o : Page 0
> + *    Order  2   1 0
> + *
> + * Example of requests on this zon:

typo: zone

> + *   __find_buddy(pool, page 0, order 0) => page 1
> + *   __find_buddy(pool, page 0, order 1) => page 2
> + *   __find_buddy(pool, page 1, order 0) => page 0
> + *   __find_buddy(pool, page 2, order 0) => page 3
> + */
> +static struct hyp_page *__find_buddy(struct hyp_pool *pool, struct hyp_page *p,
> +				     unsigned int order)
> +{
> +	phys_addr_t addr = hyp_page_to_phys(p);
> +
> +	addr ^= (PAGE_SIZE << order);
> +	if (addr < pool->range_start || addr >= pool->range_end)
> +		return NULL;

Are these range checks only needed because the pool isn't required to be
an exact power-of-2 pages in size? If so, maybe it would be more
straightforward to limit the max order on a per-pool basis depending upon
its size?

> +
> +	return hyp_phys_to_page(addr);
> +}
> +
> +static void __hyp_attach_page(struct hyp_pool *pool,
> +			      struct hyp_page *p)
> +{
> +	unsigned int order = p->order;
> +	struct hyp_page *buddy;
> +
> +	p->order = HYP_NO_ORDER;

Why is this needed?

> +	for (; order < HYP_MAX_ORDER; order++) {
> +		/* Nothing to do if the buddy isn't in a free-list */
> +		buddy = __find_buddy(pool, p, order);
> +		if (!buddy || list_empty(&buddy->node) || buddy->order != order)

Could we move the "buddy->order" check into __find_buddy()?

> +			break;
> +
> +		/* Otherwise, coalesce the buddies and go one level up */
> +		list_del_init(&buddy->node);
> +		buddy->order = HYP_NO_ORDER;
> +		p = (p < buddy) ? p : buddy;
> +	}
> +
> +	p->order = order;
> +	list_add_tail(&p->node, &pool->free_area[order]);
> +}
> +
> +void hyp_put_page(void *addr)
> +{
> +	struct hyp_page *p = hyp_virt_to_page(addr);
> +	struct hyp_pool *pool = hyp_page_to_pool(p);
> +
> +	hyp_spin_lock(&pool->lock);
> +	if (!p->refcount)
> +		hyp_panic();
> +	p->refcount--;
> +	if (!p->refcount)
> +		__hyp_attach_page(pool, p);
> +	hyp_spin_unlock(&pool->lock);
> +}
> +
> +void hyp_get_page(void *addr)
> +{
> +	struct hyp_page *p = hyp_virt_to_page(addr);
> +	struct hyp_pool *pool = hyp_page_to_pool(p);
> +
> +	hyp_spin_lock(&pool->lock);
> +	p->refcount++;
> +	hyp_spin_unlock(&pool->lock);

We should probably have a proper atomic refcount type for this along the
lines of refcount_t. Even if initially that is implemented with a lock, it
would be good to hide that behind a refcount API.

> +}
> +
> +/* Extract a page from the buddy tree, at a specific order */
> +static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
> +					   struct hyp_page *p,
> +					   unsigned int order)
> +{
> +	struct hyp_page *buddy;
> +
> +	if (p->order == HYP_NO_ORDER || p->order < order)
> +		return NULL;

Can you drop the explicit HYP_NO_ORDER check here?

> +
> +	list_del_init(&p->node);
> +
> +	/* Split the page in two until reaching the requested order */
> +	while (p->order > order) {
> +		p->order--;
> +		buddy = __find_buddy(pool, p, p->order);
> +		buddy->order = p->order;
> +		list_add_tail(&buddy->node, &pool->free_area[buddy->order]);
> +	}
> +
> +	p->refcount = 1;
> +
> +	return p;
> +}
> +
> +static void clear_hyp_page(struct hyp_page *p)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < (1 << p->order); i++)
> +		clear_page(hyp_page_to_virt(p) + (i << PAGE_SHIFT));

I wonder if this is actually any better than a memset(0)? That should use
DC ZCA as appropriate afaict.

> +static void *__hyp_alloc_pages(struct hyp_pool *pool, gfp_t mask,
> +			       unsigned int order)
> +{
> +	unsigned int i = order;
> +	struct hyp_page *p;
> +
> +	/* Look for a high-enough-order page */
> +	while (i <= HYP_MAX_ORDER && list_empty(&pool->free_area[i]))
> +		i++;
> +	if (i > HYP_MAX_ORDER)
> +		return NULL;
> +
> +	/* Extract it from the tree at the right order */
> +	p = list_first_entry(&pool->free_area[i], struct hyp_page, node);
> +	p = __hyp_extract_page(pool, p, order);
> +
> +	if (mask & HYP_GFP_ZERO)
> +		clear_hyp_page(p);

Do we have a use-case where skipping the zeroing is worthwhile? If not,
it might make some sense to zero on the freeing path instead.

> +
> +	return p;
> +}
> +
> +void *hyp_alloc_pages(struct hyp_pool *pool, gfp_t mask, unsigned int order)
> +{
> +	struct hyp_page *p;
> +
> +	hyp_spin_lock(&pool->lock);
> +	p = __hyp_alloc_pages(pool, mask, order);
> +	hyp_spin_unlock(&pool->lock);
> +
> +	return p ? hyp_page_to_virt(p) : NULL;

It looks weird not having __hyp_alloc_pages return the VA, but I guess later
patches will use __hyp_alloc_pages() for something else.

> +}
> +
> +/* hyp_vmemmap must be backed beforehand */
> +int hyp_pool_init(struct hyp_pool *pool, phys_addr_t phys,
> +		  unsigned int nr_pages, unsigned int used_pages)
> +{
> +	struct hyp_page *p;
> +	int i;
> +
> +	if (phys % PAGE_SIZE)
> +		return -EINVAL;

Maybe just take a pfn instead?

> +	hyp_spin_lock_init(&pool->lock);
> +	for (i = 0; i <= HYP_MAX_ORDER; i++)
> +		INIT_LIST_HEAD(&pool->free_area[i]);
> +	pool->range_start = phys;
> +	pool->range_end = phys + (nr_pages << PAGE_SHIFT);
> +
> +	/* Init the vmemmap portion */
> +	p = hyp_phys_to_page(phys);
> +	memset(p, 0, sizeof(*p) * nr_pages);
> +	for (i = 0; i < nr_pages; i++, p++) {
> +		p->pool = pool;
> +		INIT_LIST_HEAD(&p->node);
> +	}

Maybe index p like an array (e.g. p[i]) instead of maintaining two loop
increments?

> +
> +	/* Attach the unused pages to the buddy tree */
> +	p = hyp_phys_to_page(phys + (used_pages << PAGE_SHIFT));
> +	for (i = used_pages; i < nr_pages; i++, p++)
> +		__hyp_attach_page(pool, p);

Likewise.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
