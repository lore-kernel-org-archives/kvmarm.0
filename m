From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [PATCH v14 01/20] vfio/platform: initial skeleton of VFIO support for
 platform devices
Date: Mon,  2 Mar 2015 17:59:41 +0100
Message-ID: <1425315600-29761-2-git-send-email-b.reynal@virtualopensystems.com>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4068A475FA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:54:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qhraSFaLgqGg for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 11:54:37 -0500 (EST)
Received: from mail-we0-f177.google.com (mail-we0-f177.google.com
 [74.125.82.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC23E47564
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:54:35 -0500 (EST)
Received: by wesp10 with SMTP id p10so32426051wes.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2015 09:00:32 -0800 (PST)
In-Reply-To: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: iommu@lists.linux-foundation.org, kvmarm@lists.cs.columbia.edu
Cc: "open list:VFIO DRIVER" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, tech@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Antonios Motakis <a.motakis@virtualopensystems.com>

This patch forms the common skeleton code for platform devices support
with VFIO. This will include the core functionality of VFIO_PLATFORM,
however binding to the device and discovering the device resources will
be done with the help of a separate file where any Linux platform bus
specific code will reside.

This will allow us to implement support for also discovering AMBA devices
and their resources, but still reuse a large part of the VFIO_PLATFORM
implementation.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
[Baptiste Reynal: added includes in vfio_platform_private.h]
Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_common.c  | 121 ++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  39 +++++++++
 2 files changed, 160 insertions(+)
 create mode 100644 drivers/vfio/platform/vfio_platform_common.c
 create mode 100644 drivers/vfio/platform/vfio_platform_private.h

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
new file mode 100644
index 0000000..34d023b
--- /dev/null
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -0,0 +1,121 @@
+/*
+ * Copyright (C) 2013 - Virtual Open Systems
+ * Author: Antonios Motakis <a.motakis@virtualopensystems.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/vfio.h>
+
+#include "vfio_platform_private.h"
+
+static void vfio_platform_release(void *device_data)
+{
+	module_put(THIS_MODULE);
+}
+
+static int vfio_platform_open(void *device_data)
+{
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	return 0;
+}
+
+static long vfio_platform_ioctl(void *device_data,
+				unsigned int cmd, unsigned long arg)
+{
+	if (cmd == VFIO_DEVICE_GET_INFO)
+		return -EINVAL;
+
+	else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
+		return -EINVAL;
+
+	else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
+		return -EINVAL;
+
+	else if (cmd == VFIO_DEVICE_SET_IRQS)
+		return -EINVAL;
+
+	else if (cmd == VFIO_DEVICE_RESET)
+		return -EINVAL;
+
+	return -ENOTTY;
+}
+
+static ssize_t vfio_platform_read(void *device_data, char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	return -EINVAL;
+}
+
+static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	return -EINVAL;
+}
+
+static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
+{
+	return -EINVAL;
+}
+
+static const struct vfio_device_ops vfio_platform_ops = {
+	.name		= "vfio-platform",
+	.open		= vfio_platform_open,
+	.release	= vfio_platform_release,
+	.ioctl		= vfio_platform_ioctl,
+	.read		= vfio_platform_read,
+	.write		= vfio_platform_write,
+	.mmap		= vfio_platform_mmap,
+};
+
+int vfio_platform_probe_common(struct vfio_platform_device *vdev,
+			       struct device *dev)
+{
+	struct iommu_group *group;
+	int ret;
+
+	if (!vdev)
+		return -EINVAL;
+
+	group = iommu_group_get(dev);
+	if (!group) {
+		pr_err("VFIO: No IOMMU group for device %s\n", vdev->name);
+		return -EINVAL;
+	}
+
+	ret = vfio_add_group_dev(dev, &vfio_platform_ops, vdev);
+	if (ret) {
+		iommu_group_put(group);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_platform_probe_common);
+
+struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
+{
+	struct vfio_platform_device *vdev;
+
+	vdev = vfio_del_group_dev(dev);
+	if (vdev)
+		iommu_group_put(dev->iommu_group);
+
+	return vdev;
+}
+EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
new file mode 100644
index 0000000..c046988
--- /dev/null
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2013 - Virtual Open Systems
+ * Author: Antonios Motakis <a.motakis@virtualopensystems.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef VFIO_PLATFORM_PRIVATE_H
+#define VFIO_PLATFORM_PRIVATE_H
+
+#include <linux/types.h>
+#include <linux/interrupt.h>
+
+struct vfio_platform_device {
+	/*
+	 * These fields should be filled by the bus specific binder
+	 */
+	void		*opaque;
+	const char	*name;
+	uint32_t	flags;
+	/* callbacks to discover device resources */
+	struct resource*
+		(*get_resource)(struct vfio_platform_device *vdev, int i);
+	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
+};
+
+extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
+				      struct device *dev);
+extern struct vfio_platform_device *vfio_platform_remove_common
+				     (struct device *dev);
+
+#endif /* VFIO_PLATFORM_PRIVATE_H */
-- 
2.3.1
