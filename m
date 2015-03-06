From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH roundup 1/4] arm64: mm: increase VA range of identity map
Date: Fri,  6 Mar 2015 15:34:39 +0100
Message-ID: <1425652482-31411-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1425652482-31411-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 301F047A40
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 09:29:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ob6zZpmCtnOB for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 09:28:58 -0500 (EST)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DE2E47A84
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 09:28:58 -0500 (EST)
Received: by wibhm9 with SMTP id hm9so4014252wib.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Mar 2015 06:35:05 -0800 (PST)
In-Reply-To: <1425652482-31411-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: will.deacon@arm.com, arnd@arndb.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The page size and the number of translation levels, and hence the supported
virtual address range, are build-time configurables on arm64 whose optimal
values are use case dependent. However, in the current implementation, if
the system's RAM is located at a very high offset, the virtual address range
needs to reflect that merely because the identity mapping, which is only used
to enable or disable the MMU, requires the extended virtual range to map the
physical memory at an equal virtual offset.

This patch relaxes that requirement, by increasing the number of translation
levels for the identity mapping only, and only when actually needed, i.e.,
when system RAM's offset is found to be out of reach at runtime.

Tested-by: Laura Abbott <lauraa@codeaurora.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/mmu_context.h   | 43 ++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/page.h          |  6 +++--
 arch/arm64/include/asm/pgtable-hwdef.h |  7 +++++-
 arch/arm64/kernel/head.S               | 38 ++++++++++++++++++++++++++++++
 arch/arm64/kernel/smp.c                |  1 +
 arch/arm64/mm/mmu.c                    |  7 +++++-
 arch/arm64/mm/proc-macros.S            | 11 +++++++++
 arch/arm64/mm/proc.S                   |  3 +++
 8 files changed, 112 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index a9eee33dfa62..ecf2d060036b 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -64,6 +64,49 @@ static inline void cpu_set_reserved_ttbr0(void)
 	: "r" (ttbr));
 }
 
+/*
+ * TCR.T0SZ value to use when the ID map is active. Usually equals
+ * TCR_T0SZ(VA_BITS), unless system RAM is positioned very high in
+ * physical memory, in which case it will be smaller.
+ */
+extern u64 idmap_t0sz;
+
+static inline bool __cpu_uses_extended_idmap(void)
+{
+	return (!IS_ENABLED(CONFIG_ARM64_VA_BITS_48) &&
+		unlikely(idmap_t0sz != TCR_T0SZ(VA_BITS)));
+}
+
+static inline void __cpu_set_tcr_t0sz(u64 t0sz)
+{
+	unsigned long tcr;
+
+	if (__cpu_uses_extended_idmap())
+		asm volatile (
+		"	mrs	%0, tcr_el1	;"
+		"	bfi	%0, %1, %2, %3	;"
+		"	msr	tcr_el1, %0	;"
+		"	isb"
+		: "=&r" (tcr)
+		: "r"(t0sz), "I"(TCR_T0SZ_OFFSET), "I"(TCR_TxSZ_WIDTH));
+}
+
+/*
+ * Set TCR.T0SZ to the value appropriate for activating the identity map.
+ */
+static inline void cpu_set_idmap_tcr_t0sz(void)
+{
+	__cpu_set_tcr_t0sz(idmap_t0sz);
+}
+
+/*
+ * Set TCR.T0SZ to its default value (based on VA_BITS)
+ */
+static inline void cpu_set_default_tcr_t0sz(void)
+{
+	__cpu_set_tcr_t0sz(TCR_T0SZ(VA_BITS));
+}
+
 static inline void switch_new_context(struct mm_struct *mm)
 {
 	unsigned long flags;
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 22b16232bd60..3d02b1869eb8 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -33,7 +33,9 @@
  * image. Both require pgd, pud (4 levels only) and pmd tables to (section)
  * map the kernel. With the 64K page configuration, swapper and idmap need to
  * map to pte level. The swapper also maps the FDT (see __create_page_tables
- * for more information).
+ * for more information). Note that the number of ID map translation levels
+ * could be increased on the fly if system RAM is out of reach for the default
+ * VA range, so 3 pages are reserved in all cases.
  */
 #ifdef CONFIG_ARM64_64K_PAGES
 #define SWAPPER_PGTABLE_LEVELS	(CONFIG_ARM64_PGTABLE_LEVELS)
@@ -42,7 +44,7 @@
 #endif
 
 #define SWAPPER_DIR_SIZE	(SWAPPER_PGTABLE_LEVELS * PAGE_SIZE)
-#define IDMAP_DIR_SIZE		(SWAPPER_DIR_SIZE)
+#define IDMAP_DIR_SIZE		(3 * PAGE_SIZE)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 5f930cc9ea83..847e864202cc 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -143,7 +143,12 @@
 /*
  * TCR flags.
  */
-#define TCR_TxSZ(x)		(((UL(64) - (x)) << 16) | ((UL(64) - (x)) << 0))
+#define TCR_T0SZ_OFFSET		0
+#define TCR_T1SZ_OFFSET		16
+#define TCR_T0SZ(x)		((UL(64) - (x)) << TCR_T0SZ_OFFSET)
+#define TCR_T1SZ(x)		((UL(64) - (x)) << TCR_T1SZ_OFFSET)
+#define TCR_TxSZ(x)		(TCR_T0SZ(x) | TCR_T1SZ(x))
+#define TCR_TxSZ_WIDTH		6
 #define TCR_IRGN_NC		((UL(0) << 8) | (UL(0) << 24))
 #define TCR_IRGN_WBWA		((UL(1) << 8) | (UL(1) << 24))
 #define TCR_IRGN_WT		((UL(2) << 8) | (UL(2) << 24))
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 8ce88e08c030..a3612eadab3c 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -387,6 +387,44 @@ __create_page_tables:
 	mov	x0, x25				// idmap_pg_dir
 	ldr	x3, =KERNEL_START
 	add	x3, x3, x28			// __pa(KERNEL_START)
+
+#ifndef CONFIG_ARM64_VA_BITS_48
+#define EXTRA_SHIFT	(PGDIR_SHIFT + PAGE_SHIFT - 3)
+#define EXTRA_PTRS	(1 << (48 - EXTRA_SHIFT))
+
+	/*
+	 * If VA_BITS < 48, it may be too small to allow for an ID mapping to be
+	 * created that covers system RAM if that is located sufficiently high
+	 * in the physical address space. So for the ID map, use an extended
+	 * virtual range in that case, by configuring an additional translation
+	 * level.
+	 * First, we have to verify our assumption that the current value of
+	 * VA_BITS was chosen such that all translation levels are fully
+	 * utilised, and that lowering T0SZ will always result in an additional
+	 * translation level to be configured.
+	 */
+#if VA_BITS != EXTRA_SHIFT
+#error "Mismatch between VA_BITS and page size/number of translation levels"
+#endif
+
+	/*
+	 * Calculate the maximum allowed value for TCR_EL1.T0SZ so that the
+	 * entire kernel image can be ID mapped. As T0SZ == (64 - #bits used),
+	 * this number conveniently equals the number of leading zeroes in
+	 * the physical address of KERNEL_END.
+	 */
+	adrp	x5, KERNEL_END
+	clz	x5, x5
+	cmp	x5, TCR_T0SZ(VA_BITS)	// default T0SZ small enough?
+	b.ge	1f			// .. then skip additional level
+
+	adrp	x6, idmap_t0sz
+	str	x5, [x6, :lo12:idmap_t0sz]
+
+	create_table_entry x0, x3, EXTRA_SHIFT, EXTRA_PTRS, x5, x6
+1:
+#endif
+
 	create_pgd_entry x0, x3, x5, x6
 	ldr	x6, =KERNEL_END
 	mov	x5, x3				// __pa(KERNEL_START)
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 328b8ce4b007..74554dfcce73 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -151,6 +151,7 @@ asmlinkage void secondary_start_kernel(void)
 	 */
 	cpu_set_reserved_ttbr0();
 	flush_tlb_all();
+	cpu_set_default_tcr_t0sz();
 
 	preempt_disable();
 	trace_hardirqs_off();
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index c6daaf6c6f97..c4f60393383e 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -40,6 +40,8 @@
 
 #include "mm.h"
 
+u64 idmap_t0sz = TCR_T0SZ(VA_BITS);
+
 /*
  * Empty_zero_page is a special page that is used for zero-initialized data
  * and COW.
@@ -454,6 +456,7 @@ void __init paging_init(void)
 	 */
 	cpu_set_reserved_ttbr0();
 	flush_tlb_all();
+	cpu_set_default_tcr_t0sz();
 }
 
 /*
@@ -461,8 +464,10 @@ void __init paging_init(void)
  */
 void setup_mm_for_reboot(void)
 {
-	cpu_switch_mm(idmap_pg_dir, &init_mm);
+	cpu_set_reserved_ttbr0();
 	flush_tlb_all();
+	cpu_set_idmap_tcr_t0sz();
+	cpu_switch_mm(idmap_pg_dir, &init_mm);
 }
 
 /*
diff --git a/arch/arm64/mm/proc-macros.S b/arch/arm64/mm/proc-macros.S
index 005d29e2977d..c17fdd6a19bc 100644
--- a/arch/arm64/mm/proc-macros.S
+++ b/arch/arm64/mm/proc-macros.S
@@ -52,3 +52,14 @@
 	mov	\reg, #4			// bytes per word
 	lsl	\reg, \reg, \tmp		// actual cache line size
 	.endm
+
+/*
+ * tcr_set_idmap_t0sz - update TCR.T0SZ so that we can load the ID map
+ */
+	.macro	tcr_set_idmap_t0sz, valreg, tmpreg
+#ifndef CONFIG_ARM64_VA_BITS_48
+	adrp	\tmpreg, idmap_t0sz
+	ldr	\tmpreg, [\tmpreg, #:lo12:idmap_t0sz]
+	bfi	\valreg, \tmpreg, #TCR_T0SZ_OFFSET, #TCR_TxSZ_WIDTH
+#endif
+	.endm
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 28eebfb6af76..cdd754e19b9b 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -156,6 +156,7 @@ ENTRY(cpu_do_resume)
 	msr	cpacr_el1, x6
 	msr	ttbr0_el1, x1
 	msr	ttbr1_el1, x7
+	tcr_set_idmap_t0sz x8, x7
 	msr	tcr_el1, x8
 	msr	vbar_el1, x9
 	msr	mdscr_el1, x10
@@ -233,6 +234,8 @@ ENTRY(__cpu_setup)
 	 */
 	ldr	x10, =TCR_TxSZ(VA_BITS) | TCR_CACHE_FLAGS | TCR_SMP_FLAGS | \
 			TCR_TG_FLAGS | TCR_ASID16 | TCR_TBI0
+	tcr_set_idmap_t0sz	x10, x9
+
 	/*
 	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the IPS bits in
 	 * TCR_EL1.
-- 
1.8.3.2
