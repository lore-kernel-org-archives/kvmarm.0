From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v5 14/17] vfio: allow the user to register reserved iova range
 for MSI mapping
Date: Tue,  1 Mar 2016 18:27:54 +0000
Message-ID: <1456856877-4817-15-git-send-email-eric.auger@linaro.org>
References: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40D95411BE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 13:21:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OZH2eR8nL4Rr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2016 13:21:50 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E283941390
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 13:21:49 -0500 (EST)
Received: by mail-wm0-f49.google.com with SMTP id l68so50632939wml.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Mar 2016 10:28:57 -0800 (PST)
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

The user is allowed to [un]register a reserved IOVA range by using the
DMA MAP API and setting the new flag: VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA.
It provides the base address and the size. This region is stored in the
vfio_dma rb tree. At that point the iova range is not mapped to any target
address yet. The host kernel will use those iova when needed, typically
when the VFIO-PCI device allocates its MSIs.

This patch also handles the destruction of the reserved binding RB-tree and
domain's iova_domains.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>

---
v3 -> v4:
- use iommu_alloc/free_reserved_iova_domain exported by dma-reserved-iommu
- protect vfio_register_reserved_iova_range implementation with
  CONFIG_IOMMU_DMA_RESERVED
- handle unregistration by user-space and on vfio_iommu_type1 release

v1 -> v2:
- set returned value according to alloc_reserved_iova_domain result
- free the iova domains in case any error occurs

RFC v1 -> v1:
- takes into account Alex comments, based on
  [RFC PATCH 1/6] vfio: Add interface for add/del reserved iova region:
- use the existing dma map/unmap ioctl interface with a flag to register
  a reserved IOVA range. A single reserved iova region is allowed.
---
 drivers/vfio/vfio_iommu_type1.c | 141 +++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h       |  12 +++-
 2 files changed, 150 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 692e9a2..4e01ebe 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -36,6 +36,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
+#include <linux/dma-reserved-iommu.h>
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
@@ -403,10 +404,22 @@ static void vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_lock_acct(-unlocked);
 }
 
+static void vfio_unmap_reserved(struct vfio_iommu *iommu)
+{
+#ifdef CONFIG_IOMMU_DMA_RESERVED
+	struct vfio_domain *d;
+
+	list_for_each_entry(d, &iommu->domain_list, next)
+		iommu_unmap_reserved(d->domain);
+#endif
+}
+
 static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
 	if (likely(dma->type != VFIO_IOVA_RESERVED))
 		vfio_unmap_unpin(iommu, dma);
+	else
+		vfio_unmap_reserved(iommu);
 	vfio_unlink_dma(iommu, dma);
 	kfree(dma);
 }
@@ -489,7 +502,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	 */
 	if (iommu->v2) {
 		dma = vfio_find_dma(iommu, unmap->iova, 0);
-		if (dma && dma->iova != unmap->iova) {
+		if (dma && (dma->iova != unmap->iova ||
+			   (dma->type == VFIO_IOVA_RESERVED))) {
 			ret = -EINVAL;
 			goto unlock;
 		}
@@ -501,6 +515,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	}
 
 	while ((dma = vfio_find_dma(iommu, unmap->iova, unmap->size))) {
+		if (dma->type == VFIO_IOVA_RESERVED) {
+			ret = -EINVAL;
+			goto unlock;
+		}
 		if (!iommu->v2 && unmap->iova > dma->iova)
 			break;
 		unmapped += dma->size;
@@ -650,6 +668,114 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_register_reserved_iova_range(struct vfio_iommu *iommu,
+			   struct vfio_iommu_type1_dma_map *map)
+{
+#ifdef CONFIG_IOMMU_DMA_RESERVED
+	dma_addr_t iova = map->iova;
+	size_t size = map->size;
+	uint64_t mask;
+	struct vfio_dma *dma;
+	int ret = 0;
+	struct vfio_domain *d;
+	unsigned long order;
+
+	/* Verify that none of our __u64 fields overflow */
+	if (map->size != size || map->iova != iova)
+		return -EINVAL;
+
+	order =  __ffs(vfio_pgsize_bitmap(iommu));
+	mask = ((uint64_t)1 << order) - 1;
+
+	WARN_ON(mask & PAGE_MASK);
+
+	if (!size || (size | iova) & mask)
+		return -EINVAL;
+
+	/* Don't allow IOVA address wrap */
+	if (iova + size - 1 < iova)
+		return -EINVAL;
+
+	mutex_lock(&iommu->lock);
+
+	if (vfio_find_dma(iommu, iova, size)) {
+		ret =  -EEXIST;
+		goto out;
+	}
+
+	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
+	if (!dma) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	dma->iova = iova;
+	dma->size = size;
+	dma->type = VFIO_IOVA_RESERVED;
+
+	list_for_each_entry(d, &iommu->domain_list, next)
+		ret |= iommu_alloc_reserved_iova_domain(d->domain, iova,
+							size, order);
+
+	if (ret) {
+		list_for_each_entry(d, &iommu->domain_list, next)
+			iommu_free_reserved_iova_domain(d->domain);
+		goto out;
+	}
+
+	vfio_link_dma(iommu, dma);
+
+out:
+	mutex_unlock(&iommu->lock);
+	return ret;
+#else /* CONFIG_IOMMU_DMA_RESERVED */
+	return -ENODEV;
+#endif
+}
+
+static void vfio_unregister_reserved_iova_range(struct vfio_iommu *iommu,
+				struct vfio_iommu_type1_dma_unmap *unmap)
+{
+#ifdef CONFIG_IOMMU_DMA_RESERVED
+	dma_addr_t iova = unmap->iova;
+	struct vfio_dma *dma;
+	size_t size = unmap->size;
+	uint64_t mask;
+	unsigned long order;
+
+	/* Verify that none of our __u64 fields overflow */
+	if (unmap->size != size || unmap->iova != iova)
+		return;
+
+	order =  __ffs(vfio_pgsize_bitmap(iommu));
+	mask = ((uint64_t)1 << order) - 1;
+
+	WARN_ON(mask & PAGE_MASK);
+
+	if (!size || (size | iova) & mask)
+		return;
+
+	/* Don't allow IOVA address wrap */
+	if (iova + size - 1 < iova)
+		return;
+
+	mutex_lock(&iommu->lock);
+
+	dma = vfio_find_dma(iommu, iova, size);
+
+	if (!dma || (dma->type != VFIO_IOVA_RESERVED)) {
+		unmap->size = 0;
+		goto out;
+	}
+
+	unmap->size =  dma->size;
+	vfio_remove_dma(iommu, dma);
+
+out:
+	mutex_unlock(&iommu->lock);
+#endif
+}
+
 static int vfio_bus_type(struct device *dev, void *data)
 {
 	struct bus_type **bus = data;
@@ -946,6 +1072,7 @@ static void vfio_iommu_type1_release(void *iommu_data)
 	struct vfio_group *group, *group_tmp;
 
 	vfio_iommu_unmap_unpin_all(iommu);
+	vfio_unmap_reserved(iommu);
 
 	list_for_each_entry_safe(domain, domain_tmp,
 				 &iommu->domain_list, next) {
@@ -1019,7 +1146,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 	} else if (cmd == VFIO_IOMMU_MAP_DMA) {
 		struct vfio_iommu_type1_dma_map map;
 		uint32_t mask = VFIO_DMA_MAP_FLAG_READ |
-				VFIO_DMA_MAP_FLAG_WRITE;
+				VFIO_DMA_MAP_FLAG_WRITE |
+				VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
@@ -1029,6 +1157,9 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		if (map.argsz < minsz || map.flags & ~mask)
 			return -EINVAL;
 
+		if (map.flags & VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA)
+			return vfio_register_reserved_iova_range(iommu, &map);
+
 		return vfio_dma_do_map(iommu, &map);
 
 	} else if (cmd == VFIO_IOMMU_UNMAP_DMA) {
@@ -1043,10 +1174,16 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		if (unmap.argsz < minsz || unmap.flags)
 			return -EINVAL;
 
+		if (unmap.flags & VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA) {
+			vfio_unregister_reserved_iova_range(iommu, &unmap);
+			goto out;
+		}
+
 		ret = vfio_dma_do_unmap(iommu, &unmap);
 		if (ret)
 			return ret;
 
+out:
 		return copy_to_user((void __user *)arg, &unmap, minsz);
 	}
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 7d7a4c6..d5a48e7 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -410,12 +410,21 @@ struct vfio_iommu_type1_info {
  *
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
+ *
+ * In case MSI_RESERVED_IOVA flag is set, the API only aims at registering an
+ * IOVA region which will be used on some platforms to map the host MSI frame.
+ * in that specific case, vaddr and prot are ignored. The requirement for
+ * provisioning such IOVA range can be checked by calling VFIO_IOMMU_GET_INFO
+ * with the VFIO_IOMMU_INFO_REQUIRE_MSI_MAP attribute. A single
+ * MSI_RESERVED_IOVA region can be registered
  */
 struct vfio_iommu_type1_dma_map {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
+/* reserved iova for MSI vectors*/
+#define VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA (1 << 2)
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
@@ -431,7 +440,8 @@ struct vfio_iommu_type1_dma_map {
  * Caller sets argsz.  The actual unmapped size is returned in the size
  * field.  No guarantee is made to the user that arbitrary unmaps of iova
  * or size different from those used in the original mapping call will
- * succeed.
+ * succeed. A Reserved DMA region must be unmapped with MSI_RESERVED_IOVA
+ * flag set.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
-- 
1.9.1
