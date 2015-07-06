From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 2/9] VFIO: platform: test forwarded state when selecting IRQ handler
Date: Mon,  6 Jul 2015 15:24:36 +0200
Message-ID: <1436189083-32527-3-git-send-email-eric.auger@linaro.org>
References: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, alex.williamson@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

In case the IRQ is forwarded, the VFIO platform IRQ handler does not
need to disable the IRQ anymore.

When setting the IRQ handler we now also test the forwarded state. In
case the IRQ is forwarded we select the vfio_irq_handler.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v3 -> v4:
- change title

v2 -> v3:
- forwarded state was tested in the handler. Now the forwarded state
  is tested before setting the handler. This definitively limits
  the dynamics of forwarded state changes but I don't think there is
  a use case where we need to be able to change the state at any time.

Conflicts:
	drivers/vfio/platform/vfio_platform_irq.c
---
 drivers/vfio/platform/vfio_platform_irq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 4b059bf..e39f795 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -260,8 +260,13 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 {
 	struct vfio_platform_irq *irq = &vdev->irqs[index];
 	irq_handler_t handler;
+	struct irq_data *d;
+	bool is_forwarded;
 
-	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_AUTOMASKED)
+	d = irq_get_irq_data(irq->hwirq);
+	is_forwarded = irqd_irq_forwarded(d);
+
+	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_AUTOMASKED && !is_forwarded)
 		handler = vfio_automasked_irq_handler;
 	else
 		handler = vfio_irq_handler;
-- 
1.9.1

