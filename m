Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E9A215F42
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136542; cv=none; b=EcFdJYMVUiKGoHcXQ1RrLrwnXd/1o8WsPK4zwZJAc6WfXDSPdKH2Je2Ri3l2leCclrT7tfh8X2vhy8SWJfRLO94vguY71MkyFq4E/ftFbWqgR11BecPULoE2UMquOI6aylMZeZKH5oKRiR9WZIkKmPu2nmlrBCpT/vm247Zu1EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136542; c=relaxed/simple;
	bh=Z9x2KEn1wfFDQs8l3a7k9iwXMba5lqwj5JeziiK9xKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1bpIHvMGfvLl1g0GLsPS8ppBcYNbftZK3dAm9g/ivL/bd+P9VrWczK9UDbXD/zZjhfFkyKoDQlT9LQNuvyY2aWctvOMWny4ng2Zog/Wyhp8hgicrbRFXt6C3DF/x1WRXxMfF3wRCiv/E9+6hR3Rg2dw0SkmEXHgL0rynw8Bp6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 691AB1C00;
	Fri, 14 Nov 2025 08:08:52 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE1E53F5A1;
	Fri, 14 Nov 2025 08:08:57 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 34/35] KVM: arm64: Add hugetlb support for SPE
Date: Fri, 14 Nov 2025 16:07:15 +0000
Message-ID: <20251114160717.163230-35-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hugetlb pages are different from transparent huge pages, as they cannot be
split by GUP with the FOLL_SPLIT_PMD flag.

Mapping hugetlb pages at stage 2 with a page mapping would be a mistake:
CPU stage 2 faults will make KVM map the entire hugetlb page with a block
mapping at stage 2. This process requires a break-before-make sequence, and
the SPU will trigger a stage 2 fault if it attempts to write a record to
memory during the break part of the sequence.

Map hugetlb pages with a block mapping at stage 2, to make sure this won't
happen.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h |   3 +
 arch/arm64/include/asm/kvm_spe.h |   6 +
 arch/arm64/kvm/mmu.c             |  23 ++-
 arch/arm64/kvm/spe.c             | 292 ++++++++++++++++++++++++-------
 4 files changed, 250 insertions(+), 74 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index a4a0e00d1bbb..4d57c6d62f4a 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -191,6 +191,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 bool kvm_vma_mte_allowed(struct vm_area_struct *vma);
 void kvm_sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn, unsigned long size);
 
+bool kvm_stage2_supports_map_size(struct kvm_memory_slot *memslot,
+				  unsigned long hva, unsigned long map_size);
+
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
 int __init kvm_mmu_init(u32 *hyp_va_bits);
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 7dcf03980019..a22764719ecc 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -68,6 +68,8 @@ u8 kvm_spe_get_pmsver_limit(void);
 
 void kvm_spe_handle_req_memlock(struct kvm_vcpu *vcpu);
 
+bool kvm_spe_gfn_is_pinned(struct kvm_vcpu *vcpu, gfn_t gfn);
+
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
@@ -117,6 +119,10 @@ static inline u8 kvm_spe_get_pmsver_limit(void)
 static inline void kvm_spe_handle_req_memlock(struct kvm_vcpu *vcpu)
 {
 }
+static inline bool kvm_spe_gfn_is_pinned(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	return false;
+}
 static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	return -ENXIO;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index de48fb7c0fff..cc2993f10269 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1332,9 +1332,8 @@ static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
 }
 
-static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
-					       unsigned long hva,
-					       unsigned long map_size)
+bool kvm_stage2_supports_map_size(struct kvm_memory_slot *memslot,
+				  unsigned long hva, unsigned long map_size)
 {
 	gpa_t gpa_start;
 	hva_t uaddr_start, uaddr_end;
@@ -1417,7 +1416,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
+	if (kvm_stage2_supports_map_size(memslot, hva, PMD_SIZE)) {
 		int sz = get_user_mapping_size(kvm, hva);
 
 		if (sz < 0)
@@ -1664,6 +1663,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct page *page;
 	vm_flags_t vm_flags;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
+	bool is_vma_hugetlbfs;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1694,6 +1694,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
+	is_vma_hugetlbfs = is_vm_hugetlb_page(vma);
+
 	if (force_pte)
 		vma_shift = PAGE_SHIFT;
 	else
@@ -1702,7 +1704,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
+		if (kvm_stage2_supports_map_size(memslot, hva, PUD_SIZE))
 			break;
 		fallthrough;
 #endif
@@ -1710,7 +1712,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_shift = PMD_SHIFT;
 		fallthrough;
 	case PMD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
+		if (kvm_stage2_supports_map_size(memslot, hva, PMD_SIZE))
 			break;
 		fallthrough;
 	case CONT_PTE_SHIFT:
@@ -1853,6 +1855,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		goto out_unlock;
 	}
 
+	if (vcpu_has_spe(vcpu) && logging_active && is_vma_hugetlbfs) {
+		gfn_t pmd_gfn = PHYS_PFN(fault_ipa & PMD_MASK);
+
+		if (kvm_spe_gfn_is_pinned(vcpu, pmd_gfn)) {
+			/* SPE won the race, don't break the block mapping. */
+			goto out_unlock;
+		}
+	}
+
 	/*
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 2e2b97c3b861..81e07bc08ba6 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -6,6 +6,7 @@
 #include <linux/bitops.h>
 #include <linux/capability.h>
 #include <linux/cpumask.h>
+#include <linux/hugetlb.h>
 #include <linux/kvm_host.h>
 #include <linux/perf/arm_spe_pmu.h>
 #include <linux/swap.h>
@@ -30,6 +31,7 @@ struct pinned_page {
 	DECLARE_BITMAP(vcpus, KVM_MAX_VCPUS);	/* The page is pinned on these VCPUs */
 	struct page *page;
 	gfn_t gfn;
+	unsigned long s2_map_size;
 	bool unmap_after_unpin;			/* Unmap the page after the buffer is unpinned */
 	bool writable;				/* Is the page mapped as writable? */
 };
@@ -196,10 +198,7 @@ static bool kvm_spe_allow_stage2_change(enum kvm_mmu_notifier_event event)
 	 * to memory.
 	 */
 	case KVM_MMU_NOTIFY_WP:
-	/*
-	 * All buffer pages are mapped with PAGE_SIZE granularity at stage 2,
-	 * it's safe to skip them.
-	 */
+	/* Buffer pages will be unmapped after they are unpinned. */
 	case KVM_MMU_NOTIFY_SPLIT_HUGE_PAGE:
 		return false;
 
@@ -246,8 +245,8 @@ phys_addr_t kvm_spe_adjust_range_start(struct kvm *kvm, phys_addr_t start, phys_
 {
 	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
 	struct xarray *pinned_pages = &kvm_spe->pinned_pages;
+	kvm_pfn_t limit_gfn, gfn = PHYS_PFN(start);
 	struct pinned_page *pinned_page;
-	kvm_pfn_t gfn;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -255,21 +254,55 @@ phys_addr_t kvm_spe_adjust_range_start(struct kvm *kvm, phys_addr_t start, phys_
 		return start;
 
 	xa_lock(pinned_pages);
-	for (gfn = PHYS_PFN(start); gfn < PHYS_PFN(end); gfn++) {
+	while (gfn < PHYS_PFN(end)) {
 		pinned_page = xa_load(pinned_pages, gfn);
 		if (!pinned_page)
 			break;
 
 		pinned_page->unmap_after_unpin = true;
-		if (event == KVM_MMU_NOTIFY_WP && pinned_page->writable) {
+
+		if (event == KVM_MMU_NOTIFY_WP) {
+			if (!pinned_page->writable && pinned_page->s2_map_size == PAGE_SIZE)
+				goto next_gfn;
+
+                       /*
+			* Stage 2 block mappings are special, because, while
+			* dirty page locking is enabled, any fault will break
+			* the block mapping. Map it with all permissions to
+			* avoid the fault.
+                        */
+			if (pinned_page->s2_map_size > PAGE_SIZE) {
+				phys_addr_t gpa = PFN_PHYS(pinned_page->gfn);
+				struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+				enum kvm_pgtable_walk_flags flags;
+				enum kvm_pgtable_prot prot;
+				int ret;
+
+				prot = KVM_PGTABLE_PROT_X |
+				       KVM_PGTABLE_PROT_R |
+				       KVM_PGTABLE_PROT_W;
+				flags = KVM_PGTABLE_WALK_HANDLE_FAULT;
+				ret = kvm_pgtable_stage2_relax_perms(mmu->pgt, gpa, prot, flags);
+				if (WARN_ON_ONCE(ret))
+					goto next_gfn;
+				kvm_call_hyp(__kvm_tlb_flush_vmid_range,
+					     mmu, gpa, PHYS_PFN(pinned_page->s2_map_size));
+			}
+
+			limit_gfn = min(PHYS_PFN(end), gfn + PHYS_PFN(pinned_page->s2_map_size));
 			kvm_spe->dirtying_pages = true;
-			mark_page_dirty(kvm, gfn);
+			for (; gfn < limit_gfn; gfn++)
+				mark_page_dirty(kvm, gfn);
 			kvm_spe->dirtying_pages = false;
+
+			continue;
 		}
+next_gfn:
+		gfn += PHYS_PFN(pinned_page->s2_map_size);
 	}
 	xa_unlock(pinned_pages);
 
-	return PFN_PHYS(gfn);
+	return min_t(phys_addr_t, PFN_PHYS(gfn), end);
 }
 
 /*
@@ -280,16 +313,19 @@ static void kvm_spe_unpin_page_range(struct kvm *kvm, phys_addr_t start, phys_ad
 {
 	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
 	struct pinned_page *pinned_page;
-	kvm_pfn_t gfn;
+	kvm_pfn_t gfn = PHYS_PFN(start);
 
 	xa_lock(pinned_pages);
-	for (gfn = PHYS_PFN(start); gfn < PHYS_PFN(end); gfn++) {
+	while (gfn < PHYS_PFN(end)) {
 		pinned_page = xa_load(pinned_pages, gfn);
-		if (!pinned_page)
+		if (!pinned_page) {
+			gfn++;
 			continue;
+		}
 
 		kvm_spe_unpin_page(kvm, pinned_page);
 		kfree(pinned_page);
+		gfn += PHYS_PFN(pinned_page->s2_map_size);
 	}
 	xa_unlock(pinned_pages);
 }
@@ -422,7 +458,7 @@ static void kvm_spe_unpin_page(struct kvm *kvm, struct pinned_page *pinned_page)
 {
 	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
 
-	kvm_spe_remove_locked_mem(kvm, PAGE_SIZE);
+	kvm_spe_remove_locked_mem(kvm, pinned_page->s2_map_size);
 
 	__xa_erase(pinned_pages, pinned_page->gfn);
 	unpin_user_pages_dirty_lock(&pinned_page->page, 1, pinned_page->writable);
@@ -476,7 +512,7 @@ static void kvm_spe_unpin_buffer(struct kvm_vcpu *vcpu)
 		if (!pgt)
 			goto free_continue;
 
-		kvm_pgtable_stage2_unmap(pgt, PFN_PHYS(pinned_page->gfn), PAGE_SIZE);
+		kvm_pgtable_stage2_unmap(pgt, PFN_PHYS(pinned_page->gfn), pinned_page->s2_map_size);
 		unmap_count++;
 		if (unmap_count == unmap_resched) {
 			xas_pause(&xas);
@@ -538,6 +574,30 @@ static void kvm_spe_add_locked_mem(struct kvm_vcpu *vcpu, unsigned long size)
 		vcpu_spe->locked_mem_excess = kvm_spe->locked_mem - kvm_spe->locked_mem_watermark;
 }
 
+static void kvm_spe_unlock_mmu(struct kvm *kvm, bool exclusive_access)
+{
+	if (exclusive_access)
+		write_unlock(&kvm->mmu_lock);
+	else
+		read_unlock(&kvm->mmu_lock);
+}
+
+static bool kvm_spe_lock_mmu(struct kvm *kvm, unsigned long s2_map_size, bool logging_active)
+{
+	bool exclusive_access;
+
+	if (s2_map_size > PAGE_SIZE && logging_active) {
+		/* Prevent concurrent CPU faults breaking the block mapping. */
+		write_lock(&kvm->mmu_lock);
+		exclusive_access = true;
+	} else {
+		read_lock(&kvm->mmu_lock);
+		exclusive_access = false;
+	}
+
+	return exclusive_access;
+}
+
 #define MAP_GPA_RET_NOTIFIER_RETRY	1
 #define MAP_GPA_RET_PAGE_EXIST		2
 
@@ -549,7 +609,7 @@ static void kvm_spe_add_locked_mem(struct kvm_vcpu *vcpu, unsigned long size)
 /* Calls release_faultin_page(), regardless of the return value */
 static int kvm_spe_map_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t hfn, struct page *page,
 			   bool make_writable, bool mte_allowed, unsigned long mmu_seq,
-			   struct pinned_page *pinned_page)
+			   struct pinned_page *pinned_page, unsigned long s2_map_size)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
@@ -558,21 +618,31 @@ static int kvm_spe_map_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t hfn, stru
 	gfn_t gfn = PHYS_PFN(gpa);
 	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT;
 	int action = PGTABLE_ACTION_NONE;
+	struct kvm_memory_slot *memslot = gfn_to_memslot(kvm, gfn);
+	bool logging_active = kvm_slot_dirty_track_enabled(memslot);
+	bool exclusive_access;
 	s8 level = S8_MAX;
 	kvm_pte_t pte = 0;
 	int ret;
 
-	read_lock(&kvm->mmu_lock);
+	if (make_writable)
+		prot |= KVM_PGTABLE_PROT_W;
+
+	/* Avoid all faults. */
+	if (s2_map_size > PAGE_SIZE && logging_active)
+		prot |= KVM_PGTABLE_PROT_X;
+
+	exclusive_access = kvm_spe_lock_mmu(kvm, s2_map_size, logging_active);
+	if (!exclusive_access)
+		flags |= KVM_PGTABLE_WALK_SHARED;
+
 	if (mmu_invalidate_retry(kvm, mmu_seq)) {
 		ret = MAP_GPA_RET_NOTIFIER_RETRY;
 		goto mmu_unlock;
 	}
 
-	if (make_writable)
-		prot |= KVM_PGTABLE_PROT_W;
-
 	ret = kvm_pgtable_get_leaf(pgt, gpa, &pte, &level);
 	if (ret)
 		goto mmu_unlock;
@@ -589,7 +659,7 @@ static int kvm_spe_map_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t hfn, stru
 		}
 
 		existing_prot = kvm_pgtable_stage2_pte_prot(pte);
-		if (kvm_granule_size(level) != PAGE_SIZE) {
+		if (kvm_granule_size(level) != s2_map_size) {
 			/* Break block mapping */
 			action = PGTABLE_MAP_GPA;
 		} else {
@@ -603,14 +673,14 @@ static int kvm_spe_map_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t hfn, stru
 	}
 
 	if (action == PGTABLE_MAP_GPA) {
-		read_unlock(&kvm->mmu_lock);
+		kvm_spe_unlock_mmu(kvm, exclusive_access);
 		ret = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
 				kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
 		if (ret) {
 			kvm_release_faultin_page(kvm, page, false, make_writable);
 			goto out;
 		}
-		read_lock(&kvm->mmu_lock);
+		exclusive_access = kvm_spe_lock_mmu(kvm, s2_map_size, logging_active);
 		if (mmu_invalidate_retry(kvm, mmu_seq)) {
 			ret = MAP_GPA_RET_NOTIFIER_RETRY;
 			goto mmu_unlock;
@@ -642,7 +712,7 @@ static int kvm_spe_map_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t hfn, stru
 
 	if (!pp && !kvm_pte_valid(pte) && kvm_has_mte(kvm)) {
 		if (mte_allowed) {
-			kvm_sanitise_mte_tags(kvm, hfn, PAGE_SIZE);
+			kvm_sanitise_mte_tags(kvm, hfn, s2_map_size);
 		} else {
 			ret = -EFAULT;
 			goto mmu_unlock;
@@ -653,7 +723,7 @@ static int kvm_spe_map_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t hfn, stru
 	if (action & PGTABLE_RELAX_PERMS) {
 		ret = kvm_pgtable_stage2_relax_perms(pgt, gpa, prot, flags);
 	} else if (action & PGTABLE_MAP_GPA) {
-		ret = kvm_pgtable_stage2_map(pgt, gpa, PAGE_SIZE, hpa, prot,
+		ret = kvm_pgtable_stage2_map(pgt, gpa, s2_map_size, hpa, prot,
 					     &vcpu->arch.mmu_page_cache, flags);
 	}
 	if (ret)
@@ -662,14 +732,22 @@ static int kvm_spe_map_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t hfn, stru
 	if (action & PGTABLE_MAKE_YOUNG)
 		kvm_pgtable_stage2_mkyoung(pgt, gpa, flags);
 
+	if (exclusive_access &&
+	    (action & (PGTABLE_MAKE_YOUNG | PGTABLE_RELAX_PERMS)) == PGTABLE_RELAX_PERMS) {
+		kvm_call_hyp(__kvm_tlb_flush_vmid_range, &kvm->arch.mmu, gpa,
+			     PHYS_PFN(s2_map_size));
+	}
+
 	if (pp) {
 		pp->writable = make_writable;
-		set_bit(vcpu->vcpu_idx, pp->vcpus);
+		if (!test_bit(vcpu->vcpu_idx, pp->vcpus))
+			set_bit(vcpu->vcpu_idx, pp->vcpus);
 
 		ret = MAP_GPA_RET_PAGE_EXIST;
 	} else {
 		pinned_page->page = page;
 		pinned_page->gfn = gfn;
+		pinned_page->s2_map_size = s2_map_size;
 		pinned_page->writable = make_writable;
 		set_bit(vcpu->vcpu_idx, pinned_page->vcpus);
 
@@ -679,31 +757,65 @@ static int kvm_spe_map_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t hfn, stru
 			goto pages_unlock;
 		}
 
-		kvm_spe_add_locked_mem(vcpu, PAGE_SIZE);
+		kvm_spe_add_locked_mem(vcpu, s2_map_size);
 		ret = 0;
 	}
 
+	if (!ret && make_writable && s2_map_size > PAGE_SIZE &&
+	    kvm_slot_dirty_track_enabled(memslot)) {
+		/*
+		 * Unmap the huge page from stage 2 after unpinning to
+		 * resume normal dirty page logging.
+		 */
+		pinned_page->unmap_after_unpin = true;
+	}
+
 pages_unlock:
 	xa_unlock(pinned_pages);
 mmu_unlock:
 	kvm_release_faultin_page(kvm, page, ret < 0, make_writable);
-	if (!ret && make_writable)
-		kvm_vcpu_mark_page_dirty(vcpu, gfn);
-
-	read_unlock(&kvm->mmu_lock);
+	if (!ret && make_writable) {
+		for (int i = 0; i < PHYS_PFN(s2_map_size); i++, gfn++)
+			mark_page_dirty_in_slot(kvm, memslot, gfn);
+	}
+	kvm_spe_unlock_mmu(kvm, exclusive_access);
 out:
 	return ret;
 }
 
-static int kvm_spe_pin_hva_locked(hva_t hva, bool make_writable, struct page **page)
+static unsigned long kvm_spe_compute_stage2_map_size(struct kvm *kvm, gfn_t gfn, hva_t hva,
+						     struct vm_area_struct *vma)
+{
+	unsigned long map_size = PAGE_SIZE;
+
+	if (is_vm_hugetlb_page(vma) && !(vma->vm_flags & VM_PFNMAP)) {
+		map_size = huge_page_size(hstate_vma(vma));
+		/* Stage 2 supports only PMD_SIZE huge mappings. */
+		if (map_size > PMD_SIZE)
+			map_size = PMD_SIZE;
+		if (!kvm_stage2_supports_map_size(gfn_to_memslot(kvm, gfn), hva, map_size))
+			map_size = PAGE_SIZE;
+	}
+
+	return map_size;
+}
+
+static int kvm_spe_pin_hva_locked(hva_t hva, bool make_writable, struct vm_area_struct *vma,
+				  struct page **page)
 {
 	unsigned int gup_flags;
 	long nr_pages;
 
+	gup_flags = FOLL_LONGTERM | FOLL_HONOR_NUMA_FAULT | FOLL_HWPOISON;
+	if (make_writable)
+		gup_flags |= FOLL_WRITE;
 	/*
-	 * FOLL_SPLIT_PMD is what allows us to ignore the order of the folio and
-	 * how the page is mapped in the host and operate on a single page
-	 * instead of a higher order folio.
+	 * When the VMA is backed by hugetlb, the memory will be mapped with a
+	 * block mapping at stage 2.
+	 *
+	 * In the non-hugetlb case, FOLL_SPLIT_PMD is what allows us to ignore
+	 * the order of the folio and how the page is mapped in the host and
+	 * operate on a single page instead of a higher order folio.
 	 *
 	 * Let's assume that we don't use FOLL_SPLIT_PMD and the pinned page is
 	 * mapped with a block mapping in the host's stage 1.  kvm_spe_map_gpa()
@@ -722,9 +834,8 @@ static int kvm_spe_pin_hva_locked(hva_t hva, bool make_writable, struct page **p
 	 * true: a higher order folio can be split into PTEs regardless of its
 	 * elevated reference count (see split_huge_pmd()).
 	 */
-	gup_flags = FOLL_LONGTERM | FOLL_SPLIT_PMD | FOLL_HONOR_NUMA_FAULT | FOLL_HWPOISON;
-	if (make_writable)
-		gup_flags |= FOLL_WRITE;
+	if (!is_vm_hugetlb_page(vma))
+		gup_flags |= FOLL_SPLIT_PMD;
 
 	nr_pages = pin_user_pages(hva, 1, gup_flags, page);
 
@@ -753,7 +864,8 @@ static int kvm_spe_find_hva(struct kvm *kvm, gfn_t gfn, bool make_writable, hva_
 	return 0;
 }
 
-static bool kvm_spe_test_gpa_pinned(struct kvm_vcpu *vcpu, gpa_t gpa, bool make_writable)
+static bool kvm_spe_test_gpa_pinned(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long s2_map_size,
+				    bool make_writable)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
@@ -766,17 +878,21 @@ static bool kvm_spe_test_gpa_pinned(struct kvm_vcpu *vcpu, gpa_t gpa, bool make_
 		goto out_unlock;
 
 	/*
-	 * Only happens if the buffer overlaps with a translation table, which
-	 * is almost certainly a guest bug and hopefully exceedingly rare. To
-	 * avoid unnecessary complexity, pretend that the gpa is not pinned, and
-	 * kvm_spe_map_gpa() will fix things up. Sure, it means doing a lot of
-	 * unnecessary work, but it's all on the guest for programming the
-	 * buffer with the wrong translations.
+	 * Should never happen. The buffer is mapped at stage 2 with a block
+	 * mapping if it's backed by a hugetlb page in the host, otherwise it's
+	 * mapped with PAGE_SIZE granularity. On the host side, changing a
+	 * mapping from a PAGE_SIZE page to a hugetlb page, or the other way
+	 * around, is performed only after userspace explictely unmaps the
+	 * memory.  kvm_spe_adjust_range_end() will unpin the affected buffer
+	 * page(s) when memory is unmapped by userspace.
 	 */
+	WARN_ON_ONCE(pp->s2_map_size != s2_map_size);
+
 	if (make_writable && !pp->writable)
 		goto out_unlock;
 
-	set_bit(vcpu->vcpu_idx, pp->vcpus);
+	if (!test_bit(vcpu->vcpu_idx, pp->vcpus))
+		set_bit(vcpu->vcpu_idx, pp->vcpus);
 
 	xa_unlock(pinned_pages);
 	return true;
@@ -793,7 +909,7 @@ static int kvm_spe_pin_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, bool make_writable)
 	struct kvm *kvm = vcpu->kvm;
 	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
 	struct pinned_page *pinned_page;
-	unsigned long mmu_seq, tries;
+	unsigned long mmu_seq, tries, s2_map_size;
 	struct vm_area_struct *vma;
 	gfn_t gfn = PHYS_PFN(gpa);
 	bool writable = false, mte_allowed = false;
@@ -804,32 +920,50 @@ static int kvm_spe_pin_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, bool make_writable)
 
 	WARN_ON_ONCE(!srcu_read_lock_held(&vcpu->kvm->srcu));
 
-	/*
-	 * For each buffer page, KVM needs to pin up to four pages, one for each
-	 * level of the guest's stage 1 translation tables. The first level
-	 * table is shared between each page of the buffer, and likely some of
-	 * the next levels too, so it's worth checking if a gpa is already
-	 * pinned.
-	 */
-	if (kvm_spe_test_gpa_pinned(vcpu, gpa, make_writable))
-		return 0;
-
 	ret = kvm_spe_find_hva(kvm, gfn, make_writable, &hva);
 	if (ret)
 		return ret;
 
 	scoped_guard(mmap_read_lock, current->mm) {
-		if (kvm_has_mte(kvm)) {
-			vma = vma_lookup(current->mm, hva);
-			if (!vma) {
-				kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
-				return -EFAULT;
-			}
-			mte_allowed = kvm_vma_mte_allowed(vma);
+		vma = vma_lookup(current->mm, hva);
+		if (unlikely(!vma)) {
+			kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
+			return -EFAULT;
+		}
+
+		s2_map_size = kvm_spe_compute_stage2_map_size(kvm, gfn, hva, vma);
+		if (s2_map_size == PMD_SIZE) {
+			/*
+			 * Make the adjustements before searching for the gpa in
+			 * pinned_pages.
+			 */
+			hva &= PMD_MASK;
+			gpa &= PMD_MASK;
+			gfn = PHYS_PFN(gpa);
+			/*
+			 * Dirty page tracking cannot be enabled on read-only
+			 * memslots.
+			 */
+			if (kvm_slot_dirty_track_enabled(gfn_to_memslot(kvm, gfn)))
+				make_writable = true;
 		}
-		ret = kvm_spe_pin_hva_locked(hva, make_writable, &page);
+
+		/*
+		 * For each buffer page, KVM needs to pin up to four pages, one
+		 * for each level of the guest's stage 1 translation tables. The
+		 * first level table is shared between each page of the buffer,
+		 * and likely some of the next levels too, so it's worth
+		 * checking if a gpa is already pinned.
+		 */
+		if (kvm_spe_test_gpa_pinned(vcpu, gpa, s2_map_size, make_writable))
+			return 0;
+
+		ret = kvm_spe_pin_hva_locked(hva, make_writable, vma, &page);
 		if (ret)
 			return ret;
+
+		if (kvm_has_mte(kvm))
+			mte_allowed = kvm_vma_mte_allowed(vma);
 	}
 
 	pinned_page = kzalloc(sizeof(*pinned_page), GFP_KERNEL_ACCOUNT);
@@ -848,7 +982,7 @@ static int kvm_spe_pin_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, bool make_writable)
 
 	get_page(page);
 	ret = kvm_spe_map_gpa(vcpu, gpa, hfn, page, make_writable, mte_allowed, mmu_seq,
-			      pinned_page);
+			      pinned_page, s2_map_size);
 	tries = 1;
 
 	while (ret == MAP_GPA_RET_NOTIFIER_RETRY) {
@@ -867,7 +1001,7 @@ static int kvm_spe_pin_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, bool make_writable)
 
 		hfn = kvm_faultin_pfn(vcpu, gfn, make_writable, &writable, &retry_page);
 		if (hfn == KVM_PFN_ERR_HWPOISON) {
-			send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva, PAGE_SIZE, current);
+			send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva, s2_map_size, current);
 			ret = 0;
 			goto out_release;
 		}
@@ -887,7 +1021,7 @@ static int kvm_spe_pin_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, bool make_writable)
 		}
 
 		ret = kvm_spe_map_gpa(vcpu, gpa, hfn, page, make_writable, mte_allowed, mmu_seq,
-				      pinned_page);
+				      pinned_page, s2_map_size);
 		/*
 		 * Choose the number of VCPUs as the limit on retrying because
 		 * the guest can enable SPE on all VCPUs at the same, and
@@ -1420,6 +1554,28 @@ void kvm_spe_handle_req_memlock(struct kvm_vcpu *vcpu)
 	vcpu_spe->locked_mem_excess = 0;
 }
 
+bool kvm_spe_gfn_is_pinned(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
+	bool is_pinned = false;
+	struct pinned_page *pinned_page;
+
+	xa_lock(pinned_pages);
+	if (xa_empty(pinned_pages))
+		goto unlock;
+
+	pinned_page = xa_load(pinned_pages, gfn);
+	if (pinned_page) {
+		is_pinned = true;
+		WARN_ON_ONCE(!pinned_page->writable);
+	}
+
+unlock:
+	xa_unlock(pinned_pages);
+	return is_pinned;
+}
+
 static u64 max_buffer_size_to_pmbidr_el1(u64 size)
 {
 	u64 msb_idx, num_bits;
-- 
2.51.2

