From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v4 09/14] msi: IOMMU map the doorbell address when needed
Date: Fri, 26 Feb 2016 17:35:49 +0000
Message-ID: <1456508154-2253-10-git-send-email-eric.auger@linaro.org>
References: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5198D410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7LDkdozmHnE0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2016 12:29:38 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59B44411F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:38 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id g62so82767630wme.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 09:36:30 -0800 (PST)
In-Reply-To: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

In case the msi_desc references a device attached to an iommu
domain and this iommu domain requires MSI mapping, the msi
address (aka doorbell) needs to be mapped in the IOMMU. Else any
MSI write transaction will cause a fault.

We perform this action at msi message composition time. We
need to track when the doorbell address changes. On domain deactivate,
we now also call the composition function with a new erase parameter.

In case the mapping fails we just WARN_ON.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v3 -> v4:
- that code was formely in irq-gic-common.c
  "irqchip/gicv2m/v3-its-pci-msi: IOMMU map the MSI frame when needed"
  also the [un]mapping was done in irq_write_msi_msg; now done on compose

v2 -> v3:
- protect iova/addr manipulation with CONFIG_ARCH_DMA_ADDR_T_64BIT and
  CONFIG_PHYS_ADDR_T_64BIT
- only expose gic_pci_msi_domain_write_msg in case CONFIG_IOMMU_API &
  CONFIG_PCI_MSI_IRQ_DOMAIN are set.
- gic_set/unset_msi_addr duly become static
---
 kernel/irq/msi.c | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 109 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 9b0ba4a..93bd861 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -17,6 +17,8 @@
 
 /* Temparory solution for building, will be removed later */
 #include <linux/pci.h>
+#include <linux/iommu.h>
+#include <linux/dma-reserved-iommu.h>
 
 struct msi_desc *alloc_msi_entry(struct device *dev)
 {
@@ -55,6 +57,110 @@ static inline void irq_chip_write_msi_msg(struct irq_data *data,
 	data->chip->irq_write_msi_msg(data, msg);
 }
 
+static int msi_map_doorbell(struct iommu_domain *d, struct msi_msg *msg)
+{
+#ifdef CONFIG_IOMMU_DMA_RESERVED
+	dma_addr_t iova;
+	phys_addr_t addr;
+	int ret;
+
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+	addr = ((phys_addr_t)(msg->address_hi) << 32) | msg->address_lo;
+#else
+	addr = msg->address_lo;
+#endif
+
+	ret = iommu_get_single_reserved(d, addr, IOMMU_WRITE, &iova);
+	if (!ret) {
+		msg->address_lo = lower_32_bits(iova);
+		msg->address_hi = upper_32_bits(iova);
+	}
+	return ret;
+#else
+	return -ENODEV;
+#endif
+}
+
+static void msi_unmap_doorbell(struct iommu_domain *d, struct msi_msg *msg)
+{
+#ifdef CONFIG_IOMMU_DMA_RESERVED
+	dma_addr_t iova;
+
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	iova = ((dma_addr_t)(msg->address_hi) << 32) | msg->address_lo;
+#else
+	iova = msg->address_lo;
+#endif
+
+	iommu_put_single_reserved(d, iova);
+#endif
+}
+
+#ifdef CONFIG_IOMMU_API
+static struct iommu_domain *
+	irq_data_to_msi_mapping_domain(struct irq_data *irq_data)
+{
+
+	struct msi_desc *desc;
+	struct device *dev;
+	struct iommu_domain *d;
+	int ret;
+
+	desc = irq_data_get_msi_desc(irq_data);
+	if (!desc)
+		return NULL;
+
+	dev = msi_desc_to_dev(desc);
+
+	d = iommu_get_domain_for_dev(dev);
+	if (!d)
+		return NULL;
+
+	ret = iommu_domain_get_attr(d, DOMAIN_ATTR_MSI_MAPPING, NULL);
+	if (!ret)
+		return d;
+	else
+		return NULL;
+}
+#else
+static inline iommu_domain *
+		irq_data_to_msi_mapping_domain(struct irq_data *irq_data)
+{
+	return NULL;
+}
+#endif /* CONFIG_IOMMU_API */
+
+static int msi_compose(struct irq_data *irq_data,
+		       struct msi_msg *msg, bool erase)
+{
+	struct msi_msg old_msg;
+	struct iommu_domain *d;
+	int ret = 0;
+
+	d = irq_data_to_msi_mapping_domain(irq_data);
+	if (unlikely(d))
+		get_cached_msi_msg(irq_data->irq, &old_msg);
+
+	if (erase)
+		memset(msg, 0, sizeof(*msg));
+	else
+		ret = irq_chip_compose_msi_msg(irq_data, msg);
+
+	if (!d)
+		goto out;
+
+	/* handle (re-)mapping of MSI doorbell */
+	if ((old_msg.address_lo != msg->address_lo) ||
+	    (old_msg.address_hi != msg->address_hi))
+		msi_unmap_doorbell(d, &old_msg);
+
+	if (!erase)
+		WARN_ON(msi_map_doorbell(d, msg));
+
+out:
+	return ret;
+}
+
 /**
  * msi_domain_set_affinity - Generic affinity setter function for MSI domains
  * @irq_data:	The irq data associated to the interrupt
@@ -73,7 +179,7 @@ int msi_domain_set_affinity(struct irq_data *irq_data,
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
-		BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+		BUG_ON(msi_compose(irq_data, &msg, false));
 		irq_chip_write_msi_msg(irq_data, &msg);
 	}
 
@@ -85,7 +191,7 @@ static void msi_domain_activate(struct irq_domain *domain,
 {
 	struct msi_msg msg;
 
-	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+	BUG_ON(msi_compose(irq_data, &msg, false));
 	irq_chip_write_msi_msg(irq_data, &msg);
 }
 
@@ -94,7 +200,7 @@ static void msi_domain_deactivate(struct irq_domain *domain,
 {
 	struct msi_msg msg;
 
-	memset(&msg, 0, sizeof(msg));
+	msi_compose(irq_data, &msg, true);
 	irq_chip_write_msi_msg(irq_data, &msg);
 }
 
-- 
1.9.1
