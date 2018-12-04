From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 05/13] virtio: Add exit_vq() callback
Date: Tue,  4 Dec 2018 11:08:38 +0000
Message-ID: <1543921726-54571-6-git-send-email-julien.thierry@arm.com>
References: <1543921726-54571-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3002A4A36D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:09:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TmcBfMfq2mu7 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 06:08:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D454C4A365
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:08:58 -0500 (EST)
In-Reply-To: <1543921726-54571-1-git-send-email-julien.thierry@arm.com>
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
Cc: will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

Virtio allows to reset individual virtqueues. For legacy devices, it's
done by writing an address of 0 into the PFN register. Modern devices have
an "enable" register. Add an exit_vq() callback to all devices. A lot more
work is required by each device to clean up their virtqueue state, and by
the core to reset things like MSI routes and ioeventfds.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 include/kvm/virtio.h |  5 +++++
 virtio/core.c        | 10 ++++++++++
 virtio/mmio.c        | 26 ++++++++++++++++++++------
 virtio/pci.c         | 23 +++++++++++++++++++----
 4 files changed, 54 insertions(+), 10 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index fd04d21..20399f4 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -52,6 +52,7 @@ struct virt_queue {
 	u16		last_used_signalled;
 	u16		endian;
 	bool		use_event_idx;
+	bool		enabled;
 };
 
 /*
@@ -181,6 +182,7 @@ struct virtio_ops {
 	int (*get_vq_count)(struct kvm *kvm, void *dev);
 	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq, u32 page_size,
 		       u32 align, u32 pfn);
+	void (*exit_vq)(struct kvm *kvm, void *dev, u32 vq);
 	int (*notify_vq)(struct kvm *kvm, void *dev, u32 vq);
 	struct virt_queue *(*get_vq)(struct kvm *kvm, void *dev, u32 vq);
 	int (*get_size_vq)(struct kvm *kvm, void *dev, u32 vq);
@@ -211,8 +213,11 @@ static inline void virtio_init_device_vq(struct virtio_device *vdev,
 {
 	vq->endian = vdev->endian;
 	vq->use_event_idx = (vdev->features & VIRTIO_RING_F_EVENT_IDX);
+	vq->enabled = true;
 }
 
+void virtio_exit_vq(struct kvm *kvm, struct virtio_device *vdev, void *dev,
+		    int num);
 void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
 			       void *dev, u32 features);
 void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
diff --git a/virtio/core.c b/virtio/core.c
index 9114f27..67d4114 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -166,6 +166,16 @@ u16 virt_queue__get_inout_iov(struct kvm *kvm, struct virt_queue *queue,
 	return head;
 }
 
+void virtio_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
+			   void *dev, int num)
+{
+	struct virt_queue *vq = vdev->ops->get_vq(kvm, dev, num);
+
+	if (vq->enabled && vdev->ops->exit_vq)
+		vdev->ops->exit_vq(kvm, dev, num);
+	memset(vq, 0, sizeof(*vq));
+}
+
 int virtio__get_dev_specific_field(int offset, bool msix, u32 *config_off)
 {
 	if (msix) {
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 70f767e..4b8c20e 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -79,6 +79,15 @@ int virtio_mmio_signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
 	return 0;
 }
 
+static void virtio_mmio_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
+				int vq)
+{
+	struct virtio_mmio *vmmio = vdev->virtio;
+
+	ioeventfd__del_event(vmmio->addr + VIRTIO_MMIO_QUEUE_NOTIFY, vq);
+	virtio_exit_vq(kvm, vdev, vmmio->dev, vq);
+}
+
 int virtio_mmio_signal_config(struct kvm *kvm, struct virtio_device *vdev)
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
@@ -188,12 +197,17 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
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
+			virtio_mmio_init_ioeventfd(vmmio->kvm, vdev,
+						   vmmio->hdr.queue_sel);
+			vdev->ops->init_vq(vmmio->kvm, vmmio->dev,
+					   vmmio->hdr.queue_sel,
+					   vmmio->hdr.guest_page_size,
+					   vmmio->hdr.queue_align,
+					   val);
+		} else {
+			virtio_mmio_exit_vq(kvm, vdev, vmmio->hdr.queue_sel);
+		}
 		break;
 	case VIRTIO_MMIO_QUEUE_NOTIFY:
 		val = ioport__read32(data);
diff --git a/virtio/pci.c b/virtio/pci.c
index 8add770..2da2d3f 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -72,6 +72,16 @@ free_ioport_evt:
 	return r;
 }
 
+static void virtio_pci_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
+			       int vq)
+{
+	struct virtio_pci *vpci = vdev->virtio;
+
+	ioeventfd__del_event(vpci->port_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
+	ioeventfd__del_event(vpci->mmio_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
+	virtio_exit_vq(kvm, vdev, vpci->dev, vq);
+}
+
 static inline bool virtio_pci__msix_enabled(struct virtio_pci *vpci)
 {
 	return vpci->pci_hdr.msix.ctrl & cpu_to_le16(PCI_MSIX_FLAGS_ENABLE);
@@ -270,10 +280,15 @@ static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16
 		break;
 	case VIRTIO_PCI_QUEUE_PFN:
 		val = ioport__read32(data);
-		virtio_pci__init_ioeventfd(kvm, vdev, vpci->queue_selector);
-		vdev->ops->init_vq(kvm, vpci->dev, vpci->queue_selector,
-				   1 << VIRTIO_PCI_QUEUE_ADDR_SHIFT,
-				   VIRTIO_PCI_VRING_ALIGN, val);
+		if (val) {
+			virtio_pci__init_ioeventfd(kvm, vdev,
+						   vpci->queue_selector);
+			vdev->ops->init_vq(kvm, vpci->dev, vpci->queue_selector,
+					   1 << VIRTIO_PCI_QUEUE_ADDR_SHIFT,
+					   VIRTIO_PCI_VRING_ALIGN, val);
+		} else {
+			virtio_pci_exit_vq(kvm, vdev, vpci->queue_selector);
+		}
 		break;
 	case VIRTIO_PCI_QUEUE_SEL:
 		vpci->queue_selector = ioport__read16(data);
-- 
1.9.1
