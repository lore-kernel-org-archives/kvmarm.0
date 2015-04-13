From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v6 02/16] VFIO: platform: test forwarded state when selecting
 IRQ handler
Date: Mon, 13 Apr 2015 14:29:17 +0200
Message-ID: <1428928171-18884-3-git-send-email-eric.auger@linaro.org>
References: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40C7C4C3DE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xh7Ncp5+mkzl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:24:49 -0400 (EDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
 [209.85.212.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DEAE4C3D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:48 -0400 (EDT)
Received: by widdi4 with SMTP id di4so70262847wid.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:32:35 -0700 (PDT)
In-Reply-To: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com
Cc: feng.wu@intel.com, linux-kernel@vger.kernel.org, patches@linaro.org
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
index 88bba57..132bb3f 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -229,8 +229,13 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
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
