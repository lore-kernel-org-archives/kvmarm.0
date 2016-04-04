From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 09/17] kvm-arm: arm64: Introduce stage2 page table helpers
Date: Mon,  4 Apr 2016 17:26:09 +0100
Message-ID: <1459787177-12767-10-git-send-email-suzuki.poulose@arm.com>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 298F840FA7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 12:25:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pbsLdWm2H9kU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 12:25:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3386411BE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 12:25:44 -0400 (EDT)
In-Reply-To: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Introduce stage2 page table helpers for arm64. With the fake
page table level still in place, the stage2 table has the same
number of levels as that of the host (and hyp), so they all
fallback to the host version.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h        |   29 +----------
 arch/arm64/include/asm/stage2_pgtable.h |   86 +++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 27 deletions(-)
 create mode 100644 arch/arm64/include/asm/stage2_pgtable.h

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 9a3409f..e3f53e3 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -91,6 +91,8 @@ alternative_endif
 #define KVM_PHYS_SIZE	(1UL << KVM_PHYS_SHIFT)
 #define KVM_PHYS_MASK	(KVM_PHYS_SIZE - 1UL)
 
+#include <asm/stage2_pgtable.h>
+
 int create_hyp_mappings(void *from, void *to);
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
 void free_boot_hyp_pgd(void);
@@ -156,35 +158,8 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 #define kvm_pud_addr_end(addr, end)	pud_addr_end(addr, end)
 #define kvm_pmd_addr_end(addr, end)	pmd_addr_end(addr, end)
 
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
 #define kvm_pgd_index(addr)	(((addr) >> PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
 
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
diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
new file mode 100644
index 0000000..751227d
--- /dev/null
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -0,0 +1,86 @@
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
+#define stage2_pte_table_empty(ptep)			kvm_page_empty(ptep)
+#ifdef __PGTABLE_PMD_FOLDED
+#define stage2_pmd_table_empty(pmdp)			(0)
+#else
+#define stage2_pmd_table_empty(pmdp)			((KVM_PREALLOC_LEVEL < 2) && kvm_page_empty(pmdp))
+#endif
+
+#ifdef __PGTABLE_PUD_FOLDED
+#define stage2_pud_table_empty(pudp)			(0)
+#else
+#define stage2_pud_table_empty(pudp)			((KVM_PREALLOC_LEVEL < 1) && kvm_page_empty(pudp))
+#endif
+
+#define stage2_pgd_index(addr)				(((addr) >> PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
+
+#endif	/* __ARM64_S2_PGTABLE_H_ */
-- 
1.7.9.5
