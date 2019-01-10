From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool v2 06/13] virtio: Add reset() callback
Date: Thu, 10 Jan 2019 14:12:43 +0000
Message-ID: <1547129570-14351-7-git-send-email-julien.thierry@arm.com>
References: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28F3F4A471
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dMyp6KtNSre5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:13:05 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F5894A496
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:05 -0500 (EST)
In-Reply-To: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: will.deacon@arm.com, kraxel@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

When the guest writes a status of 0, the device should be reset. Add a
reset() callback for the transport layer to reset all queues and their
ioeventfd.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 include/kvm/virtio-mmio.h |  1 +
 include/kvm/virtio-pci.h  |  1 +
 include/kvm/virtio.h      |  1 +
 virtio/core.c             |  9 +++++++++
 virtio/mmio.c             | 16 ++++++++++++----
 virtio/pci.c              | 20 +++++++++++++-------
 6 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
index 835f421..0528947 100644
--- a/include/kvm/virtio-mmio.h
+++ b/include/kvm/virtio-mmio.h
@@ -54,6 +54,7 @@ struct virtio_mmio {
 int virtio_mmio_signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq);
 int virtio_mmio_signal_config(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_mmio_exit(struct kvm *kvm, struct virtio_device *vdev);
+int virtio_mmio_reset(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		      int device_id, int subsys_id, int class);
 void virtio_mmio_assign_irq(struct device_header *dev_hdr);
diff --git a/include/kvm/virtio-pci.h b/include/kvm/virtio-pci.h
index b70cadd..278a259 100644
--- a/include/kvm/virtio-pci.h
+++ b/include/kvm/virtio-pci.h
@@ -55,6 +55,7 @@ struct virtio_pci {
 int virtio_pci__signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq);
 int virtio_pci__signal_config(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_pci__exit(struct kvm *kvm, struct virtio_device *vdev);
+int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		     int device_id, int subsys_id, int class);
 
diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index f35c74d..19b9137 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -201,6 +201,7 @@ struct virtio_ops {
 	int (*init)(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		    int device_id, int subsys_id, int class);
 	int (*exit)(struct kvm *kvm, struct virtio_device *vdev);
+	int (*reset)(struct kvm *kvm, struct virtio_device *vdev);
 };
 
 int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
diff --git a/virtio/core.c b/virtio/core.c
index 67d4114..e10ec36 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -241,6 +241,13 @@ void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 	} else if (!status && (vdev->status & VIRTIO__STATUS_START)) {
 		vdev->status &= ~VIRTIO__STATUS_START;
 		ext_status |= VIRTIO__STATUS_STOP;
+
+		/*
+		 * Reset virtqueues and stop all traffic now, so that the device
+		 * can safely reset the backend in notify_status().
+		 */
+		if (ext_status & VIRTIO__STATUS_STOP)
+			vdev->ops->reset(kvm, vdev);
 	}
 
 	if (vdev->ops->notify_status)
@@ -264,6 +271,7 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		vdev->ops->signal_config	= virtio_pci__signal_config;
 		vdev->ops->init			= virtio_pci__init;
 		vdev->ops->exit			= virtio_pci__exit;
+		vdev->ops->reset		= virtio_pci__reset;
 		vdev->ops->init(kvm, dev, vdev, device_id, subsys_id, class);
 		break;
 	case VIRTIO_MMIO:
@@ -276,6 +284,7 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		vdev->ops->signal_config	= virtio_mmio_signal_config;
 		vdev->ops->init			= virtio_mmio_init;
 		vdev->ops->exit			= virtio_mmio_exit;
+		vdev->ops->reset		= virtio_mmio_reset;
 		vdev->ops->init(kvm, dev, vdev, device_id, subsys_id, class);
 		break;
 	default:
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 4b8c20e..eff147a 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -326,15 +326,23 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	return 0;
 }
 
+int virtio_mmio_reset(struct kvm *kvm, struct virtio_device *vdev)
+{
+	int vq;
+	struct virtio_mmio *vmmio = vdev->virtio;
+
+	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vmmio->dev); vq++)
+		virtio_mmio_exit_vq(kvm, vdev, vq);
+
+	return 0;
+}
+
 int virtio_mmio_exit(struct kvm *kvm, struct virtio_device *vdev)
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
-	int i;
 
+	virtio_mmio_reset(kvm, vdev);
 	kvm__deregister_mmio(kvm, vmmio->addr);
 
-	for (i = 0; i < VIRTIO_MMIO_MAX_VQ; i++)
-		ioeventfd__del_event(vmmio->addr + VIRTIO_MMIO_QUEUE_NOTIFY, i);
-
 	return 0;
 }
diff --git a/virtio/pci.c b/virtio/pci.c
index 2da2d3f..99653ca 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -77,8 +77,8 @@ static void virtio_pci_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
 {
 	struct virtio_pci *vpci = vdev->virtio;
 
-	ioeventfd__del_event(vpci->port_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
 	ioeventfd__del_event(vpci->mmio_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
+	ioeventfd__del_event(vpci->port_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
 	virtio_exit_vq(kvm, vdev, vpci->dev, vq);
 }
 
@@ -522,19 +522,25 @@ free_ioport:
 	return r;
 }
 
+int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
+{
+	int vq;
+	struct virtio_pci *vpci = vdev->virtio;
+
+	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vpci->dev); vq++)
+		virtio_pci_exit_vq(kvm, vdev, vq);
+
+	return 0;
+}
+
 int virtio_pci__exit(struct kvm *kvm, struct virtio_device *vdev)
 {
 	struct virtio_pci *vpci = vdev->virtio;
-	int i;
 
+	virtio_pci__reset(kvm, vdev);
 	kvm__deregister_mmio(kvm, vpci->mmio_addr);
 	kvm__deregister_mmio(kvm, vpci->msix_io_block);
 	ioport__unregister(kvm, vpci->port_addr);
 
-	for (i = 0; i < VIRTIO_PCI_MAX_VQ; i++) {
-		ioeventfd__del_event(vpci->port_addr + VIRTIO_PCI_QUEUE_NOTIFY, i);
-		ioeventfd__del_event(vpci->mmio_addr + VIRTIO_PCI_QUEUE_NOTIFY, i);
-	}
-
 	return 0;
 }
-- 
1.9.1
