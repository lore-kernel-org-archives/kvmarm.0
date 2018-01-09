From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v1 03/16] arm64: Make page table helpers reusable
Date: Tue,  9 Jan 2018 19:03:58 +0000
Message-ID: <20180109190414.4017-4-suzuki.poulose@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CA5349DB5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nzHpvy9BtHhj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jan 2018 14:00:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E020549DC6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:12 -0500 (EST)
In-Reply-To: <20180109190414.4017-1-suzuki.poulose@arm.com>
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
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/pgalloc.h | 32 +++++++++++++++++-----
 arch/arm64/include/asm/pgtable.h | 58 +++++++++++++++++++++++++---------------
 2 files changed, 63 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index e9d9f1b006ef..e555b04045d0 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -29,6 +29,28 @@
 #define PGALLOC_GFP	(GFP_KERNEL | __GFP_ZERO)
 #define PGD_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
 
+static inline void __raw_pmd_free(pmd_t *pmd)
+{
+	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
+	free_page((unsigned long)pmd);
+}
+
+static inline void __raw_pud_free(pud_t *pud)
+{
+	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
+	free_page((unsigned long)pud);
+}
+
+static inline void __raw_pgd_populate(pgd_t *pgdp, phys_addr_t pud, pgdval_t prot)
+{
+	__raw_set_pgd(pgdp, __pgd(__phys_to_pgd_val(pud) | prot));
+}
+
+static inline void __raw_pud_populate(pud_t *pud, phys_addr_t pmd, pudval_t prot)
+{
+	__raw_set_pud(pud, __pud(__phys_to_pud_val(pmd) | prot));
+}
+
 #if CONFIG_PGTABLE_LEVELS > 2
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
@@ -38,13 +60,12 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
-	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	free_page((unsigned long)pmd);
+	__raw_pmd_free(pmd);
 }
 
 static inline void __pud_populate(pud_t *pud, phys_addr_t pmd, pudval_t prot)
 {
-	set_pud(pud, __pud(__phys_to_pud_val(pmd) | prot));
+	__raw_pud_populate(pud, pmd, prot);
 }
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
@@ -67,13 +88,12 @@ static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
 {
-	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
-	free_page((unsigned long)pud);
+	__raw_pud_free(pud);
 }
 
 static inline void __pgd_populate(pgd_t *pgdp, phys_addr_t pud, pgdval_t prot)
 {
-	set_pgd(pgdp, __pgd(__phys_to_pgd_val(pud) | prot));
+	__raw_pgd_populate(pgdp, pud, prot);
 }
 
 static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index bfa237e892f1..a5a5203b603d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -464,31 +464,40 @@ static inline phys_addr_t pmd_page_paddr(pmd_t pmd)
  */
 #define mk_pte(page,prot)	pfn_pte(page_to_pfn(page),prot)
 
-#if CONFIG_PGTABLE_LEVELS > 2
-
-#define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd_val(pmd))
 
-#define pud_none(pud)		(!pud_val(pud))
-#define pud_bad(pud)		(!(pud_val(pud) & PUD_TABLE_BIT))
-#define pud_present(pud)	pte_present(pud_pte(pud))
+#define __raw_pud_none(pud)		(!pud_val((pud)))
+#define __raw_pud_bad(pud)		(!(pud_val((pud)) & PUD_TABLE_BIT))
+#define __raw_pud_present(pud)	pte_present(pud_pte((pud)))
 
-static inline void set_pud(pud_t *pudp, pud_t pud)
+static inline void __raw_set_pud(pud_t *pudp, pud_t pud)
 {
 	*pudp = pud;
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
+#define pud_none(pud)		__raw_pud_none((pud))
+#define pud_bad(pud)		__raw_pud_bad((pud))
+#define pud_present(pud)	__raw_pud_present((pud))
+
+#define set_pud(pudp, pud)	__raw_set_pud((pudp), (pud))
+#define pud_clear(pudp)		__raw_pud_clear((pudp))
+#define pud_page_paddr(pud)	__raw_pud_page_paddr((pud))
+
 /* Find an entry in the second-level page table. */
 #define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
 
@@ -517,30 +526,37 @@ static inline phys_addr_t pud_page_paddr(pud_t pud)
 
 #endif	/* CONFIG_PGTABLE_LEVELS > 2 */
 
-#if CONFIG_PGTABLE_LEVELS > 3
-
-#define pud_ERROR(pud)		__pud_error(__FILE__, __LINE__, pud_val(pud))
+#define __raw_pgd_none(pgd)		(!pgd_val((pgd)))
+#define __raw_pgd_bad(pgd)		(!(pgd_val((pgd)) & 2))
+#define __raw_pgd_present(pgd)	(pgd_val((pgd)))
 
-#define pgd_none(pgd)		(!pgd_val(pgd))
-#define pgd_bad(pgd)		(!(pgd_val(pgd) & 2))
-#define pgd_present(pgd)	(pgd_val(pgd))
-
-static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
+static inline void __raw_set_pgd(pgd_t *pgdp, pgd_t pgd)
 {
 	*pgdp = pgd;
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
+#define set_pgd(pgdp, pgd)	__raw_set_pgd((pgdp), (pgd))
+#define pgd_clear(pgdp)		__raw_pgd_clear((pgdp))
+#define pgd_page_paddr(pgd)	__raw_pgd_page_paddr((pgd))
+
 /* Find an entry in the frst-level page table. */
 #define pud_index(addr)		(((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
 
-- 
2.13.6
