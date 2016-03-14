From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC PATCH 10/12] kvm: arm64: Get rid of fake page table levels
Date: Mon, 14 Mar 2016 16:53:09 +0000
Message-ID: <1457974391-28456-11-git-send-email-suzuki.poulose@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F7D849B5D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DYE8MoidyVLc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2016 12:53:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E150249B5A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:19 -0400 (EDT)
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

On arm64, the hardware mandates concatenation of upto 16 tables,
at entry level for stage2 translations. This could lead to reduced
number of translation levels than the normal (stage1 table).
Also, since the IPA(40bit) is smaller than the some of the supported
VA_BITS (e.g, 48bit), there could be different number of levels
in stage-1 vs stage-2 tables. To work around this, so far we have been
using a fake software page table level, not known to the hardware.
But with 16K translations, there could be upto 2 fake software
levels, which complicates the code. Hence, we want to get rid of the hack.

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
be a level in between (N, N-4).

Hence, we have

 STAGE2_PGTABLE_LEVELS = PGTABLE_LEVELS(KVM_PHYS_SHIFT - 4)

With the current IPA limit (40bit), for all supported translations
and VA_BITS, we have the following condition:

 CONFIG_PGTABLE_LEVELS >= STAGE2_PGTABLE_LEVELS.

So, for e.g,  if PUD is present in stage2, it is present in the hyp(host).
Hence, we fall back to the host definition if find that a level is not
folded. Otherwise we redefine it accordingly.

A build time check is added to make sure the above condition holds.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---

Removing this restriction is straight forward, by re-arranging the
host page table accessor macros to their ___p.d_xxx versions and
using them instead of the p.d_xxxx. To make the review easier,
I have kept it as it is.

---
---
 arch/arm64/include/asm/kvm_mmu.h              |   64 +------------
 arch/arm64/include/asm/stage2_pgtable-nopmd.h |   26 ++++++
 arch/arm64/include/asm/stage2_pgtable-nopud.h |   23 +++++
 arch/arm64/include/asm/stage2_pgtable.h       |  119 +++++++++++++++++--------
 4 files changed, 135 insertions(+), 97 deletions(-)
 create mode 100644 arch/arm64/include/asm/stage2_pgtable-nopmd.h
 create mode 100644 arch/arm64/include/asm/stage2_pgtable-nopud.h

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 55cde87..a6f9846 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -42,18 +42,6 @@
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
 
 /*
@@ -256,69 +244,21 @@ static inline phys_addr_t kvm_pgd_index(struct kvm *kvm, phys_addr_t addr)
 
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
index 0000000..2cbd315
--- /dev/null
+++ b/arch/arm64/include/asm/stage2_pgtable-nopmd.h
@@ -0,0 +1,26 @@
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
+#define stage2_pud_populate(mm, pud, pmd)	do { } while (0)
+#define stage2_pmd_offset(pud, address)		((pmd_t *)(pud))
+
+#define stage2_pmd_free(mm, pmd)		do { } while (0)
+
+#define stage2_pmd_addr_end(addr, end)		(end)
+
+#define stage2_pud_huge(pud)			(0)
+#define stage2_pmd_table_empty(pmdp)		(0)
+
+#endif
diff --git a/arch/arm64/include/asm/stage2_pgtable-nopud.h b/arch/arm64/include/asm/stage2_pgtable-nopud.h
new file mode 100644
index 0000000..591ac53
--- /dev/null
+++ b/arch/arm64/include/asm/stage2_pgtable-nopud.h
@@ -0,0 +1,23 @@
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
+#define stage2_pgd_populate(mm, pgd, pud)	do { } while (0)
+
+#define stage2_pud_offset(pgd, address)		((pud_t *)(pgd))
+
+#define stage2_pud_free(mm, x)			do { } while (0)
+
+#define stage2_pud_addr_end(addr, end)		(end)
+#define stage2_pud_table_empty(pmdp)		(0)
+
+#endif
diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index 95496e6..90f1403 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -16,38 +16,61 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifndef __ARM64_S2_PGTABLE_H_
-#define __ARM64_S2_PGTABLE_H_
+#ifndef __ARM64_STAGE2_PGTABLE_H_
+#define __ARM64_STAGE2_PGTABLE_H_
 
 #include <asm/pgtable.h>
 
 /*
- * In the case where PGDIR_SHIFT is larger than KVM_PHYS_SHIFT, we can address
- * the entire IPA input range with a single pgd entry, and we would only need
- * one pgd entry.  Note that in this case, the pgd is actually not used by
- * the MMU for Stage-2 translations, but is merely a fake pgd used as a data
- * structure for the kernel pgtable macros to work.
+ * The hardware mandates concatenation of upto 16 tables at stage2 entry level.
+ * Now, the minimum number of bits resolved at any level is (PAGE_SHIFT - 3),
+ * or in other words log2(PTRS_PER_PTE). On arm64, the smallest PAGE_SIZE
+ * supported is 4k, which means (PAGE_SHIFT - 3) > 4 holds for all page sizes.
+ * This implies, the total number of page table levels at stage2 expected
+ * by the hardware is actually the number of levels required for (KVM_PHYS_SHIFT - 4)
+ * in normal translations(e.g, stage-1), since we cannot have another level in
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
+ * At the moment, we do not support a combination of guest IPA and host VA_BITS
+ * where
+ * 	STAGE2_PGTABLE_LEVELS > CONFIG_PGTABLE_LEVELS
+ *
+ * We base our stage-2 page table walker helpers based on this assumption and
+ * fallback to using the host version of the helper wherever possible.
+ * i.e, if a particular level is not folded (e.g, PUD) at stage2, we fall back
+ * to using the host version, since it is guaranteed it is not folded at host.
+ *
+ * TODO: We could lift this limitation easily by rearranging the host level
+ * definitions to a more reusable version.
  */
-#if PTRS_PER_S2_PGD <= 16
-#define KVM_PREALLOC_LEVEL	(4 - CONFIG_PGTABLE_LEVELS + 1)
-#else
-#define KVM_PREALLOC_LEVEL	(0)
+#if STAGE2_PGTABLE_LEVELS > CONFIG_PGTABLE_LEVELS
+#error "Unsupported combination of guest IPA and host VA_BITS."
 #endif
 
+
+#define S2_PGDIR_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(4 - STAGE2_PGTABLE_LEVELS)
+#define S2_PGDIR_SIZE			(_AC(1, UL) << S2_PGDIR_SHIFT)
+#define S2_PGDIR_MASK			(~(S2_PGDIR_SIZE - 1))
+
+/* We can have concatenated tables at stage2 entry. */
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
@@ -55,6 +78,17 @@
 #define stage2_pud_offset(pgd, address)			pud_offset(pgd, address)
 #define stage2_pud_free(mm, pud)			pud_free(mm, pud)
 
+#define stage2_pud_table_empty(pudp)			kvm_page_empty(pudp)
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
@@ -63,23 +97,38 @@
 #define stage2_pmd_free(mm, pmd)			pmd_free(mm, pmd)
 
 #define stage2_pud_huge(pud)				pud_huge(pud)
+#define stage2_pmd_table_empty(pmdp)			kvm_page_empty(pmdp)
 
-#define stage2_pgd_addr_end(address, end)		pgd_addr_end(address, end)
-#define stage2_pud_addr_end(address, end)		pud_addr_end(address, end)
-#define stage2_pmd_addr_end(address, end)		pmd_addr_end(address, end)
+#endif		/* STAGE2_PGTABLE_LEVELS > 2 */
 
-#ifdef __PGTABLE_PMD_FOLDED
-#define stage2_pmd_table_empty(pmdp)			(0)
-#else
-#define stage2_pmd_table_empty(pmdp)			((KVM_PREALLOC_LEVEL < 2) && kvm_page_empty(pmdp))
+#if STAGE2_PGTABLE_LEVELS == 2
+#include <asm/stage2_pgtable-nopmd.h>
+#elif STAGE2_PGTABLE_LEVELS == 3
+#include <asm/stage2_pgtable-nopud.h>
 #endif
 
-#ifdef __PGTABLE_PUD_FOLDED
-#define stage2_pmd_table_empty(pmdp)			(0)
-#else
-#define stage2_pud_table_empty(pudp)			((KVM_PREALLOC_LEVEL < 1) && kvm_page_empty(pudp))
+#ifndef stage2_pgd_addr_end
+#define stage2_pgd_addr_end(addr, end)							\
+({	phys_addr_t __boundary = (((addr) + S2_PGDIR_SIZE) & S2_PGDIR_MASK);		\
+	(__boundary - 1 < (end) - 1) ? __boundary : (end);				\
+})
 #endif
 
-#define stage2_pgd_index(addr)				(((addr) >> PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
+#ifndef stage2_pud_addr_end
+#define stage2_pud_addr_end(addr, end)							\
+({	phys_addr_t __boundary = (((addr) + S2_PUD_SIZE) & S2_PUD_MASK);		\
+	(__boundary - 1 < (end) - 1) ? __boundary : (end);				\
+})
+#endif
+
+#ifndef stage2_pmd_addr_end
+#define stage2_pmd_addr_end(addr, end)							\
+({	phys_addr_t __boundary = (((addr) + S2_PMD_SIZE) & S2_PMD_MASK);		\
+	(__boundary - 1 < (end) - 1) ? __boundary : (end);				\
+})
+#endif
+
+
+#define stage2_pgd_index(addr)				(((addr) >> S2_PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
 
-#endif	/* __ARM64_S2_PGTABLE_H_ */
+#endif	/* __ARM64_STAGE2_PGTABLE_H_ */
-- 
1.7.9.5
