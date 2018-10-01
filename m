From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v8 5/9] KVM: arm64: Support dirty page tracking for PUD hugepages
Date: Mon,  1 Oct 2018 16:54:39 +0100
Message-ID: <20181001155443.23032-6-punit.agrawal@arm.com>
References: <20181001155443.23032-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181001155443.23032-1-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In preparation for creating PUD hugepages at stage 2, add support for
write protecting PUD hugepages when they are encountered. Write
protecting guest tables is used to track dirty pages when migrating
VMs.

Also, provide trivial implementations of required kvm_s2pud_* helpers
to allow sharing of code with arm32.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 15 +++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h | 10 ++++++++++
 virt/kvm/arm/mmu.c               | 11 +++++++----
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index e77212e53e77..9ec09f4cc284 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -87,6 +87,21 @@ void kvm_clear_hyp_idmap(void);
 
 #define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
 
+/*
+ * The following kvm_*pud*() functions are provided strictly to allow
+ * sharing code with arm64. They should never be called in practice.
+ */
+static inline void kvm_set_s2pud_readonly(pud_t *pud)
+{
+	BUG();
+}
+
+static inline bool kvm_s2pud_readonly(pud_t *pud)
+{
+	BUG();
+	return false;
+}
+
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= L_PTE_S2_RDWR;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index baabea0cbb66..3cc342177474 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -251,6 +251,16 @@ static inline bool kvm_s2pmd_exec(pmd_t *pmdp)
 	return !(READ_ONCE(pmd_val(*pmdp)) & PMD_S2_XN);
 }
 
+static inline void kvm_set_s2pud_readonly(pud_t *pudp)
+{
+	kvm_set_s2pte_readonly((pte_t *)pudp);
+}
+
+static inline bool kvm_s2pud_readonly(pud_t *pudp)
+{
+	return kvm_s2pte_readonly((pte_t *)pudp);
+}
+
 #define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
 
 #ifdef __PAGETABLE_PMD_FOLDED
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 21079eb5bc15..9c48f2ca6583 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1347,9 +1347,12 @@ static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd,
 	do {
 		next = stage2_pud_addr_end(kvm, addr, end);
 		if (!stage2_pud_none(kvm, *pud)) {
-			/* TODO:PUD not supported, revisit later if supported */
-			BUG_ON(stage2_pud_huge(kvm, *pud));
-			stage2_wp_pmds(kvm, pud, addr, next);
+			if (stage2_pud_huge(kvm, *pud)) {
+				if (!kvm_s2pud_readonly(pud))
+					kvm_set_s2pud_readonly(pud);
+			} else {
+				stage2_wp_pmds(kvm, pud, addr, next);
+			}
 		}
 	} while (pud++, addr = next, addr != end);
 }
@@ -1392,7 +1395,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
  *
  * Called to start logging dirty pages after memory region
  * KVM_MEM_LOG_DIRTY_PAGES operation is called. After this function returns
- * all present PMD and PTEs are write protected in the memory region.
+ * all present PUD, PMD and PTEs are write protected in the memory region.
  * Afterwards read of dirty page log can be called.
  *
  * Acquires kvm_mmu_lock. Called with kvm->slots_lock mutex acquired,
-- 
2.18.0
