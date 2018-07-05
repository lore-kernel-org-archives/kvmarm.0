From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v4 4/7] KVM: arm64: Support PUD hugepage in
 stage2_is_exec()
Date: Thu, 5 Jul 2018 17:48:37 +0100
Message-ID: <442d0f4b-cb23-9788-1ebd-b14c89c52c45@arm.com>
References: <20180705140850.5801-1-punit.agrawal@arm.com>
 <20180705140850.5801-5-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180705140850.5801-5-punit.agrawal@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Punit,

On 05/07/18 15:08, Punit Agrawal wrote:
> In preparation for creating PUD hugepages at stage 2, add support for
> detecting execute permissions on PUD page table entries. Faults due to
> lack of execute permissions on page table entries is used to perform
> i-cache invalidation on first execute.
> 
> Provide trivial implementations of arm32 helpers to allow sharing of
> code.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>   arch/arm/include/asm/kvm_mmu.h         |  6 ++++++
>   arch/arm64/include/asm/kvm_mmu.h       |  5 +++++
>   arch/arm64/include/asm/pgtable-hwdef.h |  2 ++
>   virt/kvm/arm/mmu.c                     | 10 +++++++++-
>   4 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index c23722f75d5c..d05c8986e495 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -96,6 +96,12 @@ static inline bool kvm_s2pud_readonly(pud_t *pud)
>   }
>   
>   
> +static inline bool kvm_s2pud_exec(pud_t *pud)
> +{
> +	BUG();
> +	return false;
> +}
> +
>   static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
>   {
>   	*pmd = new_pmd;
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 84051930ddfe..15bc1be8f82f 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -249,6 +249,11 @@ static inline bool kvm_s2pud_readonly(pud_t *pudp)
>   	return kvm_s2pte_readonly((pte_t *)pudp);
>   }
>   
> +static inline bool kvm_s2pud_exec(pud_t *pudp)
> +{
> +	return !(READ_ONCE(pud_val(*pudp)) & PUD_S2_XN);
> +}
> +
>   static inline bool kvm_page_empty(void *ptr)
>   {
>   	struct page *ptr_page = virt_to_page(ptr);
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index fd208eac9f2a..10ae592b78b8 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -193,6 +193,8 @@
>   #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
>   #define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
>   
> +#define PUD_S2_XN		(_AT(pudval_t, 2) << 53)  /* XN[1:0] */
> +

The changes above look good to me. Please see below.

>   /*
>    * Memory Attribute override for Stage-2 (MemAttr[3:0])
>    */
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index db04b18218c1..ccdea0edabb3 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1040,10 +1040,18 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>   
>   static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
>   {
> +	pud_t *pudp;
>   	pmd_t *pmdp;
>   	pte_t *ptep;
>   
> -	pmdp = stage2_get_pmd(kvm, NULL, addr);
> +	pudp = stage2_get_pud(kvm, NULL, addr);
> +	if (!pudp || pud_none(*pudp) || !pud_present(*pudp))
> +		return false;
> +
> +	if (pud_huge(*pudp))
> +		return kvm_s2pud_exec(pudp);
> +
> +	pmdp = stage2_pmd_offset(pudp, addr);
>   	if (!pmdp || pmd_none(*pmdp) || !pmd_present(*pmdp))
>   		return false;

I am wondering if we need a slightly better way to deal with this
kind of operation. We seem to duplicate the above operation (here and
in the following patches), i.e, finding the "leaf entry" for a given
address and follow the checks one level up at a time.

So instead of doing, stage2_get_pud() and walking down everywhere this
is needed, how about adding :

/* Returns true if the leaf entry is found and updates the relevant pointer */
found = stage2_get_leaf_entry(kvm, NULL, addr, &pudp, &pmdp, &ptep)

which could set the appropriate entry and we could check the result here.

Cheers
Suzuki
