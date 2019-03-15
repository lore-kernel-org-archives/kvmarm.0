From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 19/22] vfio-pci: Register an iommu fault handler
Date: Fri, 15 Mar 2019 17:09:03 +0100
Message-ID: <20190315160906.12900-20-eric.auger@redhat.com>
References: <20190315160906.12900-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190315160906.12900-1-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org, vincent.stehle@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch registers a fault handler which records faults in
a circular buffer and then signals an eventfd. This buffer is
exposed within the fault region.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v3 -> v4:
- move iommu_unregister_device_fault_handler to vfio_pci_release
---
 drivers/vfio/pci/vfio_pci.c         | 49 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 2 files changed, 50 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 01b1b4cb8349..cf12204486c3 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -29,6 +29,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
+#include <linux/circ_buf.h>
 
 #include "vfio_pci_private.h"
 
@@ -295,6 +296,46 @@ static const struct vfio_pci_regops vfio_pci_fault_prod_regops = {
 	.add_capability = vfio_pci_fault_prod_add_capability,
 };
 
+int vfio_pci_iommu_dev_fault_handler(struct iommu_fault_event *evt, void *data)
+{
+	struct vfio_pci_device *vdev = (struct vfio_pci_device *) data;
+	struct vfio_region_fault_prod *prod_region =
+		(struct vfio_region_fault_prod *)vdev->fault_pages;
+	struct vfio_region_fault_cons *cons_region =
+		(struct vfio_region_fault_cons *)(vdev->fault_pages + 2 * PAGE_SIZE);
+	struct iommu_fault *new =
+		(struct iommu_fault *)(vdev->fault_pages + prod_region->offset +
+			prod_region->prod * prod_region->entry_size);
+	int prod, cons, size;
+
+	mutex_lock(&vdev->fault_queue_lock);
+
+	if (!vdev->fault_abi)
+		goto unlock;
+
+	prod = prod_region->prod;
+	cons = cons_region->cons;
+	size = prod_region->nb_entries;
+
+	if (CIRC_SPACE(prod, cons, size) < 1)
+		goto unlock;
+
+	*new = evt->fault;
+	prod = (prod + 1) % size;
+	prod_region->prod = prod;
+	mutex_unlock(&vdev->fault_queue_lock);
+
+	mutex_lock(&vdev->igate);
+	if (vdev->dma_fault_trigger)
+		eventfd_signal(vdev->dma_fault_trigger, 1);
+	mutex_unlock(&vdev->igate);
+	return 0;
+
+unlock:
+	mutex_unlock(&vdev->fault_queue_lock);
+	return -EINVAL;
+}
+
 static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
 {
 	struct vfio_region_fault_prod *header;
@@ -327,6 +368,13 @@ static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
 	header = (struct vfio_region_fault_prod *)vdev->fault_pages;
 	header->version = -1;
 	header->offset = PAGE_SIZE;
+
+	ret = iommu_register_device_fault_handler(&vdev->pdev->dev,
+					vfio_pci_iommu_dev_fault_handler,
+					vdev);
+	if (ret)
+		goto out;
+
 	return 0;
 out:
 	kfree(vdev->fault_pages);
@@ -574,6 +622,7 @@ static void vfio_pci_release(void *device_data)
 	if (!(--vdev->refcnt)) {
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
+		iommu_unregister_device_fault_handler(&vdev->pdev->dev);
 	}
 
 	mutex_unlock(&vdev->reflck->lock);
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 8e0a55682d3f..a9276926f008 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -122,6 +122,7 @@ struct vfio_pci_device {
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
+	struct eventfd_ctx	*dma_fault_trigger;
 	struct mutex		fault_queue_lock;
 	int			fault_abi;
 	struct list_head	dummy_resources_list;
-- 
2.20.1
