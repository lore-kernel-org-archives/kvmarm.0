From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [PATCH v14 13/20] vfio/platform: support for level sensitive
 interrupts
Date: Mon,  2 Mar 2015 17:59:53 +0100
Message-ID: <1425315600-29761-14-git-send-email-b.reynal@virtualopensystems.com>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 519C9475FB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:56:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fyw+3dTGei3v for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 11:56:45 -0500 (EST)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
 [209.85.212.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4FC8C475F1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:56:45 -0500 (EST)
Received: by widex7 with SMTP id ex7so16477721wid.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2015 09:02:42 -0800 (PST)
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

Level sensitive interrupts are exposed as maskable and automasked
interrupts and are masked and disabled automatically when they fire.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
[Baptiste Reynal: Move masked interrupt initialization from "vfio/platform:
trigger an interrupt via eventfd"]
Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_irq.c     | 103 +++++++++++++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |   2 +
 2 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 611ec80..e0e6388 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -23,12 +23,59 @@
 
 #include "vfio_platform_private.h"
 
+static void vfio_platform_mask(struct vfio_platform_irq *irq_ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq_ctx->lock, flags);
+
+	if (!irq_ctx->masked) {
+		disable_irq_nosync(irq_ctx->hwirq);
+		irq_ctx->masked = true;
+	}
+
+	spin_unlock_irqrestore(&irq_ctx->lock, flags);
+}
+
 static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
 				      unsigned index, unsigned start,
 				      unsigned count, uint32_t flags,
 				      void *data)
 {
-	return -EINVAL;
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	if (!(vdev->irqs[index].flags & VFIO_IRQ_INFO_MASKABLE))
+		return -EINVAL;
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD)
+		return -EINVAL; /* not implemented yet */
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+		vfio_platform_mask(&vdev->irqs[index]);
+
+	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+		uint8_t mask = *(uint8_t *)data;
+
+		if (mask)
+			vfio_platform_mask(&vdev->irqs[index]);
+	}
+
+	return 0;
+}
+
+static void vfio_platform_unmask(struct vfio_platform_irq *irq_ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq_ctx->lock, flags);
+
+	if (irq_ctx->masked) {
+		enable_irq(irq_ctx->hwirq);
+		irq_ctx->masked = false;
+	}
+
+	spin_unlock_irqrestore(&irq_ctx->lock, flags);
 }
 
 static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
@@ -36,7 +83,50 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
 					unsigned count, uint32_t flags,
 					void *data)
 {
-	return -EINVAL;
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	if (!(vdev->irqs[index].flags & VFIO_IRQ_INFO_MASKABLE))
+		return -EINVAL;
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD)
+		return -EINVAL; /* not implemented yet */
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+		vfio_platform_unmask(&vdev->irqs[index]);
+
+	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+		uint8_t unmask = *(uint8_t *)data;
+
+		if (unmask)
+			vfio_platform_unmask(&vdev->irqs[index]);
+	}
+
+	return 0;
+}
+
+static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
+{
+	struct vfio_platform_irq *irq_ctx = dev_id;
+	unsigned long flags;
+	int ret = IRQ_NONE;
+
+	spin_lock_irqsave(&irq_ctx->lock, flags);
+
+	if (!irq_ctx->masked) {
+		ret = IRQ_HANDLED;
+
+		/* automask maskable interrupts */
+		disable_irq_nosync(irq_ctx->hwirq);
+		irq_ctx->masked = true;
+	}
+
+	spin_unlock_irqrestore(&irq_ctx->lock, flags);
+
+	if (ret == IRQ_HANDLED)
+		eventfd_signal(irq_ctx->trigger, 1);
+
+	return ret;
 }
 
 static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
@@ -78,6 +168,7 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 
 	irq->trigger = trigger;
 
+	irq_set_status_flags(irq->hwirq, IRQ_NOAUTOEN);
 	ret = request_irq(irq->hwirq, handler, 0, irq->name, irq);
 	if (ret) {
 		kfree(irq->name);
@@ -86,6 +177,9 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 		return ret;
 	}
 
+	if (!irq->masked)
+		enable_irq(irq->hwirq);
+
 	return 0;
 }
 
@@ -98,7 +192,7 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 	irq_handler_t handler;
 
 	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_AUTOMASKED)
-		return -EINVAL; /* not implemented */
+		handler = vfio_automasked_irq_handler;
 	else
 		handler = vfio_irq_handler;
 
@@ -170,6 +264,8 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 		if (hwirq < 0)
 			goto err;
 
+		spin_lock_init(&vdev->irqs[i].lock);
+
 		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
 
 		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
@@ -178,6 +274,7 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 
 		vdev->irqs[i].count = 1;
 		vdev->irqs[i].hwirq = hwirq;
+		vdev->irqs[i].masked = false;
 	}
 
 	vdev->num_irqs = cnt;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index aa01cc3..ff2db1d 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -33,6 +33,8 @@ struct vfio_platform_irq {
 	int			hwirq;
 	char			*name;
 	struct eventfd_ctx	*trigger;
+	bool			masked;
+	spinlock_t		lock;
 };
 
 struct vfio_platform_region {
-- 
2.3.1
