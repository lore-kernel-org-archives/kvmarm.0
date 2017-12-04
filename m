From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH 09/12] arm64: dump: Make kernel page table dumper dynamic again
Date: Mon,  4 Dec 2017 14:13:10 +0000
Message-ID: <20171204141313.31604-10-steve.capper@arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3947D49D61
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DhdsKRpE2nmY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:10:39 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CDF249D74
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:38 -0500 (EST)
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

The kernel page table dumper assumes that the placement of VA regions is
constant and determined at compile time. As we are about to introduce
variable VA logic, we need to be able to determine certain regions at
boot time.

This patch adds logic to the kernel page table dumper s.t. these regions
can be computed at boot time.

Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 arch/arm64/mm/dump.c | 51 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
index e5d1b5f432fe..c50af666c407 100644
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@ -29,18 +29,42 @@
 #include <asm/pgtable-hwdef.h>
 #include <asm/ptdump.h>
 
-static const struct addr_marker address_markers[] = {
-	{ PAGE_OFFSET,			"Linear Mapping start" },
-	{ VA_START,			"Linear Mapping end" },
+
+enum address_markers_idx {
+	PAGE_OFFSET_NR = 0,
+	VA_START_NR,
 #ifdef CONFIG_KASAN
-	{ KASAN_SHADOW_START,		"Kasan shadow start" },
+	KASAN_START_NR,
+	KASAN_END_NR,
+#endif
+	VMALLOC_START_NR,
+	VMALLOC_END_NR,
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	VMEMMAP_START_NR,
+	VMEMMAP_END_NR,
+#endif
+	FIXADDR_START_NR,
+	FIXADDR_END_NR,
+	PCI_START_NR,
+	PCI_END_NR,
+	MODULES_START_NR,
+	MODULES_END_NR,
+	KIMAGE_NR,
+	END_NR
+};
+
+static struct addr_marker address_markers[] = {
+	{ 0 /* PAGE_OFFSET */,		"Linear Mapping start" },
+	{ 0 /* VA_START */,		"Linear Mapping end" },
+#ifdef CONFIG_KASAN
+	{ 0 /* KASAN_SHADOW_START */,	"Kasan shadow start" },
 	{ KASAN_SHADOW_END,		"Kasan shadow end" },
 #endif
-	{ VMALLOC_START,		"vmalloc() Area" },
+	{ 0 /* VMALLOC_START */,	"vmalloc() Area" },
 	{ VMALLOC_END,			"vmalloc() End" },
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-	{ VMEMMAP_START,		"vmemmap start" },
-	{ VMEMMAP_START + VMEMMAP_SIZE,	"vmemmap end"},
+	{ 0 /* VMEMMAP_START */,		"vmemmap start" },
+	{ 0 /*VMEMMAP_START + VMEMMAP_SIZE */,	"vmemmap end"},
 #endif
 	{ FIXADDR_START,		"Fixmap start" },
 	{ FIXADDR_TOP,			"Fixmap end" },
@@ -377,7 +401,6 @@ static void ptdump_initialize(void)
 static struct ptdump_info kernel_ptdump_info = {
 	.mm		= &init_mm,
 	.markers	= address_markers,
-	.base_addr	= PAGE_OFFSET,
 };
 
 void ptdump_check_wx(void)
@@ -403,6 +426,18 @@ void ptdump_check_wx(void)
 static int ptdump_init(void)
 {
 	ptdump_initialize();
+	kernel_ptdump_info.base_addr = PAGE_OFFSET;
+	address_markers[PAGE_OFFSET_NR].start_address = PAGE_OFFSET;
+	address_markers[VA_START_NR].start_address = VA_START;
+#ifdef CONFIG_KASAN
+	address_markers[KASAN_START_NR].start_address = KASAN_SHADOW_START;
+#endif
+	address_markers[VMALLOC_START_NR].start_address = VMALLOC_START;
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	address_markers[VMEMMAP_START_NR].start_address = VMEMMAP_START;
+	address_markers[VMEMMAP_END_NR].start_address = VMEMMAP_START
+							+ VMEMMAP_SIZE;
+#endif
 	return ptdump_debugfs_register(&kernel_ptdump_info,
 					"kernel_page_tables");
 }
-- 
2.11.0
