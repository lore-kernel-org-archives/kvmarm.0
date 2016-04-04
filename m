From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v6 4/4] msi: IOMMU map the doorbell address when needed
Date: Mon,  4 Apr 2016 08:19:32 +0000
Message-ID: <1459757972-2814-5-git-send-email-eric.auger@linaro.org>
References: <1459757972-2814-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE73A40F77
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:18:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2cW0ckXWibk6 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 04:18:41 -0400 (EDT)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
 [209.85.217.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88A0F40FA6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:18:41 -0400 (EDT)
Received: by mail-lb0-f177.google.com with SMTP id qe11so148709142lbc.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2016 01:19:56 -0700 (PDT)
In-Reply-To: <1459757972-2814-1-git-send-email-eric.auger@linaro.org>
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

In case the msi is emitted by a device attached to an iommu domain
and this iommu domain requires MSI mapping, the msi address (aka
doorbell) must be mapped in the IOMMU. Else MSI write transaction
will cause a fault.

We handle the iommu mapping/unmapping anytime the msi address is
updated.

In case the mapping fails we just WARN_ON.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v6:
- check the domain type to detect bypass situation (rebase on
  new default domain modality)
- fix the msi_domain_set_affinity sequence:
  unmap the address once the PCI device has been given the new address
- use new proto for iommu_put_reserved_iova. New function names

v5:
- use macros to increase the readability
- add comments
- fix a typo that caused a compilation error if CONFIG_IOMMU_API
  is not set
---
 include/linux/msi.h |  15 +++++++
 kernel/irq/msi.c    | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 138 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 08441b1..1dc41db 100644
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
index 9b0ba4a..7440653 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -17,6 +17,8 @@
 
 /* Temparory solution for building, will be removed later */
 #include <linux/pci.h>
+#include <linux/iommu.h>
+#include <linux/dma-reserved-iommu.h>
 
 struct msi_desc *alloc_msi_entry(struct device *dev)
 {
@@ -56,6 +58,94 @@ static inline void irq_chip_write_msi_msg(struct irq_data *data,
 }
 
 /**
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
+	ret = iommu_get_reserved_iova(d, addr, sizeof(addr), IOMMU_WRITE, &iova);
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
+	iommu_put_reserved_iova(d, iova);
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
+	if (!d || (d->type == IOMMU_DOMAIN_DMA))
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
+/**
  * msi_domain_set_affinity - Generic affinity setter function for MSI domains
  * @irq_data:	The irq data associated to the interrupt
  * @mask:	The affinity mask to set
@@ -73,8 +163,27 @@ int msi_domain_set_affinity(struct irq_data *irq_data,
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
+		bool doorbell_change = false;
+		struct iommu_domain *d;
+		struct msi_msg old_msg;
+
+		d = irq_data_to_msi_mapping_domain(irq_data);
+		if (unlikely(d)) {
+			get_cached_msi_msg(irq_data->irq, &old_msg);
+			doorbell_change =
+				(old_msg.address_lo != msg.address_lo) ||
+				(old_msg.address_hi != msg.address_hi);
+		}
+
 		BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+
+		if (unlikely(doorbell_change))
+			WARN_ON(msi_map_doorbell(d, &msg));
+
 		irq_chip_write_msi_msg(irq_data, &msg);
+
+		if (unlikely(doorbell_change))
+			msi_unmap_doorbell(d, &old_msg);
 	}
 
 	return ret;
@@ -83,19 +192,33 @@ int msi_domain_set_affinity(struct irq_data *irq_data,
 static void msi_domain_activate(struct irq_domain *domain,
 				struct irq_data *irq_data)
 {
+	struct iommu_domain *d;
 	struct msi_msg msg;
 
+	d = irq_data_to_msi_mapping_domain(irq_data);
+
 	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+	if (unlikely(d))
+		WARN_ON(msi_map_doorbell(d, &msg));
 	irq_chip_write_msi_msg(irq_data, &msg);
 }
 
 static void msi_domain_deactivate(struct irq_domain *domain,
 				  struct irq_data *irq_data)
 {
+	struct iommu_domain *d;
+	struct msi_msg old_msg;
 	struct msi_msg msg;
 
+	d = irq_data_to_msi_mapping_domain(irq_data);
+	if (unlikely(d))
+		get_cached_msi_msg(irq_data->irq, &old_msg);
+
 	memset(&msg, 0, sizeof(msg));
 	irq_chip_write_msi_msg(irq_data, &msg);
+
+	if (unlikely(d))
+		msi_unmap_doorbell(d, &old_msg);
 }
 
 static int msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
-- 
1.9.1
