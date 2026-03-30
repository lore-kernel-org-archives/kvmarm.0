Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B3F740DFD1
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 04:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774844307; cv=none; b=r9IMN/FLvMEABsyMAe3Mpmhs/MiQj+UMVU/7g5Zkznw0pXKLGSd9eH4lB/pa30R1aFpBLLkVyhI1DHvmRzPFlhkr52HKBvnD0uNkw+bM68Ei/g/t9iyAVEIoW9xI/HYwxZDf+tG9Nkag+5LM3n1pD+mTolf+vXjiHJlQCkfudAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774844307; c=relaxed/simple;
	bh=Z4AgDARLWXKHW03hWSgYt9DaDd9umeiKKIS3+WZJl5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qhYOe9LwIwevZ0Bzd3dcD4hEaxe1VMP2twHDqokU1UIogQRhiaq8YIAxZTaXes0n1wC2dhYX4EnCTojEKTClFg91c/zylAlkQzC3ojlCoIoxNlfP+krX4qIrLLxKy6cjdZIkqPAqc/rKws5UfNYGFaxpx8syM0wFKhH6IfeK14w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OO+xTKzT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OO+xTKzT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D8831C2B;
	Sun, 29 Mar 2026 21:18:18 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 68DD93F915;
	Sun, 29 Mar 2026 21:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774844304; bh=Z4AgDARLWXKHW03hWSgYt9DaDd9umeiKKIS3+WZJl5M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OO+xTKzTrwp+KrNCeULz/Tel5YPvdatzP4vZ6jKoSzFiun18DPYN+BmI2yzUEfBeQ
	 FfAIl6l9AWVIQpQf37RPLfNXBQKf9rETL1O3RFhHUoI4cp88wEGZAR2WqhyC6mwcEn
	 d3eTZ6AxZScray9jbYq4WRcdjSdwMQfh4GYBYX0s=
Message-ID: <02cc517a-2c7f-4dc8-860d-b4ef26e08093@arm.com>
Date: Mon, 30 Mar 2026 09:48:18 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/30] KVM: arm64: Introduce struct kvm_s2_fault to
 user_mem_abort()
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-3-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 27/03/26 5:05 PM, Marc Zyngier wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> The user_mem_abort() function takes many arguments and defines a large
> number of local variables. Passing all these variables around to helper
> functions would result in functions with too many arguments.
> 
> Introduce struct kvm_s2_fault to encapsulate the stage-2 fault state.
> This structure holds both the input parameters and the intermediate
> state required during the fault handling process.
> 
> Update user_mem_abort() to initialize this structure and replace the
> usage of local variables with fields from the new structure.
> 
> This prepares the ground for further extracting parts of
> user_mem_abort() into smaller helper functions that can simply take a
> pointer to the fault state structure.
> 
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 212 +++++++++++++++++++++++++------------------
>  1 file changed, 123 insertions(+), 89 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f8064b2d32045..b366bde15a429 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1710,38 +1710,68 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
>  	return vma_shift;
>  }
>  
> +struct kvm_s2_fault {
> +	struct kvm_vcpu *vcpu;
> +	phys_addr_t fault_ipa;
> +	struct kvm_s2_trans *nested;
> +	struct kvm_memory_slot *memslot;
> +	unsigned long hva;
> +	bool fault_is_perm;
> +
> +	bool write_fault;
> +	bool exec_fault;
> +	bool writable;
> +	bool topup_memcache;
> +	bool mte_allowed;
> +	bool is_vma_cacheable;
> +	bool s2_force_noncacheable;
> +	bool vfio_allow_any_uc;
> +	unsigned long mmu_seq;
> +	phys_addr_t ipa;
> +	short vma_shift;
> +	gfn_t gfn;
> +	kvm_pfn_t pfn;
> +	bool logging_active;
> +	bool force_pte;
> +	long vma_pagesize;
> +	long fault_granule;
> +	enum kvm_pgtable_prot prot;
> +	struct page *page;
> +	vm_flags_t vm_flags;
> +};
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_s2_trans *nested,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>  			  bool fault_is_perm)
>  {
>  	int ret = 0;
> -	bool topup_memcache;
> -	bool write_fault, writable;
> -	bool exec_fault, mte_allowed, is_vma_cacheable;
> -	bool s2_force_noncacheable = false, vfio_allow_any_uc = false;
> -	unsigned long mmu_seq;
> -	phys_addr_t ipa = fault_ipa;
> +	struct kvm_s2_fault fault_data = {
> +		.vcpu = vcpu,
> +		.fault_ipa = fault_ipa,
> +		.nested = nested,
> +		.memslot = memslot,
> +		.hva = hva,
> +		.fault_is_perm = fault_is_perm,
> +		.ipa = fault_ipa,
> +		.logging_active = memslot_is_logging(memslot),
> +		.force_pte = memslot_is_logging(memslot),
> +		.s2_force_noncacheable = false,
> +		.vfio_allow_any_uc = false,
> +		.prot = KVM_PGTABLE_PROT_R,
> +	};
> +	struct kvm_s2_fault *fault = &fault_data;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct vm_area_struct *vma;
> -	short vma_shift;
>  	void *memcache;
> -	gfn_t gfn;
> -	kvm_pfn_t pfn;
> -	bool logging_active = memslot_is_logging(memslot);
> -	bool force_pte = logging_active;
> -	long vma_pagesize, fault_granule;
> -	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt;
> -	struct page *page;
> -	vm_flags_t vm_flags;
>  	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>  
> -	if (fault_is_perm)
> -		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
> -	write_fault = kvm_is_write_fault(vcpu);
> -	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> -	VM_WARN_ON_ONCE(write_fault && exec_fault);
> +	if (fault->fault_is_perm)
> +		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
> +	fault->write_fault = kvm_is_write_fault(fault->vcpu);
> +	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
> +	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
>  
>  	/*
>  	 * Permission faults just need to update the existing leaf entry,
> @@ -1749,8 +1779,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * only exception to this is when dirty logging is enabled at runtime
>  	 * and a write fault needs to collapse a block entry into a table.
>  	 */
> -	topup_memcache = !fault_is_perm || (logging_active && write_fault);
> -	ret = prepare_mmu_memcache(vcpu, topup_memcache, &memcache);
> +	fault->topup_memcache = !fault->fault_is_perm ||
> +				(fault->logging_active && fault->write_fault);
> +	ret = prepare_mmu_memcache(fault->vcpu, fault->topup_memcache, &memcache);
>  	if (ret)
>  		return ret;
>  
> @@ -1759,33 +1790,33 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * get block mapping for device MMIO region.
>  	 */
>  	mmap_read_lock(current->mm);
> -	vma = vma_lookup(current->mm, hva);
> +	vma = vma_lookup(current->mm, fault->hva);
>  	if (unlikely(!vma)) {
> -		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> +		kvm_err("Failed to find VMA for fault->hva 0x%lx\n", fault->hva);
>  		mmap_read_unlock(current->mm);
>  		return -EFAULT;
>  	}
>  
> -	vma_shift = kvm_s2_resolve_vma_size(vma, hva, memslot, nested,
> -					    &force_pte, &ipa);
> -	vma_pagesize = 1UL << vma_shift;
> +	fault->vma_shift = kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot, fault->nested,
> +						   &fault->force_pte, &fault->ipa);
> +	fault->vma_pagesize = 1UL << fault->vma_shift;
>  
>  	/*
>  	 * Both the canonical IPA and fault IPA must be aligned to the
>  	 * mapping size to ensure we find the right PFN and lay down the
>  	 * mapping in the right place.
>  	 */
> -	fault_ipa = ALIGN_DOWN(fault_ipa, vma_pagesize);
> -	ipa = ALIGN_DOWN(ipa, vma_pagesize);
> +	fault->fault_ipa = ALIGN_DOWN(fault->fault_ipa, fault->vma_pagesize);
> +	fault->ipa = ALIGN_DOWN(fault->ipa, fault->vma_pagesize);
>  
> -	gfn = ipa >> PAGE_SHIFT;
> -	mte_allowed = kvm_vma_mte_allowed(vma);
> +	fault->gfn = fault->ipa >> PAGE_SHIFT;
> +	fault->mte_allowed = kvm_vma_mte_allowed(vma);
>  
> -	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> +	fault->vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
>  
> -	vm_flags = vma->vm_flags;
> +	fault->vm_flags = vma->vm_flags;
>  
> -	is_vma_cacheable = kvm_vma_is_cacheable(vma);
> +	fault->is_vma_cacheable = kvm_vma_is_cacheable(vma);
>  
>  	/* Don't use the VMA after the unlock -- it may have vanished */
>  	vma = NULL;
> @@ -1798,24 +1829,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
>  	 * with the smp_wmb() in kvm_mmu_invalidate_end().
>  	 */
> -	mmu_seq = kvm->mmu_invalidate_seq;
> +	fault->mmu_seq = kvm->mmu_invalidate_seq;
>  	mmap_read_unlock(current->mm);
>  
> -	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
> -				&writable, &page);
> -	if (pfn == KVM_PFN_ERR_HWPOISON) {
> -		kvm_send_hwpoison_signal(hva, vma_shift);
> +	fault->pfn = __kvm_faultin_pfn(fault->memslot, fault->gfn,
> +				       fault->write_fault ? FOLL_WRITE : 0,
> +				       &fault->writable, &fault->page);
> +	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
> +		kvm_send_hwpoison_signal(fault->hva, fault->vma_shift);
>  		return 0;
>  	}
> -	if (is_error_noslot_pfn(pfn))
> +	if (is_error_noslot_pfn(fault->pfn))
>  		return -EFAULT;
>  
>  	/*
>  	 * Check if this is non-struct page memory PFN, and cannot support
>  	 * CMOs. It could potentially be unsafe to access as cacheable.
>  	 */
> -	if (vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(pfn)) {
> -		if (is_vma_cacheable) {
> +	if (fault->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
> +		if (fault->is_vma_cacheable) {
>  			/*
>  			 * Whilst the VMA owner expects cacheable mapping to this
>  			 * PFN, hardware also has to support the FWB and CACHE DIC
> @@ -1833,25 +1865,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		} else {
>  			/*
>  			 * If the page was identified as device early by looking at
> -			 * the VMA flags, vma_pagesize is already representing the
> +			 * the VMA flags, fault->vma_pagesize is already representing the
>  			 * largest quantity we can map.  If instead it was mapped
> -			 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
> +			 * via __kvm_faultin_pfn(), fault->vma_pagesize is set to PAGE_SIZE
>  			 * and must not be upgraded.
>  			 *
>  			 * In both cases, we don't let transparent_hugepage_adjust()
>  			 * change things at the last minute.
>  			 */
> -			s2_force_noncacheable = true;
> +			fault->s2_force_noncacheable = true;
>  		}
> -	} else if (logging_active && !write_fault) {
> +	} else if (fault->logging_active && !fault->write_fault) {
>  		/*
> -		 * Only actually map the page as writable if this was a write
> +		 * Only actually map the page as fault->writable if this was a write
>  		 * fault.
>  		 */
> -		writable = false;
> +		fault->writable = false;
>  	}
>  
> -	if (exec_fault && s2_force_noncacheable)
> +	if (fault->exec_fault && fault->s2_force_noncacheable)
>  		ret = -ENOEXEC;
>  
>  	if (ret)
> @@ -1860,21 +1892,21 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	/*
>  	 * Guest performs atomic/exclusive operations on memory with unsupported
>  	 * attributes (e.g. ld64b/st64b on normal memory when no FEAT_LS64WB)
> -	 * and trigger the exception here. Since the memslot is valid, inject
> +	 * and trigger the exception here. Since the fault->memslot is valid, inject
>  	 * the fault back to the guest.
>  	 */
> -	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(vcpu))) {
> -		kvm_inject_dabt_excl_atomic(vcpu, kvm_vcpu_get_hfar(vcpu));
> +	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(fault->vcpu))) {
> +		kvm_inject_dabt_excl_atomic(fault->vcpu, kvm_vcpu_get_hfar(fault->vcpu));
>  		ret = 1;
>  		goto out_put_page;
>  	}
>  
> -	if (nested)
> -		adjust_nested_fault_perms(nested, &prot, &writable);
> +	if (fault->nested)
> +		adjust_nested_fault_perms(fault->nested, &fault->prot, &fault->writable);
>  
>  	kvm_fault_lock(kvm);
> -	pgt = vcpu->arch.hw_mmu->pgt;
> -	if (mmu_invalidate_retry(kvm, mmu_seq)) {
> +	pgt = fault->vcpu->arch.hw_mmu->pgt;
> +	if (mmu_invalidate_retry(kvm, fault->mmu_seq)) {
>  		ret = -EAGAIN;
>  		goto out_unlock;
>  	}
> @@ -1883,78 +1915,80 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * If we are not forced to use page mapping, check if we are
>  	 * backed by a THP and thus use block mapping if possible.
>  	 */
> -	if (vma_pagesize == PAGE_SIZE && !(force_pte || s2_force_noncacheable)) {
> -		if (fault_is_perm && fault_granule > PAGE_SIZE)
> -			vma_pagesize = fault_granule;
> +	if (fault->vma_pagesize == PAGE_SIZE &&
> +	    !(fault->force_pte || fault->s2_force_noncacheable)) {
> +		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE)
> +			fault->vma_pagesize = fault->fault_granule;
>  		else
> -			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
> -								   hva, &pfn,
> -								   &fault_ipa);
> +			fault->vma_pagesize = transparent_hugepage_adjust(kvm, fault->memslot,
> +									  fault->hva, &fault->pfn,
> +									  &fault->fault_ipa);
>  
> -		if (vma_pagesize < 0) {
> -			ret = vma_pagesize;
> +		if (fault->vma_pagesize < 0) {
> +			ret = fault->vma_pagesize;
>  			goto out_unlock;
>  		}
>  	}
>  
> -	if (!fault_is_perm && !s2_force_noncacheable && kvm_has_mte(kvm)) {
> +	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
>  		/* Check the VMM hasn't introduced a new disallowed VMA */
> -		if (mte_allowed) {
> -			sanitise_mte_tags(kvm, pfn, vma_pagesize);
> +		if (fault->mte_allowed) {
> +			sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
>  		} else {
>  			ret = -EFAULT;
>  			goto out_unlock;
>  		}
>  	}
>  
> -	if (writable)
> -		prot |= KVM_PGTABLE_PROT_W;
> +	if (fault->writable)
> +		fault->prot |= KVM_PGTABLE_PROT_W;
>  
> -	if (exec_fault)
> -		prot |= KVM_PGTABLE_PROT_X;
> +	if (fault->exec_fault)
> +		fault->prot |= KVM_PGTABLE_PROT_X;
>  
> -	if (s2_force_noncacheable) {
> -		if (vfio_allow_any_uc)
> -			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
> +	if (fault->s2_force_noncacheable) {
> +		if (fault->vfio_allow_any_uc)
> +			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
>  		else
> -			prot |= KVM_PGTABLE_PROT_DEVICE;
> +			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
>  	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
> -		prot |= KVM_PGTABLE_PROT_X;
> +		fault->prot |= KVM_PGTABLE_PROT_X;
>  	}
>  
> -	if (nested)
> -		adjust_nested_exec_perms(kvm, nested, &prot);
> +	if (fault->nested)
> +		adjust_nested_exec_perms(kvm, fault->nested, &fault->prot);
>  
>  	/*
>  	 * Under the premise of getting a FSC_PERM fault, we just need to relax
> -	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
> +	 * permissions only if fault->vma_pagesize equals fault->fault_granule. Otherwise,
>  	 * kvm_pgtable_stage2_map() should be called to change block size.
>  	 */
> -	if (fault_is_perm && vma_pagesize == fault_granule) {
> +	if (fault->fault_is_perm && fault->vma_pagesize == fault->fault_granule) {
>  		/*
>  		 * Drop the SW bits in favour of those stored in the
>  		 * PTE, which will be preserved.
>  		 */
> -		prot &= ~KVM_NV_GUEST_MAP_SZ;
> -		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
> +		fault->prot &= ~KVM_NV_GUEST_MAP_SZ;
> +		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault->fault_ipa, fault->prot,
> +								 flags);
>  	} else {
> -		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
> -					     __pfn_to_phys(pfn), prot,
> -					     memcache, flags);
> +		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault->fault_ipa, fault->vma_pagesize,
> +							 __pfn_to_phys(fault->pfn), fault->prot,
> +							 memcache, flags);
>  	}
>  
>  out_unlock:
> -	kvm_release_faultin_page(kvm, page, !!ret, writable);
> +	kvm_release_faultin_page(kvm, fault->page, !!ret, fault->writable);
>  	kvm_fault_unlock(kvm);
>  
>  	/* Mark the page dirty only if the fault is handled successfully */
> -	if (writable && !ret)
> -		mark_page_dirty_in_slot(kvm, memslot, gfn);
> +	if (fault->writable && !ret)
> +		mark_page_dirty_in_slot(kvm, fault->memslot, fault->gfn);
>  
>  	return ret != -EAGAIN ? ret : 0;
>  
>  out_put_page:
> -	kvm_release_page_unused(page);
> +	kvm_release_page_unused(fault->page);
>  	return ret;
>  }
>  

