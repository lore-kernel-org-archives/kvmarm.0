From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v6 5/8] KVM: arm64: Support PUD hugepage in stage2_is_exec()
Date: Mon, 16 Jul 2018 12:08:54 +0100
Message-ID: <20180716110857.19310-6-punit.agrawal@arm.com>
References: <20180716110857.19310-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47EED4A110
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 06:57:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SqF7gHcY6zQ8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 06:56:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE9E04A116
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 06:56:58 -0400 (EDT)
In-Reply-To: <20180716110857.19310-1-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, will.deacon@arm.com, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In preparation for creating PUD hugepages at stage 2, add support for
detecting execute permissions on PUD page table entries. Faults due to
lack of execute permissions on page table entries is used to perform
i-cache invalidation on first execute.

Provide trivial implementations of arm32 helpers to allow sharing of
code.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h         |  6 +++
 arch/arm64/include/asm/kvm_mmu.h       |  5 +++
 arch/arm64/include/asm/pgtable-hwdef.h |  2 +
 virt/kvm/arm/mmu.c                     | 53 +++++++++++++++++++++++---
 4 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index c3ac7a76fb69..ec0c58e139da 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -96,6 +96,12 @@ static inline bool kvm_s2pud_readonly(pud_t *pud)
 }
 
 
+static inline bool kvm_s2pud_exec(pud_t *pud)
+{
+	BUG();
+	return false;
+}
+
 static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
 {
 	*pmd = new_pmd;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 84051930ddfe..15bc1be8f82f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -249,6 +249,11 @@ static inline bool kvm_s2pud_readonly(pud_t *pudp)
 	return kvm_s2pte_readonly((pte_t *)pudp);
 }
 
+static inline bool kvm_s2pud_exec(pud_t *pudp)
+{
+	return !(READ_ONCE(pud_val(*pudp)) & PUD_S2_XN);
+}
+
 static inline bool kvm_page_empty(void *ptr)
 {
 	struct page *ptr_page = virt_to_page(ptr);
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index fd208eac9f2a..10ae592b78b8 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -193,6 +193,8 @@
 #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
 #define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
 
+#define PUD_S2_XN		(_AT(pudval_t, 2) << 53)  /* XN[1:0] */
+
 /*
  * Memory Attribute override for Stage-2 (MemAttr[3:0])
  */
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ed8f8271c389..3839d0e3766d 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1038,23 +1038,66 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 	return 0;
 }
 
-static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
+/*
+ * stage2_get_leaf_entry - walk the stage2 VM page tables and return
+ * true if a valid and present leaf-entry is found. A pointer to the
+ * leaf-entry is returned in the appropriate level variable - pudpp,
+ * pmdpp, ptepp.
+ */
+static bool stage2_get_leaf_entry(struct kvm *kvm, phys_addr_t addr,
+				  pud_t **pudpp, pmd_t **pmdpp, pte_t **ptepp)
 {
+	pud_t *pudp;
 	pmd_t *pmdp;
 	pte_t *ptep;
 
-	pmdp = stage2_get_pmd(kvm, NULL, addr);
+	*pudpp = NULL;
+	*pmdpp = NULL;
+	*ptepp = NULL;
+
+	pudp = stage2_get_pud(kvm, NULL, addr);
+	if (!pudp || pud_none(*pudp) || !pud_present(*pudp))
+		return false;
+
+	if (pud_huge(*pudp)) {
+		*pudpp = pudp;
+		return true;
+	}
+
+	pmdp = stage2_pmd_offset(pudp, addr);
 	if (!pmdp || pmd_none(*pmdp) || !pmd_present(*pmdp))
 		return false;
 
-	if (pmd_thp_or_huge(*pmdp))
-		return kvm_s2pmd_exec(pmdp);
+	if (pmd_thp_or_huge(*pmdp)) {
+		*pmdpp = pmdp;
+		return true;
+	}
 
 	ptep = pte_offset_kernel(pmdp, addr);
 	if (!ptep || pte_none(*ptep) || !pte_present(*ptep))
 		return false;
 
-	return kvm_s2pte_exec(ptep);
+	*ptepp = ptep;
+	return true;
+}
+
+static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
+{
+	pud_t *pudp;
+	pmd_t *pmdp;
+	pte_t *ptep;
+	bool found;
+
+	found = stage2_get_leaf_entry(kvm, addr, &pudp, &pmdp, &ptep);
+	if (!found)
+		return false;
+
+	if (pudp)
+		return kvm_s2pud_exec(pudp);
+	else if (pmdp)
+		return kvm_s2pmd_exec(pmdp);
+	else
+		return kvm_s2pte_exec(ptep);
 }
 
 static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
-- 
2.17.1
