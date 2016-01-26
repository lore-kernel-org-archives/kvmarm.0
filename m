From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 02/10] vfio: expose MSI mapping requirement through
 VFIO_IOMMU_GET_INFO
Date: Tue, 26 Jan 2016 13:12:40 +0000
Message-ID: <1453813968-2024-3-git-send-email-eric.auger@linaro.org>
References: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84BD24113E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:08:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XcMFlNO88dmj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2016 08:08:31 -0500 (EST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2DB8411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:08:30 -0500 (EST)
Received: by mail-wm0-f43.google.com with SMTP id r129so103632826wmr.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 05:13:26 -0800 (PST)
In-Reply-To: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, will.deacon@arm.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch allows the user-space to retrieve whether msi write
transaction addresses must be mapped. This is returned through the
VFIO_IOMMU_GET_INFO API using a new flag: VFIO_IOMMU_INFO_REQUIRE_MSI_MAP.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

RFC v1 -> RFC v2:
- derived from
  [RFC PATCH 3/6] vfio: Extend iommu-info to return MSIs automap state
- renamed allow_msi_reconfig into require_msi_mapping
- fixed VFIO_IOMMU_GET_INFO
---
 drivers/vfio/vfio_iommu_type1.c | 26 ++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 6f1ea3d..c5b57e1 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -255,6 +255,29 @@ static int vaddr_get_pfn(unsigned long vaddr, int prot, unsigned long *pfn)
 }
 
 /*
+ * vfio_domains_require_msi_mapping: indicates whether MSI write transaction
+ * addresses must be mapped
+ *
+ * returns true if it does
+ */
+static bool vfio_domains_require_msi_mapping(struct vfio_iommu *iommu)
+{
+	struct vfio_domain *d;
+	bool ret;
+
+	mutex_lock(&iommu->lock);
+	/* All domains have same require_msi_map property, pick first */
+	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
+	if (iommu_domain_get_attr(d->domain, DOMAIN_ATTR_MSI_MAPPING, NULL) < 0)
+		ret = false;
+	else
+		ret = true;
+	mutex_unlock(&iommu->lock);
+
+	return ret;
+}
+
+/*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
  * first page and all consecutive pages with the same locking.
@@ -997,6 +1020,9 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		info.flags = VFIO_IOMMU_INFO_PGSIZES;
 
+		if (vfio_domains_require_msi_mapping(iommu))
+			info.flags |= VFIO_IOMMU_INFO_REQUIRE_MSI_MAP;
+
 		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
 
 		return copy_to_user((void __user *)arg, &info, minsz);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 7d7a4c6..43e183b 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -400,6 +400,7 @@ struct vfio_iommu_type1_info {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
+#define VFIO_IOMMU_INFO_REQUIRE_MSI_MAP (1 << 1)/* MSI must be mapped */
 	__u64	iova_pgsizes;		/* Bitmap of supported page sizes */
 };
 
-- 
1.9.1
