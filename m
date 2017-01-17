From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 06/33] irqchip/gic-v3-its: Add probing for VLPI properties
Date: Tue, 17 Jan 2017 10:20:27 +0000
Message-ID: <1484648454-21216-7-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 377F34019C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 39MTbJiJMt6d for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3028840692
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:32 -0500 (EST)
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

Add the probing code for the ITS VLPI support. This includes
configuring the ITS number if not supporting the single VMOVP
command feature.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c   | 47 ++++++++++++++++++++++++++++++++++----
 include/linux/irqchip/arm-gic-v3.h |  4 ++++
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 9304dd2..99f6130 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -103,6 +103,7 @@ struct its_node {
 	u32			ite_size;
 	u32			device_ids;
 	int			numa_node;
+	bool			is_v4;
 };
 
 #define ITS_ITT_ALIGN		SZ_256
@@ -135,6 +136,8 @@ static DEFINE_SPINLOCK(its_lock);
 static struct rdists *gic_rdists;
 static struct irq_domain *its_parent;
 
+static unsigned long its_list_map;
+
 #define gic_data_rdist()		(raw_cpu_ptr(gic_rdists->rdist))
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 
@@ -1661,8 +1664,8 @@ static int __init its_probe_one(struct resource *res,
 {
 	struct its_node *its;
 	void __iomem *its_base;
-	u32 val;
-	u64 baser, tmp;
+	u32 val, ctlr;
+	u64 baser, tmp, typer;
 	int err;
 
 	its_base = ioremap(res->start, resource_size(res));
@@ -1695,9 +1698,44 @@ static int __init its_probe_one(struct resource *res,
 	raw_spin_lock_init(&its->lock);
 	INIT_LIST_HEAD(&its->entry);
 	INIT_LIST_HEAD(&its->its_device_list);
+	typer = gic_read_typer(its_base + GITS_TYPER);
 	its->base = its_base;
 	its->phys_base = res->start;
-	its->ite_size = ((gic_read_typer(its_base + GITS_TYPER) >> 4) & 0xf) + 1;
+	its->ite_size = ((typer >> 4) & 0xf) + 1;
+	its->is_v4 = !!(typer & GITS_TYPER_VLPIS);
+	if (its->is_v4 && !(typer & GITS_TYPER_VMOVP)) {
+		int its_number;
+
+		its_number = find_first_zero_bit(&its_list_map, 16);
+		if (its_number >= 16) {
+			pr_err("ITS@%pa: No ITSList entry available!\n",
+			       &res->start);
+			err = -EINVAL;
+			goto out_free_its;
+		}
+
+		ctlr = readl_relaxed(its_base + GITS_CTLR);
+		ctlr &= ~GITS_CTLR_ITS_NUMBER;
+		ctlr |= its_number << GITS_CTLR_ITS_NUMBER_SHIFT;
+		writel_relaxed(ctlr, its_base + GITS_CTLR);
+		ctlr = readl_relaxed(its_base + GITS_CTLR);
+		if ((ctlr & GITS_CTLR_ITS_NUMBER) != (its_number << GITS_CTLR_ITS_NUMBER_SHIFT)) {
+			its_number = ctlr & GITS_CTLR_ITS_NUMBER;
+			its_number >>= GITS_CTLR_ITS_NUMBER_SHIFT;
+		}
+
+		if (test_and_set_bit(its_number, &its_list_map)) {
+			pr_err("ITS@%pa: Duplicate ITSList entry %d\n",
+			       &res->start, its_number);
+			err = -EINVAL;
+			goto out_free_its;
+		}
+
+		pr_info("ITS@%pa: Using ITS number %d\n", &res->start, its_number);
+	} else {
+		pr_info("ITS@%pa: Single VMOVP capable\n", &res->start);
+	}
+
 	its->numa_node = numa_node;
 
 	its->cmd_base = kzalloc(ITS_CMD_QUEUE_SZ, GFP_KERNEL);
@@ -1743,7 +1781,8 @@ static int __init its_probe_one(struct resource *res,
 	}
 
 	gits_write_cwriter(0, its->base + GITS_CWRITER);
-	writel_relaxed(GITS_CTLR_ENABLE, its->base + GITS_CTLR);
+	ctlr = readl_relaxed(its->base + GITS_CTLR);
+	writel_relaxed(ctlr | GITS_CTLR_ENABLE, its->base + GITS_CTLR);
 
 	err = its_init_domain(handle, its);
 	if (err)
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index b162bfa..dc7dcc6 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -231,14 +231,18 @@
 #define GITS_TRANSLATER			0x10040
 
 #define GITS_CTLR_ENABLE		(1U << 0)
+#define	GITS_CTLR_ITS_NUMBER_SHIFT	4
+#define	GITS_CTLR_ITS_NUMBER		(0xFU << GITS_CTLR_ITS_NUMBER_SHIFT)
 #define GITS_CTLR_QUIESCENT		(1U << 31)
 
 #define GITS_TYPER_PLPIS		(1UL << 0)
+#define GITS_TYPER_VLPIS		(1UL << 1)
 #define GITS_TYPER_IDBITS_SHIFT		8
 #define GITS_TYPER_DEVBITS_SHIFT	13
 #define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
 #define GITS_TYPER_PTA			(1UL << 19)
 #define GITS_TYPER_HWCOLLCNT_SHIFT	24
+#define GITS_TYPER_VMOVP		(1ULL << 37)
 
 #define GITS_CBASER_VALID			(1ULL << 63)
 #define GITS_CBASER_SHAREABILITY_SHIFT		(10)
-- 
2.1.4
