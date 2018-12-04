From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 09/13] virtio/net: Implement device and virtqueue reset
Date: Tue,  4 Dec 2018 11:08:42 +0000
Message-ID: <1543921726-54571-10-git-send-email-julien.thierry@arm.com>
References: <1543921726-54571-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 985E94A372
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:09:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OHynwfaIfQux for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 06:09:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C57314A38E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:09:03 -0500 (EST)
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

On exit_vq(), clean all resources allocated for the queue. When the device
is reset, clean the backend.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 virtio/net.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/virtio/net.c b/virtio/net.c
index ef8e226..a05f4cd 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -43,6 +43,8 @@ struct net_dev_queue {
 	pthread_t			thread;
 	struct mutex			lock;
 	pthread_cond_t			cond;
+	int				gsi;
+	int				irqfd;
 };
 
 struct net_dev {
@@ -361,6 +363,23 @@ fail:
 	return 0;
 }
 
+static void virtio_net__tap_exit(struct net_dev *ndev)
+{
+	int sock;
+	struct ifreq ifr;
+
+	if (ndev->params->tapif)
+		return;
+
+	sock = socket(AF_INET, SOCK_STREAM, 0);
+	strncpy(ifr.ifr_name, ndev->tap_name, sizeof(ndev->tap_name));
+	ioctl(sock, SIOCGIFFLAGS, &ifr);
+	ifr.ifr_flags &= ~(IFF_UP | IFF_RUNNING);
+	if (ioctl(sock, SIOCGIFFLAGS, &ifr) < 0)
+		pr_warning("Count not bring tap device down");
+	close(sock);
+}
+
 static bool virtio_net__tap_create(struct net_dev *ndev)
 {
 	int offload;
@@ -533,10 +552,21 @@ static void virtio_net_start(struct net_dev *ndev)
 	}
 }
 
+static void virtio_net_stop(struct net_dev *ndev)
+{
+	/* Undo whatever start() did */
+	if (ndev->mode == NET_MODE_TAP)
+		virtio_net__tap_exit(ndev);
+	else
+		uip_exit(&ndev->info);
+}
+
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
 	if (status & VIRTIO__STATUS_START)
 		virtio_net_start(dev);
+	else if (status & VIRTIO__STATUS_STOP)
+		virtio_net_stop(dev);
 }
 
 static bool is_ctrl_vq(struct net_dev *ndev, u32 vq)
@@ -611,6 +641,35 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	return 0;
 }
 
+static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	struct net_dev *ndev = dev;
+	struct net_dev_queue *queue = &ndev->queues[vq];
+
+	if (!is_ctrl_vq(ndev, vq) && queue->gsi) {
+		irq__del_irqfd(kvm, queue->gsi, queue->irqfd);
+		close(queue->irqfd);
+		queue->gsi = queue->irqfd = 0;
+	}
+
+	/*
+	 * TODO: vhost reset owner. It's the only way to cleanly stop vhost, but
+	 * we can't restart it at the moment.
+	 */
+	if (ndev->vhost_fd && !is_ctrl_vq(ndev, vq)) {
+		pr_warning("Cannot reset VHOST queue");
+		ioctl(ndev->vhost_fd, VHOST_RESET_OWNER);
+		return;
+	}
+
+	/*
+	 * Threads are waiting on cancellation points (readv or
+	 * pthread_cond_wait) and should stop gracefully.
+	 */
+	pthread_cancel(queue->thread);
+	pthread_join(queue->thread, NULL);
+}
+
 static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 {
 	struct net_dev *ndev = dev;
@@ -630,6 +689,9 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 	if (r < 0)
 		die_perror("KVM_IRQFD failed");
 
+	queue->irqfd = file.fd;
+	queue->gsi = gsi;
+
 	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_CALL, &file);
 	if (r < 0)
 		die_perror("VHOST_SET_VRING_CALL failed");
@@ -698,6 +760,7 @@ static struct virtio_ops net_dev_virtio_ops = {
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
 	.init_vq		= init_vq,
+	.exit_vq		= exit_vq,
 	.get_vq			= get_vq,
 	.get_size_vq		= get_size_vq,
 	.set_size_vq		= set_size_vq,
-- 
1.9.1
