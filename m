From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 28/33] irqchip/gic-v3-its: Support VPE doorbell
 invalidation even when !DirectLPI
Date: Tue, 17 Jan 2017 10:20:49 +0000
Message-ID: <1484648454-21216-29-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE4C94069B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:20:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WTBb+LHaa3zX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:20:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0FB34096F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:20:02 -0500 (EST)
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

When we don't have the DirectLPI feature, we must work around the
architecture shortcomings to be able to perform the required
invalidation.

For this, we create a fake device whose sole purpose is to
provide a way to issue a map/inv/unmap sequence (and the corresponding
sync operations). That's 6 commands and a full serialization point
to be able to do this.

You just have hope the hypervisor won't do that too often...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 59 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 008fb71..3787579 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -133,6 +133,9 @@ struct its_device {
 	u32			device_id;
 };
 
+static struct its_device *vpe_proxy_dev;
+static DEFINE_RAW_SPINLOCK(vpe_proxy_dev_lock);
+
 static LIST_HEAD(its_nodes);
 static DEFINE_SPINLOCK(its_lock);
 static struct rdists *gic_rdists;
@@ -993,8 +996,35 @@ static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
 		struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
 		void __iomem *rdbase;
 
-		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
-		writeq_relaxed(d->hwirq, rdbase + GICR_INVLPIR);
+		if (gic_rdists->has_direct_lpi) {
+			rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
+			writeq_relaxed(d->hwirq, rdbase + GICR_INVLPIR);
+		} else {
+			/*
+			 * This is insane.
+			 *
+			 * If a GICv4 doesn't implement Direct LPIs,
+			 * the only way to perform an invalidate is to
+			 * use a fake device to issue a MAP/INV/UNMAP
+			 * sequence. Since each of these commands has
+			 * a sync operation, this is really fast. Not.
+			 *
+			 * We always use event 0, and this serialize
+			 * all VPE invalidations in the system.
+			 *
+			 * Broken by design(tm).
+			 */
+			unsigned long flags;
+
+			raw_spin_lock_irqsave(&vpe_proxy_dev_lock, flags);
+
+			vpe_proxy_dev->event_map.col_map[0] = vpe->col_idx;
+			its_send_mapvi(vpe_proxy_dev, vpe->vpe_db_lpi, 0);
+			its_send_inv(vpe_proxy_dev, 0);
+			its_send_discard(vpe_proxy_dev, 0);
+
+			raw_spin_unlock_irqrestore(&vpe_proxy_dev_lock, flags);
+		}
 	}
 }
 
@@ -2481,6 +2511,31 @@ static struct irq_domain *its_init_vpe_domain(void)
 	struct fwnode_handle *handle;
 	struct irq_domain *domain;
 
+	if (gic_rdists->has_direct_lpi) {
+		pr_info("ITS: Using DirectLPI for VPE invalidation\n");
+	} else {
+		struct its_node *its;
+
+		list_for_each_entry(its, &its_nodes, entry) {
+			u32 devid;
+
+			if (!its->is_v4)
+				continue;
+
+			/* Use the last possible DevID */
+			devid = GENMASK(its->device_ids - 1, 0);
+			vpe_proxy_dev = its_create_device(its, devid, 1);
+			if (!vpe_proxy_dev) {
+				pr_err("ITS: Can't allocate GICv4 proxy device\n");
+				return NULL;
+			}
+
+			pr_info("ITS: Allocated DevID %x as GICv4 proxy device\n",
+				devid);
+			break;
+		}
+	}
+
 	handle = irq_domain_alloc_fwnode("VPE domain");
 	if (!handle)
 		return NULL;
-- 
2.1.4
