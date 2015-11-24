From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 2/3] gicv3, its: Introduce VFIO map and unmap operations
Date: Tue, 24 Nov 2015 10:48:20 +0300
Message-ID: <0b4f6bebe566c8806d77f67911c40711c780832f.1448350806.git.p.fedin@samsung.com>
References: <cover.1448350806.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D829B497F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 02:47:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OEsScaWELruG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 02:47:47 -0500 (EST)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FCF949721
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 02:47:47 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYB00JGM717XY30@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 24 Nov 2015 07:48:43 +0000 (GMT)
In-reply-to: <cover.1448350806.git.p.fedin@samsung.com>
In-reply-to: <cover.1448350806.git.p.fedin@samsung.com>
References: <cover.1448350806.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Manish Jaggi <mjaggi@caviumnetworks.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

These new functions use the supplied IOMMU in order to map and unmap MSI
translation register(s).

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 drivers/irqchip/irq-gic-v3-its.c   | 31 +++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v3.h |  2 ++
 include/linux/msi.h                | 12 ++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index e23d1d1..b97dfd7 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -29,6 +29,7 @@
 #include <linux/of_platform.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
+#include <linux/vfio.h>
 
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic-v3.h>
@@ -1257,8 +1258,38 @@ out:
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_VFIO)
+
+static int its_vfio_map(struct irq_domain *domain,
+			const struct vfio_iommu_driver_ops *ops,
+			void *iommu_data)
+{
+	struct msi_domain_info *msi_info = msi_get_domain_info(domain);
+	struct its_node *its = msi_info->data;
+	u64 addr = its->phys_base + GIC_V3_ITS_CONTROL_SIZE;
+
+	return ops->map(iommu_data, addr, addr, 1, IOMMU_READ|IOMMU_WRITE);
+}
+
+static void its_vfio_unmap(struct irq_domain *domain,
+			   const struct vfio_iommu_driver_ops *ops,
+			   void *iommu_data)
+{
+	struct msi_domain_info *msi_info = msi_get_domain_info(domain);
+	struct its_node *its = msi_info->data;
+	u64 addr = its->phys_base + GIC_V3_ITS_CONTROL_SIZE;
+
+	ops->unmap(iommu_data, addr, 1);
+}
+
+#endif
+
 static struct msi_domain_ops its_msi_domain_ops = {
 	.msi_prepare	= its_msi_prepare,
+#if IS_ENABLED(CONFIG_VFIO)
+	.vfio_map	= its_vfio_map,
+	.vfio_unmap	= its_vfio_unmap,
+#endif
 };
 
 static int its_irq_gic_domain_alloc(struct irq_domain *domain,
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index c9ae0c6..95388a7 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -240,6 +240,8 @@
 #define GITS_BASER_TYPE_RESERVED6	6
 #define GITS_BASER_TYPE_RESERVED7	7
 
+#define GIC_V3_ITS_CONTROL_SIZE		0x10000
+
 /*
  * ITS commands
  */
diff --git a/include/linux/msi.h b/include/linux/msi.h
index f71a25e..48faea9 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -155,6 +155,8 @@ void arch_restore_msi_irqs(struct pci_dev *dev);
 void default_teardown_msi_irqs(struct pci_dev *dev);
 void default_restore_msi_irqs(struct pci_dev *dev);
 
+struct vfio_iommu_driver_ops;
+
 struct msi_controller {
 	struct module *owner;
 	struct device *dev;
@@ -189,6 +191,8 @@ struct msi_domain_info;
  * @msi_finish:		Optional callbacl to finalize the allocation
  * @set_desc:		Set the msi descriptor for an interrupt
  * @handle_error:	Optional error handler if the allocation fails
+ * @vfio_map:		Map the MSI hardware for VFIO
+ * @vfio_unmap:		Unmap the MSI hardware for VFIO
  *
  * @get_hwirq, @msi_init and @msi_free are callbacks used by
  * msi_create_irq_domain() and related interfaces
@@ -218,6 +222,14 @@ struct msi_domain_ops {
 				    struct msi_desc *desc);
 	int		(*handle_error)(struct irq_domain *domain,
 					struct msi_desc *desc, int error);
+#if IS_ENABLED(CONFIG_VFIO)
+	int		(*vfio_map)(struct irq_domain *domain,
+				    const struct vfio_iommu_driver_ops *ops,
+				    void *iommu_data);
+	void		(*vfio_unmap)(struct irq_domain *domain,
+				      const struct vfio_iommu_driver_ops *ops,
+				      void *iommu_data);
+#endif
 };
 
 /**
-- 
2.4.4
