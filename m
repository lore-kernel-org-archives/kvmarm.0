From: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH kvmtool v1 1/2] vfio-pci: Release INTx's guest to host eventfd
 properly
Date: Fri, 15 Mar 2019 16:33:14 +0800
Message-ID: <20190315083315.19221-1-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 752794A452
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 04:33:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qVJ1acdDRgCW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Mar 2019 04:33:29 -0400 (EDT)
Received: from mail-oi1-f195.google.com (mail-oi1-f195.google.com
 [209.85.167.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 580B54A389
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 04:33:29 -0400 (EDT)
Received: by mail-oi1-f195.google.com with SMTP id a15so6676864oid.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 01:33:29 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: Leo Yan <leo.yan@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The PCI device INTx uses event fd 'unmask_fd' to signal the deassertion
of the line from guest to host; but this eventfd isn't released properly
when disable INTx.

When disable INTx this patch firstly unbinds interrupt signal by calling
ioctl VFIO_DEVICE_SET_IRQS and then it uses the new added field
'unmask_fd' in struct vfio_pci_device to close event fd.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 include/kvm/vfio.h |  1 +
 vfio/pci.c         | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
index 60e6c54..28223cf 100644
--- a/include/kvm/vfio.h
+++ b/include/kvm/vfio.h
@@ -74,6 +74,7 @@ struct vfio_pci_device {
 
 	unsigned long			irq_modes;
 	int				intx_fd;
+	int				unmask_fd;
 	unsigned int			intx_gsi;
 	struct vfio_pci_msi_common	msi;
 	struct vfio_pci_msi_common	msix;
diff --git a/vfio/pci.c b/vfio/pci.c
index 03de3c1..c0683f6 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -996,18 +996,26 @@ static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev)
 {
 	struct vfio_pci_device *pdev = &vdev->pci;
 	int gsi = pdev->intx_gsi;
-	struct vfio_irq_set irq_set = {
-		.argsz	= sizeof(irq_set),
+	struct vfio_irq_set trigger_irq = {
+		.argsz	= sizeof(trigger_irq),
 		.flags	= VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_TRIGGER,
 		.index	= VFIO_PCI_INTX_IRQ_INDEX,
 	};
 
+	struct vfio_irq_set unmask_irq = {
+		.argsz	= sizeof(unmask_irq),
+		.flags	= VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_UNMASK,
+		.index	= VFIO_PCI_INTX_IRQ_INDEX,
+	};
+
 	pr_debug("user requested MSI, disabling INTx %d", gsi);
 
-	ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
+	ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &trigger_irq);
+	ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &unmask_irq);
 	irq__del_irqfd(kvm, gsi, pdev->intx_fd);
 
 	close(pdev->intx_fd);
+	close(pdev->unmask_fd);
 }
 
 static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
@@ -1095,6 +1103,7 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 	}
 
 	pdev->intx_fd = trigger_fd;
+	pdev->unmask_fd = unmask_fd;
 	/* Guest is going to ovewrite our irq_line... */
 	pdev->intx_gsi = gsi;
 
-- 
2.19.1
