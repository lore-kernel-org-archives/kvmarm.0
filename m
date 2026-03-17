Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43BE22F5313
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 16:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773763232; cv=none; b=J1ZW/SjcWqu2HrSX5lzAN0M6hjC1zmx9p1G8aTeWTwai8YYOZB0uyE5djcbDc9idSHjWWNFjxvEItlMeI54Ckbp83cOZfMpLlm13AHUDLHXFv3vHLhH6tmGHP61YlBnWb89om91cJyA/O8K4+VdgOsjZ/g8vocJgHEFE0DRLE/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773763232; c=relaxed/simple;
	bh=kVZGu2nP+tiHWw/hAS47L9tghuDONhuPMZc0/av/xDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJ3ev+sJM2IXbOZnccm04MdpMhgOsNg9wtLwGvqdmHuJmo+1CccwL5dN8SNC+gWqhA7MY9vofsh8oqJN8NCUup4AAbGeL7OFWXRNX4O8mrhL8dk8UWZEGLqpteY+O3JW16XHahfTCA4v4h6ZZqPY4sC7s11fzUkW7a00hm/6zr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E2C01477;
	Tue, 17 Mar 2026 09:00:23 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A68CA3F778;
	Tue, 17 Mar 2026 09:00:27 -0700 (PDT)
Date: Tue, 17 Mar 2026 16:00:25 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, vdonnefort@google.com
Subject: Re: [PATCH v1 02/13] KVM: arm64: Introduce struct kvm_s2_fault to
 user_mem_abort()
Message-ID: <20260317160025.GB3808327@e124191.cambridge.arm.com>
References: <20260306140232.2193802-1-tabba@google.com>
 <20260306140232.2193802-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306140232.2193802-3-tabba@google.com>

On Fri, Mar 06, 2026 at 02:02:21PM +0000, Fuad Tabba wrote:
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
> Signed-off-by: Fuad Tabba <tabba@google.com>

A few nits later on, that can be changed or ignored!

maz's branch changes a lot of this again, but still:

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 222 +++++++++++++++++++++++++------------------
>  1 file changed, 128 insertions(+), 94 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f8064b2d3204..419b793c5891 100644
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
> @@ -1749,43 +1779,44 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
>  	/*
> -	 * Let's check if we will get back a huge page backed by hugetlbfs, or
> +	 * Let's check if we will get back a huge fault->page backed by hugetlbfs, or

Seems like a find/replace issue. This one (and the others below) seem to be
talking more generically about 'page'.

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
> -	 * Check if this is non-struct page memory PFN, and cannot support
> +	 * Check if this is non-struct fault->page memory PFN, and cannot support

Here too.

>  	 * CMOs. It could potentially be unsafe to access as cacheable.
>  	 */
> -	if (vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(pfn)) {
> -		if (is_vma_cacheable) {
> +	if (fault->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
> +		if (fault->is_vma_cacheable) {
>  			/*
>  			 * Whilst the VMA owner expects cacheable mapping to this
>  			 * PFN, hardware also has to support the FWB and CACHE DIC
> @@ -1832,26 +1864,26 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  				ret = -EFAULT;
>  		} else {
>  			/*
> -			 * If the page was identified as device early by looking at
> -			 * the VMA flags, vma_pagesize is already representing the
> +			 * If the fault->page was identified as device early by looking at

Here too.

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
> +		 * Only actually map the fault->page as fault->writable if this was a write
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
> @@ -1860,101 +1892,103 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	/*
>  	 * Guest performs atomic/exclusive operations on memory with unsupported
>  	 * attributes (e.g. ld64b/st64b on normal memory when no FEAT_LS64WB)
> -	 * and trigger the exception here. Since the memslot is valid, inject
> +	 * and trigger the exception here. Since the fault->memslot is valid, inject

Here too.

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
>  
>  	/*
> -	 * If we are not forced to use page mapping, check if we are
> +	 * If we are not forced to use fault->page mapping, check if we are

Here too.

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
> -	/* Mark the page dirty only if the fault is handled successfully */
> -	if (writable && !ret)
> -		mark_page_dirty_in_slot(kvm, memslot, gfn);
> +	/* Mark the fault->page dirty only if the fault is handled successfully */
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
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 
