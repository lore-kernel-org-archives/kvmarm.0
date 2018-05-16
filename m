From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v3 4/4] KVM: arm64: Add support for PUD hugepages at stage 2
Date: Wed, 16 May 2018 12:08:57 +0100
Message-ID: <87wow326ye.fsf@e105922-lin.cambridge.arm.com>
References: <20180514144304.10484-1-punit.agrawal@arm.com>
        <20180514144304.10484-5-punit.agrawal@arm.com>
        <574c197f-378c-ca14-676b-c81e92585b4f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <574c197f-378c-ca14-676b-c81e92585b4f@arm.com> (Suzuki
        K. Poulose's message of "Tue, 15 May 2018 23:19:21 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 05/14/2018 03:43 PM, Punit Agrawal wrote:
>> KVM only supports PMD hugepages at stage 2. Extend the stage 2 fault
>> handling to add support for PUD hugepages.
>>
>> Addition of pud hugepage support enables additional hugepage
>> sizes (e.g., 1G with 4K granule) which can be useful on cores that
>> support mapping larger block sizes in the TLB entries.
>>
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> ---
>>   arch/arm/include/asm/kvm_mmu.h         | 19 ++++++++++++
>>   arch/arm64/include/asm/kvm_mmu.h       | 15 ++++++++++
>>   arch/arm64/include/asm/pgtable-hwdef.h |  4 +++
>>   arch/arm64/include/asm/pgtable.h       |  2 ++
>>   virt/kvm/arm/mmu.c                     | 40 ++++++++++++++++++++++++--
>>   5 files changed, 77 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
>> index 224c22c0a69c..155916dbdd7e 100644
>> --- a/arch/arm/include/asm/kvm_mmu.h
>> +++ b/arch/arm/include/asm/kvm_mmu.h
>> @@ -77,8 +77,11 @@ void kvm_clear_hyp_idmap(void);
>>     #define kvm_pfn_pte(pfn, prot)	pfn_pte(pfn, prot)
>>   #define kvm_pfn_pmd(pfn, prot)	pfn_pmd(pfn, prot)
>> +#define kvm_pfn_pud(pfn, prot)	(__pud(0))
>>     #define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
>> +/* No support for pud hugepages */
>> +#define kvm_pud_mkhuge(pud)	(pud)
>>     /*
>>    * The following kvm_*pud*() functionas are provided strictly to allow
>> @@ -95,6 +98,22 @@ static inline bool kvm_s2pud_readonly(pud_t *pud)
>>   	return false;
>>   }
>>   +static inline void kvm_set_pud(pud_t *pud, pud_t new_pud)
>> +{
>> +	BUG();
>> +}
>> +
>> +static inline pud_t kvm_s2pud_mkwrite(pud_t pud)
>> +{
>> +	BUG();
>> +	return pud;
>> +}
>> +
>> +static inline pud_t kvm_s2pud_mkexec(pud_t pud)
>> +{
>> +	BUG();
>> +	return pud;
>> +}
>>     static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
>>   {
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index f440cf216a23..f49a68fcbf26 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -172,11 +172,14 @@ void kvm_clear_hyp_idmap(void);
>>     #define	kvm_set_pte(ptep, pte)		set_pte(ptep, pte)
>>   #define	kvm_set_pmd(pmdp, pmd)		set_pmd(pmdp, pmd)
>> +#define kvm_set_pud(pudp, pud)		set_pud(pudp, pud)
>>     #define kvm_pfn_pte(pfn, prot)		pfn_pte(pfn, prot)
>>   #define kvm_pfn_pmd(pfn, prot)		pfn_pmd(pfn, prot)
>> +#define kvm_pfn_pud(pfn, prot)		pfn_pud(pfn, prot)
>>     #define kvm_pmd_mkhuge(pmd)		pmd_mkhuge(pmd)
>> +#define kvm_pud_mkhuge(pud)		pud_mkhuge(pud)
>>     static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
>>   {
>> @@ -190,6 +193,12 @@ static inline pmd_t kvm_s2pmd_mkwrite(pmd_t pmd)
>>   	return pmd;
>>   }
>>   +static inline pud_t kvm_s2pud_mkwrite(pud_t pud)
>> +{
>> +	pud_val(pud) |= PUD_S2_RDWR;
>> +	return pud;
>> +}
>> +
>>   static inline pte_t kvm_s2pte_mkexec(pte_t pte)
>>   {
>>   	pte_val(pte) &= ~PTE_S2_XN;
>> @@ -202,6 +211,12 @@ static inline pmd_t kvm_s2pmd_mkexec(pmd_t pmd)
>>   	return pmd;
>>   }
>>   +static inline pud_t kvm_s2pud_mkexec(pud_t pud)
>> +{
>> +	pud_val(pud) &= ~PUD_S2_XN;
>> +	return pud;
>> +}
>> +
>>   static inline void kvm_set_s2pte_readonly(pte_t *ptep)
>>   {
>>   	pteval_t old_pteval, pteval;
>> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
>> index fd208eac9f2a..e327665e94d1 100644
>> --- a/arch/arm64/include/asm/pgtable-hwdef.h
>> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
>> @@ -193,6 +193,10 @@
>>   #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
>>   #define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
>>   +#define PUD_S2_RDONLY		(_AT(pudval_t, 1) << 6)   /*
>> HAP[2:1] */
>> +#define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
>> +#define PUD_S2_XN		(_AT(pudval_t, 2) << 53)  /* XN[1:0] */
>> +
>>   /*
>>    * Memory Attribute override for Stage-2 (MemAttr[3:0])
>>    */
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 7c4c8f318ba9..31ea9fda07e3 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -386,6 +386,8 @@ static inline int pmd_protnone(pmd_t pmd)
>>     #define pud_write(pud)		pte_write(pud_pte(pud))
>>   +#define pud_mkhuge(pud)		(__pud(pud_val(pud) &
>> ~PUD_TABLE_BIT))
>> +
>>   #define __pud_to_phys(pud)	__pte_to_phys(pud_pte(pud))
>>   #define __phys_to_pud_val(phys)	__phys_to_pte_val(phys)
>>   #define pud_pfn(pud)		((__pud_to_phys(pud) & PUD_MASK) >> PAGE_SHIFT)
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 671d3c0825f2..b0931fa2d64e 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1036,6 +1036,26 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>>   	return 0;
>>   }
>>   +static int stage2_set_pud_huge(struct kvm *kvm, struct
>> kvm_mmu_memory_cache *cache,
>> +			       phys_addr_t addr, const pud_t *new_pud)
>> +{
>> +	pud_t *pud, old_pud;
>> +
>> +	pud = stage2_get_pud(kvm, cache, addr);
>> +	VM_BUG_ON(!pud);
>> +
>> +	old_pud = *pud;
>> +	if (pud_present(old_pud)) {
>> +		pud_clear(pud);
>> +		kvm_tlb_flush_vmid_ipa(kvm, addr);
>> +	} else {
>> +		get_page(virt_to_page(pud));
>> +	}
>> +
>> +	kvm_set_pud(pud, *new_pud);
>> +	return 0;
>> +}
>> +
>>   static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
>>   {
>>   	pmd_t *pmdp;
>> @@ -1467,9 +1487,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	}
>>     	vma_pagesize = vma_kernel_pagesize(vma);
>> -	if (vma_pagesize == PMD_SIZE && !logging_active) {
>> +	if ((vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) &&
>> +	    !logging_active) {
>> +		struct hstate *h = hstate_vma(vma);
>> +
>>   		hugetlb = true;
>> -		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
>> +		gfn = (fault_ipa & huge_page_mask(h)) >> PAGE_SHIFT;
>>   	} else {
>>   		/*
>>   		 * Pages belonging to memslots that don't have the same
>> @@ -1555,7 +1578,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	if (exec_fault)
>>   		invalidate_icache_guest_page(pfn, vma_pagesize);
>>   -	if (vma_pagesize == PMD_SIZE) {
>> +	if (vma_pagesize == PUD_SIZE) {
>> +		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
>> +
>> +		new_pud = kvm_pud_mkhuge(new_pud);
>> +		if (writable)
>> +			new_pud = kvm_s2pud_mkwrite(new_pud);
>> +
>> +		if (stage2_should_exec(kvm, fault_ipa, exec_fault, fault_status))
>> +			new_pud = kvm_s2pud_mkexec(new_pud);
>> +
>> +		ret = stage2_set_pud_huge(kvm, memcache, fault_ipa, &new_pud);
>> +	} else if (vma_pagesize == PMD_SIZE) {
>>   		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
>>     		new_pmd = kvm_pmd_mkhuge(new_pmd);
>>
>
>
> Punit,
>
> Sorry for the late notice. I was looking deeply in to the stage2 table
> code to rework the same for dynamic IPA and thus found this.
>
> I am wondering if these changes are sufficient enough to add the PUD
> hugepage support. There are lots places where we simply get the
> stage2_pmd of a given address and then go about doing something at the
> PMD level or drill down to PTE if the PMD is not huge. (e.g
> stage2_is_exec, handle_access_fault etc). We simply do a pmd_offset()
> on a PUD entry, without even checking if the PUD is huge or not.

Having stared at the relevant code, I agree that more bits in the stage2
mmu logic needs to be made huge PUD aware.

I've been running guests with huge PUD on hardware and didn't hit any
issues. But this seems to be due to the affected code running only in
certain scenarios such as when save-restoring and possibly under memory
pressure.

I'll make sure to add this to my testing for the next version.

>
> With the PUD huge support, I think we need to go a level up in all
> these cases and drill down from PUD level, down to the PMD level and
> then further down, depending on whether we have huge page support at
> either of these levels.

>From a quick check I've identified the following functions (in addition
to stage2_is_exec and handle_access_fault) which need to looked into -

* stage2_get_pmd
* stage2_set_pte
* kvm_age_hva_handler
* kvm_test_age_hva_handler

I'll address PUD huegpage awareness throughout stage2 in the next
version.

Thanks,
Punit


>
>
> Cheers
> Suzuki
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
