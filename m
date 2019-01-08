From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v3 19/21] vfio-pci: Register an iommu fault handler
Date: Tue,  8 Jan 2019 11:26:31 +0100
Message-ID: <20190108102633.17482-20-eric.auger@redhat.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 360AD4A442
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jan 2019 05:28:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z67+AN-pG3US for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jan 2019 05:28:58 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 445B64A413
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jan 2019 05:28:58 -0500 (EST)
In-Reply-To: <20190108102633.17482-1-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, kevin.tian@intel.com, ashok.raj@intel.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch registers a fault handler which records faults in
a circular buffer and then signals an eventfd. This buffer is
exposed within the fault region.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         | 44 ++++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 2ba181ab2edd..f9e2c8292e60 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -29,6 +29,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
+#include <linux/circ_buf.h>
 
 #include "vfio_pci_private.h"
 
@@ -1296,6 +1297,44 @@ static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
 	.release	= vfio_pci_dma_fault_release,
 };
 
+int vfio_pci_iommu_dev_fault_handler(struct iommu_fault_event *evt, void *data)
+{
+	struct vfio_pci_device *vdev = (struct vfio_pci_device *) data;
+	int prod, cons, size;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vdev->fault_queue_lock, flags);
+	prod = vdev->fault_region->header.prod;
+	cons = vdev->fault_region->header.cons;
+	size = vdev->fault_region->header.size;
+
+	if (cons > VFIO_FAULT_QUEUE_SIZE - 1)
+		goto unlock;
+	if (prod > VFIO_FAULT_QUEUE_SIZE - 1)
+		goto unlock;
+	if (size != VFIO_FAULT_QUEUE_SIZE)
+		goto unlock;
+	if (vdev->fault_region->header.reserved)
+		goto unlock;
+	if (CIRC_SPACE(prod, cons, size) < 1)
+		goto unlock;
+
+	vdev->fault_region->queue[prod] = evt->fault;
+	prod = (prod + 1) % size;
+	vdev->fault_region->header.prod = prod;
+	spin_unlock_irqrestore(&vdev->fault_queue_lock, flags);
+
+	mutex_lock(&vdev->igate);
+	if (vdev->dma_fault_trigger)
+		eventfd_signal(vdev->dma_fault_trigger, 1);
+	mutex_unlock(&vdev->igate);
+	return 0;
+
+unlock:
+	spin_unlock_irqrestore(&vdev->fault_queue_lock, flags);
+	return -EINVAL;
+}
+
 static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
 {
 	u32 flags = VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE |
@@ -1322,7 +1361,9 @@ static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
 	vdev->fault_region->header.cons = 0;
 	vdev->fault_region->header.reserved = 0;
 	vdev->fault_region->header.size = VFIO_FAULT_QUEUE_SIZE;
-	return 0;
+	return iommu_register_device_fault_handler(&vdev->pdev->dev,
+					vfio_pci_iommu_dev_fault_handler,
+					vdev);
 }
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -1414,6 +1455,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
 	kfree(vdev->region);
+	iommu_unregister_device_fault_handler(&pdev->dev);
 	kfree(vdev->fault_region);
 	mutex_destroy(&vdev->ioeventfds_lock);
 	kfree(vdev);
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 38b5d1764a26..5936802cbbd0 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -120,6 +120,7 @@ struct vfio_pci_device {
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
+	struct eventfd_ctx	*dma_fault_trigger;
 	spinlock_t              fault_queue_lock;
 	struct vfio_fault_region *fault_region;
 	struct list_head	dummy_resources_list;
-- 
2.17.2
