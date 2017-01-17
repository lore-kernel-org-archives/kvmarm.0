From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 11/33] irqchip/gic-v3-its: Split out pending table
 allocation
Date: Tue, 17 Jan 2017 10:20:32 +0000
Message-ID: <1484648454-21216-12-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7948740693
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JIMv1E9cttSL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E7E54080B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:39 -0500 (EST)
In-Reply-To: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Just as for the property table, let's move the pending table
allocation to a separate function.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 14305db1..dce8f8c 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1188,6 +1188,24 @@ static int its_alloc_collections(struct its_node *its)
 	return 0;
 }
 
+static struct page *its_allocate_pending_table(gfp_t gfp_flags)
+{
+	struct page *pend_page;
+	/*
+	 * The pending pages have to be at least 64kB aligned,
+	 * hence the 'max(LPI_PENDBASE_SZ, SZ_64K)' below.
+	 */
+	pend_page = alloc_pages(gfp_flags | __GFP_ZERO,
+				get_order(max(LPI_PENDBASE_SZ, SZ_64K)));
+	if (!pend_page)
+		return NULL;
+
+	/* Make sure the GIC will observe the zero-ed page */
+	gic_flush_dcache_to_poc(page_address(pend_page), LPI_PENDBASE_SZ);
+
+	return pend_page;
+}
+
 static void its_cpu_init_lpis(void)
 {
 	void __iomem *rbase = gic_data_rdist_rd_base();
@@ -1198,21 +1216,14 @@ static void its_cpu_init_lpis(void)
 	pend_page = gic_data_rdist()->pend_page;
 	if (!pend_page) {
 		phys_addr_t paddr;
-		/*
-		 * The pending pages have to be at least 64kB aligned,
-		 * hence the 'max(LPI_PENDBASE_SZ, SZ_64K)' below.
-		 */
-		pend_page = alloc_pages(GFP_NOWAIT | __GFP_ZERO,
-					get_order(max(LPI_PENDBASE_SZ, SZ_64K)));
+
+		pend_page = its_allocate_pending_table(GFP_NOWAIT);
 		if (!pend_page) {
 			pr_err("Failed to allocate PENDBASE for CPU%d\n",
 			       smp_processor_id());
 			return;
 		}
 
-		/* Make sure the GIC will observe the zero-ed page */
-		gic_flush_dcache_to_poc(page_address(pend_page), LPI_PENDBASE_SZ);
-
 		paddr = page_to_phys(pend_page);
 		pr_info("CPU%d: using LPI pending table @%pa\n",
 			smp_processor_id(), &paddr);
-- 
2.1.4
