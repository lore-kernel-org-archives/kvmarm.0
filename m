From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 3/4] KVM: arm64: Support dirty page tracking for PUD
 hugepages
Date: Fri, 27 Apr 2018 13:14:50 +0200
Message-ID: <20180427111450.GN13249@C02W217FHV2R.local>
References: <20180420145409.24485-1-punit.agrawal@arm.com>
 <20180420145409.24485-4-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180420145409.24485-4-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 20, 2018 at 03:54:08PM +0100, Punit Agrawal wrote:
> In preparation for creating PUD hugepages at stage 2, add support for
> write protecting PUD hugepages when they are encountered. Write
> protecting guest tables is used to track dirty pages when migrating
> VMs.
> 
> Also, provide trivial implementations of required kvm_s2pud_* helpers
> to allow sharing of code with arm32.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/include/asm/kvm_mmu.h   | 16 ++++++++++++++++
>  arch/arm64/include/asm/kvm_mmu.h | 10 ++++++++++
>  virt/kvm/arm/mmu.c               |  9 ++++++---
>  3 files changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index 5907a81ad5c1..224c22c0a69c 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -80,6 +80,22 @@ void kvm_clear_hyp_idmap(void);
>  
>  #define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
>  
> +/*
> + * The following kvm_*pud*() functionas are provided strictly to allow
> + * sharing code with arm64. They should never be called in practice.
> + */
> +static inline void kvm_set_s2pud_readonly(pud_t *pud)
> +{
> +	BUG();
> +}
> +
> +static inline bool kvm_s2pud_readonly(pud_t *pud)
> +{
> +	BUG();
> +	return false;
> +}
> +
> +
>  static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
>  {
>  	*pmd = new_pmd;
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index d962508ce4b3..f440cf216a23 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -240,6 +240,16 @@ static inline bool kvm_s2pmd_exec(pmd_t *pmdp)
>  	return !(READ_ONCE(pmd_val(*pmdp)) & PMD_S2_XN);
>  }
>  
> +static inline void kvm_set_s2pud_readonly(pud_t *pudp)
> +{
> +	kvm_set_s2pte_readonly((pte_t *)pudp);
> +}
> +
> +static inline bool kvm_s2pud_readonly(pud_t *pudp)
> +{
> +	return kvm_s2pte_readonly((pte_t *)pudp);
> +}
> +
>  static inline bool kvm_page_empty(void *ptr)
>  {
>  	struct page *ptr_page = virt_to_page(ptr);
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index f72ae7a6dea0..5f53909da90e 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1286,9 +1286,12 @@ static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
>  	do {
>  		next = stage2_pud_addr_end(addr, end);
>  		if (!stage2_pud_none(*pud)) {
> -			/* TODO:PUD not supported, revisit later if supported */
> -			BUG_ON(stage2_pud_huge(*pud));
> -			stage2_wp_pmds(pud, addr, next);
> +			if (stage2_pud_huge(*pud)) {
> +				if (!kvm_s2pud_readonly(pud))
> +					kvm_set_s2pud_readonly(pud);
> +			} else {
> +				stage2_wp_pmds(pud, addr, next);
> +			}
>  		}
>  	} while (pud++, addr = next, addr != end);
>  }
> -- 
> 2.17.0
> 

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
