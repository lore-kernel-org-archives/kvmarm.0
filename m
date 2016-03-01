From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v5 12/17] msi: IOMMU map the doorbell address when needed
Date: Tue,  1 Mar 2016 18:27:52 +0000
Message-ID: <1456856877-4817-13-git-send-email-eric.auger@linaro.org>
References: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: suravee.suthikulpanit@amd.com, patches@linaro.org, linux-kernel@vger.kernel.org, Manish.Jaggi@caviumnetworks.com, Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, p.fedin@samsung.com, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

In case the msi is emitted by a device attached to an iommu
domain and this iommu domain requires MSI mapping, the msi
address (aka doorbell) must be mapped in the IOMMU. Else
MSI write transaction will cause a fault.

We perform this action at msi message composition time. On any
MSI address change and MSI message erasure we decrement the reference
counter to the IOMMU binding.

In case the mapping fails we just WARN_ON.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v5:
- use macros to increase the readability
- add comments
- fix a typo that caused a compilation error if CONFIG_IOMMU_API
  is not set
---
 include/linux/msi.h |  15 +++++++
 kernel/irq/msi.c    | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 03eda72..b920cac 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -10,6 +10,21 @@ struct msi_msg {
 	u32	data;		/* 16 bits of msi message data */
 };
 
+/* Helpers to convert the msi message address to a an iova/physical address */
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+#define msg_to_dma_addr(msg) \
+	(((dma_addr_t)((msg)->address_hi) << 32) | (msg)->address_lo)
+#else
+#define msg_to_dma_addr(msg) ((msg)->address_lo)
+#endif
+
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+#define msg_to_phys_addr(msg) \
+	(((phys_addr_t)((msg)->address_hi) << 32) | (msg)->address_lo)
+#else
+#define msg_to_phys_addr(msg)	((msg)->address_lo)
+#endif
+
 extern int pci_msi_ignore_mask;
 /* Helper functions */
 struct irq_data;
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 72bf4d6..8ddbe57 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -17,6 +17,8 @@
 
 /* Temparory solution for building, will be removed later */
 #include <linux/pci.h>
+#include <linux/iommu.h>
+#include <linux/dma-reserved-iommu.h>
 
 struct msi_desc *alloc_msi_entry(struct device *dev)
 {
@@ -55,16 +57,133 @@ static inline void irq_chip_write_msi_msg(struct irq_data *data,
 	data->chip->irq_write_msi_msg(data, msg);
 }
 
+/**
+ * msi_map_doorbell: make sure an IOMMU mapping exists on domain @d
+ * for the message physical address (aka. doorbell)
+ *
+ * Either allocate an IOVA and create a mapping or simply increment
+ * a reference count on the existing IOMMU mapping
+ * @d: iommu domain handle the mapping belongs to
+ * @msg: msi message handle
+ */
+static int msi_map_doorbell(struct iommu_domain *d, struct msi_msg *msg)
+{
+#ifdef CONFIG_IOMMU_DMA_RESERVED
+	phys_addr_t addr;
+	dma_addr_t iova;
+	int ret;
+
+	addr = msg_to_phys_addr(msg);
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
+/**
+ * msi_unmap_doorbell: decrements the reference count on an existing
+ * doorbell IOMMU mapping
+ *
+ * @d: iommu domain the mapping is attached to
+ * @msg: msi message containing the doorbell IOVA to unbind
+ */
+static void msi_unmap_doorbell(struct iommu_domain *d, struct msi_msg *msg)
+{
+#ifdef CONFIG_IOMMU_DMA_RESERVED
+	dma_addr_t iova;
+
+	iova = msg_to_dma_addr(msg);
+	iommu_put_single_reserved(d, iova);
+#endif
+}
+
+#ifdef CONFIG_IOMMU_API
+/**
+ * irq_data_to_msi_mapping_domain: checks if an irq corresponds to
+ * an MSI whose write address must be mapped in an IOMMU domain
+ *
+ * determine whether the irq corresponds to an MSI emitted by a device,
+ * upstream to an IOMMU, and if this IOMMU requires a binding of the
+ * MSI address
+ *
+ * @irq_data: irq data handle
+ */
+static struct iommu_domain *
+irq_data_to_msi_mapping_domain(struct irq_data *irq_data)
+{
+	struct iommu_domain *d;
+	struct msi_desc *desc;
+	struct device *dev;
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
+static inline struct iommu_domain *
+irq_data_to_msi_mapping_domain(struct irq_data *irq_data)
+{
+	return NULL;
+}
+#endif /* CONFIG_IOMMU_API */
+
 static int msi_compose(struct irq_data *irq_data,
 		       struct msi_msg *msg, bool erase)
 {
+	struct msi_msg old_msg;
+	struct iommu_domain *d;
 	int ret = 0;
 
+	/*
+	 * Does this IRQ require an MSI address mapping in an IOMMU?
+	 * If it does, read the existing cached message. This will allow
+	 * to check if the IOMMU mapping needs an update
+	 */
+	d = irq_data_to_msi_mapping_domain(irq_data);
+	if (unlikely(d))
+		get_cached_msi_msg(irq_data->irq, &old_msg);
+
 	if (erase)
 		memset(msg, 0, sizeof(*msg));
 	else
 		ret = irq_chip_compose_msi_msg(irq_data, msg);
 
+	if (!d)
+		goto out;
+
+	/*
+	 * An MSI address IOMMU binding needs to be handled.
+	 * In case we have a change in the MSI address or an MSI
+	 * message erasure, destroy the existing binding.
+	 * In case we have an actual MSI message composition
+	 * bind the new MSI address
+	 */
+	if ((old_msg.address_lo != msg->address_lo) ||
+	    (old_msg.address_hi != msg->address_hi))
+		msi_unmap_doorbell(d, &old_msg);
+
+	if (!erase)
+		WARN_ON(msi_map_doorbell(d, msg));
+
+out:
 	return ret;
 }
 
-- 
1.9.1
