From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v2 3/3] vfio: Introduce generic MSI mapping operations
Date: Tue, 24 Nov 2015 16:50:56 +0300
Message-ID: <fe012a8253bf89e2648594b4be3826c2aa3db233.1448372839.git.p.fedin@samsung.com>
References: <cover.1448372839.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1448372839.git.p.fedin@samsung.com>
In-reply-to: <cover.1448372839.git.p.fedin@samsung.com>
References: <cover.1448372839.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Alex Williamson <alex.williamson@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Manish Jaggi <mjaggi@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

These operations are used in order to map and unmap MSI translation
registers for the device, allowing it to send MSIs to the host while being
mapped via IOMMU.

Usage of MSI controllers is tracked on a per-device basis using reference
counting. An MSI controller remains mapped as long as there's at least one
device referring to it using MSI.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c |  11 ++++
 drivers/vfio/vfio.c               | 116 ++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h              |  13 +++++
 3 files changed, 140 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 3b3ba15..3c8be59 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -259,12 +259,19 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 	if (!vdev->ctx)
 		return -ENOMEM;
 
+	ret = vfio_device_map_msi(&pdev->dev);
+	if (ret) {
+		kfree(vdev->ctx);
+		return ret;
+	}
+
 	if (msix) {
 		int i;
 
 		vdev->msix = kzalloc(nvec * sizeof(struct msix_entry),
 				     GFP_KERNEL);
 		if (!vdev->msix) {
+			vfio_device_unmap_msi(&pdev->dev);
 			kfree(vdev->ctx);
 			return -ENOMEM;
 		}
@@ -277,6 +284,7 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 			if (ret > 0)
 				pci_disable_msix(pdev);
 			kfree(vdev->msix);
+			vfio_device_unmap_msi(&pdev->dev);
 			kfree(vdev->ctx);
 			return ret;
 		}
@@ -285,6 +293,7 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 		if (ret < nvec) {
 			if (ret > 0)
 				pci_disable_msi(pdev);
+			vfio_device_unmap_msi(&pdev->dev);
 			kfree(vdev->ctx);
 			return ret;
 		}
@@ -413,6 +422,8 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 	} else
 		pci_disable_msi(pdev);
 
+	vfio_device_unmap_msi(&pdev->dev);
+
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vdev->num_ctx = 0;
 	kfree(vdev->ctx);
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index de632da..37d99f5 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -21,9 +21,11 @@
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/iommu.h>
+#include <linux/irqdomain.h>
 #include <linux/list.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
+#include <linux/msi.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/rwsem.h>
@@ -63,6 +65,8 @@ struct vfio_container {
 	struct vfio_iommu_driver	*iommu_driver;
 	void				*iommu_data;
 	bool				noiommu;
+	struct list_head		msi_list;
+	struct mutex			msi_lock;
 };
 
 struct vfio_unbound_dev {
@@ -97,6 +101,13 @@ struct vfio_device {
 	void				*device_data;
 };
 
+struct vfio_msi {
+	struct kref			kref;
+	struct list_head		msi_next;
+	struct vfio_container		*container;
+	struct irq_domain		*domain;
+};
+
 #ifdef CONFIG_VFIO_NOIOMMU
 static bool noiommu __read_mostly;
 module_param_named(enable_unsafe_noiommu_support,
@@ -882,6 +893,109 @@ void *vfio_device_data(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_device_data);
 
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+
+int vfio_device_map_msi(struct device *dev)
+{
+	struct irq_domain *msi_domain = dev_get_msi_domain(dev);
+	struct msi_domain_info *info;
+	struct vfio_device *device;
+	struct vfio_container *container;
+	struct vfio_msi *vmsi;
+	int ret;
+
+	if (!msi_domain)
+		return 0;
+	info = msi_domain->host_data;
+	if (!info->ops->vfio_map)
+		return 0;
+
+	device = dev_get_drvdata(dev);
+	container = device->group->container;
+
+	if (!container->iommu_driver->ops->map)
+		return -EINVAL;
+
+	mutex_lock(&container->msi_lock);
+
+	list_for_each_entry(vmsi, &container->msi_list, msi_next) {
+		if (vmsi->domain == msi_domain) {
+			kref_get(&vmsi->kref);
+			mutex_unlock(&container->msi_lock);
+			return 0;
+		}
+	}
+
+	vmsi = kmalloc(sizeof(*vmsi), GFP_KERNEL);
+	if (!vmsi) {
+		mutex_unlock(&container->msi_lock);
+		return -ENOMEM;
+	}
+
+	ret = info->ops->vfio_map(msi_domain, container->iommu_driver->ops,
+				  container->iommu_data);
+	if (ret) {
+		mutex_unlock(&container->msi_lock);
+		kfree(vmsi);
+		return ret;
+	}
+
+	kref_init(&vmsi->kref);
+	vmsi->container = container;
+	vmsi->domain = msi_domain;
+	list_add(&vmsi->msi_next, &container->msi_list);
+
+	mutex_unlock(&container->msi_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(vfio_device_map_msi);
+
+static void msi_release(struct kref *kref)
+{
+	struct vfio_msi *vmsi = container_of(kref, struct vfio_msi, kref);
+	struct vfio_container *container = vmsi->container;
+	struct msi_domain_info *info = vmsi->domain->host_data;
+
+	info->ops->vfio_unmap(vmsi->domain, container->iommu_driver->ops,
+			      container->iommu_data);
+
+	list_del(&vmsi->msi_next);
+	kfree(vmsi);
+}
+
+void vfio_device_unmap_msi(struct device *dev)
+{
+	struct irq_domain *msi_domain = dev_get_msi_domain(dev);
+	struct msi_domain_info *info;
+	struct vfio_device *device;
+	struct vfio_container *container;
+	struct vfio_msi *vmsi;
+
+	if (!msi_domain)
+		return;
+	info = msi_domain->host_data;
+	if (!info->ops->vfio_unmap)
+		return;
+
+	device = dev_get_drvdata(dev);
+	container = device->group->container;
+
+	mutex_lock(&container->msi_lock);
+
+	list_for_each_entry(vmsi, &container->msi_list, msi_next) {
+		if (vmsi->domain == msi_domain) {
+			kref_put(&vmsi->kref, msi_release);
+			break;
+		}
+	}
+
+	mutex_unlock(&container->msi_lock);
+}
+EXPORT_SYMBOL(vfio_device_unmap_msi);
+
+#endif
+
 /* Given a referenced group, check if it contains the device */
 static bool vfio_dev_present(struct vfio_group *group, struct device *dev)
 {
@@ -1170,6 +1284,8 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
 
 	INIT_LIST_HEAD(&container->group_list);
 	init_rwsem(&container->group_lock);
+	INIT_LIST_HEAD(&container->msi_list);
+	mutex_init(&container->msi_lock);
 	kref_init(&container->kref);
 
 	filep->private_data = container;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 061038a..7b87b02 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -93,6 +93,19 @@ extern void vfio_group_put_external_user(struct vfio_group *group);
 extern int vfio_external_user_iommu_id(struct vfio_group *group);
 extern long vfio_external_check_extension(struct vfio_group *group,
 					  unsigned long arg);
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+int vfio_device_map_msi(struct device *dev);
+void vfio_device_unmap_msi(struct device *dev);
+#else
+static inline int vfio_device_map_msi(struct device *dev)
+{
+	return 0;
+}
+
+static inline void vfio_device_unmap_msi(struct device *dev)
+{
+}
+#endif
 
 struct pci_dev;
 #ifdef CONFIG_EEH
-- 
2.4.4

