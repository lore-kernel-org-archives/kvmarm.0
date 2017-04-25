From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v10 06/15] PCI: Only allocate IRQ routing entry when
 available
Date: Tue, 25 Apr 2017 15:39:23 +0100
Message-ID: <20170425143932.17235-7-andre.przywara@arm.com>
References: <20170425143932.17235-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FE8A40DB8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 10:34:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O9oElDenCBGy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Apr 2017 10:34:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E9E040CC6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 10:34:43 -0400 (EDT)
In-Reply-To: <20170425143932.17235-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

If we need to inject an MSI into the guest, we rely at the moment on a
working GSI MSI routing functionality. However we can get away without
IRQ routing, if the host supports MSI injection via the KVM_SIGNAL_MSI
ioctl.
So we try the GSI routing first, but if that fails due to a missing
IRQ routing functionality, we fall back to KVM_SIGNAL_MSI (if that is
supported).

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virtio/pci.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index e9f36c7..04176c1 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -193,8 +193,20 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
 
 			gsi = irq__add_msix_route(kvm,
 						  &vpci->msix_table[vec].msg);
-			if (gsi >= 0)
-				vpci->config_gsi = gsi;
+			/*
+			 * We don't need IRQ routing if we can use
+			 * MSI injection via the KVM_SIGNAL_MSI ioctl.
+			 */
+			if (gsi == -ENXIO &&
+			    vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
+				break;
+
+			if (gsi < 0) {
+				die("failed to configure MSIs");
+				break;
+			}
+
+			vpci->config_gsi = gsi;
 			break;
 		case VIRTIO_MSI_QUEUE_VECTOR:
 			vec = ioport__read16(data);
@@ -205,8 +217,19 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
 
 			gsi = irq__add_msix_route(kvm,
 						  &vpci->msix_table[vec].msg);
-			if (gsi < 0)
+			/*
+			 * We don't need IRQ routing if we can use
+			 * MSI injection via the KVM_SIGNAL_MSI ioctl.
+			 */
+			if (gsi == -ENXIO &&
+			    vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
 				break;
+
+			if (gsi < 0) {
+				die("failed to configure MSIs");
+				break;
+			}
+
 			vpci->gsis[vpci->queue_selector] = gsi;
 			if (vdev->ops->notify_vq_gsi)
 				vdev->ops->notify_vq_gsi(kvm, vpci->dev,
-- 
2.9.0
