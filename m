From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 5/9] VFIO: platform: add vfio_platform_is_active
Date: Mon,  6 Jul 2015 15:24:39 +0200
Message-ID: <1436189083-32527-6-git-send-email-eric.auger@linaro.org>
References: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, alex.williamson@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This function returns whether the IRQ is active at irqchip level or
VFIO masked. If either is true, it is considered the IRQ is active.
Currently there is no way to differentiate userspace masked IRQ from
automasked IRQ. There might be false detection of activity. However
it is currently acceptable to have false detection.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
---
 drivers/vfio/platform/vfio_platform_irq.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index aa540db..d00ed24 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -203,6 +203,23 @@ static int vfio_platform_set_automasked(struct vfio_platform_irq *irq,
 	return 0;
 }
 
+static int vfio_platform_is_active(struct vfio_platform_irq *irq)
+{
+	unsigned long flags;
+	bool active, masked, outstanding;
+	int ret;
+
+	spin_lock_irqsave(&irq->lock, flags);
+
+	ret = irq_get_irqchip_state(irq->hwirq, IRQCHIP_STATE_ACTIVE, &active);
+	BUG_ON(ret);
+	masked = irq->masked;
+	outstanding = active || masked;
+
+	spin_unlock_irqrestore(&irq->lock, flags);
+	return outstanding;
+}
+
 static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
 {
 }
-- 
1.9.1
