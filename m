From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [PATCH v14 06/20] vfio/platform: return info for bound device
Date: Mon,  2 Mar 2015 17:59:46 +0100
Message-ID: <1425315600-29761-7-git-send-email-b.reynal@virtualopensystems.com>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B46304763B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:55:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tb-oLBuEJJd4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 11:55:23 -0500 (EST)
Received: from mail-wg0-f51.google.com (mail-wg0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D4C9347639
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:55:22 -0500 (EST)
Received: by wgha1 with SMTP id a1so34744309wgh.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2015 09:01:19 -0800 (PST)
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

A VFIO userspace driver will start by opening the VFIO device
that corresponds to an IOMMU group, and will use the ioctl interface
to get the basic device info, such as number of memory regions and
interrupts, and their properties. This patch enables the
VFIO_DEVICE_GET_INFO ioctl call.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
[Baptiste Reynal: added include in vfio_platform_common.c]
Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_common.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 34d023b..c2f853a 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -18,6 +18,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/uaccess.h>
 #include <linux/vfio.h>
 
 #include "vfio_platform_private.h"
@@ -38,10 +39,27 @@ static int vfio_platform_open(void *device_data)
 static long vfio_platform_ioctl(void *device_data,
 				unsigned int cmd, unsigned long arg)
 {
-	if (cmd == VFIO_DEVICE_GET_INFO)
-		return -EINVAL;
+	struct vfio_platform_device *vdev = device_data;
+	unsigned long minsz;
+
+	if (cmd == VFIO_DEVICE_GET_INFO) {
+		struct vfio_device_info info;
+
+		minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		info.flags = vdev->flags;
+		info.num_regions = 0;
+		info.num_irqs = 0;
+
+		return copy_to_user((void __user *)arg, &info, minsz);
 
-	else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
+	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
 		return -EINVAL;
 
 	else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
-- 
2.3.1
