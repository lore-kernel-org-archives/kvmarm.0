From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool v2 12/13] virtio/p9: Implement reset
Date: Thu, 10 Jan 2019 14:12:49 +0000
Message-ID: <1547129570-14351-13-git-send-email-julien.thierry@arm.com>
References: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 697BA4A450
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GDLZEgLup7Ym for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:13:15 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28C704A492
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:13:14 -0500 (EST)
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

The p9 reset cancels all running jobs and closes any open fid.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 virtio/9p.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/virtio/9p.c b/virtio/9p.c
index d9f45cf..6bae403 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1384,6 +1384,14 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
+	struct p9_dev *p9dev = dev;
+	struct p9_fid *pfid, *next;
+
+	if (!(status & VIRTIO__STATUS_STOP))
+		return;
+
+	rbtree_postorder_for_each_entry_safe(pfid, next, &p9dev->fids, node)
+		close_fid(p9dev, pfid->fid);
 }
 
 static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
@@ -1413,6 +1421,13 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	return 0;
 }
 
+static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	struct p9_dev *p9dev = dev;
+
+	thread_pool__cancel_job(&p9dev->jobs[vq].job_id);
+}
+
 static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct p9_dev *p9dev = dev;
@@ -1450,6 +1465,7 @@ struct virtio_ops p9_dev_virtio_ops = {
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
+	.exit_vq		= exit_vq,
 	.notify_status		= notify_status,
 	.notify_vq		= notify_vq,
 	.get_vq			= get_vq,
-- 
1.9.1
