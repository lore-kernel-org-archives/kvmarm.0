From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 05/10] VFIO: platform: add vfio_platform_is_active
Date: Mon, 10 Aug 2015 15:20:59 +0200
Message-ID: <1439212864-12954-6-git-send-email-eric.auger@linaro.org>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5258E5A696
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:09:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Hwx+0n26acZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:08:59 -0400 (EDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3989A5A690
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:08:58 -0400 (EDT)
Received: by wicja10 with SMTP id ja10so25457921wic.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:21:59 -0700 (PDT)
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
index a285384..efaee58 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -205,6 +205,23 @@ static int vfio_platform_set_automasked(struct vfio_platform_irq *irq,
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
