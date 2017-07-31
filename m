From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 27/59] irqchip/gic-v3-its: Support VPE doorbell
 invalidation even when !DirectLPI
Date: Mon, 31 Jul 2017 18:26:05 +0100
Message-ID: <20170731172637.29355-28-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 740A349C27
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 02Mqxv7v3GEw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:26:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3621840D1A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:31 -0400 (EDT)
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

When we don't have the DirectLPI feature, we must work around the
architecture shortcomings to be able to perform the required
invalidation.

For this, we create a fake device whose sole purpose is to
provide a way to issue a map/inv/unmap sequence (and the corresponding
sync operations). That's 6 commands and a full serialization point
to be able to do this.

You just have to hope the hypervisor won't do that too often...

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 73 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 70 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index d871d105be9d..210840e0ec92 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -136,6 +136,9 @@ struct its_device {
 	u32			device_id;
 };
 
+static struct its_device *vpe_proxy_dev;
+static DEFINE_RAW_SPINLOCK(vpe_proxy_dev_lock);
+
 static LIST_HEAD(its_nodes);
 static DEFINE_SPINLOCK(its_lock);
 static struct rdists *gic_rdists;
@@ -2077,6 +2080,14 @@ static int its_msi_prepare(struct irq_domain *domain, struct device *dev,
 	msi_info = msi_get_domain_info(domain);
 	its = msi_info->data;
 
+	if (its->is_v4 && !gic_rdists->has_direct_lpi &&
+	    dev_id == vpe_proxy_dev->device_id) {
+		/* Bad luck. Get yourself a better implementation */
+		WARN_ONCE(1, "DevId %x clashes with GICv4 VPE proxy device\n",
+			  dev_id);
+		return -EINVAL;
+	}
+
 	its_dev = its_find_device(its, dev_id);
 	if (its_dev) {
 		/*
@@ -2330,13 +2341,48 @@ static int its_vpe_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 	}
 }
 
+static void its_vpe_send_cmd(struct its_vpe *vpe,
+			     void (*cmd)(struct its_device *, u32))
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&vpe_proxy_dev_lock, flags);
+
+	vpe_proxy_dev->event_map.col_map[0] = vpe->col_idx;
+	its_send_mapti(vpe_proxy_dev, vpe->vpe_db_lpi, 0);
+	cmd(vpe_proxy_dev, 0);
+	its_send_discard(vpe_proxy_dev, 0);
+
+	raw_spin_unlock_irqrestore(&vpe_proxy_dev_lock, flags);
+}
+
 static void its_vpe_send_inv(struct irq_data *d)
 {
 	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
-	void __iomem *rdbase;
 
-	rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
-	gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_INVLPIR);
+	if (gic_rdists->has_direct_lpi) {
+		void __iomem *rdbase;
+
+		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
+		gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_INVLPIR);
+	} else {
+		/*
+		 * This is insane.
+		 *
+		 * If a GICv4 doesn't implement Direct LPIs (which is
+		 * extremely likely), the only way to perform an
+		 * invalidate is to use a fake device to issue a
+		 * MAP/INV/UNMAP sequence. Since each of these
+		 * commands has a sync operation, this is really
+		 * fast. Not.
+		 *
+		 * We always use event 0, and thus serialize all VPE
+		 * invalidations in the system.
+		 *
+		 * Broken by design(tm).
+		 */
+		its_vpe_send_cmd(vpe, its_send_inv);
+	}
 }
 
 static void its_vpe_mask_irq(struct irq_data *d)
@@ -2638,6 +2684,27 @@ static int its_init_domain(struct fwnode_handle *handle, struct its_node *its)
 
 static int its_init_vpe_domain(void)
 {
+	struct its_node *its;
+	u32 devid;
+
+	if (gic_rdists->has_direct_lpi) {
+		pr_info("ITS: Using DirectLPI for VPE invalidation\n");
+		return 0;
+	}
+
+	/* Any ITS will do, even if not v4 */
+	its = list_first_entry(&its_nodes, struct its_node, entry);
+
+	/* Use the last possible DevID */
+	devid = GENMASK(its->device_ids - 1, 0);
+	vpe_proxy_dev = its_create_device(its, devid, 1);
+	if (!vpe_proxy_dev) {
+		pr_err("ITS: Can't allocate GICv4 proxy device\n");
+		return -ENODEV;
+	}
+
+	pr_info("ITS: Allocated DevID %x as GICv4 proxy device\n", devid);
+
 	return 0;
 }
 
-- 
2.11.0
