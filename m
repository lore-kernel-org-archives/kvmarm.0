From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 08/13] virtio/net: Clean virtqueue state
Date: Tue,  4 Dec 2018 11:08:41 +0000
Message-ID: <1543921726-54571-9-git-send-email-julien.thierry@arm.com>
References: <1543921726-54571-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C99CA4A359
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:09:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JlfSfqx5iqTs for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 06:09:03 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B73A4A380
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:09:02 -0500 (EST)
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

Currently the virtqueue state is mixed with the netdev state. Move it to a
separate structure.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 virtio/net.c | 110 +++++++++++++++++++++++++++++++----------------------------
 1 file changed, 57 insertions(+), 53 deletions(-)

diff --git a/virtio/net.c b/virtio/net.c
index d65d04e..ef8e226 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -36,18 +36,23 @@ struct net_dev_operations {
 	int (*tx)(struct iovec *iov, u16 in, struct net_dev *ndev);
 };
 
+struct net_dev_queue {
+	int				id;
+	struct net_dev			*ndev;
+	struct virt_queue		vq;
+	pthread_t			thread;
+	struct mutex			lock;
+	pthread_cond_t			cond;
+};
+
 struct net_dev {
 	struct mutex			mutex;
 	struct virtio_device		vdev;
 	struct list_head		list;
 
-	struct virt_queue		vqs[VIRTIO_NET_NUM_QUEUES * 2 + 1];
+	struct net_dev_queue		queues[VIRTIO_NET_NUM_QUEUES * 2 + 1];
 	struct virtio_net_config	config;
-	u32				features, rx_vqs, tx_vqs, queue_pairs;
-
-	pthread_t			io_thread[VIRTIO_NET_NUM_QUEUES * 2 + 1];
-	struct mutex			io_lock[VIRTIO_NET_NUM_QUEUES * 2 + 1];
-	pthread_cond_t			io_cond[VIRTIO_NET_NUM_QUEUES * 2 + 1];
+	u32				features, queue_pairs;
 
 	int				vhost_fd;
 	int				tap_fd;
@@ -92,28 +97,22 @@ static void virtio_net_fix_rx_hdr(struct virtio_net_hdr *hdr, struct net_dev *nd
 static void *virtio_net_rx_thread(void *p)
 {
 	struct iovec iov[VIRTIO_NET_QUEUE_SIZE];
-	struct virt_queue *vq;
+	struct net_dev_queue *queue = p;
+	struct virt_queue *vq = &queue->vq;
+	struct net_dev *ndev = queue->ndev;
 	struct kvm *kvm;
-	struct net_dev *ndev = p;
 	u16 out, in;
 	u16 head;
 	int len, copied;
-	u32 id;
-
-	mutex_lock(&ndev->mutex);
-	id = ndev->rx_vqs++ * 2;
-	mutex_unlock(&ndev->mutex);
 
 	kvm__set_thread_name("virtio-net-rx");
 
 	kvm = ndev->kvm;
-	vq = &ndev->vqs[id];
-
 	while (1) {
-		mutex_lock(&ndev->io_lock[id]);
+		mutex_lock(&queue->lock);
 		if (!virt_queue__available(vq))
-			pthread_cond_wait(&ndev->io_cond[id], &ndev->io_lock[id].mutex);
-		mutex_unlock(&ndev->io_lock[id]);
+			pthread_cond_wait(&queue->cond, &queue->lock.mutex);
+		mutex_unlock(&queue->lock);
 
 		while (virt_queue__available(vq)) {
 			unsigned char buffer[MAX_PACKET_SIZE + sizeof(struct virtio_net_hdr_mrg_rxbuf)];
@@ -127,7 +126,7 @@ static void *virtio_net_rx_thread(void *p)
 			len = ndev->ops->rx(&dummy_iov, 1, ndev);
 			if (len < 0) {
 				pr_warning("%s: rx on vq %u failed (%d), exiting thread\n",
-						__func__, id, len);
+						__func__, queue->id, len);
 				goto out_err;
 			}
 
@@ -155,7 +154,7 @@ static void *virtio_net_rx_thread(void *p)
 
 			/* We should interrupt guest right now, otherwise latency is huge. */
 			if (virtio_queue__should_signal(vq))
-				ndev->vdev.ops->signal_vq(kvm, &ndev->vdev, id);
+				ndev->vdev.ops->signal_vq(kvm, &ndev->vdev, queue->id);
 		}
 	}
 
@@ -168,28 +167,23 @@ out_err:
 static void *virtio_net_tx_thread(void *p)
 {
 	struct iovec iov[VIRTIO_NET_QUEUE_SIZE];
-	struct virt_queue *vq;
+	struct net_dev_queue *queue = p;
+	struct virt_queue *vq = &queue->vq;
+	struct net_dev *ndev = queue->ndev;
 	struct kvm *kvm;
-	struct net_dev *ndev = p;
 	u16 out, in;
 	u16 head;
 	int len;
-	u32 id;
-
-	mutex_lock(&ndev->mutex);
-	id = ndev->tx_vqs++ * 2 + 1;
-	mutex_unlock(&ndev->mutex);
 
 	kvm__set_thread_name("virtio-net-tx");
 
 	kvm = ndev->kvm;
-	vq = &ndev->vqs[id];
 
 	while (1) {
-		mutex_lock(&ndev->io_lock[id]);
+		mutex_lock(&queue->lock);
 		if (!virt_queue__available(vq))
-			pthread_cond_wait(&ndev->io_cond[id], &ndev->io_lock[id].mutex);
-		mutex_unlock(&ndev->io_lock[id]);
+			pthread_cond_wait(&queue->cond, &queue->lock.mutex);
+		mutex_unlock(&queue->lock);
 
 		while (virt_queue__available(vq)) {
 			struct virtio_net_hdr *hdr;
@@ -199,7 +193,7 @@ static void *virtio_net_tx_thread(void *p)
 			len = ndev->ops->tx(iov, out, ndev);
 			if (len < 0) {
 				pr_warning("%s: tx on vq %u failed (%d)\n",
-						__func__, id, errno);
+						__func__, queue->id, errno);
 				goto out_err;
 			}
 
@@ -207,7 +201,7 @@ static void *virtio_net_tx_thread(void *p)
 		}
 
 		if (virtio_queue__should_signal(vq))
-			ndev->vdev.ops->signal_vq(kvm, &ndev->vdev, id);
+			ndev->vdev.ops->signal_vq(kvm, &ndev->vdev, queue->id);
 	}
 
 out_err:
@@ -224,24 +218,24 @@ static virtio_net_ctrl_ack virtio_net_handle_mq(struct kvm* kvm, struct net_dev
 static void *virtio_net_ctrl_thread(void *p)
 {
 	struct iovec iov[VIRTIO_NET_QUEUE_SIZE];
+	struct net_dev_queue *queue = p;
+	struct virt_queue *vq = &queue->vq;
+	struct net_dev *ndev = queue->ndev;
 	u16 out, in, head;
-	struct net_dev *ndev = p;
 	struct kvm *kvm = ndev->kvm;
-	u32 id = ndev->queue_pairs * 2;
-	struct virt_queue *vq = &ndev->vqs[id];
 	struct virtio_net_ctrl_hdr *ctrl;
 	virtio_net_ctrl_ack *ack;
 
 	kvm__set_thread_name("virtio-net-ctrl");
 
 	while (1) {
-		mutex_lock(&ndev->io_lock[id]);
+		mutex_lock(&queue->lock);
 		if (!virt_queue__available(vq))
-			pthread_cond_wait(&ndev->io_cond[id], &ndev->io_lock[id].mutex);
-		mutex_unlock(&ndev->io_lock[id]);
+			pthread_cond_wait(&queue->cond, &queue->lock.mutex);
+		mutex_unlock(&queue->lock);
 
 		while (virt_queue__available(vq)) {
-			head = virt_queue__get_iov(&ndev->vqs[id], iov, &out, &in, kvm);
+			head = virt_queue__get_iov(vq, iov, &out, &in, kvm);
 			ctrl = iov[0].iov_base;
 			ack = iov[out].iov_base;
 
@@ -253,11 +247,11 @@ static void *virtio_net_ctrl_thread(void *p)
 				*ack = VIRTIO_NET_ERR;
 				break;
 			}
-			virt_queue__set_used_elem(&ndev->vqs[id], head, iov[out].iov_len);
+			virt_queue__set_used_elem(vq, head, iov[out].iov_len);
 		}
 
-		if (virtio_queue__should_signal(&ndev->vqs[id]))
-			ndev->vdev.ops->signal_vq(kvm, &ndev->vdev, id);
+		if (virtio_queue__should_signal(vq))
+			ndev->vdev.ops->signal_vq(kvm, &ndev->vdev, queue->id);
 	}
 
 	pthread_exit(NULL);
@@ -267,14 +261,16 @@ static void *virtio_net_ctrl_thread(void *p)
 
 static void virtio_net_handle_callback(struct kvm *kvm, struct net_dev *ndev, int queue)
 {
+	struct net_dev_queue *net_queue = &ndev->queues[queue];
+
 	if ((u32)queue >= (ndev->queue_pairs * 2 + 1)) {
 		pr_warning("Unknown queue index %u", queue);
 		return;
 	}
 
-	mutex_lock(&ndev->io_lock[queue]);
-	pthread_cond_signal(&ndev->io_cond[queue]);
-	mutex_unlock(&ndev->io_lock[queue]);
+	mutex_lock(&net_queue->lock);
+	pthread_cond_signal(&net_queue->cond);
+	mutex_unlock(&net_queue->lock);
 }
 
 static int virtio_net_request_tap(struct net_dev *ndev, struct ifreq *ifr,
@@ -552,6 +548,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 		   u32 pfn)
 {
 	struct vhost_vring_state state = { .index = vq };
+	struct net_dev_queue *net_queue;
 	struct vhost_vring_addr addr;
 	struct net_dev *ndev = dev;
 	struct virt_queue *queue;
@@ -560,24 +557,30 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 
 	compat__remove_message(compat_id);
 
-	queue		= &ndev->vqs[vq];
+	net_queue	= &ndev->queues[vq];
+	net_queue->id	= vq;
+	net_queue->ndev	= ndev;
+	queue		= &net_queue->vq;
 	queue->pfn	= pfn;
 	p		= virtio_get_vq(kvm, queue->pfn, page_size);
 
 	vring_init(&queue->vring, VIRTIO_NET_QUEUE_SIZE, p, align);
 	virtio_init_device_vq(&ndev->vdev, queue);
 
-	mutex_init(&ndev->io_lock[vq]);
-	pthread_cond_init(&ndev->io_cond[vq], NULL);
+	mutex_init(&net_queue->lock);
+	pthread_cond_init(&net_queue->cond, NULL);
 	if (is_ctrl_vq(ndev, vq)) {
-		pthread_create(&ndev->io_thread[vq], NULL, virtio_net_ctrl_thread, ndev);
+		pthread_create(&net_queue->thread, NULL, virtio_net_ctrl_thread,
+			       net_queue);
 
 		return 0;
 	} else if (ndev->vhost_fd == 0 ) {
 		if (vq & 1)
-			pthread_create(&ndev->io_thread[vq], NULL, virtio_net_tx_thread, ndev);
+			pthread_create(&net_queue->thread, NULL,
+				       virtio_net_tx_thread, net_queue);
 		else
-			pthread_create(&ndev->io_thread[vq], NULL, virtio_net_rx_thread, ndev);
+			pthread_create(&net_queue->thread, NULL,
+				       virtio_net_rx_thread, net_queue);
 
 		return 0;
 	}
@@ -611,6 +614,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 {
 	struct net_dev *ndev = dev;
+	struct net_dev_queue *queue = &ndev->queues[vq];
 	struct vhost_vring_file file;
 	int r;
 
@@ -666,7 +670,7 @@ static struct virt_queue *get_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct net_dev *ndev = dev;
 
-	return &ndev->vqs[vq];
+	return &ndev->queues[vq].vq;
 }
 
 static int get_size_vq(struct kvm *kvm, void *dev, u32 vq)
-- 
1.9.1
