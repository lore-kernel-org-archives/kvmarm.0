From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 07/29] kvm-arm: arm32: Introduce stage2 page table helpers
Date: Wed, 11 May 2016 15:30:00 +0200
Message-ID: <1462973422-10021-8-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Define the page table helpers for walking the stage2 pagetable
for arm. Since both hyp and stage2 have the same number of levels,
as that of the host we reuse the host helpers.

The exceptions are the p.d_addr_end routines which have to deal
with IPA > 32bit, hence we use the open coded version of their host helpers
which supports 64bit.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_mmu.h        |  1 +
 arch/arm/include/asm/stage2_pgtable.h | 61 +++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)
 create mode 100644 arch/arm/include/asm/stage2_pgtable.h

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index c2b2b27..7d207b4 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -47,6 +47,7 @@
 #include <linux/highmem.h>
 #include <asm/cacheflush.h>
 #include <asm/pgalloc.h>
+#include <asm/stage2_pgtable.h>
 
 int create_hyp_mappings(void *from, void *to);
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
new file mode 100644
index 0000000..460d616
--- /dev/null
+++ b/arch/arm/include/asm/stage2_pgtable.h
@@ -0,0 +1,61 @@
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
+#define stage2_pgd_none(pgd)			pgd_none(pgd)
+#define stage2_pgd_clear(pgd)			pgd_clear(pgd)
+#define stage2_pgd_present(pgd)			pgd_present(pgd)
+#define stage2_pgd_populate(pgd, pud)		pgd_populate(NULL, pgd, pud)
+#define stage2_pud_offset(pgd, address)		pud_offset(pgd, address)
+#define stage2_pud_free(pud)			pud_free(NULL, pud)
+
+#define stage2_pud_none(pud)			pud_none(pud)
+#define stage2_pud_clear(pud)			pud_clear(pud)
+#define stage2_pud_present(pud)			pud_present(pud)
+#define stage2_pud_populate(pud, pmd)		pud_populate(NULL, pud, pmd)
+#define stage2_pmd_offset(pud, address)		pmd_offset(pud, address)
+#define stage2_pmd_free(pmd)			pmd_free(NULL, pmd)
+
+#define stage2_pud_huge(pud)			pud_huge(pud)
+
+/* Open coded p*d_addr_end that can deal with 64bit addresses */
+static inline phys_addr_t stage2_pgd_addr_end(phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t boundary = (addr + PGDIR_SIZE) & PGDIR_MASK;
+
+	return (boundary - 1 < end - 1) ? boundary : end;
+}
+
+#define stage2_pud_addr_end(addr, end)		(end)
+
+static inline phys_addr_t stage2_pmd_addr_end(phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t boundary = (addr + PMD_SIZE) & PMD_MASK;
+
+	return (boundary - 1 < end - 1) ? boundary : end;
+}
+
+#define stage2_pgd_index(addr)				pgd_index(addr)
+
+#define stage2_pte_table_empty(ptep)			kvm_page_empty(ptep)
+#define stage2_pmd_table_empty(pmdp)			kvm_page_empty(pmdp)
+#define stage2_pud_table_empty(pudp)			false
+
+#endif	/* __ARM_S2_PGTABLE_H_ */
-- 
2.1.2.330.g565301e.dirty

