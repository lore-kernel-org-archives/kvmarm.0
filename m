Return-Path: <SRS0=vuhq=H3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE2EAC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:01:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3C38B64EF1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:01:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C38B64EF1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2DC64B30D;
	Wed, 24 Feb 2021 20:01:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O4vE994n3nOd; Wed, 24 Feb 2021 20:01:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AE024B2F6;
	Wed, 24 Feb 2021 20:01:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9798D4B2C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C07xbvpqan7h for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2021 20:00:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E257B4B2FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:55 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A35BF14BF;
 Wed, 24 Feb 2021 17:00:55 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 54FFA3F73B;
 Wed, 24 Feb 2021 17:00:54 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v2 19/22] Remove ioport specific routines
Date: Thu, 25 Feb 2021 00:59:12 +0000
Message-Id: <20210225005915.26423-20-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Sami Mujawar <sami.mujawar@arm.com>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Now that all users of the dedicated ioport trap handler interface are
gone, we can retire the code associated with it.

This removes ioport.c and ioport.h, along with removing prototypes from
other header files.

This also transfers the responsibility for port I/O trap handling
entirely into the new routine in mmio.c.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Makefile             |   1 -
 include/kvm/ioport.h |  27 ------
 include/kvm/kvm.h    |   2 -
 ioport.c             | 195 -------------------------------------------
 mmio.c               |   2 +-
 5 files changed, 1 insertion(+), 226 deletions(-)
 delete mode 100644 ioport.c

diff --git a/Makefile b/Makefile
index 35bb1182..94ff5da6 100644
--- a/Makefile
+++ b/Makefile
@@ -56,7 +56,6 @@ OBJS	+= framebuffer.o
 OBJS	+= guest_compat.o
 OBJS	+= hw/rtc.o
 OBJS	+= hw/serial.o
-OBJS	+= ioport.o
 OBJS	+= irq.o
 OBJS	+= kvm-cpu.o
 OBJS	+= kvm.o
diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
index a61038e2..b6f579cb 100644
--- a/include/kvm/ioport.h
+++ b/include/kvm/ioport.h
@@ -1,13 +1,8 @@
 #ifndef KVM__IOPORT_H
 #define KVM__IOPORT_H
 
-#include "kvm/devices.h"
 #include "kvm/kvm-cpu.h"
-#include "kvm/rbtree-interval.h"
-#include "kvm/fdt.h"
 
-#include <stdbool.h>
-#include <limits.h>
 #include <asm/types.h>
 #include <linux/types.h>
 #include <linux/byteorder.h>
@@ -15,30 +10,8 @@
 /* some ports we reserve for own use */
 #define IOPORT_DBG			0xe0
 
-struct kvm;
-
-struct ioport {
-	struct rb_int_node		node;
-	struct ioport_operations	*ops;
-	void				*priv;
-	struct device_header		dev_hdr;
-	u32				refcount;
-	bool				remove;
-};
-
-struct ioport_operations {
-	bool (*io_in)(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size);
-	bool (*io_out)(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size);
-};
-
 void ioport__map_irq(u8 *irq);
 
-int __must_check ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops,
-				  int count, void *param);
-int ioport__unregister(struct kvm *kvm, u16 port);
-int ioport__init(struct kvm *kvm);
-int ioport__exit(struct kvm *kvm);
-
 static inline u8 ioport__read8(u8 *data)
 {
 	return *data;
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 306b258a..6c28afa3 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -126,8 +126,6 @@ void kvm__irq_line(struct kvm *kvm, int irq, int level);
 void kvm__irq_trigger(struct kvm *kvm, int irq);
 bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction, int size, u32 count);
 bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
-bool kvm__emulate_pio(struct kvm_cpu *vcpu, u16 port, void *data,
-		      int direction, int size, u32 count);
 int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr);
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr,
 		      enum kvm_mem_type type);
diff --git a/ioport.c b/ioport.c
deleted file mode 100644
index ce29e7e7..00000000
--- a/ioport.c
+++ /dev/null
@@ -1,195 +0,0 @@
-#include "kvm/ioport.h"
-
-#include "kvm/kvm.h"
-#include "kvm/util.h"
-#include "kvm/rbtree-interval.h"
-#include "kvm/mutex.h"
-
-#include <linux/kvm.h>	/* for KVM_EXIT_* */
-#include <linux/types.h>
-
-#include <stdbool.h>
-#include <limits.h>
-#include <stdlib.h>
-#include <stdio.h>
-
-#define ioport_node(n) rb_entry(n, struct ioport, node)
-
-static DEFINE_MUTEX(ioport_lock);
-
-static struct rb_root		ioport_tree = RB_ROOT;
-
-static struct ioport *ioport_search(struct rb_root *root, u64 addr)
-{
-	struct rb_int_node *node;
-
-	node = rb_int_search_single(root, addr);
-	if (node == NULL)
-		return NULL;
-
-	return ioport_node(node);
-}
-
-static int ioport_insert(struct rb_root *root, struct ioport *data)
-{
-	return rb_int_insert(root, &data->node);
-}
-
-static void ioport_remove(struct rb_root *root, struct ioport *data)
-{
-	rb_int_erase(root, &data->node);
-}
-
-static struct ioport *ioport_get(struct rb_root *root, u64 addr)
-{
-	struct ioport *ioport;
-
-	mutex_lock(&ioport_lock);
-	ioport = ioport_search(root, addr);
-	if (ioport)
-		ioport->refcount++;
-	mutex_unlock(&ioport_lock);
-
-	return ioport;
-}
-
-/* Called with ioport_lock held. */
-static void ioport_unregister(struct rb_root *root, struct ioport *data)
-{
-	ioport_remove(root, data);
-	free(data);
-}
-
-static void ioport_put(struct rb_root *root, struct ioport *data)
-{
-	mutex_lock(&ioport_lock);
-	data->refcount--;
-	if (data->remove && data->refcount == 0)
-		ioport_unregister(root, data);
-	mutex_unlock(&ioport_lock);
-}
-
-int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, int count, void *param)
-{
-	struct ioport *entry;
-	int r;
-
-	entry = malloc(sizeof(*entry));
-	if (entry == NULL)
-		return -ENOMEM;
-
-	*entry = (struct ioport) {
-		.node		= RB_INT_INIT(port, port + count),
-		.ops		= ops,
-		.priv		= param,
-		/*
-		 * Start from 0 because ioport__unregister() doesn't decrement
-		 * the reference count.
-		 */
-		.refcount	= 0,
-		.remove		= false,
-	};
-
-	mutex_lock(&ioport_lock);
-	r = ioport_insert(&ioport_tree, entry);
-	if (r < 0)
-		goto out_free;
-	mutex_unlock(&ioport_lock);
-
-	return port;
-
-out_free:
-	free(entry);
-	mutex_unlock(&ioport_lock);
-	return r;
-}
-
-int ioport__unregister(struct kvm *kvm, u16 port)
-{
-	struct ioport *entry;
-
-	mutex_lock(&ioport_lock);
-	entry = ioport_search(&ioport_tree, port);
-	if (!entry) {
-		mutex_unlock(&ioport_lock);
-		return -ENOENT;
-	}
-	/* The same reasoning from kvm__deregister_mmio() applies. */
-	if (entry->refcount == 0)
-		ioport_unregister(&ioport_tree, entry);
-	else
-		entry->remove = true;
-	mutex_unlock(&ioport_lock);
-
-	return 0;
-}
-
-static void ioport__unregister_all(void)
-{
-	struct ioport *entry;
-	struct rb_node *rb;
-	struct rb_int_node *rb_node;
-
-	rb = rb_first(&ioport_tree);
-	while (rb) {
-		rb_node = rb_int(rb);
-		entry = ioport_node(rb_node);
-		ioport_unregister(&ioport_tree, entry);
-		rb = rb_first(&ioport_tree);
-	}
-}
-
-static const char *to_direction(int direction)
-{
-	if (direction == KVM_EXIT_IO_IN)
-		return "IN";
-	else
-		return "OUT";
-}
-
-static void ioport_error(u16 port, void *data, int direction, int size, u32 count)
-{
-	fprintf(stderr, "IO error: %s port=%x, size=%d, count=%u\n", to_direction(direction), port, size, count);
-}
-
-bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction, int size, u32 count)
-{
-	struct ioport_operations *ops;
-	bool ret = false;
-	struct ioport *entry;
-	void *ptr = data;
-	struct kvm *kvm = vcpu->kvm;
-
-	entry = ioport_get(&ioport_tree, port);
-	if (!entry)
-		return kvm__emulate_pio(vcpu, port, data, direction,
-					size, count);
-
-	ops	= entry->ops;
-
-	while (count--) {
-		if (direction == KVM_EXIT_IO_IN && ops->io_in)
-				ret = ops->io_in(entry, vcpu, port, ptr, size);
-		else if (direction == KVM_EXIT_IO_OUT && ops->io_out)
-				ret = ops->io_out(entry, vcpu, port, ptr, size);
-
-		ptr += size;
-	}
-
-	ioport_put(&ioport_tree, entry);
-
-	if (ret)
-		return true;
-
-	if (kvm->cfg.ioport_debug)
-		ioport_error(port, data, direction, size, count);
-
-	return !kvm->cfg.ioport_debug;
-}
-
-int ioport__exit(struct kvm *kvm)
-{
-	ioport__unregister_all();
-	return 0;
-}
-dev_base_exit(ioport__exit);
diff --git a/mmio.c b/mmio.c
index 75de04ad..9f731dcf 100644
--- a/mmio.c
+++ b/mmio.c
@@ -212,7 +212,7 @@ out:
 	return true;
 }
 
-bool kvm__emulate_pio(struct kvm_cpu *vcpu, u16 port, void *data,
+bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data,
 		     int direction, int size, u32 count)
 {
 	struct mmio_mapping *mmio;
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
