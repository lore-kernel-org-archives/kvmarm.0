From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 05/10] VFIO: pci: Introduce direct EOI INTx interrupt handler
Date: Wed, 24 May 2017 22:13:18 +0200
Message-ID: <1495656803-28011-6-git-send-email-eric.auger@redhat.com>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 553DE40C25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 16:10:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PCJNKTQzxKC8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 May 2017 16:10:13 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E27A40A74
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 16:10:13 -0400 (EDT)
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

We add two new fields in vfio_pci_irq_ctx struct: deoi and handler.
If deoi is set, this means the physical IRQ attached to the virtual
IRQ is directly deactivated by the guest and the VFIO driver does
not need to disable the physical IRQ and mask it at VFIO level.

The handler pointer is set accordingly and a wrapper handler is
introduced that calls the chosen handler function.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
---
 drivers/vfio/pci/vfio_pci_intrs.c   | 32 ++++++++++++++++++++++++++------
 drivers/vfio/pci/vfio_pci_private.h |  2 ++
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index d4d377b..06aa713 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -121,11 +121,8 @@ void vfio_pci_intx_unmask(struct vfio_pci_device *vdev)
 static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 {
 	struct vfio_pci_device *vdev = dev_id;
-	unsigned long flags;
 	int ret = IRQ_NONE;
 
-	spin_lock_irqsave(&vdev->irqlock, flags);
-
 	if (!vdev->pci_2_3) {
 		disable_irq_nosync(vdev->pdev->irq);
 		vdev->ctx[0].automasked = true;
@@ -137,14 +134,33 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 		ret = IRQ_HANDLED;
 	}
 
-	spin_unlock_irqrestore(&vdev->irqlock, flags);
-
 	if (ret == IRQ_HANDLED)
 		vfio_send_intx_eventfd(vdev, NULL);
 
 	return ret;
 }
 
+static irqreturn_t vfio_intx_handler_deoi(int irq, void *dev_id)
+{
+	struct vfio_pci_device *vdev = dev_id;
+
+	vfio_send_intx_eventfd(vdev, NULL);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t vfio_intx_wrapper_handler(int irq, void *dev_id)
+{
+	struct vfio_pci_device *vdev = dev_id;
+	unsigned long flags;
+	irqreturn_t ret;
+
+	spin_lock_irqsave(&vdev->irqlock, flags);
+	ret = vdev->ctx[0].handler(irq, dev_id);
+	spin_unlock_irqrestore(&vdev->irqlock, flags);
+
+	return ret;
+}
+
 static int vfio_intx_enable(struct vfio_pci_device *vdev)
 {
 	if (!is_irq_none(vdev))
@@ -208,7 +224,11 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 	if (!vdev->pci_2_3)
 		irqflags = 0;
 
-	ret = request_irq(pdev->irq, vfio_intx_handler,
+	if (vdev->ctx[0].deoi)
+		vdev->ctx[0].handler = vfio_intx_handler_deoi;
+	else
+		vdev->ctx[0].handler = vfio_intx_handler;
+	ret = request_irq(pdev->irq, vfio_intx_wrapper_handler,
 			  irqflags, vdev->ctx[0].name, vdev);
 	if (ret) {
 		vdev->ctx[0].trigger = NULL;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index f7f1101..5cfe59a 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -36,6 +36,8 @@ struct vfio_pci_irq_ctx {
 	char			*name;
 	bool			masked;
 	bool			automasked;
+	bool			deoi;
+	irqreturn_t		(*handler)(int irq, void *dev_id);
 	struct irq_bypass_producer	producer;
 };
 
-- 
2.5.5
