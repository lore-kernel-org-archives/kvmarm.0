From: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v2 01/20] iommu: Introduce bind_pasid_table API
Date: Tue, 18 Sep 2018 16:24:38 +0200
Message-ID: <20180918142457.3325-2-eric.auger@redhat.com>
References: <20180918142457.3325-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180918142457.3325-1-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yi.l.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org
Cc: tianyu.lan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christoffer.dall-5wv7dgnIgG8@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

In virtualization use case, when a guest is assigned
a PCI host device, protected by a virtual IOMMU on a guest,
the physical IOMMU must be programmed to be consistent with
the guest mappings. If the physical IOMMU supports two
translation stages it makes sense to program guest mappings
onto the first stage/level (ARM/VTD terminology) while to host
owns the stage/level 2.

In that case, it is mandated to trap on guest configuration
settings and pass those to the physical iommu driver.

This patch adds a new API to the iommu subsystem that allows
to bind and unbind the guest configuration data to the host.

A generic iommu_pasid_table_config struct is introduced in
a new iommu.h uapi header. This is going to be used by the VFIO
user API. We foresee at least two specializations of this struct,
for PASID table passing and ARM SMMUv3.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Liu, Yi L <yi.l.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---

In practice, I think it would be simpler to have a single
set_pasid_table function instead of bind/unbind. The "bypass" field
tells the stage 1 is bypassed (equivalent to the unbind actually).
On userspace we have notifications that the device context has changed.
Calling either bind or unbind requires to have an understand of what
was the previous state and call different notifiers. So to me the
bind/unbind complexifies the user integration while not bring much
benefits.

This patch generalizes the API introduced by Jacob & co-authors in
https://lwn.net/Articles/754331/

v1 -> v2:
- restore the original pasid table name
- remove the struct device * parameter in the API
- reworked iommu_pasid_smmuv3
---
 drivers/iommu/iommu.c      | 19 ++++++++++++++
 include/linux/iommu.h      | 21 +++++++++++++++
 include/uapi/linux/iommu.h | 52 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+)
 create mode 100644 include/uapi/linux/iommu.h

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 8c15c5980299..db2c7c9502ae 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1362,6 +1362,25 @@ int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_attach_device);
 
+int iommu_bind_pasid_table(struct iommu_domain *domain,
+			   struct iommu_pasid_table_config *cfg)
+{
+	if (unlikely(!domain->ops->bind_pasid_table))
+		return -ENODEV;
+
+	return domain->ops->bind_pasid_table(domain, cfg);
+}
+EXPORT_SYMBOL_GPL(iommu_bind_pasid_table);
+
+void iommu_unbind_pasid_table(struct iommu_domain *domain)
+{
+	if (unlikely(!domain->ops->unbind_pasid_table))
+		return;
+
+	domain->ops->unbind_pasid_table(domain);
+}
+EXPORT_SYMBOL_GPL(iommu_unbind_pasid_table);
+
 static void __iommu_detach_device(struct iommu_domain *domain,
 				  struct device *dev)
 {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 87994c265bf5..e56cad4863f7 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -25,6 +25,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <uapi/linux/iommu.h>
 
 #define IOMMU_READ	(1 << 0)
 #define IOMMU_WRITE	(1 << 1)
@@ -185,6 +186,8 @@ struct iommu_resv_region {
  * @domain_get_windows: Return the number of windows for a domain
  * @of_xlate: add OF master IDs to iommu grouping
  * @pgsize_bitmap: bitmap of all possible supported page sizes
+ * @bind_pasid_table: bind pasid table
+ * @unbind_pasid_table: unbind pasid table and restore defaults
  */
 struct iommu_ops {
 	bool (*capable)(enum iommu_cap);
@@ -231,6 +234,10 @@ struct iommu_ops {
 	int (*of_xlate)(struct device *dev, struct of_phandle_args *args);
 	bool (*is_attach_deferred)(struct iommu_domain *domain, struct device *dev);
 
+	int (*bind_pasid_table)(struct iommu_domain *domain,
+				struct iommu_pasid_table_config *cfg);
+	void (*unbind_pasid_table)(struct iommu_domain *domain);
+
 	unsigned long pgsize_bitmap;
 };
 
@@ -292,6 +299,9 @@ extern int iommu_attach_device(struct iommu_domain *domain,
 			       struct device *dev);
 extern void iommu_detach_device(struct iommu_domain *domain,
 				struct device *dev);
+extern int iommu_bind_pasid_table(struct iommu_domain *domain,
+				  struct iommu_pasid_table_config *cfg);
+extern void iommu_unbind_pasid_table(struct iommu_domain *domain);
 extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot);
@@ -684,6 +694,17 @@ const struct iommu_ops *iommu_ops_from_fwnode(struct fwnode_handle *fwnode)
 	return NULL;
 }
 
+static inline
+int iommu_bind_pasid_table(struct iommu_domain *domain,
+			   struct iommu_pasid_table_config *cfg)
+{
+	return -ENODEV;
+}
+static inline
+void iommu_unbind_pasid_table(struct iommu_domain *domain)
+{
+}
+
 #endif /* CONFIG_IOMMU_API */
 
 #ifdef CONFIG_IOMMU_DEBUGFS
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
new file mode 100644
index 000000000000..babec91ae7e1
--- /dev/null
+++ b/include/uapi/linux/iommu.h
@@ -0,0 +1,52 @@
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
+ * SMMUv3 Stream Table Entry stage 1 related information
+ * @s1contextptr: Context Descriptor Table GPA
+ * @abort: shall the STE lead to abort
+ * @s1fmt: STE s1fmt field as set by the guest
+ * @s1cdmax: STE s1cdmax as set by the guest
+ * @s1dss: STE s1dss as set by the guest
+ * All field names match the smmu 3.0/3.1 spec (ARM IHI 0070A)
+ */
+struct iommu_pasid_smmuv3 {
+	__u64 s1contextptr;
+	__u8 bypass;
+	__u8 abort;
+	__u8 s1fmt;
+	__u8 s1cdmax;
+	__u8 s1dss;
+};
+
+/**
+ * PASID table data used to bind guest PASID table to the host IOMMU
+ * Note PASID table corresponds to the Context Table on ARM SMMUv3.
+ *
+ * @version: API version to prepare for future extensions
+ * @format: format of the PASID table
+ *
+ */
+struct iommu_pasid_table_config {
+#define PASID_TABLE_CFG_VERSION_1 1
+	__u32 version;
+#define IOMMU_PASID_FORMAT_SMMUV3	(1 << 0)
+	__u32 format;
+	union {
+		struct iommu_pasid_smmuv3 smmuv3;
+	};
+};
+
+#endif /* _UAPI_IOMMU_H */
-- 
2.17.1
