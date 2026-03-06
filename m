Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928F93AA1BF
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805762; cv=none; b=iIyPb8Rb5YekYualvYhp85PETQEfxzR+W9upF3DKkCg87fWGu8YYZpDpiMc7VNvB+IUV9VBxx9ByzNvbHWtgRG5HfGtyXUAdBd29T5bQIbqKAxJjwKmbBGYUTgSsI4Iw+/q6eviCcbHQh11iZqGPb10jklXuVkFJO3B0bgKvDr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805762; c=relaxed/simple;
	bh=cVfsoVGktk/0FuGMBPHRVoGerRI7UR3QYIiSmg4fRd8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iQKVQpEsvt7KCs/mcyRRSQTNBeKr6lxW22gIYnO+pMVnLuc2bmh/jJ3creO5HTfR03DWyoRlGLAJhMzpYm50RRNni564iCzwAjaqkvHmgKmrtuCQJAXN786/05I2c7dBl8K9Ox4dwzfS4I9J5D5Z7DvDDMKSwbdfm7Sk4QU4f5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OMG/Y0mL; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OMG/Y0mL"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b90484c398cso820424466b.3
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805756; x=1773410556; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d0w9iw1cGZJvO5arhwgcmj7KKngdL1WNYxmO3CGQ7Gg=;
        b=OMG/Y0mLN8doq9pEei89Ch2jYNVu9rTXjCPrdvVcIEpqewUXrrgWWhFzsJXfKtLY+A
         lC3qupndXja4qas2674FN5Xb37fgDWGDbUJiQzfO9Q79EL27K/gdfiRhSfIQPrugm4Xp
         TJqIu0041R8mTq6Ya5G+opTbDByPhuLwQfHmDzs/U9GphVnyLIn1zgnjbf4rzn4c2f8d
         L5nX4/iS3LjF19hPwgyg8/bHyXEE3Eu1L57YjOKy68jNc44fto5c/+lyLgzN5gvEzKB/
         8g05Z65s4bmVFFJEHhD1LisgGop0DgiRmzwRUS9oNEI2Vh6atuscm0W9FjQe62DrPA3+
         649A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805756; x=1773410556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d0w9iw1cGZJvO5arhwgcmj7KKngdL1WNYxmO3CGQ7Gg=;
        b=b8vckrsirg4Mrr/oKUxNaRNVUlfBx/WyOE689GJokGpjSDAa8PiygwEKTksls9IF8e
         LSzES4JIqPbi0OW20VAmTdLaXSAM1Tb77qWjV0gFYW2CACsgbcGdzO5fqgvFj+chONDZ
         7SlNn/zqWSpEk0RHlIEwvMMfzvZYVd0t+1Ap6Yj9dSQTsPD10GvFtYrOxh/DoLigesum
         V8rPIWBvokKKeF/Jk+TC69xECbabDXjyiw+gMJ+Z4Af3/4ZpAjhDXjS9/bHmLHr+LUN2
         EWZst3DX5HQcmzyJ4sSDszYtiAoA6Ab9v6UYW0NlP6zTOL7F4RAUSZtJb3+PJGVewIoY
         hbVg==
X-Forwarded-Encrypted: i=1; AJvYcCVXe04e/sXNw4/SA8PdX+irbzpe1jm10baprjPy4VpzIUYEvqLDsOd4MYGD/n3YJc3yL8q62F0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjM+XoZpT6pvsQrfS3DerM4rLUKe+TB08kFo5XCa3swjDj1r9S
	QO4I83MslCI572ymFfY6i3HmaRd8jtSB/fDHt0FUxLGtZaNdtOUVm8tvi5/IdMYSYbPG5Oybf0t
	Gjg==
X-Received: from ejbci23.prod.google.com ([2002:a17:906:c357:b0:b93:5d8f:523c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:f588:b0:b87:d255:39ff
 with SMTP id a640c23a62f3a-b942dfb3019mr117949966b.32.1772805756111; Fri, 06
 Mar 2026 06:02:36 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:21 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-3-tabba@google.com>
Subject: [PATCH v1 02/13] KVM: arm64: Introduce struct kvm_s2_fault to user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

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

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 222 +++++++++++++++++++++++++------------------
 1 file changed, 128 insertions(+), 94 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f8064b2d3204..419b793c5891 100644
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
@@ -1749,43 +1779,44 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
 
 	/*
-	 * Let's check if we will get back a huge page backed by hugetlbfs, or
+	 * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
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
-	 * Check if this is non-struct page memory PFN, and cannot support
+	 * Check if this is non-struct fault->page memory PFN, and cannot support
 	 * CMOs. It could potentially be unsafe to access as cacheable.
 	 */
-	if (vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(pfn)) {
-		if (is_vma_cacheable) {
+	if (fault->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
+		if (fault->is_vma_cacheable) {
 			/*
 			 * Whilst the VMA owner expects cacheable mapping to this
 			 * PFN, hardware also has to support the FWB and CACHE DIC
@@ -1832,26 +1864,26 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 				ret = -EFAULT;
 		} else {
 			/*
-			 * If the page was identified as device early by looking at
-			 * the VMA flags, vma_pagesize is already representing the
+			 * If the fault->page was identified as device early by looking at
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
+		 * Only actually map the fault->page as fault->writable if this was a write
 		 * fault.
 		 */
-		writable = false;
+		fault->writable = false;
 	}
 
-	if (exec_fault && s2_force_noncacheable)
+	if (fault->exec_fault && fault->s2_force_noncacheable)
 		ret = -ENOEXEC;
 
 	if (ret)
@@ -1860,101 +1892,103 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
 
 	/*
-	 * If we are not forced to use page mapping, check if we are
+	 * If we are not forced to use fault->page mapping, check if we are
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
 
-	/* Mark the page dirty only if the fault is handled successfully */
-	if (writable && !ret)
-		mark_page_dirty_in_slot(kvm, memslot, gfn);
+	/* Mark the fault->page dirty only if the fault is handled successfully */
+	if (fault->writable && !ret)
+		mark_page_dirty_in_slot(kvm, fault->memslot, fault->gfn);
 
 	return ret != -EAGAIN ? ret : 0;
 
 out_put_page:
-	kvm_release_page_unused(page);
+	kvm_release_page_unused(fault->page);
 	return ret;
 }
 
-- 
2.53.0.473.g4a7958ca14-goog

