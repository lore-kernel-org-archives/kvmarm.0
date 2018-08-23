From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 02/13] iommu: Introduce tlb_invalidate API
Date: Thu, 23 Aug 2018 14:17:25 +0200
Message-ID: <1535026656-8450-3-git-send-email-eric.auger__24023.8561215394$1535038711$gmane$org@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE5634A1DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:17:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OmHDKgo3qAxf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 08:17:50 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4AA64A210
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:17:50 -0400 (EDT)
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

From: "Liu, Yi L" <yi.l.liu@linux.intel.com>

In any virtualization use case When the fisrt translation stage
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
renamed sva_invalidate into tlb_invalidate and add iommu_ prefix in
header. Commit message reworded.
---
 drivers/iommu/iommu.c      | 14 +++++++
 include/linux/iommu.h      | 13 +++++++
 include/uapi/linux/iommu.h | 91 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 118 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 5156172..0bc05a7 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1345,6 +1345,20 @@ void iommu_unbind_guest_stage(struct iommu_domain *domain, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_unbind_guest_stage);
 
+int iommu_tlb_invalidate(struct iommu_domain *domain, struct device *dev,
+			 struct iommu_tlb_invalidate_info *inv_info)
+{
+	int ret = 0;
+
+	if (unlikely(!domain->ops->tlb_invalidate))
+		return -ENODEV;
+
+	ret = domain->ops->tlb_invalidate(domain, dev, inv_info);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_tlb_invalidate);
+
 static void __iommu_detach_device(struct iommu_domain *domain,
 				  struct device *dev)
 {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index aec853d..b13cf2b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -190,6 +190,7 @@ struct iommu_resv_region {
  * @pgsize_bitmap: bitmap of all possible supported page sizes
  * @bind_guest_stage: program the guest stage configuration
  * @unbind_guest_stage: unbind the guest stage and restore defaults
+ * @tlb_invalidate: invalidate translation caches
  */
 struct iommu_ops {
 	bool (*capable)(enum iommu_cap);
@@ -243,6 +244,9 @@ struct iommu_ops {
 	void (*unbind_guest_stage)(struct iommu_domain *domain,
 				   struct device *dev);
 
+	int (*tlb_invalidate)(struct iommu_domain *domain, struct device *dev,
+			      struct iommu_tlb_invalidate_info *inv_info);
+
 	unsigned long pgsize_bitmap;
 };
 
@@ -308,6 +312,10 @@ extern int iommu_bind_guest_stage(struct iommu_domain *domain,
 		struct device *dev, struct iommu_guest_stage_config *cfg);
 extern void iommu_unbind_guest_stage(struct iommu_domain *domain,
 				     struct device *dev);
+extern int iommu_tlb_invalidate(struct iommu_domain *domain,
+				struct device *dev,
+				struct iommu_tlb_invalidate_info *inv_info);
+
 extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot);
@@ -718,6 +726,11 @@ static inline
 void iommu_unbind_guest_stage(struct iommu_domain *domain, struct device *dev)
 {
 }
+static inline int iommu_tlb_invalidate(struct iommu_domain *domain,
+		struct device *dev, struct iommu_tlb_invalidate_info *inv_info)
+{
+	return -ENODEV;
+}
 
 #endif /* CONFIG_IOMMU_API */
 
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index 2d1593c..7c88d80 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -56,4 +56,95 @@ struct iommu_guest_stage_config {
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
+struct iommu_tlb_invalidate_hdr {
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
+ * @addr:		page address to be invalidated
+ * @flags		IOMMU_INVALIDATE_ADDR_LEAF: leaf paging entries
+ *			IOMMU_INVALIDATE_GLOBAL_PAGE: global pages
+ *
+ */
+struct iommu_tlb_invalidate_info {
+	struct iommu_tlb_invalidate_hdr	hdr;
+	enum iommu_inv_granularity	granularity;
+	__u32		flags;
+#define IOMMU_INVALIDATE_ADDR_LEAF	(1 << 0)
+#define IOMMU_INVALIDATE_GLOBAL_PAGE	(1 << 1)
+	__u8		size;
+	__u64		nr_pages;
+	__u32		pasid;
+	__u64		addr;
+};
 #endif /* _UAPI_IOMMU_H */
-- 
2.5.5
