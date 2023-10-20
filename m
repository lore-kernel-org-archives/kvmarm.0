Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC491DA38
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 15:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A15F143D;
	Fri, 20 Oct 2023 08:07:34 -0700 (PDT)
Received: from [10.1.30.154] (XHFQ2J9959.cambridge.arm.com [10.1.30.154])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1F7B3F762;
	Fri, 20 Oct 2023 08:06:51 -0700 (PDT)
Message-ID: <9d4ac532-1642-411b-a826-ab90f0046a6c@arm.com>
Date: Fri, 20 Oct 2023 16:06:50 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/12] KVM: arm64: Use LPA2 page-tables for stage2 and
 hyp stage1
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231009185008.3803879-1-ryan.roberts@arm.com>
 <20231009185008.3803879-7-ryan.roberts@arm.com>
 <86bkctmz6t.wl-maz@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <86bkctmz6t.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/10/2023 10:16, Marc Zyngier wrote:
> On Mon, 09 Oct 2023 19:50:02 +0100,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> Implement a simple policy whereby if the HW supports FEAT_LPA2 for the
>> page size we are using, always use LPA2-style page-tables for stage 2
>> and hyp stage 1, regardless of the VMM-requested IPA size or
>> HW-implemented PA size. When in use we can now support up to 52-bit IPA
>> and PA sizes.
> 
> Maybe worth stating that this S1 comment only applies to the
> standalone EL2 portion, and not the VHE S1 mappings.

ACK.

> 
>>
>> We use the previously created cpu feature to track whether LPA2 is
>> supported for deciding whether to use the LPA2 or classic pte format.
>>
>> Note that FEAT_LPA2 brings support for bigger block mappings (512GB with
>> 4KB, 64GB with 16KB). We explicitly don't enable these in the library
>> because stage2_apply_range() works on batch sizes of the largest used
>> block mapping, and increasing the size of the batch would lead to soft
>> lockups. See commit 5994bc9e05c2 ("KVM: arm64: Limit
>> stage2_apply_range() batch size to largest block").
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_pgtable.h | 47 +++++++++++++++++++++-------
>>  arch/arm64/kvm/arm.c                 |  2 ++
>>  arch/arm64/kvm/hyp/nvhe/tlb.c        |  3 +-
>>  arch/arm64/kvm/hyp/pgtable.c         | 15 +++++++--
>>  arch/arm64/kvm/hyp/vhe/tlb.c         |  3 +-
>>  5 files changed, 54 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> index d3e354bb8351..b240158e1218 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -25,12 +25,22 @@
>>  #define KVM_PGTABLE_MIN_BLOCK_LEVEL	2U
>>  #endif
>>  
>> +static inline u64 kvm_get_parange_max(void)
>> +{
>> +	if (system_supports_lpa2() ||
>> +	   (IS_ENABLED(CONFIG_ARM64_PA_BITS_52) && PAGE_SIZE == SZ_64K))
> 
> nit: the rest of the code uses PAGE_SHIFT instead of PAGE_SIZE. Not a
> big deal, but being consistent might help the reader.

ACK.

> 
>> +		return ID_AA64MMFR0_EL1_PARANGE_52;
>> +	else
>> +		return ID_AA64MMFR0_EL1_PARANGE_48;
>> +}
>> +
>>  static inline u64 kvm_get_parange(u64 mmfr0)
>>  {
>> +	u64 parange_max = kvm_get_parange_max();
>>  	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
>>  				ID_AA64MMFR0_EL1_PARANGE_SHIFT);
>> -	if (parange > ID_AA64MMFR0_EL1_PARANGE_MAX)
>> -		parange = ID_AA64MMFR0_EL1_PARANGE_MAX;
>> +	if (parange > parange_max)
>> +		parange = parange_max;
>>  
>>  	return parange;
>>  }
>> @@ -41,6 +51,8 @@ typedef u64 kvm_pte_t;
>>  
>>  #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
>>  #define KVM_PTE_ADDR_51_48		GENMASK(15, 12)
>> +#define KVM_PTE_ADDR_MASK_LPA2		GENMASK(49, PAGE_SHIFT)
>> +#define KVM_PTE_ADDR_51_50_LPA2		GENMASK(9, 8)
>>  
>>  #define KVM_PHYS_INVALID		(-1ULL)
>>  
>> @@ -51,21 +63,34 @@ static inline bool kvm_pte_valid(kvm_pte_t pte)
>>  
>>  static inline u64 kvm_pte_to_phys(kvm_pte_t pte)
>>  {
>> -	u64 pa = pte & KVM_PTE_ADDR_MASK;
>> -
>> -	if (PAGE_SHIFT == 16)
>> -		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
>> +	u64 pa;
>> +
>> +	if (system_supports_lpa2()) {
>> +		pa = pte & KVM_PTE_ADDR_MASK_LPA2;
>> +		pa |= FIELD_GET(KVM_PTE_ADDR_51_50_LPA2, pte) << 50;
>> +	} else {
>> +		pa = pte & KVM_PTE_ADDR_MASK;
>> +		if (PAGE_SHIFT == 16)
>> +			pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
>> +	}
>>  
>>  	return pa;
>>  }
>>  
>>  static inline kvm_pte_t kvm_phys_to_pte(u64 pa)
>>  {
>> -	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
>> -
>> -	if (PAGE_SHIFT == 16) {
>> -		pa &= GENMASK(51, 48);
>> -		pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
>> +	kvm_pte_t pte;
>> +
>> +	if (system_supports_lpa2()) {
>> +		pte = pa & KVM_PTE_ADDR_MASK_LPA2;
>> +		pa &= GENMASK(51, 50);
>> +		pte |= FIELD_PREP(KVM_PTE_ADDR_51_50_LPA2, pa >> 50);
>> +	} else {
>> +		pte = pa & KVM_PTE_ADDR_MASK;
>> +		if (PAGE_SHIFT == 16) {
>> +			pa &= GENMASK(51, 48);
>> +			pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
>> +		}
>>  	}
>>  
>>  	return pte;
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 4866b3f7b4ea..73cc67c2a8a7 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1747,6 +1747,8 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
>>  	}
>>  	tcr &= ~TCR_T0SZ_MASK;
>>  	tcr |= TCR_T0SZ(hyp_va_bits);
>> +	if (system_supports_lpa2())
>> +		tcr |= TCR_EL2_DS;
>>  	params->tcr_el2 = tcr;
>>  
>>  	params->pgd_pa = kvm_mmu_get_httbr();
>> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
>> index d42b72f78a9b..c3cd16c6f95f 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
>> @@ -198,7 +198,8 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>>  	/* Switch to requested VMID */
>>  	__tlb_switch_to_guest(mmu, &cxt, false);
>>  
>> -	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0, false);
>> +	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0,
>> +				system_supports_lpa2());
> 
> At this stage, I'd fully expect the flag to have been subsumed into
> the helper...

ACK. I'm planning to have has_lpa2() always return false for now. Then once
Ard's changes are in, we can change it to report the system status. Then we can
move this inside __flush_s2_tlb_range_op(). Does that work for you?

> 
>>  
>>  	dsb(ish);
>>  	__tlbi(vmalle1is);
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index f155b8c9e98c..062eb7bcdb8a 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -79,7 +79,10 @@ static bool kvm_pgtable_walk_skip_cmo(const struct kvm_pgtable_visit_ctx *ctx)
>>  
>>  static bool kvm_phys_is_valid(u64 phys)
>>  {
>> -	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_EL1_PARANGE_MAX));
>> +	u64 parange_max = kvm_get_parange_max();
>> +	u8 shift = id_aa64mmfr0_parange_to_phys_shift(parange_max);
>> +
>> +	return phys < BIT(shift);
>>  }
>>  
>>  static bool kvm_block_mapping_supported(const struct kvm_pgtable_visit_ctx *ctx, u64 phys)
>> @@ -408,7 +411,8 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>>  	}
>>  
>>  	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
>> -	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
>> +	if (!system_supports_lpa2())
>> +		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
>>  	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
>>  	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
>>  	*ptep = attr;
>> @@ -654,6 +658,9 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
>>  		vtcr |= VTCR_EL2_HA;
>>  #endif /* CONFIG_ARM64_HW_AFDBM */
>>  
>> +	if (system_supports_lpa2())
>> +		vtcr |= VTCR_EL2_DS;
>> +
>>  	/* Set the vmid bits */
>>  	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
>>  		VTCR_EL2_VS_16BIT :
>> @@ -711,7 +718,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>>  	if (prot & KVM_PGTABLE_PROT_W)
>>  		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>>  
>> -	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
>> +	if (!system_supports_lpa2())
>> +		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
>> +
>>  	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
>>  	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
>>  	*ptep = attr;
>> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
>> index 6041c6c78984..40cea2482a76 100644
>> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
>> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
>> @@ -161,7 +161,8 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>>  	/* Switch to requested VMID */
>>  	__tlb_switch_to_guest(mmu, &cxt);
>>  
>> -	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0, false);
>> +	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0,
>> +				system_supports_lpa2());
>>  
>>  	dsb(ish);
>>  	__tlbi(vmalle1is);
> 
> One thing I don't see here is how you update the tcr_compute_pa_size
> macro that is used on the initial nVHE setup, which is inconsistent
> with the kvm_get_parange_max() helper.

As you saw, it's in a separate patch.

> 
> Thanks,
> 
> 	M.
> 

