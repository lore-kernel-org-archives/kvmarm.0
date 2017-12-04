From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH 07/12] arm64: mm: Place kImage at bottom of VA space
Date: Mon,  4 Dec 2017 14:13:08 +0000
Message-ID: <20171204141313.31604-8-steve.capper@arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31AA649D74
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t3NwCOdp+nu9 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:10:37 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7302749D4E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:35 -0500 (EST)
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

Re-arrange the kernel memory map s.t. the kernel image resides in the
bottom 514MB of memory. With the modules, fixed map, PCI IO space placed
above it. At the very bottom of the memory map we set aside a 2MB guard
region to prevent ambiguity with PTR_ERR/ERR_PTR.

Dynamically resizable objects such as KASAN shadow and sparsemem map
are placed above the fixed size objects.

This means that kernel addresses are now no longer directly dependent on
VA space size.

Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 arch/arm64/include/asm/memory.h  | 17 +++++++++--------
 arch/arm64/include/asm/pgtable.h |  4 ++--
 arch/arm64/mm/dump.c             | 12 +++++++-----
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 0a912eb3d74f..ba80561c6ed8 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -68,14 +68,15 @@
 #define PAGE_OFFSET		(UL(0xffffffffffffffff) - \
 	(UL(1) << VA_BITS) + 1)
 #define PAGE_OFFSET_END		(VA_START)
-#define KIMAGE_VADDR		(MODULES_END)
-#define MODULES_END		(MODULES_VADDR + MODULES_VSIZE)
-#define MODULES_VADDR		(VA_START + KASAN_SHADOW_SIZE)
+#define KIMAGE_VSIZE		(SZ_512M)
+#define KIMAGE_VADDR		(UL(0) - SZ_2M - KIMAGE_VSIZE)
 #define MODULES_VSIZE		(SZ_128M)
-#define VMEMMAP_START		(-VMEMMAP_SIZE)
-#define PCI_IO_END		(VMEMMAP_START - SZ_2M)
+#define MODULES_END		(KIMAGE_VADDR)
+#define MODULES_VADDR		(MODULES_END - MODULES_VSIZE)
+#define PCI_IO_END		(MODULES_VADDR - SZ_2M)
 #define PCI_IO_START		(PCI_IO_END - PCI_IO_SIZE)
-#define FIXADDR_TOP		(PCI_IO_START - SZ_2M)
+#define FIXADDR_TOP		(PCI_IO_START - PGDIR_SIZE)
+#define VMEMMAP_START		(FIXADDR_START - VMEMMAP_SIZE)
 
 #define KERNEL_START      _text
 #define KERNEL_END        _end
@@ -292,10 +293,10 @@ static inline void *phys_to_virt(phys_addr_t x)
 #define _virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 #else
 #define __virt_to_pgoff(kaddr)	(((u64)(kaddr) & ~PAGE_OFFSET) / PAGE_SIZE * sizeof(struct page))
-#define __page_to_voff(kaddr)	(((u64)(kaddr) & ~VMEMMAP_START) * PAGE_SIZE / sizeof(struct page))
+#define __page_to_voff(kaddr)	(((u64)(kaddr) - VMEMMAP_START) * PAGE_SIZE / sizeof(struct page))
 
 #define page_to_virt(page)	((void *)((__page_to_voff(page)) | PAGE_OFFSET))
-#define virt_to_page(vaddr)	((struct page *)((__virt_to_pgoff(vaddr)) | VMEMMAP_START))
+#define virt_to_page(vaddr)	((struct page *)((__virt_to_pgoff(vaddr)) + VMEMMAP_START))
 
 #define _virt_addr_valid(kaddr)	pfn_valid((((u64)(kaddr) & ~PAGE_OFFSET) \
 					   + PHYS_OFFSET) >> PAGE_SHIFT)
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 054b37143a50..e8b4dcc11fed 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -30,8 +30,8 @@
  * VMALLOC_END: extends to the available space below vmmemmap, PCI I/O space
  *	and fixed mappings
  */
-#define VMALLOC_START		(MODULES_END)
-#define VMALLOC_END		(- PUD_SIZE - VMEMMAP_SIZE - SZ_64K)
+#define VMALLOC_START		(VA_START + KASAN_SHADOW_SIZE)
+#define VMALLOC_END		(FIXADDR_TOP - PUD_SIZE)
 
 #define vmemmap			((struct page *)VMEMMAP_START - (memstart_addr >> PAGE_SHIFT))
 
diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
index b7b09c0fc50d..e5d1b5f432fe 100644
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@ -36,17 +36,19 @@ static const struct addr_marker address_markers[] = {
 	{ KASAN_SHADOW_START,		"Kasan shadow start" },
 	{ KASAN_SHADOW_END,		"Kasan shadow end" },
 #endif
-	{ MODULES_VADDR,		"Modules start" },
-	{ MODULES_END,			"Modules end" },
 	{ VMALLOC_START,		"vmalloc() Area" },
 	{ VMALLOC_END,			"vmalloc() End" },
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	{ VMEMMAP_START,		"vmemmap start" },
+	{ VMEMMAP_START + VMEMMAP_SIZE,	"vmemmap end"},
+#endif
 	{ FIXADDR_START,		"Fixmap start" },
 	{ FIXADDR_TOP,			"Fixmap end" },
 	{ PCI_IO_START,			"PCI I/O start" },
 	{ PCI_IO_END,			"PCI I/O end" },
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-	{ VMEMMAP_START,		"vmemmap" },
-#endif
+	{ MODULES_VADDR,		"Modules start" },
+	{ MODULES_END,			"Modules end" },
+	{ KIMAGE_VADDR,			"kImage start"},
 	{ -1,				NULL },
 };
 
-- 
2.11.0
