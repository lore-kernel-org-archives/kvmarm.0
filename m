From: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v4 2/3] vfio-pci: Add new function for INTx one-time
 initialisation
Date: Mon,  8 Apr 2019 09:27:18 +0800
Message-ID: <20190408012719.16158-3-leo.yan@linaro.org>
References: <20190408012719.16158-1-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F89C4A321
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:27:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5NnNPYaVW9Po for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Apr 2019 21:27:53 -0400 (EDT)
Received: from mail-yb1-f194.google.com (mail-yb1-f194.google.com
 [209.85.219.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BB714A319
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:27:53 -0400 (EDT)
Received: by mail-yb1-f194.google.com with SMTP id i10so4569827ybk.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 07 Apr 2019 18:27:53 -0700 (PDT)
In-Reply-To: <20190408012719.16158-1-leo.yan@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Will Deacon <Will.Deacon@arm.com>, Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Robin Murphy <Robin.Murphy@arm.com>
Cc: Leo Yan <leo.yan@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

To support INTx enabling for multiple times, we need firstly to extract
one-time initialisation and move the related code into a new function
vfio_pci_init_intx(); if later disable and re-enable the INTx, we can
skip these one-time operations.

This patch move below three main operations for INTx one-time
initialisation from function vfio_pci_enable_intx() into function
vfio_pci_init_intx():

- Reserve 2 FDs for INTx;
- Sanity check with ioctl VFIO_DEVICE_GET_IRQ_INFO;
- Setup pdev->intx_gsi.

Suggested-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 vfio/pci.c | 67 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index 5224fee..3c39844 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -1018,30 +1018,7 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 	struct vfio_irq_eventfd	trigger;
 	struct vfio_irq_eventfd	unmask;
 	struct vfio_pci_device *pdev = &vdev->pci;
-	int gsi = pdev->hdr.irq_line - KVM_IRQ_OFFSET;
-
-	struct vfio_irq_info irq_info = {
-		.argsz = sizeof(irq_info),
-		.index = VFIO_PCI_INTX_IRQ_INDEX,
-	};
-
-	vfio_pci_reserve_irq_fds(2);
-
-	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
-	if (ret || irq_info.count == 0) {
-		vfio_dev_err(vdev, "no INTx reported by VFIO");
-		return -ENODEV;
-	}
-
-	if (!(irq_info.flags & VFIO_IRQ_INFO_EVENTFD)) {
-		vfio_dev_err(vdev, "interrupt not eventfd capable");
-		return -EINVAL;
-	}
-
-	if (!(irq_info.flags & VFIO_IRQ_INFO_AUTOMASKED)) {
-		vfio_dev_err(vdev, "INTx interrupt not AUTOMASKED");
-		return -EINVAL;
-	}
+	int gsi = pdev->intx_gsi;
 
 	/*
 	 * PCI IRQ is level-triggered, so we use two eventfds. trigger_fd
@@ -1097,8 +1074,6 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 
 	pdev->intx_fd = trigger_fd;
 	pdev->unmask_fd = unmask_fd;
-	/* Guest is going to ovewrite our irq_line... */
-	pdev->intx_gsi = gsi;
 
 	return 0;
 
@@ -1117,6 +1092,39 @@ err_close:
 	return ret;
 }
 
+static int vfio_pci_init_intx(struct kvm *kvm, struct vfio_device *vdev)
+{
+	int ret;
+	struct vfio_pci_device *pdev = &vdev->pci;
+	struct vfio_irq_info irq_info = {
+		.argsz = sizeof(irq_info),
+		.index = VFIO_PCI_INTX_IRQ_INDEX,
+	};
+
+	vfio_pci_reserve_irq_fds(2);
+
+	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
+	if (ret || irq_info.count == 0) {
+		vfio_dev_err(vdev, "no INTx reported by VFIO");
+		return -ENODEV;
+	}
+
+	if (!(irq_info.flags & VFIO_IRQ_INFO_EVENTFD)) {
+		vfio_dev_err(vdev, "interrupt not eventfd capable");
+		return -EINVAL;
+	}
+
+	if (!(irq_info.flags & VFIO_IRQ_INFO_AUTOMASKED)) {
+		vfio_dev_err(vdev, "INTx interrupt not AUTOMASKED");
+		return -EINVAL;
+	}
+
+	/* Guest is going to ovewrite our irq_line... */
+	pdev->intx_gsi = pdev->hdr.irq_line - KVM_IRQ_OFFSET;
+
+	return 0;
+}
+
 static int vfio_pci_configure_dev_irqs(struct kvm *kvm, struct vfio_device *vdev)
 {
 	int ret = 0;
@@ -1142,8 +1150,13 @@ static int vfio_pci_configure_dev_irqs(struct kvm *kvm, struct vfio_device *vdev
 			return ret;
 	}
 
-	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX) {
+		ret = vfio_pci_init_intx(kvm, vdev);
+		if (ret)
+			return ret;
+
 		ret = vfio_pci_enable_intx(kvm, vdev);
+	}
 
 	return ret;
 }
-- 
2.19.1
