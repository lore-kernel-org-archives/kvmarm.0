Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C103EC10F13
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 12:20:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 742B721473
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 12:20:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 742B721473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AE364A472;
	Mon,  8 Apr 2019 08:20:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IX40ytsx-54z; Mon,  8 Apr 2019 08:20:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEF954A482;
	Mon,  8 Apr 2019 08:20:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D181F4A420
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 08:19:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wb-rqdEZoLCh for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 08:19:58 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 917034A44D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 08:19:58 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id D8EA5306D354;
 Mon,  8 Apr 2019 12:19:57 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-117-161.ams2.redhat.com [10.36.117.161])
 by smtp.corp.redhat.com (Postfix) with ESMTP id D10BC600C4;
 Mon,  8 Apr 2019 12:19:53 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com,
 robin.murphy@arm.com
Subject: [PATCH v7 05/23] iommu: Introduce cache_invalidate API
Date: Mon,  8 Apr 2019 14:18:53 +0200
Message-Id: <20190408121911.24103-6-eric.auger@redhat.com>
In-Reply-To: <20190408121911.24103-1-eric.auger@redhat.com>
References: <20190408121911.24103-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.47]); Mon, 08 Apr 2019 12:19:58 +0000 (UTC)
Cc: kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com,
 marc.zyngier@arm.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408121853.jWOAupAx-sQjb3O52NTtZNT05OtAWl1uKlcY2g3xLbg@z>

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
v6 -> v7:
- detail which fields are used for each invalidation type
- add a comment about multiple cache invalidation

v5 -> v6:
- fix merge issue

v3 -> v4:
- full reshape of the API following Alex' comments

v1 -> v2:
- add arch_id field
- renamed tlb_invalidate into cache_invalidate as this API allows
  to invalidate context caches on top of IOTLBs

v1:
renamed sva_invalidate into tlb_invalidate and add iommu_ prefix in
header. Commit message reworded.
---
 drivers/iommu/iommu.c      | 14 +++++++
 include/linux/iommu.h      | 15 ++++++++
 include/uapi/linux/iommu.h | 78 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ede8a9bef826..6d6cb4005ca5 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1547,6 +1547,20 @@ void iommu_detach_pasid_table(struct iommu_domain *domain)
 }
 EXPORT_SYMBOL_GPL(iommu_detach_pasid_table);
 
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
index fb9b7a8de25f..7c7c6bad1420 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -191,6 +191,7 @@ struct iommu_resv_region {
  *                      driver init to device driver init (default no)
  * @attach_pasid_table: attach a pasid table
  * @detach_pasid_table: detach the pasid table
+ * @cache_invalidate: invalidate translation caches
  * @pgsize_bitmap: bitmap of all possible supported page sizes
  */
 struct iommu_ops {
@@ -239,6 +240,9 @@ struct iommu_ops {
 				  struct iommu_pasid_table_config *cfg);
 	void (*detach_pasid_table)(struct iommu_domain *domain);
 
+	int (*cache_invalidate)(struct iommu_domain *domain, struct device *dev,
+				struct iommu_cache_invalidate_info *inv_info);
+
 	unsigned long pgsize_bitmap;
 };
 
@@ -349,6 +353,9 @@ extern void iommu_detach_device(struct iommu_domain *domain,
 extern int iommu_attach_pasid_table(struct iommu_domain *domain,
 				    struct iommu_pasid_table_config *cfg);
 extern void iommu_detach_pasid_table(struct iommu_domain *domain);
+extern int iommu_cache_invalidate(struct iommu_domain *domain,
+				  struct device *dev,
+				  struct iommu_cache_invalidate_info *inv_info);
 extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
@@ -797,6 +804,14 @@ int iommu_attach_pasid_table(struct iommu_domain *domain,
 static inline
 void iommu_detach_pasid_table(struct iommu_domain *domain) {}
 
+static inline int
+iommu_cache_invalidate(struct iommu_domain *domain,
+		       struct device *dev,
+		       struct iommu_cache_invalidate_info *inv_info)
+{
+	return -ENODEV;
+}
+
 #endif /* CONFIG_IOMMU_API */
 
 #ifdef CONFIG_IOMMU_DEBUGFS
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index 532a64075f23..61a3fb75be3f 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -159,4 +159,82 @@ struct iommu_pasid_table_config {
 	};
 };
 
+/* defines the granularity of the invalidation */
+enum iommu_inv_granularity {
+	IOMMU_INV_GRANU_DOMAIN,	/* domain-selective invalidation */
+	IOMMU_INV_GRANU_PASID,	/* pasid-selective invalidation */
+	IOMMU_INV_GRANU_ADDR,	/* page-selective invalidation */
+};
+
+/**
+ * Address Selective Invalidation Structure
+ *
+ * @flags indicates the granularity of the address-selective invalidation
+ * - if PASID bit is set, @pasid field is populated and the invalidation
+ *   relates to cache entries tagged with this PASID and matching the
+ *   address range.
+ * - if ARCHID bit is set, @archid is populated and the invalidation relates
+ *   to cache entries tagged with this architecture specific id and matching
+ *   the address range.
+ * - Both PASID and ARCHID can be set as they may tag different caches.
+ * - if neither PASID or ARCHID is set, global addr invalidation applies
+ * - LEAF flag indicates whether only the leaf PTE caching needs to be
+ *   invalidated and other paging structure caches can be preserved.
+ * @pasid: process address space id
+ * @archid: architecture-specific id
+ * @addr: first stage/level input address
+ * @granule_size: page/block size of the mapping in bytes
+ * @nb_granules: number of contiguous granules to be invalidated
+ */
+struct iommu_inv_addr_info {
+#define IOMMU_INV_ADDR_FLAGS_PASID	(1 << 0)
+#define IOMMU_INV_ADDR_FLAGS_ARCHID	(1 << 1)
+#define IOMMU_INV_ADDR_FLAGS_LEAF	(1 << 2)
+	__u32	flags;
+	__u32	archid;
+	__u64	pasid;
+	__u64	addr;
+	__u64	granule_size;
+	__u64	nb_granules;
+};
+
+/**
+ * First level/stage invalidation information
+ * @cache: bitfield that allows to select which caches to invalidate
+ * @granularity: defines the lowest granularity used for the invalidation:
+ *     domain > pasid > addr
+ *
+ * Not all the combinations of cache/granularity make sense:
+ *
+ *         type |   DEV_IOTLB   |     IOTLB     |      PASID    |
+ * granularity	|		|		|      cache	|
+ * -------------+---------------+---------------+---------------+
+ * DOMAIN	|	N/A	|       Y	|	Y	|
+ * PASID	|	Y	|       Y	|	Y	|
+ * ADDR		|       Y	|       Y	|	N/A	|
+ *
+ * Invalidations by %IOMMU_INV_GRANU_ADDR use field @addr_info.
+ * Invalidations by %IOMMU_INV_GRANU_PASID use field @pasid.
+ * Invalidations by %IOMMU_INV_GRANU_DOMAIN don't take any argument.
+ *
+ * If multiple cache types are invalidated simultaneously, they all
+ * must support the used granularity.
+ */
+struct iommu_cache_invalidate_info {
+#define IOMMU_CACHE_INVALIDATE_INFO_VERSION_1 1
+	__u32	version;
+/* IOMMU paging structure cache */
+#define IOMMU_CACHE_INV_TYPE_IOTLB	(1 << 0) /* IOMMU IOTLB */
+#define IOMMU_CACHE_INV_TYPE_DEV_IOTLB	(1 << 1) /* Device IOTLB */
+#define IOMMU_CACHE_INV_TYPE_PASID	(1 << 2) /* PASID cache */
+	__u8	cache;
+	__u8	granularity;
+	__u8	padding[2];
+	union {
+		__u64	pasid;
+		struct iommu_inv_addr_info addr_info;
+	};
+};
+
+
 #endif /* _UAPI_IOMMU_H */
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
