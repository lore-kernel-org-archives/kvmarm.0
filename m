From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 02/10] VFIO: platform: Introduce direct EOI interrupt handler
Date: Wed, 24 May 2017 22:13:15 +0200
Message-ID: <1495656803-28011-3-git-send-email-eric.auger@redhat.com>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0649940B58
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 16:10:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RJjpm6htaAT1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 May 2017 16:10:00 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E81A40C5B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 16:09:59 -0400 (EDT)
In-Reply-To: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, pbonzini@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
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
---
 drivers/vfio/platform/vfio_platform_irq.c     | 24 +++++++++++++++++-------
 drivers/vfio/platform/vfio_platform_private.h |  2 ++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 831f0b0..2f82459 100644
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
 	if (!irq_ctx->masked && !irq_ctx->automasked) {
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
@@ -232,7 +241,8 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 	struct vfio_platform_irq *irq = &vdev->irqs[index];
 	irq_handler_t handler;
 
-	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_AUTOMASKED)
+	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_AUTOMASKED &&
+			!irq->deoi)
 		handler = vfio_automasked_irq_handler;
 	else
 		handler = vfio_irq_handler;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 8a3cfa9..b80a380 100644
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
