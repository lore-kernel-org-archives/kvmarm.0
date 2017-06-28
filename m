From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 10/52] irqchip/gic-v3-its: Split out pending table
 allocation
Date: Wed, 28 Jun 2017 16:03:29 +0100
Message-ID: <20170628150411.15846-11-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A64540DFF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tRPLGsvgBWuI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:04:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26EE74113E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:45 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
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
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

Just as for the property table, let's move the pending table
allocation to a separate function.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 27f57c528026..d6f9ccb36f4d 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1199,6 +1199,24 @@ static int its_alloc_collections(struct its_node *its)
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
@@ -1209,21 +1227,14 @@ static void its_cpu_init_lpis(void)
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
2.11.0
