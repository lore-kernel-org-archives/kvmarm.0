From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v16 6/9] kvm-all.c: add qemu_irq/gsi hash table and utility
 routines
Date: Wed, 27 May 2015 10:11:08 +0100
Message-ID: <1432717871-2393-7-git-send-email-eric.auger@linaro.org>
References: <1432717871-2393-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2233B521AB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2015 05:01:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eEBvExZWd4Ng for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2015 05:01:55 -0400 (EDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
 [209.85.212.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E115E521D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2015 05:01:51 -0400 (EDT)
Received: by wizo1 with SMTP id o1so13994597wiz.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2015 02:11:33 -0700 (PDT)
In-Reply-To: <1432717871-2393-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com
Cc: patches@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

VFIO platform device needs to setup irqfd but it does not know the
gsi corresponding to the device qemu_irq. This series proposes to
store a hash table in kvm_state using the qemu_irq as key and the gsi
as a value.

kvm_irqchip_set_qemuirq_gsi allows to insert such a pair. The interrupt
controller is supposed to use it.

kvm_irqchip_[add, remove]_irqfd_notifier allows to setup/tear down
irqfd directly from the qemu_irq.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Tested-by: Vikram Sethi <vikrams@codeaurora.org>

---

v15 -> v16:
- Added Vikram's T-b

v13 -> v14:
- correct checkpatch warning

v2 -> v3 (integration into VFIO series v13):
- rename kvm_irqchip_[add, remove]_qemuirq_irqfd_notifier into
  kvm_irqchip_[add, remove]_irqfd_notifier. Possible since legacy
  functions were also renamed with _gsi suffix.

V1 -> v2:
- qemu_irq get_gsi callback replaced by hash table stored in kvm
---
 include/sysemu/kvm.h |  6 ++++++
 kvm-all.c            | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index d0aa224..5a1d70d 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -19,6 +19,7 @@
 #include "qemu/queue.h"
 #include "qom/cpu.h"
 #include "exec/memattrs.h"
+#include "hw/irq.h"
 
 #ifdef CONFIG_KVM
 #include <linux/kvm.h>
@@ -418,6 +419,11 @@ int kvm_irqchip_add_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
                                        EventNotifier *rn, int virq);
 int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
                                           int virq);
+int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
+                                   EventNotifier *rn, qemu_irq irq);
+int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n,
+                                      qemu_irq irq);
+void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_irq irq, int gsi);
 void kvm_pc_gsi_handler(void *opaque, int n, int level);
 void kvm_pc_setup_irq_routing(bool pci_enabled);
 void kvm_init_irq_routing(KVMState *s);
diff --git a/kvm-all.c b/kvm-all.c
index 2d58eb8..16ae000 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -37,6 +37,7 @@
 #include "exec/address-spaces.h"
 #include "qemu/event_notifier.h"
 #include "trace.h"
+#include "hw/irq.h"
 
 #include "hw/boards.h"
 
@@ -99,6 +100,7 @@ struct KVMState
      * unsigned, and treating them as signed here can break things */
     unsigned irq_set_ioctl;
     unsigned int sigmask_len;
+    GHashTable *gsimap;
 #ifdef KVM_CAP_IRQ_ROUTING
     struct kvm_irq_routing *irq_routes;
     int nr_allocated_irq_routes;
@@ -1382,6 +1384,39 @@ int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
            false);
 }
 
+int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
+                                   EventNotifier *rn, qemu_irq irq)
+{
+    gpointer key, gsi;
+    gboolean found = g_hash_table_lookup_extended(s->gsimap, irq, &key, &gsi);
+
+    if (!found) {
+        return -ENXIO;
+    } else {
+        return kvm_irqchip_add_irqfd_notifier_gsi(s, n, rn,
+                                                  GPOINTER_TO_UINT(gsi));
+    }
+}
+
+int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n,
+                                      qemu_irq irq)
+{
+    gpointer key, gsi;
+    gboolean found = g_hash_table_lookup_extended(s->gsimap, irq, &key, &gsi);
+
+    if (!found) {
+        return -ENXIO;
+    } else {
+        return kvm_irqchip_remove_irqfd_notifier_gsi(s, n,
+                                                     GPOINTER_TO_INT(gsi));
+    }
+}
+
+void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_irq irq, int gsi)
+{
+    g_hash_table_insert(s->gsimap, irq, GINT_TO_POINTER(gsi));
+}
+
 static int kvm_irqchip_create(MachineState *machine, KVMState *s)
 {
     int ret;
@@ -1414,6 +1449,8 @@ static int kvm_irqchip_create(MachineState *machine, KVMState *s)
 
     kvm_init_irq_routing(s);
 
+    s->gsimap = g_hash_table_new(g_direct_hash, g_direct_equal);
+
     return 0;
 }
 
-- 
1.8.3.2
