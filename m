From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v11 09/10] genirq/msi: map/unmap the MSI doorbells on
 msi_domain_alloc/free_irqs
Date: Tue, 19 Jul 2016 13:02:46 +0000
Message-ID: <1468933367-23159-10-git-send-email-eric.auger@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A91C49B3B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 08:57:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e3cf4i9W2ZoD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2016 08:57:37 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B53749B36
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 08:57:36 -0400 (EDT)
In-Reply-To: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, robert.richter@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch handles the iommu mapping of MSI doorbells that require to
be mapped in an iommu domain. This happens on msi_domain_alloc/free_irqs
since this is called in code that can sleep (pci_enable/disable_msi):
iommu_map/unmap is not stated as atomic. On msi_domain_(de)activate and
msi_domain_set_affinity, which must be atomic, we just lookup for this
pre-allocated/mapped IOVA.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v10 -> v11:
- restore v9 version based on irq_chip msi_doorbell_info

v9 -> v10:
- use irqchip API to lookup for the chip_data's doorbell

v8 -> v9:
- decouple irq_data parsing from the actual mapping/unmapping

v7 -> v8:
- new percpu pointer type
- exit from the irq domain hierarchy parsing on first map/unmap success
- reset desc->irq to 0 on mapping failure

v7: creation
---
 kernel/irq/msi.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 101 insertions(+), 8 deletions(-)

diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 72bf4d6..69b5b19 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -14,6 +14,9 @@
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/msi.h>
+#include <linux/msi-iommu.h>
+#include <linux/iommu.h>
+#include <linux/msi-doorbell.h>
 
 /* Temparory solution for building, will be removed later */
 #include <linux/pci.h>
@@ -322,6 +325,74 @@ int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
 }
 
 /**
+ * msi_handle_doorbell_mappings: in case the irq data corresponds to an
+ * MSI that requires iommu mapping, traverse the irq domain hierarchy
+ * to retrieve the doorbells to handle and iommu_map/unmap them according
+ * to @map boolean.
+ *
+ * @data: irq data handle
+ * @map: mapping if true, unmapping if false
+ */
+static int msi_handle_doorbell_mappings(struct irq_data *data, bool map)
+{
+	const struct irq_chip_msi_doorbell_info *dbinfo;
+	struct iommu_domain *domain;
+	struct irq_chip *chip;
+	struct device *dev;
+	dma_addr_t iova;
+	int ret = 0, cpu;
+
+	while (data) {
+		dev = msi_desc_to_dev(irq_data_get_msi_desc(data));
+		domain = iommu_msi_domain(dev);
+		if (domain) {
+			chip = irq_data_get_irq_chip(data);
+			if (chip->msi_doorbell_info)
+				break;
+		}
+		data = data->parent_data;
+	}
+
+	if (!data)
+		return 0;
+
+	dbinfo = chip->msi_doorbell_info(data);
+	if (!dbinfo)
+		return -EINVAL;
+
+	if (!dbinfo->doorbell_is_percpu) {
+		if (!map) {
+			iommu_msi_put_doorbell_iova(domain,
+						    dbinfo->global_doorbell);
+			return 0;
+		}
+		return iommu_msi_get_doorbell_iova(domain,
+						   dbinfo->global_doorbell,
+						   dbinfo->size, dbinfo->prot,
+						   &iova);
+	}
+
+	/* percpu doorbells */
+	for_each_possible_cpu(cpu) {
+		phys_addr_t __percpu *db_addr =
+			per_cpu_ptr(dbinfo->percpu_doorbells, cpu);
+
+		if (!map) {
+			iommu_msi_put_doorbell_iova(domain, *db_addr);
+		} else {
+
+			ret = iommu_msi_get_doorbell_iova(domain, *db_addr,
+							  dbinfo->size,
+							  dbinfo->prot, &iova);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+/**
  * msi_domain_alloc_irqs - Allocate interrupts from a MSI interrupt domain
  * @domain:	The domain to allocate from
  * @dev:	Pointer to device struct of the device for which the interrupts
@@ -352,17 +423,29 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 
 		virq = __irq_domain_alloc_irqs(domain, virq, desc->nvec_used,
 					       dev_to_node(dev), &arg, false);
-		if (virq < 0) {
-			ret = -ENOSPC;
-			if (ops->handle_error)
-				ret = ops->handle_error(domain, desc, ret);
-			if (ops->msi_finish)
-				ops->msi_finish(&arg, ret);
-			return ret;
-		}
+		if (virq < 0)
+			goto error;
 
 		for (i = 0; i < desc->nvec_used; i++)
 			irq_set_msi_desc_off(virq, i, desc);
+
+		for (i = 0; i < desc->nvec_used; i++) {
+			struct irq_data *d = irq_get_irq_data(virq + i);
+
+			ret = msi_handle_doorbell_mappings(d, true);
+			if (ret)
+				break;
+		}
+		if (ret) {
+			for (; i >= 0; i--) {
+				struct irq_data *d = irq_get_irq_data(virq + i);
+
+				msi_handle_doorbell_mappings(d, false);
+			}
+			irq_domain_free_irqs(virq, desc->nvec_used);
+			desc->irq = 0;
+			goto error;
+		}
 	}
 
 	if (ops->msi_finish)
@@ -377,6 +460,13 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 	}
 
 	return 0;
+error:
+	ret = -ENOSPC;
+	if (ops->handle_error)
+		ret = ops->handle_error(domain, desc, ret);
+	if (ops->msi_finish)
+		ops->msi_finish(&arg, ret);
+	return ret;
 }
 
 /**
@@ -396,6 +486,9 @@ void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
 		 * entry. If that's the case, don't do anything.
 		 */
 		if (desc->irq) {
+			msi_handle_doorbell_mappings(
+				irq_get_irq_data(desc->irq),
+				false);
 			irq_domain_free_irqs(desc->irq, desc->nvec_used);
 			desc->irq = 0;
 		}
-- 
1.9.1
