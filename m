From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/3] arm64: KVM: Fix stage-2 PGD allocation to have
 per-page refcounting
Date: Mon, 2 Mar 2015 10:27:05 -0800
Message-ID: <20150302182705.GD10137@lvm>
References: <1424883340-29940-1-git-send-email-marc.zyngier@arm.com>
 <1424883340-29940-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DA9C47722
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 13:21:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V+iLNZZ9WyFK for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 13:21:30 -0500 (EST)
Received: from mail-qa0-f46.google.com (mail-qa0-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 650E0476AC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 13:21:29 -0500 (EST)
Received: by mail-qa0-f46.google.com with SMTP id n4so24280793qaq.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2015 10:27:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1424883340-29940-2-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 25, 2015 at 04:55:38PM +0000, Marc Zyngier wrote:
> We're using __get_free_pages with to allocate the guest's stage-2
> PGD. The standard behaviour of this function is to return a set of
> pages where only the head page has a valid refcount.
> 
> This behaviour gets us into trouble when we're trying to increment
> the refount on a non-head page:
> 
> page:ffff7c00cfb693c0 count:0 mapcount:0 mapping:          (null) index:0x0
> flags: 0x4000000000000000()
> page dumped because: VM_BUG_ON_PAGE((*({ __attribute__((unused)) typeof((&page->_count)->counter) __var = ( typeof((&page->_count)->counter)) 0; (volatile typeof((&page->_count)->counter) *)&((&page->_count)->counter); })) <= 0)
> BUG: failure at include/linux/mm.h:548/get_page()!
> Kernel panic - not syncing: BUG!
> CPU: 1 PID: 1695 Comm: kvm-vcpu-0 Not tainted 4.0.0-rc1+ #3825
> Hardware name: APM X-Gene Mustang board (DT)
> Call trace:
> [<ffff80000008a09c>] dump_backtrace+0x0/0x13c
> [<ffff80000008a1e8>] show_stack+0x10/0x1c
> [<ffff800000691da8>] dump_stack+0x74/0x94
> [<ffff800000690d78>] panic+0x100/0x240
> [<ffff8000000a0bc4>] stage2_get_pmd+0x17c/0x2bc
> [<ffff8000000a1dc4>] kvm_handle_guest_abort+0x4b4/0x6b0
> [<ffff8000000a420c>] handle_exit+0x58/0x180
> [<ffff80000009e7a4>] kvm_arch_vcpu_ioctl_run+0x114/0x45c
> [<ffff800000099df4>] kvm_vcpu_ioctl+0x2e0/0x754
> [<ffff8000001c0a18>] do_vfs_ioctl+0x424/0x5c8
> [<ffff8000001c0bfc>] SyS_ioctl+0x40/0x78
> CPU0: stopping
> 
> Passing the (unintuitively named) __GFP_COMP flag to __get_free_pages
> forces the allocator to maintain a per-page refcount, which is exactly
> what we need.

There's a concerning comment with what seems to be the same kind of
scenario in arch/tile/mm/pgtable.c:248.

I'm a little confused here, because it looks like prep_new_page() calls
prep_compound_page(), which is the effect you're looking for, but it
sets the page count of all tail pages to 0, and I think our code expects
all page table pages with all entries clear to have a page count of 1,
i.e. the allocation count itself, so don't we still have a discrepency
between head and tail pages for compound allocations?

So I'm wondering if we should simply call split_page() on the allocation
or if there's some other way of doing individual multiple contigous page
allocations?  Am I seeing ghosts?

> 
> This has been tested on an X-Gene platform with a 4kB/48bit-VA host
> kernel, and kvmtool hacked to place memory in the second page of
> the hardware PGD (PUD for the host kernel).
> 
> Reported-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_mmu.h   | 7 +++++++
>  arch/arm/kvm/mmu.c               | 2 +-
>  arch/arm64/include/asm/kvm_mmu.h | 9 ++++++++-
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index 37ca2a4..1cac89b 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -162,6 +162,13 @@ static inline bool kvm_page_empty(void *ptr)
>  
>  #define KVM_PREALLOC_LEVEL	0
>  
> +/*
> + * We need to ensure that stage-2 PGDs are allocated with a per-page
> + * refcount, as we fiddle with the refcounts of non-head pages.
> + * __GFP_COMP forces the allocator to do what we want.
> + */
> +#define KVM_GFP_S2_PGD	(GFP_KERNEL | __GFP_ZERO | __GFP_COMP)
> +
>  static inline int kvm_prealloc_hwpgd(struct kvm *kvm, pgd_t *pgd)
>  {

what about the case for kvm_prealloc_hwpgd, why doesn't it need to use
the new GFP mask?

>  	return 0;
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 3e6859b..a6a8252 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -666,7 +666,7 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
>  		 * Allocate actual first-level Stage-2 page table used by the
>  		 * hardware for Stage-2 page table walks.
>  		 */
> -		pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, S2_PGD_ORDER);
> +		pgd = (pgd_t *)__get_free_pages(KVM_GFP_S2_PGD, S2_PGD_ORDER);
>  	}
>  
>  	if (!pgd)
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 6458b53..06c733a 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -171,6 +171,13 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
>  #define KVM_PREALLOC_LEVEL	(0)
>  #endif
>  
> +/*
> + * We need to ensure that stage-2 PGDs are allocated with a per-page
> + * refcount, as we fiddle with the refcounts of non-head pages.
> + * __GFP_COMP forces the allocator to do what we want.
> + */
> +#define KVM_GFP_S2_PGD	(GFP_KERNEL | __GFP_ZERO | __GFP_COMP)
> +
>  /**
>   * kvm_prealloc_hwpgd - allocate inital table for VTTBR
>   * @kvm:	The KVM struct pointer for the VM.
> @@ -192,7 +199,7 @@ static inline int kvm_prealloc_hwpgd(struct kvm *kvm, pgd_t *pgd)
>  	if (KVM_PREALLOC_LEVEL == 0)
>  		return 0;
>  
> -	hwpgd = __get_free_pages(GFP_KERNEL | __GFP_ZERO, PTRS_PER_S2_PGD_SHIFT);
> +	hwpgd = __get_free_pages(KVM_GFP_S2_PGD, PTRS_PER_S2_PGD_SHIFT);
>  	if (!hwpgd)
>  		return -ENOMEM;
>  
> -- 
> 2.1.4
> 

Thanks,
-Christoffer
