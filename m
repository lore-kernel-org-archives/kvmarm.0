From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool hack 1/3] virtio: Handle aborts using invalid PFN
Date: Tue,  9 Jan 2018 19:04:12 +0000
Message-ID: <20180109190414.4017-18-suzuki.poulose@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E1E249DA2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GW-x-aKciMPl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jan 2018 14:00:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8557F49D36
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:53 -0500 (EST)
In-Reply-To: <20180109190414.4017-1-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When the host fails to complete the shake hand due to various
reasons. e.g, for PCI and MMIO, if 0 is written as the PFN,
it implies the host has given up and simply don't take any
action.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virtio/mmio.c | 14 ++++++++------
 virtio/pci.c  | 10 ++++++----
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/virtio/mmio.c b/virtio/mmio.c
index f0af4bd..ba02358 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -188,12 +188,14 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 		break;
 	case VIRTIO_MMIO_QUEUE_PFN:
 		val = ioport__read32(data);
-		virtio_mmio_init_ioeventfd(vmmio->kvm, vdev, vmmio->hdr.queue_sel);
-		vdev->ops->init_vq(vmmio->kvm, vmmio->dev,
-				   vmmio->hdr.queue_sel,
-				   vmmio->hdr.guest_page_size,
-				   vmmio->hdr.queue_align,
-				   val);
+		if (val) {
+			virtio_mmio_init_ioeventfd(vmmio->kvm, vdev, vmmio->hdr.queue_sel);
+			vdev->ops->init_vq(vmmio->kvm, vmmio->dev,
+					   vmmio->hdr.queue_sel,
+					   vmmio->hdr.guest_page_size,
+					   vmmio->hdr.queue_align,
+					   val);
+		}
 		break;
 	case VIRTIO_MMIO_QUEUE_NOTIFY:
 		val = ioport__read32(data);
diff --git a/virtio/pci.c b/virtio/pci.c
index 4ce1111..3c694c2 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -271,10 +271,12 @@ static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16
 		break;
 	case VIRTIO_PCI_QUEUE_PFN:
 		val = ioport__read32(data);
-		virtio_pci__init_ioeventfd(kvm, vdev, vpci->queue_selector);
-		vdev->ops->init_vq(kvm, vpci->dev, vpci->queue_selector,
-				   1 << VIRTIO_PCI_QUEUE_ADDR_SHIFT,
-				   VIRTIO_PCI_VRING_ALIGN, val);
+		if (val) {
+			virtio_pci__init_ioeventfd(kvm, vdev, vpci->queue_selector);
+			vdev->ops->init_vq(kvm, vpci->dev, vpci->queue_selector,
+					   1 << VIRTIO_PCI_QUEUE_ADDR_SHIFT,
+					   VIRTIO_PCI_VRING_ALIGN, val);
+		}
 		break;
 	case VIRTIO_PCI_QUEUE_SEL:
 		vpci->queue_selector = ioport__read16(data);
-- 
2.13.6
