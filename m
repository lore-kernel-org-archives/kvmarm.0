From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 02/20] iommu: Introduce cache_invalidate API
Date: Tue, 18 Sep 2018 16:24:39 +0200
Message-ID: <20180918142457.3325-3-eric.auger@redhat.com>
References: <20180918142457.3325-1-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918142457.3325-1-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: tianyu.lan@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: "Liu, Yi L" <yi.l.liu@linux.intel.com>

In any virtualization use case, when the first translation stage
is "owned" by the guest OS, the host IOMMU driver has no knowledge
of caching structure updates unless the guest invalidation activities
are trapped by the virtualizer and passed down to the host.

Since the invalidation data are obtained from user space and will be
written into physical IOMMU, we must allow security check at various
layers. Therefore, generic invalidation data format are proposed here,
model specific IOMMU drivers need to convert them into their own format.

Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v1 -> v2:
- add arch_id field
- renamed tlb_invalidate into cache_invalidate as this API allows
  to invalidate context caches on top of IOTLBs

v1:
renamed sva_invalidate into tlb_invalidate and add iommu_ prefix in
header. Commit message reworded.
---
 drivers/iommu/iommu.c      | 14 ++++++
 include/linux/iommu.h      | 14 ++++++
 include/uapi/linux/iommu.h | 95 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index db2c7c9502ae..1442a6c640af 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1381,6 +1381,20 @@ void iommu_unbind_pasid_table(struct iommu_domain *domain)
 }
 EXPORT_SYMBOL_GPL(iommu_unbind_pasid_table);
 
+int iommu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
+			   struct iommu_cache_invalidate_info *inv_info)
+{
+	int ret = 0;
+
+	if (unlikely(!domain->ops->cache_invalidate))
+		return -ENODEV;
+
+	ret = domain->ops->cache_invalidate(domain, dev, inv_info);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_cache_invalidate);
+
 static void __iommu_detach_device(struct iommu_domain *domain,
 				  struct device *dev)
 {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index e56cad4863f7..3e5f6eb1f04a 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -188,6 +188,7 @@ struct iommu_resv_region {
  * @pgsize_bitmap: bitmap of all possible supported page sizes
  * @bind_pasid_table: bind pasid table
  * @unbind_pasid_table: unbind pasid table and restore defaults
+ * @cache_invalidate: invalidate translation caches
  */
 struct iommu_ops {
 	bool (*capable)(enum iommu_cap);
@@ -238,6 +239,9 @@ struct iommu_ops {
 				struct iommu_pasid_table_config *cfg);
 	void (*unbind_pasid_table)(struct iommu_domain *domain);
 
+	int (*cache_invalidate)(struct iommu_domain *domain, struct device *dev,
+				struct iommu_cache_invalidate_info *inv_info);
+
 	unsigned long pgsize_bitmap;
 };
 
@@ -302,6 +306,9 @@ extern void iommu_detach_device(struct iommu_domain *domain,
 extern int iommu_bind_pasid_table(struct iommu_domain *domain,
 				  struct iommu_pasid_table_config *cfg);
 extern void iommu_unbind_pasid_table(struct iommu_domain *domain);
+extern int iommu_cache_invalidate(struct iommu_domain *domain,
+				struct device *dev,
+				struct iommu_cache_invalidate_info *inv_info);
 extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot);
@@ -704,6 +711,13 @@ static inline
 void iommu_unbind_pasid_table(struct iommu_domain *domain)
 {
 }
+static inline int
+iommu_cache_invalidate(struct iommu_domain *domain,
+		       struct device *dev,
+		       struct iommu_cache_invalidate_info *inv_info)
+{
+	return -ENODEV;
+}
 
 #endif /* CONFIG_IOMMU_API */
 
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index babec91ae7e1..4283e0334baf 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -49,4 +49,99 @@ struct iommu_pasid_table_config {
 	};
 };
 
+/**
+ * enum iommu_inv_granularity - Generic invalidation granularity
+ * @IOMMU_INV_GRANU_DOMAIN_ALL_PASID:	TLB entries or PASID caches of all
+ *					PASIDs associated with a domain ID
+ * @IOMMU_INV_GRANU_PASID_SEL:		TLB entries or PASID cache associated
+ *					with a PASID and a domain
+ * @IOMMU_INV_GRANU_PAGE_PASID:		TLB entries of selected page range
+ *					within a PASID
+ *
+ * When an invalidation request is passed down to IOMMU to flush translation
+ * caches, it may carry different granularity levels, which can be specific
+ * to certain types of translation caches.
+ * This enum is a collection of granularities for all types of translation
+ * caches. The idea is to make it easy for IOMMU model specific driver to
+ * convert from generic to model specific value. Each IOMMU driver
+ * can enforce check based on its own conversion table. The conversion is
+ * based on 2D look-up with inputs as follows:
+ * - translation cache types
+ * - granularity
+ *
+ *             type |   DTLB    |    TLB    |   PASID   |
+ *  granule         |           |           |   cache   |
+ * -----------------+-----------+-----------+-----------+
+ *  DN_ALL_PASID    |   Y       |   Y       |   Y       |
+ *  PASID_SEL       |   Y       |   Y       |   Y       |
+ *  PAGE_PASID      |   Y       |   Y       |   N/A     |
+ *
+ */
+enum iommu_inv_granularity {
+	IOMMU_INV_GRANU_DOMAIN_ALL_PASID,
+	IOMMU_INV_GRANU_PASID_SEL,
+	IOMMU_INV_GRANU_PAGE_PASID,
+	IOMMU_INV_NR_GRANU,
+};
+
+/**
+ * enum iommu_inv_type - Generic translation cache types for invalidation
+ *
+ * @IOMMU_INV_TYPE_DTLB:	device IOTLB
+ * @IOMMU_INV_TYPE_TLB:		IOMMU paging structure cache
+ * @IOMMU_INV_TYPE_PASID:	PASID cache
+ * Invalidation requests sent to IOMMU for a given device need to indicate
+ * which type of translation cache to be operated on. Combined with enum
+ * iommu_inv_granularity, model specific driver can do a simple lookup to
+ * convert from generic to model specific value.
+ */
+enum iommu_inv_type {
+	IOMMU_INV_TYPE_DTLB,
+	IOMMU_INV_TYPE_TLB,
+	IOMMU_INV_TYPE_PASID,
+	IOMMU_INV_NR_TYPE
+};
+
+/**
+ * Translation cache invalidation header that contains mandatory meta data.
+ * @version:	info format version, expecting future extesions
+ * @type:	type of translation cache to be invalidated
+ */
+struct iommu_cache_invalidate_hdr {
+	__u32 version;
+#define TLB_INV_HDR_VERSION_1 1
+	enum iommu_inv_type type;
+};
+
+/**
+ * Translation cache invalidation information, contains generic IOMMU
+ * data which can be parsed based on model ID by model specific drivers.
+ * Since the invalidation of second level page tables are included in the
+ * unmap operation, this info is only applicable to the first level
+ * translation caches, i.e. DMA request with PASID.
+ *
+ * @granularity:	requested invalidation granularity, type dependent
+ * @size:		2^size of 4K pages, 0 for 4k, 9 for 2MB, etc.
+ * @nr_pages:		number of pages to invalidate
+ * @pasid:		processor address space ID value per PCI spec.
+ * @arch_id:		architecture dependent id characterizing a context
+ *			and tagging the caches, ie. domain Identfier on VTD,
+ *			asid on ARM SMMU
+ * @addr:		page address to be invalidated
+ * @flags		IOMMU_INVALIDATE_ADDR_LEAF: leaf paging entries
+ *			IOMMU_INVALIDATE_GLOBAL_PAGE: global pages
+ *
+ */
+struct iommu_cache_invalidate_info {
+	struct iommu_cache_invalidate_hdr	hdr;
+	enum iommu_inv_granularity	granularity;
+	__u32		flags;
+#define IOMMU_INVALIDATE_ADDR_LEAF	(1 << 0)
+#define IOMMU_INVALIDATE_GLOBAL_PAGE	(1 << 1)
+	__u8		size;
+	__u64		nr_pages;
+	__u32		pasid;
+	__u64		arch_id;
+	__u64		addr;
+};
 #endif /* _UAPI_IOMMU_H */
-- 
2.17.1
