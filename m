Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BC53783C8;
	Fri, 27 Mar 2026 11:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611385; cv=none; b=g/0HCAGeVFNuejCFPq1//YiFaJh2ABsJodQPmJ3S9q5Ooy8jaH/dezV3aH+TWfvqIUAjO7FCkZBGGScEZkMWASidu0Vo/4ghsVrt1w2rm9aCJIsD+0j/ecbL0bEP2dOzKnU0n44eyKdI6DRQ+ccYZODMQ3TLZ4LZiAKkDVFmEd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611385; c=relaxed/simple;
	bh=3RUzAXdCYD+rRZxmRUjZpV/le79DzsnRbqCe+lfCtcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0KNi0zz0sdu+3Zr0WTDzznBcmMxEYf9UVCCVsCI7Xj2RBdzvJR3fAL83zv80nZWA4UhcSYxKP70+Sh+1u1KGdEM7o2ekJcFhk7/gVOW2H9v9mtoO95iepmcRNO3DbJrsNerDZQaq7tVrjl3HIWrJpGX/kaY3occHEBgAzGHc+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aBkkm+o0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aBkkm+o0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7FEC19423;
	Fri, 27 Mar 2026 11:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611384;
	bh=3RUzAXdCYD+rRZxmRUjZpV/le79DzsnRbqCe+lfCtcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBkkm+o0L6Jird3es9A1CLjaCEOQFsFXJyMv4CBpUDBJe1Zpy2A+PNW/PUar/i58+
	 bZyfytEQzycy9iy3OKg9Th8vB6QHENqS0PUpjSAOYObWeeZ4u49ODobvn75DTGOU2I
	 QL4cEM+kIeysPTbTHHlvIFcTY0EF9VaD4Dm1br0zEzqh3VJ68vmcJWXnVABIpY0fDs
	 iDGjwVtZfnZTmpdymqCbtzPYF5EcswlOyjZokv+xsQTRbb29DW70532OzrueuM7F3J
	 jdfWvtrMFe7WmgPyyl6dlpr9sdLtPvNjARmRuVGvlNVjtHjSaCAHQp9g2aaFRO462Z
	 6nuvOr1lsvnCw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UE-00000006K4a-2QA5;
	Fri, 27 Mar 2026 11:36:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH v2 02/30] KVM: arm64: Introduce struct kvm_s2_fault to user_mem_abort()
Date: Fri, 27 Mar 2026 11:35:50 +0000
Message-ID: <20260327113618.4051534-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327113618.4051534-1-maz@kernel.org>
References: <20260327113618.4051534-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Fuad Tabba <tabba@google.com>

The user_mem_abort() function takes many arguments and defines a large
number of local variables. Passing all these variables around to helper
functions would result in functions with too many arguments.

Introduce struct kvm_s2_fault to encapsulate the stage-2 fault state.
This structure holds both the input parameters and the intermediate
state required during the fault handling process.

Update user_mem_abort() to initialize this structure and replace the
usage of local variables with fields from the new structure.

This prepares the ground for further extracting parts of
user_mem_abort() into smaller helper functions that can simply take a
pointer to the fault state structure.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 212 +++++++++++++++++++++++++------------------
 1 file changed, 123 insertions(+), 89 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f8064b2d32045..b366bde15a429 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1710,38 +1710,68 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 	return vma_shift;
 }
 
+struct kvm_s2_fault {
+	struct kvm_vcpu *vcpu;
+	phys_addr_t fault_ipa;
+	struct kvm_s2_trans *nested;
+	struct kvm_memory_slot *memslot;
+	unsigned long hva;
+	bool fault_is_perm;
+
+	bool write_fault;
+	bool exec_fault;
+	bool writable;
+	bool topup_memcache;
+	bool mte_allowed;
+	bool is_vma_cacheable;
+	bool s2_force_noncacheable;
+	bool vfio_allow_any_uc;
+	unsigned long mmu_seq;
+	phys_addr_t ipa;
+	short vma_shift;
+	gfn_t gfn;
+	kvm_pfn_t pfn;
+	bool logging_active;
+	bool force_pte;
+	long vma_pagesize;
+	long fault_granule;
+	enum kvm_pgtable_prot prot;
+	struct page *page;
+	vm_flags_t vm_flags;
+};
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  bool fault_is_perm)
 {
 	int ret = 0;
-	bool topup_memcache;
-	bool write_fault, writable;
-	bool exec_fault, mte_allowed, is_vma_cacheable;
-	bool s2_force_noncacheable = false, vfio_allow_any_uc = false;
-	unsigned long mmu_seq;
-	phys_addr_t ipa = fault_ipa;
+	struct kvm_s2_fault fault_data = {
+		.vcpu = vcpu,
+		.fault_ipa = fault_ipa,
+		.nested = nested,
+		.memslot = memslot,
+		.hva = hva,
+		.fault_is_perm = fault_is_perm,
+		.ipa = fault_ipa,
+		.logging_active = memslot_is_logging(memslot),
+		.force_pte = memslot_is_logging(memslot),
+		.s2_force_noncacheable = false,
+		.vfio_allow_any_uc = false,
+		.prot = KVM_PGTABLE_PROT_R,
+	};
+	struct kvm_s2_fault *fault = &fault_data;
 	struct kvm *kvm = vcpu->kvm;
 	struct vm_area_struct *vma;
-	short vma_shift;
 	void *memcache;
-	gfn_t gfn;
-	kvm_pfn_t pfn;
-	bool logging_active = memslot_is_logging(memslot);
-	bool force_pte = logging_active;
-	long vma_pagesize, fault_granule;
-	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
-	struct page *page;
-	vm_flags_t vm_flags;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 
-	if (fault_is_perm)
-		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
-	write_fault = kvm_is_write_fault(vcpu);
-	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
-	VM_WARN_ON_ONCE(write_fault && exec_fault);
+	if (fault->fault_is_perm)
+		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
+	fault->write_fault = kvm_is_write_fault(fault->vcpu);
+	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
+	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
 
 	/*
 	 * Permission faults just need to update the existing leaf entry,
@@ -1749,8 +1779,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
-	topup_memcache = !fault_is_perm || (logging_active && write_fault);
-	ret = prepare_mmu_memcache(vcpu, topup_memcache, &memcache);
+	fault->topup_memcache = !fault->fault_is_perm ||
+				(fault->logging_active && fault->write_fault);
+	ret = prepare_mmu_memcache(fault->vcpu, fault->topup_memcache, &memcache);
 	if (ret)
 		return ret;
 
@@ -1759,33 +1790,33 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * get block mapping for device MMIO region.
 	 */
 	mmap_read_lock(current->mm);
-	vma = vma_lookup(current->mm, hva);
+	vma = vma_lookup(current->mm, fault->hva);
 	if (unlikely(!vma)) {
-		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
+		kvm_err("Failed to find VMA for fault->hva 0x%lx\n", fault->hva);
 		mmap_read_unlock(current->mm);
 		return -EFAULT;
 	}
 
-	vma_shift = kvm_s2_resolve_vma_size(vma, hva, memslot, nested,
-					    &force_pte, &ipa);
-	vma_pagesize = 1UL << vma_shift;
+	fault->vma_shift = kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot, fault->nested,
+						   &fault->force_pte, &fault->ipa);
+	fault->vma_pagesize = 1UL << fault->vma_shift;
 
 	/*
 	 * Both the canonical IPA and fault IPA must be aligned to the
 	 * mapping size to ensure we find the right PFN and lay down the
 	 * mapping in the right place.
 	 */
-	fault_ipa = ALIGN_DOWN(fault_ipa, vma_pagesize);
-	ipa = ALIGN_DOWN(ipa, vma_pagesize);
+	fault->fault_ipa = ALIGN_DOWN(fault->fault_ipa, fault->vma_pagesize);
+	fault->ipa = ALIGN_DOWN(fault->ipa, fault->vma_pagesize);
 
-	gfn = ipa >> PAGE_SHIFT;
-	mte_allowed = kvm_vma_mte_allowed(vma);
+	fault->gfn = fault->ipa >> PAGE_SHIFT;
+	fault->mte_allowed = kvm_vma_mte_allowed(vma);
 
-	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
+	fault->vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
 
-	vm_flags = vma->vm_flags;
+	fault->vm_flags = vma->vm_flags;
 
-	is_vma_cacheable = kvm_vma_is_cacheable(vma);
+	fault->is_vma_cacheable = kvm_vma_is_cacheable(vma);
 
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
@@ -1798,24 +1829,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
 	 * with the smp_wmb() in kvm_mmu_invalidate_end().
 	 */
-	mmu_seq = kvm->mmu_invalidate_seq;
+	fault->mmu_seq = kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
-	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
-				&writable, &page);
-	if (pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(hva, vma_shift);
+	fault->pfn = __kvm_faultin_pfn(fault->memslot, fault->gfn,
+				       fault->write_fault ? FOLL_WRITE : 0,
+				       &fault->writable, &fault->page);
+	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
+		kvm_send_hwpoison_signal(fault->hva, fault->vma_shift);
 		return 0;
 	}
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(fault->pfn))
 		return -EFAULT;
 
 	/*
 	 * Check if this is non-struct page memory PFN, and cannot support
 	 * CMOs. It could potentially be unsafe to access as cacheable.
 	 */
-	if (vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(pfn)) {
-		if (is_vma_cacheable) {
+	if (fault->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
+		if (fault->is_vma_cacheable) {
 			/*
 			 * Whilst the VMA owner expects cacheable mapping to this
 			 * PFN, hardware also has to support the FWB and CACHE DIC
@@ -1833,25 +1865,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		} else {
 			/*
 			 * If the page was identified as device early by looking at
-			 * the VMA flags, vma_pagesize is already representing the
+			 * the VMA flags, fault->vma_pagesize is already representing the
 			 * largest quantity we can map.  If instead it was mapped
-			 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
+			 * via __kvm_faultin_pfn(), fault->vma_pagesize is set to PAGE_SIZE
 			 * and must not be upgraded.
 			 *
 			 * In both cases, we don't let transparent_hugepage_adjust()
 			 * change things at the last minute.
 			 */
-			s2_force_noncacheable = true;
+			fault->s2_force_noncacheable = true;
 		}
-	} else if (logging_active && !write_fault) {
+	} else if (fault->logging_active && !fault->write_fault) {
 		/*
-		 * Only actually map the page as writable if this was a write
+		 * Only actually map the page as fault->writable if this was a write
 		 * fault.
 		 */
-		writable = false;
+		fault->writable = false;
 	}
 
-	if (exec_fault && s2_force_noncacheable)
+	if (fault->exec_fault && fault->s2_force_noncacheable)
 		ret = -ENOEXEC;
 
 	if (ret)
@@ -1860,21 +1892,21 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	/*
 	 * Guest performs atomic/exclusive operations on memory with unsupported
 	 * attributes (e.g. ld64b/st64b on normal memory when no FEAT_LS64WB)
-	 * and trigger the exception here. Since the memslot is valid, inject
+	 * and trigger the exception here. Since the fault->memslot is valid, inject
 	 * the fault back to the guest.
 	 */
-	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(vcpu))) {
-		kvm_inject_dabt_excl_atomic(vcpu, kvm_vcpu_get_hfar(vcpu));
+	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(fault->vcpu))) {
+		kvm_inject_dabt_excl_atomic(fault->vcpu, kvm_vcpu_get_hfar(fault->vcpu));
 		ret = 1;
 		goto out_put_page;
 	}
 
-	if (nested)
-		adjust_nested_fault_perms(nested, &prot, &writable);
+	if (fault->nested)
+		adjust_nested_fault_perms(fault->nested, &fault->prot, &fault->writable);
 
 	kvm_fault_lock(kvm);
-	pgt = vcpu->arch.hw_mmu->pgt;
-	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+	pgt = fault->vcpu->arch.hw_mmu->pgt;
+	if (mmu_invalidate_retry(kvm, fault->mmu_seq)) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -1883,78 +1915,80 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !(force_pte || s2_force_noncacheable)) {
-		if (fault_is_perm && fault_granule > PAGE_SIZE)
-			vma_pagesize = fault_granule;
+	if (fault->vma_pagesize == PAGE_SIZE &&
+	    !(fault->force_pte || fault->s2_force_noncacheable)) {
+		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE)
+			fault->vma_pagesize = fault->fault_granule;
 		else
-			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
-								   hva, &pfn,
-								   &fault_ipa);
+			fault->vma_pagesize = transparent_hugepage_adjust(kvm, fault->memslot,
+									  fault->hva, &fault->pfn,
+									  &fault->fault_ipa);
 
-		if (vma_pagesize < 0) {
-			ret = vma_pagesize;
+		if (fault->vma_pagesize < 0) {
+			ret = fault->vma_pagesize;
 			goto out_unlock;
 		}
 	}
 
-	if (!fault_is_perm && !s2_force_noncacheable && kvm_has_mte(kvm)) {
+	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
-		if (mte_allowed) {
-			sanitise_mte_tags(kvm, pfn, vma_pagesize);
+		if (fault->mte_allowed) {
+			sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
 		} else {
 			ret = -EFAULT;
 			goto out_unlock;
 		}
 	}
 
-	if (writable)
-		prot |= KVM_PGTABLE_PROT_W;
+	if (fault->writable)
+		fault->prot |= KVM_PGTABLE_PROT_W;
 
-	if (exec_fault)
-		prot |= KVM_PGTABLE_PROT_X;
+	if (fault->exec_fault)
+		fault->prot |= KVM_PGTABLE_PROT_X;
 
-	if (s2_force_noncacheable) {
-		if (vfio_allow_any_uc)
-			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+	if (fault->s2_force_noncacheable) {
+		if (fault->vfio_allow_any_uc)
+			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
-			prot |= KVM_PGTABLE_PROT_DEVICE;
+			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
 	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
-		prot |= KVM_PGTABLE_PROT_X;
+		fault->prot |= KVM_PGTABLE_PROT_X;
 	}
 
-	if (nested)
-		adjust_nested_exec_perms(kvm, nested, &prot);
+	if (fault->nested)
+		adjust_nested_exec_perms(kvm, fault->nested, &fault->prot);
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
+	 * permissions only if fault->vma_pagesize equals fault->fault_granule. Otherwise,
 	 * kvm_pgtable_stage2_map() should be called to change block size.
 	 */
-	if (fault_is_perm && vma_pagesize == fault_granule) {
+	if (fault->fault_is_perm && fault->vma_pagesize == fault->fault_granule) {
 		/*
 		 * Drop the SW bits in favour of those stored in the
 		 * PTE, which will be preserved.
 		 */
-		prot &= ~KVM_NV_GUEST_MAP_SZ;
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
+		fault->prot &= ~KVM_NV_GUEST_MAP_SZ;
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault->fault_ipa, fault->prot,
+								 flags);
 	} else {
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
-					     __pfn_to_phys(pfn), prot,
-					     memcache, flags);
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault->fault_ipa, fault->vma_pagesize,
+							 __pfn_to_phys(fault->pfn), fault->prot,
+							 memcache, flags);
 	}
 
 out_unlock:
-	kvm_release_faultin_page(kvm, page, !!ret, writable);
+	kvm_release_faultin_page(kvm, fault->page, !!ret, fault->writable);
 	kvm_fault_unlock(kvm);
 
 	/* Mark the page dirty only if the fault is handled successfully */
-	if (writable && !ret)
-		mark_page_dirty_in_slot(kvm, memslot, gfn);
+	if (fault->writable && !ret)
+		mark_page_dirty_in_slot(kvm, fault->memslot, fault->gfn);
 
 	return ret != -EAGAIN ? ret : 0;
 
 out_put_page:
-	kvm_release_page_unused(page);
+	kvm_release_page_unused(fault->page);
 	return ret;
 }
 
-- 
2.47.3

