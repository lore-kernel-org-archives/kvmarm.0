From: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 5/8] vfio: allow reserved msi iova registration
Date: Tue, 19 Jul 2016 13:11:31 +0000
Message-ID: <1468933894-23250-6-git-send-email-eric.auger@redhat.com>
References: <1468933894-23250-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1468933894-23250-1-git-send-email-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, andre.przywara-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, robert.richter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, yehuday-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

The user is allowed to register a reserved MSI IOVA range by using the
DMA MAP API and setting the new flag: VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA.
This region is stored in the vfio_dma rb tree. At that point the iova
range is not mapped to any target address yet. The host kernel will use
those iova when needed, typically when MSIs are allocated.

Signed-off-by: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bharat Bhushan <Bharat.Bhushan-KZfg59tc24xl57MIdRCFDg@public.gmane.org>

---
v9 -> v10
- use VFIO_IOVA_RESERVED_MSI enum value

v7 -> v8:
- use iommu_msi_set_aperture function. There is no notion of
  unregistration anymore since the reserved msi slot remains
  until the container gets closed.

v6 -> v7:
- use iommu_free_reserved_iova_domain
- convey prot attributes downto dma-reserved-iommu iova domain creation
- reserved bindings teardown now performed on iommu domain destruction
- rename VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA into
         VFIO_DMA_MAP_FLAG_RESERVED_MSI_IOVA
- change title
- pass the protection attribute to dma-reserved-iommu API

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
 drivers/vfio/vfio_iommu_type1.c | 77 ++++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h       | 10 +++++-
 2 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 69c775e..14dc9ef 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -442,6 +442,20 @@ static void vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_lock_acct(-unlocked);
 }
 
+static int vfio_set_msi_aperture(struct vfio_iommu *iommu,
+				dma_addr_t iova, size_t size)
+{
+	struct vfio_domain *d;
+	int ret = 0;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		ret = iommu_msi_set_aperture(d->domain, iova, iova + size - 1);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
 static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
 	vfio_unmap_unpin(iommu, dma);
@@ -691,6 +705,63 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_register_msi_range(struct vfio_iommu *iommu,
+				   struct vfio_iommu_type1_dma_map *map)
+{
+	dma_addr_t iova = map->iova;
+	size_t size = map->size;
+	int ret = 0;
+	struct vfio_dma *dma;
+	unsigned long order;
+	uint64_t mask;
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
+	if (vfio_find_dma(iommu, iova, size, VFIO_IOVA_ANY)) {
+		ret =  -EEXIST;
+		goto unlock;
+	}
+
+	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
+	if (!dma) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	dma->iova = iova;
+	dma->size = size;
+	dma->type = VFIO_IOVA_RESERVED_MSI;
+
+	ret = vfio_set_msi_aperture(iommu, iova, size);
+	if (ret)
+		goto free_unlock;
+
+	vfio_link_dma(iommu, dma);
+	goto unlock;
+
+free_unlock:
+	kfree(dma);
+unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static int vfio_bus_type(struct device *dev, void *data)
 {
 	struct bus_type **bus = data;
@@ -1065,7 +1136,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 	} else if (cmd == VFIO_IOMMU_MAP_DMA) {
 		struct vfio_iommu_type1_dma_map map;
 		uint32_t mask = VFIO_DMA_MAP_FLAG_READ |
-				VFIO_DMA_MAP_FLAG_WRITE;
+				VFIO_DMA_MAP_FLAG_WRITE |
+				VFIO_DMA_MAP_FLAG_RESERVED_MSI_IOVA;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
@@ -1075,6 +1147,9 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		if (map.argsz < minsz || map.flags & ~mask)
 			return -EINVAL;
 
+		if (map.flags & VFIO_DMA_MAP_FLAG_RESERVED_MSI_IOVA)
+			return vfio_register_msi_range(iommu, &map);
+
 		return vfio_dma_do_map(iommu, &map);
 
 	} else if (cmd == VFIO_IOMMU_UNMAP_DMA) {
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 255a211..4a9dbc2 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -498,12 +498,19 @@ struct vfio_iommu_type1_info {
  *
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
+ *
+ * In case RESERVED_MSI_IOVA flag is set, the API only aims at registering an
+ * IOVA region that will be used on some platforms to map the host MSI frames.
+ * In that specific case, vaddr is ignored. Once registered, an MSI reserved
+ * IOVA region stays until the container is closed.
  */
 struct vfio_iommu_type1_dma_map {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
+/* reserved iova for MSI vectors*/
+#define VFIO_DMA_MAP_FLAG_RESERVED_MSI_IOVA (1 << 2)
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
@@ -519,7 +526,8 @@ struct vfio_iommu_type1_dma_map {
  * Caller sets argsz.  The actual unmapped size is returned in the size
  * field.  No guarantee is made to the user that arbitrary unmaps of iova
  * or size different from those used in the original mapping call will
- * succeed.
+ * succeed. Once registered, an MSI region cannot be unmapped and stays
+ * until the container is closed.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
-- 
1.9.1
