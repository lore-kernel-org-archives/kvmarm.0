From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v7 9/9] KVM: arm64: Add support for creating PUD hugepages at stage 2
Date: Mon, 24 Sep 2018 18:45:52 +0100
Message-ID: <20180924174552.8387-10-punit.agrawal@arm.com>
References: <20180924174552.8387-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180924174552.8387-1-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@arm.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>
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
 arch/arm/include/asm/kvm_mmu.h         |  20 +++++
 arch/arm64/include/asm/kvm_mmu.h       |  16 ++++
 arch/arm64/include/asm/pgtable-hwdef.h |   2 +
 arch/arm64/include/asm/pgtable.h       |   2 +
 virt/kvm/arm/mmu.c                     | 108 +++++++++++++++++++++++--
 5 files changed, 143 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index a42b9505c9a7..a8e86b926ee0 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -84,11 +84,14 @@ void kvm_clear_hyp_idmap(void);
 
 #define kvm_pfn_pte(pfn, prot)	pfn_pte(pfn, prot)
 #define kvm_pfn_pmd(pfn, prot)	pfn_pmd(pfn, prot)
+#define kvm_pfn_pud(pfn, prot)	(__pud(0))
 
 #define kvm_pud_pfn(pud)	({ BUG(); 0; })
 
 
 #define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
+/* No support for pud hugepages */
+#define kvm_pud_mkhuge(pud)	(pud)
 
 /*
  * The following kvm_*pud*() functions are provided strictly to allow
@@ -105,6 +108,23 @@ static inline bool kvm_s2pud_readonly(pud_t *pud)
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
+
 static inline bool kvm_s2pud_exec(pud_t *pud)
 {
 	BUG();
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 3baf72705dcc..b4e9c2cceecb 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -184,12 +184,16 @@ void kvm_clear_hyp_idmap(void);
 #define kvm_mk_pgd(pudp)					\
 	__pgd(__phys_to_pgd_val(__pa(pudp)) | PUD_TYPE_TABLE)
 
+#define kvm_set_pud(pudp, pud)		set_pud(pudp, pud)
+
 #define kvm_pfn_pte(pfn, prot)		pfn_pte(pfn, prot)
 #define kvm_pfn_pmd(pfn, prot)		pfn_pmd(pfn, prot)
+#define kvm_pfn_pud(pfn, prot)		pfn_pud(pfn, prot)
 
 #define kvm_pud_pfn(pud)		pud_pfn(pud)
 
 #define kvm_pmd_mkhuge(pmd)		pmd_mkhuge(pmd)
+#define kvm_pud_mkhuge(pud)		pud_mkhuge(pud)
 
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
@@ -203,6 +207,12 @@ static inline pmd_t kvm_s2pmd_mkwrite(pmd_t pmd)
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
@@ -215,6 +225,12 @@ static inline pmd_t kvm_s2pmd_mkexec(pmd_t pmd)
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
index 3ff7ebb262d2..5b8163537bc2 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -115,6 +115,25 @@ static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
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
+static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pudp)
+{
+	if (!stage2_pud_huge(kvm, *pudp))
+		return;
+
+	stage2_pud_clear(kvm, pudp);
+	kvm_tlb_flush_vmid_ipa(kvm, addr);
+	put_page(virt_to_page(pudp));
+}
+
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 				  int min, int max)
 {
@@ -1022,7 +1041,7 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	pmd_t *pmd;
 
 	pud = stage2_get_pud(kvm, cache, addr);
-	if (!pud)
+	if (!pud || stage2_pud_huge(kvm, *pud))
 		return NULL;
 
 	if (stage2_pud_none(kvm, *pud)) {
@@ -1083,6 +1102,36 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 	return 0;
 }
 
+static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+			       phys_addr_t addr, const pud_t *new_pudp)
+{
+	pud_t *pudp, old_pud;
+
+	pudp = stage2_get_pud(kvm, cache, addr);
+	VM_BUG_ON(!pudp);
+
+	old_pud = *pudp;
+
+	/*
+	 * A large number of vcpus faulting on the same stage 2 entry,
+	 * can lead to a refault due to the
+	 * stage2_pud_clear()/tlb_flush(). Skip updating the page
+	 * tables if there is no change.
+	 */
+	if (pud_val(old_pud) == pud_val(*new_pudp))
+		return 0;
+
+	if (stage2_pud_present(kvm, old_pud)) {
+		stage2_pud_clear(kvm, pudp);
+		kvm_tlb_flush_vmid_ipa(kvm, addr);
+	} else {
+		get_page(virt_to_page(pudp));
+	}
+
+	kvm_set_pud(pudp, *new_pudp);
+	return 0;
+}
+
 /*
  * stage2_get_leaf_entry - walk the stage2 VM page tables and return
  * true if a valid and present leaf-entry is found. A pointer to the
@@ -1149,6 +1198,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 			  phys_addr_t addr, const pte_t *new_pte,
 			  unsigned long flags)
 {
+	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte, old_pte;
 	bool iomap = flags & KVM_S2PTE_FLAG_IS_IOMAP;
@@ -1157,7 +1207,31 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	VM_BUG_ON(logging_active && !cache);
 
 	/* Create stage-2 page table mapping - Levels 0 and 1 */
-	pmd = stage2_get_pmd(kvm, cache, addr);
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
+	if (stage2_pud_none(kvm, *pud)) {
+		if (!cache)
+			return 0; /* ignore calls from kvm_set_spte_hva */
+		pmd = mmu_memory_cache_alloc(cache);
+		stage2_pud_populate(kvm, pud, pmd);
+		get_page(virt_to_page(pud));
+	}
+
+	pmd = stage2_pmd_offset(kvm, pud, addr);
 	if (!pmd) {
 		/*
 		 * Ignore calls from kvm_set_spte_hva for unallocated
@@ -1563,9 +1637,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
 		 * Fallback to PTE if it's not one of the Stage 2
@@ -1669,7 +1746,28 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	needs_exec = exec_fault ||
 		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
 
-	if (hugetlb && vma_pagesize == PMD_SIZE) {
+	if (hugetlb && vma_pagesize == PUD_SIZE) {
+		/*
+		 * Assuming that PUD level always exists at Stage 2 -
+		 * this is true for 4k pages with 40 bits IPA
+		 * currently supported.
+		 *
+		 * When using 64k pages, 40bits of IPA results in
+		 * using only 2-levels at Stage 2. Overlooking this
+		 * problem for now as a PUD hugepage with 64k pages is
+		 * too big (4TB) to be practical.
+		 */
+		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
+
+		new_pud = kvm_pud_mkhuge(new_pud);
+		if (writable)
+			new_pud = kvm_s2pud_mkwrite(new_pud);
+
+		if (needs_exec)
+			new_pud = kvm_s2pud_mkexec(new_pud);
+
+		ret = stage2_set_pud_huge(kvm, memcache, fault_ipa, &new_pud);
+	} else if (hugetlb && vma_pagesize == PMD_SIZE) {
 		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
 
 		new_pmd = kvm_pmd_mkhuge(new_pmd);
-- 
2.18.0
