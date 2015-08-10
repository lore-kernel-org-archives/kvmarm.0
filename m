From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 04/10] VFIO: platform: add vfio_platform_set_automasked
Date: Mon, 10 Aug 2015 15:20:58 +0200
Message-ID: <1439212864-12954-5-git-send-email-eric.auger@linaro.org>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D7455A66D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:08:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XM29WbCxHlvT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:08:58 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6636D5A67E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:08:57 -0400 (EDT)
Received: by wibhh20 with SMTP id hh20so150555189wib.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:21:58 -0700 (PDT)
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

This function makes possible to change the automasked mode.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- set forwarded flag
---
 drivers/vfio/platform/vfio_platform_irq.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index b31b1f0..a285384 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -186,6 +186,25 @@ static irqreturn_t vfio_handler(int irq, void *dev_id)
 	return ret;
 }
 
+static int vfio_platform_set_automasked(struct vfio_platform_irq *irq,
+					   bool automasked)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq->lock, flags);
+	if (automasked) {
+		irq->forwarded = true;
+		irq->flags |= VFIO_IRQ_INFO_AUTOMASKED;
+		irq->handler = vfio_automasked_irq_handler;
+	} else {
+		irq->forwarded = false;
+		irq->flags &= ~VFIO_IRQ_INFO_AUTOMASKED;
+		irq->handler = vfio_irq_handler;
+	}
+	spin_unlock_irqrestore(&irq->lock, flags);
+	return 0;
+}
+
 static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
 {
 }
-- 
1.9.1
