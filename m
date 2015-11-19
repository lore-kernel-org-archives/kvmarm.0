From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 07/13] VFIO: platform: add irq bypass producer management
Date: Thu, 19 Nov 2015 14:53:57 +0000
Message-ID: <1447944843-17731-8-git-send-email-eric.auger@linaro.org>
References: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch populates the IRQ bypass callacks:
- stop/start producer simply consist in disabling/enabling the host irq
- add/del consumer: basically set the automasked flag to false/true

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v3 -> v4:
- use vfio_platform_set_forwarded in place of vfio_platform_set_automasked
- use vfio_platform_irq_is_active and its returned value
- reword comments related to auto/explicit VFIO masking

v2 -> v3:
- vfio_platform_irq_bypass_add_consumer now returns an error in case
  the IRQ is recognized as active
- active boolean not set anymore
- do not VFIO mask the IRQ anymore on unforward

v1 -> v2:
- device handle caching in vfio_platform_device is introduced in a
  separate patch
- use container_of
---
 drivers/vfio/platform/vfio_platform_irq.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index cb7d5e9..e486c32 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -224,23 +224,49 @@ out:
 
 static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
 {
+	disable_irq(prod->irq);
 }
 
 static void vfio_platform_irq_bypass_start(struct irq_bypass_producer *prod)
 {
+	enable_irq(prod->irq);
 }
 
 static int vfio_platform_irq_bypass_add_consumer(
 			struct irq_bypass_producer *prod,
 			struct irq_bypass_consumer *cons)
 {
-	return 0;
+	struct vfio_platform_irq *irq =
+		container_of(prod, struct vfio_platform_irq, producer);
+	int ret;
+
+	/*
+	 * if the IRQ is active at irqchip level or masked by VFIO
+	 * this means the host IRQ may be under injection and
+	 * it is not safe to change the forwarding state at that time.
+	 * It is not possible to discriminate VFIO explicit masking
+	 * from VFIO auto-masking, leading to possible false detection of
+	 * IRQ activity. It is up to the user-space to avoid VFIO explicit
+	 * masking situation. In case of failure, no retry is attempted and
+	 * bypass setup simply fails.
+	 */
+	ret = vfio_platform_irq_is_active(irq);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		return -EAGAIN;
+
+	return vfio_platform_set_forwarded(irq, true);
 }
 
 static void vfio_platform_irq_bypass_del_consumer(
 			struct irq_bypass_producer *prod,
 			struct irq_bypass_consumer *cons)
 {
+	struct vfio_platform_irq *irq =
+		container_of(prod, struct vfio_platform_irq, producer);
+
+	vfio_platform_set_forwarded(irq, false);
 }
 
 static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
-- 
1.9.1

