From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 3/3] vfio: Introduce generic MSI mapping operations
Date: Tue, 24 Nov 2015 10:48:21 +0300
Message-ID: <640ca7b8c83439adde16dcb32c32394d67e408f4.1448350806.git.p.fedin@samsung.com>
References: <cover.1448350806.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF98349721
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 02:47:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id loNeyiGIbGE8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 02:47:50 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 691AF497E0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 02:47:49 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYB00BCG718KV30@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 24 Nov 2015 07:48:44 +0000 (GMT)
In-reply-to: <cover.1448350806.git.p.fedin@samsung.com>
In-reply-to: <cover.1448350806.git.p.fedin@samsung.com>
References: <cover.1448350806.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Manish Jaggi <mjaggi@caviumnetworks.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
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
 drivers/vfio/vfio.c               | 112 ++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h              |   2 +
 3 files changed, 125 insertions(+)

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
index de632da..09de246 100644
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
@@ -882,6 +893,105 @@ void *vfio_device_data(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_device_data);
 
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
 /* Given a referenced group, check if it contains the device */
 static bool vfio_dev_present(struct vfio_group *group, struct device *dev)
 {
@@ -1170,6 +1280,8 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
 
 	INIT_LIST_HEAD(&container->group_list);
 	init_rwsem(&container->group_lock);
+	INIT_LIST_HEAD(&container->msi_list);
+	mutex_init(&container->msi_lock);
 	kref_init(&container->kref);
 
 	filep->private_data = container;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 061038a..faa3dbc 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -93,6 +93,8 @@ extern void vfio_group_put_external_user(struct vfio_group *group);
 extern int vfio_external_user_iommu_id(struct vfio_group *group);
 extern long vfio_external_check_extension(struct vfio_group *group,
 					  unsigned long arg);
+int vfio_device_map_msi(struct device *dev);
+void vfio_device_unmap_msi(struct device *dev);
 
 struct pci_dev;
 #ifdef CONFIG_EEH
-- 
2.4.4
