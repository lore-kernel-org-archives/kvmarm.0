From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: [RFC 1/2] drivers: vfio: iommu map and unmap device specific memory
 from kernel.
Date: Fri, 24 Jul 2015 14:33:09 +0530
Message-ID: <1437728590-23126-2-git-send-email-pranavkumar@linaro.org>
References: <1437728590-23126-1-git-send-email-pranavkumar@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8E805918A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 04:51:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mFZ9bvYDzUWv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jul 2015 04:51:16 -0400 (EDT)
Received: from mail-pa0-f47.google.com (mail-pa0-f47.google.com
 [209.85.220.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87AD959189
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 04:51:16 -0400 (EDT)
Received: by pacan13 with SMTP id an13so11547569pac.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 02:03:30 -0700 (PDT)
In-Reply-To: <1437728590-23126-1-git-send-email-pranavkumar@linaro.org>
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
Cc: rob.herring@linaro.org, arnd@arndb.de, marc.zyngier@arm.com, patches@apm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, linux-arm-kernel@lists.infradead.org, bhelgaas@google.com, Ankit Jindal <ajindal@apm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In vfio we map and unmap various regions using "VFIO_IOMMU_MAP_DMA" and
"VFIO_IOMMU_UNMAP_DMA" ioctls from userspace.

Some device regions (like MSI in case of PCI), which we do not expose
to the userspace with mmap. These regions might require vfio driver
to create an iommu mapping, as their transactions goes through
an iommu like in case of ARM/ARM64.

As the memory is not mmaped in userspace and might needs to be mapped
with different memory attributes than user memory, we can not use
VFIO_IOMMU_MAP_DMA and VFIO_IOMMU_UNMAP_DMA ioctls.

This patch extends "vfio_iommu_driver_ops" to provide -
device_map() and device_unmap() methods by vfio iommu driver.
These methods can be used by other vfio device drivers like PCI,
to create and destroy simple iommu mappings for regions like MSI/MSI-X.

This patch also implements these methods for vfio iommu type1 driver.

Signed-off-by: Ankit Jindal <ajindal@apm.com>
Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
---
 drivers/vfio/vfio.c             |   29 +++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c |   60 +++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h            |   11 ++++++-
 3 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2fb29df..7897c47 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -143,6 +143,35 @@ void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
 
+int vfio_device_iommu_map(struct vfio_device *device, unsigned long iova,
+			  phys_addr_t paddr, size_t size, int prot)
+{
+	struct vfio_container *container = device->group->container;
+	const struct vfio_iommu_driver_ops *ops = container->iommu_driver->ops;
+	int ret;
+
+	if (!ops->device_map)
+		return -EINVAL;
+
+	ret = ops->device_map(container->iommu_data, iova, paddr, size, prot);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_device_iommu_map);
+
+void vfio_device_iommu_unmap(struct vfio_device *device, unsigned long iova,
+			    size_t size)
+{
+	struct vfio_container *container = device->group->container;
+	const struct vfio_iommu_driver_ops *ops = container->iommu_driver->ops;
+
+	if (!ops->device_unmap)
+		return;
+
+	ops->device_unmap(container->iommu_data, iova, size);
+}
+EXPORT_SYMBOL_GPL(vfio_device_iommu_unmap);
+
 /**
  * Group minor allocation/free - both called with vfio.group_lock held
  */
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 57d8c37..e41995d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1025,6 +1025,64 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 	return -ENOTTY;
 }
 
+static int vfio_iommu_type1_device_map(void *iommu_data, unsigned long iova,
+		phys_addr_t paddr, size_t size,
+		int prot)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_domain *d;
+	int ret;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+
+		if (iommu_iova_to_phys(d->domain, iova))
+			continue;
+
+		ret = iommu_map(d->domain, iova, paddr,
+				size, prot | d->prot);
+
+		if (ret) {
+			if (ret != -EBUSY)
+				goto unwind;
+		}
+
+		cond_resched();
+	}
+
+	mutex_unlock(&iommu->lock);
+
+	return 0;
+
+unwind:
+	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next)
+		iommu_unmap(d->domain, iova, size);
+
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static void vfio_iommu_type1_device_unmap(void *iommu_data, unsigned long iova,
+					 size_t size)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_domain *d;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+
+		if (!iommu_iova_to_phys(d->domain, iova))
+			continue;
+
+		iommu_unmap(d->domain, iova, size);
+		cond_resched();
+	}
+
+	mutex_unlock(&iommu->lock);
+}
+
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.name		= "vfio-iommu-type1",
 	.owner		= THIS_MODULE,
@@ -1033,6 +1091,8 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.ioctl		= vfio_iommu_type1_ioctl,
 	.attach_group	= vfio_iommu_type1_attach_group,
 	.detach_group	= vfio_iommu_type1_detach_group,
+	.device_map	= vfio_iommu_type1_device_map,
+	.device_unmap	= vfio_iommu_type1_device_unmap,
 };
 
 static int __init vfio_iommu_type1_init(void)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ddb4409..ef0d974 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -52,6 +52,12 @@ extern void *vfio_del_group_dev(struct device *dev);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
 extern void *vfio_device_data(struct vfio_device *device);
+extern int vfio_device_iommu_map(struct vfio_device *device,
+					unsigned long iova,
+					phys_addr_t paddr,
+					size_t size, int prot);
+extern void vfio_device_iommu_unmap(struct vfio_device *device,
+				    unsigned long iova, size_t size);
 
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
@@ -72,7 +78,10 @@ struct vfio_iommu_driver_ops {
 					struct iommu_group *group);
 	void		(*detach_group)(void *iommu_data,
 					struct iommu_group *group);
-
+	int		(*device_map)(void *iommu_data, unsigned long iova,
+				      phys_addr_t paddr, size_t size, int prot);
+	void		(*device_unmap)(void *iommu_data, unsigned long iova,
+					size_t size);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
-- 
1.7.9.5
