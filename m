From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: [RFC 2/2] drivers: vfio: pci: Add virtual MSI doorbell support.
Date: Fri, 24 Jul 2015 14:33:10 +0530
Message-ID: <1437728590-23126-3-git-send-email-pranavkumar@linaro.org>
References: <1437728590-23126-1-git-send-email-pranavkumar@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437728590-23126-1-git-send-email-pranavkumar@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, will.deacon@arm.com, bhelgaas@google.com, arnd@arndb.de, rob.herring@linaro.org, eric.auger@linaro.org, patches@apm.com, Pranavkumar Sawargaonkar <pranavkumar@linaro.org>, Ankit Jindal <ajindal@apm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In ARM/ARM64 MSI transactions goes through iommu/smmu.
This means there has to be an iommu mapping created for MSI addresses.

This patch adds a new ioctl "VFIO_DEVICE_PCI_MSI_VIRT_DOORBELL".

Userspace can call this ioctl to do following things:
1. Create a virtual doorbell mapping between
MSI IOVA term as a "virtual msi doorbell" (known by the userspace) and
MSI PA (known by the kernel).
2. Set MSI/MSI-X vetcor with a virtual doorbell address instead of PA.

Signed-off-by: Ankit Jindal <ajindal@apm.com>
Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
---
 drivers/vfio/pci/vfio_pci.c         |   32 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_intrs.c   |   64 +++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |    3 ++
 include/uapi/linux/vfio.h           |   19 +++++++++++
 4 files changed, 118 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 964ad57..9c92707 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -784,6 +784,38 @@ hot_reset_release:
 
 		kfree(groups);
 		return ret;
+	} else if (cmd == VFIO_DEVICE_PCI_MSI_VIRT_DOORBELL) {
+		struct vfio_pci_msi_virt_doorbell hdr;
+		u64 *data = NULL;
+		int ret = 0;
+		size_t size = sizeof(uint64_t);
+
+		minsz = offsetofend(struct vfio_pci_msi_virt_doorbell, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (hdr.argsz < minsz)
+			return -EINVAL;
+
+		if (hdr.argsz - minsz < hdr.count * size)
+			return -EINVAL;
+
+		data = memdup_user((void __user *)(arg + minsz),
+				hdr.count * size);
+		if (IS_ERR(data))
+			return PTR_ERR(data);
+
+		mutex_lock(&vdev->igate);
+
+		ret = vfio_pci_msi_virt_doorbell(vdev, hdr.flags,
+				hdr.start, hdr.count, data);
+
+		mutex_unlock(&vdev->igate);
+
+		kfree(data);
+
+		return ret;
 	}
 
 	return -ENOTTY;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 1f577b4..22a25b8 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/eventfd.h>
+#include <linux/irq.h>
 #include <linux/msi.h>
 #include <linux/pci.h>
 #include <linux/file.h>
@@ -352,8 +353,10 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 		pci_write_msi_msg(irq, &msg);
 	}
 
+
 	ret = request_irq(irq, vfio_msihandler, 0,
 			  vdev->ctx[vector].name, trigger);
+
 	if (ret) {
 		kfree(vdev->ctx[vector].name);
 		eventfd_ctx_put(trigger);
@@ -673,3 +676,64 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 
 	return func(vdev, index, start, count, flags, data);
 }
+
+int vfio_pci_msi_virt_doorbell(struct vfio_pci_device *vdev, uint32_t flags,
+			    unsigned start, unsigned count,
+			    void *data)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int irq;
+	bool msix = flags & VFIO_PCI_IS_MSIX;
+	struct msi_msg msg;
+	struct irq_data *d;
+	unsigned long msi_paddr, msi_iova;
+	struct vfio_device *device;
+	int ret;
+	int i, j;
+
+	for (i = 0, j = start; i < count && !ret; i++, j++) {
+
+		device = vfio_device_get_from_dev(&pdev->dev);
+		irq = msix ? vdev->msix[j].vector :
+					pdev->irq + j;
+
+		if (flags & VFIO_PCI_MSI_SET_DOORBELL) {
+			/* Get the MSI message to extract Physical Address */
+			d = irq_get_irq_data(irq);
+			irq_chip_compose_msi_msg(d, &msg);
+			msi_paddr = (msg.address_hi << 31) | msg.address_lo;
+		} else {
+			/*
+			 * Restore the cached value of the message prior
+			 * to the virtual doorbell setting.
+			 */
+			get_cached_msi_msg(irq, &msg);
+		}
+
+		/* MSI IPA/GPA i.e. virtual doorbell address */
+		msi_iova = (unsigned long) ((unsigned long *) data)[i];
+
+		if (flags & VFIO_PCI_MSI_SET_DOORBELL) {
+			ret = vfio_device_iommu_map(device,
+						    (msi_iova & PAGE_MASK),
+						    (msi_paddr & PAGE_MASK),
+						    PAGE_SIZE,
+						    IOMMU_READ | IOMMU_WRITE |
+						    IOMMU_CACHE);
+
+			/* Fill MSI GPA/IPA as a new MSI doorbell address. */
+			msg.address_hi = msi_iova << 31;
+			msg.address_lo = msi_iova & 0xFFFFFFFF;
+		} else if (flags & VFIO_PCI_MSI_CLEAR_DOORBELL) {
+			vfio_device_iommu_unmap(device, (msi_iova & PAGE_MASK),
+						PAGE_SIZE);
+		} else {
+			return -EINVAL;
+		}
+
+		pci_write_msi_msg(irq, &msg);
+	}
+
+	return 0;
+}
+
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index ae0e1b4..ec76e45 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -73,6 +73,9 @@ extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
 extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev,
 				   uint32_t flags, unsigned index,
 				   unsigned start, unsigned count, void *data);
+extern int vfio_pci_msi_virt_doorbell(struct vfio_pci_device *vdev,
+				   uint32_t flags, unsigned start,
+				   unsigned count, void *data);
 
 extern ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev,
 				  char __user *buf, size_t count,
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9fd7b5d..12384f5 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -379,6 +379,25 @@ struct vfio_pci_hot_reset {
 
 #define VFIO_DEVICE_PCI_HOT_RESET	_IO(VFIO_TYPE, VFIO_BASE + 13)
 
+/**
+ * VFIO_DEVICE_PCI_MSI_VIRT_DOORBELL - _IOW(VFIO_TYPE, VFIO_BASE + 14,
+ *					   struct vfio_pci_msi_virt_doorbell)
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_pci_msi_virt_doorbell {
+	__u32   argsz;
+	__u32   flags;
+#define VFIO_PCI_MSI_CLEAR_DOORBELL	(1 << 0) /* Remove virtual doorbell */
+#define VFIO_PCI_MSI_SET_DOORBELL	(1 << 1) /* Set virtual doorbell */
+#define VFIO_PCI_IS_MSIX		(1 << 2) /* Is MSI-X ? */
+	__u32	start;
+	__u32	count;
+	__u64	data[];
+};
+
+#define VFIO_DEVICE_PCI_MSI_VIRT_DOORBELL       _IO(VFIO_TYPE, VFIO_BASE + 14)
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
1.7.9.5

