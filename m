From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: [PATCH v14 08/20] vfio/platform: read and write support for the
	device fd
Date: Mon,  2 Mar 2015 17:59:48 +0100
Message-ID: <1425315600-29761-9-git-send-email-b.reynal@virtualopensystems.com>
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

VFIO returns a file descriptor which we can use to manipulate the memory
regions of the device. Usually, the user will mmap memory regions that are
addressable on page boundaries, however for memory regions where this is
not the case we cannot provide mmap functionality due to security concerns.
For this reason we also allow to use read and write functions to the file
descriptor pointing to the memory regions.

We implement this functionality only for MMIO regions of platform devices;
PIO regions are not being handled at this point.

Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Signed-off-by: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
---
 drivers/vfio/platform/vfio_platform_common.c  | 150 ++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |   1 +
 2 files changed, 151 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 47f6309..4df66f5 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -51,6 +51,10 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
 		switch (resource_type(res)) {
 		case IORESOURCE_MEM:
 			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_MMIO;
+			vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_READ;
+			if (!(res->flags & IORESOURCE_READONLY))
+				vdev->regions[i].flags |=
+					VFIO_REGION_INFO_FLAG_WRITE;
 			break;
 		case IORESOURCE_IO:
 			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_PIO;
@@ -70,6 +74,11 @@ err:
 
 static void vfio_platform_regions_cleanup(struct vfio_platform_device *vdev)
 {
+	int i;
+
+	for (i = 0; i < vdev->num_regions; i++)
+		iounmap(vdev->regions[i].ioaddr);
+
 	vdev->num_regions = 0;
 	kfree(vdev->regions);
 }
@@ -172,15 +181,156 @@ static long vfio_platform_ioctl(void *device_data,
 	return -ENOTTY;
 }
 
+static ssize_t vfio_platform_read_mmio(struct vfio_platform_region reg,
+				       char __user *buf, size_t count,
+				       loff_t off)
+{
+	unsigned int done = 0;
+
+	if (!reg.ioaddr) {
+		reg.ioaddr =
+			ioremap_nocache(reg.addr, reg.size);
+
+		if (!reg.ioaddr)
+			return -ENOMEM;
+	}
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(off % 4)) {
+			u32 val;
+
+			val = ioread32(reg.ioaddr + off);
+			if (copy_to_user(buf, &val, 4))
+				goto err;
+
+			filled = 4;
+		} else if (count >= 2 && !(off % 2)) {
+			u16 val;
+
+			val = ioread16(reg.ioaddr + off);
+			if (copy_to_user(buf, &val, 2))
+				goto err;
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			val = ioread8(reg.ioaddr + off);
+			if (copy_to_user(buf, &val, 1))
+				goto err;
+
+			filled = 1;
+		}
+
+
+		count -= filled;
+		done += filled;
+		off += filled;
+		buf += filled;
+	}
+
+	return done;
+err:
+	return -EFAULT;
+}
+
 static ssize_t vfio_platform_read(void *device_data, char __user *buf,
 				  size_t count, loff_t *ppos)
 {
+	struct vfio_platform_device *vdev = device_data;
+	unsigned int index = VFIO_PLATFORM_OFFSET_TO_INDEX(*ppos);
+	loff_t off = *ppos & VFIO_PLATFORM_OFFSET_MASK;
+
+	if (index >= vdev->num_regions)
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ))
+		return -EINVAL;
+
+	if (vdev->regions[index].type & VFIO_PLATFORM_REGION_TYPE_MMIO)
+		return vfio_platform_read_mmio(vdev->regions[index],
+							buf, count, off);
+	else if (vdev->regions[index].type & VFIO_PLATFORM_REGION_TYPE_PIO)
+		return -EINVAL; /* not implemented */
+
 	return -EINVAL;
 }
 
+static ssize_t vfio_platform_write_mmio(struct vfio_platform_region reg,
+					const char __user *buf, size_t count,
+					loff_t off)
+{
+	unsigned int done = 0;
+
+	if (!reg.ioaddr) {
+		reg.ioaddr =
+			ioremap_nocache(reg.addr, reg.size);
+
+		if (!reg.ioaddr)
+			return -ENOMEM;
+	}
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(off % 4)) {
+			u32 val;
+
+			if (copy_from_user(&val, buf, 4))
+				goto err;
+			iowrite32(val, reg.ioaddr + off);
+
+			filled = 4;
+		} else if (count >= 2 && !(off % 2)) {
+			u16 val;
+
+			if (copy_from_user(&val, buf, 2))
+				goto err;
+			iowrite16(val, reg.ioaddr + off);
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			if (copy_from_user(&val, buf, 1))
+				goto err;
+			iowrite8(val, reg.ioaddr + off);
+
+			filled = 1;
+		}
+
+		count -= filled;
+		done += filled;
+		off += filled;
+		buf += filled;
+	}
+
+	return done;
+err:
+	return -EFAULT;
+}
+
 static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
 				   size_t count, loff_t *ppos)
 {
+	struct vfio_platform_device *vdev = device_data;
+	unsigned int index = VFIO_PLATFORM_OFFSET_TO_INDEX(*ppos);
+	loff_t off = *ppos & VFIO_PLATFORM_OFFSET_MASK;
+
+	if (index >= vdev->num_regions)
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE))
+		return -EINVAL;
+
+	if (vdev->regions[index].type & VFIO_PLATFORM_REGION_TYPE_MMIO)
+		return vfio_platform_write_mmio(vdev->regions[index],
+							buf, count, off);
+	else if (vdev->regions[index].type & VFIO_PLATFORM_REGION_TYPE_PIO)
+		return -EINVAL; /* not implemented */
+
 	return -EINVAL;
 }
 
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 3551f6d..97c78f9 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -34,6 +34,7 @@ struct vfio_platform_region {
 	u32			type;
 #define VFIO_PLATFORM_REGION_TYPE_MMIO	1
 #define VFIO_PLATFORM_REGION_TYPE_PIO	2
+	void __iomem		*ioaddr;
 };
 
 struct vfio_platform_device {
-- 
2.3.1
