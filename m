From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: [PATCH v5 4/4] vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC
	flag
Date: Wed,  4 Mar 2015 17:07:54 +0100
Message-ID: <1425485274-5709-5-git-send-email-b.reynal@virtualopensystems.com>
References: <1425485274-5709-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1425485274-5709-1-git-send-email-b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
Cc: "open list:VFIO DRIVER" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>

Some IOMMU drivers, such as the ARM SMMU driver, make available the
IOMMU_NOEXEC flag to set the page tables for a device as XN (execute never).
This affects devices such as the ARM PL330 DMA Controller, which respects
this flag and will refuse to fetch DMA instructions from memory where the
XN flag has been set.

The flag can be used only if all IOMMU domains behind the container support
the IOMMU_NOEXEC flag. Also, if any mappings are created with the flag, any
new domains with devices will have to support it as well.

Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Signed-off-by: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
---
 drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a5847e8..ec313e5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -591,6 +591,12 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (!prot || !size || (size | iova | vaddr) & mask)
 		return -EINVAL;
 
+	if (map->flags & VFIO_DMA_MAP_FLAG_NOEXEC) {
+		if (!vfio_domains_have_iommu_cap(iommu, IOMMU_CAP_NOEXEC))
+			return -EINVAL;
+		prot |= IOMMU_NOEXEC;
+	}
+
 	/* Don't allow IOVA or virtual address wrap */
 	if (iova + size - 1 < iova || vaddr + size - 1 < vaddr)
 		return -EINVAL;
@@ -672,11 +678,20 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 
 	for (; n; n = rb_next(n)) {
 		struct vfio_dma *dma;
+		const struct iommu_ops *ops = domain->domain->ops;
 		dma_addr_t iova;
 
 		dma = rb_entry(n, struct vfio_dma, node);
 		iova = dma->iova;
 
+		/*
+		 * if any of the mappings to be replayed has the NOEXEC flag
+		 * set, then the new iommu domain must support it
+		 */
+		if ((dma->prot & IOMMU_NOEXEC) &&
+				!(ops->capable(IOMMU_CAP_NOEXEC)))
+			return -EINVAL;
+
 		while (iova < dma->iova + dma->size) {
 			phys_addr_t phys = iommu_iova_to_phys(d->domain, iova);
 			size_t size;
@@ -969,6 +984,11 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 				return 0;
 			return vfio_domains_have_iommu_cap(iommu,
 						  IOMMU_CAP_CACHE_COHERENCY);
+		case VFIO_DMA_NOEXEC_IOMMU:
+			if (!iommu)
+				return 0;
+			return vfio_domains_have_iommu_cap(iommu,
+							   IOMMU_CAP_NOEXEC);
 		default:
 			return 0;
 		}
@@ -992,7 +1012,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 	} else if (cmd == VFIO_IOMMU_MAP_DMA) {
 		struct vfio_iommu_type1_dma_map map;
 		uint32_t mask = VFIO_DMA_MAP_FLAG_READ |
-				VFIO_DMA_MAP_FLAG_WRITE;
+				VFIO_DMA_MAP_FLAG_WRITE |
+				VFIO_DMA_MAP_FLAG_NOEXEC;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
-- 
2.3.1
