Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFA6028314C
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136530; cv=none; b=kbd9xmFANlOnrPTxUDFTGlDnlXl+kju29ir8t3R+DFHkTd7JEkf6uoq4mRanx4XdY3pt3/yL4cgYxDoSbBBrmF6J0wzaDnaCKrMPV09oNdmWeXebXpYXUzoISuvXvkhCqoIWgDun2t9O3vDK9T86JkBpGsKtmFpBscMfUE2sgp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136530; c=relaxed/simple;
	bh=NrvL1PI8NN1y/CUyyM0APPpyQVGbBmzYp5axJ/ouwWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgf/sxpRvegmTc8p005Bm0j5iAapWqtBEFd7sJBnKb+u1Cl1BxBDqKwgexk3xFPOmMjVVLG/yaU1CS68wqosLmrHZGsmqozq6W+JnFPSOaHQDiZ5wBMrFZ4ScnTOIJX+ABy/PzsZ2n+ebHuBTn3tayqFyJUWrZY0eNGBqUOZOhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E83BC1BCB;
	Fri, 14 Nov 2025 08:08:39 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 444243F5A1;
	Fri, 14 Nov 2025 08:08:45 -0800 (PST)
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
Subject: [RFC PATCH v6 29/35] KVM: arm64: Pin the SPE buffer in the host and map it at stage 2
Date: Fri, 14 Nov 2025 16:07:10 +0000
Message-ID: <20251114160717.163230-30-alexandru.elisei@arm.com>
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

If the SPU encounters a translation fault when it attempts to write a
profiling record to memory, it stops profiling and asserts the PMBIRQ
interrupt.  Interrupts are not delivered instantaneously to the CPU, and
this creates a profiling blackout window where the profiled CPU executes
instructions, but no samples are collected.

This is not desirable, and the SPE driver avoids it by keeping the buffer
mapped for the entire the profiling session.

KVM maps memory at stage 2 when the guest accesses it, following a fault on
a missing stage 2 translation, which means that the problem is present in a
SPE enabled virtual machine. Worse yet, the blackout windows are
unpredictable: the guest profiling the same process can during one
profiling session, not trigger any stage 2 faults (the entire buffer memory
is already mapped at stage 2), but worst case scenario, during another
profiling session, trigger stage 2 faults for every record it attempts to
write (if KVM keeps removing the buffer pages from stage 2), or something
in between - some records trigger a stage 2 fault, some don't.

The solution is for KVM to follow what the SPE driver does: keep the buffer
mapped at stage 2 while ProfilingBufferEnabled() is true. To accomplish
this, pin the host pages that correspond to the guest buffer, **and** the
pages that correspond to the stage 1 entries used for translating the
buffer guest virtual addresses.

When a guest enables profiling, KVM walks stage 1, finds the IPA mapping
for guest VA, pins the corresponding host page and installs the IPA to PA
mapping at stage 2.

Transparent huge pages can be split by split_huge_pmd() regardless of the
reference count (as per Documentation/mm/transhuge.rst). On arm64, going
from a block mapping to a PTE mapping requires break-before-make, and the
SPU will trigger a stage 2 fault if it happens to write to memory exactly
during the break part.  Avoid this by pre-splitting the THP using the
FOLL_SPLIT_PMD flag for gup.

Note that this is not enough to guarantee that the buffer remains mapped at
stage 2, as a page pinned longterm in the host can still be unmapped from
stage 2. Hugetlb-backed guest memory is also not working, because the flag
FOLL_SPLIT_PMD is incompatible with hugetlb.

And yet another glaring ommission is dirty page tracking: KVM will happily
mark a buffer page as read-only, even though that will likely cause a
buffer management event, with the associated blackout window.

All of these shortcomings will be handled in later patches.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h |   9 +-
 arch/arm64/include/asm/kvm_spe.h     |   9 +
 arch/arm64/include/asm/sysreg.h      |   2 +
 arch/arm64/kvm/arm.c                 |   3 +
 arch/arm64/kvm/spe.c                 | 625 ++++++++++++++++++++++++++-
 5 files changed, 634 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c9eab316398e..50174ab86a58 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -472,9 +472,9 @@ u64 kvm_vcpu_trap_get_perm_fault_granule(const struct kvm_vcpu *vcpu)
 	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(esr & ESR_ELx_FSC_LEVEL));
 }
 
-static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_fsc_issea(const u8 fsc)
 {
-	switch (kvm_vcpu_trap_get_fault(vcpu)) {
+	switch (fsc) {
 	case ESR_ELx_FSC_EXTABT:
 	case ESR_ELx_FSC_SEA_TTW(-1) ... ESR_ELx_FSC_SEA_TTW(3):
 	case ESR_ELx_FSC_SECC:
@@ -485,6 +485,11 @@ static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
 	}
 }
 
+static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
+{
+	return kvm_fsc_issea(kvm_vcpu_trap_get_fault(vcpu));
+}
+
 static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 7d8becf76314..6c091fbfc95d 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -11,6 +11,7 @@
 #ifdef CONFIG_KVM_ARM_SPE
 
 struct kvm_spe {
+	struct xarray pinned_pages;
 	struct arm_spe_pmu *arm_spu;
 	u64 max_buffer_size;	/* Maximum per VCPU buffer size */
 	u64 guest_pmscr_el2;
@@ -42,7 +43,9 @@ static inline bool kvm_spe_profiling_buffer_enabled(u64 pmblimitr_el1, u64 pmbsr
 }
 
 void kvm_spe_init_vm(struct kvm *kvm);
+void kvm_spe_destroy_vm(struct kvm *kvm);
 int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
+void kvm_spe_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 u8 kvm_spe_get_pmsver_limit(void);
 
@@ -73,10 +76,16 @@ struct kvm_vcpu_spe {
 static inline void kvm_spe_init_vm(struct kvm *kvm)
 {
 }
+static inline void kvm_spe_destroy_vm(struct kvm *kvm)
+{
+}
 static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+static inline void kvm_spe_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+}
 static inline u8 kvm_spe_get_pmsver_limit(void)
 {
 	return 0;
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 28388e12a251..87bc46a68d51 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -345,6 +345,8 @@
 /* Buffer error reporting */
 #define PMBSR_EL1_FAULT_FSC_SHIFT	PMBSR_EL1_MSS_SHIFT
 #define PMBSR_EL1_FAULT_FSC_MASK	PMBSR_EL1_MSS_MASK
+#define PMBSR_EL1_FAULT_FSC_ALIGN	0x21
+#define PMBSR_EL1_FAULT_FSC_TTW0	0x4
 
 #define PMBSR_EL1_BUF_BSC_SHIFT		PMBSR_EL1_MSS_SHIFT
 #define PMBSR_EL1_BUF_BSC_MASK		PMBSR_EL1_MSS_MASK
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a2c97daece24..8da772690173 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -259,6 +259,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kfree(kvm->arch.sysreg_masks);
 	kvm_destroy_vcpus(kvm);
 
+	kvm_spe_destroy_vm(kvm);
+
 	kvm_unshare_hyp(kvm, kvm + 1);
 
 	kvm_arm_teardown_hypercalls(kvm);
@@ -517,6 +519,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 		free_hyp_memcache(&vcpu->arch.pkvm_memcache);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
+	kvm_spe_vcpu_destroy(vcpu);
 	kvm_vgic_vcpu_destroy(vcpu);
 	kvm_arm_vcpu_destroy(vcpu);
 }
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index b138b564413b..35848e4ff68b 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -8,9 +8,12 @@
 #include <linux/cpumask.h>
 #include <linux/kvm_host.h>
 #include <linux/perf/arm_spe_pmu.h>
+#include <linux/swap.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 #include <asm/kvm_spe.h>
+#include <asm/pgtable-hwdef.h>
 #include <asm/sysreg.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_spe_available);
@@ -23,8 +26,16 @@ struct arm_spu_entry {
 	struct arm_spe_pmu *arm_spu;
 };
 
+struct pinned_page {
+	DECLARE_BITMAP(vcpus, KVM_MAX_VCPUS);	/* The page is pinned on these VCPUs */
+	struct page *page;
+	gfn_t gfn;
+	bool writable;				/* Is the page mapped as writable? */
+};
+
 static u64 max_buffer_size_to_pmbidr_el1(u64 size);
 static void kvm_spe_update_irq_level(struct kvm_vcpu *vcpu, bool level);
+static void kvm_spe_unpin_buffer(struct kvm_vcpu *vcpu);
 
 static u64 pmblimitr_el1_res0_mask = GENMASK_ULL(11, 8) | GENMASK_ULL(6, 3);
 
@@ -63,7 +74,18 @@ void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
 
 void kvm_spe_init_vm(struct kvm *kvm)
 {
+	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
+
 	kvm->arch.kvm_spe.max_buffer_size = KVM_SPE_MAX_BUFFER_SIZE_UNSET;
+	xa_init(pinned_pages);
+}
+
+void kvm_spe_destroy_vm(struct kvm *kvm)
+{
+	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
+
+	WARN_ON_ONCE(!xa_empty(pinned_pages));
+	xa_destroy(pinned_pages);
 }
 
 static bool kvm_spe_has_physical_addrmode(struct kvm *kvm)
@@ -116,6 +138,14 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void kvm_spe_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_has_spe(vcpu))
+		return;
+
+	kvm_spe_unpin_buffer(vcpu);
+}
+
 u8 kvm_spe_get_pmsver_limit(void)
 {
 	unsigned int pmsver;
@@ -180,6 +210,534 @@ static void kvm_spe_inject_other_event(struct kvm_vcpu *vcpu, u8 bsc)
 	kvm_spe_update_irq_level(vcpu, true);
 }
 
+/* Implements DebugWriteFault() from ARM DDI0487L.a. */
+static void kvm_spe_inject_data_abort(struct kvm_vcpu *vcpu, u8 fst, bool s2)
+{
+	u64 pmbsr_el1 = __vcpu_sys_reg(vcpu, PMBSR_EL1);
+	u64 mss2 = 0, ec = 0, mss = 0;
+
+	pmbsr_el1 &= ~(PMBSR_EL1_MSS2 | PMBSR_EL1_EC | PMBSR_EL1_MSS);
+
+	ec = s2 ? PMBSR_EL1_EC_FAULT_S2 : PMBSR_EL1_EC_FAULT_S1;
+	mss = fst & GENMASK_ULL(5, 0);
+
+	pmbsr_el1 |= FIELD_PREP(PMBSR_EL1_MSS2, mss2);
+	pmbsr_el1 |= FIELD_PREP(PMBSR_EL1_EC, ec);
+	pmbsr_el1 |= FIELD_PREP(PMBSR_EL1_S, 1);
+	pmbsr_el1 |= FIELD_PREP(PMBSR_EL1_MSS, mss);
+
+	__vcpu_assign_sys_reg(vcpu, PMBSR_EL1, pmbsr_el1);
+
+	kvm_spe_update_irq_level(vcpu, true);
+}
+
+static void kvm_spe_unpin_buffer(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
+	struct pinned_page *pinned_page;
+	unsigned long gfn;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	xa_lock(pinned_pages);
+
+	xa_for_each(pinned_pages, gfn, pinned_page) {
+		if (!test_bit(vcpu->vcpu_idx, pinned_page->vcpus))
+			continue;
+
+		clear_bit(vcpu->vcpu_idx, pinned_page->vcpus);
+		if (bitmap_empty(pinned_page->vcpus, KVM_MAX_VCPUS)) {
+			__xa_erase(pinned_pages, pinned_page->gfn);
+			unpin_user_pages_dirty_lock(&pinned_page->page, 1, pinned_page->writable);
+		}
+	}
+
+	xa_unlock(pinned_pages);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
+#define MAP_GPA_RET_NOTIFIER_RETRY	1
+#define MAP_GPA_RET_PAGE_EXIST		2
+
+#define PGTABLE_ACTION_NONE	0
+#define PGTABLE_RELAX_PERMS	(1 << 0)
+#define PGTABLE_MAP_GPA		(1 << 1)
+#define PGTABLE_MAKE_YOUNG	(1 << 31)
+
+/* Calls release_faultin_page(), regardless of the return value */
+static int kvm_spe_map_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t hfn, struct page *page,
+			   bool make_writable, bool mte_allowed, unsigned long mmu_seq,
+			   struct pinned_page *pinned_page)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
+	struct pinned_page *pp = NULL;
+	phys_addr_t hpa = page_to_phys(page);
+	gfn_t gfn = PHYS_PFN(gpa);
+	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
+	int action = PGTABLE_ACTION_NONE;
+	s8 level = S8_MAX;
+	kvm_pte_t pte = 0;
+	int ret;
+
+	read_lock(&kvm->mmu_lock);
+	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+		ret = MAP_GPA_RET_NOTIFIER_RETRY;
+		goto mmu_unlock;
+	}
+
+	if (make_writable)
+		prot |= KVM_PGTABLE_PROT_W;
+
+	ret = kvm_pgtable_get_leaf(pgt, gpa, &pte, &level);
+	if (ret)
+		goto mmu_unlock;
+
+	if (kvm_pte_valid(pte)) {
+		enum kvm_pgtable_prot existing_prot;
+		phys_addr_t stage2_hpa;
+
+		/* Final sanity check. */
+		stage2_hpa = kvm_pte_to_phys(pte) + gpa % kvm_granule_size(level);
+		if (WARN_ON_ONCE(PHYS_PFN(stage2_hpa) != hfn)) {
+			ret = -EFAULT;
+			goto mmu_unlock;
+		}
+
+		existing_prot = kvm_pgtable_stage2_pte_prot(pte);
+		if (kvm_granule_size(level) != PAGE_SIZE) {
+			/* Break block mapping */
+			action = PGTABLE_MAP_GPA;
+		} else {
+			if (make_writable && !(existing_prot & KVM_PGTABLE_PROT_W))
+				action = PGTABLE_RELAX_PERMS;
+			if (!(pte & PTE_AF))
+				action |= PGTABLE_MAKE_YOUNG;
+		}
+	} else {
+		action = PGTABLE_MAP_GPA;
+	}
+
+	if (action == PGTABLE_MAP_GPA) {
+		read_unlock(&kvm->mmu_lock);
+		ret = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
+				kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
+		if (ret) {
+			kvm_release_faultin_page(kvm, page, false, make_writable);
+			goto out;
+		}
+		read_lock(&kvm->mmu_lock);
+		if (mmu_invalidate_retry(kvm, mmu_seq)) {
+			ret = MAP_GPA_RET_NOTIFIER_RETRY;
+			goto mmu_unlock;
+		}
+	}
+
+	/*
+	 * Serialize changes to stage 2 made by pinning the buffer - if multiple
+	 * VCPUs enable the buffer at the same time, they will race when pinning
+	 * the guest's stage 1 tables.
+	 */
+	xa_lock(pinned_pages);
+	pp = xa_load(pinned_pages, gfn);
+	if (pp) {
+		if (make_writable && !pp->writable) {
+			/*
+			 * GPA was made young when it was mapped, only need to
+			 * make it writable.
+			 */
+			action = PGTABLE_RELAX_PERMS;
+		} else {
+			/*
+			 * Another VCPU snuck in before we took the lock and
+			 * mapped the GPA, don't modify stage 2 twice.
+			 */
+			action = PGTABLE_ACTION_NONE;
+		}
+	}
+
+	if (!pp && !kvm_pte_valid(pte) && kvm_has_mte(kvm)) {
+		if (mte_allowed) {
+			kvm_sanitise_mte_tags(kvm, hfn, PAGE_SIZE);
+		} else {
+			ret = -EFAULT;
+			goto mmu_unlock;
+		}
+	}
+
+	ret = 0;
+	if (action & PGTABLE_RELAX_PERMS) {
+		ret = kvm_pgtable_stage2_relax_perms(pgt, gpa, prot, flags);
+	} else if (action & PGTABLE_MAP_GPA) {
+		ret = kvm_pgtable_stage2_map(pgt, gpa, PAGE_SIZE, hpa, prot,
+					     &vcpu->arch.mmu_page_cache, flags);
+	}
+	if (ret)
+		goto pages_unlock;
+
+	if (action & PGTABLE_MAKE_YOUNG)
+		kvm_pgtable_stage2_mkyoung(pgt, gpa, flags);
+
+	if (pp) {
+		pp->writable = make_writable;
+		set_bit(vcpu->vcpu_idx, pp->vcpus);
+
+		ret = MAP_GPA_RET_PAGE_EXIST;
+	} else {
+		pinned_page->page = page;
+		pinned_page->gfn = gfn;
+		pinned_page->writable = make_writable;
+		set_bit(vcpu->vcpu_idx, pinned_page->vcpus);
+
+		pp = __xa_store(pinned_pages, gfn, pinned_page, GFP_ATOMIC);
+		if (xa_is_err(pp)) {
+			ret = xa_err(pp);
+			goto pages_unlock;
+		}
+
+		ret = 0;
+	}
+
+pages_unlock:
+	xa_unlock(pinned_pages);
+mmu_unlock:
+	kvm_release_faultin_page(kvm, page, ret < 0, make_writable);
+	if (!ret && make_writable)
+		kvm_vcpu_mark_page_dirty(vcpu, gfn);
+
+	read_unlock(&kvm->mmu_lock);
+out:
+	return ret;
+}
+
+static int kvm_spe_pin_hva_locked(hva_t hva, bool make_writable, struct page **page)
+{
+	unsigned int gup_flags;
+	long nr_pages;
+
+	/*
+	 * FOLL_SPLIT_PMD is what allows us to ignore the order of the folio and
+	 * how the page is mapped in the host and operate on a single page
+	 * instead of a higher order folio.
+	 *
+	 * Let's assume that we don't use FOLL_SPLIT_PMD and the pinned page is
+	 * mapped with a block mapping in the host's stage 1.  kvm_spe_map_gpa()
+	 * will map the pinned page at the PTE level, but any number of pages
+	 * from the block mapping in the host might not be mapped at stage 2.
+	 *
+	 * When KVM takes a stage 2 fault on an IPA that corresponds to an
+	 * unmapped page that is part of the block mapping at host's stage 1,
+	 * KVM will walk the host's stage 1 and conclude it can also map the IPA
+	 * with a block mapping at stage 2. This requires break-before-make at
+	 * stage 2, during which the SPU might observe the short lived invalid
+	 * entry and report a stage 2 fault.
+	 *
+	 * Note that a higher order pinned folio, mapped at the PTE level,
+	 * cannot be collapsed into a block mapping, but the reverse is not
+	 * true: a higher order folio can be split into PTEs regardless of its
+	 * elevated reference count (see split_huge_pmd()).
+	 */
+	gup_flags = FOLL_LONGTERM | FOLL_SPLIT_PMD | FOLL_HONOR_NUMA_FAULT | FOLL_HWPOISON;
+	if (make_writable)
+		gup_flags |= FOLL_WRITE;
+
+	nr_pages = pin_user_pages(hva, 1, gup_flags, page);
+
+	if (nr_pages < 0)
+		return nr_pages;
+	if (nr_pages == 0)
+		return -ENOMEM;
+	return 0;
+}
+
+static int kvm_spe_find_hva(struct kvm *kvm, gfn_t gfn, bool make_writable, hva_t *hva)
+{
+	struct kvm_memory_slot *memslot;
+	bool writable;
+
+	memslot = gfn_to_memslot(kvm, gfn);
+	/* Confidential things not yet supported */
+	if (kvm_slot_has_gmem(memslot))
+		return -EFAULT;
+	*hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
+	if (kvm_is_error_hva(*hva))
+		return -EFAULT;
+	if (make_writable && !writable)
+		return -EPERM;
+
+	return 0;
+}
+
+static bool kvm_spe_test_gpa_pinned(struct kvm_vcpu *vcpu, gpa_t gpa, bool make_writable)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
+	struct pinned_page *pp;
+
+	xa_lock(pinned_pages);
+
+	pp = xa_load(pinned_pages, PHYS_PFN(gpa));
+	if (!pp)
+		goto out_unlock;
+
+	/*
+	 * Only happens if the buffer overlaps with a translation table, which
+	 * is almost certainly a guest bug and hopefully exceedingly rare. To
+	 * avoid unnecessary complexity, pretend that the gpa is not pinned, and
+	 * kvm_spe_map_gpa() will fix things up. Sure, it means doing a lot of
+	 * unnecessary work, but it's all on the guest for programming the
+	 * buffer with the wrong translations.
+	 */
+	if (make_writable && !pp->writable)
+		goto out_unlock;
+
+	set_bit(vcpu->vcpu_idx, pp->vcpus);
+
+	xa_unlock(pinned_pages);
+	return true;
+
+out_unlock:
+	xa_unlock(pinned_pages);
+	return false;
+}
+
+static int kvm_spe_pin_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, bool make_writable)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
+	struct pinned_page *pinned_page;
+	unsigned long mmu_seq, tries;
+	struct vm_area_struct *vma;
+	gfn_t gfn = PHYS_PFN(gpa);
+	bool writable = false, mte_allowed = false;
+	struct page *page;
+	kvm_pfn_t hfn;
+	hva_t hva;
+	int ret;
+
+	WARN_ON_ONCE(!srcu_read_lock_held(&vcpu->kvm->srcu));
+
+	/*
+	 * For each buffer page, KVM needs to pin up to four pages, one for each
+	 * level of the guest's stage 1 translation tables. The first level
+	 * table is shared between each page of the buffer, and likely some of
+	 * the next levels too, so it's worth checking if a gpa is already
+	 * pinned.
+	 */
+	if (kvm_spe_test_gpa_pinned(vcpu, gpa, make_writable))
+		return 0;
+
+	ret = kvm_spe_find_hva(kvm, gfn, make_writable, &hva);
+	if (ret)
+		return ret;
+
+	scoped_guard(mmap_read_lock, current->mm) {
+		if (kvm_has_mte(kvm)) {
+			vma = vma_lookup(current->mm, hva);
+			if (!vma) {
+				kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
+				return -EFAULT;
+			}
+			mte_allowed = kvm_vma_mte_allowed(vma);
+		}
+		ret = kvm_spe_pin_hva_locked(hva, make_writable, &page);
+		if (ret)
+			return ret;
+	}
+
+	pinned_page = kzalloc(sizeof(*pinned_page), GFP_KERNEL_ACCOUNT);
+	if (!pinned_page) {
+		ret = -ENOMEM;
+		goto out_unpin_page;
+	}
+	ret = xa_reserve(pinned_pages, gfn, GFP_KERNEL_ACCOUNT);
+	if (ret)
+		goto out_free;
+
+	mmu_seq = kvm->mmu_invalidate_seq;
+	smp_rmb();
+
+	hfn = page_to_pfn(page);
+
+	get_page(page);
+	ret = kvm_spe_map_gpa(vcpu, gpa, hfn, page, make_writable, mte_allowed, mmu_seq,
+			      pinned_page);
+	tries = 1;
+
+	while (ret == MAP_GPA_RET_NOTIFIER_RETRY) {
+		struct page *retry_page;
+
+		/*
+		 * mmu_seq has likely changed for benign reasons (a memory
+		 * allocation triggered reclaim/compaction, for example), but it
+		 * could have also changed because userspace did something that
+		 * KVM must handle, like changing the protection for the VMA
+		 * that backs the memslot. So walk stage 1 again instead of
+		 * failing prematurely.
+		 */
+		mmu_seq = kvm->mmu_invalidate_seq;
+		smp_rmb();
+
+		hfn = kvm_faultin_pfn(vcpu, gfn, make_writable, &writable, &retry_page);
+		if (hfn == KVM_PFN_ERR_HWPOISON) {
+			send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva, PAGE_SIZE, current);
+			ret = 0;
+			goto out_release;
+		}
+		if (is_error_noslot_pfn(hfn)) {
+			ret = -EFAULT;
+			break;
+		}
+		if (WARN_ON_ONCE(retry_page != page)) {
+			kvm_release_page_unused(retry_page);
+			ret = -EFAULT;
+			break;
+		}
+		if (make_writable && !writable) {
+			kvm_release_page_unused(page);
+			ret = -EPERM;
+			break;
+		}
+
+		ret = kvm_spe_map_gpa(vcpu, gpa, hfn, page, make_writable, mte_allowed, mmu_seq,
+				      pinned_page);
+		/*
+		 * Choose the number of VCPUs as the limit on retrying because
+		 * the guest can enable SPE on all VCPUs at the same, and
+		 * pinning the buffer can lead to memory allocation or
+		 * migration, which increment the MMU notification count.
+		 */
+		tries++;
+		if (ret == MAP_GPA_RET_NOTIFIER_RETRY && tries == kvm->created_vcpus + 1)
+			ret = -EAGAIN;
+	}
+
+	if (ret < 0)
+		goto out_release;
+
+	switch (ret) {
+	case 0:
+		break;
+	case MAP_GPA_RET_PAGE_EXIST:
+		kfree(pinned_page);
+		pinned_page = NULL;
+		/* Unpin the page we pinned twice. */
+		unpin_user_pages_dirty_lock(&page, 1, make_writable);
+		break;
+	default:
+		WARN_ON_ONCE(true);
+	}
+
+	/* Treat all non-negative return codes as success. */
+	return 0;
+
+out_release:
+	xa_release(pinned_pages, gfn);
+out_free:
+	kfree(pinned_page);
+out_unpin_page:
+	unpin_user_pages_dirty_lock(&page, 1, make_writable);
+	return ret;
+}
+
+/*
+ * Read the address of the next level translation table and pin the table at the
+ * current translation level.
+ *
+ * Called with KVM's SRCU lock held.
+ */
+static int kvm_spe_pin_buffer_read_desc(struct kvm_vcpu *vcpu, gpa_t gpa, void *data,
+					      unsigned long len)
+{
+	int ret;
+
+	/* Page descriptors are always 64 bits. */
+	if (WARN_ON_ONCE(len != 8))
+		return -EINVAL;
+
+	ret = kvm_read_guest(vcpu->kvm, gpa, data, len);
+	if (ret)
+		return ret;
+
+	return kvm_spe_pin_gpa(vcpu, gpa, false);
+}
+
+static bool kvm_spe_pin_buffer(struct kvm_vcpu *vcpu, u64 ptr, u64 limit)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct s1_walk_result wr = {};
+	struct s1_walk_info wi = {
+		.read_desc 	= kvm_spe_pin_buffer_read_desc,
+		.regime		= TR_EL10,
+		.as_el0		= false,
+		.pan		= false,
+	};
+	bool commit_write, s2_err;
+	int idx, ret;
+	u8 fst = 0;
+
+	/* KVM can only pin memory at the host's PAGE_SIZE granularity. */
+	ptr = PAGE_ALIGN_DOWN(ptr);
+	limit = PAGE_ALIGN(limit);
+
+	idx = srcu_read_lock(&kvm->srcu);
+	for (; ptr < limit; ptr += PAGE_SIZE) {
+		ret = __kvm_translate_va(vcpu, &wi, &wr, ptr);
+		if (ret) {
+			fst = wr.fst;
+			s2_err = wr.s2;
+			break;
+		}
+		if (!wr.pw) {
+			/* I_GQYCH */
+			fst = ESR_ELx_FSC_PERM_L(wr.level);
+			s2_err = false;
+			ret = -EPERM;
+			break;
+		}
+
+		ret = kvm_spe_pin_gpa(vcpu, wr.pa, true);
+		if (ret) {
+			if (ret == -EPERM)
+				fst = ESR_ELx_FSC_PERM_L(wr.level);
+			s2_err = true;
+			break;
+		}
+	}
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	if (!ret)
+		return true;
+
+	switch (ret) {
+	case -EAGAIN:
+		commit_write = false;
+		break;
+	case -EPERM:
+		if (!fst)
+			fst = ESR_ELx_FSC_PERM_L(1);
+		kvm_spe_inject_data_abort(vcpu, fst, s2_err);
+		commit_write = true;
+		break;
+	case -ENOMEM:
+		kvm_spe_inject_other_event(vcpu, PMBSR_EL1_BUF_BSC_SIZE);
+		commit_write = true;
+		break;
+	default:
+		if (!fst)
+			fst = ESR_ELx_FSC_FAULT_L(0);
+		kvm_spe_inject_data_abort(vcpu, fst, s2_err);
+		commit_write = true;
+	}
+
+	kvm_spe_unpin_buffer(vcpu);
+
+	return commit_write;
+}
+
 static u64 kvm_spe_max_buffer_size(struct kvm *kvm)
 {
 	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
@@ -229,8 +787,14 @@ static u16 kvm_spe_min_align(struct kvm *kvm)
 
 bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
 {
+	u64 pmbptr_el1, pmblimitr_el1, pmbsr_el1;
+	bool was_enabled, now_enabled;
 	struct kvm *kvm = vcpu->kvm;
 	u64 ptr, limit, max_buffer_size;
+	bool commit_write;
+
+	was_enabled = kvm_spe_profiling_buffer_enabled_vcpu(vcpu) &&
+		      !kvm_spe_in_discard_mode_vcpu(vcpu);
 
 	switch (reg) {
 	case PMBLIMITR_EL1:
@@ -244,19 +808,32 @@ bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
 		break;
 	default:
 		WARN_ON_ONCE(true);
+		goto commit_write;
 	}
 
-	__vcpu_assign_sys_reg(vcpu, reg, val);
-	if (reg == PMBSR_EL1) {
-		kvm_spe_update_irq_level(vcpu,
-					 FIELD_GET(PMBSR_EL1_S, __vcpu_sys_reg(vcpu, PMBSR_EL1)));
-	}
+	/*
+	 * Don't update the VCPU register just yet, we might be required to
+	 * replay the access to retry pinning the buffer.
+	 */
 
-	if (!kvm_spe_profiling_buffer_enabled_vcpu(vcpu) || kvm_spe_in_discard_mode_vcpu(vcpu))
-		goto out;
+	pmbptr_el1 = reg == PMBPTR_EL1 ? val : __vcpu_sys_reg(vcpu, PMBPTR_EL1);
+	pmblimitr_el1 = reg == PMBLIMITR_EL1 ? val : __vcpu_sys_reg(vcpu, PMBLIMITR_EL1);
+	pmbsr_el1 = reg == PMBSR_EL1 ? val : __vcpu_sys_reg(vcpu, PMBSR_EL1);
 
-	ptr = kvm_spe_buffer_ptr(__vcpu_sys_reg(vcpu, PMBPTR_EL1));
-	limit = kvm_spe_buffer_limit(__vcpu_sys_reg(vcpu, PMBLIMITR_EL1));
+	now_enabled = kvm_spe_profiling_buffer_enabled(pmblimitr_el1, pmbsr_el1) &&
+		      !kvm_spe_in_discard_mode(pmblimitr_el1);
+
+	if (!was_enabled && !now_enabled)
+		goto commit_write;
+
+	if (was_enabled)
+		kvm_spe_unpin_buffer(vcpu);
+
+	if (!now_enabled)
+		goto commit_write;
+
+	ptr = kvm_spe_buffer_ptr(pmbptr_el1);
+	limit = kvm_spe_buffer_limit(pmblimitr_el1);
 
 	/*
 	 * In the Arm ARM, Uint() performs a *signed* integer conversion.
@@ -265,14 +842,34 @@ bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
 	if (!limit || (s64)ptr > (s64)limit - (s64)kvm_spe_max_record_size(kvm) ||
 	    FIELD_GET(GENMASK_ULL(63, 56), ptr) != FIELD_GET(GENMASK_ULL(63, 56), limit)) {
 		kvm_spe_inject_other_event(vcpu, PMBSR_EL1_BUF_BSC_FULL);
-		goto out;
+		goto buffer_management_event;
 	}
 
 	max_buffer_size = kvm_spe_max_buffer_size(kvm);
-	if (max_buffer_size && limit - ptr > max_buffer_size)
+	if (max_buffer_size && limit - ptr > max_buffer_size) {
 		kvm_spe_inject_other_event(vcpu, PMBSR_EL1_BUF_BSC_SIZE);
+		goto buffer_management_event;
+	}
 
-out:
+	commit_write = kvm_spe_pin_buffer(vcpu, ptr, limit);
+	if (!commit_write)
+		return false;
+
+commit_write:
+	__vcpu_assign_sys_reg(vcpu, reg, val);
+	if (reg == PMBSR_EL1) {
+		kvm_spe_update_irq_level(vcpu,
+					 FIELD_GET(PMBSR_EL1_S, __vcpu_sys_reg(vcpu, PMBSR_EL1)));
+	}
+	return true;
+
+buffer_management_event:
+	/*
+	 * Injecting an event modifies PMBSR_EL1, make sure the write doesn't
+	 * overwrite it.
+	 */
+	if (reg != PMBSR_EL1)
+		__vcpu_assign_sys_reg(vcpu, reg, val);
 	return true;
 }
 
@@ -327,6 +924,9 @@ static u64 kvm_spe_get_pmbidr_el1(struct kvm_vcpu *vcpu)
 	pmbidr_el1 &= ~PMBIDR_EL1_MaxBuffSize;
 	pmbidr_el1 |= max_buffer_size_to_pmbidr_el1(max_buffer_size);
 
+	/* TODO: Implement support for FEAT_HAFDBS in the table walker. */
+	pmbidr_el1 &= ~PMBIDR_EL1_F;
+
 	return pmbidr_el1;
 }
 
@@ -375,6 +975,7 @@ void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
 
 	if (FIELD_GET(PMBSR_EL1_S, vcpu_spe->hw_pmbsr_el1)) {
 		__vcpu_assign_sys_reg(vcpu, PMBSR_EL1, vcpu_spe->hw_pmbsr_el1);
+		kvm_spe_unpin_buffer(vcpu);
 		vcpu_spe->hw_pmbsr_el1 = 0;
 		kvm_spe_update_irq_level(vcpu, true);
 	}
-- 
2.51.2

