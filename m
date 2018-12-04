From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 04/13] virtio: Add get_vq() callback
Date: Tue,  4 Dec 2018 11:08:37 +0000
Message-ID: <1543921726-54571-5-git-send-email-julien.thierry@arm.com>
References: <1543921726-54571-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98DA74A348
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:08:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ldtcAMCRc1Sv for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 06:08:58 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE8AD4A364
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:08:57 -0500 (EST)
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

To ease future changes to the core, replace get_pfn_vq() with get_vq().
This way adding new generic operation on virtqueues won't require
modifying every virtio device.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 include/kvm/virtio.h | 2 +-
 virtio/9p.c          | 6 +++---
 virtio/balloon.c     | 6 +++---
 virtio/blk.c         | 6 +++---
 virtio/console.c     | 6 +++---
 virtio/mmio.c        | 7 ++++---
 virtio/net.c         | 6 +++---
 virtio/pci.c         | 5 +++--
 virtio/rng.c         | 6 +++---
 virtio/scsi.c        | 6 +++---
 10 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 8b6dbd0..fd04d21 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -182,7 +182,7 @@ struct virtio_ops {
 	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq, u32 page_size,
 		       u32 align, u32 pfn);
 	int (*notify_vq)(struct kvm *kvm, void *dev, u32 vq);
-	int (*get_pfn_vq)(struct kvm *kvm, void *dev, u32 vq);
+	struct virt_queue *(*get_vq)(struct kvm *kvm, void *dev, u32 vq);
 	int (*get_size_vq)(struct kvm *kvm, void *dev, u32 vq);
 	int (*set_size_vq)(struct kvm *kvm, void *dev, u32 vq, int size);
 	void (*notify_vq_gsi)(struct kvm *kvm, void *dev, u32 vq, u32 gsi);
diff --git a/virtio/9p.c b/virtio/9p.c
index 94f7a8f..d9f45cf 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1422,11 +1422,11 @@ static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 	return 0;
 }
 
-static int get_pfn_vq(struct kvm *kvm, void *dev, u32 vq)
+static struct virt_queue *get_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct p9_dev *p9dev = dev;
 
-	return p9dev->vqs[vq].pfn;
+	return &p9dev->vqs[vq];
 }
 
 static int get_size_vq(struct kvm *kvm, void *dev, u32 vq)
@@ -1452,7 +1452,7 @@ struct virtio_ops p9_dev_virtio_ops = {
 	.init_vq		= init_vq,
 	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
-	.get_pfn_vq		= get_pfn_vq,
+	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
 	.set_size_vq		= set_size_vq,
 	.get_vq_count		= get_vq_count,
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 2c2e24a..15a9a46 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -225,11 +225,11 @@ static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 	return 0;
 }
 
-static int get_pfn_vq(struct kvm *kvm, void *dev, u32 vq)
+static struct virt_queue *get_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct bln_dev *bdev = dev;
 
-	return bdev->vqs[vq].pfn;
+	return &bdev->vqs[vq];
 }
 
 static int get_size_vq(struct kvm *kvm, void *dev, u32 vq)
@@ -255,7 +255,7 @@ struct virtio_ops bln_dev_virtio_ops = {
 	.init_vq		= init_vq,
 	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
-	.get_pfn_vq		= get_pfn_vq,
+	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
 	.set_size_vq            = set_size_vq,
 	.get_vq_count		= get_vq_count,
diff --git a/virtio/blk.c b/virtio/blk.c
index 6502b8c..6a6b3b7 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -229,11 +229,11 @@ static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 	return 0;
 }
 
-static int get_pfn_vq(struct kvm *kvm, void *dev, u32 vq)
+static struct virt_queue *get_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct blk_dev *bdev = dev;
 
-	return bdev->vqs[vq].pfn;
+	return &bdev->vqs[vq];
 }
 
 static int get_size_vq(struct kvm *kvm, void *dev, u32 vq)
@@ -261,7 +261,7 @@ static struct virtio_ops blk_dev_virtio_ops = {
 	.init_vq		= init_vq,
 	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
-	.get_pfn_vq		= get_pfn_vq,
+	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
 	.set_size_vq		= set_size_vq,
 };
diff --git a/virtio/console.c b/virtio/console.c
index c96bc11..d2b312c 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -184,11 +184,11 @@ static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 	return 0;
 }
 
-static int get_pfn_vq(struct kvm *kvm, void *dev, u32 vq)
+static struct virt_queue *get_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct con_dev *cdev = dev;
 
-	return cdev->vqs[vq].pfn;
+	return &cdev->vqs[vq];
 }
 
 static int get_size_vq(struct kvm *kvm, void *dev, u32 vq)
@@ -215,7 +215,7 @@ static struct virtio_ops con_dev_virtio_ops = {
 	.init_vq		= init_vq,
 	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
-	.get_pfn_vq		= get_pfn_vq,
+	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
 	.set_size_vq		= set_size_vq,
 };
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 7a78fef..70f767e 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -111,6 +111,7 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
 				  struct virtio_device *vdev)
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
+	struct virt_queue *vq;
 	u32 val = 0;
 
 	switch (addr) {
@@ -129,9 +130,9 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
 		ioport__write32(data, val);
 		break;
 	case VIRTIO_MMIO_QUEUE_PFN:
-		val = vdev->ops->get_pfn_vq(vmmio->kvm, vmmio->dev,
-					    vmmio->hdr.queue_sel);
-		ioport__write32(data, val);
+		vq = vdev->ops->get_vq(vmmio->kvm, vmmio->dev,
+				       vmmio->hdr.queue_sel);
+		ioport__write32(data, vq->pfn);
 		break;
 	case VIRTIO_MMIO_QUEUE_NUM_MAX:
 		val = vdev->ops->get_size_vq(vmmio->kvm, vmmio->dev,
diff --git a/virtio/net.c b/virtio/net.c
index 3b08aea..d65d04e 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -662,11 +662,11 @@ static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 	return 0;
 }
 
-static int get_pfn_vq(struct kvm *kvm, void *dev, u32 vq)
+static struct virt_queue *get_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct net_dev *ndev = dev;
 
-	return ndev->vqs[vq].pfn;
+	return &ndev->vqs[vq];
 }
 
 static int get_size_vq(struct kvm *kvm, void *dev, u32 vq)
@@ -694,7 +694,7 @@ static struct virtio_ops net_dev_virtio_ops = {
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
 	.init_vq		= init_vq,
-	.get_pfn_vq		= get_pfn_vq,
+	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
 	.set_size_vq		= set_size_vq,
 	.notify_vq		= notify_vq,
diff --git a/virtio/pci.c b/virtio/pci.c
index fdeee69..8add770 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -113,6 +113,7 @@ static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 p
 	bool ret = true;
 	struct virtio_device *vdev;
 	struct virtio_pci *vpci;
+	struct virt_queue *vq;
 	struct kvm *kvm;
 	u32 val;
 
@@ -127,8 +128,8 @@ static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 p
 		ioport__write32(data, val);
 		break;
 	case VIRTIO_PCI_QUEUE_PFN:
-		val = vdev->ops->get_pfn_vq(kvm, vpci->dev, vpci->queue_selector);
-		ioport__write32(data, val);
+		vq = vdev->ops->get_vq(kvm, vpci->dev, vpci->queue_selector);
+		ioport__write32(data, vq->pfn);
 		break;
 	case VIRTIO_PCI_QUEUE_NUM:
 		val = vdev->ops->get_size_vq(kvm, vpci->dev, vpci->queue_selector);
diff --git a/virtio/rng.c b/virtio/rng.c
index fc0e320..9dd757b 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -123,11 +123,11 @@ static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 	return 0;
 }
 
-static int get_pfn_vq(struct kvm *kvm, void *dev, u32 vq)
+static struct virt_queue *get_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct rng_dev *rdev = dev;
 
-	return rdev->vqs[vq].pfn;
+	return &rdev->vqs[vq];
 }
 
 static int get_size_vq(struct kvm *kvm, void *dev, u32 vq)
@@ -152,7 +152,7 @@ static struct virtio_ops rng_dev_virtio_ops = {
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
 	.notify_vq		= notify_vq,
-	.get_pfn_vq		= get_pfn_vq,
+	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
 	.set_size_vq		= set_size_vq,
 	.get_vq_count		= get_vq_count,
diff --git a/virtio/scsi.c b/virtio/scsi.c
index e21263c..c8400b6 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -150,11 +150,11 @@ static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 	return 0;
 }
 
-static int get_pfn_vq(struct kvm *kvm, void *dev, u32 vq)
+static struct virt_queue *get_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct scsi_dev *sdev = dev;
 
-	return sdev->vqs[vq].pfn;
+	return &sdev->vqs[vq];
 }
 
 static int get_size_vq(struct kvm *kvm, void *dev, u32 vq)
@@ -177,7 +177,7 @@ static struct virtio_ops scsi_dev_virtio_ops = {
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
-	.get_pfn_vq		= get_pfn_vq,
+	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
 	.set_size_vq		= set_size_vq,
 	.notify_status		= notify_status,
-- 
1.9.1
