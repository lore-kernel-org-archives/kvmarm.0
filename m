From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v10 7/8] KVM: arm64: Update age handlers to support PUD
 hugepages
Date: Tue, 11 Dec 2018 17:10:40 +0000
Message-ID: <1544548241-6417-8-git-send-email-suzuki.poulose@arm.com>
References: <1544548241-6417-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CC784A374
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 12:12:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GCiJCXB4SQlQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 12:12:20 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB5904A348
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 12:12:20 -0500 (EST)
In-Reply-To: <1544548241-6417-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, anshuman.khandual@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Punit Agrawal <punit.agrawal@arm.com>

In preparation for creating larger hugepages at Stage 2, add support
to the age handling notifiers for PUD hugepages when encountered.

Provide trivial helpers for arm32 to allow sharing code.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
[ Replaced BUG() => WARN_ON(1) for arm32 PUD helpers ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  6 ++++++
 arch/arm64/include/asm/kvm_mmu.h |  5 +++++
 arch/arm64/include/asm/pgtable.h |  1 +
 virt/kvm/arm/mmu.c               | 39 ++++++++++++++++++++-------------------
 4 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 3a40720..4b4b214 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -117,6 +117,12 @@ static inline pud_t kvm_s2pud_mkyoung(pud_t pud)
 	return pud;
 }
 
+static inline bool kvm_s2pud_young(pud_t pud)
+{
+	WARN_ON(1);
+	return false;
+}
+
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= L_PTE_S2_RDWR;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 612032b..9f941f7 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -273,6 +273,11 @@ static inline pud_t kvm_s2pud_mkyoung(pud_t pud)
 	return pud_mkyoung(pud);
 }
 
+static inline bool kvm_s2pud_young(pud_t pud)
+{
+	return pud_young(pud);
+}
+
 #define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
 
 #ifdef __PAGETABLE_PMD_FOLDED
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f51e227..bb0f3f1 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -386,6 +386,7 @@ static inline int pmd_protnone(pmd_t pmd)
 #define pfn_pmd(pfn,prot)	__pmd(__phys_to_pmd_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
 
+#define pud_young(pud)		pte_young(pud_pte(pud))
 #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
 #define pud_write(pud)		pte_write(pud_pte(pud))
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index bd74960..3893ea6 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1225,6 +1225,11 @@ static int stage2_pmdp_test_and_clear_young(pmd_t *pmd)
 	return stage2_ptep_test_and_clear_young((pte_t *)pmd);
 }
 
+static int stage2_pudp_test_and_clear_young(pud_t *pud)
+{
+	return stage2_ptep_test_and_clear_young((pte_t *)pud);
+}
+
 /**
  * kvm_phys_addr_ioremap - map a device range to guest IPA
  *
@@ -1932,42 +1937,38 @@ void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 
 static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
+	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
-	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
-	pmd = stage2_get_pmd(kvm, NULL, gpa);
-	if (!pmd || pmd_none(*pmd))	/* Nothing there */
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
+	if (!stage2_get_leaf_entry(kvm, gpa, &pud, &pmd, &pte))
 		return 0;
 
-	if (pmd_thp_or_huge(*pmd))	/* THP, HugeTLB */
+	if (pud)
+		return stage2_pudp_test_and_clear_young(pud);
+	else if (pmd)
 		return stage2_pmdp_test_and_clear_young(pmd);
-
-	pte = pte_offset_kernel(pmd, gpa);
-	if (pte_none(*pte))
-		return 0;
-
-	return stage2_ptep_test_and_clear_young(pte);
+	else
+		return stage2_ptep_test_and_clear_young(pte);
 }
 
 static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
+	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
-	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
-	pmd = stage2_get_pmd(kvm, NULL, gpa);
-	if (!pmd || pmd_none(*pmd))	/* Nothing there */
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
+	if (!stage2_get_leaf_entry(kvm, gpa, &pud, &pmd, &pte))
 		return 0;
 
-	if (pmd_thp_or_huge(*pmd))		/* THP, HugeTLB */
+	if (pud)
+		return kvm_s2pud_young(*pud);
+	else if (pmd)
 		return pmd_young(*pmd);
-
-	pte = pte_offset_kernel(pmd, gpa);
-	if (!pte_none(*pte))		/* Just a page... */
+	else
 		return pte_young(*pte);
-
-	return 0;
 }
 
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
-- 
2.7.4
