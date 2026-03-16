Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6D433B6F8
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683703; cv=none; b=fqSXKphMuekQ9GKIwrzJyYC5dbr6zIk+fBZcmTuAL3IRr81FJN2D8ExBYE6U+/niZi38EtaEF/Tsf2+IwJdOQaHTC+H9IRD5bhm037RpMhTE5sg5/dslWNEzpYHSthKdB83Xvi2WnYt3Yt5fx14KNe4DAH+hbUmfQKnu8bEXNuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683703; c=relaxed/simple;
	bh=BPAP1aIW/OQWedUkzTy1+lO6MY6hiCXaeEkUCDoeDMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2D/kBjc1uPPXUM+kmhi3rnJudsdGLW/n6LUB+u9FQLMXq2z6r+SC0iYH8MfOk0tA7qLS97Q8JfH0y5h4c5nOU0lINBT7wZ+yH6wcx5uNA06IKrASFrgGF9QgjTrwzvxoth9hp/m3lFzMjBD3DR1UTN5abNVYEwayOeqkXqOtr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q6G7+fHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q6G7+fHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F672C2BC87;
	Mon, 16 Mar 2026 17:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683703;
	bh=BPAP1aIW/OQWedUkzTy1+lO6MY6hiCXaeEkUCDoeDMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6G7+fHgw7Rd1noPIH+LY3NDV8vq4zlQlGPcuUFboScJvKJDxtyDms80tPZ+T9Bi7
	 KV6pqGaX2+ePsdxf7aDkLFu4WOZ77q3maCG7kddSQECLBPae93p14VIieb87XQ1gtA
	 w09KVGlm22jU8acBhMewMu5A6nD0lb8gq+akYKwkpWreRmLnpBzKYeIErTLtMrGp/7
	 wE35aPyMkod+1ccbyrna5n9rg2jPGhLt4x2uMXk9nQkRbSkFeD0kdtV5e9cdQt5KJg
	 rPf2F3t0wdYeGceCdmMJs5CAc2l2dZyRtbv6GyZwVUNpTQHkLgcD/Pn5z5buwIbm4b
	 tFRgFQthRhSwQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9d-00000002XDx-1PWM;
	Mon, 16 Mar 2026 17:55:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH 09/17] KVM: arm64: Move VMA-related information to kvm_s2_fault_vma_info
Date: Mon, 16 Mar 2026 17:54:42 +0000
Message-ID: <20260316175451.1866175-10-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316175451.1866175-1-maz@kernel.org>
References: <20260316175451.1866175-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Mecanically extract a bunch of VMA-related fields from kvm_s2_fault
and move them to a new kvm_s2_fault_vma_info structure.

This is not much, but it already allows us to define which functions
can update this structure, and which ones are pure consumers of the
data. Those in the latter camp are updated to take a const pointer
to that structure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 113 +++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 52 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index abe239752c696..a5b0dd41560f6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1710,20 +1710,23 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 	return vma_shift;
 }
 
+struct kvm_s2_fault_vma_info {
+	unsigned long	mmu_seq;
+	long		vma_pagesize;
+	vm_flags_t	vm_flags;
+	gfn_t		gfn;
+	bool		mte_allowed;
+	bool		is_vma_cacheable;
+};
+
 struct kvm_s2_fault {
 	bool writable;
-	bool mte_allowed;
-	bool is_vma_cacheable;
 	bool s2_force_noncacheable;
-	unsigned long mmu_seq;
-	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active;
 	bool force_pte;
-	long vma_pagesize;
 	enum kvm_pgtable_prot prot;
 	struct page *page;
-	vm_flags_t vm_flags;
 };
 
 static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
@@ -1732,7 +1735,8 @@ static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
 }
 
 static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
-				     struct kvm_s2_fault *fault)
+				     struct kvm_s2_fault *fault,
+				     struct kvm_s2_fault_vma_info *s2vi)
 {
 	struct vm_area_struct *vma;
 	struct kvm *kvm = s2fd->vcpu->kvm;
@@ -1745,20 +1749,20 @@ static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
 		return -EFAULT;
 	}
 
-	fault->vma_pagesize = BIT(kvm_s2_resolve_vma_size(s2fd, vma, &fault->force_pte));
+	s2vi->vma_pagesize = BIT(kvm_s2_resolve_vma_size(s2fd, vma, &fault->force_pte));
 
 	/*
 	 * Both the canonical IPA and fault IPA must be aligned to the
 	 * mapping size to ensure we find the right PFN and lay down the
 	 * mapping in the right place.
 	 */
-	fault->gfn = ALIGN_DOWN(s2fd->fault_ipa, fault->vma_pagesize) >> PAGE_SHIFT;
+	s2vi->gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
 
-	fault->mte_allowed = kvm_vma_mte_allowed(vma);
+	s2vi->mte_allowed = kvm_vma_mte_allowed(vma);
 
-	fault->vm_flags = vma->vm_flags;
+	s2vi->vm_flags = vma->vm_flags;
 
-	fault->is_vma_cacheable = kvm_vma_is_cacheable(vma);
+	s2vi->is_vma_cacheable = kvm_vma_is_cacheable(vma);
 
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
@@ -1768,39 +1772,40 @@ static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
 	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
 	 * with the smp_wmb() in kvm_mmu_invalidate_end().
 	 */
-	fault->mmu_seq = kvm->mmu_invalidate_seq;
+	s2vi->mmu_seq = kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
 	return 0;
 }
 
 static gfn_t get_canonical_gfn(const struct kvm_s2_fault_desc *s2fd,
-			       const struct kvm_s2_fault *fault)
+			       const struct kvm_s2_fault_vma_info *s2vi)
 {
 	phys_addr_t ipa;
 
 	if (!s2fd->nested)
-		return fault->gfn;
+		return s2vi->gfn;
 
 	ipa = kvm_s2_trans_output(s2fd->nested);
-	return ALIGN_DOWN(ipa, fault->vma_pagesize) >> PAGE_SHIFT;
+	return ALIGN_DOWN(ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
 }
 
 static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
-				struct kvm_s2_fault *fault)
+				struct kvm_s2_fault *fault,
+				struct kvm_s2_fault_vma_info *s2vi)
 {
 	int ret;
 
-	ret = kvm_s2_fault_get_vma_info(s2fd, fault);
+	ret = kvm_s2_fault_get_vma_info(s2fd, fault, s2vi);
 	if (ret)
 		return ret;
 
-	fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, fault),
+	fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, s2vi),
 				       kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
 				       &fault->writable, &fault->page);
 	if (unlikely(is_error_noslot_pfn(fault->pfn))) {
 		if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
-			kvm_send_hwpoison_signal(s2fd->hva, __ffs(fault->vma_pagesize));
+			kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi->vma_pagesize));
 			return 0;
 		}
 		return -EFAULT;
@@ -1810,7 +1815,8 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
 }
 
 static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
-				     struct kvm_s2_fault *fault)
+				     struct kvm_s2_fault *fault,
+				     const struct kvm_s2_fault_vma_info *s2vi)
 {
 	struct kvm *kvm = s2fd->vcpu->kvm;
 
@@ -1818,8 +1824,8 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 	 * Check if this is non-struct page memory PFN, and cannot support
 	 * CMOs. It could potentially be unsafe to access as cacheable.
 	 */
-	if (fault->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
-		if (fault->is_vma_cacheable) {
+	if (s2vi->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
+		if (s2vi->is_vma_cacheable) {
 			/*
 			 * Whilst the VMA owner expects cacheable mapping to this
 			 * PFN, hardware also has to support the FWB and CACHE DIC
@@ -1879,7 +1885,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 		fault->prot |= KVM_PGTABLE_PROT_X;
 
 	if (fault->s2_force_noncacheable)
-		fault->prot |= (fault->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
+		fault->prot |= (s2vi->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
 			       KVM_PGTABLE_PROT_NORMAL_NC : KVM_PGTABLE_PROT_DEVICE;
 	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
 		fault->prot |= KVM_PGTABLE_PROT_X;
@@ -1889,74 +1895,73 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 
 	if (!kvm_s2_fault_is_perm(s2fd) && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
-		if (!fault->mte_allowed)
+		if (!s2vi->mte_allowed)
 			return -EFAULT;
 	}
 
 	return 0;
 }
 
-static phys_addr_t get_ipa(const struct kvm_s2_fault *fault)
-{
-	return gfn_to_gpa(fault->gfn);
-}
-
 static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
-			    struct kvm_s2_fault *fault, void *memcache)
+			    struct kvm_s2_fault *fault,
+			    const struct kvm_s2_fault_vma_info *s2vi, void *memcache)
 {
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	struct kvm_pgtable *pgt;
 	long perm_fault_granule;
+	long mapping_size;
+	gfn_t gfn;
 	int ret;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 
 	kvm_fault_lock(kvm);
 	pgt = s2fd->vcpu->arch.hw_mmu->pgt;
 	ret = -EAGAIN;
-	if (mmu_invalidate_retry(kvm, fault->mmu_seq))
+	if (mmu_invalidate_retry(kvm, s2vi->mmu_seq))
 		goto out_unlock;
 
 	perm_fault_granule = (kvm_s2_fault_is_perm(s2fd) ?
 			      kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0);
+	mapping_size = s2vi->vma_pagesize;
+	gfn = s2vi->gfn;
 
 	/*
 	 * If we are not forced to use fault->page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (fault->vma_pagesize == PAGE_SIZE &&
+	if (mapping_size == PAGE_SIZE &&
 	    !(fault->force_pte || fault->s2_force_noncacheable)) {
 		if (perm_fault_granule > PAGE_SIZE) {
-			fault->vma_pagesize = perm_fault_granule;
+			mapping_size = perm_fault_granule;
 		} else {
-			fault->vma_pagesize = transparent_hugepage_adjust(kvm, s2fd->memslot,
-									  s2fd->hva, &fault->pfn,
-									  &fault->gfn);
-
-			if (fault->vma_pagesize < 0) {
-				ret = fault->vma_pagesize;
+			mapping_size = transparent_hugepage_adjust(kvm, s2fd->memslot,
+								   s2fd->hva, &fault->pfn,
+								   &gfn);
+			if (mapping_size < 0) {
+				ret = mapping_size;
 				goto out_unlock;
 			}
 		}
 	}
 
 	if (!perm_fault_granule && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
-		sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
+		sanitise_mte_tags(kvm, fault->pfn, mapping_size);
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-	 * permissions only if vma_pagesize equals perm_fault_granule. Otherwise,
+	 * permissions only if mapping_size equals perm_fault_granule. Otherwise,
 	 * kvm_pgtable_stage2_map() should be called to change block size.
 	 */
-	if (fault->vma_pagesize == perm_fault_granule) {
+	if (mapping_size == perm_fault_granule) {
 		/*
 		 * Drop the SW bits in favour of those stored in the
 		 * PTE, which will be preserved.
 		 */
 		fault->prot &= ~KVM_NV_GUEST_MAP_SZ;
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, get_ipa(fault),
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn),
 								 fault->prot, flags);
 	} else {
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, get_ipa(fault), fault->vma_pagesize,
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
 							 __pfn_to_phys(fault->pfn), fault->prot,
 							 memcache, flags);
 	}
@@ -1965,9 +1970,12 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	kvm_release_faultin_page(kvm, fault->page, !!ret, fault->writable);
 	kvm_fault_unlock(kvm);
 
-	/* Mark the fault->page dirty only if the fault is handled successfully */
-	if (fault->writable && !ret)
-		mark_page_dirty_in_slot(kvm, s2fd->memslot, get_canonical_gfn(s2fd, fault));
+	/* Mark the page dirty only if the fault is handled successfully */
+	if (fault->writable && !ret) {
+		phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
+		ipa &= ~(mapping_size - 1);
+		mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
+	}
 
 	if (ret != -EAGAIN)
 		return ret;
@@ -1978,6 +1986,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
 	bool logging_active = memslot_is_logging(s2fd->memslot);
+	struct kvm_s2_fault_vma_info s2vi = {};
 	struct kvm_s2_fault fault = {
 		.logging_active = logging_active,
 		.force_pte = logging_active,
@@ -2002,17 +2011,17 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	 * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
 	 * get block mapping for device MMIO region.
 	 */
-	ret = kvm_s2_fault_pin_pfn(s2fd, &fault);
+	ret = kvm_s2_fault_pin_pfn(s2fd, &fault, &s2vi);
 	if (ret != 1)
 		return ret;
 
-	ret = kvm_s2_fault_compute_prot(s2fd, &fault);
+	ret = kvm_s2_fault_compute_prot(s2fd, &fault, &s2vi);
 	if (ret) {
 		kvm_release_page_unused(fault.page);
 		return ret;
 	}
 
-	return kvm_s2_fault_map(s2fd, &fault, memcache);
+	return kvm_s2_fault_map(s2fd, &fault, &s2vi, memcache);
 }
 
 /* Resolve the access fault by making the page young again. */
-- 
2.47.3

