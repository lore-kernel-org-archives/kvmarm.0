From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 08/13] KVM: arm64: add data structures to model ITS interrupt
 translation
Date: Fri, 29 May 2015 10:53:24 +0100
Message-ID: <1432893209-27313-9-git-send-email-andre.przywara@arm.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F09A45243E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 05:43:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cVy6c0k9huTB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2015 05:43:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29E2152462
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 05:43:54 -0400 (EDT)
In-Reply-To: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The GICv3 Interrupt Translation Service (ITS) uses tables in memory
to allow a sophisticated interrupt routing. It features device tables,
an interrupt table per device and a table connecting "collections" to
actual CPUs (aka. redistributors in the GICv3 lingo).
Since the interrupt numbers for the LPIs are allocated quite sparsely
and the range can be quite huge (8192 LPIs being the minimum), using
bitmaps or arrays for storing information is a waste of memory.
We use linked lists instead, which we iterate linearily. This works
very well with the actual number of LPIs/MSIs in the guest being
quite low. Should the number of LPIs exceed the number where iterating
the lists becomes painful, we can later revisit this and use more
efficient data structures.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h  |  3 +++
 virt/kvm/arm/its-emul.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 3b8e3a1..fa17df6 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -25,6 +25,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <kvm/iodev.h>
+#include <linux/list.h>
 
 #define VGIC_NR_IRQS_LEGACY	256
 #define VGIC_NR_SGIS		16
@@ -162,6 +163,8 @@ struct vgic_its {
 	u64			cbaser;
 	int			creadr;
 	int			cwriter;
+	struct list_head	device_list;
+	struct list_head	collection_list;
 };
 
 struct vgic_dist {
diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
index 82bc34a..f0f4a9c 100644
--- a/virt/kvm/arm/its-emul.c
+++ b/virt/kvm/arm/its-emul.c
@@ -21,6 +21,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
+#include <linux/list.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
 #include <kvm/arm_vgic.h>
@@ -32,6 +33,25 @@
 #include "vgic.h"
 #include "its-emul.h"
 
+struct its_device {
+	struct list_head dev_list;
+	struct list_head itt;
+	u32 device_id;
+};
+
+struct its_collection {
+	struct list_head coll_list;
+	u32 collection_id;
+	u32 target_addr;
+};
+
+struct its_itte {
+	struct list_head itte_list;
+	struct its_collection *collection;
+	u32 lpi;
+	u32 event_id;
+};
+
 #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
 
 /* distributor lock is hold by the VGIC MMIO handler */
@@ -280,6 +300,9 @@ int vits_init(struct kvm *kvm)
 
 	spin_lock_init(&its->lock);
 
+	INIT_LIST_HEAD(&its->device_list);
+	INIT_LIST_HEAD(&its->collection_list);
+
 	its->enabled = false;
 
 	return -ENXIO;
@@ -289,11 +312,33 @@ void vits_destroy(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_its *its = &dist->its;
+	struct its_device *dev;
+	struct its_itte *itte;
+	struct list_head *dev_cur, *dev_temp;
+	struct list_head *cur, *temp;
 
 	if (!vgic_has_its(kvm))
 		return;
 
+	spin_lock(&its->lock);
+	list_for_each_safe(dev_cur, dev_temp, &its->device_list) {
+		dev = container_of(dev_cur, struct its_device, dev_list);
+		list_for_each_safe(cur, temp, &dev->itt) {
+			itte = (container_of(cur, struct its_itte, itte_list));
+			list_del(cur);
+			kfree(itte);
+		}
+		list_del(dev_cur);
+		kfree(dev);
+	}
+
+	list_for_each_safe(cur, temp, &its->collection_list) {
+		list_del(cur);
+		kfree(container_of(cur, struct its_collection, coll_list));
+	}
+
 	kfree(dist->pendbaser);
 
 	its->enabled = false;
+	spin_unlock(&its->lock);
 }
-- 
2.3.5
