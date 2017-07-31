From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 26/59] irqchip/gic-v3-its: Add VPE interrupt masking
Date: Mon, 31 Jul 2017 18:26:04 +0100
Message-ID: <20170731172637.29355-27-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ADA340D17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8NVf0GIkxc9J for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:26:29 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C10C449C25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:28 -0400 (EDT)
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
 drivers/irqchip/irq-gic-v3-its.c    | 31 +++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index 8d45e88feac9..550fb0bcccf8 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -276,6 +276,11 @@ static inline u64 __gic_readq_nonatomic(const volatile void __iomem *addr)
 #define gicr_write_pendbaser(v, c)	__gic_writeq_nonatomic(v, c)
 
 /*
+ * GICR_xLPIR - only the lower bits are significant
+ */
+#define gic_write_lpir(v, c)		writel_relaxed(lower_32_bits(v), c)
+
+/*
  * GITS_TYPER is an ID register and doesn't need atomicity.
  */
 #define gits_read_typer(c)		__gic_readq_nonatomic(c)
diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index 0d2a53457c30..c2de3ff374a0 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -116,6 +116,7 @@ static inline void gic_write_bpr1(u32 val)
 
 #define gic_read_typer(c)		readq_relaxed(c)
 #define gic_write_irouter(v, c)		writeq_relaxed(v, c)
+#define gic_write_lpir(v, c)		writeq_relaxed(v, c)
 
 #define gic_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))
 
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 0a9aedaf6da2..d871d105be9d 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2330,8 +2330,39 @@ static int its_vpe_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 	}
 }
 
+static void its_vpe_send_inv(struct irq_data *d)
+{
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+	void __iomem *rdbase;
+
+	rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
+	gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_INVLPIR);
+}
+
+static void its_vpe_mask_irq(struct irq_data *d)
+{
+	/*
+	 * We need to unmask the LPI, which is described by the parent
+	 * irq_data. Instead of calling into the parent (which won't
+	 * exactly do the right thing, let's simply use the
+	 * parent_data pointer. Yes, I'm naughty.
+	 */
+	lpi_write_config(d->parent_data, LPI_PROP_ENABLED, 0);
+	its_vpe_send_inv(d);
+}
+
+static void its_vpe_unmask_irq(struct irq_data *d)
+{
+	/* Same hack as above... */
+	lpi_write_config(d->parent_data, 0, LPI_PROP_ENABLED);
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
