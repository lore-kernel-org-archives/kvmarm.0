From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v6 2/5] vfio: allow the user to register reserved iova range
	for MSI mapping
Date: Mon,  4 Apr 2016 08:30:08 +0000
Message-ID: <1459758611-2972-3-git-send-email-eric.auger@linaro.org>
References: <1459758611-2972-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1459758611-2972-1-git-send-email-eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger-qxv4g6HH51o@public.gmane.org, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: julien.grall-5wv7dgnIgG8@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

The user is allowed to [un]register a reserved IOVA range by using the
DMA MAP API and setting the new flag: VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA.
It provides the base address and the size. This region is stored in the
vfio_dma rb tree. At that point the iova range is not mapped to any target
address yet. The host kernel will use those iova when needed, typically
when the VFIO-PCI device allocates its MSIs.

This patch also handles the destruction of the reserved binding RB-tree and
domain's iova_domains.

Signed-off-by: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Bharat Bhushan <Bharat.Bhushan-KZfg59tc24xl57MIdRCFDg@public.gmane.org>

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

Conflicts:
	drivers/vfio/vfio_iommu_type1.c
---
 drivers/vfio/vfio_iommu_type1.c | 141 +++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h       |  12 +++-
 2 files changed, 150 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c9ddbde..4497b20 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -36,6 +36,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
+#include <linux/dma-reserved-iommu.h>
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>"
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
@@ -1020,7 +1147,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 	} else if (cmd == VFIO_IOMMU_MAP_DMA) {
 		struct vfio_iommu_type1_dma_map map;
 		uint32_t mask = VFIO_DMA_MAP_FLAG_READ |
-				VFIO_DMA_MAP_FLAG_WRITE;
+				VFIO_DMA_MAP_FLAG_WRITE |
+				VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
@@ -1030,6 +1158,9 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		if (map.argsz < minsz || map.flags & ~mask)
 			return -EINVAL;
 
+		if (map.flags & VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA)
+			return vfio_register_reserved_iova_range(iommu, &map);
+
 		return vfio_dma_do_map(iommu, &map);
 
 	} else if (cmd == VFIO_IOMMU_UNMAP_DMA) {
@@ -1044,10 +1175,16 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
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
 		return copy_to_user((void __user *)arg, &unmap, minsz) ?
 			-EFAULT : 0;
 	}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 255a211..a49be8a 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -498,12 +498,21 @@ struct vfio_iommu_type1_info {
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
@@ -519,7 +528,8 @@ struct vfio_iommu_type1_dma_map {
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
