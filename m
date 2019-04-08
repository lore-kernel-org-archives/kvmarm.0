From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v7 04/23] iommu: Introduce attach/detach_pasid_table API
Date: Mon,  8 Apr 2019 14:18:52 +0200
Message-ID: <20190408121911.24103-5-eric.auger@redhat.com>
References: <20190408121911.24103-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190408121911.24103-1-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org, vincent.stehle@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

In virtualization use case, when a guest is assigned
a PCI host device, protected by a virtual IOMMU on the guest,
the physical IOMMU must be programmed to be consistent with
the guest mappings. If the physical IOMMU supports two
translation stages it makes sense to program guest mappings
onto the first stage/level (ARM/Intel terminology) while the host
owns the stage/level 2.

In that case, it is mandated to trap on guest configuration
settings and pass those to the physical iommu driver.

This patch adds a new API to the iommu subsystem that allows
to set/unset the pasid table information.

A generic iommu_pasid_table_config struct is introduced in
a new iommu.h uapi header. This is going to be used by the VFIO
user API.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

---

This patch generalizes the API introduced by Jacob & co-authors in
https://lwn.net/Articles/754331/

v4 -> v5:
- no returned valued for dummy definition of iommu_detach_pasid_table
- fix order in comment
- added Jean's R-b

v3 -> v4:
- s/set_pasid_table/attach_pasid_table
- restore detach_pasid_table. Detach can be used on unwind path.
- add padding
- remove @abort
- signature used for config and format
- add comments for fields in the SMMU struct

v2 -> v3:
- replace unbind/bind by set_pasid_table
- move table pointer and pasid bits in the generic part of the struct

v1 -> v2:
- restore the original pasid table name
- remove the struct device * parameter in the API
- reworked iommu_pasid_smmuv3
---
 drivers/iommu/iommu.c      | 19 +++++++++++++++
 include/linux/iommu.h      | 19 +++++++++++++++
 include/uapi/linux/iommu.h | 47 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 63c282a77fa9..ede8a9bef826 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1528,6 +1528,25 @@ int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_attach_device);
 
+int iommu_attach_pasid_table(struct iommu_domain *domain,
+			     struct iommu_pasid_table_config *cfg)
+{
+	if (unlikely(!domain->ops->attach_pasid_table))
+		return -ENODEV;
+
+	return domain->ops->attach_pasid_table(domain, cfg);
+}
+EXPORT_SYMBOL_GPL(iommu_attach_pasid_table);
+
+void iommu_detach_pasid_table(struct iommu_domain *domain)
+{
+	if (unlikely(!domain->ops->detach_pasid_table))
+		return;
+
+	domain->ops->detach_pasid_table(domain);
+}
+EXPORT_SYMBOL_GPL(iommu_detach_pasid_table);
+
 static void __iommu_detach_device(struct iommu_domain *domain,
 				  struct device *dev)
 {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index aeb4b615cb44..fb9b7a8de25f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -189,6 +189,8 @@ struct iommu_resv_region {
  * @of_xlate: add OF master IDs to iommu grouping
  * @is_attach_deferred: Check if domain attach should be deferred from iommu
  *                      driver init to device driver init (default no)
+ * @attach_pasid_table: attach a pasid table
+ * @detach_pasid_table: detach the pasid table
  * @pgsize_bitmap: bitmap of all possible supported page sizes
  */
 struct iommu_ops {
@@ -233,6 +235,10 @@ struct iommu_ops {
 	int (*of_xlate)(struct device *dev, struct of_phandle_args *args);
 	bool (*is_attach_deferred)(struct iommu_domain *domain, struct device *dev);
 
+	int (*attach_pasid_table)(struct iommu_domain *domain,
+				  struct iommu_pasid_table_config *cfg);
+	void (*detach_pasid_table)(struct iommu_domain *domain);
+
 	unsigned long pgsize_bitmap;
 };
 
@@ -340,6 +346,9 @@ extern int iommu_attach_device(struct iommu_domain *domain,
 			       struct device *dev);
 extern void iommu_detach_device(struct iommu_domain *domain,
 				struct device *dev);
+extern int iommu_attach_pasid_table(struct iommu_domain *domain,
+				    struct iommu_pasid_table_config *cfg);
+extern void iommu_detach_pasid_table(struct iommu_domain *domain);
 extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
@@ -778,6 +787,16 @@ const struct iommu_ops *iommu_ops_from_fwnode(struct fwnode_handle *fwnode)
 	return NULL;
 }
 
+static inline
+int iommu_attach_pasid_table(struct iommu_domain *domain,
+			     struct iommu_pasid_table_config *cfg)
+{
+	return -ENODEV;
+}
+
+static inline
+void iommu_detach_pasid_table(struct iommu_domain *domain) {}
+
 #endif /* CONFIG_IOMMU_API */
 
 #ifdef CONFIG_IOMMU_DEBUGFS
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index edcc0dda7993..532a64075f23 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -112,4 +112,51 @@ struct iommu_fault {
 		struct iommu_fault_page_request prm;
 	};
 };
+
+/**
+ * SMMUv3 Stream Table Entry stage 1 related information
+ * The PASID table is referred to as the context descriptor (CD) table.
+ *
+ * @s1fmt: STE s1fmt (format of the CD table: single CD, linear table
+   or 2-level table)
+ * @s1dss: STE s1dss (specifies the behavior when pasid_bits != 0
+   and no pasid is passed along with the incoming transaction)
+ * Please refer to the smmu 3.x spec (ARM IHI 0070A) for full details
+ */
+struct iommu_pasid_smmuv3 {
+#define PASID_TABLE_SMMUV3_CFG_VERSION_1 1
+	__u32	version;
+	__u8 s1fmt;
+	__u8 s1dss;
+	__u8 padding[2];
+};
+
+/**
+ * PASID table data used to bind guest PASID table to the host IOMMU
+ * Note PASID table corresponds to the Context Table on ARM SMMUv3.
+ *
+ * @version: API version to prepare for future extensions
+ * @format: format of the PASID table
+ * @base_ptr: guest physical address of the PASID table
+ * @pasid_bits: number of PASID bits used in the PASID table
+ * @config: indicates whether the guest translation stage must
+ * be translated, bypassed or aborted.
+ */
+struct iommu_pasid_table_config {
+#define PASID_TABLE_CFG_VERSION_1 1
+	__u32	version;
+#define IOMMU_PASID_FORMAT_SMMUV3	1
+	__u32	format;
+	__u64	base_ptr;
+	__u8	pasid_bits;
+#define IOMMU_PASID_CONFIG_TRANSLATE	1
+#define IOMMU_PASID_CONFIG_BYPASS	2
+#define IOMMU_PASID_CONFIG_ABORT	3
+	__u8	config;
+	__u8    padding[6];
+	union {
+		struct iommu_pasid_smmuv3 smmuv3;
+	};
+};
+
 #endif /* _UAPI_IOMMU_H */
-- 
2.20.1
