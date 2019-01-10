From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool v2 03/13] virtio: Add get_vq_count() callback
Date: Thu, 10 Jan 2019 14:12:40 +0000
Message-ID: <1547129570-14351-4-git-send-email-julien.thierry@arm.com>
References: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0257B4A429
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OZleA5g70Hat for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:13:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3CC54A471
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:01 -0500 (EST)
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

Modern virtio requires devices to report how many queues they support. Add
an operation to query all devices about their capacities.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 include/kvm/virtio.h | 1 +
 virtio/9p.c          | 6 ++++++
 virtio/balloon.c     | 6 ++++++
 virtio/blk.c         | 6 ++++++
 virtio/console.c     | 6 ++++++
 virtio/net.c         | 8 ++++++++
 virtio/rng.c         | 6 ++++++
 virtio/scsi.c        | 6 ++++++
 8 files changed, 45 insertions(+)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index f143321..cc49c9d 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -184,6 +184,7 @@ struct virtio_ops {
 	u8 *(*get_config)(struct kvm *kvm, void *dev);
 	u32 (*get_host_features)(struct kvm *kvm, void *dev);
 	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
+	int (*get_vq_count)(struct kvm *kvm, void *dev);
 	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq, u32 page_size,
 		       u32 align, u32 pfn);
 	int (*notify_vq)(struct kvm *kvm, void *dev, u32 vq);
diff --git a/virtio/9p.c b/virtio/9p.c
index 4b93b4c..94f7a8f 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1440,6 +1440,11 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
+static int get_vq_count(struct kvm *kvm, void *dev)
+{
+	return NUM_VIRT_QUEUES;
+}
+
 struct virtio_ops p9_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
@@ -1450,6 +1455,7 @@ struct virtio_ops p9_dev_virtio_ops = {
 	.get_pfn_vq		= get_pfn_vq,
 	.get_size_vq		= get_size_vq,
 	.set_size_vq		= set_size_vq,
+	.get_vq_count		= get_vq_count,
 };
 
 int virtio_9p_rootdir_parser(const struct option *opt, const char *arg, int unset)
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 871d6e0..2c2e24a 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -243,6 +243,11 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
+static int get_vq_count(struct kvm *kvm, void *dev)
+{
+	return NUM_VIRT_QUEUES;
+}
+
 struct virtio_ops bln_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
@@ -253,6 +258,7 @@ struct virtio_ops bln_dev_virtio_ops = {
 	.get_pfn_vq		= get_pfn_vq,
 	.get_size_vq		= get_size_vq,
 	.set_size_vq            = set_size_vq,
+	.get_vq_count		= get_vq_count,
 };
 
 int virtio_bln__init(struct kvm *kvm)
diff --git a/virtio/blk.c b/virtio/blk.c
index db9f4cc..6502b8c 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -248,10 +248,16 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
+static int get_vq_count(struct kvm *kvm, void *dev)
+{
+	return NUM_VIRT_QUEUES;
+}
+
 static struct virtio_ops blk_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
+	.get_vq_count		= get_vq_count,
 	.init_vq		= init_vq,
 	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
diff --git a/virtio/console.c b/virtio/console.c
index b9df5c9..c96bc11 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -202,10 +202,16 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
+static int get_vq_count(struct kvm *kvm, void *dev)
+{
+	return VIRTIO_CONSOLE_NUM_QUEUES;
+}
+
 static struct virtio_ops con_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
+	.get_vq_count		= get_vq_count,
 	.init_vq		= init_vq,
 	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
diff --git a/virtio/net.c b/virtio/net.c
index 619b545..3b08aea 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -681,10 +681,18 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
+static int get_vq_count(struct kvm *kvm, void *dev)
+{
+	struct net_dev *ndev = dev;
+
+	return ndev->queue_pairs * 2 + 1;
+}
+
 static struct virtio_ops net_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
+	.get_vq_count		= get_vq_count,
 	.init_vq		= init_vq,
 	.get_pfn_vq		= get_pfn_vq,
 	.get_size_vq		= get_size_vq,
diff --git a/virtio/rng.c b/virtio/rng.c
index 9b9e128..fc0e320 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -141,6 +141,11 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
+static int get_vq_count(struct kvm *kvm, void *dev)
+{
+	return NUM_VIRT_QUEUES;
+}
+
 static struct virtio_ops rng_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
@@ -150,6 +155,7 @@ static struct virtio_ops rng_dev_virtio_ops = {
 	.get_pfn_vq		= get_pfn_vq,
 	.get_size_vq		= get_size_vq,
 	.set_size_vq		= set_size_vq,
+	.get_vq_count		= get_vq_count,
 };
 
 int virtio_rng__init(struct kvm *kvm)
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 788bfa2..e21263c 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -167,6 +167,11 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
+static int get_vq_count(struct kvm *kvm, void *dev)
+{
+	return NUM_VIRT_QUEUES;
+}
+
 static struct virtio_ops scsi_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
@@ -179,6 +184,7 @@ static struct virtio_ops scsi_dev_virtio_ops = {
 	.notify_vq		= notify_vq,
 	.notify_vq_gsi		= notify_vq_gsi,
 	.notify_vq_eventfd	= notify_vq_eventfd,
+	.get_vq_count		= get_vq_count,
 };
 
 static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
-- 
1.9.1
