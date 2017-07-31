From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 10/59] irqchip/gic-v3-its: Split out pending table allocation
Date: Mon, 31 Jul 2017 18:25:48 +0100
Message-ID: <20170731172637.29355-11-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
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
index 9a317934455c..ebdb1603b95d 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1202,6 +1202,24 @@ static int its_alloc_collections(struct its_node *its)
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
+				get_order(max_t(u32, LPI_PENDBASE_SZ, SZ_64K)));
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
@@ -1212,21 +1230,14 @@ static void its_cpu_init_lpis(void)
 	pend_page = gic_data_rdist()->pend_page;
 	if (!pend_page) {
 		phys_addr_t paddr;
-		/*
-		 * The pending pages have to be at least 64kB aligned,
-		 * hence the 'max(LPI_PENDBASE_SZ, SZ_64K)' below.
-		 */
-		pend_page = alloc_pages(GFP_NOWAIT | __GFP_ZERO,
-					get_order(max_t(u32, LPI_PENDBASE_SZ, SZ_64K)));
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
