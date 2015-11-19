From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 02/13] VFIO: platform: registration of a dummy IRQ bypass
 producer
Date: Thu, 19 Nov 2015 14:53:52 +0000
Message-ID: <1447944843-17731-3-git-send-email-eric.auger@linaro.org>
References: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C753249928
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zNSCD+6iWqyf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2015 09:53:35 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33E5349956
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:33 -0500 (EST)
Received: by wmdw130 with SMTP id w130so243635052wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 06:54:13 -0800 (PST)
In-Reply-To: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Register a dummy producer with void callbacks

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v3 -> v3:
- replace WARN_ON by pr_info() in case irq_bypass_register_producer
  fails

v2 -> v3:
- rename vfio_platform_irq_bypass_resume into *_start
---
 drivers/vfio/platform/vfio_platform_irq.c     | 34 +++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  2 ++
 2 files changed, 36 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 46d4750..ab7658a 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -20,6 +20,7 @@
 #include <linux/types.h>
 #include <linux/vfio.h>
 #include <linux/irq.h>
+#include <linux/irqbypass.h>
 
 #include "vfio_platform_private.h"
 
@@ -177,6 +178,27 @@ static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
+{
+}
+
+static void vfio_platform_irq_bypass_start(struct irq_bypass_producer *prod)
+{
+}
+
+static int vfio_platform_irq_bypass_add_consumer(
+			struct irq_bypass_producer *prod,
+			struct irq_bypass_consumer *cons)
+{
+	return 0;
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
@@ -187,6 +209,7 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 	if (irq->trigger) {
 		irq_clear_status_flags(irq->hwirq, IRQ_NOAUTOEN);
 		free_irq(irq->hwirq, irq);
+		irq_bypass_unregister_producer(&irq->producer);
 		kfree(irq->name);
 		eventfd_ctx_put(irq->trigger);
 		irq->trigger = NULL;
@@ -217,6 +240,17 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 		return ret;
 	}
 
+	irq->producer.token = (void *)trigger;
+	irq->producer.irq = irq->hwirq;
+	irq->producer.add_consumer = vfio_platform_irq_bypass_add_consumer;
+	irq->producer.del_consumer = vfio_platform_irq_bypass_del_consumer;
+	irq->producer.stop = vfio_platform_irq_bypass_stop;
+	irq->producer.start = vfio_platform_irq_bypass_start;
+	ret = irq_bypass_register_producer(&irq->producer);
+	if (ret)
+		pr_info("irq bypass producer (token %p) registration fails: %d\n",
+			irq->producer.token, ret);
+
 	if (!irq->masked)
 		enable_irq(irq->hwirq);
 
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 42816dd..979c191 100644
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
