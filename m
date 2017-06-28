From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 26/52] irqchip/gic-v3-its: Add VPE interrupt masking
Date: Wed, 28 Jun 2017 16:03:45 +0100
Message-ID: <20170628150411.15846-27-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2DFA43C75
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3G-9VUjalN9A for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A749849C2A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:12 -0400 (EDT)
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

When masking/unmasking a doorbell interrupt, it is necessary
to issue an invalidation to the corresponding redistributor.
We use the DirectLPI feature by writting directly to the corresponding
redistributor.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/arch_gicv3.h   |  5 +++++
 arch/arm64/include/asm/arch_gicv3.h |  1 +
 drivers/irqchip/irq-gic-v3-its.c    | 26 +++++++++++++++++++++++++-
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index 8d45e88feac9..0735888fe42e 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -276,6 +276,11 @@ static inline u64 __gic_readq_nonatomic(const volatile void __iomem *addr)
 #define gicr_write_pendbaser(v, c)	__gic_writeq_nonatomic(v, c)
 
 /*
+ * GICR_INVLPIR - only the lower bits are significant
+ */
+#define gic_write_invlpir(v, c)		writel_relaxed(lower_32_bits(v), c)
+
+/*
  * GITS_TYPER is an ID register and doesn't need atomicity.
  */
 #define gits_read_typer(c)		__gic_readq_nonatomic(c)
diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index 0d2a53457c30..019128dd37e4 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -116,6 +116,7 @@ static inline void gic_write_bpr1(u32 val)
 
 #define gic_read_typer(c)		readq_relaxed(c)
 #define gic_write_irouter(v, c)		writeq_relaxed(v, c)
+#define gic_write_invlpir(v, c)		writeq_relaxed(v, c)
 
 #define gic_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))
 
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 281eed031e01..64893f0427f2 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -969,12 +969,12 @@ static inline u32 its_get_event_id(struct irq_data *d)
 
 static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
 {
-	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
 	irq_hw_number_t hwirq;
 	struct page *prop_page;
 	u8 *cfg;
 
 	if (irqd_is_forwarded_to_vcpu(d)) {
+		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
 		u32 event = its_get_event_id(d);
 
 		prop_page = its_dev->event_map.vm->vprop_page;
@@ -2315,8 +2315,32 @@ static int its_vpe_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 	}
 }
 
+static void its_vpe_send_inv(struct irq_data *d)
+{
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+	void __iomem *rdbase;
+
+	rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
+	gic_write_invlpir(d->hwirq, rdbase + GICR_INVLPIR);
+}
+
+static void its_vpe_mask_irq(struct irq_data *d)
+{
+	lpi_write_config(d, LPI_PROP_ENABLED, 0);
+	its_vpe_send_inv(d);
+}
+
+static void its_vpe_unmask_irq(struct irq_data *d)
+{
+	lpi_write_config(d, 0, LPI_PROP_ENABLED);
+	its_vpe_send_inv(d);
+}
+
 static struct irq_chip its_vpe_irq_chip = {
 	.name			= "GICv4-vpe",
+	.irq_mask		= its_vpe_mask_irq,
+	.irq_unmask		= its_vpe_unmask_irq,
+	.irq_eoi		= irq_chip_eoi_parent,
 	.irq_set_affinity	= its_vpe_set_affinity,
 	.irq_set_vcpu_affinity	= its_vpe_set_vcpu_affinity,
 };
-- 
2.11.0
