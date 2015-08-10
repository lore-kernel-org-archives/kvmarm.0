From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 03/10] VFIO: platform: single handler using function pointer
Date: Mon, 10 Aug 2015 15:20:57 +0200
Message-ID: <1439212864-12954-4-git-send-email-eric.auger@linaro.org>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 494805A676
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:08:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qb1Rr6u1TyxZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:08:56 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 152285A66E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:08:55 -0400 (EDT)
Received: by wicne3 with SMTP id ne3so135767613wic.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:21:56 -0700 (PDT)
In-Reply-To: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, feng.wu@intel.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
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
index 40f057a..b31b1f0 100644
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
@@ -229,9 +237,10 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
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
index 8b4f814..f848a6b 100644
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
