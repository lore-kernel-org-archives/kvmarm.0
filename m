From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH] vhost: Fix vhost_copy_to_user()
Date: Wed, 11 Apr 2018 15:30:38 +0200
Message-ID: <1523453438-4266-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, kvm@vger.kernel.org, jasowang@redhat.com, mst@redhat.com, kvmarm@lists.cs.columbia.edu
Cc: stefanha@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

vhost_copy_to_user is used to copy vring used elements to userspace.
We should use VHOST_ADDR_USED instead of VHOST_ADDR_DESC.

Fixes: f88949138058 ("vhost: introduce O(1) vq metadata cache")
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

This fixes a stall observed when running an aarch64 guest with
virtual smmu
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index bec722e..f44aead 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -744,7 +744,7 @@ static int vhost_copy_to_user(struct vhost_virtqueue *vq, void __user *to,
 		struct iov_iter t;
 		void __user *uaddr = vhost_vq_meta_fetch(vq,
 				     (u64)(uintptr_t)to, size,
-				     VHOST_ADDR_DESC);
+				     VHOST_ADDR_USED);
 
 		if (uaddr)
 			return __copy_to_user(uaddr, from, size);
-- 
2.5.5
