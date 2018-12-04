From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 10/13] virtio/blk: Reset virtqueue
Date: Tue,  4 Dec 2018 11:08:43 +0000
Message-ID: <1543921726-54571-11-git-send-email-julien.thierry@arm.com>
References: <1543921726-54571-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 949CE4A348
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:09:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yu+qjbFufnYc for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 06:09:05 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F7E84A386
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:09:05 -0500 (EST)
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

Move pthread creation to init_vq, and kill the thread in exit_vq.
Initialize the virtqueue states at runtime.

All in-flight I/O is canceled with the virtqueue pthreads, except for AIO
threads, but after reading the code I'm not sure if AIO has ever worked
anyway.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 virtio/blk.c | 67 ++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/virtio/blk.c b/virtio/blk.c
index 6a6b3b7..a57df2e 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -178,9 +178,29 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
 }
 
+static void *virtio_blk_thread(void *dev)
+{
+	struct blk_dev *bdev = dev;
+	u64 data;
+	int r;
+
+	kvm__set_thread_name("virtio-blk-io");
+
+	while (1) {
+		r = read(bdev->io_efd, &data, sizeof(u64));
+		if (r < 0)
+			continue;
+		virtio_blk_do_io(bdev->kvm, &bdev->vqs[0], bdev);
+	}
+
+	pthread_exit(NULL);
+	return NULL;
+}
+
 static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 		   u32 pfn)
 {
+	unsigned int i;
 	struct blk_dev *bdev = dev;
 	struct virt_queue *queue;
 	void *p;
@@ -194,26 +214,37 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	vring_init(&queue->vring, VIRTIO_BLK_QUEUE_SIZE, p, align);
 	virtio_init_device_vq(&bdev->vdev, queue);
 
+	if (vq != 0)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(bdev->reqs); i++) {
+		bdev->reqs[i] = (struct blk_dev_req) {
+			.bdev = bdev,
+			.kvm = kvm,
+		};
+	}
+
+	mutex_init(&bdev->mutex);
+	bdev->io_efd = eventfd(0, 0);
+	if (bdev->io_efd < 0)
+		return -errno;
+
+	if (pthread_create(&bdev->io_thread, NULL, virtio_blk_thread, bdev))
+		return -errno;
+
 	return 0;
 }
 
-static void *virtio_blk_thread(void *dev)
+static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct blk_dev *bdev = dev;
-	u64 data;
-	int r;
 
-	kvm__set_thread_name("virtio-blk-io");
+	if (vq != 0)
+		return;
 
-	while (1) {
-		r = read(bdev->io_efd, &data, sizeof(u64));
-		if (r < 0)
-			continue;
-		virtio_blk_do_io(bdev->kvm, &bdev->vqs[0], bdev);
-	}
-
-	pthread_exit(NULL);
-	return NULL;
+	close(bdev->io_efd);
+	pthread_cancel(bdev->io_thread);
+	pthread_join(bdev->io_thread, NULL);
 }
 
 static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
@@ -259,6 +290,7 @@ static struct virtio_ops blk_dev_virtio_ops = {
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
 	.init_vq		= init_vq,
+	.exit_vq		= exit_vq,
 	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
 	.get_vq			= get_vq,
@@ -269,7 +301,6 @@ static struct virtio_ops blk_dev_virtio_ops = {
 static int virtio_blk__init_one(struct kvm *kvm, struct disk_image *disk)
 {
 	struct blk_dev *bdev;
-	unsigned int i;
 
 	if (!disk)
 		return -EINVAL;
@@ -279,13 +310,11 @@ static int virtio_blk__init_one(struct kvm *kvm, struct disk_image *disk)
 		return -ENOMEM;
 
 	*bdev = (struct blk_dev) {
-		.mutex			= MUTEX_INITIALIZER,
 		.disk			= disk,
 		.blk_config		= (struct virtio_blk_config) {
 			.capacity	= disk->size / SECTOR_SIZE,
 			.seg_max	= DISK_SEG_MAX,
 		},
-		.io_efd			= eventfd(0, 0),
 		.kvm			= kvm,
 	};
 
@@ -295,14 +324,8 @@ static int virtio_blk__init_one(struct kvm *kvm, struct disk_image *disk)
 
 	list_add_tail(&bdev->list, &bdevs);
 
-	for (i = 0; i < ARRAY_SIZE(bdev->reqs); i++) {
-		bdev->reqs[i].bdev = bdev;
-		bdev->reqs[i].kvm = kvm;
-	}
-
 	disk_image__set_callback(bdev->disk, virtio_blk_complete);
 
-	pthread_create(&bdev->io_thread, NULL, virtio_blk_thread, bdev);
 	if (compat_id == -1)
 		compat_id = virtio_compat_add_message("virtio-blk", "CONFIG_VIRTIO_BLK");
 
-- 
1.9.1
