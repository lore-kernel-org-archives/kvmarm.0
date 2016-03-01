From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v5 17/17] vfio/type1: return MSI mapping requirements with
 VFIO_IOMMU_GET_INFO
Date: Tue,  1 Mar 2016 18:27:57 +0000
Message-ID: <1456856877-4817-18-git-send-email-eric.auger@linaro.org>
References: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC00E412A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 13:21:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ydr0OqHh2QaK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2016 13:21:58 -0500 (EST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C4C841145
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 13:21:58 -0500 (EST)
Received: by mail-wm0-f47.google.com with SMTP id n186so50812658wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Mar 2016 10:29:06 -0800 (PST)
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

This patch allows the user-space to know whether MSI addresses need to
be mapped in the IOMMU. The user-space uses VFIO_IOMMU_GET_INFO ioctl and
IOMMU_INFO_REQUIRE_MSI_MAP gets set if they need to.

Also the number of IOMMU pages requested to map those is returned in
msi_iova_pages field. User-space must use this information to allocate an
IOVA contiguous region of size msi_iova_pages * ffs(iova_pgsizes) and pass
it with VFIO_IOMMU_MAP_DMA iotcl (VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA set).

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

Currently it is assumed a single doorbell page is used per MSI controller.
This is the case for known ARM MSI controllers (GICv2M, GICv3 ITS, ...).
If an MSI controller were to expose more doorbells it could implement a
new callback at irq_chip interface.

v4 -> v5:
- move msi_info and ret declaration within the conditional code

v3 -> v4:
- replace former vfio_domains_require_msi_mapping by
  more complex computation of MSI mapping requirements, especially the
  number of pages to be provided by the user-space.
- reword patch title

RFC v1 -> v1:
- derived from
  [RFC PATCH 3/6] vfio: Extend iommu-info to return MSIs automap state
- renamed allow_msi_reconfig into require_msi_mapping
- fixed VFIO_IOMMU_GET_INFO
---
 drivers/vfio/vfio_iommu_type1.c | 149 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |   2 +
 2 files changed, 151 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 88a40f1..17a941c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -39,6 +39,7 @@
 #include <linux/dma-reserved-iommu.h>
 #include <linux/irqdomain.h>
 #include <linux/msi.h>
+#include <linux/irq.h>
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
@@ -95,6 +96,18 @@ struct vfio_group {
 	struct list_head	next;
 };
 
+struct vfio_irq_chip {
+	struct list_head next;
+	struct irq_chip *chip;
+};
+
+struct vfio_msi_map_info {
+	bool mapping_required;
+	size_t page_size;
+	unsigned int iova_pages;
+	struct list_head irq_chip_list;
+};
+
 /*
  * This code handles mapping and unmapping of user data buffers
  * into DMA'ble space using the IOMMU
@@ -267,6 +280,128 @@ static int vaddr_get_pfn(unsigned long vaddr, int prot, unsigned long *pfn)
 	return ret;
 }
 
+#if defined(CONFIG_GENERIC_MSI_IRQ_DOMAIN) && defined(CONFIG_IOMMU_DMA_RESERVED)
+/**
+ * vfio_dev_compute_msi_map_info: augment MSI mapping info (@data) with
+ * the @dev device requirements.
+ *
+ * @dev: device handle
+ * @data: opaque pointing to a struct vfio_msi_map_info
+ *
+ * returns 0 upon success or -ENOMEM
+ */
+static int vfio_dev_compute_msi_map_info(struct device *dev, void *data)
+{
+	struct irq_domain *domain;
+	struct msi_domain_info *info;
+	struct vfio_msi_map_info *msi_info = (struct vfio_msi_map_info *)data;
+	struct irq_chip *chip;
+	struct vfio_irq_chip *iter, *new;
+
+	domain = dev_get_msi_domain(dev);
+	if (!domain)
+		return 0;
+
+	/* Let's compute the needs for the MSI domain */
+	info = msi_get_domain_info(domain);
+	chip = info->chip;
+	list_for_each_entry(iter, &msi_info->irq_chip_list, next) {
+		if (iter->chip == chip)
+			return 0;
+	}
+
+	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	new->chip = chip;
+
+	list_add(&new->next, &msi_info->irq_chip_list);
+
+	/*
+	 * new irq_chip to be taken into account; we currently assume
+	 * a single iova doorbell by irq chip requesting MSI mapping
+	 */
+	msi_info->iova_pages += 1;
+	return 0;
+}
+
+/**
+ * vfio_domain_compute_msi_map_info: compute MSI mapping requirements (@data)
+ * for vfio_domain @d
+ *
+ * @d: vfio domain handle
+ * @data: opaque pointing to a struct vfio_msi_map_info
+ *
+ * returns 0 upon success or -ENOMEM
+ */
+static int vfio_domain_compute_msi_map_info(struct vfio_domain *d, void *data)
+{
+	int ret = 0;
+	struct vfio_msi_map_info *msi_info = (struct vfio_msi_map_info *)data;
+	struct vfio_irq_chip *iter, *tmp;
+	struct vfio_group *g;
+
+	msi_info->iova_pages = 0;
+	INIT_LIST_HEAD(&msi_info->irq_chip_list);
+
+	if (iommu_domain_get_attr(d->domain,
+				   DOMAIN_ATTR_MSI_MAPPING, NULL))
+		return 0;
+	msi_info->mapping_required = true;
+	list_for_each_entry(g, &d->group_list, next) {
+		ret = iommu_group_for_each_dev(g->iommu_group, msi_info,
+			   vfio_dev_compute_msi_map_info);
+		if (ret)
+			goto out;
+	}
+out:
+	list_for_each_entry_safe(iter, tmp, &msi_info->irq_chip_list, next) {
+		list_del(&iter->next);
+		kfree(iter);
+	}
+	return ret;
+}
+
+/**
+ * vfio_compute_msi_map_info: compute MSI mapping requirements
+ *
+ * Do some MSI addresses need to be mapped? IOMMU page size?
+ * Max number of IOVA pages needed by any domain to map MSI
+ *
+ * @iommu: iommu handle
+ * @info: msi map info handle
+ *
+ * returns 0 upon success or -ENOMEM
+ */
+static int vfio_compute_msi_map_info(struct vfio_iommu *iommu,
+				 struct vfio_msi_map_info *msi_info)
+{
+	int ret = 0;
+	struct vfio_domain *d;
+	unsigned long bitmap = ULONG_MAX;
+	unsigned int iova_pages = 0;
+
+	msi_info->mapping_required = false;
+
+	mutex_lock(&iommu->lock);
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		bitmap &= d->domain->ops->pgsize_bitmap;
+		ret = vfio_domain_compute_msi_map_info(d, msi_info);
+		if (ret)
+			goto out;
+		if (msi_info->iova_pages > iova_pages)
+			iova_pages = msi_info->iova_pages;
+	}
+out:
+	msi_info->page_size = 1 << __ffs(bitmap);
+	msi_info->iova_pages = iova_pages;
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+#endif
+
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
@@ -1179,6 +1314,20 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		info.flags = VFIO_IOMMU_INFO_PGSIZES;
 
+#if defined(CONFIG_GENERIC_MSI_IRQ_DOMAIN) && defined(CONFIG_IOMMU_DMA_RESERVED)
+		{
+			struct vfio_msi_map_info msi_info;
+			int ret;
+
+			ret = vfio_compute_msi_map_info(iommu, &msi_info);
+			if (ret)
+				return ret;
+
+			if (msi_info.mapping_required)
+				info.flags |= VFIO_IOMMU_INFO_REQUIRE_MSI_MAP;
+			info.msi_iova_pages = msi_info.iova_pages;
+		}
+#endif
 		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
 
 		return copy_to_user((void __user *)arg, &info, minsz);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d5a48e7..863c68a 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -400,7 +400,9 @@ struct vfio_iommu_type1_info {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
+#define VFIO_IOMMU_INFO_REQUIRE_MSI_MAP (1 << 1)/* MSI must be mapped */
 	__u64	iova_pgsizes;		/* Bitmap of supported page sizes */
+	__u32   msi_iova_pages;	/* number of IOVA pages needed to map MSIs */
 };
 
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
-- 
1.9.1
