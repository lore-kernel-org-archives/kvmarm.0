From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 04/13] VFIO: platform: single handler using function pointer
Date: Thu, 19 Nov 2015 14:53:54 +0000
Message-ID: <1447944843-17731-5-git-send-email-eric.auger@linaro.org>
References: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF8AE499F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kd5F-nom0uVp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2015 09:53:38 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6524649A08
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:37 -0500 (EST)
Received: by wmdw130 with SMTP id w130so243637238wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 06:54:16 -0800 (PST)
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
index d4462fd..c58e0ad 100644
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
 	if (!irq_ctx->masked) {
 		ret = IRQ_HANDLED;
 
@@ -161,8 +158,6 @@ static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
 		irq_ctx->masked = true;
 	}
 
-	spin_unlock_irqrestore(&irq_ctx->lock, flags);
-
 	if (ret == IRQ_HANDLED)
 		eventfd_signal(irq_ctx->trigger, 1);
 
@@ -178,6 +173,19 @@ static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
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
 static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
 {
 }
@@ -230,9 +238,10 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
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
index 55e8043..8a8c050 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -40,6 +40,7 @@ struct vfio_platform_irq {
 	struct virqfd		*mask;
 	struct irq_bypass_producer producer;
 	bool			forwarded;
+	irqreturn_t (*handler)(int irq, void *dev_id);
 };
 
 struct vfio_platform_region {
-- 
1.9.1
