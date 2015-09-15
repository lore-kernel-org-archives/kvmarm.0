From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: [PATCH 02/15] arm64: Handle section maps for swapper/idmap
Date: Tue, 15 Sep 2015 16:41:11 +0100
Message-ID: <1442331684-28818-3-git-send-email-suzuki.poulose@arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Catalin.Marinas@arm.com, Will.Deacon@arm.com, Mark.Rutland@arm.com, Marc.Zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, ard.biesheuvel@linaro.org, suzuki.poulose@arm.com, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

We use section maps with 4K page size to create the swapper/idmaps.
So far we have used !64K or 4K checks to handle the case where we
use the section maps.
This patch adds a new symbol, ARM64_SWAPPER_USES_SECTION_MAPS, to
handle cases where we use section maps, instead of using the page size
symbols.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
---
Changes since v1:
  - Use ARM64_SWAPPER_USES_SECTION_MAPS for vmemmap_populate()
  - Fix description
---
 arch/arm64/include/asm/kernel-pgtable.h |   31 ++++++++-----
 arch/arm64/mm/mmu.c                     |   72 ++++++++++++++-------------=
----
 2 files changed, 52 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/a=
sm/kernel-pgtable.h
index 622929d..5876a36 100644
--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -19,6 +19,13 @@
 #ifndef __ASM_KERNEL_PGTABLE_H
 #define __ASM_KERNEL_PGTABLE_H
=20
+/* With 4K pages, we use section maps. */
+#ifdef CONFIG_ARM64_4K_PAGES
+#define ARM64_SWAPPER_USES_SECTION_MAPS 1
+#else
+#define ARM64_SWAPPER_USES_SECTION_MAPS 0
+#endif
+
 /*
  * The idmap and swapper page tables need some space reserved in the kerne=
l
  * image. Both require pgd, pud (4 levels only) and pmd tables to (section=
)
@@ -28,26 +35,28 @@
  * could be increased on the fly if system RAM is out of reach for the def=
ault
  * VA range, so 3 pages are reserved in all cases.
  */
-#ifdef CONFIG_ARM64_64K_PAGES
-#define SWAPPER_PGTABLE_LEVELS=09(CONFIG_PGTABLE_LEVELS)
-#else
+#if ARM64_SWAPPER_USES_SECTION_MAPS
 #define SWAPPER_PGTABLE_LEVELS=09(CONFIG_PGTABLE_LEVELS - 1)
+#else
+#define SWAPPER_PGTABLE_LEVELS=09(CONFIG_PGTABLE_LEVELS)
 #endif
=20
 #define SWAPPER_DIR_SIZE=09(SWAPPER_PGTABLE_LEVELS * PAGE_SIZE)
 #define IDMAP_DIR_SIZE=09=09(3 * PAGE_SIZE)
=20
 /* Initial memory map size */
-#ifdef CONFIG_ARM64_64K_PAGES
-#define SWAPPER_BLOCK_SHIFT=09PAGE_SHIFT
-#define SWAPPER_BLOCK_SIZE=09PAGE_SIZE
-#define SWAPPER_TABLE_SHIFT=09PMD_SHIFT
-#else
+#if ARM64_SWAPPER_USES_SECTION_MAPS
 #define SWAPPER_BLOCK_SHIFT=09SECTION_SHIFT
 #define SWAPPER_BLOCK_SIZE=09SECTION_SIZE
 #define SWAPPER_TABLE_SHIFT=09PUD_SHIFT
+#else
+#define SWAPPER_BLOCK_SHIFT=09PAGE_SHIFT
+#define SWAPPER_BLOCK_SIZE=09PAGE_SIZE
+#define SWAPPER_TABLE_SHIFT=09PMD_SHIFT
 #endif
=20
+/* The size of the initial kernel direct mapping */
+#define SWAPPER_INIT_MAP_SIZE=09(_AC(1, UL) << SWAPPER_TABLE_SHIFT)
=20
 /*
  * Initial memory map attributes.
@@ -55,10 +64,10 @@
 #define SWAPPER_PTE_FLAGS=09PTE_TYPE_PAGE | PTE_AF | PTE_SHARED
 #define SWAPPER_PMD_FLAGS=09PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S
=20
-#ifdef CONFIG_ARM64_64K_PAGES
-#define SWAPPER_MM_MMUFLAGS=09PTE_ATTRINDX(MT_NORMAL) | SWAPPER_PTE_FLAGS
-#else
+#if ARM64_SWAPPER_USES_SECTION_MAPS
 #define SWAPPER_MM_MMUFLAGS=09PMD_ATTRINDX(MT_NORMAL) | SWAPPER_PMD_FLAGS
+#else
+#define SWAPPER_MM_MMUFLAGS=09PTE_ATTRINDX(MT_NORMAL) | SWAPPER_PTE_FLAGS
 #endif
=20
=20
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 9211b85..f533312 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -32,6 +32,7 @@
=20
 #include <asm/cputype.h>
 #include <asm/fixmap.h>
+#include <asm/kernel-pgtable.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/sizes.h>
@@ -353,14 +354,11 @@ static void __init map_mem(void)
 =09 * memory addressable from the initial direct kernel mapping.
 =09 *
 =09 * The initial direct kernel mapping, located at swapper_pg_dir, gives
-=09 * us PUD_SIZE (4K pages) or PMD_SIZE (64K pages) memory starting from
-=09 * PHYS_OFFSET (which must be aligned to 2MB as per
-=09 * Documentation/arm64/booting.txt).
+=09 * us PUD_SIZE (with SECTION maps, i.e, 4K) or PMD_SIZE (without
+=09 * SECTION maps, i.e, 64K pages) memory starting from PHYS_OFFSET
+=09 * (which must be aligned to 2MB as per Documentation/arm64/booting.txt=
).
 =09 */
-=09if (IS_ENABLED(CONFIG_ARM64_64K_PAGES))
-=09=09limit =3D PHYS_OFFSET + PMD_SIZE;
-=09else
-=09=09limit =3D PHYS_OFFSET + PUD_SIZE;
+=09limit =3D PHYS_OFFSET + SWAPPER_INIT_MAP_SIZE;
 =09memblock_set_current_limit(limit);
=20
 =09/* map all the memory banks */
@@ -371,21 +369,24 @@ static void __init map_mem(void)
 =09=09if (start >=3D end)
 =09=09=09break;
=20
-#ifndef CONFIG_ARM64_64K_PAGES
-=09=09/*
-=09=09 * For the first memory bank align the start address and
-=09=09 * current memblock limit to prevent create_mapping() from
-=09=09 * allocating pte page tables from unmapped memory.
-=09=09 * When 64K pages are enabled, the pte page table for the
-=09=09 * first PGDIR_SIZE is already present in swapper_pg_dir.
-=09=09 */
-=09=09if (start < limit)
-=09=09=09start =3D ALIGN(start, PMD_SIZE);
-=09=09if (end < limit) {
-=09=09=09limit =3D end & PMD_MASK;
-=09=09=09memblock_set_current_limit(limit);
+=09=09if (ARM64_SWAPPER_USES_SECTION_MAPS) {
+=09=09=09/*
+=09=09=09 * For the first memory bank align the start address and
+=09=09=09 * current memblock limit to prevent create_mapping() from
+=09=09=09 * allocating pte page tables from unmapped memory. With
+=09=09=09 * the section maps, if the first block doesn't end on section
+=09=09=09 * size boundary, create_mapping() will try to allocate a pte
+=09=09=09 * page, which may be returned from an unmapped area.
+=09=09=09 * When section maps are not used, the pte page table for the
+=09=09=09 * current limit is already present in swapper_pg_dir.
+=09=09=09 */
+=09=09=09if (start < limit)
+=09=09=09=09start =3D ALIGN(start, SECTION_SIZE);
+=09=09=09if (end < limit) {
+=09=09=09=09limit =3D end & SECTION_MASK;
+=09=09=09=09memblock_set_current_limit(limit);
+=09=09=09}
 =09=09}
-#endif
 =09=09__map_memblock(start, end);
 =09}
=20
@@ -498,7 +499,7 @@ int kern_addr_valid(unsigned long addr)
 =09return pfn_valid(pte_pfn(*pte));
 }
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-#ifdef CONFIG_ARM64_64K_PAGES
+#if !ARM64_SWAPPER_USES_SECTION_MAPS
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int=
 node)
 {
 =09return vmemmap_populate_basepages(start, end, node);
@@ -638,7 +639,7 @@ void *__init fixmap_remap_fdt(phys_addr_t dt_phys)
 {
 =09const u64 dt_virt_base =3D __fix_to_virt(FIX_FDT);
 =09pgprot_t prot =3D PAGE_KERNEL | PTE_RDONLY;
-=09int granularity, size, offset;
+=09int size, offset;
 =09void *dt_virt;
=20
 =09/*
@@ -664,24 +665,15 @@ void *__init fixmap_remap_fdt(phys_addr_t dt_phys)
 =09 */
 =09BUILD_BUG_ON(dt_virt_base % SZ_2M);
=20
-=09if (IS_ENABLED(CONFIG_ARM64_64K_PAGES)) {
-=09=09BUILD_BUG_ON(__fix_to_virt(FIX_FDT_END) >> PMD_SHIFT !=3D
-=09=09=09     __fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT);
-
-=09=09granularity =3D PAGE_SIZE;
-=09} else {
-=09=09BUILD_BUG_ON(__fix_to_virt(FIX_FDT_END) >> PUD_SHIFT !=3D
-=09=09=09     __fix_to_virt(FIX_BTMAP_BEGIN) >> PUD_SHIFT);
-
-=09=09granularity =3D PMD_SIZE;
-=09}
+=09BUILD_BUG_ON(__fix_to_virt(FIX_FDT_END) >> SWAPPER_TABLE_SHIFT !=3D
+=09=09     __fix_to_virt(FIX_BTMAP_BEGIN) >> SWAPPER_TABLE_SHIFT);
=20
-=09offset =3D dt_phys % granularity;
+=09offset =3D dt_phys % SWAPPER_BLOCK_SIZE;
 =09dt_virt =3D (void *)dt_virt_base + offset;
=20
 =09/* map the first chunk so we can read the size from the header */
-=09create_mapping(round_down(dt_phys, granularity), dt_virt_base,
-=09=09       granularity, prot);
+=09create_mapping(round_down(dt_phys, SWAPPER_BLOCK_SIZE), dt_virt_base,
+=09=09       SWAPPER_BLOCK_SIZE, prot);
=20
 =09if (fdt_check_header(dt_virt) !=3D 0)
 =09=09return NULL;
@@ -690,9 +682,9 @@ void *__init fixmap_remap_fdt(phys_addr_t dt_phys)
 =09if (size > MAX_FDT_SIZE)
 =09=09return NULL;
=20
-=09if (offset + size > granularity)
-=09=09create_mapping(round_down(dt_phys, granularity), dt_virt_base,
-=09=09=09       round_up(offset + size, granularity), prot);
+=09if (offset + size > SWAPPER_BLOCK_SIZE)
+=09=09create_mapping(round_down(dt_phys, SWAPPER_BLOCK_SIZE), dt_virt_base=
,
+=09=09=09       round_up(offset + size, SWAPPER_BLOCK_SIZE), prot);
=20
 =09memblock_reserve(dt_phys, size);
=20
--=20
1.7.9.5

