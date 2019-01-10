From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool v2 13/13] virtio/console: Implement reset
Date: Thu, 10 Jan 2019 14:12:50 +0000
Message-ID: <1547129570-14351-14-git-send-email-julien.thierry@arm.com>
References: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2374F4A473
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a3GvvrgfpAdC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:13:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B202D4A4C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:15 -0500 (EST)
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

The virtio-console reset cancels all running jobs.

Unfortunately we don't have a good way to prevent the term polling thread
from getting in the way, read invalid data during reset and cause a
segfault. To prevent this, move all handling of the Rx queue in the
threadpool job.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 virtio/console.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/virtio/console.c b/virtio/console.c
index d2b312c..f1be025 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -35,8 +35,6 @@ struct con_dev {
 	struct virt_queue		vqs[VIRTIO_CONSOLE_NUM_QUEUES];
 	struct virtio_console_config	config;
 	u32				features;
-
-	pthread_cond_t			poll_cond;
 	int				vq_ready;
 
 	struct thread_pool__job		jobs[VIRTIO_CONSOLE_NUM_QUEUES];
@@ -44,7 +42,6 @@ struct con_dev {
 
 static struct con_dev cdev = {
 	.mutex				= MUTEX_INITIALIZER,
-	.poll_cond			= PTHREAD_COND_INITIALIZER,
 
 	.vq_ready			= 0,
 
@@ -68,16 +65,10 @@ static void virtio_console__inject_interrupt_callback(struct kvm *kvm, void *par
 	u16 head;
 	int len;
 
-	if (kvm->cfg.active_console != CONSOLE_VIRTIO)
-		return;
-
 	mutex_lock(&cdev.mutex);
 
 	vq = param;
 
-	if (!cdev.vq_ready)
-		pthread_cond_wait(&cdev.poll_cond, &cdev.mutex.mutex);
-
 	if (term_readable(0) && virt_queue__available(vq)) {
 		head = virt_queue__get_iov(vq, iov, &out, &in, kvm);
 		len = term_getc_iov(kvm, iov, in, 0);
@@ -90,8 +81,13 @@ static void virtio_console__inject_interrupt_callback(struct kvm *kvm, void *par
 
 void virtio_console__inject_interrupt(struct kvm *kvm)
 {
-	virtio_console__inject_interrupt_callback(kvm,
-					&cdev.vqs[VIRTIO_CONSOLE_RX_QUEUE]);
+	if (kvm->cfg.active_console != CONSOLE_VIRTIO)
+		return;
+
+	mutex_lock(&cdev.mutex);
+	if (cdev.vq_ready)
+		thread_pool__do_job(&cdev.jobs[VIRTIO_CONSOLE_RX_QUEUE]);
+	mutex_unlock(&cdev.mutex);
 }
 
 static void virtio_console_handle_callback(struct kvm *kvm, void *param)
@@ -168,13 +164,24 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 		/* Tell the waiting poll thread that we're ready to go */
 		mutex_lock(&cdev.mutex);
 		cdev.vq_ready = 1;
-		pthread_cond_signal(&cdev.poll_cond);
 		mutex_unlock(&cdev.mutex);
 	}
 
 	return 0;
 }
 
+static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	if (vq == VIRTIO_CONSOLE_RX_QUEUE) {
+		mutex_lock(&cdev.mutex);
+		cdev.vq_ready = 0;
+		mutex_unlock(&cdev.mutex);
+		thread_pool__cancel_job(&cdev.jobs[vq]);
+	} else if (vq == VIRTIO_CONSOLE_TX_QUEUE) {
+		thread_pool__cancel_job(&cdev.jobs[vq]);
+	}
+}
+
 static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct con_dev *cdev = dev;
@@ -213,6 +220,7 @@ static struct virtio_ops con_dev_virtio_ops = {
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
 	.init_vq		= init_vq,
+	.exit_vq		= exit_vq,
 	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
 	.get_vq			= get_vq,
-- 
1.9.1
