From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 02/10] VFIO: platform: test forwarded state when selecting
 the IRQ handler
Date: Mon, 10 Aug 2015 15:20:56 +0200
Message-ID: <1439212864-12954-3-git-send-email-eric.auger@linaro.org>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CBC85A66B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:08:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TFnQLw4XX58R for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:08:54 -0400 (EDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
 [209.85.212.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71B4259F5E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:08:54 -0400 (EDT)
Received: by wicne3 with SMTP id ne3so135766472wic.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:21:54 -0700 (PDT)
In-Reply-To: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, feng.wu@intel.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a new forwarded flag in vfio_platform_irq.  In case the IRQ
is forwarded, the VFIO platform IRQ handler does not need to
disable the IRQ anymore.

When setting the IRQ handler we now also test the forwarded state. In
case the IRQ is forwarded we select the vfio_irq_handler.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2:
- add a new forwarded flag and do not use irqd_irq_forwarded anymore
---
 drivers/vfio/platform/vfio_platform_irq.c     | 3 ++-
 drivers/vfio/platform/vfio_platform_private.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index b5cb8c7..40f057a 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -262,7 +262,8 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 	struct vfio_platform_irq *irq = &vdev->irqs[index];
 	irq_handler_t handler;
 
-	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_AUTOMASKED)
+	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_AUTOMASKED &&
+			!irq->forwarded)
 		handler = vfio_automasked_irq_handler;
 	else
 		handler = vfio_irq_handler;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 1d2d4d6..8b4f814 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -39,6 +39,7 @@ struct vfio_platform_irq {
 	struct virqfd		*unmask;
 	struct virqfd		*mask;
 	struct irq_bypass_producer producer;
+	bool			forwarded;
 };
 
 struct vfio_platform_region {
-- 
1.9.1
