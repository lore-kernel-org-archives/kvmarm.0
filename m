From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v6 4/7] dma-reserved-iommu: alloc/free_reserved_iova_domain
Date: Mon,  4 Apr 2016 08:06:59 +0000
Message-ID: <1459757222-2668-5-git-send-email-eric.auger@linaro.org>
References: <1459757222-2668-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1459757222-2668-1-git-send-email-eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger-qxv4g6HH51o@public.gmane.org, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: julien.grall-5wv7dgnIgG8@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Introduce alloc/free_reserved_iova_domain in the IOMMU API.
alloc_reserved_iova_domain initializes an iova domain at a given
iova base address and with a given size. This iova domain will
be used to allocate iova within that window. Those IOVAs will be reserved
for special purpose, typically MSI frame binding. Allocation function
within the reserved iova domain will be introduced in subsequent patches.

Those functions are implemented and exposed if CONFIG_IOMMU_DMA_RESERVED
is seta.

Signed-off-by: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

---

v5 -> v6:
- use spin lock instead of mutex

v3 -> v4:
- formerly in "iommu/arm-smmu: implement alloc/free_reserved_iova_domain" &
  "iommu: add alloc/free_reserved_iova_domain"

v2 -> v3:
- remove iommu_alloc_reserved_iova_domain & iommu_free_reserved_iova_domain
  static implementation in case CONFIG_IOMMU_API is not set

v1 -> v2:
- moved from vfio API to IOMMU API
---
 drivers/iommu/Kconfig              |  8 ++++
 drivers/iommu/Makefile             |  1 +
 drivers/iommu/dma-reserved-iommu.c | 75 ++++++++++++++++++++++++++++++++++++++
 include/linux/dma-reserved-iommu.h | 45 +++++++++++++++++++++++
 4 files changed, 129 insertions(+)
 create mode 100644 drivers/iommu/dma-reserved-iommu.c
 create mode 100644 include/linux/dma-reserved-iommu.h

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index dd1dc39..a5a1530 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -74,6 +74,12 @@ config IOMMU_DMA
 	select IOMMU_IOVA
 	select NEED_SG_DMA_LENGTH
 
+# IOMMU reserved IOVA mapping (MSI doorbell)
+config IOMMU_DMA_RESERVED
+	bool
+	select IOMMU_API
+	select IOMMU_IOVA
+
 config FSL_PAMU
 	bool "Freescale IOMMU support"
 	depends on PPC32
@@ -307,6 +313,7 @@ config SPAPR_TCE_IOMMU
 config ARM_SMMU
 	bool "ARM Ltd. System MMU (SMMU) Support"
 	depends on (ARM64 || ARM) && MMU
+	select IOMMU_DMA_RESERVED
 	select IOMMU_API
 	select IOMMU_IO_PGTABLE_LPAE
 	select ARM_DMA_USE_IOMMU if ARM
@@ -320,6 +327,7 @@ config ARM_SMMU
 config ARM_SMMU_V3
 	bool "ARM Ltd. System MMU Version 3 (SMMUv3) Support"
 	depends on ARM64 && PCI
+	select IOMMU_DMA_RESERVED
 	select IOMMU_API
 	select IOMMU_IO_PGTABLE_LPAE
 	select GENERIC_MSI_IRQ_DOMAIN
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index c6edb31..6c9ae99 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
+obj-$(CONFIG_IOMMU_DMA_RESERVED) += dma-reserved-iommu.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
diff --git a/drivers/iommu/dma-reserved-iommu.c b/drivers/iommu/dma-reserved-iommu.c
new file mode 100644
index 0000000..a461482
--- /dev/null
+++ b/drivers/iommu/dma-reserved-iommu.c
@@ -0,0 +1,75 @@
+/*
+ * Reserved IOVA Management
+ *
+ * Copyright (c) 2015 Linaro Ltd.
+ *              www.linaro.org
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/iommu.h>
+#include <linux/iova.h>
+
+int iommu_alloc_reserved_iova_domain(struct iommu_domain *domain,
+				     dma_addr_t iova, size_t size,
+				     unsigned long order)
+{
+	unsigned long granule, mask;
+	struct iova_domain *iovad;
+	unsigned long flags;
+	int ret = 0;
+
+	granule = 1UL << order;
+	mask = granule - 1;
+	if (iova & mask || (!size) || (size & mask))
+		return -EINVAL;
+
+	iovad = kzalloc(sizeof(struct iova_domain), GFP_KERNEL);
+	if (!iovad)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&domain->reserved_lock, flags);
+
+	if (domain->reserved_iova_cookie) {
+		ret = -EEXIST;
+		goto free_unlock;
+	}
+
+	init_iova_domain(iovad, granule,
+			 iova >> order, (iova + size - 1) >> order);
+	domain->reserved_iova_cookie = iovad;
+	goto unlock;
+
+free_unlock:
+	kfree(iovad);
+unlock:
+	spin_unlock_irqrestore(&domain->reserved_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_alloc_reserved_iova_domain);
+
+void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
+{
+	struct iova_domain *iovad =
+		(struct iova_domain *)domain->reserved_iova_cookie;
+	unsigned long flags;
+
+	if (!iovad)
+		return;
+
+	spin_lock_irqsave(&domain->reserved_lock, flags);
+
+	put_iova_domain(iovad);
+	kfree(iovad);
+
+	spin_unlock_irqrestore(&domain->reserved_lock, flags);
+}
+EXPORT_SYMBOL_GPL(iommu_free_reserved_iova_domain);
diff --git a/include/linux/dma-reserved-iommu.h b/include/linux/dma-reserved-iommu.h
new file mode 100644
index 0000000..5bf863b
--- /dev/null
+++ b/include/linux/dma-reserved-iommu.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (c) 2015 Linaro Ltd.
+ *              www.linaro.org
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __DMA_RESERVED_IOMMU_H
+#define __DMA_RESERVED_IOMMU_H
+
+#ifdef __KERNEL__
+#include <asm/errno.h>
+
+#ifdef CONFIG_IOMMU_DMA_RESERVED
+#include <linux/iommu.h>
+
+/**
+ * iommu_alloc_reserved_iova_domain: allocate the reserved iova domain
+ *
+ * @domain: iommu domain handle
+ * @iova: base iova address
+ * @size: iova window size
+ * @order: page order
+ */
+int iommu_alloc_reserved_iova_domain(struct iommu_domain *domain,
+				     dma_addr_t iova, size_t size,
+				     unsigned long order);
+
+/**
+ * iommu_free_reserved_iova_domain: free the reserved iova domain
+ *
+ * @domain: iommu domain handle
+ */
+void iommu_free_reserved_iova_domain(struct iommu_domain *domain);
+
+#endif	/* CONFIG_IOMMU_DMA_RESERVED */
+#endif	/* __KERNEL__ */
+#endif	/* __DMA_RESERVED_IOMMU_H */
-- 
1.9.1
