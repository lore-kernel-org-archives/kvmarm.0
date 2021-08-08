Return-Path: <SRS0=Bxxw=M7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A638AC432BE
	for <kvmarm@archiver.kernel.org>; Sun,  8 Aug 2021 08:23:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1EB7560EE9
	for <kvmarm@archiver.kernel.org>; Sun,  8 Aug 2021 08:23:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1EB7560EE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A109640463;
	Sun,  8 Aug 2021 04:23:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uoqVNxn4m+W8; Sun,  8 Aug 2021 04:23:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5122740573;
	Sun,  8 Aug 2021 04:23:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 315E44048A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  8 Aug 2021 04:23:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 04iiROO6fGaH for <kvmarm@lists.cs.columbia.edu>;
 Sun,  8 Aug 2021 04:23:17 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6ED1B40463
 for <kvmarm@lists.cs.columbia.edu>; Sun,  8 Aug 2021 04:23:17 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E6A860EE9;
 Sun,  8 Aug 2021 08:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628410996;
 bh=zhCNdgw/mYWOZ9DqYDjenjpLs/lZQV8K6NnmUuIdhpU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hxFnOZyjcmwZqd3mCVjgbL1nsIFWan2gjbIz5LSGxdHj1yXahtapkDvBgiCYcsHKX
 m4QWL4TNRbSBo+smfSQjyWEnGKF9YVlf8xT8x1irSxBGEgFA6tGCjzUWIEATBf9VFB
 nZZ6HDQaDDw5gEbOL/GkSdSNddXXyq19QvKohyhds33z12zOIHlfTBkX8mbtcWLKH7
 YJRNbu3MTuxGUbVMArVa8yuYwJ3hDm3IeXpgHXMD0QdI5NsnzoVDtDAJ9M8CxQkfGK
 ENoLz5aLp31iOlDRcNOzwE/EJ7+9vWlB3PNfXgF9LCzuYHpAHNQrnq9U5ou8/nzRc9
 2v71OP1WH34Ng==
Date: Sun, 8 Aug 2021 11:23:08 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Subject: Re: [RFC PATCH 14/15] mm: introduce MIN_MAX_ORDER to replace
 MAX_ORDER as compile time constant.
Message-ID: <YQ+UbJtSWciIVqr4@kernel.org>
References: <20210805190253.2795604-1-zi.yan@sent.com>
 <20210805190253.2795604-15-zi.yan@sent.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210805190253.2795604-15-zi.yan@sent.com>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 David Hildenbrand <david@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
 Vlastimil Babka <vbabka@suse.cz>, Marc Zyngier <maz@kernel.org>,
 Christoph Lameter <cl@linux.com>, kvmarm@lists.cs.columbia.edu,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Mike Kravetz <mike.kravetz@oracle.com>
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

On Thu, Aug 05, 2021 at 03:02:52PM -0400, Zi Yan wrote:
> From: Zi Yan <ziy@nvidia.com>
> 
> For other MAX_ORDER uses (described below), there is no need or too much
> hassle to convert certain static array to dynamic ones. Add
> MIN_MAX_ORDER to serve as compile time constant in place of MAX_ORDER.
> 
> ARM64 hypervisor maintains its own free page list and does not import
> any core kernel symbols, so soon-to-be runtime variable MAX_ORDER is not
> accessible in ARM64 hypervisor code. Also there is no need to allocating
> very large pages.
> 
> In SLAB/SLOB/SLUB, 2-D array kmalloc_caches uses MAX_ORDER in its second
> dimension. It is too much hassle to allocate memory for kmalloc_caches
> before any proper memory allocator is set up.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Quentin Perret <qperret@google.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm64/kvm/hyp/include/nvhe/gfp.h | 2 +-
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 3 ++-
>  include/linux/mmzone.h                | 3 +++
>  include/linux/slab.h                  | 8 ++++----
>  mm/slab.c                             | 2 +-
>  mm/slub.c                             | 7 ++++---
>  6 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> index fb0f523d1492..c774b4a98336 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> @@ -16,7 +16,7 @@ struct hyp_pool {
>  	 * API at EL2.
>  	 */
>  	hyp_spinlock_t lock;
> -	struct list_head free_area[MAX_ORDER];
> +	struct list_head free_area[MIN_MAX_ORDER];
>  	phys_addr_t range_start;
>  	phys_addr_t range_end;
>  	unsigned short max_order;
> diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> index 41fc25bdfb34..a1cc1b648de0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> @@ -226,7 +226,8 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
>  	int i;
>  
>  	hyp_spin_lock_init(&pool->lock);
> -	pool->max_order = min(MAX_ORDER, get_order(nr_pages << PAGE_SHIFT));
> +
> +	pool->max_order = min(MIN_MAX_ORDER, get_order(nr_pages << PAGE_SHIFT));
>  	for (i = 0; i < pool->max_order; i++)
>  		INIT_LIST_HEAD(&pool->free_area[i]);
>  	pool->range_start = phys;
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 09aafc05aef4..379dada82d4b 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -27,11 +27,14 @@
>  #ifndef CONFIG_ARCH_FORCE_MAX_ORDER
>  #ifdef CONFIG_SET_MAX_ORDER
>  #define MAX_ORDER CONFIG_SET_MAX_ORDER
> +#define MIN_MAX_ORDER CONFIG_SET_MAX_ORDER
>  #else
>  #define MAX_ORDER 11
> +#define MIN_MAX_ORDER MAX_ORDER
>  #endif /* CONFIG_SET_MAX_ORDER */
>  #else
>  #define MAX_ORDER CONFIG_ARCH_FORCE_MAX_ORDER
> +#define MIN_MAX_ORDER CONFIG_ARCH_FORCE_MAX_ORDER
>  #endif /* CONFIG_ARCH_FORCE_MAX_ORDER */
>  #define MAX_ORDER_NR_PAGES (1 << (MAX_ORDER - 1))

The end result of this #ifdef explosion looks entirely unreadable:

/* Free memory management - zoned buddy allocator.  */
#ifndef CONFIG_ARCH_FORCE_MAX_ORDER
#ifdef CONFIG_SET_MAX_ORDER
/* Defined in mm/page_alloc.c */
extern int buddy_alloc_max_order;

#define MAX_ORDER buddy_alloc_max_order
#define MIN_MAX_ORDER CONFIG_SET_MAX_ORDER
#else
#define MAX_ORDER 11
#define MIN_MAX_ORDER MAX_ORDER
#endif /* CONFIG_SET_MAX_ORDER */
#else

#ifdef CONFIG_SPARSEMEM_VMEMMAP
/* Defined in mm/page_alloc.c */
extern int buddy_alloc_max_order;

#define MAX_ORDER buddy_alloc_max_order
#else
#define MAX_ORDER CONFIG_ARCH_FORCE_MAX_ORDER
#endif /* CONFIG_SPARSEMEM_VMEMMAP */
#define MIN_MAX_ORDER CONFIG_ARCH_FORCE_MAX_ORDER
#endif /* CONFIG_ARCH_FORCE_MAX_ORDER */

> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 2c0d80cca6b8..d8747c158db6 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -244,8 +244,8 @@ static inline void __check_heap_object(const void *ptr, unsigned long n,
>   * to do various tricks to work around compiler limitations in order to
>   * ensure proper constant folding.
>   */
> -#define KMALLOC_SHIFT_HIGH	((MAX_ORDER + PAGE_SHIFT - 1) <= 25 ? \
> -				(MAX_ORDER + PAGE_SHIFT - 1) : 25)
> +#define KMALLOC_SHIFT_HIGH	((MIN_MAX_ORDER + PAGE_SHIFT - 1) <= 25 ? \
> +				(MIN_MAX_ORDER + PAGE_SHIFT - 1) : 25)
>  #define KMALLOC_SHIFT_MAX	KMALLOC_SHIFT_HIGH
>  #ifndef KMALLOC_SHIFT_LOW
>  #define KMALLOC_SHIFT_LOW	5
> @@ -258,7 +258,7 @@ static inline void __check_heap_object(const void *ptr, unsigned long n,
>   * (PAGE_SIZE*2).  Larger requests are passed to the page allocator.
>   */
>  #define KMALLOC_SHIFT_HIGH	(PAGE_SHIFT + 1)
> -#define KMALLOC_SHIFT_MAX	(MAX_ORDER + PAGE_SHIFT - 1)
> +#define KMALLOC_SHIFT_MAX	(MIN_MAX_ORDER + PAGE_SHIFT - 1)
>  #ifndef KMALLOC_SHIFT_LOW
>  #define KMALLOC_SHIFT_LOW	3
>  #endif
> @@ -271,7 +271,7 @@ static inline void __check_heap_object(const void *ptr, unsigned long n,
>   * be allocated from the same page.
>   */
>  #define KMALLOC_SHIFT_HIGH	PAGE_SHIFT
> -#define KMALLOC_SHIFT_MAX	(MAX_ORDER + PAGE_SHIFT - 1)
> +#define KMALLOC_SHIFT_MAX	(MIN_MAX_ORDER + PAGE_SHIFT - 1)
>  #ifndef KMALLOC_SHIFT_LOW
>  #define KMALLOC_SHIFT_LOW	3
>  #endif
> diff --git a/mm/slab.c b/mm/slab.c
> index d0f725637663..0041de8ec0e9 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -466,7 +466,7 @@ static int __init slab_max_order_setup(char *str)
>  {
>  	get_option(&str, &slab_max_order);
>  	slab_max_order = slab_max_order < 0 ? 0 :
> -				min(slab_max_order, MAX_ORDER - 1);
> +				min(slab_max_order, MIN_MAX_ORDER - 1);
>  	slab_max_order_set = true;
>  
>  	return 1;
> diff --git a/mm/slub.c b/mm/slub.c
> index b6c5205252eb..228e4a77c678 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3564,8 +3564,9 @@ static inline int calculate_order(unsigned int size)
>  	/*
>  	 * Doh this slab cannot be placed using slub_max_order.
>  	 */
> -	order = slab_order(size, 1, MAX_ORDER, 1);
> -	if (order < MAX_ORDER)
> +
> +	order = slab_order(size, 1, MIN_MAX_ORDER, 1);
> +	if (order < MIN_MAX_ORDER)
>  		return order;
>  	return -ENOSYS;
>  }
> @@ -4079,7 +4080,7 @@ __setup("slub_min_order=", setup_slub_min_order);
>  static int __init setup_slub_max_order(char *str)
>  {
>  	get_option(&str, (int *)&slub_max_order);
> -	slub_max_order = min(slub_max_order, (unsigned int)MAX_ORDER - 1);
> +	slub_max_order = min(slub_max_order, (unsigned int)MIN_MAX_ORDER - 1);
>  
>  	return 1;
>  }
> -- 
> 2.30.2
> 

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
