From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 11/16] mmio: Allow mmio callbacks to be called without
 locking
Date: Thu,  7 Mar 2019 08:36:12 +0000
Message-ID: <1551947777-13044-12-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D0974A4D3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qd9XEgIiA39B for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:41 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2F364A4C2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:40 -0500 (EST)
In-Reply-To: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Andre.Przywara@arm.com, Sami.Mujawar@arm.com, will.deacon@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

A vcpu might reconfigure some memory mapped region while other vcpus
access another one. Currently, edit to one mmio region blocks all other
mmio accesses.

Execute mmio callbacks outside of locking, protecting mmio data with
ref counting to prevent data being deleted while callback runs.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 mmio.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/mmio.c b/mmio.c
index 61e1d47..03e1a76 100644
--- a/mmio.c
+++ b/mmio.c
@@ -2,6 +2,7 @@
 #include "kvm/kvm-cpu.h"
 #include "kvm/rbtree-interval.h"
 #include "kvm/brlock.h"
+#include "kvm/ref_cnt.h"
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -19,10 +20,18 @@ struct mmio_mapping {
 	struct rb_int_node	node;
 	void			(*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr);
 	void			*ptr;
+	struct ref_cnt		ref_cnt;
 };
 
 static struct rb_root mmio_tree = RB_ROOT;
 
+static void mmio_release(struct ref_cnt *ref_cnt)
+{
+	struct mmio_mapping * mmio = container_of(ref_cnt, struct mmio_mapping, ref_cnt);
+
+	free(mmio);
+}
+
 static struct mmio_mapping *mmio_search(struct rb_root *root, u64 addr, u64 len)
 {
 	struct rb_int_node *node;
@@ -75,6 +84,7 @@ int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool c
 		.node = RB_INT_INIT(phys_addr, phys_addr + phys_addr_len),
 		.mmio_fn = mmio_fn,
 		.ptr	= ptr,
+		.ref_cnt = REF_CNT_INIT,
 	};
 
 	if (coalesce) {
@@ -89,6 +99,7 @@ int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool c
 		}
 	}
 	br_write_lock(kvm);
+	/* Pass ref to tree, no need to put ref */
 	ret = mmio_insert(&mmio_tree, mmio);
 	br_write_unlock(kvm);
 
@@ -106,6 +117,7 @@ bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
 		br_write_unlock(kvm);
 		return false;
 	}
+	/* Taking the ref from the tree */
 
 	zone = (struct kvm_coalesced_mmio_zone) {
 		.addr	= phys_addr,
@@ -114,9 +126,10 @@ bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
 	ioctl(kvm->vm_fd, KVM_UNREGISTER_COALESCED_MMIO, &zone);
 
 	rb_int_erase(&mmio_tree, &mmio->node);
+	ref_put(&mmio->ref_cnt, mmio_release);
+
 	br_write_unlock(kvm);
 
-	free(mmio);
 	return true;
 }
 
@@ -127,15 +140,20 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u
 	br_read_lock(vcpu->kvm);
 	mmio = mmio_search(&mmio_tree, phys_addr, len);
 
-	if (mmio)
-		mmio->mmio_fn(vcpu, phys_addr, data, len, is_write, mmio->ptr);
-	else {
+	if (!mmio) {
+		br_read_unlock(vcpu->kvm);
 		if (vcpu->kvm->cfg.mmio_debug)
 			fprintf(stderr,	"Warning: Ignoring MMIO %s at %016llx (length %u)\n",
 				to_direction(is_write),
 				(unsigned long long)phys_addr, len);
+		return true;
 	}
+
+	ref_get(&mmio->ref_cnt);
 	br_read_unlock(vcpu->kvm);
 
+	mmio->mmio_fn(vcpu, phys_addr, data, len, is_write, mmio->ptr);
+	ref_put(&mmio->ref_cnt, mmio_release);
+
 	return true;
 }
-- 
1.9.1
