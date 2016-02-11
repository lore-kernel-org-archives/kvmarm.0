From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 15/15] irqchip/gicv2m/v3-its-pci-msi: IOMMU map the MSI frame
 when needed
Date: Thu, 11 Feb 2016 14:34:22 +0000
Message-ID: <1455201262-5259-16-git-send-email-eric.auger@linaro.org>
References: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B3F649B62
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kvSazp2wjf8B for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 09:29:58 -0500 (EST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7908A499E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:58 -0500 (EST)
Received: by mail-wm0-f44.google.com with SMTP id p63so75978683wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 06:35:53 -0800 (PST)
In-Reply-To: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Thomas.Lendacky@amd.com, brijesh.singh@amd.com, patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, leo.duran@amd.com, sherry.hurwitz@amd.com
List-Id: kvmarm@lists.cs.columbia.edu

In case the msi_desc references a device attached to an iommu
domain, the msi address needs to be mapped in the IOMMU. Else any
MSI write transaction will cause a fault.

gic_set_msi_addr detects that case and allocates an iova bound
to the physical address page comprising the MSI frame. This iova
then is used as the msi_msg address. Unset operation decrements the
reference on the binding.

The functions are called in the irq_write_msi_msg ops implementation.
At that time we can recognize whether the msi is setup or teared down
looking at the msi_msg content. Indeed msi_domain_deactivate zeroes all
the fields.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/irqchip/irq-gic-common.c         | 60 ++++++++++++++++++++++++++++++++
 drivers/irqchip/irq-gic-common.h         |  5 +++
 drivers/irqchip/irq-gic-v2m.c            |  3 +-
 drivers/irqchip/irq-gic-v3-its-pci-msi.c |  3 +-
 4 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
index f174ce0..690802b 100644
--- a/drivers/irqchip/irq-gic-common.c
+++ b/drivers/irqchip/irq-gic-common.c
@@ -18,6 +18,8 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/iommu.h>
+#include <linux/msi.h>
 
 #include "irq-gic-common.h"
 
@@ -121,3 +123,61 @@ void gic_cpu_config(void __iomem *base, void (*sync_access)(void))
 	if (sync_access)
 		sync_access();
 }
+
+int gic_set_msi_addr(struct irq_data *data, struct msi_msg *msg)
+{
+	struct msi_desc *desc = irq_data_get_msi_desc(data);
+	struct device *dev = msi_desc_to_dev(desc);
+	struct iommu_domain *d;
+	phys_addr_t addr;
+	dma_addr_t iova;
+	int ret;
+
+	d = iommu_get_domain_for_dev(dev);
+	if (!d)
+		return 0;
+
+	addr = ((phys_addr_t)(msg->address_hi) << 32) |
+		msg->address_lo;
+
+	ret = iommu_get_single_reserved(d, addr, IOMMU_WRITE, &iova);
+
+	if (!ret) {
+		msg->address_lo = lower_32_bits(iova);
+		msg->address_hi = upper_32_bits(iova);
+	}
+	return ret;
+}
+
+
+void gic_unset_msi_addr(struct irq_data *data)
+{
+	struct msi_desc *desc = irq_data_get_msi_desc(data);
+	struct device *dev;
+	struct iommu_domain *d;
+	dma_addr_t iova;
+
+	iova = ((dma_addr_t)(desc->msg.address_hi) << 32) |
+		desc->msg.address_lo;
+
+	dev = msi_desc_to_dev(desc);
+	if (!dev)
+		return;
+
+	d = iommu_get_domain_for_dev(dev);
+	if (!d)
+		return;
+
+	iommu_put_single_reserved(d, iova);
+}
+
+void gic_pci_msi_domain_write_msg(struct irq_data *irq_data,
+				  struct msi_msg *msg)
+{
+	if (!msg->address_hi && !msg->address_lo && !msg->data)
+		gic_unset_msi_addr(irq_data); /* deactivate */
+	else
+		gic_set_msi_addr(irq_data, msg); /* activate, set_affinity */
+
+	pci_msi_domain_write_msg(irq_data, msg);
+}
diff --git a/drivers/irqchip/irq-gic-common.h b/drivers/irqchip/irq-gic-common.h
index fff697d..e99e321 100644
--- a/drivers/irqchip/irq-gic-common.h
+++ b/drivers/irqchip/irq-gic-common.h
@@ -35,4 +35,9 @@ void gic_cpu_config(void __iomem *base, void (*sync_access)(void));
 void gic_enable_quirks(u32 iidr, const struct gic_quirk *quirks,
 		void *data);
 
+int gic_set_msi_addr(struct irq_data *data, struct msi_msg *msg);
+void gic_unset_msi_addr(struct irq_data *data);
+void gic_pci_msi_domain_write_msg(struct irq_data *irq_data,
+				  struct msi_msg *msg);
+
 #endif /* _IRQ_GIC_COMMON_H */
diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index c779f83..5d7b89f 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -24,6 +24,7 @@
 #include <linux/of_pci.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include "irq-gic-common.h"
 
 /*
 * MSI_TYPER:
@@ -83,7 +84,7 @@ static struct irq_chip gicv2m_msi_irq_chip = {
 	.irq_mask		= gicv2m_mask_msi_irq,
 	.irq_unmask		= gicv2m_unmask_msi_irq,
 	.irq_eoi		= irq_chip_eoi_parent,
-	.irq_write_msi_msg	= pci_msi_domain_write_msg,
+	.irq_write_msi_msg	= gic_pci_msi_domain_write_msg,
 };
 
 static struct msi_domain_info gicv2m_msi_domain_info = {
diff --git a/drivers/irqchip/irq-gic-v3-its-pci-msi.c b/drivers/irqchip/irq-gic-v3-its-pci-msi.c
index aee60ed..6d5cbce 100644
--- a/drivers/irqchip/irq-gic-v3-its-pci-msi.c
+++ b/drivers/irqchip/irq-gic-v3-its-pci-msi.c
@@ -19,6 +19,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_pci.h>
+#include "irq-gic-common.h"
 
 static void its_mask_msi_irq(struct irq_data *d)
 {
@@ -37,7 +38,7 @@ static struct irq_chip its_msi_irq_chip = {
 	.irq_unmask		= its_unmask_msi_irq,
 	.irq_mask		= its_mask_msi_irq,
 	.irq_eoi		= irq_chip_eoi_parent,
-	.irq_write_msi_msg	= pci_msi_domain_write_msg,
+	.irq_write_msi_msg	= gic_pci_msi_domain_write_msg,
 };
 
 struct its_pci_alias {
-- 
1.9.1
