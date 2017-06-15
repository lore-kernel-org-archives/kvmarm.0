From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 2/8] VFIO: platform: Introduce direct EOI interrupt handler
Date: Thu, 15 Jun 2017 14:52:34 +0200
Message-ID: <1497531160-29162-3-git-send-email-eric.auger@redhat.com>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, pbonzini@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

We add two new fields in vfio_platform_irq: deoi and handler.

If deoi is set, this means the physical IRQ attached to the virtual
IRQ is directly deactivated by the guest and the VFIO driver does
not need to disable the physical IRQ and mask it at VFIO level.

The handler pointer points to either the automasked or "deoi" handler.
This latter is the same as the one used for edge sensitive IRQs.
A wrapper handler is introduced that calls the chosen handler function.

The irq lock is taken/released in the wrapper handler. eventfd_signal
can be called in regions not allowed to sleep.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- fix a weird indentation
---
 drivers/vfio/platform/vfio_platform_irq.c     | 23 ++++++++++++++++-------
 drivers/vfio/platform/vfio_platform_private.h |  2 ++
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 6740dbe..0228a96 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -148,11 +148,8 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
 static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
 {
 	struct vfio_platform_irq *irq_ctx = dev_id;
-	unsigned long flags;
 	int ret = IRQ_NONE;
 
-	spin_lock_irqsave(&irq_ctx->lock, flags);
-
 	if (!is_masked(irq_ctx)) {
 		ret = IRQ_HANDLED;
 
@@ -161,8 +158,6 @@ static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
 		irq_ctx->automasked = true;
 	}
 
-	spin_unlock_irqrestore(&irq_ctx->lock, flags);
-
 	if (ret == IRQ_HANDLED)
 		eventfd_signal(irq_ctx->trigger, 1);
 
@@ -178,6 +173,19 @@ static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t vfio_wrapper_handler(int irq, void *dev_id)
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
@@ -208,9 +216,10 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 	}
 
 	irq->trigger = trigger;
+	irq->handler = handler;
 
 	irq_set_status_flags(irq->hwirq, IRQ_NOAUTOEN);
-	ret = request_irq(irq->hwirq, handler, 0, irq->name, irq);
+	ret = request_irq(irq->hwirq, vfio_wrapper_handler, 0, irq->name, irq);
 	if (ret) {
 		kfree(irq->name);
 		eventfd_ctx_put(trigger);
@@ -232,7 +241,7 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 	struct vfio_platform_irq *irq = &vdev->irqs[index];
 	irq_handler_t handler;
 
-	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_AUTOMASKED)
+	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_AUTOMASKED && !irq->deoi)
 		handler = vfio_automasked_irq_handler;
 	else
 		handler = vfio_irq_handler;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index e8db291..66a9ef5 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -38,6 +38,8 @@ struct vfio_platform_irq {
 	spinlock_t		lock;
 	struct virqfd		*unmask;
 	struct virqfd		*mask;
+	bool			deoi;
+	irqreturn_t		(*handler)(int irq, void *dev_id);
 };
 
 struct vfio_platform_region {
-- 
2.5.5
