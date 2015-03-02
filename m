From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [PATCH v14 11/20] vfio/platform: initial interrupts support code
Date: Mon,  2 Mar 2015 17:59:51 +0100
Message-ID: <1425315600-29761-12-git-send-email-b.reynal@virtualopensystems.com>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48EE54767D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:56:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1y0f61np1Dq4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 11:56:22 -0500 (EST)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2264A47515
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:56:21 -0500 (EST)
Received: by wivr20 with SMTP id r20so16496612wiv.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2015 09:02:19 -0800 (PST)
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

This patch is a skeleton for the VFIO_DEVICE_SET_IRQS IOCTL, around which
most IRQ functionality is implemented in VFIO.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_common.c  | 52 +++++++++++++++++++++--
 drivers/vfio/platform/vfio_platform_irq.c     | 59 +++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  7 ++++
 3 files changed, 115 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 908d510..abcff7a 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -205,10 +205,54 @@ static long vfio_platform_ioctl(void *device_data,
 
 		return copy_to_user((void __user *)arg, &info, minsz);
 
-	} else if (cmd == VFIO_DEVICE_SET_IRQS)
-		return -EINVAL;
+	} else if (cmd == VFIO_DEVICE_SET_IRQS) {
+		struct vfio_irq_set hdr;
+		u8 *data = NULL;
+		int ret = 0;
+
+		minsz = offsetofend(struct vfio_irq_set, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (hdr.argsz < minsz)
+			return -EINVAL;
+
+		if (hdr.index >= vdev->num_irqs)
+			return -EINVAL;
+
+		if (hdr.flags & ~(VFIO_IRQ_SET_DATA_TYPE_MASK |
+				  VFIO_IRQ_SET_ACTION_TYPE_MASK))
+			return -EINVAL;
 
-	else if (cmd == VFIO_DEVICE_RESET)
+		if (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE)) {
+			size_t size;
+
+			if (hdr.flags & VFIO_IRQ_SET_DATA_BOOL)
+				size = sizeof(uint8_t);
+			else if (hdr.flags & VFIO_IRQ_SET_DATA_EVENTFD)
+				size = sizeof(int32_t);
+			else
+				return -EINVAL;
+
+			if (hdr.argsz - minsz < size)
+				return -EINVAL;
+
+			data = memdup_user((void __user *)(arg + minsz), size);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
+		}
+
+		mutex_lock(&vdev->igate);
+
+		ret = vfio_platform_set_irqs_ioctl(vdev, hdr.flags, hdr.index,
+						   hdr.start, hdr.count, data);
+		mutex_unlock(&vdev->igate);
+		kfree(data);
+
+		return ret;
+
+	} else if (cmd == VFIO_DEVICE_RESET)
 		return -EINVAL;
 
 	return -ENOTTY;
@@ -458,6 +502,8 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 		return ret;
 	}
 
+	mutex_init(&vdev->igate);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_platform_probe_common);
diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index c6c3ec1..df5c919 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -23,6 +23,56 @@
 
 #include "vfio_platform_private.h"
 
+static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
+				      unsigned index, unsigned start,
+				      unsigned count, uint32_t flags,
+				      void *data)
+{
+	return -EINVAL;
+}
+
+static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
+					unsigned index, unsigned start,
+					unsigned count, uint32_t flags,
+					void *data)
+{
+	return -EINVAL;
+}
+
+static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
+					 unsigned index, unsigned start,
+					 unsigned count, uint32_t flags,
+					 void *data)
+{
+	return -EINVAL;
+}
+
+int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
+				 uint32_t flags, unsigned index, unsigned start,
+				 unsigned count, void *data)
+{
+	int (*func)(struct vfio_platform_device *vdev, unsigned index,
+		    unsigned start, unsigned count, uint32_t flags,
+		    void *data) = NULL;
+
+	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+	case VFIO_IRQ_SET_ACTION_MASK:
+		func = vfio_platform_set_irq_mask;
+		break;
+	case VFIO_IRQ_SET_ACTION_UNMASK:
+		func = vfio_platform_set_irq_unmask;
+		break;
+	case VFIO_IRQ_SET_ACTION_TRIGGER:
+		func = vfio_platform_set_irq_trigger;
+		break;
+	}
+
+	if (!func)
+		return -ENOTTY;
+
+	return func(vdev, index, start, count, flags, data);
+}
+
 int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 {
 	int cnt = 0, i;
@@ -35,13 +85,22 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 		return -ENOMEM;
 
 	for (i = 0; i < cnt; i++) {
+		int hwirq = vdev->get_irq(vdev, i);
+
+		if (hwirq < 0)
+			goto err;
+
 		vdev->irqs[i].flags = 0;
 		vdev->irqs[i].count = 1;
+		vdev->irqs[i].hwirq = hwirq;
 	}
 
 	vdev->num_irqs = cnt;
 
 	return 0;
+err:
+	kfree(vdev->irqs);
+	return -EINVAL;
 }
 
 void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index a2e286e..b119a6c 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -30,6 +30,7 @@
 struct vfio_platform_irq {
 	u32			flags;
 	u32			count;
+	int			hwirq;
 };
 
 struct vfio_platform_region {
@@ -48,6 +49,7 @@ struct vfio_platform_device {
 	struct vfio_platform_irq	*irqs;
 	u32				num_irqs;
 	int				refcnt;
+	struct mutex			igate;
 
 	/*
 	 * These fields should be filled by the bus specific binder
@@ -69,4 +71,9 @@ extern struct vfio_platform_device *vfio_platform_remove_common
 extern int vfio_platform_irq_init(struct vfio_platform_device *vdev);
 extern void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev);
 
+extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
+					uint32_t flags, unsigned index,
+					unsigned start, unsigned count,
+					void *data);
+
 #endif /* VFIO_PLATFORM_PRIVATE_H */
-- 
2.3.1
