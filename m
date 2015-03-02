From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: [PATCH v14 07/20] vfio/platform: return info for device memory mapped
	IO regions
Date: Mon,  2 Mar 2015 17:59:47 +0100
Message-ID: <1425315600-29761-8-git-send-email-b.reynal@virtualopensystems.com>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1425315600-29761-1-git-send-email-b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
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
Cc: "open list:VFIO DRIVER" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>

This patch enables the IOCTLs VFIO_DEVICE_GET_REGION_INFO ioctl call,
which allows the user to learn about the available MMIO resources of
a device.

Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Signed-off-by: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
---
 drivers/vfio/platform/vfio_platform_common.c  | 106 +++++++++++++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |  22 ++++++
 2 files changed, 124 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index c2f853a..47f6309 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -23,17 +23,97 @@
 
 #include "vfio_platform_private.h"
 
+static DEFINE_MUTEX(driver_lock);
+
+static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
+{
+	int cnt = 0, i;
+
+	while (vdev->get_resource(vdev, cnt))
+		cnt++;
+
+	vdev->regions = kcalloc(cnt, sizeof(struct vfio_platform_region),
+				GFP_KERNEL);
+	if (!vdev->regions)
+		return -ENOMEM;
+
+	for (i = 0; i < cnt;  i++) {
+		struct resource *res =
+			vdev->get_resource(vdev, i);
+
+		if (!res)
+			goto err;
+
+		vdev->regions[i].addr = res->start;
+		vdev->regions[i].size = resource_size(res);
+		vdev->regions[i].flags = 0;
+
+		switch (resource_type(res)) {
+		case IORESOURCE_MEM:
+			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_MMIO;
+			break;
+		case IORESOURCE_IO:
+			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_PIO;
+			break;
+		default:
+			goto err;
+		}
+	}
+
+	vdev->num_regions = cnt;
+
+	return 0;
+err:
+	kfree(vdev->regions);
+	return -EINVAL;
+}
+
+static void vfio_platform_regions_cleanup(struct vfio_platform_device *vdev)
+{
+	vdev->num_regions = 0;
+	kfree(vdev->regions);
+}
+
 static void vfio_platform_release(void *device_data)
 {
+	struct vfio_platform_device *vdev = device_data;
+
+	mutex_lock(&driver_lock);
+
+	if (!(--vdev->refcnt)) {
+		vfio_platform_regions_cleanup(vdev);
+	}
+
+	mutex_unlock(&driver_lock);
+
 	module_put(THIS_MODULE);
 }
 
 static int vfio_platform_open(void *device_data)
 {
+	struct vfio_platform_device *vdev = device_data;
+	int ret;
+
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
+	mutex_lock(&driver_lock);
+
+	if (!vdev->refcnt) {
+		ret = vfio_platform_regions_init(vdev);
+		if (ret)
+			goto err_reg;
+	}
+
+	vdev->refcnt++;
+
+	mutex_unlock(&driver_lock);
 	return 0;
+
+err_reg:
+	mutex_unlock(&driver_lock);
+	module_put(THIS_MODULE);
+	return ret;
 }
 
 static long vfio_platform_ioctl(void *device_data,
@@ -54,15 +134,33 @@ static long vfio_platform_ioctl(void *device_data,
 			return -EINVAL;
 
 		info.flags = vdev->flags;
-		info.num_regions = 0;
+		info.num_regions = vdev->num_regions;
 		info.num_irqs = 0;
 
 		return copy_to_user((void __user *)arg, &info, minsz);
 
-	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
-		return -EINVAL;
+	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
+		struct vfio_region_info info;
+
+		minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		if (info.index >= vdev->num_regions)
+			return -EINVAL;
+
+		/* map offset to the physical address  */
+		info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
+		info.size = vdev->regions[info.index].size;
+		info.flags = vdev->regions[info.index].flags;
+
+		return copy_to_user((void __user *)arg, &info, minsz);
 
-	else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
+	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
 		return -EINVAL;
 
 	else if (cmd == VFIO_DEVICE_SET_IRQS)
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index c046988..3551f6d 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -18,7 +18,29 @@
 #include <linux/types.h>
 #include <linux/interrupt.h>
 
+#define VFIO_PLATFORM_OFFSET_SHIFT   40
+#define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) << VFIO_PLATFORM_OFFSET_SHIFT) - 1)
+
+#define VFIO_PLATFORM_OFFSET_TO_INDEX(off)	\
+	(off >> VFIO_PLATFORM_OFFSET_SHIFT)
+
+#define VFIO_PLATFORM_INDEX_TO_OFFSET(index)	\
+	((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
+
+struct vfio_platform_region {
+	u64			addr;
+	resource_size_t		size;
+	u32			flags;
+	u32			type;
+#define VFIO_PLATFORM_REGION_TYPE_MMIO	1
+#define VFIO_PLATFORM_REGION_TYPE_PIO	2
+};
+
 struct vfio_platform_device {
+	struct vfio_platform_region	*regions;
+	u32				num_regions;
+	int				refcnt;
+
 	/*
 	 * These fields should be filled by the bus specific binder
 	 */
-- 
2.3.1
