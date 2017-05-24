From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 01/10] vfio: platform: Add automasked field to
 vfio_platform_irq
Date: Wed, 24 May 2017 22:13:14 +0200
Message-ID: <1495656803-28011-2-git-send-email-eric.auger@redhat.com>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B683140C5B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 16:09:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3zHjf+giB6wu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 May 2017 16:09:57 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C48840992
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 16:09:56 -0400 (EDT)
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

For direct EOI modality we will need to differentiate a userspace
masking from the IRQ handler auto-masking.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/platform/vfio_platform_irq.c     | 10 ++++++----
 drivers/vfio/platform/vfio_platform_private.h |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 46d4750..831f0b0 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -29,7 +29,7 @@ static void vfio_platform_mask(struct vfio_platform_irq *irq_ctx)
 
 	spin_lock_irqsave(&irq_ctx->lock, flags);
 
-	if (!irq_ctx->masked) {
+	if (!irq_ctx->masked && !irq_ctx->automasked) {
 		disable_irq_nosync(irq_ctx->hwirq);
 		irq_ctx->masked = true;
 	}
@@ -89,9 +89,10 @@ static void vfio_platform_unmask(struct vfio_platform_irq *irq_ctx)
 
 	spin_lock_irqsave(&irq_ctx->lock, flags);
 
-	if (irq_ctx->masked) {
+	if (irq_ctx->masked || irq_ctx->automasked) {
 		enable_irq(irq_ctx->hwirq);
 		irq_ctx->masked = false;
+		irq_ctx->automasked = false;
 	}
 
 	spin_unlock_irqrestore(&irq_ctx->lock, flags);
@@ -152,12 +153,12 @@ static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
 
 	spin_lock_irqsave(&irq_ctx->lock, flags);
 
-	if (!irq_ctx->masked) {
+	if (!irq_ctx->masked && !irq_ctx->automasked) {
 		ret = IRQ_HANDLED;
 
 		/* automask maskable interrupts */
 		disable_irq_nosync(irq_ctx->hwirq);
-		irq_ctx->masked = true;
+		irq_ctx->automasked = true;
 	}
 
 	spin_unlock_irqrestore(&irq_ctx->lock, flags);
@@ -315,6 +316,7 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 		vdev->irqs[i].count = 1;
 		vdev->irqs[i].hwirq = hwirq;
 		vdev->irqs[i].masked = false;
+		vdev->irqs[i].automasked = false;
 	}
 
 	vdev->num_irqs = cnt;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 85ffe5d..8a3cfa9 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -34,6 +34,7 @@ struct vfio_platform_irq {
 	char			*name;
 	struct eventfd_ctx	*trigger;
 	bool			masked;
+	bool			automasked;
 	spinlock_t		lock;
 	struct virqfd		*unmask;
 	struct virqfd		*mask;
-- 
2.5.5
