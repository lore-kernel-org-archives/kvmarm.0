From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v4 7/7] KVM: arm64: Add support for creating PUD hugepages at stage 2
Date: Thu,  5 Jul 2018 15:08:50 +0100
Message-ID: <20180705140850.5801-8-punit.agrawal@arm.com>
References: <20180705140850.5801-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180705140850.5801-1-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

KVM only supports PMD hugepages at stage 2. Now that the various page
handling routines are updated, extend the stage 2 fault handling to
map in PUD hugepages.

Addition of PUD hugepage support enables additional page sizes (e.g.,
1G with 4K granule) which can be useful on cores that support mapping
larger block sizes in the TLB entries.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h         | 19 +++++++
 arch/arm64/include/asm/kvm_mmu.h       | 15 +++++
 arch/arm64/include/asm/pgtable-hwdef.h |  2 +
 arch/arm64/include/asm/pgtable.h       |  2 +
 virt/kvm/arm/mmu.c                     | 78 ++++++++++++++++++++++++--
 5 files changed, 112 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 8e1e8aee229e..787baf9ec994 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -77,10 +77,13 @@ void kvm_clear_hyp_idmap(void);
 
 #define kvm_pfn_pte(pfn, prot)	pfn_pte(pfn, prot)
 #define kvm_pfn_pmd(pfn, prot)	pfn_pmd(pfn, prot)
+#define kvm_pfn_pud(pfn, prot)	(__pud(0))
 
 #define kvm_pud_pfn(pud)	(((pud_val(pud) & PUD_MASK) & PHYS_MASK) >> PAGE_SHIFT)
 
 #define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
+/* No support for pud hugepages */
+#define kvm_pud_mkhuge(pud)	(pud)
 
 /*
  * The following kvm_*pud*() functionas are provided strictly to allow
@@ -97,6 +100,22 @@ static inline bool kvm_s2pud_readonly(pud_t *pud)
 	return false;
 }
 
+static inline void kvm_set_pud(pud_t *pud, pud_t new_pud)
+{
+	BUG();
+}
+
+static inline pud_t kvm_s2pud_mkwrite(pud_t pud)
+{
+	BUG();
+	return pud;
+}
+
+static inline pud_t kvm_s2pud_mkexec(pud_t pud)
+{
+	BUG();
+	return pud;
+}
 
 static inline bool kvm_s2pud_exec(pud_t *pud)
 {
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index c542052fb199..dd8a23159463 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -171,13 +171,16 @@ void kvm_clear_hyp_idmap(void);
 
 #define	kvm_set_pte(ptep, pte)		set_pte(ptep, pte)
 #define	kvm_set_pmd(pmdp, pmd)		set_pmd(pmdp, pmd)
+#define kvm_set_pud(pudp, pud)		set_pud(pudp, pud)
 
 #define kvm_pfn_pte(pfn, prot)		pfn_pte(pfn, prot)
 #define kvm_pfn_pmd(pfn, prot)		pfn_pmd(pfn, prot)
+#define kvm_pfn_pud(pfn, prot)		pfn_pud(pfn, prot)
 
 #define kvm_pud_pfn(pud)		pud_pfn(pud)
 
 #define kvm_pmd_mkhuge(pmd)		pmd_mkhuge(pmd)
+#define kvm_pud_mkhuge(pud)		pud_mkhuge(pud)
 
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
@@ -191,6 +194,12 @@ static inline pmd_t kvm_s2pmd_mkwrite(pmd_t pmd)
 	return pmd;
 }
 
+static inline pud_t kvm_s2pud_mkwrite(pud_t pud)
+{
+	pud_val(pud) |= PUD_S2_RDWR;
+	return pud;
+}
+
 static inline pte_t kvm_s2pte_mkexec(pte_t pte)
 {
 	pte_val(pte) &= ~PTE_S2_XN;
@@ -203,6 +212,12 @@ static inline pmd_t kvm_s2pmd_mkexec(pmd_t pmd)
 	return pmd;
 }
 
+static inline pud_t kvm_s2pud_mkexec(pud_t pud)
+{
+	pud_val(pud) &= ~PUD_S2_XN;
+	return pud;
+}
+
 static inline void kvm_set_s2pte_readonly(pte_t *ptep)
 {
 	pteval_t old_pteval, pteval;
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 10ae592b78b8..e327665e94d1 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -193,6 +193,8 @@
 #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
 #define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
 
+#define PUD_S2_RDONLY		(_AT(pudval_t, 1) << 6)   /* HAP[2:1] */
+#define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
 #define PUD_S2_XN		(_AT(pudval_t, 2) << 53)  /* XN[1:0] */
 
 /*
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4d9476e420d9..0afc34f94ff5 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -389,6 +389,8 @@ static inline int pmd_protnone(pmd_t pmd)
 #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
 #define pud_write(pud)		pte_write(pud_pte(pud))
 
+#define pud_mkhuge(pud)		(__pud(pud_val(pud) & ~PUD_TABLE_BIT))
+
 #define __pud_to_phys(pud)	__pte_to_phys(pud_pte(pud))
 #define __phys_to_pud_val(phys)	__phys_to_pte_val(phys)
 #define pud_pfn(pud)		((__pud_to_phys(pud) & PUD_MASK) >> PAGE_SHIFT)
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0c04c64e858c..5912210e94d9 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -116,6 +116,25 @@ static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
 	put_page(virt_to_page(pmd));
 }
 
+/**
+ * stage2_dissolve_pud() - clear and flush huge PUD entry
+ * @kvm:	pointer to kvm structure.
+ * @addr:	IPA
+ * @pud:	pud pointer for IPA
+ *
+ * Function clears a PUD entry, flushes addr 1st and 2nd stage TLBs. Marks all
+ * pages in the range dirty.
+ */
+static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pud)
+{
+	if (!pud_huge(*pud))
+		return;
+
+	pud_clear(pud);
+	kvm_tlb_flush_vmid_ipa(kvm, addr);
+	put_page(virt_to_page(pud));
+}
+
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 				  int min, int max)
 {
@@ -993,7 +1012,7 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	pmd_t *pmd;
 
 	pud = stage2_get_pud(kvm, cache, addr);
-	if (!pud)
+	if (!pud || pud_huge(*pud))
 		return NULL;
 
 	if (stage2_pud_none(*pud)) {
@@ -1038,6 +1057,26 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 	return 0;
 }
 
+static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+			       phys_addr_t addr, const pud_t *new_pud)
+{
+	pud_t *pud, old_pud;
+
+	pud = stage2_get_pud(kvm, cache, addr);
+	VM_BUG_ON(!pud);
+
+	old_pud = *pud;
+	if (pud_present(old_pud)) {
+		pud_clear(pud);
+		kvm_tlb_flush_vmid_ipa(kvm, addr);
+	} else {
+		get_page(virt_to_page(pud));
+	}
+
+	kvm_set_pud(pud, *new_pud);
+	return 0;
+}
+
 static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
 {
 	pud_t *pudp;
@@ -1069,6 +1108,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 			  phys_addr_t addr, const pte_t *new_pte,
 			  unsigned long flags)
 {
+	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte, old_pte;
 	bool iomap = flags & KVM_S2PTE_FLAG_IS_IOMAP;
@@ -1077,6 +1117,22 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	VM_BUG_ON(logging_active && !cache);
 
 	/* Create stage-2 page table mapping - Levels 0 and 1 */
+	pud = stage2_get_pud(kvm, cache, addr);
+	if (!pud) {
+		/*
+		 * Ignore calls from kvm_set_spte_hva for unallocated
+		 * address ranges.
+		 */
+		return 0;
+	}
+
+	/*
+	 * While dirty page logging - dissolve huge PUD, then continue
+	 * on to allocate page.
+	 */
+	if (logging_active)
+		stage2_dissolve_pud(kvm, addr, pud);
+
 	pmd = stage2_get_pmd(kvm, cache, addr);
 	if (!pmd) {
 		/*
@@ -1483,9 +1539,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	vma_pagesize = vma_kernel_pagesize(vma);
-	if (vma_pagesize == PMD_SIZE && !logging_active) {
+	if ((vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) &&
+	    !logging_active) {
+		struct hstate *h = hstate_vma(vma);
+
 		hugetlb = true;
-		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
+		gfn = (fault_ipa & huge_page_mask(h)) >> PAGE_SHIFT;
 	} else {
 		/*
 		 * Pages belonging to memslots that don't have the same
@@ -1572,7 +1631,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault)
 		invalidate_icache_guest_page(pfn, vma_pagesize);
 
-	if (hugetlb && vma_pagesize == PMD_SIZE) {
+	if (hugetlb && vma_pagesize == PUD_SIZE) {
+		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
+
+		new_pud = kvm_pud_mkhuge(new_pud);
+		if (writable)
+			new_pud = kvm_s2pud_mkwrite(new_pud);
+
+		if (stage2_should_exec(kvm, fault_ipa, exec_fault, fault_status))
+			new_pud = kvm_s2pud_mkexec(new_pud);
+
+		ret = stage2_set_pud_huge(kvm, memcache, fault_ipa, &new_pud);
+	} else if (hugetlb && vma_pagesize == PMD_SIZE) {
 		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
 
 		new_pmd = kvm_pmd_mkhuge(new_pmd);
-- 
2.17.1
