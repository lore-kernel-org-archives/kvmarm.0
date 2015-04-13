From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v6 08/16] VFIO: platform: implement vfio_device_external_ops
 callbacks
Date: Mon, 13 Apr 2015 14:29:23 +0200
Message-ID: <1428928171-18884-9-git-send-email-eric.auger@linaro.org>
References: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 327184C3F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:25:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S00aN63XcVGH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:25:00 -0400 (EDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
 [209.85.212.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BC634C402
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:58 -0400 (EDT)
Received: by wiax7 with SMTP id x7so63536912wia.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:32:45 -0700 (PDT)
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

This patch adds the implementation for the 3 external callbacks of
vfio_device_external_ops struct, namely active, is_active,
set_automasked. Also vfio_device_ops and vfio_device_external_ops are
set accordingly.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v6: creation
---
 drivers/vfio/platform/vfio_platform_common.c  |  7 ++++
 drivers/vfio/platform/vfio_platform_irq.c     | 49 +++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h | 11 ++++++
 3 files changed, 67 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index abcff7a..4113d46 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -471,6 +471,12 @@ static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
 	return -EINVAL;
 }
 
+static struct vfio_device_external_ops vfio_platform_external_ops = {
+	.mask		= vfio_platform_external_mask,
+	.is_active	= vfio_platform_external_is_active,
+	.set_automasked	= vfio_platform_external_set_automasked,
+};
+
 static const struct vfio_device_ops vfio_platform_ops = {
 	.name		= "vfio-platform",
 	.open		= vfio_platform_open,
@@ -479,6 +485,7 @@ static const struct vfio_device_ops vfio_platform_ops = {
 	.read		= vfio_platform_read,
 	.write		= vfio_platform_write,
 	.mmap		= vfio_platform_mmap,
+	.external_ops	= &vfio_platform_external_ops
 };
 
 int vfio_platform_probe_common(struct vfio_platform_device *vdev,
diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 8eb65c1..f6d83ed 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -231,6 +231,55 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 	return 0;
 }
 
+int vfio_platform_external_mask(void *device_data, unsigned index,
+				 unsigned start, unsigned count)
+{
+	struct vfio_platform_device *vdev = device_data;
+
+	vfio_platform_mask(&vdev->irqs[index]);
+	return 0;
+}
+
+int vfio_platform_external_is_active(void *device_data, unsigned index,
+				      unsigned start, unsigned count)
+{
+	unsigned long flags;
+	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_irq *irq = &vdev->irqs[index];
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
+int vfio_platform_external_set_automasked(void *device_data, unsigned index,
+					   unsigned start, unsigned count,
+					   bool automasked)
+{
+	unsigned long flags;
+	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_irq *irq = &vdev->irqs[index];
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
 static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 					 unsigned index, unsigned start,
 					 unsigned count, uint32_t flags,
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index eb91deb..253caa3 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -83,4 +83,15 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 					unsigned start, unsigned count,
 					void *data);
 
+extern int vfio_platform_external_mask(void *device_data, unsigned index,
+				       unsigned start, unsigned count);
+extern int vfio_platform_external_is_active(void *device_data,
+					    unsigned index, unsigned start,
+					    unsigned count);
+extern int vfio_platform_external_set_automasked(void *device_data,
+						 unsigned index,
+						 unsigned start,
+						 unsigned count,
+						 bool automasked);
+
 #endif /* VFIO_PLATFORM_PRIVATE_H */
-- 
1.9.1
