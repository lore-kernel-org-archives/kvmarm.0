From: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Subject: [RFC PATCH 4/6] vfio: Add interface to iommu-map/unmap MSI pages
Date: Wed, 30 Sep 2015 20:26:27 +0530
Message-ID: <1443624989-24346-4-git-send-email-Bharat.Bhushan@freescale.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D4EF410BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 05:21:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KfUdOa2Tr8px for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2015 05:21:54 -0400 (EDT)
Received: from na01-bn1-obe.outbound.protection.outlook.com
 (mail-bn1bon0148.outbound.protection.outlook.com [157.56.111.148])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E00240FA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 05:21:54 -0400 (EDT)
In-Reply-To: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com
Cc: marc.zyngier@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

For MSI interrupts to work for a pass-through devices we need
to have mapping of msi-pages in iommu. Now on some platforms
(like x86) does this msi-pages mapping happens magically and in these
case they chooses an iova which they somehow know that it will never
overlap with guest memory. But this magic iova selection
may not be always true for all platform (like PowerPC and ARM64).

Also on x86 platform, there is no problem as long as running a x86-guest
on x86-host but there can be issues when running a non-x86 guest on
x86 host or other userspace applications like (I think ODP/DPDK).
As in these cases there can be chances that it overlaps with guest
memory mapping.

This patch add interface to iommu-map and iommu-unmap msi-pages at
reserved iova chosen by userspace.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
---
 drivers/vfio/vfio.c             |  52 +++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c | 111 ++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h            |   9 +++-
 3 files changed, 171 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2fb29df..a817d2d 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -605,6 +605,58 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
+int vfio_device_map_msi(struct vfio_device *device, uint64_t msi_addr,
+			uint32_t size, uint64_t *msi_iova)
+{
+	struct vfio_container *container = device->group->container;
+	struct vfio_iommu_driver *driver;
+	int ret;
+
+	/* Validate address and size */
+	if (!msi_addr || !size || !msi_iova)
+		return -EINVAL;
+
+	down_read(&container->group_lock);
+
+	driver = container->iommu_driver;
+	if (!driver || !driver->ops || !driver->ops->msi_map) {
+		up_read(&container->group_lock);
+		return -EINVAL;
+	}
+
+	ret = driver->ops->msi_map(container->iommu_data,
+				   msi_addr, size, msi_iova);
+
+	up_read(&container->group_lock);
+	return ret;
+}
+
+int vfio_device_unmap_msi(struct vfio_device *device, uint64_t msi_iova,
+			  uint64_t size)
+{
+	struct vfio_container *container = device->group->container;
+	struct vfio_iommu_driver *driver;
+	int ret;
+
+	/* Validate address and size */
+	if (!msi_iova || !size)
+		return -EINVAL;
+
+	down_read(&container->group_lock);
+
+	driver = container->iommu_driver;
+	if (!driver || !driver->ops || !driver->ops->msi_unmap) {
+		up_read(&container->group_lock);
+		return -EINVAL;
+	}
+
+	ret = driver->ops->msi_unmap(container->iommu_data,
+				     msi_iova, size);
+
+	up_read(&container->group_lock);
+	return ret;
+}
+
 /**
  * VFIO driver API
  */
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3315fb6..ab376c2 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1003,12 +1003,34 @@ out_free:
 	return ret;
 }
 
+static void vfio_iommu_unmap_all_reserved_regions(struct vfio_iommu *iommu)
+{
+	struct vfio_resvd_region *region;
+	struct vfio_domain *d;
+
+	list_for_each_entry(region, &iommu->reserved_iova_list, next) {
+		list_for_each_entry(d, &iommu->domain_list, next) {
+			if (!region->map_paddr)
+				continue;
+
+			if (!iommu_iova_to_phys(d->domain, region->iova))
+				continue;
+
+			iommu_unmap(d->domain, region->iova, PAGE_SIZE);
+			region->map_paddr = 0;
+			cond_resched();
+		}
+	}
+}
+
 static void vfio_iommu_unmap_unpin_all(struct vfio_iommu *iommu)
 {
 	struct rb_node *node;
 
 	while ((node = rb_first(&iommu->dma_list)))
 		vfio_remove_dma(iommu, rb_entry(node, struct vfio_dma, node));
+
+	vfio_iommu_unmap_all_reserved_regions(iommu);
 }
 
 static void vfio_iommu_type1_detach_group(void *iommu_data,
@@ -1048,6 +1070,93 @@ done:
 	mutex_unlock(&iommu->lock);
 }
 
+static int vfio_iommu_type1_msi_map(void *iommu_data, uint64_t msi_addr,
+				    uint64_t size, uint64_t *msi_iova)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_resvd_region *region;
+	int ret;
+
+	mutex_lock(&iommu->lock);
+
+	/* Do not try ceate iommu-mapping if msi reconfig not allowed */
+	if (!iommu->allow_msi_reconfig) {
+		mutex_unlock(&iommu->lock);
+		return 0;
+	}
+
+	/* Check if there is already region mapping the msi page */
+	list_for_each_entry(region, &iommu->reserved_iova_list, next) {
+		if (region->map_paddr == msi_addr) {
+			*msi_iova = region->iova;
+			region->refcount++;
+			mutex_unlock(&iommu->lock);
+			return 0;
+		}
+	}
+
+	/* Get a unmapped reserved region */
+	list_for_each_entry(region, &iommu->reserved_iova_list, next) {
+		if (!region->map_paddr)
+			break;
+	}
+
+	if (region == NULL) {
+		mutex_unlock(&iommu->lock);
+		return -ENODEV;
+	}
+
+	ret = vfio_iommu_map(iommu, region->iova, msi_addr >> PAGE_SHIFT,
+			     size >> PAGE_SHIFT, region->prot);
+	if (ret) {
+		mutex_unlock(&iommu->lock);
+		return ret;
+	}
+
+	region->map_paddr = msi_addr;
+	*msi_iova = region->iova;
+	region->refcount++;
+
+	mutex_unlock(&iommu->lock);
+
+	return 0;
+}
+
+static int vfio_iommu_type1_msi_unmap(void *iommu_data, uint64_t iova,
+				      uint64_t size)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_resvd_region *region;
+	struct vfio_domain *d;
+
+	mutex_lock(&iommu->lock);
+
+	/* find the region mapping the msi page */
+	list_for_each_entry(region, &iommu->reserved_iova_list, next)
+		if (region->iova == iova)
+			break;
+
+	if (region == NULL || region->refcount <= 0) {
+		mutex_unlock(&iommu->lock);
+		return -EINVAL;
+	}
+
+	region->refcount--;
+	if (!region->refcount) {
+		list_for_each_entry(d, &iommu->domain_list, next) {
+			if (!iommu_iova_to_phys(d->domain, iova))
+				continue;
+
+			iommu_unmap(d->domain, iova, size);
+			cond_resched();
+		}
+	}
+	region->map_paddr = 0;
+
+	mutex_unlock(&iommu->lock);
+	return 0;
+}
+
 static void *vfio_iommu_type1_open(unsigned long arg)
 {
 	struct vfio_iommu *iommu;
@@ -1264,6 +1373,8 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.ioctl		= vfio_iommu_type1_ioctl,
 	.attach_group	= vfio_iommu_type1_attach_group,
 	.detach_group	= vfio_iommu_type1_detach_group,
+	.msi_map	= vfio_iommu_type1_msi_map,
+	.msi_unmap	= vfio_iommu_type1_msi_unmap,
 };
 
 static int __init vfio_iommu_type1_init(void)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ddb4409..b91085d 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -52,6 +52,10 @@ extern void *vfio_del_group_dev(struct device *dev);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
 extern void *vfio_device_data(struct vfio_device *device);
+extern int vfio_device_map_msi(struct vfio_device *device, uint64_t msi_addr,
+			       uint32_t size, uint64_t *msi_iova);
+int vfio_device_unmap_msi(struct vfio_device *device, uint64_t msi_iova,
+			  uint64_t size);
 
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
@@ -72,7 +76,10 @@ struct vfio_iommu_driver_ops {
 					struct iommu_group *group);
 	void		(*detach_group)(void *iommu_data,
 					struct iommu_group *group);
-
+	int		(*msi_map)(void *iommu_data, uint64_t msi_addr,
+				   uint64_t size, uint64_t *msi_iova);
+	int		(*msi_unmap)(void *iommu_data, uint64_t msi_iova,
+				     uint64_t size);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
-- 
1.9.3
