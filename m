From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v5 5/7] KVM: arm64: Support handling access faults for PUD hugepages
Date: Mon,  9 Jul 2018 15:41:22 +0100
Message-ID: <20180709144124.29164-5-punit.agrawal@arm.com>
References: <20180709143835.28971-1-punit.agrawal@arm.com>
 <20180709144124.29164-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180709144124.29164-1-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, will.deacon@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In preparation for creating larger hugepages at Stage 2, extend the
access fault handling at Stage 2 to support PUD hugepages when
encountered.

Provide trivial helpers for arm32 to allow sharing of code.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  8 ++++++++
 arch/arm64/include/asm/kvm_mmu.h |  7 +++++++
 arch/arm64/include/asm/pgtable.h |  6 ++++++
 virt/kvm/arm/mmu.c               | 29 ++++++++++++++++-------------
 4 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index d05c8986e495..a4298d429efc 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -78,6 +78,8 @@ void kvm_clear_hyp_idmap(void);
 #define kvm_pfn_pte(pfn, prot)	pfn_pte(pfn, prot)
 #define kvm_pfn_pmd(pfn, prot)	pfn_pmd(pfn, prot)
 
+#define kvm_pud_pfn(pud)	(((pud_val(pud) & PUD_MASK) & PHYS_MASK) >> PAGE_SHIFT)
+
 #define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
 
 /*
@@ -102,6 +104,12 @@ static inline bool kvm_s2pud_exec(pud_t *pud)
 	return false;
 }
 
+static inline pud_t kvm_s2pud_mkyoung(pud_t pud)
+{
+	BUG();
+	return pud;
+}
+
 static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
 {
 	*pmd = new_pmd;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 15bc1be8f82f..4d2780c588b0 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -175,6 +175,8 @@ void kvm_clear_hyp_idmap(void);
 #define kvm_pfn_pte(pfn, prot)		pfn_pte(pfn, prot)
 #define kvm_pfn_pmd(pfn, prot)		pfn_pmd(pfn, prot)
 
+#define kvm_pud_pfn(pud)		pud_pfn(pud)
+
 #define kvm_pmd_mkhuge(pmd)		pmd_mkhuge(pmd)
 
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
@@ -254,6 +256,11 @@ static inline bool kvm_s2pud_exec(pud_t *pudp)
 	return !(READ_ONCE(pud_val(*pudp)) & PUD_S2_XN);
 }
 
+static inline pud_t kvm_s2pud_mkyoung(pud_t pud)
+{
+	return pud_mkyoung(pud);
+}
+
 static inline bool kvm_page_empty(void *ptr)
 {
 	struct page *ptr_page = virt_to_page(ptr);
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 1bdeca8918a6..a64a5c35beb1 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -314,6 +314,11 @@ static inline pte_t pud_pte(pud_t pud)
 	return __pte(pud_val(pud));
 }
 
+static inline pud_t pte_pud(pte_t pte)
+{
+	return __pud(pte_val(pte));
+}
+
 static inline pmd_t pud_pmd(pud_t pud)
 {
 	return __pmd(pud_val(pud));
@@ -380,6 +385,7 @@ static inline int pmd_protnone(pmd_t pmd)
 #define pfn_pmd(pfn,prot)	__pmd(__phys_to_pmd_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
 
+#define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
 #define pud_write(pud)		pte_write(pud_pte(pud))
 
 #define __pud_to_phys(pud)	__pte_to_phys(pud_pte(pud))
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index e73909a31e02..d2c705e31584 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1637,33 +1637,36 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
  */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
-	pmd_t *pmd;
-	pte_t *pte;
+	pud_t *pud = NULL;
+	pmd_t *pmd = NULL;
+	pte_t *pte = NULL;
 	kvm_pfn_t pfn;
-	bool pfn_valid = false;
+	bool found, pfn_valid = false;
 
 	trace_kvm_access_fault(fault_ipa);
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
-	pmd = stage2_get_pmd(vcpu->kvm, NULL, fault_ipa);
-	if (!pmd || pmd_none(*pmd))	/* Nothing there */
+	found = stage2_get_leaf_entry(vcpu->kvm, fault_ipa, &pud, &pmd, &pte);
+	if (!found)
 		goto out;
 
-	if (pmd_thp_or_huge(*pmd)) {	/* THP, HugeTLB */
+	if (pud) {		/* HugeTLB */
+		*pud = kvm_s2pud_mkyoung(*pud);
+		pfn = kvm_pud_pfn(*pud);
+		pfn_valid = true;
+		goto out;
+	} else 	if (pmd) {	/* THP, HugeTLB */
 		*pmd = pmd_mkyoung(*pmd);
 		pfn = pmd_pfn(*pmd);
 		pfn_valid = true;
 		goto out;
+	} else {
+		*pte = pte_mkyoung(*pte);	/* Just a page... */
+		pfn = pte_pfn(*pte);
+		pfn_valid = true;
 	}
 
-	pte = pte_offset_kernel(pmd, fault_ipa);
-	if (pte_none(*pte))		/* Nothing there either */
-		goto out;
-
-	*pte = pte_mkyoung(*pte);	/* Just a page... */
-	pfn = pte_pfn(*pte);
-	pfn_valid = true;
 out:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	if (pfn_valid)
-- 
2.17.1
