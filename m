From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 07/10] VFIO: pci: Direct EOI irq bypass for ARM/ARM64
Date: Wed, 24 May 2017 22:13:20 +0200
Message-ID: <1495656803-28011-8-git-send-email-eric.auger@redhat.com>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6726740992
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 16:10:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EaatGF99eXvK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 May 2017 16:10:22 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1DAC240C58
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 16:10:22 -0400 (EDT)
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

Current architectures use irq bypass negotiation for MSI only and
the existing irq bypass producer does not implement any callback.

On ARM/ARM64 we would like to setup direct EOI for shared peripheral
interrupts and this requires specific callbacks to be implemented.

We introduce a new VFIO_PCI_IRQ_BYPASS_DEOI config that is set
only for ARM/ARM64. A new vfio_pci_irq_bypass.c file contains the
implementation of the DEOI callbacks. The code is not so much
ARM tainted, hence the choice of making it as generic as possible:

- stop/start: disable/enable the host irq
- add/del consumer: set the VFIO Direct EOI mode, ie. select the
  adapted physical IRQ handler (automasked or not automasked).

The DEOI bypass producer only is registered for ARM/ARM64 for INTx
interrupts.

Other architectures use vfio_register_default_producer for MSIs
only.

we also include vfio.h in vfio_pci_private as this latter is not
self-contained.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
---
 drivers/vfio/pci/Kconfig               |   4 +
 drivers/vfio/pci/Makefile              |   1 +
 drivers/vfio/pci/vfio_pci_intrs.c      |  31 ++++++--
 drivers/vfio/pci/vfio_pci_irq_bypass.c | 134 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h    |  32 ++++++++
 5 files changed, 195 insertions(+), 7 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_irq_bypass.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 24ee260..5b66d48 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -30,3 +30,7 @@ config VFIO_PCI_INTX
 config VFIO_PCI_IGD
 	depends on VFIO_PCI
 	def_bool y if X86
+
+config VFIO_PCI_IRQ_BYPASS_DEOI
+	depends on VFIO_PCI && (ARM || ARM64)
+	def_bool y if (ARM || ARM64)
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 76d8ec0..5836ea6 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,5 +1,6 @@
 
 vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
+vfio-pci-y += vfio_pci_irq_bypass.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 06aa713..344147e 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -161,6 +161,23 @@ static irqreturn_t vfio_intx_wrapper_handler(int irq, void *dev_id)
 	return ret;
 }
 
+/* must be called with vdev->irqlock held */
+int vfio_pci_set_deoi(struct vfio_pci_device *vdev,
+		      struct vfio_pci_irq_ctx *irq_ctx, bool deoi)
+{
+	if (!is_intx(vdev))
+		return -EINVAL;
+
+	irq_ctx->deoi = deoi;
+
+	if (deoi)
+		irq_ctx->handler = vfio_intx_handler_deoi;
+	else
+		irq_ctx->handler = vfio_intx_handler;
+
+	return 0;
+}
+
 static int vfio_intx_enable(struct vfio_pci_device *vdev)
 {
 	if (!is_irq_none(vdev))
@@ -200,6 +217,7 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 
 	if (vdev->ctx[0].trigger) {
 		free_irq(pdev->irq, vdev);
+		irq_bypass_unregister_producer(&vdev->ctx[0].producer);
 		kfree(vdev->ctx[0].name);
 		eventfd_ctx_put(vdev->ctx[0].trigger);
 		vdev->ctx[0].trigger = NULL;
@@ -237,6 +255,10 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 		return ret;
 	}
 
+	if (vfio_pci_has_deoi())
+		vfio_pci_register_deoi_producer(vdev, vdev->ctx,
+						trigger, pdev->irq);
+
 	/*
 	 * INTx disable will stick across the new irq setup,
 	 * disable_irq won't.
@@ -364,13 +386,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 		return ret;
 	}
 
-	vdev->ctx[vector].producer.token = trigger;
-	vdev->ctx[vector].producer.irq = irq;
-	ret = irq_bypass_register_producer(&vdev->ctx[vector].producer);
-	if (unlikely(ret))
-		dev_info(&pdev->dev,
-		"irq bypass producer (token %p) registration fails: %d\n",
-		vdev->ctx[vector].producer.token, ret);
+	vfio_pci_register_default_producer(vdev, &vdev->ctx[vector],
+					   trigger, irq);
 
 	vdev->ctx[vector].trigger = trigger;
 
diff --git a/drivers/vfio/pci/vfio_pci_irq_bypass.c b/drivers/vfio/pci/vfio_pci_irq_bypass.c
new file mode 100644
index 0000000..447fa60
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_irq_bypass.c
@@ -0,0 +1,134 @@
+/*
+ * VFIO PCI device irqbypass callback implementation for DEOI
+ *
+ * Copyright (C) 2017 Red Hat, Inc.  All rights reserved.
+ * Author: Eric Auger <eric.auger@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/irqbypass.h>
+#include "vfio_pci_private.h"
+
+#ifdef CONFIG_VFIO_PCI_IRQ_BYPASS_DEOI
+
+static inline void irq_bypass_deoi_start(struct irq_bypass_producer *prod)
+{
+	enable_irq(prod->irq);
+}
+
+static inline void irq_bypass_deoi_stop(struct irq_bypass_producer *prod)
+{
+	disable_irq(prod->irq);
+}
+
+/**
+ * irq_bypass_deoi_add_consumer - turns direct EOI on
+ *
+ * The linux irq is disabled when the function is called.
+ * The operation succeeds only if the irq is not active at irqchip level
+ * and not automasked at VFIO level, meaning the IRQ is not under injection
+ * into the guest.
+ */
+static int irq_bypass_deoi_add_consumer(struct irq_bypass_producer *prod,
+					struct irq_bypass_consumer *cons)
+{
+	struct vfio_pci_device *vdev = (struct vfio_pci_device *)prod->private;
+	struct vfio_pci_irq_ctx *irq_ctx =
+		container_of(prod, struct vfio_pci_irq_ctx, producer);
+	unsigned long flags;
+	bool active;
+	int ret;
+
+	spin_lock_irqsave(&vdev->irqlock, flags);
+
+	ret = irq_get_irqchip_state(prod->irq, IRQCHIP_STATE_ACTIVE,
+				    &active);
+	WARN_ON(ret);
+	if (ret)
+		goto out;
+
+	if (active || irq_ctx->automasked) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	ret = vfio_pci_set_deoi(vdev, irq_ctx, true);
+out:
+	spin_unlock_irqrestore(&vdev->irqlock, flags);
+	return ret;
+}
+
+static void irq_bypass_deoi_del_consumer(struct irq_bypass_producer *prod,
+					 struct irq_bypass_consumer *cons)
+{
+	struct vfio_pci_device *vdev = (struct vfio_pci_device *)prod->private;
+	struct vfio_pci_irq_ctx *irq_ctx =
+		container_of(prod, struct vfio_pci_irq_ctx, producer);
+	unsigned long flags;
+
+	spin_lock_irqsave(&vdev->irqlock, flags);
+	vfio_pci_set_deoi(vdev, irq_ctx, false);
+	spin_unlock_irqrestore(&vdev->irqlock, flags);
+}
+
+bool vfio_pci_has_deoi(void)
+{
+	return true;
+}
+
+void vfio_pci_register_deoi_producer(struct vfio_pci_device *vdev,
+				     struct vfio_pci_irq_ctx *irq_ctx,
+				     struct eventfd_ctx *trigger,
+				     unsigned int irq)
+{
+	struct irq_bypass_producer *prod = &irq_ctx->producer;
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+
+	prod->token =		trigger;
+	prod->irq =		irq;
+	prod->private =		vdev;
+	prod->add_consumer =	irq_bypass_deoi_add_consumer;
+	prod->del_consumer =	irq_bypass_deoi_del_consumer;
+	prod->stop =		irq_bypass_deoi_stop;
+	prod->start =		irq_bypass_deoi_start;
+
+	ret = irq_bypass_register_producer(prod);
+	if (unlikely(ret))
+		dev_info(&pdev->dev,
+		"irq bypass producer (token %p) registration fails for irq %s: %d\n",
+		prod->token, irq_ctx->name, ret);
+}
+
+#endif /* DEOI */
+
+void vfio_pci_register_default_producer(struct vfio_pci_device *vdev,
+					struct vfio_pci_irq_ctx *irq_ctx,
+					struct eventfd_ctx *trigger,
+					unsigned int irq)
+{
+	struct irq_bypass_producer *prod = &irq_ctx->producer;
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+
+	prod->token =	trigger;
+	prod->irq =	irq;
+	prod->private = vdev;
+
+	ret = irq_bypass_register_producer(prod);
+	if (unlikely(ret))
+		dev_info(&pdev->dev,
+		"irq bypass producer (token %p) registration fails for irq %s: %d\n",
+		prod->token, irq_ctx->name, ret);
+}
+
+
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 5cfe59a..adc1ba2 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -15,6 +15,7 @@
 #include <linux/pci.h>
 #include <linux/irqbypass.h>
 #include <linux/types.h>
+#include <linux/vfio.h>
 
 #ifndef VFIO_PCI_PRIVATE_H
 #define VFIO_PCI_PRIVATE_H
@@ -133,6 +134,10 @@ extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 					unsigned int type, unsigned int subtype,
 					const struct vfio_pci_regops *ops,
 					size_t size, u32 flags, void *data);
+
+extern int vfio_pci_set_deoi(struct vfio_pci_device *vdev,
+			     struct vfio_pci_irq_ctx *irq_ctx, bool deoi);
+
 #ifdef CONFIG_VFIO_PCI_IGD
 extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
 #else
@@ -141,4 +146,31 @@ static inline int vfio_pci_igd_init(struct vfio_pci_device *vdev)
 	return -ENODEV;
 }
 #endif
+
+#ifdef CONFIG_VFIO_PCI_IRQ_BYPASS_DEOI
+/*
+ * Architecture specific irqbypass producer callbacks
+ */
+bool vfio_pci_has_deoi(void);
+void vfio_pci_register_deoi_producer(struct vfio_pci_device *vdev,
+				     struct vfio_pci_irq_ctx *irq_ctx,
+				     struct eventfd_ctx *trigger,
+				     unsigned int irq);
+#else
+static inline bool vfio_pci_has_deoi(void)
+{
+	return false;
+}
+static inline
+void vfio_pci_register_deoi_producer(struct vfio_pci_device *vdev,
+				     struct vfio_pci_irq_ctx *irq_ctx,
+				     struct eventfd_ctx *trigger,
+				     unsigned int irq) {}
+#endif
+
+void vfio_pci_register_default_producer(struct vfio_pci_device *vdev,
+					struct vfio_pci_irq_ctx *irq_ctx,
+					struct eventfd_ctx *trigger,
+					unsigned int irq);
+
 #endif /* VFIO_PCI_PRIVATE_H */
-- 
2.5.5
