From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 06/10] VFIO: platform: add irq bypass producer management
Date: Mon, 10 Aug 2015 15:21:00 +0200
Message-ID: <1439212864-12954-7-git-send-email-eric.auger@linaro.org>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C3025A697
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:09:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ijnMauS+KWpH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:09:00 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 812565A677
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:09:00 -0400 (EDT)
Received: by wicne3 with SMTP id ne3so21958688wic.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:22:01 -0700 (PDT)
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

This patch populates the IRQ bypass callacks:
- stop/start producer simply consist in disabling/enabling the host irq
- add/del consumer: basically set the automasked flag to false/true

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
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
 drivers/vfio/platform/vfio_platform_irq.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index efaee58..400a188 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -224,23 +224,44 @@ static int vfio_platform_is_active(struct vfio_platform_irq *irq)
 
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
+
+	/*
+	 * if the IRQ is active at irqchip level or VFIO (auto)masked
+	 * this means the host IRQ is already under injection in the
+	 * guest and this not safe to change the forwarding state at
+	 * that stage.
+	 * It is not possible to differentiate user-space masking
+	 * from auto-masking, leading to possible false detection of
+	 * active state.
+	 */
+	if (vfio_platform_is_active(irq))
+		return -EAGAIN;
+
+	return vfio_platform_set_automasked(irq, false);
 }
 
 static void vfio_platform_irq_bypass_del_consumer(
 			struct irq_bypass_producer *prod,
 			struct irq_bypass_consumer *cons)
 {
+	struct vfio_platform_irq *irq =
+		container_of(prod, struct vfio_platform_irq, producer);
+
+	vfio_platform_set_automasked(irq, true);
 }
 
 static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
-- 
1.9.1
