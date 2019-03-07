From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 12/16] ioport: Allow ioport callbacks to be called
 without locking
Date: Thu,  7 Mar 2019 08:36:13 +0000
Message-ID: <1551947777-13044-13-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE59B4A4DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WxZAYYvkXcJw for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 631964A4C9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:42 -0500 (EST)
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

A vcpu might reconfigure some ioports while other vcpus access another one.
Currently, edit to one port blocks all other ioport accesses.

Execute ioport callbacks outside of locking. protecting ioport data with
ref counting to prevent data being deleted while callback runs.

Since ioport struct is being passed to all ioport callbacks, wrap it in
another structure that will get ref counted to avoid modifying all ioport
devices.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 include/kvm/ioport.h |  1 -
 ioport.c             | 68 ++++++++++++++++++++++++++++++++++------------------
 2 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
index 8c86b71..a73f78c 100644
--- a/include/kvm/ioport.h
+++ b/include/kvm/ioport.h
@@ -18,7 +18,6 @@
 struct kvm;
 
 struct ioport {
-	struct rb_int_node		node;
 	struct ioport_operations	*ops;
 	void				*priv;
 	struct device_header		dev_hdr;
diff --git a/ioport.c b/ioport.c
index a72e403..2c3fe93 100644
--- a/ioport.c
+++ b/ioport.c
@@ -5,6 +5,7 @@
 #include "kvm/brlock.h"
 #include "kvm/rbtree-interval.h"
 #include "kvm/mutex.h"
+#include "kvm/ref_cnt.h"
 
 #include <linux/kvm.h>	/* for KVM_EXIT_* */
 #include <linux/types.h>
@@ -14,11 +15,25 @@
 #include <stdlib.h>
 #include <stdio.h>
 
-#define ioport_node(n) rb_entry(n, struct ioport, node)
+#define ioport_node(n) rb_entry(n, struct ioport_data, node)
 
 static struct rb_root		ioport_tree = RB_ROOT;
 
-static struct ioport *ioport_search(struct rb_root *root, u64 addr)
+struct ioport_data {
+	struct rb_int_node	node;
+	struct ioport		ioport;
+	struct ref_cnt		ref_cnt;
+};
+
+static void ioport_release(struct ref_cnt  *ref_cnt)
+{
+	struct ioport_data *data = container_of(ref_cnt,
+						struct ioport_data, ref_cnt);
+
+	free(data);
+}
+
+static struct ioport_data *ioport_search(struct rb_root *root, u64 addr)
 {
 	struct rb_int_node *node;
 
@@ -29,12 +44,12 @@ static struct ioport *ioport_search(struct rb_root *root, u64 addr)
 	return ioport_node(node);
 }
 
-static int ioport_insert(struct rb_root *root, struct ioport *data)
+static int ioport_insert(struct rb_root *root, struct ioport_data *data)
 {
 	return rb_int_insert(root, &data->node);
 }
 
-static void ioport_remove(struct rb_root *root, struct ioport *data)
+static void ioport_remove(struct rb_root *root, struct ioport_data *data)
 {
 	rb_int_erase(root, &data->node);
 }
@@ -65,7 +80,7 @@ static void generate_ioport_fdt_node(void *fdt,
 
 int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, int count, void *param)
 {
-	struct ioport *entry;
+	struct ioport_data *entry;
 	int r;
 
 	br_write_lock(kvm);
@@ -74,14 +89,16 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 	if (entry) {
 		pr_warning("ioport re-registered: %x", port);
 		rb_int_erase(&ioport_tree, &entry->node);
+		ref_put(&entry->ref_cnt, ioport_release);
 	}
 
 	entry = malloc(sizeof(*entry));
 	if (entry == NULL)
 		return -ENOMEM;
 
-	*entry = (struct ioport) {
-		.node		= RB_INT_INIT(port, port + count),
+	ref_cnt_init(&entry->ref_cnt);
+	entry->node = RB_INT_INIT(port, port + count);
+	entry->ioport = (struct ioport) {
 		.ops		= ops,
 		.priv		= param,
 		.dev_hdr	= (struct device_header) {
@@ -90,14 +107,15 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 		},
 	};
 
+	/* Give the ref to the tree */
 	r = ioport_insert(&ioport_tree, entry);
 	if (r < 0) {
-		free(entry);
+		ref_put(&entry->ref_cnt, ioport_release);
 		br_write_unlock(kvm);
 		return r;
 	}
 
-	device__register(&entry->dev_hdr);
+	device__register(&entry->ioport.dev_hdr);
 	br_write_unlock(kvm);
 
 	return port;
@@ -105,7 +123,7 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 
 int ioport__unregister(struct kvm *kvm, u16 port)
 {
-	struct ioport *entry;
+	struct ioport_data *entry;
 	int r;
 
 	br_write_lock(kvm);
@@ -115,10 +133,9 @@ int ioport__unregister(struct kvm *kvm, u16 port)
 	if (!entry)
 		goto done;
 
-	device__unregister(&entry->dev_hdr);
+	device__unregister(&entry->ioport.dev_hdr);
 	ioport_remove(&ioport_tree, entry);
-
-	free(entry);
+	ref_put(&entry->ref_cnt, ioport_release);
 
 	r = 0;
 
@@ -130,7 +147,7 @@ done:
 
 static void ioport__unregister_all(void)
 {
-	struct ioport *entry;
+	struct ioport_data *entry;
 	struct rb_node *rb;
 	struct rb_int_node *rb_node;
 
@@ -138,9 +155,9 @@ static void ioport__unregister_all(void)
 	while (rb) {
 		rb_node = rb_int(rb);
 		entry = ioport_node(rb_node);
-		device__unregister(&entry->dev_hdr);
+		device__unregister(&entry->ioport.dev_hdr);
 		ioport_remove(&ioport_tree, entry);
-		free(entry);
+		ref_put(&entry->ref_cnt, ioport_release);
 		rb = rb_first(&ioport_tree);
 	}
 }
@@ -162,29 +179,34 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
 {
 	struct ioport_operations *ops;
 	bool ret = false;
-	struct ioport *entry;
+	struct ioport_data *entry;
 	void *ptr = data;
 	struct kvm *kvm = vcpu->kvm;
 
 	br_read_lock(kvm);
 	entry = ioport_search(&ioport_tree, port);
-	if (!entry)
+	if (!entry) {
+		br_read_unlock(kvm);
 		goto out;
+	}
+
+	ref_get(&entry->ref_cnt);
+	br_read_unlock(kvm);
 
-	ops	= entry->ops;
+	ops	= entry->ioport.ops;
 
 	while (count--) {
 		if (direction == KVM_EXIT_IO_IN && ops->io_in)
-				ret = ops->io_in(entry, vcpu, port, ptr, size);
+				ret = ops->io_in(&entry->ioport, vcpu, port, ptr, size);
 		else if (direction == KVM_EXIT_IO_OUT && ops->io_out)
-				ret = ops->io_out(entry, vcpu, port, ptr, size);
+				ret = ops->io_out(&entry->ioport, vcpu, port, ptr, size);
 
 		ptr += size;
 	}
 
-out:
-	br_read_unlock(kvm);
+	ref_put(&entry->ref_cnt, ioport_release);
 
+out:
 	if (ret)
 		return true;
 
-- 
1.9.1
