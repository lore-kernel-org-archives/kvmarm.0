From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH V2 2/7] arm64: mm: Flip kernel VA space
Date: Mon, 18 Dec 2017 21:47:31 +0000
Message-ID: <20171218214736.13761-3-steve.capper@arm.com>
References: <20171218214736.13761-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D8A449D7D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 16:44:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fgSZnnpU3VIu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Dec 2017 16:44:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB80449D79
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 16:44:09 -0500 (EST)
In-Reply-To: <20171218214736.13761-1-steve.capper@arm.com>
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

Put the direct linear map in the lower addresses of the kernel VA range
and everything else in the higher ranges.

This allows us to make room for an inline KASAN shadow that operates
under both 48 and 52 bit kernel VA sizes. For example with a 52-bit VA,
if KASAN_SHADOW_END < 0xFFF8000000000000 (it is in the lower addresses
of the kernel VA range), this will be below the start of the minimum
48-bit kernel VA address of 0xFFFF000000000000.

We need to adjust:
 *) KASAN shadow region placement logic,
 *) KASAN_SHADOW_OFFSET computation logic,
 *) virt_to_phys, phys_to_virt checks,
 *) page table dumper.

These are all small changes, that need to take place atomically, so they
are bundled into this commit.

Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 arch/arm64/Makefile              |  2 +-
 arch/arm64/include/asm/memory.h  | 10 +++++-----
 arch/arm64/include/asm/pgtable.h |  2 +-
 arch/arm64/mm/dump.c             |  8 ++++----
 arch/arm64/mm/init.c             |  9 +--------
 arch/arm64/mm/kasan_init.c       |  4 ++--
 arch/arm64/mm/mmu.c              |  4 ++--
 7 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index b481b4a7c011..7eaff48d2a39 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -100,7 +100,7 @@ endif
 # KASAN_SHADOW_OFFSET = VA_START + (1 << (VA_BITS - 3)) - (1 << 61)
 # in 32-bit arithmetic
 KASAN_SHADOW_OFFSET := $(shell printf "0x%08x00000000\n" $$(( \
-			(0xffffffff & (-1 << ($(CONFIG_ARM64_VA_BITS) - 32))) \
+			(0xffffffff & (-1 << ($(CONFIG_ARM64_VA_BITS) - 1 - 32))) \
 			+ (1 << ($(CONFIG_ARM64_VA_BITS) - 32 - 3)) \
 			- (1 << (64 - 32 - 3)) )) )
 
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 2dedc775d151..0a912eb3d74f 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -64,15 +64,15 @@
  */
 #define VA_BITS			(CONFIG_ARM64_VA_BITS)
 #define VA_START		(UL(0xffffffffffffffff) - \
-	(UL(1) << VA_BITS) + 1)
-#define PAGE_OFFSET		(UL(0xffffffffffffffff) - \
 	(UL(1) << (VA_BITS - 1)) + 1)
-#define PAGE_OFFSET_END		(~0UL)
+#define PAGE_OFFSET		(UL(0xffffffffffffffff) - \
+	(UL(1) << VA_BITS) + 1)
+#define PAGE_OFFSET_END		(VA_START)
 #define KIMAGE_VADDR		(MODULES_END)
 #define MODULES_END		(MODULES_VADDR + MODULES_VSIZE)
 #define MODULES_VADDR		(VA_START + KASAN_SHADOW_SIZE)
 #define MODULES_VSIZE		(SZ_128M)
-#define VMEMMAP_START		(PAGE_OFFSET - VMEMMAP_SIZE)
+#define VMEMMAP_START		(-VMEMMAP_SIZE)
 #define PCI_IO_END		(VMEMMAP_START - SZ_2M)
 #define PCI_IO_START		(PCI_IO_END - PCI_IO_SIZE)
 #define FIXADDR_TOP		(PCI_IO_START - SZ_2M)
@@ -223,7 +223,7 @@ static inline unsigned long kaslr_offset(void)
  * space. Testing the top bit for the start of the region is a
  * sufficient check.
  */
-#define __is_lm_address(addr)	(!!((addr) & BIT(VA_BITS - 1)))
+#define __is_lm_address(addr)	(!((addr) & BIT(VA_BITS - 1)))
 
 #define __lm_to_phys(addr)	(((addr) & ~PAGE_OFFSET) + PHYS_OFFSET)
 #define __kimg_to_phys(addr)	((addr) - kimage_voffset)
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 6d611f8b7c5b..63ea76cc8357 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -31,7 +31,7 @@
  *	and fixed mappings
  */
 #define VMALLOC_START		(MODULES_END)
-#define VMALLOC_END		(PAGE_OFFSET - PUD_SIZE - VMEMMAP_SIZE - SZ_64K)
+#define VMALLOC_END		(- PUD_SIZE - VMEMMAP_SIZE - SZ_64K)
 
 #define vmemmap			((struct page *)VMEMMAP_START - (memstart_addr >> PAGE_SHIFT))
 
diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
index 7b60d62ac593..d1814b247d4b 100644
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@ -30,6 +30,8 @@
 #include <asm/ptdump.h>
 
 static const struct addr_marker address_markers[] = {
+	{ PAGE_OFFSET,			"Linear Mapping start" },
+	{ VA_START,			"Linear Mapping end" },
 #ifdef CONFIG_KASAN
 	{ KASAN_SHADOW_START,		"Kasan shadow start" },
 	{ KASAN_SHADOW_END,		"Kasan shadow end" },
@@ -43,10 +45,8 @@ static const struct addr_marker address_markers[] = {
 	{ PCI_IO_START,			"PCI I/O start" },
 	{ PCI_IO_END,			"PCI I/O end" },
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-	{ VMEMMAP_START,		"vmemmap start" },
-	{ VMEMMAP_START + VMEMMAP_SIZE,	"vmemmap end" },
+	{ VMEMMAP_START,		"vmemmap" },
 #endif
-	{ PAGE_OFFSET,			"Linear Mapping" },
 	{ -1,				NULL },
 };
 
@@ -375,7 +375,7 @@ static void ptdump_initialize(void)
 static struct ptdump_info kernel_ptdump_info = {
 	.mm		= &init_mm,
 	.markers	= address_markers,
-	.base_addr	= VA_START,
+	.base_addr	= PAGE_OFFSET,
 };
 
 void ptdump_check_wx(void)
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index d84c77125b3a..0a5da98f92fa 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -361,19 +361,12 @@ static void __init fdt_enforce_memory_region(void)
 
 void __init arm64_memblock_init(void)
 {
-	const s64 linear_region_size = -(s64)PAGE_OFFSET;
+	const s64 linear_region_size = BIT(VA_BITS - 1);
 
 	/* Handle linux,usable-memory-range property */
 	fdt_enforce_memory_region();
 
 	/*
-	 * Ensure that the linear region takes up exactly half of the kernel
-	 * virtual address space. This way, we can distinguish a linear address
-	 * from a kernel/module/vmalloc address by testing a single bit.
-	 */
-	BUILD_BUG_ON(linear_region_size != BIT(VA_BITS - 1));
-
-	/*
 	 * Select a suitable value for the base of physical memory.
 	 */
 	memstart_addr = round_down(memblock_start_of_DRAM(),
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index acba49fb5aac..5aef679e61c6 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -205,10 +205,10 @@ void __init kasan_init(void)
 	kasan_map_populate(kimg_shadow_start, kimg_shadow_end,
 			   pfn_to_nid(virt_to_pfn(lm_alias(_text))));
 
-	kasan_populate_zero_shadow((void *)KASAN_SHADOW_START,
+	kasan_populate_zero_shadow(kasan_mem_to_shadow((void *) VA_START),
 				   (void *)mod_shadow_start);
 	kasan_populate_zero_shadow((void *)kimg_shadow_end,
-				   kasan_mem_to_shadow((void *)PAGE_OFFSET));
+				   (void *)KASAN_SHADOW_END);
 
 	if (kimg_shadow_start > mod_shadow_end)
 		kasan_populate_zero_shadow((void *)mod_shadow_end,
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 58b1ed6fd7ec..5a16e2b9b1a2 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -356,7 +356,7 @@ static phys_addr_t pgd_pgtable_alloc(void)
 static void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
 				  phys_addr_t size, pgprot_t prot)
 {
-	if (virt < VMALLOC_START) {
+	if ((virt >= VA_START) && (virt < VMALLOC_START)) {
 		pr_warn("BUG: not creating mapping for %pa at 0x%016lx - outside kernel range\n",
 			&phys, virt);
 		return;
@@ -383,7 +383,7 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 				phys_addr_t size, pgprot_t prot)
 {
-	if (virt < VMALLOC_START) {
+	if ((virt >= VA_START) && (virt < VMALLOC_START)) {
 		pr_warn("BUG: not updating mapping for %pa at 0x%016lx - outside kernel range\n",
 			&phys, virt);
 		return;
-- 
2.11.0
