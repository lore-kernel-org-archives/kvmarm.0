From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v9 05/15] virtio: fix endianness check for vhost support
Date: Thu,  2 Feb 2017 16:32:13 +0000
Message-ID: <20170202163223.15372-6-andre.przywara@arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170202163223.15372-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
2.9.0
