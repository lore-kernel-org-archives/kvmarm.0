From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 1/8] VFIO: platform: Differentiate auto-masking from user
 masking
Date: Thu, 15 Jun 2017 14:52:33 +0200
Message-ID: <1497531160-29162-2-git-send-email-eric.auger@redhat.com>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4A0240D58
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jun 2017 08:49:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0IeSCYE6eCYv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jun 2017 08:49:40 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6A3540D44
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jun 2017 08:49:39 -0400 (EDT)
In-Reply-To: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, pbonzini@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

For direct EOI modality we will need to differentiate a userspace
masking from the IRQ handler auto-masking.

The level sensitive IRQ handler sets the automasked flag while
VFIO_DEVICE_SET_IRQS with VFIO_IRQ_SET_ACTION_MASK sets the
usermasked flag. VFIO_IRQ_SET_ACTION_UNMASK resets both flags.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- rename maked into usermasked
- add is_masked() macro
- commit message reworded to better explain role of each flag
- change commit title
---
 drivers/vfio/platform/vfio_platform_irq.c     | 18 ++++++++++--------
 drivers/vfio/platform/vfio_platform_private.h |  6 +++++-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 46d4750..6740dbe 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -29,9 +29,9 @@ static void vfio_platform_mask(struct vfio_platform_irq *irq_ctx)
 
 	spin_lock_irqsave(&irq_ctx->lock, flags);
 
-	if (!irq_ctx->masked) {
+	if (!is_masked(irq_ctx)) {
 		disable_irq_nosync(irq_ctx->hwirq);
-		irq_ctx->masked = true;
+		irq_ctx->usermasked = true;
 	}
 
 	spin_unlock_irqrestore(&irq_ctx->lock, flags);
@@ -89,9 +89,10 @@ static void vfio_platform_unmask(struct vfio_platform_irq *irq_ctx)
 
 	spin_lock_irqsave(&irq_ctx->lock, flags);
 
-	if (irq_ctx->masked) {
+	if (is_masked(irq_ctx)) {
 		enable_irq(irq_ctx->hwirq);
-		irq_ctx->masked = false;
+		irq_ctx->usermasked = false;
+		irq_ctx->automasked = false;
 	}
 
 	spin_unlock_irqrestore(&irq_ctx->lock, flags);
@@ -152,12 +153,12 @@ static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
 
 	spin_lock_irqsave(&irq_ctx->lock, flags);
 
-	if (!irq_ctx->masked) {
+	if (!is_masked(irq_ctx)) {
 		ret = IRQ_HANDLED;
 
 		/* automask maskable interrupts */
 		disable_irq_nosync(irq_ctx->hwirq);
-		irq_ctx->masked = true;
+		irq_ctx->automasked = true;
 	}
 
 	spin_unlock_irqrestore(&irq_ctx->lock, flags);
@@ -217,7 +218,7 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 		return ret;
 	}
 
-	if (!irq->masked)
+	if (!irq->usermasked)
 		enable_irq(irq->hwirq);
 
 	return 0;
@@ -314,7 +315,8 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 
 		vdev->irqs[i].count = 1;
 		vdev->irqs[i].hwirq = hwirq;
-		vdev->irqs[i].masked = false;
+		vdev->irqs[i].usermasked = false;
+		vdev->irqs[i].automasked = false;
 	}
 
 	vdev->num_irqs = cnt;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 85ffe5d..e8db291 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -33,7 +33,8 @@ struct vfio_platform_irq {
 	int			hwirq;
 	char			*name;
 	struct eventfd_ctx	*trigger;
-	bool			masked;
+	bool			usermasked;
+	bool			automasked;
 	spinlock_t		lock;
 	struct virqfd		*unmask;
 	struct virqfd		*mask;
@@ -102,6 +103,9 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 extern void __vfio_platform_register_reset(struct vfio_platform_reset_node *n);
 extern void vfio_platform_unregister_reset(const char *compat,
 					   vfio_platform_reset_fn_t fn);
+
+#define is_masked(irq) ((irq)->usermasked || (irq)->automasked)
+
 #define vfio_platform_register_reset(__compat, __reset)		\
 static struct vfio_platform_reset_node __reset ## _node = {	\
 	.owner = THIS_MODULE,					\
-- 
2.5.5
