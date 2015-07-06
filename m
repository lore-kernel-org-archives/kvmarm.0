From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 1/9] VFIO: platform: registration of a dummy IRQ bypass
 producer
Date: Mon,  6 Jul 2015 15:24:35 +0200
Message-ID: <1436189083-32527-2-git-send-email-eric.auger@linaro.org>
References: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6018457B9D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 09:13:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HDLf84vtRAM1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 09:13:43 -0400 (EDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
 [209.85.212.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D03857B92
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 09:13:43 -0400 (EDT)
Received: by wiclp1 with SMTP id lp1so21138241wic.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2015 06:25:10 -0700 (PDT)
In-Reply-To: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: pbonzini@redhat.com, alex.williamson@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Register a dummy producer with void callbacks

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/platform/vfio_platform_irq.c     | 31 +++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 88bba57..4b059bf 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -20,6 +20,7 @@
 #include <linux/types.h>
 #include <linux/vfio.h>
 #include <linux/irq.h>
+#include <linux/irqbypass.h>
 
 #include "vfio_platform_private.h"
 
@@ -177,6 +178,26 @@ static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
+{
+}
+
+static void vfio_platform_irq_bypass_resume(struct irq_bypass_producer *prod)
+{
+}
+
+static void vfio_platform_irq_bypass_add_consumer(
+			struct irq_bypass_producer *prod,
+			struct irq_bypass_consumer *cons)
+{
+}
+
+static void vfio_platform_irq_bypass_del_consumer(
+			struct irq_bypass_producer *prod,
+			struct irq_bypass_consumer *cons)
+{
+}
+
 static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 			    int fd, irq_handler_t handler)
 {
@@ -186,6 +207,7 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 
 	if (irq->trigger) {
 		free_irq(irq->hwirq, irq);
+		irq_bypass_unregister_producer(&irq->producer);
 		kfree(irq->name);
 		eventfd_ctx_put(irq->trigger);
 		irq->trigger = NULL;
@@ -216,6 +238,15 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 		return ret;
 	}
 
+	irq->producer.token = (void *)trigger;
+	irq->producer.irq = irq->hwirq;
+	irq->producer.add_consumer = vfio_platform_irq_bypass_add_consumer;
+	irq->producer.del_consumer = vfio_platform_irq_bypass_del_consumer;
+	irq->producer.stop = vfio_platform_irq_bypass_stop;
+	irq->producer.resume = vfio_platform_irq_bypass_resume;
+	ret = irq_bypass_register_producer(&irq->producer);
+	WARN_ON(ret);
+
 	if (!irq->masked)
 		enable_irq(irq->hwirq);
 
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 1c9b3d5..1d2d4d6 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -17,6 +17,7 @@
 
 #include <linux/types.h>
 #include <linux/interrupt.h>
+#include <linux/irqbypass.h>
 
 #define VFIO_PLATFORM_OFFSET_SHIFT   40
 #define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) << VFIO_PLATFORM_OFFSET_SHIFT) - 1)
@@ -37,6 +38,7 @@ struct vfio_platform_irq {
 	spinlock_t		lock;
 	struct virqfd		*unmask;
 	struct virqfd		*mask;
+	struct irq_bypass_producer producer;
 };
 
 struct vfio_platform_region {
-- 
1.9.1
