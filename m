Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E477733C19E;
	Wed, 13 May 2026 13:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678460; cv=none; b=RUYDgMZidlFa4UGDXXi1g6Q4+gVzVu48f59cyenrJOIYv5h3pzFAIN7N5vQg/9YMn2QoN6fm+uTpPIolPTy0rTOKOoVp8rCmnxQPMyse0e/O/65gt72i9h1kaX6Fzj4BIO3tBRtO3PyEpMtk2ILq9bdMtCLG4PlGwuQFSXDeqfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678460; c=relaxed/simple;
	bh=qB337CMfrS4Z5ymus5yPj+0S0LY9IGfq8yCUStHMZbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKeEUKanpX2twz8r15lnYSC+yTtDIklj21XX5ldma/z4GK9GKydW7Yu8H2bK03cvOGVhs/Hpiu360w0YmJx8ogRVtogT/iKx6eXMUDfuz/iQLoFGVd+f6hq4z+1SCC2m2ATOiLNFcr4afAmTB8bgl56AVwkn/w7IZCE/s03COgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=C2SxhH2V; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="C2SxhH2V"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 122DE302D;
	Wed, 13 May 2026 06:20:52 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 773593F836;
	Wed, 13 May 2026 06:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678457; bh=qB337CMfrS4Z5ymus5yPj+0S0LY9IGfq8yCUStHMZbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2SxhH2VYDb8vF6wXMRUD3Ia7P223KJLfgDk2ns/3FDbWBXyD/UI1ggWHxhR317V3
	 Rkwk7sPaygjp5uJ+tZd+Nd/9o+suBaErPcvkRLi3vkrqyLsx3rqGD1+hU0KgICGpRY
	 pSr005L9Pl83m7rnixub+wNNnXXrMXVDPDLJWfOE=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo.Pieralisi2@arm.com
Subject: [PATCH v14 29/44] arm64: RMI: Runtime faulting of memory
Date: Wed, 13 May 2026 14:17:37 +0100
Message-ID: <20260513131757.116630-30-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513131757.116630-1-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At runtime if the realm guest accesses memory which hasn't yet been
mapped then KVM needs to either populate the region or fault the guest.

For memory in the lower (protected) region of IPA a fresh page is
provided to the RMM which will zero the contents. For memory in the
upper (shared) region of IPA, the memory from the memslot is mapped
into the realm VM non secure.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v13:
 * Numerous changes due to rebasing.
 * Fix addr_range_desc() to encode the correct block size.
Changes since v12:
 * Switch to RMM v2.0 range based APIs.
Changes since v11:
 * Adapt to upstream changes.
Changes since v10:
 * RME->RMI renaming.
 * Adapt to upstream gmem changes.
Changes since v9:
 * Fix call to kvm_stage2_unmap_range() in kvm_free_stage2_pgd() to set
   may_block to avoid stall warnings.
 * Minor coding style fixes.
Changes since v8:
 * Propagate the may_block flag.
 * Minor comments and coding style changes.
Changes since v7:
 * Remove redundant WARN_ONs for realm_create_rtt_levels() - it will
   internally WARN when necessary.
Changes since v6:
 * Handle PAGE_SIZE being larger than RMM granule size.
 * Some minor renaming following review comments.
Changes since v5:
 * Reduce use of struct page in preparation for supporting the RMM
   having a different page size to the host.
 * Handle a race when delegating a page where another CPU has faulted on
   a the same page (and already delegated the physical page) but not yet
   mapped it. In this case simply return to the guest to either use the
   mapping from the other CPU (or refault if the race is lost).
 * The changes to populate_par_region() are moved into the previous
   patch where they belong.
Changes since v4:
 * Code cleanup following review feedback.
 * Drop the PTE_SHARED bit when creating unprotected page table entries.
   This is now set by the RMM and the host has no control of it and the
   spec requires the bit to be set to zero.
Changes since v2:
 * Avoid leaking memory if failing to map it in the realm.
 * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
 * Adapt to changes in previous patches.
---
 arch/arm64/include/asm/kvm_emulate.h |   8 ++
 arch/arm64/include/asm/kvm_rmi.h     |  12 ++
 arch/arm64/kvm/mmu.c                 | 128 ++++++++++++++++----
 arch/arm64/kvm/rmi.c                 | 173 +++++++++++++++++++++++++++
 4 files changed, 301 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 2e69fe494716..8b6f9d26b5d8 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -712,6 +712,14 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
 	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
 }
 
+static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t ipa)
+{
+	if (!kvm_is_realm(kvm))
+		return ipa;
+
+	return ipa & ~BIT(kvm->arch.realm.ia_bits - 1);
+}
+
 static inline bool vcpu_is_rec(const struct kvm_vcpu *vcpu)
 {
 	return kvm_is_realm(vcpu->kvm);
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index a2b6bc412a22..b65cfec10dee 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -6,6 +6,7 @@
 #ifndef __ASM_KVM_RMI_H
 #define __ASM_KVM_RMI_H
 
+#include <asm/kvm_pgtable.h>
 #include <asm/rmi_smc.h>
 
 /**
@@ -97,6 +98,17 @@ void kvm_realm_unmap_range(struct kvm *kvm,
 			   unsigned long size,
 			   bool unmap_private,
 			   bool may_block);
+int realm_map_protected(struct kvm *kvm,
+			unsigned long base_ipa,
+			kvm_pfn_t pfn,
+			unsigned long size,
+			struct kvm_mmu_memory_cache *memcache);
+int realm_map_non_secure(struct realm *realm,
+			 unsigned long ipa,
+			 kvm_pfn_t pfn,
+			 unsigned long size,
+			 enum kvm_pgtable_prot prot,
+			 struct kvm_mmu_memory_cache *memcache);
 
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ac2a0f0106b0..776ffe56d17e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -334,8 +334,15 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
-	WARN_ON(stage2_apply_range(mmu, start, end, KVM_PGT_FN(kvm_pgtable_stage2_unmap),
-				   may_block));
+
+	if (kvm_is_realm(kvm)) {
+		kvm_realm_unmap_range(kvm, start, size, !only_shared,
+				      may_block);
+	} else {
+		WARN_ON(stage2_apply_range(mmu, start, end,
+					   KVM_PGT_FN(kvm_pgtable_stage2_unmap),
+					   may_block));
+	}
 }
 
 void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
@@ -358,7 +365,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
 	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
 
-	kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
+	if (kvm_is_realm(kvm))
+		kvm_realm_unmap_range(kvm, addr, end - addr, false, true);
+	else
+		kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
 }
 
 /**
@@ -1103,6 +1113,10 @@ void stage2_unmap_vm(struct kvm *kvm)
 	struct kvm_memory_slot *memslot;
 	int idx, bkt;
 
+	/* For realms this is handled by the RMM so nothing to do here */
+	if (kvm_is_realm(kvm))
+		return;
+
 	idx = srcu_read_lock(&kvm->srcu);
 	mmap_read_lock(current->mm);
 	write_lock(&kvm->mmu_lock);
@@ -1528,6 +1542,29 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
+			 kvm_pfn_t pfn, unsigned long map_size,
+			 enum kvm_pgtable_prot prot,
+			 struct kvm_mmu_memory_cache *memcache)
+{
+	struct realm *realm = &kvm->arch.realm;
+
+	/*
+	 * Write permission is required for now even though it's possible to
+	 * map unprotected pages (granules) as read-only. It's impossible to
+	 * map protected pages (granules) as read-only.
+	 */
+	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
+		return -EFAULT;
+
+	ipa = ALIGN_DOWN(ipa, PAGE_SIZE);
+	if (!kvm_realm_is_private_address(realm, ipa))
+		return realm_map_non_secure(realm, ipa, pfn, map_size, prot,
+					    memcache);
+
+	return realm_map_protected(kvm, ipa, pfn, map_size, memcache);
+}
+
 static bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
 {
 	switch (FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(vma->vm_page_prot))) {
@@ -1604,27 +1641,52 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	bool write_fault, exec_fault;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
-	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
+	struct kvm_vcpu *vcpu = s2fd->vcpu;
+	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	gpa_t gpa = kvm_gpa_from_fault(vcpu->kvm, s2fd->fault_ipa);
 	unsigned long mmu_seq;
 	struct page *page;
-	struct kvm *kvm = s2fd->vcpu->kvm;
+	struct kvm *kvm = vcpu->kvm;
 	void *memcache;
 	kvm_pfn_t pfn;
 	gfn_t gfn;
 	int ret;
 
-	memcache = get_mmu_memcache(s2fd->vcpu);
-	ret = topup_mmu_memcache(s2fd->vcpu, memcache);
+	if (kvm_is_realm(vcpu->kvm)) {
+		/* check for memory attribute mismatch */
+		bool is_priv_gfn = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
+		/*
+		 * For Realms, the shared address is an alias of the private
+		 * PA with the top bit set. Thus if the fault address matches
+		 * the GPA then it is the private alias.
+		 */
+		bool is_priv_fault = (gpa == s2fd->fault_ipa);
+
+		if (is_priv_gfn != is_priv_fault) {
+			kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
+						      kvm_is_write_fault(vcpu),
+						      false,
+						      is_priv_fault);
+			/*
+			 * KVM_EXIT_MEMORY_FAULT requires an return code of
+			 * -EFAULT, see the API documentation
+			 */
+			return -EFAULT;
+		}
+	}
+
+	memcache = get_mmu_memcache(vcpu);
+	ret = topup_mmu_memcache(vcpu, memcache);
 	if (ret)
 		return ret;
 
 	if (s2fd->nested)
 		gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
 	else
-		gfn = s2fd->fault_ipa >> PAGE_SHIFT;
+		gfn = gpa >> PAGE_SHIFT;
 
-	write_fault = kvm_is_write_fault(s2fd->vcpu);
-	exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu);
+	write_fault = kvm_is_write_fault(vcpu);
+	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
 
 	VM_WARN_ON_ONCE(write_fault && exec_fault);
 
@@ -1634,7 +1696,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 
 	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
 	if (ret) {
-		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
+		kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
 					      write_fault, exec_fault, false);
 		return ret;
 	}
@@ -1654,14 +1716,20 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	kvm_fault_lock(kvm);
 	if (mmu_invalidate_retry(kvm, mmu_seq)) {
 		ret = -EAGAIN;
-		goto out_unlock;
+		goto out_release_page;
+	}
+
+	if (kvm_is_realm(kvm)) {
+		ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn,
+				    PAGE_SIZE, KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W, memcache);
+		goto out_release_page;
 	}
 
 	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
 						 __pfn_to_phys(pfn), prot,
 						 memcache, flags);
 
-out_unlock:
+out_release_page:
 	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
 	kvm_fault_unlock(kvm);
 
@@ -1847,7 +1915,7 @@ static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
 	 * mapping size to ensure we find the right PFN and lay down the
 	 * mapping in the right place.
 	 */
-	s2vi->gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
+	s2vi->gfn = kvm_gpa_from_fault(kvm, ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize)) >> PAGE_SHIFT;
 
 	s2vi->mte_allowed = kvm_vma_mte_allowed(vma);
 
@@ -2056,6 +2124,9 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn),
 								 prot, flags);
+	} else if (kvm_is_realm(kvm)) {
+		ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
+				    prot, memcache);
 	} else {
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
 							 __pfn_to_phys(pfn), prot,
@@ -2214,6 +2285,13 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static bool shared_ipa_fault(struct kvm *kvm, phys_addr_t fault_ipa)
+{
+	gpa_t gpa = kvm_gpa_from_fault(kvm, fault_ipa);
+
+	return (gpa != fault_ipa);
+}
+
 /**
  * kvm_handle_guest_abort - handles all 2nd stage aborts
  * @vcpu:	the VCPU pointer
@@ -2324,8 +2402,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		nested = &nested_trans;
 	}
 
-	gfn = ipa >> PAGE_SHIFT;
+	gfn = kvm_gpa_from_fault(vcpu->kvm, ipa) >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
@@ -2368,7 +2447,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * of the page size.
 		 */
 		ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
-		ret = io_mem_abort(vcpu, ipa);
+		ret = io_mem_abort(vcpu, kvm_gpa_from_fault(vcpu->kvm, ipa));
 		goto out_unlock;
 	}
 
@@ -2396,7 +2475,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 				!write_fault &&
 				!kvm_vcpu_trap_is_exec_fault(vcpu));
 
-		if (kvm_slot_has_gmem(memslot))
+		if (kvm_slot_has_gmem(memslot) && !shared_ipa_fault(vcpu->kvm, fault_ipa))
 			ret = gmem_abort(&s2fd);
 		else
 			ret = user_mem_abort(&s2fd);
@@ -2433,6 +2512,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
 		return false;
 
+	/* We don't support aging for Realms */
+	if (kvm_is_realm(kvm))
+		return true;
+
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, true);
@@ -2449,6 +2532,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
 		return false;
 
+	/* We don't support aging for Realms */
+	if (kvm_is_realm(kvm))
+		return true;
+
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, false);
@@ -2628,10 +2715,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		return -EFAULT;
 
 	/*
-	 * Only support guest_memfd backed memslots with mappable memory, since
-	 * there aren't any CoCo VMs that support only private memory on arm64.
+	 * Only support guest_memfd backed memslots with mappable memory,
+	 * unless the guest is a CCA realm guest.
 	 */
-	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
+	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new) &&
+	    !kvm_is_realm(kvm))
 		return -EINVAL;
 
 	hva = new->userspace_addr;
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index cae29fd3353c..761b38a4071c 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -597,6 +597,179 @@ static int realm_data_map_init(struct kvm *kvm, unsigned long ipa,
 	return ret;
 }
 
+static unsigned long addr_range_desc(unsigned long phys, unsigned long size)
+{
+	unsigned long out = 0;
+
+	switch (size) {
+	case P4D_SIZE:
+		out = 3 | (1 << 2);
+		break;
+	case PUD_SIZE:
+		out = 2 | (1 << 2);
+		break;
+	case PMD_SIZE:
+		out = 1 | (1 << 2);
+		break;
+	case PAGE_SIZE:
+		out = 0 | (1 << 2);
+		break;
+	default:
+		/*
+		 * Only support mapping at the page level granulatity when
+		 * it's an unusual length. This should get us back onto a larger
+		 * block size for the subsequent mappings.
+		 */
+		out = 0 | ((MIN(size >> PAGE_SHIFT, PTRS_PER_PTE - 1)) << 2);
+		break;
+	}
+
+	WARN_ON(phys & ~PAGE_MASK);
+
+	out |= phys & PAGE_MASK;
+
+	return out;
+}
+
+int realm_map_protected(struct kvm *kvm,
+			unsigned long ipa,
+			kvm_pfn_t pfn,
+			unsigned long map_size,
+			struct kvm_mmu_memory_cache *memcache)
+{
+	struct realm *realm = &kvm->arch.realm;
+	phys_addr_t phys = __pfn_to_phys(pfn);
+	phys_addr_t base_phys = phys;
+	phys_addr_t rd = virt_to_phys(realm->rd);
+	unsigned long base_ipa = ipa;
+	unsigned long ipa_top = ipa + map_size;
+	int ret = 0;
+
+	if (WARN_ON(!IS_ALIGNED(map_size, PAGE_SIZE) ||
+		    !IS_ALIGNED(ipa, map_size)))
+		return -EINVAL;
+
+	if (rmi_delegate_range(phys, map_size)) {
+		/*
+		 * It's likely we raced with another VCPU on the same
+		 * fault. Assume the other VCPU has handled the fault
+		 * and return to the guest.
+		 */
+		return 0;
+	}
+
+	while (ipa < ipa_top) {
+		unsigned long flags = RMI_ADDR_TYPE_SINGLE;
+		unsigned long range_desc = addr_range_desc(phys, ipa_top - ipa);
+		unsigned long out_top;
+
+		ret = rmi_rtt_data_map(rd, ipa, ipa_top, flags, range_desc,
+				       &out_top);
+
+		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+			/* Create missing RTTs and retry */
+			int level = RMI_RETURN_INDEX(ret);
+
+			WARN_ON(level == KVM_PGTABLE_LAST_LEVEL);
+			ret = realm_create_rtt_levels(realm, ipa, level,
+						      KVM_PGTABLE_LAST_LEVEL,
+						      memcache);
+			if (ret)
+				goto err_undelegate;
+
+			ret = rmi_rtt_data_map(rd, ipa, ipa_top, flags,
+					       range_desc, &out_top);
+		}
+
+		if (WARN_ON(ret))
+			goto err_undelegate;
+
+		phys += out_top - ipa;
+		ipa = out_top;
+	}
+
+	return 0;
+
+err_undelegate:
+	realm_unmap_private_range(kvm, base_ipa, ipa, true);
+	if (WARN_ON(rmi_undelegate_range(base_phys, map_size))) {
+		/* Page can't be returned to NS world so is lost */
+		get_page(phys_to_page(base_phys));
+	}
+	return -ENXIO;
+}
+
+int realm_map_non_secure(struct realm *realm,
+			 unsigned long ipa,
+			 kvm_pfn_t pfn,
+			 unsigned long size,
+			 enum kvm_pgtable_prot prot,
+			 struct kvm_mmu_memory_cache *memcache)
+{
+	unsigned long attr, flags = 0;
+	phys_addr_t rd = virt_to_phys(realm->rd);
+	phys_addr_t phys = __pfn_to_phys(pfn);
+	unsigned long ipa_top = ipa + size;
+	int ret;
+
+	if (WARN_ON(!IS_ALIGNED(size, PAGE_SIZE) ||
+		    !IS_ALIGNED(ipa, size)))
+		return -EINVAL;
+
+	switch (prot & (KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC)) {
+	case KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC:
+		return -EINVAL;
+	case KVM_PGTABLE_PROT_DEVICE:
+		attr = MT_S2_FWB_DEVICE_nGnRE;
+		break;
+	case KVM_PGTABLE_PROT_NORMAL_NC:
+		attr = MT_S2_FWB_NORMAL_NC;
+		break;
+	default:
+		attr = MT_S2_FWB_NORMAL;
+	}
+
+	flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_MEMATTR, attr);
+
+	if (prot & KVM_PGTABLE_PROT_R)
+		flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_S2AP, RMI_S2AP_DIRECT_READ);
+	if (prot & KVM_PGTABLE_PROT_W)
+		flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_S2AP, RMI_S2AP_DIRECT_WRITE);
+
+	flags |= RMI_ADDR_TYPE_SINGLE;
+
+	while (ipa < ipa_top) {
+		unsigned long range_desc = addr_range_desc(phys, ipa_top - ipa);
+		unsigned long out_top;
+
+		ret = rmi_rtt_unprot_map(rd, ipa, ipa_top, flags, range_desc,
+					 &out_top);
+
+		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+			/* Create missing RTTs and retry */
+			int level = RMI_RETURN_INDEX(ret);
+
+			WARN_ON(level == KVM_PGTABLE_LAST_LEVEL);
+			ret = realm_create_rtt_levels(realm, ipa, level,
+						      KVM_PGTABLE_LAST_LEVEL,
+						      memcache);
+			if (ret)
+				return ret;
+
+			ret = rmi_rtt_unprot_map(rd, ipa, ipa_top, flags,
+						 range_desc, &out_top);
+		}
+
+		if (WARN_ON(ret))
+			return ret;
+
+		phys += out_top - ipa;
+		ipa = out_top;
+	}
+
+	return 0;
+}
+
 static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 			      struct page *src_page, void *opaque)
 {
-- 
2.43.0

