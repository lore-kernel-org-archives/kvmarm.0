From: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH kvmtool v3 2/3] vfio-pci: Add new function for INTx one-time
 initialisation
Date: Tue, 26 Mar 2019 15:41:30 +0800
Message-ID: <20190326074131.4284-3-leo.yan@linaro.org>
References: <20190326074131.4284-1-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFF254A41B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 03:42:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oa+cuqRCXCHw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Mar 2019 03:42:19 -0400 (EDT)
Received: from mail-yw1-f66.google.com (mail-yw1-f66.google.com
 [209.85.161.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2E204A439
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 03:42:18 -0400 (EDT)
Received: by mail-yw1-f66.google.com with SMTP id c4so9033995ywa.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 00:42:18 -0700 (PDT)
In-Reply-To: <20190326074131.4284-1-leo.yan@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, Eric Auger <eric.auger@redhat.com>, Robin Murphy <robin.murphy@arm.com>
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
