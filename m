From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 01/12] avoid casts when initializing structures
Date: Fri, 17 Jul 2015 17:02:07 +0100
Message-ID: <1437148938-5394-2-git-send-email-andre.przywara@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: Szabolcs.Nagy@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Due to our kernel heritage we have code in kvmtool that relies on
the (still) implicit -std=gnu89 compiler switch.
It turns out that this just affects some structure initialization,
where we currently provide a cast to the type, which upsets GCC for
anything beyond -std=gnu89 (for instance gnu99 or gnu11).
We do need the casts when initializing structures that are not
assigned to the same type, so we put it there explicitly.

This allows us to compile with all the three GNU standards GCC
currently supports: gnu89/90, gnu99 and gnu11.
GCC threatens people with moving to gnu11 as the new default standard,
so lets fix this better sooner than later.
(Compiling without GNU extensions still breaks and I don't bother to
fix that without very good reasons.)

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 disk/qcow.c            | 6 +++---
 include/kvm/mutex.h    | 2 +-
 include/linux/rbtree.h | 2 +-
 virtio/9p.c            | 2 +-
 virtio/balloon.c       | 2 +-
 virtio/blk.c           | 2 +-
 virtio/console.c       | 2 +-
 virtio/net.c           | 2 +-
 virtio/rng.c           | 2 +-
 virtio/scsi.c          | 2 +-
 10 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/disk/qcow.c b/disk/qcow.c
index 64a2550..e26c419 100644
--- a/disk/qcow.c
+++ b/disk/qcow.c
@@ -1203,7 +1203,7 @@ static int qcow_read_refcount_table(struct qcow *q)
 	if (!rft->rf_table)
 		return -1;
 
-	rft->root = RB_ROOT;
+	rft->root = (struct rb_root) RB_ROOT;
 	INIT_LIST_HEAD(&rft->lru_list);
 
 	return pread_in_full(q->fd, rft->rf_table, sizeof(u64) * rft->rf_size, header->refcount_table_offset);
@@ -1289,7 +1289,7 @@ static struct disk_image *qcow2_probe(int fd, bool readonly)
 
 	l1t = &q->table;
 
-	l1t->root = RB_ROOT;
+	l1t->root = (struct rb_root) RB_ROOT;
 	INIT_LIST_HEAD(&l1t->lru_list);
 
 	h = q->header = qcow2_read_header(fd);
@@ -1435,7 +1435,7 @@ static struct disk_image *qcow1_probe(int fd, bool readonly)
 
 	l1t = &q->table;
 
-	l1t->root = RB_ROOT;
+	l1t->root = (struct rb_root)RB_ROOT;
 	INIT_LIST_HEAD(&l1t->lru_list);
 
 	h = q->header = qcow1_read_header(fd);
diff --git a/include/kvm/mutex.h b/include/kvm/mutex.h
index a90584b..1f7d0f6 100644
--- a/include/kvm/mutex.h
+++ b/include/kvm/mutex.h
@@ -13,7 +13,7 @@
 struct mutex {
 	pthread_mutex_t mutex;
 };
-#define MUTEX_INITIALIZER (struct mutex) { .mutex = PTHREAD_MUTEX_INITIALIZER }
+#define MUTEX_INITIALIZER { .mutex = PTHREAD_MUTEX_INITIALIZER }
 
 #define DEFINE_MUTEX(mtx) struct mutex mtx = MUTEX_INITIALIZER
 
diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index fb31765..33adf78 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -46,7 +46,7 @@ struct rb_root {
 
 #define rb_parent(r)   ((struct rb_node *)((r)->__rb_parent_color & ~3))
 
-#define RB_ROOT	(struct rb_root) { NULL, }
+#define RB_ROOT	{ NULL, }
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
 
 #define RB_EMPTY_ROOT(root)  ((root)->rb_node == NULL)
diff --git a/virtio/9p.c b/virtio/9p.c
index 66dcc26..49e7c5c 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1320,7 +1320,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-struct virtio_ops p9_dev_virtio_ops = (struct virtio_ops) {
+struct virtio_ops p9_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 84c4bb0..9564aa3 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -239,7 +239,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-struct virtio_ops bln_dev_virtio_ops = (struct virtio_ops) {
+struct virtio_ops bln_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
diff --git a/virtio/blk.c b/virtio/blk.c
index edfa8e6..c485e4f 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -244,7 +244,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static struct virtio_ops blk_dev_virtio_ops = (struct virtio_ops) {
+static struct virtio_ops blk_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
diff --git a/virtio/console.c b/virtio/console.c
index 384eac1..f1c0a19 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -197,7 +197,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static struct virtio_ops con_dev_virtio_ops = (struct virtio_ops) {
+static struct virtio_ops con_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
diff --git a/virtio/net.c b/virtio/net.c
index 9784520..4a6a855 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -624,7 +624,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static struct virtio_ops net_dev_virtio_ops = (struct virtio_ops) {
+static struct virtio_ops net_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
diff --git a/virtio/rng.c b/virtio/rng.c
index 8031368..9b9e128 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -141,7 +141,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static struct virtio_ops rng_dev_virtio_ops = (struct virtio_ops) {
+static struct virtio_ops rng_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
diff --git a/virtio/scsi.c b/virtio/scsi.c
index be254f3..58d2353 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -167,7 +167,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static struct virtio_ops scsi_dev_virtio_ops = (struct virtio_ops) {
+static struct virtio_ops scsi_dev_virtio_ops = {
 	.get_config		= get_config,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
-- 
2.3.5

