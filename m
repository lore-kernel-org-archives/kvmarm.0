From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v5 3/7] KVM: arm64: Support dirty page tracking for PUD hugepages
Date: Mon,  9 Jul 2018 15:41:20 +0100
Message-ID: <20180709144124.29164-3-punit.agrawal@arm.com>
References: <20180709143835.28971-1-punit.agrawal@arm.com>
 <20180709144124.29164-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180709144124.29164-1-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, will.deacon@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In preparation for creating PUD hugepages at stage 2, add support for
write protecting PUD hugepages when they are encountered. Write
protecting guest tables is used to track dirty pages when migrating
VMs.

Also, provide trivial implementations of required kvm_s2pud_* helpers
to allow sharing of code with arm32.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 16 ++++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h | 10 ++++++++++
 virt/kvm/arm/mmu.c               | 11 +++++++----
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index d095c2d0b284..c23722f75d5c 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -80,6 +80,22 @@ void kvm_clear_hyp_idmap(void);
 
 #define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
 
+/*
+ * The following kvm_*pud*() functionas are provided strictly to allow
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
+
 static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
 {
 	*pmd = new_pmd;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 689def9bb9d5..84051930ddfe 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -239,6 +239,16 @@ static inline bool kvm_s2pmd_exec(pmd_t *pmdp)
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
 static inline bool kvm_page_empty(void *ptr)
 {
 	struct page *ptr_page = virt_to_page(ptr);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index e131b7f9b7d7..ed8f8271c389 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1288,9 +1288,12 @@ static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
 	do {
 		next = stage2_pud_addr_end(addr, end);
 		if (!stage2_pud_none(*pud)) {
-			/* TODO:PUD not supported, revisit later if supported */
-			BUG_ON(stage2_pud_huge(*pud));
-			stage2_wp_pmds(pud, addr, next);
+			if (stage2_pud_huge(*pud)) {
+				if (!kvm_s2pud_readonly(pud))
+					kvm_set_s2pud_readonly(pud);
+			} else {
+				stage2_wp_pmds(pud, addr, next);
+			}
 		}
 	} while (pud++, addr = next, addr != end);
 }
@@ -1333,7 +1336,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
  *
  * Called to start logging dirty pages after memory region
  * KVM_MEM_LOG_DIRTY_PAGES operation is called. After this function returns
- * all present PMD and PTEs are write protected in the memory region.
+ * all present PUD, PMD and PTEs are write protected in the memory region.
  * Afterwards read of dirty page log can be called.
  *
  * Acquires kvm_mmu_lock. Called with kvm->slots_lock mutex acquired,
-- 
2.17.1
