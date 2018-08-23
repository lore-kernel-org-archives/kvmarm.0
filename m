From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 01/13] iommu: Introduce bind_guest_stage API
Date: Thu, 23 Aug 2018 14:17:24 +0200
Message-ID: <1535026656-8450-2-git-send-email-eric.auger__39376.4459797696$1535038707$gmane$org@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 488CF4A210
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:17:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UefGAcyGSLSi for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 08:17:48 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 177ED4A1DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:17:48 -0400 (EDT)
In-Reply-To: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jean-philippe.brucker@arm.com,
 jacob.jun.pan@linux.intel.com, yi.l.liu"@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

In virtualization use case, when a guest is assigned
a PCI host device, protected by a virtual IOMMU on a guest,
the physical IOMMU must be programmed to be consistent with
the guest mappings. If the physical IOMMU supports two
translation stages it makes sense to program guest mappings
onto the first stage while to host owns the stage 2.

In that case, it is mandated to trap on guest configuration
settings and pass those to the physical iommu driver.

This patch adds a new API to the iommu subsystem that allows
to bind and unbind the guest configuration data to the host.

A generic iommu_guest_stage_config struct is introduced in
a new iommu.h uapi header. This is going to be used by the VFIO
user API. We foresee at least 2 specialization of this struct,
for PASID table passing and ARM SMMUv3.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

This patch generalizes the API introduced by Jacob & co-authors in
https://lwn.net/Articles/754331/
---
 drivers/iommu/iommu.c      | 19 +++++++++++++++
 include/linux/iommu.h      | 23 ++++++++++++++++++
 include/uapi/linux/iommu.h | 59 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+)
 create mode 100644 include/uapi/linux/iommu.h

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 63b3756..5156172 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1326,6 +1326,25 @@ int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_attach_device);
 
+int iommu_bind_guest_stage(struct iommu_domain *domain, struct device *dev,
+			   struct iommu_guest_stage_config *cfg)
+{
+	if (unlikely(!domain->ops->bind_guest_stage))
+		return -ENODEV;
+
+	return domain->ops->bind_guest_stage(domain, dev, cfg);
+}
+EXPORT_SYMBOL_GPL(iommu_bind_guest_stage);
+
+void iommu_unbind_guest_stage(struct iommu_domain *domain, struct device *dev)
+{
+	if (unlikely(!domain->ops->unbind_guest_stage))
+		return;
+
+	domain->ops->unbind_guest_stage(domain, dev);
+}
+EXPORT_SYMBOL_GPL(iommu_unbind_guest_stage);
+
 static void __iommu_detach_device(struct iommu_domain *domain,
 				  struct device *dev)
 {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 19938ee..aec853d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -25,6 +25,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <uapi/linux/iommu.h>
 
 #define IOMMU_READ	(1 << 0)
 #define IOMMU_WRITE	(1 << 1)
@@ -187,6 +188,8 @@ struct iommu_resv_region {
  * @domain_get_windows: Return the number of windows for a domain
  * @of_xlate: add OF master IDs to iommu grouping
  * @pgsize_bitmap: bitmap of all possible supported page sizes
+ * @bind_guest_stage: program the guest stage configuration
+ * @unbind_guest_stage: unbind the guest stage and restore defaults
  */
 struct iommu_ops {
 	bool (*capable)(enum iommu_cap);
@@ -235,6 +238,11 @@ struct iommu_ops {
 	int (*of_xlate)(struct device *dev, struct of_phandle_args *args);
 	bool (*is_attach_deferred)(struct iommu_domain *domain, struct device *dev);
 
+	int (*bind_guest_stage)(struct iommu_domain *domain, struct device *dev,
+				struct iommu_guest_stage_config *cfg);
+	void (*unbind_guest_stage)(struct iommu_domain *domain,
+				   struct device *dev);
+
 	unsigned long pgsize_bitmap;
 };
 
@@ -296,6 +304,10 @@ extern int iommu_attach_device(struct iommu_domain *domain,
 			       struct device *dev);
 extern void iommu_detach_device(struct iommu_domain *domain,
 				struct device *dev);
+extern int iommu_bind_guest_stage(struct iommu_domain *domain,
+		struct device *dev, struct iommu_guest_stage_config *cfg);
+extern void iommu_unbind_guest_stage(struct iommu_domain *domain,
+				     struct device *dev);
 extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot);
@@ -696,6 +708,17 @@ const struct iommu_ops *iommu_ops_from_fwnode(struct fwnode_handle *fwnode)
 	return NULL;
 }
 
+static inline
+int iommu_bind_guest_stage(struct iommu_domain *domain, struct device *dev,
+			   struct iommu_guest_stage_config *cfg)
+{
+	return -ENODEV;
+}
+static inline
+void iommu_unbind_guest_stage(struct iommu_domain *domain, struct device *dev)
+{
+}
+
 #endif /* CONFIG_IOMMU_API */
 
 #endif /* __LINUX_IOMMU_H */
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
new file mode 100644
index 0000000..2d1593c
--- /dev/null
+++ b/include/uapi/linux/iommu.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * IOMMU user API definitions
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _UAPI_IOMMU_H
+#define _UAPI_IOMMU_H
+
+#include <linux/types.h>
+
+/**
+ * PASID table data used to bind guest PASID table to the host IOMMU. This will
+ * enable guest managed first level page tables.
+ * @version: for future extensions and identification of the data format
+ * @bytes: size of this structure
+ * @base_ptr:	PASID table pointer
+ * @pasid_bits:	number of bits supported in the guest PASID table, must be less
+ *		or equal than the host supported PASID size.
+ */
+struct iommu_pasid_table_config {
+	__u32 version;
+#define PASID_TABLE_CFG_VERSION_1 1
+	__u32 bytes;
+	__u64 base_ptr;
+	__u8 pasid_bits;
+};
+
+/**
+ * Stream Table Entry S1 info
+ * @disabled: the smmu is disabled
+ * @bypassed: stage 1 is bypassed
+ * @aborted: aborted
+ * @cdptr_dma: GPA of the Context Descriptor
+ * @asid: address space identified associated to the CD
+ */
+struct iommu_smmu_s1_config {
+	__u8 disabled;
+	__u8 bypassed;
+	__u8 aborted;
+	__u64 cdptr_dma;
+	__u16 asid;
+};
+
+struct iommu_guest_stage_config {
+#define PASID_TABLE	(1 << 0)
+#define SMMUV3_S1_CFG	(1 << 1)
+	__u32 flags;
+	union {
+		struct iommu_pasid_table_config pasidt;
+		struct iommu_smmu_s1_config smmu_s1;
+	};
+};
+
+#endif /* _UAPI_IOMMU_H */
-- 
2.5.5
