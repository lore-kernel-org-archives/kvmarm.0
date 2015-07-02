From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 17/17] VFIO: platform: add irq bypass producer management
Date: Thu,  2 Jul 2015 15:17:27 +0200
Message-ID: <1435843047-6327-18-git-send-email-eric.auger@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 483FF5774A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:07:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P9wqQqT3jiOL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 09:07:35 -0400 (EDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
 [209.85.212.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 307EF5771E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:07:13 -0400 (EDT)
Received: by wiwl6 with SMTP id l6so196709676wiw.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2015 06:18:29 -0700 (PDT)
In-Reply-To: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, pbonzini@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds irq_bypass_producer registration/unregistration.
VFIO producer callbacks are populated:
- stop/resume producer simply consist in disabling/enabling the host irq
- add/del consumer: basically set the automasked flag to false/true

The vfio_platform_device pointer is passed as producer opaque.

We also cache the device handle in vfio_platform_device. This
makes possible to easily retrieve the vfio_device at registration.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/platform/vfio_platform_common.c  |  2 +
 drivers/vfio/platform/vfio_platform_irq.c     | 83 +++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  2 +
 3 files changed, 87 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 9acfca6..12d4540 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -546,6 +546,8 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 	if (!vdev)
 		return -EINVAL;
 
+	vdev->dev = dev;
+
 	group = iommu_group_get(dev);
 	if (!group) {
 		pr_err("VFIO: No IOMMU group for device %s\n", vdev->name);
diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index f6d83ed..0061e6e 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -20,6 +20,7 @@
 #include <linux/types.h>
 #include <linux/vfio.h>
 #include <linux/irq.h>
+#include <linux/irqbypass.h>
 
 #include "vfio_platform_private.h"
 
@@ -185,6 +186,70 @@ static irqreturn_t vfio_handler(int irq, void *dev_id)
 	return ret;
 }
 
+static void vfio_platform_stop_producer(struct irq_bypass_producer *prod)
+{
+	pr_info("%s disable %d\n", __func__, prod->irq);
+	disable_irq(prod->irq);
+}
+
+static void vfio_platform_resume_producer(struct irq_bypass_producer *prod)
+{
+	pr_info("%s enable %d\n", __func__, prod->irq);
+	enable_irq(prod->irq);
+}
+
+static void vfio_platform_add_consumer(struct irq_bypass_producer *prod,
+				       struct irq_bypass_consumer *cons)
+{
+	int i, ret;
+	struct vfio_platform_device *vdev =
+		(struct vfio_platform_device *)prod->opaque;
+
+	pr_info("%s irq=%d gsi =%d\n", __func__, prod->irq, cons->gsi);
+
+	for (i = 0; i < vdev->num_irqs; i++) {
+		if (vdev->irqs[i].prod == prod)
+			break;
+	}
+	WARN_ON(i == vdev->num_irqs);
+
+	//TODO
+	/*
+	 * if the IRQ is active at irqchip level or VFIO (auto)masked
+	 * this means the host IRQ is already under injection in the
+	 * guest and this not safe to change the forwarding state at
+	 * that stage.
+	 * It is not possible to differentiate user-space masking
+	 * from auto-masking, leading to possible false detection of
+	 * active state.
+	 */
+	prod->active = vfio_external_is_active(prod->vdev, i, 0, 0);
+
+	ret = vfio_external_set_automasked(prod->vdev, i, 0, 0, false);
+	WARN_ON(ret);
+}
+
+static void vfio_platform_del_consumer(struct irq_bypass_producer *prod,
+				       struct irq_bypass_consumer *cons)
+{
+	int i;
+	struct vfio_platform_device *vdev =
+		(struct vfio_platform_device *)prod->opaque;
+
+	pr_info("%s irq=%d gsi =%d\n", __func__, prod->irq, cons->gsi);
+
+	for (i = 0; i < vdev->num_irqs; i++) {
+		if (vdev->irqs[i].prod == prod)
+			break;
+	}
+	WARN_ON(i == vdev->num_irqs);
+
+	if (prod->active)
+		vfio_external_mask(prod->vdev, i, 0, 0);
+
+	vfio_external_set_automasked(prod->vdev, i, 0, 0, true);
+}
+
 static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 			    int fd, irq_handler_t handler)
 {
@@ -192,8 +257,11 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 	struct eventfd_ctx *trigger;
 	int ret;
 
+
 	if (irq->trigger) {
 		free_irq(irq->hwirq, irq);
+		irq_bypass_unregister_producer(irq->prod);
+		kfree(irq->prod);
 		kfree(irq->name);
 		eventfd_ctx_put(irq->trigger);
 		irq->trigger = NULL;
@@ -225,6 +293,21 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 		return ret;
 	}
 
+	irq->prod = kzalloc(sizeof(struct irq_bypass_producer),
+			    GFP_KERNEL);
+	if (!irq->prod)
+		return -ENOMEM;
+	irq->prod->token = (void *)trigger;
+	irq->prod->irq = irq->hwirq;
+	irq->prod->vdev = vfio_device_get_from_dev(vdev->dev);
+	irq->prod->opaque = (void *)vdev;
+	irq->prod->add_consumer = vfio_platform_add_consumer;
+	irq->prod->del_consumer = vfio_platform_del_consumer;
+	irq->prod->stop_producer = vfio_platform_stop_producer;
+	irq->prod->resume_producer = vfio_platform_resume_producer;
+	ret = irq_bypass_register_producer(irq->prod);
+	WARN_ON(ret);
+
 	if (!irq->masked)
 		enable_irq(irq->hwirq);
 
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 5f46c68..1255306 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -38,6 +38,7 @@ struct vfio_platform_irq {
 	struct virqfd		*unmask;
 	struct virqfd		*mask;
 	irqreturn_t (*handler)(int irq, void *dev_id);
+	struct irq_bypass_producer *prod;
 };
 
 struct vfio_platform_region {
@@ -57,6 +58,7 @@ struct vfio_platform_device {
 	u32				num_irqs;
 	int				refcnt;
 	struct mutex			igate;
+	struct device			*dev;
 
 	/*
 	 * These fields should be filled by the bus specific binder
-- 
1.9.1
