From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 15/29] kvm: arm64: Get rid of fake page table levels
Date: Wed, 11 May 2016 15:30:08 +0200
Message-ID: <1462973422-10021-16-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BE5E4011D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GbAwccFzl2p1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:29:14 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47BD949B7C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:08 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id e201so219197155wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 06:32:06 -0700 (PDT)
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

On arm64, the hardware supports concatenation of upto 16 tables,
at entry level for stage2 translations and we make use that whenever
possible. This could lead to reduced number of translation levels than
the normal (stage1 table) table. Also, since the IPA(40bit) is smaller
than the some of the supported VA_BITS (e.g, 48bit), there could be
different number of levels in stage-1 vs stage-2 tables. To reuse the
kernel host page table walker for stage2 we have been using a fake
software page table level, not known to the hardware. But with 16K
translations, there could be upto 2 fake software levels (with 48bit VA
and 40bit IPA), which complicates the code. Hence, we want to get rid of
the hack.

Now that we have explicit accessors for hyp vs stage2 page tables,
define the stage2 walker helpers accordingly based on the actual
table used by the hardware.

Once we know the number of translation levels used by the hardware,
it is merely a job of defining the helpers based on whether a
particular level is folded or not, looking at the number of levels.

Some facts before we calculate the translation levels:

1) Smallest page size supported by arm64 is 4K.
2) The minimum number of bits resolved at any page table level
   is (PAGE_SHIFT - 3) at intermediate levels.
Both of them implies, minimum number of bits required for a level
change is 9.

Since we can concatenate upto 16 tables at stage2 entry, the total
number of page table levels used by the hardware for resolving N bits
is same as that for (N - 4) bits (with concatenation), as there cannot
be a level in between (N, N-4) as per the above rules.

Hence, we have

 STAGE2_PGTABLE_LEVELS = PGTABLE_LEVELS(KVM_PHYS_SHIFT - 4)

With the current IPA limit (40bit), for all supported translations
and VA_BITS, we have the following condition (even for 36bit VA with
16K page size):

 CONFIG_PGTABLE_LEVELS >= STAGE2_PGTABLE_LEVELS.

So, for e.g,  if PUD is present in stage2, it is present in the hyp(host).
Hence, we fall back to the host definition if we find that a level is not
folded. Otherwise we redefine it accordingly. A build time check is added
to make sure the above condition holds. If this condition breaks in future,
we can rearrange the host level helpers and fix our code easily.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h              |  64 +-------------
 arch/arm64/include/asm/stage2_pgtable-nopmd.h |  42 +++++++++
 arch/arm64/include/asm/stage2_pgtable-nopud.h |  39 ++++++++
 arch/arm64/include/asm/stage2_pgtable.h       | 122 +++++++++++++++++++-------
 4 files changed, 172 insertions(+), 95 deletions(-)
 create mode 100644 arch/arm64/include/asm/stage2_pgtable-nopmd.h
 create mode 100644 arch/arm64/include/asm/stage2_pgtable-nopud.h

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index a3c0d05..e3fee0a 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -45,18 +45,6 @@
  */
 #define TRAMPOLINE_VA		(HYP_PAGE_OFFSET_MASK & PAGE_MASK)
 
-/*
- * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation
- * levels in addition to the PGD and potentially the PUD which are
- * pre-allocated (we pre-allocate the fake PGD and the PUD when the Stage-2
- * tables use one level of tables less than the kernel.
- */
-#ifdef CONFIG_ARM64_64K_PAGES
-#define KVM_MMU_CACHE_MIN_PAGES	1
-#else
-#define KVM_MMU_CACHE_MIN_PAGES	2
-#endif
-
 #ifdef __ASSEMBLY__
 
 #include <asm/alternative.h>
@@ -155,69 +143,21 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 
 static inline void *kvm_get_hwpgd(struct kvm *kvm)
 {
-	pgd_t *pgd = kvm->arch.pgd;
-	pud_t *pud;
-
-	if (KVM_PREALLOC_LEVEL == 0)
-		return pgd;
-
-	pud = pud_offset(pgd, 0);
-	if (KVM_PREALLOC_LEVEL == 1)
-		return pud;
-
-	BUG_ON(KVM_PREALLOC_LEVEL != 2);
-	return pmd_offset(pud, 0);
+	return kvm->arch.pgd;
 }
 
 static inline unsigned int kvm_get_hwpgd_size(void)
 {
-	if (KVM_PREALLOC_LEVEL > 0)
-		return PTRS_PER_S2_PGD * PAGE_SIZE;
 	return PTRS_PER_S2_PGD * sizeof(pgd_t);
 }
 
-/*
- * Allocate fake pgd for the host kernel page table macros to work.
- * This is not used by the hardware and we have no alignment
- * requirement for this allocation.
- */
 static inline pgd_t *kvm_setup_fake_pgd(pgd_t *hwpgd)
 {
-	int i;
-	pgd_t *pgd;
-
-	if (!KVM_PREALLOC_LEVEL)
-		return hwpgd;
-
-	/*
-	 * When KVM_PREALLOC_LEVEL==2, we allocate a single page for
-	 * the PMD and the kernel will use folded pud.
-	 * When KVM_PREALLOC_LEVEL==1, we allocate 2 consecutive PUD
-	 * pages.
-	 */
-
-	pgd = kmalloc(PTRS_PER_S2_PGD * sizeof(pgd_t),
-			GFP_KERNEL | __GFP_ZERO);
-	if (!pgd)
-		return ERR_PTR(-ENOMEM);
-
-	/* Plug the HW PGD into the fake one. */
-	for (i = 0; i < PTRS_PER_S2_PGD; i++) {
-		if (KVM_PREALLOC_LEVEL == 1)
-			pgd_populate(NULL, pgd + i,
-				     (pud_t *)hwpgd + i * PTRS_PER_PUD);
-		else if (KVM_PREALLOC_LEVEL == 2)
-			pud_populate(NULL, pud_offset(pgd, 0) + i,
-				     (pmd_t *)hwpgd + i * PTRS_PER_PMD);
-	}
-
-	return pgd;
+	return hwpgd;
 }
 
 static inline void kvm_free_fake_pgd(pgd_t *pgd)
 {
-	if (KVM_PREALLOC_LEVEL > 0)
-		kfree(pgd);
 }
 static inline bool kvm_page_empty(void *ptr)
 {
diff --git a/arch/arm64/include/asm/stage2_pgtable-nopmd.h b/arch/arm64/include/asm/stage2_pgtable-nopmd.h
new file mode 100644
index 0000000..2656a0f
--- /dev/null
+++ b/arch/arm64/include/asm/stage2_pgtable-nopmd.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2016 - ARM Ltd
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
+#ifndef __ARM64_S2_PGTABLE_NOPMD_H_
+#define __ARM64_S2_PGTABLE_NOPMD_H_
+
+#include <asm/stage2_pgtable-nopud.h>
+
+#define __S2_PGTABLE_PMD_FOLDED
+
+#define S2_PMD_SHIFT		S2_PUD_SHIFT
+#define S2_PTRS_PER_PMD		1
+#define S2_PMD_SIZE		(1UL << S2_PMD_SHIFT)
+#define S2_PMD_MASK		(~(S2_PMD_SIZE-1))
+
+#define stage2_pud_none(pud)			(0)
+#define stage2_pud_present(pud)			(1)
+#define stage2_pud_clear(pud)			do { } while (0)
+#define stage2_pud_populate(pud, pmd)		do { } while (0)
+#define stage2_pmd_offset(pud, address)		((pmd_t *)(pud))
+
+#define stage2_pmd_free(pmd)			do { } while (0)
+
+#define stage2_pmd_addr_end(addr, end)		(end)
+
+#define stage2_pud_huge(pud)			(0)
+#define stage2_pmd_table_empty(pmdp)		(0)
+
+#endif
diff --git a/arch/arm64/include/asm/stage2_pgtable-nopud.h b/arch/arm64/include/asm/stage2_pgtable-nopud.h
new file mode 100644
index 0000000..5ee87b5
--- /dev/null
+++ b/arch/arm64/include/asm/stage2_pgtable-nopud.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2016 - ARM Ltd
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
+#ifndef __ARM64_S2_PGTABLE_NOPUD_H_
+#define __ARM64_S2_PGTABLE_NOPUD_H_
+
+#define __S2_PGTABLE_PUD_FOLDED
+
+#define S2_PUD_SHIFT		S2_PGDIR_SHIFT
+#define S2_PTRS_PER_PUD		1
+#define S2_PUD_SIZE		(_AC(1, UL) << S2_PUD_SHIFT)
+#define S2_PUD_MASK		(~(S2_PUD_SIZE-1))
+
+#define stage2_pgd_none(pgd)			(0)
+#define stage2_pgd_present(pgd)			(1)
+#define stage2_pgd_clear(pgd)			do { } while (0)
+#define stage2_pgd_populate(pgd, pud)	do { } while (0)
+
+#define stage2_pud_offset(pgd, address)		((pud_t *)(pgd))
+
+#define stage2_pud_free(x)			do { } while (0)
+
+#define stage2_pud_addr_end(addr, end)		(end)
+#define stage2_pud_table_empty(pmdp)		(0)
+
+#endif
diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index 0ec218f..8b68099 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -22,32 +22,61 @@
 #include <asm/pgtable.h>
 
 /*
- * In the case where PGDIR_SHIFT is larger than KVM_PHYS_SHIFT, we can address
- * the entire IPA input range with a single pgd entry, and we would only need
- * one pgd entry.  Note that in this case, the pgd is actually not used by
- * the MMU for Stage-2 translations, but is merely a fake pgd used as a data
- * structure for the kernel pgtable macros to work.
+ * The hardware supports concatenation of up to 16 tables at stage2 entry level
+ * and we use the feature whenever possible.
+ *
+ * Now, the minimum number of bits resolved at any level is (PAGE_SHIFT - 3).
+ * On arm64, the smallest PAGE_SIZE supported is 4k, which means
+ *             (PAGE_SHIFT - 3) > 4 holds for all page sizes.
+ * This implies, the total number of page table levels at stage2 expected
+ * by the hardware is actually the number of levels required for (KVM_PHYS_SHIFT - 4)
+ * in normal translations(e.g, stage1), since we cannot have another level in
+ * the range (KVM_PHYS_SHIFT, KVM_PHYS_SHIFT - 4).
  */
-#if PGDIR_SHIFT > KVM_PHYS_SHIFT
-#define PTRS_PER_S2_PGD_SHIFT	0
-#else
-#define PTRS_PER_S2_PGD_SHIFT	(KVM_PHYS_SHIFT - PGDIR_SHIFT)
-#endif
-#define PTRS_PER_S2_PGD		(1 << PTRS_PER_S2_PGD_SHIFT)
+#define STAGE2_PGTABLE_LEVELS		ARM64_HW_PGTABLE_LEVELS(KVM_PHYS_SHIFT - 4)
 
 /*
- * If we are concatenating first level stage-2 page tables, we would have less
- * than or equal to 16 pointers in the fake PGD, because that's what the
- * architecture allows.  In this case, (4 - CONFIG_PGTABLE_LEVELS)
- * represents the first level for the host, and we add 1 to go to the next
- * level (which uses contatenation) for the stage-2 tables.
+ * With all the supported VA_BITs and 40bit guest IPA, the following condition
+ * is always true:
+ *
+ *       STAGE2_PGTABLE_LEVELS <= CONFIG_PGTABLE_LEVELS
+ *
+ * We base our stage-2 page table walker helpers on this assumption and
+ * fall back to using the host version of the helper wherever possible.
+ * i.e, if a particular level is not folded (e.g, PUD) at stage2, we fall back
+ * to using the host version, since it is guaranteed it is not folded at host.
+ *
+ * If the condition breaks in the future, we can rearrange the host level
+ * definitions and reuse them for stage2. Till then...
  */
-#if PTRS_PER_S2_PGD <= 16
-#define KVM_PREALLOC_LEVEL	(4 - CONFIG_PGTABLE_LEVELS + 1)
-#else
-#define KVM_PREALLOC_LEVEL	(0)
+#if STAGE2_PGTABLE_LEVELS > CONFIG_PGTABLE_LEVELS
+#error "Unsupported combination of guest IPA and host VA_BITS."
 #endif
 
+/* S2_PGDIR_SHIFT is the size mapped by top-level stage2 entry */
+#define S2_PGDIR_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(4 - STAGE2_PGTABLE_LEVELS)
+#define S2_PGDIR_SIZE			(_AC(1, UL) << S2_PGDIR_SHIFT)
+#define S2_PGDIR_MASK			(~(S2_PGDIR_SIZE - 1))
+
+/*
+ * The number of PTRS across all concatenated stage2 tables given by the
+ * number of bits resolved at the initial level.
+ */
+#define PTRS_PER_S2_PGD			(1 << (KVM_PHYS_SHIFT - S2_PGDIR_SHIFT))
+
+/*
+ * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation
+ * levels in addition to the PGD.
+ */
+#define KVM_MMU_CACHE_MIN_PAGES		(STAGE2_PGTABLE_LEVELS - 1)
+
+
+#if STAGE2_PGTABLE_LEVELS > 3
+
+#define S2_PUD_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(1)
+#define S2_PUD_SIZE			(_AC(1, UL) << S2_PUD_SHIFT)
+#define S2_PUD_MASK			(~(S2_PUD_SIZE - 1))
+
 #define stage2_pgd_none(pgd)				pgd_none(pgd)
 #define stage2_pgd_clear(pgd)				pgd_clear(pgd)
 #define stage2_pgd_present(pgd)				pgd_present(pgd)
@@ -55,6 +84,24 @@
 #define stage2_pud_offset(pgd, address)			pud_offset(pgd, address)
 #define stage2_pud_free(pud)				pud_free(NULL, pud)
 
+#define stage2_pud_table_empty(pudp)			kvm_page_empty(pudp)
+
+static inline phys_addr_t stage2_pud_addr_end(phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t boundary = (addr + S2_PUD_SIZE) & S2_PUD_MASK;
+
+	return (boundary - 1 < end - 1) ? boundary : end;
+}
+
+#endif		/* STAGE2_PGTABLE_LEVELS > 3 */
+
+
+#if STAGE2_PGTABLE_LEVELS > 2
+
+#define S2_PMD_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(2)
+#define S2_PMD_SIZE			(_AC(1, UL) << S2_PMD_SHIFT)
+#define S2_PMD_MASK			(~(S2_PMD_SIZE - 1))
+
 #define stage2_pud_none(pud)				pud_none(pud)
 #define stage2_pud_clear(pud)				pud_clear(pud)
 #define stage2_pud_present(pud)				pud_present(pud)
@@ -63,24 +110,33 @@
 #define stage2_pmd_free(pmd)				pmd_free(NULL, pmd)
 
 #define stage2_pud_huge(pud)				pud_huge(pud)
+#define stage2_pmd_table_empty(pmdp)			kvm_page_empty(pmdp)
+
+static inline phys_addr_t stage2_pmd_addr_end(phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t boundary = (addr + S2_PMD_SIZE) & S2_PMD_MASK;
 
-#define stage2_pgd_addr_end(address, end)		pgd_addr_end(address, end)
-#define stage2_pud_addr_end(address, end)		pud_addr_end(address, end)
-#define stage2_pmd_addr_end(address, end)		pmd_addr_end(address, end)
+	return (boundary - 1 < end - 1) ? boundary : end;
+}
+
+#endif		/* STAGE2_PGTABLE_LEVELS > 2 */
 
 #define stage2_pte_table_empty(ptep)			kvm_page_empty(ptep)
-#ifdef __PGTABLE_PMD_FOLDED
-#define stage2_pmd_table_empty(pmdp)			(0)
-#else
-#define stage2_pmd_table_empty(pmdp)			((KVM_PREALLOC_LEVEL < 2) && kvm_page_empty(pmdp))
-#endif
 
-#ifdef __PGTABLE_PUD_FOLDED
-#define stage2_pud_table_empty(pudp)			(0)
-#else
-#define stage2_pud_table_empty(pudp)			((KVM_PREALLOC_LEVEL < 1) && kvm_page_empty(pudp))
+#if STAGE2_PGTABLE_LEVELS == 2
+#include <asm/stage2_pgtable-nopmd.h>
+#elif STAGE2_PGTABLE_LEVELS == 3
+#include <asm/stage2_pgtable-nopud.h>
 #endif
 
-#define stage2_pgd_index(addr)				(((addr) >> PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
+
+#define stage2_pgd_index(addr)				(((addr) >> S2_PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
+
+static inline phys_addr_t stage2_pgd_addr_end(phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t boundary = (addr + S2_PGDIR_SIZE) & S2_PGDIR_MASK;
+
+	return (boundary - 1 < end - 1) ? boundary : end;
+}
 
 #endif	/* __ARM64_S2_PGTABLE_H_ */
-- 
2.1.2.330.g565301e.dirty
