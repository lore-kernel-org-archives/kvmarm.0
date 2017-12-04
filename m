From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH 10/12] arm64: mm: Make VA_BITS variable, introduce VA_BITS_MIN
Date: Mon,  4 Dec 2017 14:13:11 +0000
Message-ID: <20171204141313.31604-11-steve.capper@arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 802D249D32
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BCJSjBJ2FeWu for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:10:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 095EE49D73
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:40 -0500 (EST)
In-Reply-To: <20171204141313.31604-1-steve.capper@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: catalin.marinas@arm.com, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to allow the kernel to select different virtual address sizes
on boot we need to "de-constify" VA_BITS. This patch introduces
vabits_actual, a variable which is defined at very early boot, and
VA_BITS is then re-defined to reference this variable.

Having VA_BITS variable can potentially break a lot of code that makes
compile time deductions from it. To prevent future code changes being
made that break variable VA, this patch enforces VA_BITS to be variable
always (i.e. no CONFIG options will change this).

A new constant, VA_BITS_MIN is defined, that gives the minimum address
space size the kernel is compiled for. This is used for example in the
EFI stub code to choose the furthest addressable distance for the
initrd to be placed. Increasing the VA space size on bootup does not
invalidate this logic.

Also, VA_BITS_MIN is now used to detect whether or not additional page
table levels are required for the idmap. We used to check for
 #ifdef CONFIG_ARM64_VA_BITS_48
which does not work when moving up to 52-bits.

Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 arch/arm64/include/asm/assembler.h   |  2 +-
 arch/arm64/include/asm/efi.h         |  4 ++--
 arch/arm64/include/asm/kvm_mmu.h     |  6 ++++--
 arch/arm64/include/asm/memory.h      | 17 ++++++++++-------
 arch/arm64/include/asm/mmu_context.h |  2 +-
 arch/arm64/include/asm/pgtable.h     |  4 ++--
 arch/arm64/include/asm/processor.h   |  2 +-
 arch/arm64/kernel/cpufeature.c       |  2 +-
 arch/arm64/kernel/head.S             | 13 ++++++++-----
 arch/arm64/kvm/hyp-init.S            |  2 +-
 arch/arm64/mm/fault.c                |  2 +-
 arch/arm64/mm/init.c                 |  4 ++++
 arch/arm64/mm/kasan_init.c           |  6 +++---
 arch/arm64/mm/mmu.c                  |  5 ++++-
 arch/arm64/mm/proc.S                 | 21 ++++++++++++++++++++-
 15 files changed, 63 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index aef72d886677..b59c04caae44 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -344,7 +344,7 @@ alternative_endif
  * tcr_set_idmap_t0sz - update TCR.T0SZ so that we can load the ID map
  */
 	.macro	tcr_set_idmap_t0sz, valreg, tmpreg
-#ifndef CONFIG_ARM64_VA_BITS_48
+#if VA_BITS_MIN < 48
 	ldr_l	\tmpreg, idmap_t0sz
 	bfi	\valreg, \tmpreg, #TCR_T0SZ_OFFSET, #TCR_TxSZ_WIDTH
 #endif
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 650344d01124..57d0b6b13231 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -66,7 +66,7 @@ static inline unsigned long efi_get_max_fdt_addr(unsigned long dram_base)
 
 /*
  * On arm64, we have to ensure that the initrd ends up in the linear region,
- * which is a 1 GB aligned region of size '1UL << (VA_BITS - 1)' that is
+ * which is a 1 GB aligned region of size '1UL << (VA_BITS_MIN - 1)' that is
  * guaranteed to cover the kernel Image.
  *
  * Since the EFI stub is part of the kernel Image, we can relax the
@@ -77,7 +77,7 @@ static inline unsigned long efi_get_max_fdt_addr(unsigned long dram_base)
 static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
 						    unsigned long image_addr)
 {
-	return (image_addr & ~(SZ_1G - 1UL)) + (1UL << (VA_BITS - 1));
+	return (image_addr & ~(SZ_1G - 1UL)) + (1UL << (VA_BITS_MIN - 1));
 }
 
 #define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index d74d5236c26c..5174fd7e5196 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -69,8 +69,10 @@
  * mappings, and none of this applies in that case.
  */
 
-#define HYP_MAP_KERNEL_BITS	(UL(0xffffffffffffffff) << VA_BITS)
-#define HYP_MAP_HIGH_BIT	(UL(1) << (VA_BITS - 1))
+#define _HYP_MAP_KERNEL_BITS(va)	(UL(0xffffffffffffffff) << (va))
+#define _HYP_MAP_HIGH_BIT(va)		(UL(1) << ((va) - 1))
+#define HYP_MAP_KERNEL_BITS	_HYP_MAP_KERNEL_BITS(VA_BITS_MIN)
+#define HYP_MAP_HIGH_BIT	_HYP_MAP_HIGH_BIT(VA_BITS_MIN)
 
 #ifdef __ASSEMBLY__
 
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index ba80561c6ed8..652ae83468b6 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -62,11 +62,6 @@
  * VA_BITS - the maximum number of bits for virtual addresses.
  * VA_START - the first kernel virtual address.
  */
-#define VA_BITS			(CONFIG_ARM64_VA_BITS)
-#define VA_START		(UL(0xffffffffffffffff) - \
-	(UL(1) << (VA_BITS - 1)) + 1)
-#define PAGE_OFFSET		(UL(0xffffffffffffffff) - \
-	(UL(1) << VA_BITS) + 1)
 #define PAGE_OFFSET_END		(VA_START)
 #define KIMAGE_VSIZE		(SZ_512M)
 #define KIMAGE_VADDR		(UL(0) - SZ_2M - KIMAGE_VSIZE)
@@ -177,10 +172,18 @@
 #endif
 
 #ifndef __ASSEMBLY__
+extern u64			vabits_actual;
+#define VA_BITS			({vabits_actual;})
+#define VA_START		(UL(0xffffffffffffffff) - \
+	(UL(1) << (VA_BITS - 1)) + 1)
+#define PAGE_OFFSET		(UL(0xffffffffffffffff) - \
+	(UL(1) << VA_BITS) + 1)
+#define PAGE_OFFSET_END		(VA_START)
 
 #include <linux/bitops.h>
 #include <linux/mmdebug.h>
 
+extern s64			physvirt_offset;
 extern s64			memstart_addr;
 /* PHYS_OFFSET - the physical address of the start of memory. */
 #define PHYS_OFFSET		({ VM_BUG_ON(memstart_addr & 1); memstart_addr; })
@@ -226,7 +229,7 @@ static inline unsigned long kaslr_offset(void)
  */
 #define __is_lm_address(addr)	(!((addr) & BIT(VA_BITS - 1)))
 
-#define __lm_to_phys(addr)	(((addr) & ~PAGE_OFFSET) + PHYS_OFFSET)
+#define __lm_to_phys(addr)	(((addr) + physvirt_offset))
 #define __kimg_to_phys(addr)	((addr) - kimage_voffset)
 
 #define __virt_to_phys_nodebug(x) ({					\
@@ -245,7 +248,7 @@ extern phys_addr_t __phys_addr_symbol(unsigned long x);
 #define __phys_addr_symbol(x)	__pa_symbol_nodebug(x)
 #endif
 
-#define __phys_to_virt(x)	((unsigned long)((x) - PHYS_OFFSET) | PAGE_OFFSET)
+#define __phys_to_virt(x)	((unsigned long)((x) - physvirt_offset))
 #define __phys_to_kimg(x)	((unsigned long)((x) + kimage_voffset))
 
 /*
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 3257895a9b5e..e57ed28ed360 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -66,7 +66,7 @@ extern u64 idmap_t0sz;
 
 static inline bool __cpu_uses_extended_idmap(void)
 {
-	return (!IS_ENABLED(CONFIG_ARM64_VA_BITS_48) &&
+	return ((VA_BITS_MIN < 48) &&
 		unlikely(idmap_t0sz != TCR_T0SZ(VA_BITS)));
 }
 
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 5506f7d66bfa..2cfcb406f0dd 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -683,8 +683,8 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 }
 #endif
 
-extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
-extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
+extern pgd_t swapper_pg_dir[];
+extern pgd_t idmap_pg_dir[];
 extern pgd_t swapper_pg_end[];
 /*
  * Encode and decode a swap entry:
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 023cacb946c3..aa294d1ddea8 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -19,7 +19,7 @@
 #ifndef __ASM_PROCESSOR_H
 #define __ASM_PROCESSOR_H
 
-#define TASK_SIZE_64		(UL(1) << VA_BITS)
+#define TASK_SIZE_64		(UL(1) << VA_BITS_MIN)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 99b1d1ebe551..31cfffa79fee 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -834,7 +834,7 @@ static bool hyp_flip_space(const struct arm64_cpu_capabilities *entry,
 	 * - the idmap doesn't clash with it,
 	 * - the kernel is not running at EL2.
 	 */
-	return idmap_addr <= GENMASK(VA_BITS - 2, 0) && !is_kernel_in_hyp_mode();
+	return idmap_addr <= GENMASK(VA_BITS_MIN - 2, 0) && !is_kernel_in_hyp_mode();
 }
 
 static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unused)
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 71f1722685fe..6a637f91edfc 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -119,6 +119,7 @@ ENTRY(stext)
 	adrp	x23, __PHYS_OFFSET
 	and	x23, x23, MIN_KIMG_ALIGN - 1	// KASLR offset, defaults to 0
 	bl	set_cpu_boot_mode_flag
+	bl	__setup_va_constants
 	bl	__create_page_tables
 	/*
 	 * The following calls CPU setup code, see arch/arm64/mm/proc.S for
@@ -250,7 +251,9 @@ ENDPROC(preserve_boot_args)
 	add \rtbl, \tbl, #PAGE_SIZE
 	mov \sv, \rtbl
 	mov \count, #1
-	compute_indices \vstart, \vend, #PGDIR_SHIFT, #PTRS_PER_PGD, \istart, \iend, \count
+
+	ldr_l \tmp, ptrs_per_pgd
+	compute_indices \vstart, \vend, #PGDIR_SHIFT, \tmp, \istart, \iend, \count
 	populate_entries \tbl, \rtbl, \istart, \iend, #PMD_TYPE_TABLE, #PAGE_SIZE, \tmp
 	mov \tbl, \sv
 	mov \sv, \rtbl
@@ -314,7 +317,7 @@ __create_page_tables:
 	adrp	x3, __idmap_text_start		// __pa(__idmap_text_start)
 	adrp	x4, __idmap_text_end		// __pa(__idmap_text_end)
 
-#ifndef CONFIG_ARM64_VA_BITS_48
+#if (VA_BITS_MIN < 48)
 #define EXTRA_SHIFT	(PGDIR_SHIFT + PAGE_SHIFT - 3)
 #define EXTRA_PTRS	(1 << (48 - EXTRA_SHIFT))
 
@@ -329,7 +332,7 @@ __create_page_tables:
 	 * utilised, and that lowering T0SZ will always result in an additional
 	 * translation level to be configured.
 	 */
-#if VA_BITS != EXTRA_SHIFT
+#if VA_BITS_MIN != EXTRA_SHIFT
 #error "Mismatch between VA_BITS and page size/number of translation levels"
 #endif
 
@@ -340,8 +343,8 @@ __create_page_tables:
 	 * the physical address of __idmap_text_end.
 	 */
 	clz	x5, x4
-	cmp	x5, TCR_T0SZ(VA_BITS)	// default T0SZ small enough?
-	b.ge	1f			// .. then skip additional level
+	cmp	x5, TCR_T0SZ(VA_BITS_MIN)	// default T0SZ small enough?
+	b.ge	1f				// .. then skip additional level
 
 	adr_l	x6, idmap_t0sz
 	str	x5, [x6]
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 3f9615582377..729c49d9f574 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -71,7 +71,7 @@ __do_hyp_init:
 	mov	x5, #TCR_EL2_RES1
 	orr	x4, x4, x5
 
-#ifndef CONFIG_ARM64_VA_BITS_48
+#if VA_BITS_MIN < 48
 	/*
 	 * If we are running with VA_BITS < 48, we may be running with an extra
 	 * level of translation in the ID map. This is only the case if system
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 22168cd0dde7..c0e0f8638bee 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -149,7 +149,7 @@ void show_pte(unsigned long addr)
 		return;
 	}
 
-	pr_alert("%s pgtable: %luk pages, %u-bit VAs, pgd = %p\n",
+	pr_alert("%s pgtable: %luk pages, %llu-bit VAs, pgd = %p\n",
 		 mm == &init_mm ? "swapper" : "user", PAGE_SIZE / SZ_1K,
 		 VA_BITS, mm->pgd);
 	pgd = pgd_offset(mm, addr);
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 230d78b75831..7e130252edce 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -62,6 +62,8 @@
 s64 memstart_addr __ro_after_init = -1;
 phys_addr_t arm64_dma_phys_limit __ro_after_init;
 
+s64 physvirt_offset __ro_after_init = -1;
+
 #ifdef CONFIG_BLK_DEV_INITRD
 static int __init early_initrd(char *p)
 {
@@ -372,6 +374,8 @@ void __init arm64_memblock_init(void)
 	memstart_addr = round_down(memblock_start_of_DRAM(),
 				   ARM64_MEMSTART_ALIGN);
 
+	physvirt_offset = PHYS_OFFSET - PAGE_OFFSET;
+
 	/*
 	 * Remove the memory that we will not be able to cover with the
 	 * linear mapping. Take care not to clip the kernel which may be
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 968535789d13..33f99e18e4ff 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -27,7 +27,7 @@
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
 
-static pgd_t tmp_pg_dir[PTRS_PER_PGD] __initdata __aligned(PGD_SIZE);
+static pgd_t tmp_pg_dir[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
 
 /*
  * The p*d_populate functions call virt_to_phys implicitly so they can't be used
@@ -135,7 +135,7 @@ static void __init kasan_pgd_populate(unsigned long addr, unsigned long end,
 /* The early shadow maps everything to a single page of zeroes */
 asmlinkage void __init kasan_early_init(void)
 {
-	BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_START, PGDIR_SIZE));
+	BUILD_BUG_ON(!IS_ALIGNED(_KASAN_SHADOW_START(VA_BITS_MIN), PGDIR_SIZE));
 	BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_END, PGDIR_SIZE));
 	kasan_pgd_populate(KASAN_SHADOW_START, KASAN_SHADOW_END, NUMA_NO_NODE,
 			   true);
@@ -195,7 +195,7 @@ void __init kasan_init(void)
 	 * tmp_pg_dir used to keep early shadow mapped until full shadow
 	 * setup will be finished.
 	 */
-	memcpy(tmp_pg_dir, swapper_pg_dir, sizeof(tmp_pg_dir));
+	memcpy(tmp_pg_dir, swapper_pg_dir, PTRS_PER_PGD * sizeof(pgd_t));
 	dsb(ishst);
 	cpu_replace_ttbr1(lm_alias(tmp_pg_dir));
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index c8f486384fe3..8a063f22de88 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -49,7 +49,10 @@
 #define NO_BLOCK_MAPPINGS	BIT(0)
 #define NO_CONT_MAPPINGS	BIT(1)
 
-u64 idmap_t0sz = TCR_T0SZ(VA_BITS);
+u64 idmap_t0sz __ro_after_init;
+u64 ptrs_per_pgd __ro_after_init;
+u64 vabits_actual __ro_after_init;
+EXPORT_SYMBOL(vabits_actual);
 
 u64 kimage_voffset __ro_after_init;
 EXPORT_SYMBOL(kimage_voffset);
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 95233dfc4c39..607a6ff0e205 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -223,7 +223,7 @@ ENTRY(__cpu_setup)
 	 * Set/prepare TCR and TTBR. We use 512GB (39-bit) address range for
 	 * both user and kernel.
 	 */
-	ldr	x10, =TCR_TxSZ(VA_BITS) | TCR_CACHE_FLAGS | TCR_SMP_FLAGS | \
+	ldr	x10, =TCR_TxSZ(VA_BITS_MIN) | TCR_CACHE_FLAGS | TCR_SMP_FLAGS | \
 			TCR_TG_FLAGS | TCR_ASID16 | TCR_TBI0
 	tcr_set_idmap_t0sz	x10, x9
 
@@ -250,6 +250,25 @@ ENTRY(__cpu_setup)
 	ret					// return to head.S
 ENDPROC(__cpu_setup)
 
+ENTRY(__setup_va_constants)
+	mov	x0, #VA_BITS_MIN
+	mov	x1, TCR_T0SZ(VA_BITS_MIN)
+	mov	x2, #1 << (VA_BITS_MIN - PGDIR_SHIFT)
+	str_l	x0, vabits_actual, x5
+	str_l	x1, idmap_t0sz, x5
+	str_l	x2, ptrs_per_pgd, x5
+
+	adr_l	x0, vabits_actual
+	adr_l	x1, idmap_t0sz
+	adr_l	x2, ptrs_per_pgd
+	dmb	sy
+	dc	ivac, x0	// Invalidate potentially stale cache
+	dc	ivac, x1
+	dc	ivac, x2
+
+	ret
+ENDPROC(__setup_va_constants)
+
 	/*
 	 * We set the desired value explicitly, including those of the
 	 * reserved bits. The values of bits EE & E0E were set early in
-- 
2.11.0
