From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 10/10] vfio: allow the user to register reserved iova range
 for MSI mapping
Date: Tue, 26 Jan 2016 13:12:48 +0000
Message-ID: <1453813968-2024-11-git-send-email-eric.auger@linaro.org>
References: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A29D410EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:08:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5+uY2uqIfVcP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2016 08:08:54 -0500 (EST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12618410D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:08:53 -0500 (EST)
Received: by mail-wm0-f47.google.com with SMTP id r129so103646381wmr.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 05:13:49 -0800 (PST)
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

The user is allowed to register a reserved IOVA range by using the
DMA MAP API and setting the new flag: VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA.
It provides the base address and the size. This region is stored in the
vfio_dma rb tree. At that point the iova range is not mapped to any target
address yet. The host kernel will use those iova when needed, typically
when the VFIO-PCI device allocates its MSI's.

This patch also handles the destruction of the reserved binding RB-tree and
domain's iova_domains.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>

---

- Currently the user is not yet informed about the number of pages to
  provide

RFC v1 -> RFC v2:
- takes into account Alex comments, based on
  [RFC PATCH 1/6] vfio: Add interface for add/del reserved iova region:
- use the existing dma map/unmap ioctl interface with a flag to register
  a reserved IOVA range. A single reserved iova region is allowed.
---
 drivers/vfio/vfio_iommu_type1.c | 98 ++++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h       |  9 ++++
 2 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2f085d3..37c7d78 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -538,10 +538,40 @@ static void vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_lock_acct(-unlocked);
 }
 
+/* vfio_unmap_reserved: unmap and free all reserved binding nodes
+ * for all domains and destroy their iova_domain
+ *
+ * @iommu: iommu handle
+ */
+static void vfio_unmap_reserved(struct vfio_iommu *iommu)
+{
+	struct vfio_domain *d;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		struct rb_node *node;
+
+		while ((node = rb_first(&d->reserved_binding_list))) {
+			struct vfio_reserved_binding *b =
+				rb_entry(node,
+					 struct vfio_reserved_binding, node);
+
+			while (!kref_put(&b->kref,
+				vfio_reserved_binding_release)) {
+			}
+		}
+		d->reserved_binding_list = RB_ROOT;
+
+		put_iova_domain(d->reserved_iova_domain);
+		kfree(d->reserved_iova_domain);
+	}
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
@@ -785,6 +815,68 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_register_reserved_iova_range(struct vfio_iommu *iommu,
+			   struct vfio_iommu_type1_dma_map *map)
+{
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
+	/* we currently only support MSI_RESERVED_IOVA */
+	if (!(map->flags & VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA))
+		return -EINVAL;
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
+	/* check if the iova domain has not been instantiated already*/
+	d = list_first_entry(&iommu->domain_list,
+				  struct vfio_domain, next);
+
+	if (d->reserved_iova_domain || vfio_find_dma(iommu, iova, size)) {
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
+	vfio_link_dma(iommu, dma);
+
+	list_for_each_entry(d, &iommu->domain_list, next)
+		alloc_reserved_iova_domain(d, iova, size, order);
+
+out:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static int vfio_bus_type(struct device *dev, void *data)
 {
 	struct bus_type **bus = data;
@@ -1297,7 +1389,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 	} else if (cmd == VFIO_IOMMU_MAP_DMA) {
 		struct vfio_iommu_type1_dma_map map;
 		uint32_t mask = VFIO_DMA_MAP_FLAG_READ |
-				VFIO_DMA_MAP_FLAG_WRITE;
+				VFIO_DMA_MAP_FLAG_WRITE |
+				VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
@@ -1307,6 +1400,9 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		if (map.argsz < minsz || map.flags & ~mask)
 			return -EINVAL;
 
+		if (map.flags & VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA)
+			return vfio_register_reserved_iova_range(iommu, &map);
+
 		return vfio_dma_do_map(iommu, &map);
 
 	} else if (cmd == VFIO_IOMMU_UNMAP_DMA) {
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 43e183b..982e326 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -411,12 +411,21 @@ struct vfio_iommu_type1_info {
  *
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
+ *
+ * In case MSI_RESERVED_IOVA is set, the API only aims at registering an IOVA
+ * region which will be used on some platforms to map the host MSI frame.
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
-- 
1.9.1
