From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC PATCH 08/12] kvm: arm64: Introduce stage2 page table helpers
Date: Mon, 14 Mar 2016 16:53:07 +0000
Message-ID: <1457974391-28456-9-git-send-email-suzuki.poulose@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F7B6411E3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 02RFb596bJYp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2016 12:53:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55DB049B79
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:16 -0400 (EDT)
In-Reply-To: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Introduce arm64 kvm wrappers for page table walkers and the corresponding
stage2 table helpers. On arm64 we could have different number of page
table levels for hyp and stage2 translations. Hence, the wrapper
switches between hyp vs. stage2 depending on the 'kvm' instance passed
to it. For now, stage2 helpers fall back to that of the host, since we
still have fake page table levels to match the page table levels with
that of the host. The hypervisor code will switch to using the kvm_
wrappers in subsequent patches.

All the stage2 table related definitions are moved to asm/stage2_pgtable.h.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h        |  148 ++++++++++++++++++++++---------
 arch/arm64/include/asm/stage2_pgtable.h |   85 ++++++++++++++++++
 2 files changed, 193 insertions(+), 40 deletions(-)
 create mode 100644 arch/arm64/include/asm/stage2_pgtable.h

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 416ca23..55cde87 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -82,6 +82,8 @@
 #define KVM_PHYS_SIZE	(1UL << KVM_PHYS_SHIFT)
 #define KVM_PHYS_MASK	(KVM_PHYS_SIZE - 1UL)
 
+#include <asm/stage2_pgtable.h>
+
 int create_hyp_mappings(void *from, void *to);
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
 void free_boot_hyp_pgd(void);
@@ -144,59 +146,114 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 
 static inline int kvm_pud_huge(struct kvm *kvm, pud_t pud)
 {
-	return pud_huge(pud);
+	return kvm ? stage2_pud_huge(pud) : pud_huge(pud);
+}
+
+static inline int kvm_pgd_none(struct kvm *kvm, pgd_t pgd)
+{
+	return kvm ? stage2_pgd_none(pgd) : pgd_none(pgd);
+}
+
+static inline void kvm_pgd_clear(struct kvm *kvm, pgd_t *pgdp)
+{
+	if (kvm)
+		stage2_pgd_clear(pgdp);
+	else
+		pgd_clear(pgdp);
+}
+
+static inline int kvm_pgd_present(struct kvm *kvm, pgd_t pgd)
+{
+	return kvm ? stage2_pgd_present(pgd) : pgd_present(pgd);
+}
+
+static inline void
+kvm_pgd_populate(struct kvm *kvm, struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
+{
+	if (kvm)
+		stage2_pgd_populate(mm, pgd, pud);
+	else
+		pgd_populate(mm, pgd, pud);
+}
+
+static inline pud_t *
+kvm_pud_offset(struct kvm *kvm, pgd_t *pgd, phys_addr_t address)
+{
+	return kvm ? stage2_pud_offset(pgd, address) : pud_offset(pgd, address);
+}
+
+static inline void kvm_pud_free(struct kvm *kvm, struct mm_struct *mm, pud_t *pudp)
+{
+	if (kvm)
+		stage2_pud_free(mm, pudp);
+	else
+		pud_free(mm, pudp);
+}
+
+static inline int kvm_pud_none(struct kvm *kvm, pud_t pud)
+{
+	return kvm ? stage2_pud_none(pud) : pud_none(pud);
+}
+
+static inline void kvm_pud_clear(struct kvm *kvm, pud_t *pudp)
+{
+	if (kvm)
+		stage2_pud_clear(pudp);
+	else
+		pud_clear(pudp);
+}
+
+static inline int kvm_pud_present(struct kvm *kvm, pud_t pud)
+{
+	return kvm ? stage2_pud_present(pud) : pud_present(pud);
+}
+
+static inline void
+kvm_pud_populate(struct kvm *kvm, struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
+{
+	if (kvm)
+		stage2_pud_populate(mm, pud, pmd);
+	else
+		pud_populate(mm, pud, pmd);
+}
+
+static inline pmd_t *
+kvm_pmd_offset(struct kvm *kvm, pud_t *pud, phys_addr_t address)
+{
+	return kvm ? stage2_pmd_offset(pud, address) : pmd_offset(pud, address);
+}
+
+static inline void kvm_pmd_free(struct kvm *kvm, struct mm_struct *mm, pmd_t *pmd)
+{
+	if (kvm)
+		stage2_pmd_free(mm, pmd);
+	else
+		pmd_free(mm, pmd);
 }
 
 static inline phys_addr_t
 kvm_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
-	return	pgd_addr_end(addr, end);
+	return	kvm ? stage2_pgd_addr_end(addr, end) : pgd_addr_end(addr, end);
 }
 
 static inline phys_addr_t
 kvm_pud_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
-	return	pud_addr_end(addr, end);
+	return	kvm ? stage2_pud_addr_end(addr, end) : pud_addr_end(addr, end);
 }
 
 static inline phys_addr_t
 kvm_pmd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
-	return	pmd_addr_end(addr, end);
+	return kvm ? stage2_pmd_addr_end(addr, end) : pmd_addr_end(addr, end);
 }
 
-/*
- * In the case where PGDIR_SHIFT is larger than KVM_PHYS_SHIFT, we can address
- * the entire IPA input range with a single pgd entry, and we would only need
- * one pgd entry.  Note that in this case, the pgd is actually not used by
- * the MMU for Stage-2 translations, but is merely a fake pgd used as a data
- * structure for the kernel pgtable macros to work.
- */
-#if PGDIR_SHIFT > KVM_PHYS_SHIFT
-#define PTRS_PER_S2_PGD_SHIFT	0
-#else
-#define PTRS_PER_S2_PGD_SHIFT	(KVM_PHYS_SHIFT - PGDIR_SHIFT)
-#endif
-#define PTRS_PER_S2_PGD		(1 << PTRS_PER_S2_PGD_SHIFT)
-
 static inline phys_addr_t kvm_pgd_index(struct kvm *kvm, phys_addr_t addr)
 {
-	return (addr >> PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1);
+	return kvm ? stage2_pgd_index(addr) : pgd_index(addr);
 }
 
-/*
- * If we are concatenating first level stage-2 page tables, we would have less
- * than or equal to 16 pointers in the fake PGD, because that's what the
- * architecture allows.  In this case, (4 - CONFIG_PGTABLE_LEVELS)
- * represents the first level for the host, and we add 1 to go to the next
- * level (which uses contatenation) for the stage-2 tables.
- */
-#if PTRS_PER_S2_PGD <= 16
-#define KVM_PREALLOC_LEVEL	(4 - CONFIG_PGTABLE_LEVELS + 1)
-#else
-#define KVM_PREALLOC_LEVEL	(0)
-#endif
-
 static inline void *kvm_get_hwpgd(struct kvm *kvm)
 {
 	pgd_t *pgd = kvm->arch.pgd;
@@ -269,22 +326,33 @@ static inline bool kvm_page_empty(void *ptr)
 	return page_count(ptr_page) == 1;
 }
 
-#define kvm_pte_table_empty(kvm, ptep) kvm_page_empty(ptep)
-
 #ifdef __PAGETABLE_PMD_FOLDED
-#define kvm_pmd_table_empty(kvm, pmdp) (0)
+#define hyp_pmd_table_empty(pmdp)	(0)
 #else
-#define kvm_pmd_table_empty(kvm, pmdp) \
-	(kvm_page_empty(pmdp) && (!(kvm) || KVM_PREALLOC_LEVEL < 2))
+#define hyp_pmd_table_empty(pmdp)	kvm_page_empty(pmdp)
 #endif
 
 #ifdef __PAGETABLE_PUD_FOLDED
-#define kvm_pud_table_empty(kvm, pudp) (0)
+#define hyp_pud_table_empty(pudp)	(0)
 #else
-#define kvm_pud_table_empty(kvm, pudp) \
-	(kvm_page_empty(pudp) && (!(kvm) || KVM_PREALLOC_LEVEL < 1))
+#define hyp_pud_table_empty(pudp)	kvm_page_empty(pudp)
 #endif
 
+static inline bool kvm_pte_table_empty(struct kvm *kvm, pte_t *ptep)
+{
+	return kvm_page_empty(ptep);
+}
+
+static inline bool kvm_pmd_table_empty(struct kvm *kvm, pmd_t *pmdp)
+{
+	return kvm ? stage2_pmd_table_empty(pmdp) : hyp_pmd_table_empty(pmdp);
+}
+
+static inline bool kvm_pud_table_empty(struct kvm *kvm, pud_t *pudp)
+{
+	return kvm ? stage2_pud_table_empty(pudp) : hyp_pud_table_empty(pudp);
+}
+
 
 struct kvm;
 
diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
new file mode 100644
index 0000000..95496e6
--- /dev/null
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -0,0 +1,85 @@
+/*
+ * Copyright (C) 2016 - ARM Ltd
+ *
+ * stage2 page table helpers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __ARM64_S2_PGTABLE_H_
+#define __ARM64_S2_PGTABLE_H_
+
+#include <asm/pgtable.h>
+
+/*
+ * In the case where PGDIR_SHIFT is larger than KVM_PHYS_SHIFT, we can address
+ * the entire IPA input range with a single pgd entry, and we would only need
+ * one pgd entry.  Note that in this case, the pgd is actually not used by
+ * the MMU for Stage-2 translations, but is merely a fake pgd used as a data
+ * structure for the kernel pgtable macros to work.
+ */
+#if PGDIR_SHIFT > KVM_PHYS_SHIFT
+#define PTRS_PER_S2_PGD_SHIFT	0
+#else
+#define PTRS_PER_S2_PGD_SHIFT	(KVM_PHYS_SHIFT - PGDIR_SHIFT)
+#endif
+#define PTRS_PER_S2_PGD		(1 << PTRS_PER_S2_PGD_SHIFT)
+
+/*
+ * If we are concatenating first level stage-2 page tables, we would have less
+ * than or equal to 16 pointers in the fake PGD, because that's what the
+ * architecture allows.  In this case, (4 - CONFIG_PGTABLE_LEVELS)
+ * represents the first level for the host, and we add 1 to go to the next
+ * level (which uses contatenation) for the stage-2 tables.
+ */
+#if PTRS_PER_S2_PGD <= 16
+#define KVM_PREALLOC_LEVEL	(4 - CONFIG_PGTABLE_LEVELS + 1)
+#else
+#define KVM_PREALLOC_LEVEL	(0)
+#endif
+
+#define stage2_pgd_none(pgd)				pgd_none(pgd)
+#define stage2_pgd_clear(pgd)				pgd_clear(pgd)
+#define stage2_pgd_present(pgd)				pgd_present(pgd)
+#define stage2_pgd_populate(mm, pgd, pud)		pgd_populate(mm, pgd, pud)
+#define stage2_pud_offset(pgd, address)			pud_offset(pgd, address)
+#define stage2_pud_free(mm, pud)			pud_free(mm, pud)
+
+#define stage2_pud_none(pud)				pud_none(pud)
+#define stage2_pud_clear(pud)				pud_clear(pud)
+#define stage2_pud_present(pud)				pud_present(pud)
+#define stage2_pud_populate(mm, pud, pmd)		pud_populate(mm, pud, pmd)
+#define stage2_pmd_offset(pud, address)			pmd_offset(pud, address)
+#define stage2_pmd_free(mm, pmd)			pmd_free(mm, pmd)
+
+#define stage2_pud_huge(pud)				pud_huge(pud)
+
+#define stage2_pgd_addr_end(address, end)		pgd_addr_end(address, end)
+#define stage2_pud_addr_end(address, end)		pud_addr_end(address, end)
+#define stage2_pmd_addr_end(address, end)		pmd_addr_end(address, end)
+
+#ifdef __PGTABLE_PMD_FOLDED
+#define stage2_pmd_table_empty(pmdp)			(0)
+#else
+#define stage2_pmd_table_empty(pmdp)			((KVM_PREALLOC_LEVEL < 2) && kvm_page_empty(pmdp))
+#endif
+
+#ifdef __PGTABLE_PUD_FOLDED
+#define stage2_pmd_table_empty(pmdp)			(0)
+#else
+#define stage2_pud_table_empty(pudp)			((KVM_PREALLOC_LEVEL < 1) && kvm_page_empty(pudp))
+#endif
+
+#define stage2_pgd_index(addr)				(((addr) >> PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
+
+#endif	/* __ARM64_S2_PGTABLE_H_ */
-- 
1.7.9.5
