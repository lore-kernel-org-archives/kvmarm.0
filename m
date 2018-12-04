From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 02/13] virtio: Implement notify_status
Date: Tue,  4 Dec 2018 11:08:35 +0000
Message-ID: <1543921726-54571-3-git-send-email-julien.thierry@arm.com>
References: <1543921726-54571-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4F444A320
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:08:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fazy971x1UVq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 06:08:55 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BD714A2BD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:08:55 -0500 (EST)
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

Modern virtio require proper status handling and reset. A "notify_status"
callback is already present in the virtio ops, but isn't implemented by
any device. Instead they currently use "set_guest_feature" to reset the
device and deal with endianess. This isn't sufficient for proper device
reset, so add the notify_status callback to all devices that need it.

To add useful hints like "start" and "stop", extend the status variable to
32-bits.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 include/kvm/virtio.h | 21 ++++++++++++++++++++-
 virtio/9p.c          |  5 +++++
 virtio/balloon.c     |  5 +++++
 virtio/blk.c         |  5 +++++
 virtio/console.c     |  5 +++++
 virtio/core.c        | 23 +++++++++++++++++++++++
 virtio/mmio.c        |  3 +--
 virtio/net.c         | 10 ++++++++++
 virtio/pci.c         |  3 +--
 virtio/scsi.c        |  5 +++++
 10 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index db758b1..742aa9e 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -7,6 +7,7 @@
 #include <linux/virtio_pci.h>
 
 #include <linux/types.h>
+#include <linux/virtio_config.h>
 #include <sys/uio.h>
 
 #include "kvm/barrier.h"
@@ -27,6 +28,21 @@
 #define VIRTIO_ENDIAN_HOST VIRTIO_ENDIAN_BE
 #endif
 
+/* Reserved status bits */
+#define VIRTIO_CONFIG_S_MASK \
+	(VIRTIO_CONFIG_S_ACKNOWLEDGE |	\
+	 VIRTIO_CONFIG_S_DRIVER |	\
+	 VIRTIO_CONFIG_S_DRIVER_OK |	\
+	 VIRTIO_CONFIG_S_FEATURES_OK |	\
+	 VIRTIO_CONFIG_S_NEEDS_RESET |	\
+	 VIRTIO_CONFIG_S_FAILED)
+
+/* Kvmtool status bits */
+/* Start the device */
+#define VIRTIO__STATUS_START		(1 << 8)
+/* Stop the device */
+#define VIRTIO__STATUS_STOP		(1 << 9)
+
 struct virt_queue {
 	struct vring	vring;
 	u32		pfn;
@@ -155,6 +171,7 @@ struct virtio_device {
 	struct virtio_ops	*ops;
 	u16			endian;
 	u32			features;
+	u32			status;
 };
 
 struct virtio_ops {
@@ -171,7 +188,7 @@ struct virtio_ops {
 	void (*notify_vq_eventfd)(struct kvm *kvm, void *dev, u32 vq, u32 efd);
 	int (*signal_vq)(struct kvm *kvm, struct virtio_device *vdev, u32 queueid);
 	int (*signal_config)(struct kvm *kvm, struct virtio_device *vdev);
-	void (*notify_status)(struct kvm *kvm, void *dev, u8 status);
+	void (*notify_status)(struct kvm *kvm, void *dev, u32 status);
 	int (*init)(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		    int device_id, int subsys_id, int class);
 	int (*exit)(struct kvm *kvm, struct virtio_device *vdev);
@@ -197,5 +214,7 @@ static inline void virtio_init_device_vq(struct virtio_device *vdev,
 
 void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
 			       void *dev, u32 features);
+void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
+			  void *dev, u8 status);
 
 #endif /* KVM__VIRTIO_H */
diff --git a/virtio/9p.c b/virtio/9p.c
index 69fdc4b..4b93b4c 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1382,6 +1382,10 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 	conf->tag_len = virtio_host_to_guest_u16(&p9dev->vdev, conf->tag_len);
 }
 
+static void notify_status(struct kvm *kvm, void *dev, u32 status)
+{
+}
+
 static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 		   u32 pfn)
 {
@@ -1441,6 +1445,7 @@ struct virtio_ops p9_dev_virtio_ops = {
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
+	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
 	.get_pfn_vq		= get_pfn_vq,
 	.get_size_vq		= get_size_vq,
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 9564aa3..871d6e0 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -193,6 +193,10 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 	bdev->features = features;
 }
 
+static void notify_status(struct kvm *kvm, void *dev, u32 status)
+{
+}
+
 static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 		   u32 pfn)
 {
@@ -244,6 +248,7 @@ struct virtio_ops bln_dev_virtio_ops = {
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
+	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
 	.get_pfn_vq		= get_pfn_vq,
 	.get_size_vq		= get_size_vq,
diff --git a/virtio/blk.c b/virtio/blk.c
index c485e4f..db9f4cc 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -174,6 +174,10 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 	conf->opt_io_size = virtio_host_to_guest_u32(&bdev->vdev, conf->opt_io_size);
 }
 
+static void notify_status(struct kvm *kvm, void *dev, u32 status)
+{
+}
+
 static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 		   u32 pfn)
 {
@@ -249,6 +253,7 @@ static struct virtio_ops blk_dev_virtio_ops = {
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
+	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
 	.get_pfn_vq		= get_pfn_vq,
 	.get_size_vq		= get_size_vq,
diff --git a/virtio/console.c b/virtio/console.c
index dc0a9c4..b9df5c9 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -140,6 +140,10 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 	conf->max_nr_ports = virtio_host_to_guest_u32(&cdev->vdev, conf->max_nr_ports);
 }
 
+static void notify_status(struct kvm *kvm, void *dev, u32 status)
+{
+}
+
 static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 		   u32 pfn)
 {
@@ -203,6 +207,7 @@ static struct virtio_ops con_dev_virtio_ops = {
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
+	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
 	.get_pfn_vq		= get_pfn_vq,
 	.get_size_vq		= get_size_vq,
diff --git a/virtio/core.c b/virtio/core.c
index 0e2646c..9114f27 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -214,6 +214,29 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
 	vdev->ops->set_guest_features(kvm, dev, features);
 }
 
+void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
+			  void *dev, u8 status)
+{
+	u32 ext_status = status;
+
+	vdev->status &= ~VIRTIO_CONFIG_S_MASK;
+	vdev->status |= status;
+
+	/* Add a few hints to help devices */
+	if ((status & VIRTIO_CONFIG_S_DRIVER_OK) &&
+	    !(vdev->status & VIRTIO__STATUS_START)) {
+		vdev->status |= VIRTIO__STATUS_START;
+		ext_status |= VIRTIO__STATUS_START;
+
+	} else if (!status && (vdev->status & VIRTIO__STATUS_START)) {
+		vdev->status &= ~VIRTIO__STATUS_START;
+		ext_status |= VIRTIO__STATUS_STOP;
+	}
+
+	if (vdev->ops->notify_status)
+		vdev->ops->notify_status(kvm, dev, ext_status);
+}
+
 int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		struct virtio_ops *ops, enum virtio_trans trans,
 		int device_id, int subsys_id, int class)
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 8c0f1cc..7a78fef 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -162,8 +162,7 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 		vmmio->hdr.status = ioport__read32(data);
 		if (!vmmio->hdr.status) /* Sample endianness on reset */
 			vdev->endian = kvm_cpu__get_endianness(vcpu);
-		if (vdev->ops->notify_status)
-			vdev->ops->notify_status(kvm, vmmio->dev, vmmio->hdr.status);
+		virtio_notify_status(kvm, vdev, vmmio->dev, vmmio->hdr.status);
 		break;
 	case VIRTIO_MMIO_GUEST_FEATURES:
 		if (vmmio->hdr.guest_features_sel == 0) {
diff --git a/virtio/net.c b/virtio/net.c
index f95258c..619b545 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -518,7 +518,10 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 	conf->status = virtio_host_to_guest_u16(&ndev->vdev, conf->status);
 	conf->max_virtqueue_pairs = virtio_host_to_guest_u16(&ndev->vdev,
 							     conf->max_virtqueue_pairs);
+}
 
+static void virtio_net_start(struct net_dev *ndev)
+{
 	if (ndev->mode == NET_MODE_TAP) {
 		if (!virtio_net__tap_init(ndev))
 			die_perror("TAP device initialized failed because");
@@ -534,6 +537,12 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 	}
 }
 
+static void notify_status(struct kvm *kvm, void *dev, u32 status)
+{
+	if (status & VIRTIO__STATUS_START)
+		virtio_net_start(dev);
+}
+
 static bool is_ctrl_vq(struct net_dev *ndev, u32 vq)
 {
 	return vq == (u32)(ndev->queue_pairs * 2);
@@ -683,6 +692,7 @@ static struct virtio_ops net_dev_virtio_ops = {
 	.notify_vq		= notify_vq,
 	.notify_vq_gsi		= notify_vq_gsi,
 	.notify_vq_eventfd	= notify_vq_eventfd,
+	.notify_status		= notify_status,
 };
 
 static void virtio_net__vhost_init(struct kvm *kvm, struct net_dev *ndev)
diff --git a/virtio/pci.c b/virtio/pci.c
index 5a5fc6e..fdeee69 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -285,8 +285,7 @@ static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16
 		vpci->status = ioport__read8(data);
 		if (!vpci->status) /* Sample endianness on reset */
 			vdev->endian = kvm_cpu__get_endianness(vcpu);
-		if (vdev->ops->notify_status)
-			vdev->ops->notify_status(kvm, vpci->dev, vpci->status);
+		virtio_notify_status(kvm, vdev, vpci->dev, vpci->status);
 		break;
 	default:
 		ret = virtio_pci__specific_io_out(kvm, vdev, port, data, size, offset);
diff --git a/virtio/scsi.c b/virtio/scsi.c
index a429ac8..788bfa2 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -50,6 +50,10 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 	sdev->features = features;
 }
 
+static void notify_status(struct kvm *kvm, void *dev, u32 status)
+{
+}
+
 static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 		   u32 pfn)
 {
@@ -171,6 +175,7 @@ static struct virtio_ops scsi_dev_virtio_ops = {
 	.get_pfn_vq		= get_pfn_vq,
 	.get_size_vq		= get_size_vq,
 	.set_size_vq		= set_size_vq,
+	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
 	.notify_vq_gsi		= notify_vq_gsi,
 	.notify_vq_eventfd	= notify_vq_eventfd,
-- 
1.9.1
