From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC PATCH 07/12] kvm: arm: Introduce stage2 page table helpers
Date: Mon, 14 Mar 2016 16:53:06 +0000
Message-ID: <1457974391-28456-8-git-send-email-suzuki.poulose@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADEA349B43
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TJe-3O4802z4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2016 12:53:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C74549B71
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:14 -0400 (EDT)
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

So far we have used most of the page table helpers for host,
except for a few kvm_ wrappers. This patch introduces wrappers
for all the helpers which could potentially differ for underlying
page table. It also introduces the corresponding stage2 helpers
for arm32.

This will be plugged in to the core hypervisor code once
we have the arm64 counter parts implemented. On 32bit ARM,
we continue to use the host helpers under the hood, except
for kvm_p.d_addr_end which need to handle 64bit addresses.
Also converts kvm_p.d_table_empty() to static inline for
consistency with arm64 versions.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h        |   95 +++++++++++++++++++++++++++++----
 arch/arm/include/asm/stage2_pgtable.h |   55 +++++++++++++++++++
 2 files changed, 141 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm/include/asm/stage2_pgtable.h

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 17c6781..e670afa 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -48,6 +48,7 @@
 #include <linux/hugetlb.h>
 #include <asm/cacheflush.h>
 #include <asm/pgalloc.h>
+#include <asm/stage2_pgtable.h>
 
 int create_hyp_mappings(void *from, void *to);
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
@@ -141,26 +142,90 @@ static inline int kvm_pud_huge(struct kvm *kvm, pud_t pud)
 	return pud_huge(pud);
 }
 
+static inline int kvm_pgd_none(struct kvm *kvm, pgd_t pgd)
+{
+	return pgd_none(pgd);
+}
+
+static inline void kvm_pgd_clear(struct kvm *kvm, pgd_t *pgdp)
+{
+	pgd_clear(pgdp);
+}
+
+static inline int kvm_pgd_present(struct kvm *kvm, pgd_t pgd)
+{
+	return pgd_present(pgd);
+}
+
+static inline void
+kvm_pgd_populate(struct kvm *kvm, struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
+{
+	pgd_populate(mm, pgd, pud);
+}
+
+static inline pud_t *
+kvm_pud_offset(struct kvm *kvm, pgd_t *pgd, phys_addr_t address)
+{
+	return pud_offset(pgd, address);
+}
+
+static inline int kvm_pud_none(struct kvm *kvm, pud_t pud)
+{
+	return pud_none(pud);
+}
+
+static inline void kvm_pud_clear(struct kvm *kvm, pud_t *pudp)
+{
+	pud_clear(pudp);
+}
+
+static inline int kvm_pud_present(struct kvm *kvm, pud_t pud)
+{
+	return pud_present(pud);
+}
 
-/* Open coded p*d_addr_end that can deal with 64bit addresses */
+static inline void kvm_pud_free(struct kvm *kvm, struct mm_struct *mm, pud_t *pudp)
+{
+	pud_free(mm, pudp);
+}
+
+static inline void
+kvm_pud_populate(struct kvm *kvm, struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
+{
+	pud_populate(mm, pud, pmd);
+}
+
+static inline pmd_t *
+kvm_pmd_offset(struct kvm *kvm, pud_t *pud, phys_addr_t address)
+{
+	return pmd_offset(pud, address);
+}
+
+static inline void kvm_pmd_free(struct kvm *kvm, struct mm_struct *mm, pmd_t *pmd)
+{
+	pmd_free(mm, pmd);
+}
+
+/*
+ * stage2_p.d_addr_end can handle 64bit address, use them explicitly for
+ * hyp and stage2.
+ */
 static inline phys_addr_t
 kvm_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
-	phys_addr_t boundary = (addr + PGDIR_SIZE) & PGDIR_MASK;
-	return (boundary - 1 < end - 1) ? boundary : end;
+	return stage2_pgd_addr_end(addr, end);
 }
 
 static inline phys_addr_t
 kvm_pud_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
-	return end;
+	return stage2_pud_addr_end(addr, end);
 }
 
 static inline phys_addr_t
 kvm_pmd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 {
-	phys_addr_t boundary = (addr + PMD_SIZE) & PMD_MASK;
-	return (boundary - 1 < end - 1) ? boundary : end;
+	return stage2_pmd_addr_end(addr, end);
 }
 
 static inline phys_addr_t kvm_pgd_index(struct kvm *kvm, phys_addr_t addr)
@@ -174,9 +239,21 @@ static inline bool kvm_page_empty(void *ptr)
 	return page_count(ptr_page) == 1;
 }
 
-#define kvm_pte_table_empty(kvm, ptep) kvm_page_empty(ptep)
-#define kvm_pmd_table_empty(kvm, pmdp) kvm_page_empty(pmdp)
-#define kvm_pud_table_empty(kvm, pudp) (0)
+static inline bool kvm_pte_table_empty(struct kvm *kvm, pte_t *ptep)
+{
+	return kvm_page_empty(ptep);
+}
+
+static inline bool kvm_pmd_table_empty(struct kvm *kvm, pmd_t *pmdp)
+{
+	return kvm_page_empty(pmdp);
+}
+
+static inline bool kvm_pud_table_empty(struct kvm *kvm, pud_t *pudp)
+{
+	return 0;
+}
+
 
 static inline void *kvm_get_hwpgd(struct kvm *kvm)
 {
diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
new file mode 100644
index 0000000..91c1a63
--- /dev/null
+++ b/arch/arm/include/asm/stage2_pgtable.h
@@ -0,0 +1,55 @@
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
+#ifndef __ARM_S2_PGTABLE_H_
+#define __ARM_S2_PGTABLE_H_
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
+/* Open coded p*d_addr_end that can deal with 64bit addresses */
+static inline phys_addr_t stage2_pgd_addr_end(phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t boundary = (addr + PGDIR_SIZE) & PGDIR_MASK;
+	return (boundary - 1 < end - 1) ? boundary : end;
+}
+
+#define stage2_pud_addr_end(addr, end)		(end)
+
+static inline phys_addr_t stage2_pmd_addr_end(phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t boundary = (addr + PMD_SIZE) & PMD_MASK;
+	return (boundary - 1 < end - 1) ? boundary : end;
+}
+
+#define stage2_pgd_index(addr)				pgd_index(addr)
+
+#endif	/* __ARM_S2_PGTABLE_H_ */
-- 
1.7.9.5
