From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 16/17] kvm-arm: Cleanup stage2 pgd handling
Date: Fri, 8 Apr 2016 17:08:54 +0200
Message-ID: <20160408150854.GZ8961@cbox>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-17-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FFCC40BDA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 11:07:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id diFzFVx5kne4 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 11:07:15 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0524C407AD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 11:07:14 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id n3so26384627wmn.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 08:08:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459787177-12767-17-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 04, 2016 at 05:26:16PM +0100, Suzuki K Poulose wrote:
> Now that we don't have any fake page table levels for arm64,
> cleanup the common code to get rid of the dead code.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm/include/asm/kvm_mmu.h   |   19 -------------------
>  arch/arm/kvm/arm.c               |    2 +-
>  arch/arm/kvm/mmu.c               |   25 ++++++++-----------------
>  arch/arm64/include/asm/kvm_mmu.h |   18 ------------------
>  4 files changed, 9 insertions(+), 55 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index 50aa901..f8b7920 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -146,25 +146,6 @@ static inline bool kvm_page_empty(void *ptr)
>  #define hyp_pmd_table_empty(pmdp) kvm_page_empty(pmdp)
>  #define hyp_pud_table_empty(pudp) (0)
>  
> -static inline void *kvm_get_hwpgd(struct kvm *kvm)
> -{
> -	return kvm->arch.pgd;
> -}
> -
> -static inline unsigned int kvm_get_hwpgd_size(void)
> -{
> -	return PTRS_PER_S2_PGD * sizeof(pgd_t);
> -}
> -
> -static inline pgd_t *kvm_setup_fake_pgd(pgd_t *hwpgd)
> -{
> -	return hwpgd;
> -}
> -
> -static inline void kvm_free_fake_pgd(pgd_t *pgd)
> -{
> -}
> -
>  struct kvm;
>  
>  #define kvm_flush_dcache_to_poc(a,l)	__cpuc_flush_dcache_area((a), (l))
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 6accd66..dfd4987 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -448,7 +448,7 @@ static void update_vttbr(struct kvm *kvm)
>  	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
>  
>  	/* update vttbr to be used with the new vmid */
> -	pgd_phys = virt_to_phys(kvm_get_hwpgd(kvm));
> +	pgd_phys = virt_to_phys(kvm->arch.pgd);
>  	BUG_ON(pgd_phys & ~VTTBR_BADDR_MASK);
>  	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
>  	kvm->arch.vttbr = pgd_phys | vmid;
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index dda60fc..1cb7e60 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -755,6 +755,11 @@ int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
>  				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
>  }
>  
> +static inline unsigned int kvm_get_hwpgd_size(void)
> +{
> +	return PTRS_PER_S2_PGD * sizeof(pgd_t);
> +}
> +
>  /* Free the HW pgd, one page at a time */
>  static void kvm_free_hwpgd(void *hwpgd)
>  {
> @@ -783,29 +788,16 @@ static void *kvm_alloc_hwpgd(void)
>  int kvm_alloc_stage2_pgd(struct kvm *kvm)
>  {
>  	pgd_t *pgd;
> -	void *hwpgd;
>  
>  	if (kvm->arch.pgd != NULL) {
>  		kvm_err("kvm_arch already initialized?\n");
>  		return -EINVAL;
>  	}
>  
> -	hwpgd = kvm_alloc_hwpgd();
> -	if (!hwpgd)
> +	pgd = kvm_alloc_hwpgd();

can you just inline kvm_alloc_hwpgd and kvm_get_hwpgd_size now?

> +	if (!pgd)
>  		return -ENOMEM;
>  
> -	/*
> -	 * When the kernel uses more levels of page tables than the
> -	 * guest, we allocate a fake PGD and pre-populate it to point
> -	 * to the next-level page table, which will be the real
> -	 * initial page table pointed to by the VTTBR.
> -	 */
> -	pgd = kvm_setup_fake_pgd(hwpgd);
> -	if (IS_ERR(pgd)) {
> -		kvm_free_hwpgd(hwpgd);
> -		return PTR_ERR(pgd);
> -	}
> -
>  	kvm_clean_pgd(pgd);
>  	kvm->arch.pgd = pgd;
>  	return 0;
> @@ -893,8 +885,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
>  		return;
>  
>  	unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
> -	kvm_free_hwpgd(kvm_get_hwpgd(kvm));
> -	kvm_free_fake_pgd(kvm->arch.pgd);
> +	kvm_free_hwpgd(kvm->arch.pgd);
>  	kvm->arch.pgd = NULL;
>  }
>  
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index e3fee0a..249c4fc 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -141,24 +141,6 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
>  	return (pmd_val(*pmd) & PMD_S2_RDWR) == PMD_S2_RDONLY;
>  }
>  
> -static inline void *kvm_get_hwpgd(struct kvm *kvm)
> -{
> -	return kvm->arch.pgd;
> -}
> -
> -static inline unsigned int kvm_get_hwpgd_size(void)
> -{
> -	return PTRS_PER_S2_PGD * sizeof(pgd_t);
> -}
> -
> -static inline pgd_t *kvm_setup_fake_pgd(pgd_t *hwpgd)
> -{
> -	return hwpgd;
> -}
> -
> -static inline void kvm_free_fake_pgd(pgd_t *pgd)
> -{
> -}
>  static inline bool kvm_page_empty(void *ptr)
>  {
>  	struct page *ptr_page = virt_to_page(ptr);
> -- 
> 1.7.9.5
> 

otherwise:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
