From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 7/8] virt: irqbypass: Add a type field to the irqbypass
 producer
Date: Thu, 15 Jun 2017 14:52:39 +0200
Message-ID: <1497531160-29162-8-git-send-email-eric.auger@redhat.com>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4B0140D77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jun 2017 08:50:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AAQKJfY6nrVY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jun 2017 08:50:55 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB36E40D68
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jun 2017 08:50:54 -0400 (EDT)
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

On ARM, we are about to introduce a vfio-platform producer. The
associated architecture specific consumer only is compatible with
this producer and does not work with the dummy vfio-pci msi producer.

Adding a type to the producer allows to easily discriminate between
producers instead of complexifying things by analyzing the interrupt
type.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v2: new
---
 drivers/vfio/pci/vfio_pci_intrs.c                | 1 +
 drivers/vfio/platform/vfio_platform_irq_bypass.c | 1 +
 include/linux/irqbypass.h                        | 7 +++++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 1c46045..40a6b21 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -343,6 +343,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 
 	vdev->ctx[vector].producer.token = trigger;
 	vdev->ctx[vector].producer.irq = irq;
+	vdev->ctx[vector].producer.type = IRQ_BYPASS_VFIO_PCI_MSI;
 	ret = irq_bypass_register_producer(&vdev->ctx[vector].producer);
 	if (unlikely(ret))
 		dev_info(&pdev->dev,
diff --git a/drivers/vfio/platform/vfio_platform_irq_bypass.c b/drivers/vfio/platform/vfio_platform_irq_bypass.c
index 692b081..603b4b3 100644
--- a/drivers/vfio/platform/vfio_platform_irq_bypass.c
+++ b/drivers/vfio/platform/vfio_platform_irq_bypass.c
@@ -102,6 +102,7 @@ void vfio_platform_register_deoi_producer(struct vfio_platform_device *vdev,
 
 	prod->token =		trigger;
 	prod->irq =		host_irq;
+	prod->type =		IRQ_BYPASS_VFIO_PLATFORM;
 	prod->add_consumer =	irq_bypass_deoi_add_consumer;
 	prod->del_consumer =	irq_bypass_deoi_del_consumer;
 	prod->stop =		irq_bypass_deoi_stop;
diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index f0f5d26..331c19a 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -31,11 +31,17 @@ struct irq_bypass_consumer;
  * are not supported.
  */
 
+enum irq_bypass_producer_type {
+	IRQ_BYPASS_VFIO_PCI_MSI,
+	IRQ_BYPASS_VFIO_PLATFORM,
+};
+
 /**
  * struct irq_bypass_producer - IRQ bypass producer definition
  * @node: IRQ bypass manager private list management
  * @token: opaque token to match between producer and consumer (non-NULL)
  * @irq: Linux IRQ number for the producer device
+ * @type: type of the producer to easily assess interoperability with consumer
  * @add_consumer: Connect the IRQ producer to an IRQ consumer (optional)
  * @del_consumer: Disconnect the IRQ producer from an IRQ consumer (optional)
  * @stop: Perform any quiesce operations necessary prior to add/del (optional)
@@ -49,6 +55,7 @@ struct irq_bypass_producer {
 	struct list_head node;
 	void *token;
 	int irq;
+	enum irq_bypass_producer_type type;
 	int (*add_consumer)(struct irq_bypass_producer *,
 			    struct irq_bypass_consumer *);
 	void (*del_consumer)(struct irq_bypass_producer *,
-- 
2.5.5
