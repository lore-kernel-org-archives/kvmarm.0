From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: [PATCH v3 4/8] APEI: GHES: reserve a virtual page for SEI context
Date: Thu, 30 Mar 2017 18:31:13 +0800
Message-ID: <1490869877-118713-14-git-send-email-xiexiuqi@huawei.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 520D940C51
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 06:32:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cxxG5TFAIpKA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Mar 2017 06:32:51 -0400 (EDT)
Received: from dggrg03-dlp.huawei.com (unknown [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4389C40C4A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 06:32:49 -0400 (EDT)
In-Reply-To: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, fu.wei@linaro.org, rostedt@goodmis.org, hanjun.guo@linaro.org, shiju.jose@huawei.com
Cc: wuquanming@huawei.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, gengdongjiu@huawei.com, wangxiongfeng2@huawei.com, linux-acpi@vger.kernel.org, zhengqiang10@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On arm64 platform, SEI may interrupt code which had interrupts masked.
But SEI could be masked, so it's not treated as NMI, however SEA is
treated as NMI.

So, the  memory area used to transfer hardware error information from
BIOS to Linux can be determined only in NMI, SEI(arm64), IRQ or timer
handler.

In this patch, we add a virtual page for SEI context.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 drivers/acpi/apei/ghes.c | 98 +++++++++++++++++++++++-------------------------
 1 file changed, 47 insertions(+), 51 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 045d101..b1f9b1f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -108,26 +108,33 @@
 
 /*
  * Because the memory area used to transfer hardware error information
- * from BIOS to Linux can be determined only in NMI, IRQ or timer
- * handler, but general ioremap can not be used in atomic context, so
- * a special version of atomic ioremap is implemented for that.
+ * from BIOS to Linux can be determined only in NMI, SEI (ARM64), IRQ or
+ * timer handler, but general ioremap can not be used in atomic context,
+ * so a special version of atomic ioremap is implemented for that.
  */
 
 /*
- * Two virtual pages are used, one for IRQ/PROCESS context, the other for
- * NMI context (optionally).
+ * 3 virtual pages are used, one for IRQ/PROCESS context, one for SEI
+ * (on ARM64 platform), and the other for NMI context (optionally).
  */
+#ifdef CONFIG_ACPI_APEI_SEI
+#define GHES_IOREMAP_PAGES           3
+#define GHES_IOREMAP_SEI_PAGE(base)	((base) + PAGE_SIZE*2)
+#else
 #define GHES_IOREMAP_PAGES           2
+#endif
+
 #define GHES_IOREMAP_IRQ_PAGE(base)	(base)
 #define GHES_IOREMAP_NMI_PAGE(base)	((base) + PAGE_SIZE)
 
 /* virtual memory area for atomic ioremap */
 static struct vm_struct *ghes_ioremap_area;
 /*
- * These 2 spinlock is used to prevent atomic ioremap virtual memory
+ * These 3 spinlock is used to prevent atomic ioremap virtual memory
  * area from being mapped simultaneously.
  */
 static DEFINE_RAW_SPINLOCK(ghes_ioremap_lock_nmi);
+static DEFINE_SPINLOCK(ghes_ioremap_lock_sei);
 static DEFINE_SPINLOCK(ghes_ioremap_lock_irq);
 
 static struct gen_pool *ghes_estatus_pool;
@@ -155,54 +162,55 @@ static void ghes_ioremap_exit(void)
 	free_vm_area(ghes_ioremap_area);
 }
 
-static void __iomem *ghes_ioremap_pfn_nmi(u64 pfn)
+static void __iomem *ghes_ioremap_pfn(u64 pfn)
 {
-	unsigned long vaddr;
+	unsigned long vaddr, flags = 0;
 	phys_addr_t paddr;
 	pgprot_t prot;
 
-	vaddr = (unsigned long)GHES_IOREMAP_NMI_PAGE(ghes_ioremap_area->addr);
-
-	paddr = pfn << PAGE_SHIFT;
-	prot = arch_apei_get_mem_attribute(paddr);
-	ioremap_page_range(vaddr, vaddr + PAGE_SIZE, paddr, prot);
-
-	return (void __iomem *)vaddr;
-}
-
-static void __iomem *ghes_ioremap_pfn_irq(u64 pfn)
-{
-	unsigned long vaddr, paddr;
-	pgprot_t prot;
-
-	vaddr = (unsigned long)GHES_IOREMAP_IRQ_PAGE(ghes_ioremap_area->addr);
+	if (in_nmi()) {
+		raw_spin_lock(&ghes_ioremap_lock_nmi);
+		vaddr = (unsigned long)GHES_IOREMAP_NMI_PAGE(ghes_ioremap_area->addr);
+	} else if (this_cpu_read(sei_in_process)) {
+		spin_lock_irqsave(&ghes_ioremap_lock_sei, flags);
+		vaddr = (unsigned long)GHES_IOREMAP_SEI_PAGE(ghes_ioremap_area->addr);
+	} else {
+		spin_lock_irqsave(&ghes_ioremap_lock_irq, flags);
+		vaddr = (unsigned long)GHES_IOREMAP_IRQ_PAGE(ghes_ioremap_area->addr);
+	}
 
 	paddr = pfn << PAGE_SHIFT;
 	prot = arch_apei_get_mem_attribute(paddr);
-
 	ioremap_page_range(vaddr, vaddr + PAGE_SIZE, paddr, prot);
 
 	return (void __iomem *)vaddr;
 }
 
-static void ghes_iounmap_nmi(void __iomem *vaddr_ptr)
+static void ghes_iounmap(void __iomem *vaddr_ptr)
 {
 	unsigned long vaddr = (unsigned long __force)vaddr_ptr;
 	void *base = ghes_ioremap_area->addr;
+	unsigned long page, flags = 0;
+
+	if (in_nmi()) {
+		page = (unsigned long)GHES_IOREMAP_NMI_PAGE(base);
+	} else if (this_cpu_read(sei_in_process)) {
+		page = (unsigned long)GHES_IOREMAP_SEI_PAGE(base);
+	} else {
+		page = (unsigned long)GHES_IOREMAP_IRQ_PAGE(base);
+	}
 
-	BUG_ON(vaddr != (unsigned long)GHES_IOREMAP_NMI_PAGE(base));
+	BUG_ON(vaddr != page);
 	unmap_kernel_range_noflush(vaddr, PAGE_SIZE);
 	arch_apei_flush_tlb_one(vaddr);
-}
-
-static void ghes_iounmap_irq(void __iomem *vaddr_ptr)
-{
-	unsigned long vaddr = (unsigned long __force)vaddr_ptr;
-	void *base = ghes_ioremap_area->addr;
 
-	BUG_ON(vaddr != (unsigned long)GHES_IOREMAP_IRQ_PAGE(base));
-	unmap_kernel_range_noflush(vaddr, PAGE_SIZE);
-	arch_apei_flush_tlb_one(vaddr);
+	if (in_nmi()) {
+		raw_spin_unlock(&ghes_ioremap_lock_nmi);
+	} else if (this_cpu_read(sei_in_process)) {
+		spin_unlock_irqrestore(&ghes_ioremap_lock_sei, flags);
+	} else {
+		spin_unlock_irqrestore(&ghes_ioremap_lock_irq, flags);
+	}
 }
 
 static int ghes_estatus_pool_init(void)
@@ -327,20 +335,13 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
 				  int from_phys)
 {
 	void __iomem *vaddr;
-	unsigned long flags = 0;
-	int in_nmi = in_nmi();
 	u64 offset;
 	u32 trunk;
 
 	while (len > 0) {
 		offset = paddr - (paddr & PAGE_MASK);
-		if (in_nmi) {
-			raw_spin_lock(&ghes_ioremap_lock_nmi);
-			vaddr = ghes_ioremap_pfn_nmi(paddr >> PAGE_SHIFT);
-		} else {
-			spin_lock_irqsave(&ghes_ioremap_lock_irq, flags);
-			vaddr = ghes_ioremap_pfn_irq(paddr >> PAGE_SHIFT);
-		}
+		vaddr = ghes_ioremap_pfn(paddr >> PAGE_SHIFT);
+
 		trunk = PAGE_SIZE - offset;
 		trunk = min(trunk, len);
 		if (from_phys)
@@ -350,13 +351,8 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
 		len -= trunk;
 		paddr += trunk;
 		buffer += trunk;
-		if (in_nmi) {
-			ghes_iounmap_nmi(vaddr);
-			raw_spin_unlock(&ghes_ioremap_lock_nmi);
-		} else {
-			ghes_iounmap_irq(vaddr);
-			spin_unlock_irqrestore(&ghes_ioremap_lock_irq, flags);
-		}
+
+		ghes_iounmap(vaddr);
 	}
 }
 
-- 
1.8.3.1
