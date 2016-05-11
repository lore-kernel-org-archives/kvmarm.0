From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 13/29] kvm-arm: Add stage2 page table modifiers
Date: Wed, 11 May 2016 15:30:06 +0200
Message-ID: <1462973422-10021-14-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Now that the hyp page table is handled by different set of
routines, rename the original shared routines to stage2 handlers.
Also make explicit use of the stage2 page table helpers.

unmap_range has been merged to existing unmap_stage2_range.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c | 97 +++++++++++++++++++++++++-----------------------------
 1 file changed, 44 insertions(+), 53 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index af526f6..f2a6d9b 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -152,26 +152,26 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 	return p;
 }
 
-static void clear_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr)
+static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr)
 {
-	pud_t *pud_table __maybe_unused = pud_offset(pgd, 0);
-	pgd_clear(pgd);
+	pud_t *pud_table __maybe_unused = stage2_pud_offset(pgd, 0UL);
+	stage2_pgd_clear(pgd);
 	kvm_tlb_flush_vmid_ipa(kvm, addr);
-	pud_free(NULL, pud_table);
+	stage2_pud_free(pud_table);
 	put_page(virt_to_page(pgd));
 }
 
-static void clear_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr)
+static void clear_stage2_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr)
 {
-	pmd_t *pmd_table = pmd_offset(pud, 0);
-	VM_BUG_ON(pud_huge(*pud));
-	pud_clear(pud);
+	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(pud, 0);
+	VM_BUG_ON(stage2_pud_huge(*pud));
+	stage2_pud_clear(pud);
 	kvm_tlb_flush_vmid_ipa(kvm, addr);
-	pmd_free(NULL, pmd_table);
+	stage2_pmd_free(pmd_table);
 	put_page(virt_to_page(pud));
 }
 
-static void clear_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr)
+static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr)
 {
 	pte_t *pte_table = pte_offset_kernel(pmd, 0);
 	VM_BUG_ON(pmd_thp_or_huge(*pmd));
@@ -201,7 +201,7 @@ static void clear_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr)
  * the corresponding TLBs, we call kvm_flush_dcache_p*() to make sure
  * the IO subsystem will never hit in the cache.
  */
-static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
+static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 		       phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t start_addr = addr;
@@ -223,19 +223,19 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
-	if (kvm_pte_table_empty(kvm, start_pte))
-		clear_pmd_entry(kvm, pmd, start_addr);
+	if (stage2_pte_table_empty(start_pte))
+		clear_stage2_pmd_entry(kvm, pmd, start_addr);
 }
 
-static void unmap_pmds(struct kvm *kvm, pud_t *pud,
+static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
 		       phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t next, start_addr = addr;
 	pmd_t *pmd, *start_pmd;
 
-	start_pmd = pmd = pmd_offset(pud, addr);
+	start_pmd = pmd = stage2_pmd_offset(pud, addr);
 	do {
-		next = kvm_pmd_addr_end(addr, end);
+		next = stage2_pmd_addr_end(addr, end);
 		if (!pmd_none(*pmd)) {
 			if (pmd_thp_or_huge(*pmd)) {
 				pmd_t old_pmd = *pmd;
@@ -247,57 +247,64 @@ static void unmap_pmds(struct kvm *kvm, pud_t *pud,
 
 				put_page(virt_to_page(pmd));
 			} else {
-				unmap_ptes(kvm, pmd, addr, next);
+				unmap_stage2_ptes(kvm, pmd, addr, next);
 			}
 		}
 	} while (pmd++, addr = next, addr != end);
 
-	if (kvm_pmd_table_empty(kvm, start_pmd))
-		clear_pud_entry(kvm, pud, start_addr);
+	if (stage2_pmd_table_empty(start_pmd))
+		clear_stage2_pud_entry(kvm, pud, start_addr);
 }
 
-static void unmap_puds(struct kvm *kvm, pgd_t *pgd,
+static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
 		       phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t next, start_addr = addr;
 	pud_t *pud, *start_pud;
 
-	start_pud = pud = pud_offset(pgd, addr);
+	start_pud = pud = stage2_pud_offset(pgd, addr);
 	do {
-		next = kvm_pud_addr_end(addr, end);
-		if (!pud_none(*pud)) {
-			if (pud_huge(*pud)) {
+		next = stage2_pud_addr_end(addr, end);
+		if (!stage2_pud_none(*pud)) {
+			if (stage2_pud_huge(*pud)) {
 				pud_t old_pud = *pud;
 
-				pud_clear(pud);
+				stage2_pud_clear(pud);
 				kvm_tlb_flush_vmid_ipa(kvm, addr);
-
 				kvm_flush_dcache_pud(old_pud);
-
 				put_page(virt_to_page(pud));
 			} else {
-				unmap_pmds(kvm, pud, addr, next);
+				unmap_stage2_pmds(kvm, pud, addr, next);
 			}
 		}
 	} while (pud++, addr = next, addr != end);
 
-	if (kvm_pud_table_empty(kvm, start_pud))
-		clear_pgd_entry(kvm, pgd, start_addr);
+	if (stage2_pud_table_empty(start_pud))
+		clear_stage2_pgd_entry(kvm, pgd, start_addr);
 }
 
-
-static void unmap_range(struct kvm *kvm, pgd_t *pgdp,
-			phys_addr_t start, u64 size)
+/**
+ * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
+ * @kvm:   The VM pointer
+ * @start: The intermediate physical base address of the range to unmap
+ * @size:  The size of the area to unmap
+ *
+ * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
+ * be called while holding mmu_lock (unless for freeing the stage2 pgd before
+ * destroying the VM), otherwise another faulting VCPU may come in and mess
+ * with things behind our backs.
+ */
+static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 {
 	pgd_t *pgd;
 	phys_addr_t addr = start, end = start + size;
 	phys_addr_t next;
 
-	pgd = pgdp + kvm_pgd_index(addr);
+	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
 	do {
-		next = kvm_pgd_addr_end(addr, end);
-		if (!pgd_none(*pgd))
-			unmap_puds(kvm, pgd, addr, next);
+		next = stage2_pgd_addr_end(addr, end);
+		if (!stage2_pgd_none(*pgd))
+			unmap_stage2_puds(kvm, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
@@ -792,22 +799,6 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 	return 0;
 }
 
-/**
- * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
- * @kvm:   The VM pointer
- * @start: The intermediate physical base address of the range to unmap
- * @size:  The size of the area to unmap
- *
- * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
- * be called while holding mmu_lock (unless for freeing the stage2 pgd before
- * destroying the VM), otherwise another faulting VCPU may come in and mess
- * with things behind our backs.
- */
-static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
-{
-	unmap_range(kvm, kvm->arch.pgd, start, size);
-}
-
 static void stage2_unmap_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
-- 
2.1.2.330.g565301e.dirty

