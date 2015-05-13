From: Andrew Jones <drjones@redhat.com>
Subject: [RFC/RFT PATCH v2 3/3] arm/arm64: KVM: implement 'uncached' mem
 coherency
Date: Wed, 13 May 2015 13:31:54 +0200
Message-ID: <1431516714-25816-4-git-send-email-drjones@redhat.com>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41075512F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2015 07:23:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VbPi4NWD6ZS5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 May 2015 07:23:15 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B520512F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2015 07:23:14 -0400 (EDT)
In-Reply-To: <1431516714-25816-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, agraf@suse.de
Cc: catalin.marinas@arm.com, lersek@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

When S1 and S2 memory attributes combine wrt to caching policy,
non-cacheable types take precedence. If a guest maps a region as
device memory, which KVM userspace is using to emulate the device
using normal, cacheable memory, then we lose coherency. With
KVM_MEM_UNCACHED, KVM userspace can now hint to KVM which memory
regions are likely to be problematic. With this patch, as pages
of these types of regions are faulted into the guest, not only do
we flush the page's dcache, but we also change userspace's
mapping to NC in order to maintain coherency.

What if the guest doesn't do what we expect? While we can't
force a guest to use cacheable memory, we can take advantage of
the non-cacheable precedence, and force it to use non-cacheable.
So, this patch also introduces PAGE_S2_NORMAL_NC, and uses it on
KVM_MEM_UNCACHED regions to force them to NC.

We now have both guest and userspace on the same page (pun intended)

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/include/asm/kvm_mmu.h        |  5 ++++-
 arch/arm/include/asm/pgtable-3level.h |  1 +
 arch/arm/include/asm/pgtable.h        |  1 +
 arch/arm/kvm/mmu.c                    | 37 +++++++++++++++++++++++------------
 arch/arm64/include/asm/kvm_mmu.h      |  5 ++++-
 arch/arm64/include/asm/memory.h       |  1 +
 arch/arm64/include/asm/pgtable.h      |  1 +
 7 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 405aa18833073..e8034a80b12e5 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -214,8 +214,11 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
 	while (size) {
 		void *va = kmap_atomic_pfn(pfn);
 
-		if (need_flush)
+		if (need_flush) {
 			kvm_flush_dcache_to_poc(va, PAGE_SIZE);
+			if (ipa_uncached)
+				set_memory_nc((unsigned long)va, 1);
+		}
 
 		if (icache_is_pipt())
 			__cpuc_coherent_user_range((unsigned long)va,
diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index a745a2a53853c..39b3f7a40e663 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -121,6 +121,7 @@
  * 2nd stage PTE definitions for LPAE.
  */
 #define L_PTE_S2_MT_UNCACHED		(_AT(pteval_t, 0x0) << 2) /* strongly ordered */
+#define L_PTE_S2_MT_NORMAL_NC		(_AT(pteval_t, 0x5) << 2) /* normal non-cacheable */
 #define L_PTE_S2_MT_WRITETHROUGH	(_AT(pteval_t, 0xa) << 2) /* normal inner write-through */
 #define L_PTE_S2_MT_WRITEBACK		(_AT(pteval_t, 0xf) << 2) /* normal inner write-back */
 #define L_PTE_S2_MT_DEV_SHARED		(_AT(pteval_t, 0x1) << 2) /* device */
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index f40354198bad4..ae13ca8b0a23d 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -100,6 +100,7 @@ extern pgprot_t		pgprot_s2_device;
 #define PAGE_HYP		_MOD_PROT(pgprot_kernel, L_PTE_HYP)
 #define PAGE_HYP_DEVICE		_MOD_PROT(pgprot_hyp_device, L_PTE_HYP)
 #define PAGE_S2			_MOD_PROT(pgprot_s2, L_PTE_S2_RDONLY)
+#define PAGE_S2_NORMAL_NC	__pgprot((pgprot_val(PAGE_S2) & ~L_PTE_S2_MT_MASK) | L_PTE_S2_MT_NORMAL_NC)
 #define PAGE_S2_DEVICE		_MOD_PROT(pgprot_s2_device, L_PTE_S2_RDONLY)
 
 #define __PAGE_NONE		__pgprot(_L_PTE_DEFAULT | L_PTE_RDONLY | L_PTE_XN | L_PTE_NONE)
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index bc1665acd73e7..6b3bd8061bd2a 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1220,7 +1220,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct vm_area_struct *vma;
 	pfn_t pfn;
 	pgprot_t mem_type = PAGE_S2;
-	bool fault_ipa_uncached;
+	bool fault_ipa_uncached = false;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long flags = 0;
 
@@ -1300,6 +1300,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			writable = false;
 	}
 
+	if (memslot->flags & KVM_MEM_UNCACHED) {
+		mem_type = PAGE_S2_NORMAL_NC;
+		fault_ipa_uncached = true;
+	}
+
 	spin_lock(&kvm->mmu_lock);
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1307,8 +1312,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (!hugetlb && !force_pte)
 		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
 
-	fault_ipa_uncached = memslot->flags & KVM_MEM_UNCACHED;
-
 	if (hugetlb) {
 		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
 		new_pmd = pmd_mkhuge(new_pmd);
@@ -1462,6 +1465,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 			     unsigned long start,
 			     unsigned long end,
 			     int (*handler)(struct kvm *kvm,
+					    struct kvm_memory_slot *slot,
 					    gpa_t gpa, void *data),
 			     void *data)
 {
@@ -1491,14 +1495,15 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 
 		for (; gfn < gfn_end; ++gfn) {
 			gpa_t gpa = gfn << PAGE_SHIFT;
-			ret |= handler(kvm, gpa, data);
+			ret |= handler(kvm, memslot, gpa, data);
 		}
 	}
 
 	return ret;
 }
 
-static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
+static int kvm_unmap_hva_handler(struct kvm *kvm, struct kvm_memory_slot *slot,
+				 gpa_t gpa, void *data)
 {
 	unmap_stage2_range(kvm, gpa, PAGE_SIZE);
 	return 0;
@@ -1527,9 +1532,15 @@ int kvm_unmap_hva_range(struct kvm *kvm,
 	return 0;
 }
 
-static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, void *data)
+static int kvm_set_spte_handler(struct kvm *kvm, struct kvm_memory_slot *slot,
+				gpa_t gpa, void *data)
 {
-	pte_t *pte = (pte_t *)data;
+	pte_t pte = *((pte_t *)data);
+
+	if (slot->flags & KVM_MEM_UNCACHED)
+		pte = pfn_pte(pte_pfn(pte), PAGE_S2_NORMAL_NC);
+	else
+		pte = pfn_pte(pte_pfn(pte), PAGE_S2);
 
 	/*
 	 * We can always call stage2_set_pte with KVM_S2PTE_FLAG_LOGGING_ACTIVE
@@ -1538,7 +1549,7 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	 * therefore stage2_set_pte() never needs to clear out a huge PMD
 	 * through this calling path.
 	 */
-	stage2_set_pte(kvm, NULL, gpa, pte, 0);
+	stage2_set_pte(kvm, NULL, gpa, &pte, 0);
 	return 0;
 }
 
@@ -1546,17 +1557,16 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, void *data)
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 {
 	unsigned long end = hva + PAGE_SIZE;
-	pte_t stage2_pte;
 
 	if (!kvm->arch.pgd)
 		return;
 
 	trace_kvm_set_spte_hva(hva);
-	stage2_pte = pfn_pte(pte_pfn(pte), PAGE_S2);
-	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
+	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pte);
 }
 
-static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
+static int kvm_age_hva_handler(struct kvm *kvm, struct kvm_memory_slot *slot,
+			       gpa_t gpa, void *data)
 {
 	pmd_t *pmd;
 	pte_t *pte;
@@ -1586,7 +1596,8 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	return 0;
 }
 
-static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
+static int kvm_test_age_hva_handler(struct kvm *kvm, struct kvm_memory_slot *slot,
+				    gpa_t gpa, void *data)
 {
 	pmd_t *pmd;
 	pte_t *pte;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 61505676d0853..af5f0f0eccef9 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -236,8 +236,11 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
 {
 	void *va = page_address(pfn_to_page(pfn));
 
-	if (!vcpu_has_cache_enabled(vcpu) || ipa_uncached)
+	if (!vcpu_has_cache_enabled(vcpu) || ipa_uncached) {
 		kvm_flush_dcache_to_poc(va, size);
+		if (ipa_uncached)
+			set_memory_nc((unsigned long)va, size/PAGE_SIZE);
+	}
 
 	if (!icache_is_aliasing()) {		/* PIPT */
 		flush_icache_range((unsigned long)va,
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index f800d45ea2265..800730f7aa7d9 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -105,6 +105,7 @@
  * Memory types for Stage-2 translation
  */
 #define MT_S2_NORMAL		0xf
+#define MT_S2_NORMAL_NC		0x5
 #define MT_S2_DEVICE_nGnRE	0x1
 
 #ifndef __ASSEMBLY__
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 56283f8a675c5..a254925ce1b6b 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -78,6 +78,7 @@ extern void __pgd_error(const char *file, int line, unsigned long val);
 #define PAGE_HYP_DEVICE		__pgprot(PROT_DEVICE_nGnRE | PTE_HYP)
 
 #define PAGE_S2			__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_NORMAL) | PTE_S2_RDONLY)
+#define PAGE_S2_NORMAL_NC	__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_NORMAL_NC) | PTE_S2_RDONLY)
 #define PAGE_S2_DEVICE		__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_UXN)
 
 #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_TYPE_MASK) | PTE_PROT_NONE | PTE_PXN | PTE_UXN)
-- 
2.1.0
