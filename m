From: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH kvmtool v2 3/3] vfio-pci: Re-enable INTx mode when disable
 MSI/MSIX
Date: Wed, 20 Mar 2019 14:20:46 +0800
Message-ID: <20190320062046.3895-4-leo.yan@linaro.org>
References: <20190320062046.3895-1-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 586404A389
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 02:21:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IkUttqwgMQKb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Mar 2019 02:21:19 -0400 (EDT)
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com
 [209.85.210.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56D344A379
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 02:21:19 -0400 (EDT)
Received: by mail-ot1-f68.google.com with SMTP id u15so1086113otq.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 23:21:19 -0700 (PDT)
In-Reply-To: <20190320062046.3895-1-leo.yan@linaro.org>
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
expected and tries to rollback to use INTx mode.  The INTx mode has been
disabled and it has no chance to be enabled again, thus both INTx mode
and MSI/MSIX mode will not be enabled in vfio for this case.

Below shows the detailed flow for introducing this issue:

  vfio_pci_configure_dev_irqs()
    `-> vfio_pci_enable_intx()

  vfio_pci_enable_msis()
    `-> vfio_pci_disable_intx()

  vfio_pci_disable_msis()   => Guest PCI driver disables MSI

To fix this issue, when disable MSI/MSIX we need to check if INTx mode
is available for this device or not; if the device can support INTx then
we need to re-enable it so the device can fallback to use it.

In this patch, should note two minor changes:

- vfio_pci_disable_intx() may be called multiple times (each time the
  guest enables one MSI vector).  This patch changes to use
  'intx_fd == -1' to denote the INTx disabled, vfio_pci_disable_intx()
  and vfio_pci_enable_intx will directly bail out when detect INTx has
  been disabled and enabled respectively.

- Since pci_device_header will be corrupted after PCI configuration
  and all irq related info will be lost.  Before re-enabling INTx
  mode, this patch restores 'irq_pin' and 'irq_line' fields in struct
  pci_device_header.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 vfio/pci.c | 59 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 11 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index d025581..ba971eb 100644
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
 
@@ -162,7 +160,34 @@ static int vfio_pci_disable_msis(struct kvm *kvm, struct vfio_device *vdev,
 	msi_set_enabled(msis->phys_state, false);
 	msi_set_empty(msis->phys_state, true);
 
-	return 0;
+	/*
+	 * When MSI or MSIX is disabled, this might be called when
+	 * PCI driver detects the MSI interrupt failure and wants to
+	 * rollback to INTx mode.  Thus enable INTx if the device
+	 * supports INTx mode in this case.
+	 */
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX) {
+		/*
+		 * Struct pci_device_header is not only used for header,
+		 * it also is used for PCI configuration; and in the function
+		 * vfio_pci_cfg_write() it firstly writes configuration space
+		 * and then read back the configuration space data into the
+		 * header structure; thus 'irq_pin' and 'irq_line' in the
+		 * header will be overwritten.
+		 *
+		 * If want to enable INTx mode properly, firstly needs to
+		 * restore 'irq_pin' and 'irq_line' values; we can simply set 1
+		 * to 'irq_pin', and 'pdev->intx_gsi' keeps gsi value when
+		 * enable INTx mode previously so we can simply use it to
+		 * recover irq line number by adding offset KVM_IRQ_OFFSET.
+		 */
+		pdev->hdr.irq_pin = 1;
+		pdev->hdr.irq_line = pdev->intx_gsi + KVM_IRQ_OFFSET;
+
+		ret = vfio_pci_enable_intx(kvm, vdev);
+	}
+
+	return ret >= 0 ? 0 : ret;
 }
 
 static int vfio_pci_update_msi_entry(struct kvm *kvm, struct vfio_device *vdev,
@@ -1002,6 +1027,10 @@ static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev)
 		.index	= VFIO_PCI_INTX_IRQ_INDEX,
 	};
 
+	/* INTx mode has been disabled */
+	if (pdev->intx_fd == -1)
+		return;
+
 	pr_debug("user requested MSI, disabling INTx %d", gsi);
 
 	ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
@@ -1009,6 +1038,7 @@ static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev)
 
 	close(pdev->intx_fd);
 	close(pdev->unmask_fd);
+	pdev->intx_fd = -1;
 }
 
 static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
@@ -1025,6 +1055,10 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 		.index = VFIO_PCI_INTX_IRQ_INDEX,
 	};
 
+	/* INTx mode has been enabled */
+	if (pdev->intx_fd != -1)
+		return 0;
+
 	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
 	if (ret || irq_info.count == 0) {
 		vfio_dev_err(vdev, "no INTx reported by VFIO");
@@ -1140,6 +1174,9 @@ static int vfio_pci_configure_dev_irqs(struct kvm *kvm, struct vfio_device *vdev
 			return ret;
 	}
 
+	/* Use intx_fd=-1 to denote INTx is disabled */
+	pdev->intx_fd = -1;
+
 	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
 		ret = vfio_pci_enable_intx(kvm, vdev);
 
-- 
2.19.1
