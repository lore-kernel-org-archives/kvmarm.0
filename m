From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 3/3] virtio: fix endianness check for vhost support
Date: Tue,  1 Mar 2016 16:49:38 +0000
Message-ID: <1456850978-14091-4-git-send-email-andre.przywara@arm.com>
References: <1456850978-14091-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B87941267
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 11:42:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2bfjT6CxK5sg for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2016 11:42:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6420411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 11:42:40 -0500 (EST)
In-Reply-To: <1456850978-14091-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Sasha Levin <sasha.levin@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently we deny any VHOST_* functionality if the architecture
supports guests with different endianness than the host. Most of the
time even on those architectures the endianness of guest and host are
the same, though, so we are denying the glory of VHOST needlessly.
Switch from compile time determination to a run time scheme, which
takes the actual endianness of the guest into account.
For this we change the semantics of VIRTIO_ENDIAN_HOST to return the
actual endianness of the host (the endianness of kvmtool at compile
time, really). The actual check in vhost_net now compares this against
the guest endianness.
This enables vhost support on ARM and ARM64.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/virtio.h | 9 +++++++--
 virtio/net.c         | 2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 768ee96..66530fd 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -17,10 +17,15 @@
 #define VIRTIO_PCI_O_CONFIG	0
 #define VIRTIO_PCI_O_MSIX	1
 
-#define VIRTIO_ENDIAN_HOST	0
 #define VIRTIO_ENDIAN_LE	(1 << 0)
 #define VIRTIO_ENDIAN_BE	(1 << 1)
 
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define VIRTIO_ENDIAN_HOST VIRTIO_ENDIAN_LE
+#else
+#define VIRTIO_ENDIAN_HOST VIRTIO_ENDIAN_BE
+#endif
+
 struct virt_queue {
 	struct vring	vring;
 	u32		pfn;
@@ -40,7 +45,7 @@ struct virt_queue {
 #define VIRTIO_RING_ENDIAN VIRTIO_ENDIAN_HOST
 #endif
 
-#if (VIRTIO_RING_ENDIAN & (VIRTIO_ENDIAN_LE | VIRTIO_ENDIAN_BE))
+#if VIRTIO_RING_ENDIAN != VIRTIO_ENDIAN_HOST
 
 static inline __u16 __virtio_g2h_u16(u16 endian, __u16 val)
 {
diff --git a/virtio/net.c b/virtio/net.c
index 6d1be65..e94e37a 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -531,7 +531,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	}
 
 	if (queue->endian != VIRTIO_ENDIAN_HOST)
-		die_perror("VHOST requires VIRTIO_ENDIAN_HOST");
+		die_perror("VHOST requires the same endianness in guest and host");
 
 	state.num = queue->vring.num;
 	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_NUM, &state);
-- 
2.6.4
