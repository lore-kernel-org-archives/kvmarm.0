From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 21/22] vfio-pci: Add VFIO_PCI_DMA_FAULT_IRQ_INDEX
Date: Sun, 17 Mar 2019 18:22:31 +0100
Message-ID: <20190317172232.1068-22-eric.auger@redhat.com>
References: <20190317172232.1068-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7776F4A47F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Mar 2019 13:24:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iuf7foYcUrzA for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Mar 2019 13:24:54 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8EED24A477
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Mar 2019 13:24:54 -0400 (EDT)
In-Reply-To: <20190317172232.1068-1-eric.auger@redhat.com>
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
Cc: kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Add a new VFIO_PCI_DMA_FAULT_IRQ_INDEX index. This allows to
set/unset an eventfd that will be triggered when DMA translation
faults are detected at physical level when the nested mode is used.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c       |  3 +++
 drivers/vfio/pci/vfio_pci_intrs.c | 19 +++++++++++++++++++
 include/uapi/linux/vfio.h         |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 8c895ece4750..36b57fe363d7 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -750,6 +750,8 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 			return 1;
 	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
 		return 1;
+	} else if (irq_type == VFIO_PCI_DMA_FAULT_IRQ_INDEX) {
+		return 1;
 	}
 
 	return 0;
@@ -1086,6 +1088,7 @@ static long vfio_pci_ioctl(void *device_data,
 		switch (info.index) {
 		case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
 		case VFIO_PCI_REQ_IRQ_INDEX:
+		case VFIO_PCI_DMA_FAULT_IRQ_INDEX:
 			break;
 		case VFIO_PCI_ERR_IRQ_INDEX:
 			if (pci_is_pcie(vdev->pdev))
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 1c46045b0e7f..28a96117daf3 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -622,6 +622,18 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
 					       count, flags, data);
 }
 
+static int vfio_pci_set_dma_fault_trigger(struct vfio_pci_device *vdev,
+					  unsigned index, unsigned start,
+					  unsigned count, uint32_t flags,
+					  void *data)
+{
+	if (index != VFIO_PCI_DMA_FAULT_IRQ_INDEX || start != 0 || count > 1)
+		return -EINVAL;
+
+	return vfio_pci_set_ctx_trigger_single(&vdev->dma_fault_trigger,
+					       count, flags, data);
+}
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data)
@@ -671,6 +683,13 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 			break;
 		}
 		break;
+	case VFIO_PCI_DMA_FAULT_IRQ_INDEX:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			func = vfio_pci_set_dma_fault_trigger;
+			break;
+		}
+		break;
 	}
 
 	if (!func)
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 40b7aec8fefa..b47f65df5b86 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -555,6 +555,7 @@ enum {
 	VFIO_PCI_MSIX_IRQ_INDEX,
 	VFIO_PCI_ERR_IRQ_INDEX,
 	VFIO_PCI_REQ_IRQ_INDEX,
+	VFIO_PCI_DMA_FAULT_IRQ_INDEX,
 	VFIO_PCI_NUM_IRQS
 };
 
-- 
2.20.1
