From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 05/13] VFIO: platform: add vfio_platform_set_forwarded
Date: Thu, 19 Nov 2015 14:53:55 +0000
Message-ID: <1447944843-17731-6-git-send-email-eric.auger@linaro.org>
References: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This function allows to change the forwarded mode and selects
the IRQ handler accordingly.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v3 -> v3:
- renamed vfio_platform_set_automasked into
  vfio_platform_set_forwarded
- do not change VFIO_IRQ_INFO_AUTOMASKED setting when turning
  forwarding on/off

v1 -> v2:
- set forwarded flag
---
 drivers/vfio/platform/vfio_platform_irq.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index c58e0ad..257200b 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -186,6 +186,23 @@ static irqreturn_t vfio_handler(int irq, void *dev_id)
 	return ret;
 }
 
+static int vfio_platform_set_forwarded(struct vfio_platform_irq *irq,
+					   bool forwarded)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq->lock, flags);
+	irq->forwarded = forwarded;
+
+	if (!forwarded && (irq->flags & VFIO_IRQ_INFO_AUTOMASKED))
+		irq->handler = vfio_automasked_irq_handler;
+	else
+		irq->handler = vfio_irq_handler;
+
+	spin_unlock_irqrestore(&irq->lock, flags);
+	return 0;
+}
+
 static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
 {
 }
-- 
1.9.1
