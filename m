From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v5 04/17] dma-reserved-iommu: alloc/free_reserved_iova_domain
Date: Tue,  1 Mar 2016 18:27:44 +0000
Message-ID: <1456856877-4817-5-git-send-email-eric.auger@linaro.org>
References: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C25B441252
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 13:21:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mbYsEQjaUhoX for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2016 13:21:17 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CB3C4130B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 13:21:16 -0500 (EST)
Received: by mail-wm0-f46.google.com with SMTP id p65so45933881wmp.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Mar 2016 10:28:24 -0800 (PST)
In-Reply-To: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
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

Introduce alloc/free_reserved_iova_domain in the IOMMU API.
alloc_reserved_iova_domain initializes an iova domain at a given
iova base address and with a given size. This iova domain will
be used to allocate iova within that window. Those IOVAs will be reserved
for special purpose, typically MSI frame binding. Allocation function
within the reserved iova domain will be introduced in subsequent patches.

Those functions are implemented and exposed if CONFIG_IOMMU_DMA_RESERVED
is seta.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v3 -> v4:
- formerly in "iommu/arm-smmu: implement alloc/free_reserved_iova_domain" &
  "iommu: add alloc/free_reserved_iova_domain"

v2 -> v3:
- remove iommu_alloc_reserved_iova_domain & iommu_free_reserved_iova_domain
  static implementation in case CONFIG_IOMMU_API is not set

v1 -> v2:
- moved from vfio API to IOMMU API
---
 drivers/iommu/Kconfig              |  8 +++++
 drivers/iommu/Makefile             |  1 +
 drivers/iommu/dma-reserved-iommu.c | 74 ++++++++++++++++++++++++++++++++++++++
 include/linux/dma-reserved-iommu.h | 45 +++++++++++++++++++++++
 4 files changed, 128 insertions(+)
 create mode 100644 drivers/iommu/dma-reserved-iommu.c
 create mode 100644 include/linux/dma-reserved-iommu.h

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index a1e75cb..0775143 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -55,6 +55,12 @@ config IOMMU_DMA
 	select IOMMU_API
 	select IOMMU_IOVA
 
+# IOMMU reserved IOVA mapping (MSI doorbell)
+config IOMMU_DMA_RESERVED
+	bool
+	select IOMMU_API
+	select IOMMU_IOVA
+
 config FSL_PAMU
 	bool "Freescale IOMMU support"
 	depends on PPC32
@@ -288,6 +294,7 @@ config SPAPR_TCE_IOMMU
 config ARM_SMMU
 	bool "ARM Ltd. System MMU (SMMU) Support"
 	depends on (ARM64 || ARM) && MMU
+	select IOMMU_DMA_RESERVED
 	select IOMMU_API
 	select IOMMU_IO_PGTABLE_LPAE
 	select ARM_DMA_USE_IOMMU if ARM
@@ -301,6 +308,7 @@ config ARM_SMMU
 config ARM_SMMU_V3
 	bool "ARM Ltd. System MMU Version 3 (SMMUv3) Support"
 	depends on ARM64 && PCI
+	select IOMMU_DMA_RESERVED
 	select IOMMU_API
 	select IOMMU_IO_PGTABLE_LPAE
 	select GENERIC_MSI_IRQ_DOMAIN
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 42fc0c2..ea68d23 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
+obj-$(CONFIG_IOMMU_DMA_RESERVED) += dma-reserved-iommu.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
 obj-$(CONFIG_IOMMU_IOVA) += iova.o
diff --git a/drivers/iommu/dma-reserved-iommu.c b/drivers/iommu/dma-reserved-iommu.c
new file mode 100644
index 0000000..41a1add
--- /dev/null
+++ b/drivers/iommu/dma-reserved-iommu.c
@@ -0,0 +1,74 @@
+/*
+ * Reserved IOVA Management
+ *
+ * Copyright (c) 2015 Linaro Ltd.
+ *              www.linaro.org
+ *
+ * Copyright (C) 2000-2004 Russell King
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
+	int ret = 0;
+
+	granule = 1UL << order;
+	mask = granule - 1;
+	if (iova & mask || (!size) || (size & mask))
+		return -EINVAL;
+
+	mutex_lock(&domain->reserved_mutex);
+
+	if (domain->reserved_iova_cookie) {
+		ret = -EEXIST;
+		goto unlock;
+	}
+
+	iovad = kzalloc(sizeof(struct iova_domain), GFP_KERNEL);
+	if (!iovad) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	init_iova_domain(iovad, granule,
+			 iova >> order, (iova + size - 1) >> order);
+	domain->reserved_iova_cookie = iovad;
+
+unlock:
+	mutex_unlock(&domain->reserved_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_alloc_reserved_iova_domain);
+
+void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
+{
+	struct iova_domain *iovad =
+		(struct iova_domain *)domain->reserved_iova_cookie;
+
+	if (!iovad)
+		return;
+
+	mutex_lock(&domain->reserved_mutex);
+
+	put_iova_domain(iovad);
+	kfree(iovad);
+
+	mutex_unlock(&domain->reserved_mutex);
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
