From: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH kvmtool v3 3/3] vfio-pci: Re-enable INTx mode when disable
 MSI/MSIX
Date: Tue, 26 Mar 2019 15:41:31 +0800
Message-ID: <20190326074131.4284-4-leo.yan@linaro.org>
References: <20190326074131.4284-1-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CE0D4A320
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 03:42:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fl+A43OwIpid for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Mar 2019 03:42:23 -0400 (EDT)
Received: from mail-yw1-f66.google.com (mail-yw1-f66.google.com
 [209.85.161.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0506C4A34E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 03:42:23 -0400 (EDT)
Received: by mail-yw1-f66.google.com with SMTP id p64so9054502ywg.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 00:42:23 -0700 (PDT)
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

Since PCI forbids enabling INTx, MSI or MSIX at the same time, it's by
default to disable INTx mode when enable MSI/MSIX mode; but this logic is
easily broken if the guest PCI driver detects the MSI/MSIX cannot work as
expected and tries to rollback to use INTx mode.  In this case, the INTx
mode has been disabled and has no chance to re-enable it, thus both INTx
mode and MSI/MSIX mode cannot work in vfio.

Below shows the detailed flow for introducing this issue:

  vfio_pci_configure_dev_irqs()
    `-> vfio_pci_enable_intx()

  vfio_pci_enable_msis()
    `-> vfio_pci_disable_intx()

  vfio_pci_disable_msis()   => Guest PCI driver disables MSI

To fix this issue, when disable MSI/MSIX we need to check if INTx mode
is available for this device or not; if the device can support INTx then
re-enable it so that the device can fallback to use it.

Since vfio_pci_disable_intx() / vfio_pci_enable_intx() pair functions
may be called for multiple times, this patch uses 'intx_fd == -1' to
denote the INTx is disabled, the pair functions can directly bail out
when detect INTx has been disabled and enabled respectively.

Suggested-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 vfio/pci.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index 3c39844..3b2b1e7 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -28,6 +28,7 @@ struct vfio_irq_eventfd {
 	msi_update_state(state, val, VFIO_PCI_MSI_STATE_EMPTY)
 
 static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev);
+static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev);
 
 static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
 				bool msix)
@@ -50,17 +51,14 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
 	if (!msi_is_enabled(msis->virt_state))
 		return 0;
 
-	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX) {
-		/*
-		 * PCI (and VFIO) forbids enabling INTx, MSI or MSIX at the same
-		 * time. Since INTx has to be enabled from the start (we don't
-		 * have a reliable way to know when the user starts using it),
-		 * disable it now.
-		 */
+	/*
+	 * PCI (and VFIO) forbids enabling INTx, MSI or MSIX at the same
+	 * time. Since INTx has to be enabled from the start (after enabling
+	 * 'pdev->intx_fd' will be assigned to an eventfd and doesn't equal
+	 * to the init value -1), disable it now.
+	 */
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
 		vfio_pci_disable_intx(kvm, vdev);
-		/* Permanently disable INTx */
-		pdev->irq_modes &= ~VFIO_PCI_IRQ_MODE_INTX;
-	}
 
 	eventfds = (void *)msis->irq_set + sizeof(struct vfio_irq_set);
 
@@ -162,7 +160,16 @@ static int vfio_pci_disable_msis(struct kvm *kvm, struct vfio_device *vdev,
 	msi_set_enabled(msis->phys_state, false);
 	msi_set_empty(msis->phys_state, true);
 
-	return 0;
+	/*
+	 * When MSI or MSIX is disabled, this might be called when
+	 * PCI driver detects the MSI interrupt failure and wants to
+	 * rollback to INTx mode.  Thus enable INTx if the device
+	 * supports INTx mode in this case.
+	 */
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
+		ret = vfio_pci_enable_intx(kvm, vdev);
+
+	return ret >= 0 ? 0 : ret;
 }
 
 static int vfio_pci_update_msi_entry(struct kvm *kvm, struct vfio_device *vdev,
@@ -1002,6 +1009,10 @@ static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev)
 		.index	= VFIO_PCI_INTX_IRQ_INDEX,
 	};
 
+	/* INTx mode has been disabled */
+	if (pdev->intx_fd == -1)
+		return;
+
 	pr_debug("user requested MSI, disabling INTx %d", gsi);
 
 	ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
@@ -1009,6 +1020,7 @@ static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev)
 
 	close(pdev->intx_fd);
 	close(pdev->unmask_fd);
+	pdev->intx_fd = -1;
 }
 
 static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
@@ -1020,6 +1032,10 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 	struct vfio_pci_device *pdev = &vdev->pci;
 	int gsi = pdev->intx_gsi;
 
+	/* INTx mode has been enabled */
+	if (pdev->intx_fd != -1)
+		return 0;
+
 	/*
 	 * PCI IRQ is level-triggered, so we use two eventfds. trigger_fd
 	 * signals an interrupt from host to guest, and unmask_fd signals the
@@ -1122,6 +1138,9 @@ static int vfio_pci_init_intx(struct kvm *kvm, struct vfio_device *vdev)
 	/* Guest is going to ovewrite our irq_line... */
 	pdev->intx_gsi = pdev->hdr.irq_line - KVM_IRQ_OFFSET;
 
+	/* Use intx_fd = -1 to denote INTx is disabled */
+	pdev->intx_fd = -1;
+
 	return 0;
 }
 
-- 
2.19.1
