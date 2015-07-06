From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 4/9] VFIO: platform: add vfio_platform_set_automasked
Date: Mon,  6 Jul 2015 15:24:38 +0200
Message-ID: <1436189083-32527-5-git-send-email-eric.auger@linaro.org>
References: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C731357BC7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 09:13:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 89sm9yQ6Tfb2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 09:13:49 -0400 (EDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E825E57BC3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 09:13:48 -0400 (EDT)
Received: by wiga1 with SMTP id a1so228807522wig.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2015 06:25:15 -0700 (PDT)
In-Reply-To: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: pbonzini@redhat.com, alex.williamson@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This function makes possible to change the automasked mode.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
---
 drivers/vfio/platform/vfio_platform_irq.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 7f8d27c..aa540db 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -186,6 +186,23 @@ static irqreturn_t vfio_handler(int irq, void *dev_id)
 	return ret;
 }
 
+static int vfio_platform_set_automasked(struct vfio_platform_irq *irq,
+					   bool automasked)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq->lock, flags);
+	if (automasked) {
+		irq->flags |= VFIO_IRQ_INFO_AUTOMASKED;
+		irq->handler = vfio_automasked_irq_handler;
+	} else {
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
