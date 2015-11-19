From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 06/13] VFIO: platform: add vfio_platform_irq_is_active
Date: Thu, 19 Nov 2015 14:53:56 +0000
Message-ID: <1447944843-17731-7-git-send-email-eric.auger@linaro.org>
References: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3792F49761
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VEyqnjauhWFS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2015 09:53:43 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C91449A19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:41 -0500 (EST)
Received: by wmvv187 with SMTP id v187so29523571wmv.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 06:54:21 -0800 (PST)
In-Reply-To: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This function returns whether the IRQ is active at irqchip level or
VFIO masked. If either is true, the IRQ is considered active.
Currently there is no way to differentiate userspace masked IRQ from
automasked IRQ. There might be false detection of activity. However
it is currently acceptable to have false detection.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v3 -> v4:
- rename vfio_platform_is_active into vfio_platform_irq_is_active
- remove BUG_ON and return the error if irq_get_irqchip_state fails
---
 drivers/vfio/platform/vfio_platform_irq.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 257200b..cb7d5e9 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -203,6 +203,25 @@ static int vfio_platform_set_forwarded(struct vfio_platform_irq *irq,
 	return 0;
 }
 
+static int vfio_platform_irq_is_active(struct vfio_platform_irq *irq)
+{
+	unsigned long flags;
+	bool active;
+	int ret;
+
+	spin_lock_irqsave(&irq->lock, flags);
+
+	ret = irq_get_irqchip_state(irq->hwirq, IRQCHIP_STATE_ACTIVE, &active);
+	if (ret)
+		goto out;
+
+	ret = active || irq->masked;
+
+out:
+	spin_unlock_irqrestore(&irq->lock, flags);
+	return ret;
+}
+
 static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
 {
 }
-- 
1.9.1
