From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 02/17] VFIO: platform: single handler using function pointer
Date: Thu,  2 Jul 2015 15:17:12 +0200
Message-ID: <1435843047-6327-3-git-send-email-eric.auger@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, pbonzini@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

A single handler now is registered whatever the use case: automasked
or not. A function pointer is set according to the wished behavior
and the handler calls this function.

The irq lock is taken/released in the root handler. eventfd_signal can
be called in regions not allowed to sleep.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v4: creation
---
 drivers/vfio/platform/vfio_platform_irq.c     | 21 +++++++++++++++------
 drivers/vfio/platform/vfio_platform_private.h |  1 +
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 132bb3f..8eb65c1 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -147,11 +147,8 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
 static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
 {
 	struct vfio_platform_irq *irq_ctx = dev_id;
-	unsigned long flags;
 	int ret = IRQ_NONE;
 
-	spin_lock_irqsave(&irq_ctx->lock, flags);
-
 	if (!irq_ctx->masked) {
 		ret = IRQ_HANDLED;
 
@@ -160,8 +157,6 @@ static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
 		irq_ctx->masked = true;
 	}
 
-	spin_unlock_irqrestore(&irq_ctx->lock, flags);
-
 	if (ret == IRQ_HANDLED)
 		eventfd_signal(irq_ctx->trigger, 1);
 
@@ -177,6 +172,19 @@ static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t vfio_handler(int irq, void *dev_id)
+{
+	struct vfio_platform_irq *irq_ctx = dev_id;
+	unsigned long flags;
+	irqreturn_t ret;
+
+	spin_lock_irqsave(&irq_ctx->lock, flags);
+	ret = irq_ctx->handler(irq, dev_id);
+	spin_unlock_irqrestore(&irq_ctx->lock, flags);
+
+	return ret;
+}
+
 static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 			    int fd, irq_handler_t handler)
 {
@@ -206,9 +214,10 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 	}
 
 	irq->trigger = trigger;
+	irq->handler = handler;
 
 	irq_set_status_flags(irq->hwirq, IRQ_NOAUTOEN);
-	ret = request_irq(irq->hwirq, handler, 0, irq->name, irq);
+	ret = request_irq(irq->hwirq, vfio_handler, 0, irq->name, irq);
 	if (ret) {
 		kfree(irq->name);
 		eventfd_ctx_put(trigger);
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 1c9b3d5..413f575 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -37,6 +37,7 @@ struct vfio_platform_irq {
 	spinlock_t		lock;
 	struct virqfd		*unmask;
 	struct virqfd		*mask;
+	irqreturn_t (*handler)(int irq, void *dev_id);
 };
 
 struct vfio_platform_region {
-- 
1.9.1
