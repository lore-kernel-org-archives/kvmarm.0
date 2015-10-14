From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH] VFIO: platform: clear IRQ_NOAUTOEN when de-assigning the IRQ
Date: Wed, 14 Oct 2015 15:32:56 +0000
Message-ID: <1444836776-2364-1-git-send-email-eric.auger@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com, christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

The vfio platform driver currently sets the IRQ_NOAUTOEN before
doing the request_irq to properly handle the user masking. However
it does not clear it when de-assigning the IRQ. This brings issues
when loading the native driver again which may not explicitly enable
the IRQ. This problem was observed with xgbe driver.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/platform/vfio_platform_irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 88bba57..46d4750 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -185,6 +185,7 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 	int ret;
 
 	if (irq->trigger) {
+		irq_clear_status_flags(irq->hwirq, IRQ_NOAUTOEN);
 		free_irq(irq->hwirq, irq);
 		kfree(irq->name);
 		eventfd_ctx_put(irq->trigger);
-- 
1.9.1
