From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v11 2/8] vfio/type1: vfio_find_dma accepting a type argument
Date: Tue, 19 Jul 2016 13:11:28 +0000
Message-ID: <1468933894-23250-3-git-send-email-eric.auger@redhat.com>
References: <1468933894-23250-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5390F49B1D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 09:05:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wooKy7-tM7Pb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2016 09:05:46 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5022A49B34
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 09:05:46 -0400 (EDT)
In-Reply-To: <1468933894-23250-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, robert.richter@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

In our RB-tree we get prepared to insert slots of different types
(USER and RESERVED). It becomes useful to be able to search for dma
slots of a specific type or any type.

This patch introduces vfio_find_dma_from_node which starts the
search from a given node and stops on the first node that matches
the @start and @size parameters. If this node also matches the
@type parameter, the node is returned else NULL is returned.

At the moment we only have USER SLOTS so the type will always match.

In a separate patch, this function will be enhanced to pursue the
search recursively in case a node with a different type is
encountered.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 53 +++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a9f8b93..cb7267a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -94,25 +94,56 @@ struct vfio_group {
  * into DMA'ble space using the IOMMU
  */
 
-static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
-				      dma_addr_t start, size_t size)
+/**
+ * vfio_find_dma_from_node: looks for a dma slot intersecting a window
+ * from a given rb tree node
+ * @top: top rb tree node where the search starts (including this node)
+ * @start: window start
+ * @size: window size
+ * @type: window type
+ */
+static struct vfio_dma *vfio_find_dma_from_node(struct rb_node *top,
+						dma_addr_t start, size_t size,
+						enum vfio_iova_type type)
 {
-	struct rb_node *node = iommu->dma_list.rb_node;
+	struct rb_node *node = top;
+	struct vfio_dma *dma;
 
 	while (node) {
-		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
-
+		dma = rb_entry(node, struct vfio_dma, node);
 		if (start + size <= dma->iova)
 			node = node->rb_left;
 		else if (start >= dma->iova + dma->size)
 			node = node->rb_right;
 		else
-			return dma;
+			break;
 	}
+	if (!node)
+		return NULL;
+
+	/* a dma slot intersects our window, check the type also matches */
+	if (type == VFIO_IOVA_ANY || dma->type == type)
+		return dma;
 
 	return NULL;
 }
 
+/**
+ * vfio_find_dma: find a dma slot intersecting a given window
+ * @iommu: vfio iommu handle
+ * @start: window base iova
+ * @size: window size
+ * @type: window type
+ */
+static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
+				      dma_addr_t start, size_t size,
+				      enum vfio_iova_type type)
+{
+	struct rb_node *top_node = iommu->dma_list.rb_node;
+
+	return vfio_find_dma_from_node(top_node, start, size, type);
+}
+
 static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
 {
 	struct rb_node **link = &iommu->dma_list.rb_node, *parent = NULL;
@@ -484,19 +515,21 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	 * mappings within the range.
 	 */
 	if (iommu->v2) {
-		dma = vfio_find_dma(iommu, unmap->iova, 0);
+		dma = vfio_find_dma(iommu, unmap->iova, 0, VFIO_IOVA_USER);
 		if (dma && dma->iova != unmap->iova) {
 			ret = -EINVAL;
 			goto unlock;
 		}
-		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
+		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0,
+				    VFIO_IOVA_USER);
 		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
 			ret = -EINVAL;
 			goto unlock;
 		}
 	}
 
-	while ((dma = vfio_find_dma(iommu, unmap->iova, unmap->size))) {
+	while ((dma = vfio_find_dma(iommu, unmap->iova, unmap->size,
+				    VFIO_IOVA_USER))) {
 		if (!iommu->v2 && unmap->iova > dma->iova)
 			break;
 		unmapped += dma->size;
@@ -600,7 +633,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 
 	mutex_lock(&iommu->lock);
 
-	if (vfio_find_dma(iommu, iova, size)) {
+	if (vfio_find_dma(iommu, iova, size, VFIO_IOVA_ANY)) {
 		mutex_unlock(&iommu->lock);
 		return -EEXIST;
 	}
-- 
1.9.1
