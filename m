Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A25C38BF74;
	Fri, 27 Mar 2026 11:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611388; cv=none; b=YVFLmbIjorEjOKpqkCAACS+kWczTJO6dhJKwtrQQKC2ee0ytDKMOd9p29s+QIWCaR8hSWMKrOn9wx2zInrbB9vGHuC5EkYxhFNphw1tvnW6ew7MVbVATnrU69Gyx6js9RO0O2eIubbZcCPNmJVztjUHNqG3cGjXIIL8IfTRSWpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611388; c=relaxed/simple;
	bh=AK7Y7x+qUS5uXAkXqVv+2TwFoGmbogmJRSOYgciz0TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B27WNmy7j+PoVTMPP8cFesH5cWiec0z/5EApnPStLQEfefWY9zLVdixckhuMxm9bcKnKQ+yGHtnWznA5SY6ODx/q03+Sxtn7jltsAR5ye2pcNSZdK/gK1WUH+oZtbX6KIq0vnVLMKFMNyoz/g+n085phscmdRrwdJE20duoHB8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fpWdTw6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fpWdTw6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4188C2BCB2;
	Fri, 27 Mar 2026 11:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611388;
	bh=AK7Y7x+qUS5uXAkXqVv+2TwFoGmbogmJRSOYgciz0TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpWdTw6GT/7ZjMDHFiXpu3UlQO7L+0jFduzh+aB1WrBJGon1QHHGb8XfpcKxdIT9v
	 tCcc7qim0yPKncarGGVAeLi303aADd4WzIuzRIksOmtZrwL1DDd88qm1Lx93A201Ef
	 1MEfcmZG8fICIrItK3auhqVm8KNIcSSUzsaVqBmB/Httz2RtLPHnGeFKw4UtW0L9UR
	 6wvN6QkGmkcn9xNc5QzG6ul6K0nMT66c0QumjSUu2TOpPH8klpGetWNyfhuQ5taSc+
	 tW7w+6dslTi0xw3mmieGWiIQDeA/LwxHtL9tTW/kpsseVpeTb0H8TMuzLXPfzVULl0
	 YL0hw+szs7SXg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UH-00000006K4a-44hr;
	Fri, 27 Mar 2026 11:36:26 +0000
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
Subject: [PATCH v2 16/30] KVM: arm64: Move fault context to const structure
Date: Fri, 27 Mar 2026 11:36:04 +0000
Message-ID: <20260327113618.4051534-17-maz@kernel.org>
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

In order to make it clearer what gets updated or not during fault
handling, move a set of information that losely represents the
fault context.

This gets populated early, from handle_mem_abort(), and gets passed
along as a const pointer. user_mem_abort()'s signature is majorly
improved in doing so, and kvm_s2_fault loses a bunch of fields.

gmem_abort() will get a similar treatment down the line.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 133 ++++++++++++++++++++++---------------------
 1 file changed, 69 insertions(+), 64 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 496bf5903ed3d..09e32f08028e4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1565,6 +1565,14 @@ static void adjust_nested_exec_perms(struct kvm *kvm,
 		*prot &= ~KVM_PGTABLE_PROT_PX;
 }
 
+struct kvm_s2_fault_desc {
+	struct kvm_vcpu		*vcpu;
+	phys_addr_t		fault_ipa;
+	struct kvm_s2_trans	*nested;
+	struct kvm_memory_slot	*memslot;
+	unsigned long		hva;
+};
+
 static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		      struct kvm_s2_trans *nested,
 		      struct kvm_memory_slot *memslot, bool is_perm)
@@ -1640,23 +1648,20 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	return ret != -EAGAIN ? ret : 0;
 }
 
-static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
-				     unsigned long hva,
-				     struct kvm_memory_slot *memslot,
-				     struct kvm_s2_trans *nested,
-				     bool *force_pte)
+static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
+				     struct vm_area_struct *vma, bool *force_pte)
 {
 	short vma_shift;
 
 	if (*force_pte)
 		vma_shift = PAGE_SHIFT;
 	else
-		vma_shift = get_vma_page_shift(vma, hva);
+		vma_shift = get_vma_page_shift(vma, s2fd->hva);
 
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
+		if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PUD_SIZE))
 			break;
 		fallthrough;
 #endif
@@ -1664,7 +1669,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 		vma_shift = PMD_SHIFT;
 		fallthrough;
 	case PMD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
+		if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PMD_SIZE))
 			break;
 		fallthrough;
 	case CONT_PTE_SHIFT:
@@ -1677,7 +1682,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
 	}
 
-	if (nested) {
+	if (s2fd->nested) {
 		unsigned long max_map_size;
 
 		max_map_size = *force_pte ? PAGE_SIZE : PUD_SIZE;
@@ -1687,7 +1692,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 		 * can only create a block mapping if the guest stage 2 page
 		 * table uses at least as big a mapping.
 		 */
-		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
+		max_map_size = min(kvm_s2_trans_size(s2fd->nested), max_map_size);
 
 		/*
 		 * Be careful that if the mapping size falls between
@@ -1706,11 +1711,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 }
 
 struct kvm_s2_fault {
-	struct kvm_vcpu *vcpu;
-	phys_addr_t fault_ipa;
-	struct kvm_s2_trans *nested;
-	struct kvm_memory_slot *memslot;
-	unsigned long hva;
 	bool fault_is_perm;
 
 	bool write_fault;
@@ -1732,28 +1732,28 @@ struct kvm_s2_fault {
 	vm_flags_t vm_flags;
 };
 
-static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
+static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
+				     struct kvm_s2_fault *fault)
 {
 	struct vm_area_struct *vma;
-	struct kvm *kvm = fault->vcpu->kvm;
+	struct kvm *kvm = s2fd->vcpu->kvm;
 
 	mmap_read_lock(current->mm);
-	vma = vma_lookup(current->mm, fault->hva);
+	vma = vma_lookup(current->mm, s2fd->hva);
 	if (unlikely(!vma)) {
-		kvm_err("Failed to find VMA for fault->hva 0x%lx\n", fault->hva);
+		kvm_err("Failed to find VMA for hva 0x%lx\n", s2fd->hva);
 		mmap_read_unlock(current->mm);
 		return -EFAULT;
 	}
 
-	fault->vma_pagesize = 1UL << kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot,
-							     fault->nested, &fault->force_pte);
+	fault->vma_pagesize = BIT(kvm_s2_resolve_vma_size(s2fd, vma, &fault->force_pte));
 
 	/*
 	 * Both the canonical IPA and fault IPA must be aligned to the
 	 * mapping size to ensure we find the right PFN and lay down the
 	 * mapping in the right place.
 	 */
-	fault->gfn = ALIGN_DOWN(fault->fault_ipa, fault->vma_pagesize) >> PAGE_SHIFT;
+	fault->gfn = ALIGN_DOWN(s2fd->fault_ipa, fault->vma_pagesize) >> PAGE_SHIFT;
 
 	fault->mte_allowed = kvm_vma_mte_allowed(vma);
 
@@ -1775,31 +1775,33 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 	return 0;
 }
 
-static gfn_t get_canonical_gfn(struct kvm_s2_fault *fault)
+static gfn_t get_canonical_gfn(const struct kvm_s2_fault_desc *s2fd,
+			       const struct kvm_s2_fault *fault)
 {
 	phys_addr_t ipa;
 
-	if (!fault->nested)
+	if (!s2fd->nested)
 		return fault->gfn;
 
-	ipa = kvm_s2_trans_output(fault->nested);
+	ipa = kvm_s2_trans_output(s2fd->nested);
 	return ALIGN_DOWN(ipa, fault->vma_pagesize) >> PAGE_SHIFT;
 }
 
-static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
+static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
+				struct kvm_s2_fault *fault)
 {
 	int ret;
 
-	ret = kvm_s2_fault_get_vma_info(fault);
+	ret = kvm_s2_fault_get_vma_info(s2fd, fault);
 	if (ret)
 		return ret;
 
-	fault->pfn = __kvm_faultin_pfn(fault->memslot, get_canonical_gfn(fault),
+	fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, fault),
 				       fault->write_fault ? FOLL_WRITE : 0,
 				       &fault->writable, &fault->page);
 	if (unlikely(is_error_noslot_pfn(fault->pfn))) {
 		if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
-			kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
+			kvm_send_hwpoison_signal(s2fd->hva, __ffs(fault->vma_pagesize));
 			return 0;
 		}
 		return -EFAULT;
@@ -1808,9 +1810,10 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 	return 1;
 }
 
-static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
+static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
+				     struct kvm_s2_fault *fault)
 {
-	struct kvm *kvm = fault->vcpu->kvm;
+	struct kvm *kvm = s2fd->vcpu->kvm;
 
 	/*
 	 * Check if this is non-struct page memory PFN, and cannot support
@@ -1862,13 +1865,13 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
 	 * and trigger the exception here. Since the memslot is valid, inject
 	 * the fault back to the guest.
 	 */
-	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(fault->vcpu))) {
-		kvm_inject_dabt_excl_atomic(fault->vcpu, kvm_vcpu_get_hfar(fault->vcpu));
+	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(s2fd->vcpu))) {
+		kvm_inject_dabt_excl_atomic(s2fd->vcpu, kvm_vcpu_get_hfar(s2fd->vcpu));
 		return 1;
 	}
 
-	if (fault->nested)
-		adjust_nested_fault_perms(fault->nested, &fault->prot, &fault->writable);
+	if (s2fd->nested)
+		adjust_nested_fault_perms(s2fd->nested, &fault->prot, &fault->writable);
 
 	if (fault->writable)
 		fault->prot |= KVM_PGTABLE_PROT_W;
@@ -1882,8 +1885,8 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
 	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
 		fault->prot |= KVM_PGTABLE_PROT_X;
 
-	if (fault->nested)
-		adjust_nested_exec_perms(kvm, fault->nested, &fault->prot);
+	if (s2fd->nested)
+		adjust_nested_exec_perms(kvm, s2fd->nested, &fault->prot);
 
 	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
@@ -1899,15 +1902,16 @@ static phys_addr_t get_ipa(const struct kvm_s2_fault *fault)
 	return gfn_to_gpa(fault->gfn);
 }
 
-static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
+static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
+			    struct kvm_s2_fault *fault, void *memcache)
 {
-	struct kvm *kvm = fault->vcpu->kvm;
+	struct kvm *kvm = s2fd->vcpu->kvm;
 	struct kvm_pgtable *pgt;
 	int ret;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 
 	kvm_fault_lock(kvm);
-	pgt = fault->vcpu->arch.hw_mmu->pgt;
+	pgt = s2fd->vcpu->arch.hw_mmu->pgt;
 	ret = -EAGAIN;
 	if (mmu_invalidate_retry(kvm, fault->mmu_seq))
 		goto out_unlock;
@@ -1921,8 +1925,8 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE) {
 			fault->vma_pagesize = fault->fault_granule;
 		} else {
-			fault->vma_pagesize = transparent_hugepage_adjust(kvm, fault->memslot,
-									  fault->hva, &fault->pfn,
+			fault->vma_pagesize = transparent_hugepage_adjust(kvm, s2fd->memslot,
+									  s2fd->hva, &fault->pfn,
 									  &fault->gfn);
 
 			if (fault->vma_pagesize < 0) {
@@ -1960,34 +1964,27 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (fault->writable && !ret)
-		mark_page_dirty_in_slot(kvm, fault->memslot, get_canonical_gfn(fault));
+		mark_page_dirty_in_slot(kvm, s2fd->memslot, get_canonical_gfn(s2fd, fault));
 
 	if (ret != -EAGAIN)
 		return ret;
 	return 0;
 }
 
-static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-			  struct kvm_s2_trans *nested,
-			  struct kvm_memory_slot *memslot, unsigned long hva,
-			  bool fault_is_perm)
+static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
-	bool write_fault = kvm_is_write_fault(vcpu);
-	bool logging_active = memslot_is_logging(memslot);
+	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
+	bool write_fault = kvm_is_write_fault(s2fd->vcpu);
+	bool logging_active = memslot_is_logging(s2fd->memslot);
 	struct kvm_s2_fault fault = {
-		.vcpu = vcpu,
-		.fault_ipa = fault_ipa,
-		.nested = nested,
-		.memslot = memslot,
-		.hva = hva,
-		.fault_is_perm = fault_is_perm,
+		.fault_is_perm = perm_fault,
 		.logging_active = logging_active,
 		.force_pte = logging_active,
 		.prot = KVM_PGTABLE_PROT_R,
-		.fault_granule = fault_is_perm ? kvm_vcpu_trap_get_perm_fault_granule(vcpu) : 0,
+		.fault_granule = perm_fault ? kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0,
 		.write_fault = write_fault,
-		.exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu),
-		.topup_memcache = !fault_is_perm || (logging_active && write_fault),
+		.exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu),
+		.topup_memcache = !perm_fault || (logging_active && write_fault),
 	};
 	void *memcache;
 	int ret;
@@ -2000,7 +1997,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
-	ret = prepare_mmu_memcache(vcpu, fault.topup_memcache, &memcache);
+	ret = prepare_mmu_memcache(s2fd->vcpu, fault.topup_memcache, &memcache);
 	if (ret)
 		return ret;
 
@@ -2008,17 +2005,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * Let's check if we will get back a huge page backed by hugetlbfs, or
 	 * get block mapping for device MMIO region.
 	 */
-	ret = kvm_s2_fault_pin_pfn(&fault);
+	ret = kvm_s2_fault_pin_pfn(s2fd, &fault);
 	if (ret != 1)
 		return ret;
 
-	ret = kvm_s2_fault_compute_prot(&fault);
+	ret = kvm_s2_fault_compute_prot(s2fd, &fault);
 	if (ret) {
 		kvm_release_page_unused(fault.page);
 		return ret;
 	}
 
-	return kvm_s2_fault_map(&fault, memcache);
+	return kvm_s2_fault_map(s2fd, &fault, memcache);
 }
 
 /* Resolve the access fault by making the page young again. */
@@ -2284,12 +2281,20 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
 			!write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
 
+	const struct kvm_s2_fault_desc s2fd = {
+		.vcpu		= vcpu,
+		.fault_ipa	= fault_ipa,
+		.nested		= nested,
+		.memslot	= memslot,
+		.hva		= hva,
+	};
+
 	if (kvm_slot_has_gmem(memslot))
 		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
 				 esr_fsc_is_permission_fault(esr));
 	else
-		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
-				     esr_fsc_is_permission_fault(esr));
+		ret = user_mem_abort(&s2fd);
+
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.47.3

