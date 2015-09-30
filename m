From: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Subject: [RFC PATCH 3/6] vfio: Extend iommu-info to return MSIs automap state
Date: Wed, 30 Sep 2015 20:26:26 +0530
Message-ID: <1443624989-24346-3-git-send-email-Bharat.Bhushan@freescale.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 174F1410BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 05:21:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jpxLMwrjuyeG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2015 05:21:49 -0400 (EDT)
Received: from na01-bn1-obe.outbound.protection.outlook.com
 (mail-bn1bon0115.outbound.protection.outlook.com [157.56.111.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3CA8B412F3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 05:21:49 -0400 (EDT)
In-Reply-To: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com
Cc: marc.zyngier@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch allows the user-space to know whether msi-pages
are automatically mapped with some magic iova or not.

Even if the msi-pages are automatically mapped, still user-space
wants to over-ride the automatic iova selection for msi-mapping.
For this user-space need to know whether it is allowed to change
the automatic mapping or not and this API provides this mechanism.
Follow up patches will provide how to over-ride this.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
---
 drivers/vfio/vfio_iommu_type1.c | 32 ++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  3 +++
 2 files changed, 35 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index fa5d3e4..3315fb6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -59,6 +59,7 @@ struct vfio_iommu {
 	struct rb_root		dma_list;
 	bool			v2;
 	bool			nesting;
+	bool			allow_msi_reconfig;
 	struct list_head	reserved_iova_list;
 };
 
@@ -1117,6 +1118,23 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
 	return ret;
 }
 
+static
+int vfio_domains_get_msi_maps(struct vfio_iommu *iommu,
+			      struct iommu_domain_msi_maps *msi_maps)
+{
+	struct vfio_domain *d;
+	int ret;
+
+	mutex_lock(&iommu->lock);
+	/* All domains have same msi-automap property, pick first */
+	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
+	ret = iommu_domain_get_attr(d->domain, DOMAIN_ATTR_MSI_MAPPING,
+				    msi_maps);
+	mutex_unlock(&iommu->lock);
+
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -1138,6 +1156,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		}
 	} else if (cmd == VFIO_IOMMU_GET_INFO) {
 		struct vfio_iommu_type1_info info;
+		struct iommu_domain_msi_maps msi_maps;
+		int ret;
 
 		minsz = offsetofend(struct vfio_iommu_type1_info, iova_pgsizes);
 
@@ -1149,6 +1169,18 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		info.flags = 0;
 
+		ret = vfio_domains_get_msi_maps(iommu, &msi_maps);
+		if (ret)
+			return ret;
+
+		if (msi_maps.override_automap) {
+			info.flags |= VFIO_IOMMU_INFO_MSI_ALLOW_RECONFIG;
+			iommu->allow_msi_reconfig = true;
+		}
+
+		if (msi_maps.automap)
+			info.flags |= VFIO_IOMMU_INFO_MSI_AUTOMAP;
+
 		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
 
 		return copy_to_user((void __user *)arg, &info, minsz);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 1abd1a9..9998f6e 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -391,6 +391,9 @@ struct vfio_iommu_type1_info {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
+#define VFIO_IOMMU_INFO_MSI_AUTOMAP (1 << 1)	/* MSI pages are auto-mapped
+						   in iommu */
+#define VFIO_IOMMU_INFO_MSI_ALLOW_RECONFIG (1 << 2) /* Allows reconfig automap*/
 	__u64	iova_pgsizes;		/* Bitmap of supported page sizes */
 };
 
-- 
1.9.3
