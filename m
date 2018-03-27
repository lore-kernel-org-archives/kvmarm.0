From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 03/17] arm64: Make page table helpers reusable
Date: Tue, 27 Mar 2018 14:15:13 +0100
Message-ID: <1522156531-28348-4-git-send-email-suzuki.poulose@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A0B749FC7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 09:08:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GNU3LWRhnJnA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Mar 2018 09:08:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A0CF49D6B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 09:08:02 -0400 (EDT)
In-Reply-To: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This patch rearranges the page table level helpers so that it can
be reused for a page table with different number of levels
(e.g, stage2 page table for a VM) than the kernel page tables.
As such there is no functional change with this patch.

The page table helpers are defined to do the right thing for the
fixed page table levels set for the kernel. This patch tries to
refactor the code such that, we can have helpers for each level,
which should be used when the caller knows that the level exists
for the page table dealt with. Since the kernel defines helpers
p.d_action and __p.d_action, for consistency, we name the raw
page table action helpers __raw_p.d_action.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/pgalloc.h | 34 +++++++++++++++++++----
 arch/arm64/include/asm/pgtable.h | 60 +++++++++++++++++++++++++---------------
 2 files changed, 66 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 2e05bcd..ab4662c 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -29,6 +29,30 @@
 #define PGALLOC_GFP	(GFP_KERNEL | __GFP_ZERO)
 #define PGD_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
 
+static inline void __raw_pmd_free(pmd_t *pmdp)
+{
+	BUG_ON((unsigned long)pmdp & (PAGE_SIZE-1));
+	free_page((unsigned long)pmdp);
+}
+
+static inline void
+__raw_pud_populate(pud_t *pudp, phys_addr_t pmdp, pudval_t prot)
+{
+	__raw_set_pud(pudp, __pud(__phys_to_pud_val(pmdp) | prot));
+}
+
+static inline void __raw_pud_free(pud_t *pudp)
+{
+	BUG_ON((unsigned long)pudp & (PAGE_SIZE-1));
+	free_page((unsigned long)pudp);
+}
+
+static inline void
+__raw_pgd_populate(pgd_t *pgdp, phys_addr_t pudp, pgdval_t prot)
+{
+	__raw_set_pgd(pgdp, __pgd(__phys_to_pgd_val(pudp) | prot));
+}
+
 #if CONFIG_PGTABLE_LEVELS > 2
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
@@ -38,13 +62,12 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmdp)
 {
-	BUG_ON((unsigned long)pmdp & (PAGE_SIZE-1));
-	free_page((unsigned long)pmdp);
+	__raw_pmd_free(pmdp);
 }
 
 static inline void __pud_populate(pud_t *pudp, phys_addr_t pmdp, pudval_t prot)
 {
-	set_pud(pudp, __pud(__phys_to_pud_val(pmdp) | prot));
+	__raw_pud_populate(pudp, pmdp, prot);
 }
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmdp)
@@ -67,13 +90,12 @@ static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pudp)
 {
-	BUG_ON((unsigned long)pudp & (PAGE_SIZE-1));
-	free_page((unsigned long)pudp);
+	__raw_pud_free(pudp);
 }
 
 static inline void __pgd_populate(pgd_t *pgdp, phys_addr_t pudp, pgdval_t prot)
 {
-	set_pgd(pgdp, __pgd(__phys_to_pgd_val(pudp) | prot));
+	__raw_pgd_populate(pgdp, pudp, prot);
 }
 
 static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgdp, pud_t *pudp)
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 7e2c27e..5e22503 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -475,31 +475,39 @@ static inline phys_addr_t pmd_page_paddr(pmd_t pmd)
  */
 #define mk_pte(page,prot)	pfn_pte(page_to_pfn(page),prot)
 
-#if CONFIG_PGTABLE_LEVELS > 2
+#define __raw_pud_none(pud)	(!pud_val(pud))
+#define __raw_pud_bad(pud)	(!(pud_val(pud) & PUD_TABLE_BIT))
+#define __raw_pud_present(pud)	pte_present(pud_pte(pud))
 
-#define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd_val(pmd))
-
-#define pud_none(pud)		(!pud_val(pud))
-#define pud_bad(pud)		(!(pud_val(pud) & PUD_TABLE_BIT))
-#define pud_present(pud)	pte_present(pud_pte(pud))
-
-static inline void set_pud(pud_t *pudp, pud_t pud)
+static inline void __raw_set_pud(pud_t *pudp, pud_t pud)
 {
 	WRITE_ONCE(*pudp, pud);
 	dsb(ishst);
 	isb();
 }
 
-static inline void pud_clear(pud_t *pudp)
+static inline void __raw_pud_clear(pud_t *pudp)
 {
-	set_pud(pudp, __pud(0));
+	__raw_set_pud(pudp, __pud(0));
 }
 
-static inline phys_addr_t pud_page_paddr(pud_t pud)
+static inline phys_addr_t __raw_pud_page_paddr(pud_t pud)
 {
 	return __pud_to_phys(pud);
 }
 
+#if CONFIG_PGTABLE_LEVELS > 2
+
+#define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd_val(pmd))
+
+#define pud_none(pud)		__raw_pud_none(pud)
+#define pud_bad(pud)		__raw_pud_bad(pud)
+#define pud_present(pud)	__raw_pud_present(pud)
+
+#define set_pud(pudp, pud)	__raw_set_pud((pudp), (pud))
+#define pud_clear(pudp)		__raw_pud_clear((pudp))
+#define pud_page_paddr(pud)	__raw_pud_page_paddr((pud))
+
 /* Find an entry in the second-level page table. */
 #define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
 
@@ -528,30 +536,38 @@ static inline phys_addr_t pud_page_paddr(pud_t pud)
 
 #endif	/* CONFIG_PGTABLE_LEVELS > 2 */
 
-#if CONFIG_PGTABLE_LEVELS > 3
+#define __raw_pgd_none(pgd)	(!pgd_val(pgd))
+#define __raw_pgd_bad(pgd)	(!(pgd_val(pgd) & 2))
+#define __raw_pgd_present(pgd)	(pgd_val(pgd))
 
-#define pud_ERROR(pud)		__pud_error(__FILE__, __LINE__, pud_val(pud))
-
-#define pgd_none(pgd)		(!pgd_val(pgd))
-#define pgd_bad(pgd)		(!(pgd_val(pgd) & 2))
-#define pgd_present(pgd)	(pgd_val(pgd))
-
-static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
+static inline void __raw_set_pgd(pgd_t *pgdp, pgd_t pgd)
 {
 	WRITE_ONCE(*pgdp, pgd);
 	dsb(ishst);
 }
 
-static inline void pgd_clear(pgd_t *pgdp)
+static inline void __raw_pgd_clear(pgd_t *pgdp)
 {
-	set_pgd(pgdp, __pgd(0));
+	__raw_set_pgd(pgdp, __pgd(0));
 }
 
-static inline phys_addr_t pgd_page_paddr(pgd_t pgd)
+static inline phys_addr_t __raw_pgd_page_paddr(pgd_t pgd)
 {
 	return __pgd_to_phys(pgd);
 }
 
+#if CONFIG_PGTABLE_LEVELS > 3
+
+#define pud_ERROR(pud)		__pud_error(__FILE__, __LINE__, pud_val(pud))
+
+#define pgd_none(pgd)		__raw_pgd_none((pgd))
+#define pgd_bad(pgd)		__raw_pgd_bad((pgd))
+#define pgd_present(pgd)	__raw_pgd_present((pgd))
+
+#define set_pgd(pgdp, pgd)	__raw_set_pgd((pgdp), (pgd))
+#define pgd_clear(pgdp)		__raw_pgd_clear((pgdp))
+#define pgd_page_paddr(pgd)	__raw_pgd_page_paddr((pgd))
+
 /* Find an entry in the frst-level page table. */
 #define pud_index(addr)		(((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
 
-- 
2.7.4
