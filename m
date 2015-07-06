From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 7/9] VFIO: platform: add irq bypass producer management
Date: Mon,  6 Jul 2015 15:24:41 +0200
Message-ID: <1436189083-32527-8-git-send-email-eric.auger@linaro.org>
References: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, alex.williamson@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch populates the IRQ bypass callacks:
- stop/resume producer simply consist in disabling/enabling the host irq
- add/del consumer: basically set the automasked flag to false/true
- update remains void

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- device handle caching in vfio_platform_device is introduced in a
  separate patch
- use container_of
---
 drivers/vfio/platform/vfio_platform_irq.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index d00ed24..7dc17a6 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -222,22 +222,49 @@ static int vfio_platform_is_active(struct vfio_platform_irq *irq)
 
 static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
 {
+	disable_irq(prod->irq);
 }
 
 static void vfio_platform_irq_bypass_resume(struct irq_bypass_producer *prod)
 {
+	enable_irq(prod->irq);
 }
 
 static void vfio_platform_irq_bypass_add_consumer(
 			struct irq_bypass_producer *prod,
 			struct irq_bypass_consumer *cons)
 {
+	int ret;
+	struct vfio_platform_irq *irq =
+		container_of(prod, struct vfio_platform_irq, producer);
+
+	//TODO
+	/*
+	 * if the IRQ is active at irqchip level or VFIO (auto)masked
+	 * this means the host IRQ is already under injection in the
+	 * guest and this not safe to change the forwarding state at
+	 * that stage.
+	 * It is not possible to differentiate user-space masking
+	 * from auto-masking, leading to possible false detection of
+	 * active state.
+	 */
+	prod->active = vfio_platform_is_active(irq);
+
+	ret = vfio_platform_set_automasked(irq, false);
+	WARN_ON(ret);
 }
 
 static void vfio_platform_irq_bypass_del_consumer(
 			struct irq_bypass_producer *prod,
 			struct irq_bypass_consumer *cons)
 {
+	struct vfio_platform_irq *irq =
+		container_of(prod, struct vfio_platform_irq, producer);
+
+	if (prod->active)
+		vfio_platform_mask(irq);
+
+	vfio_platform_set_automasked(irq, true);
 }
 
 static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
-- 
1.9.1
