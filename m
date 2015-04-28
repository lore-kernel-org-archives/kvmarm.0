From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v13 06/12] kvm: rename kvm_irqchip_[add,
 remove]_irqfd_notifier with gsi suffix
Date: Tue, 28 Apr 2015 17:51:07 +0100
Message-ID: <1430239873-31950-7-git-send-email-eric.auger@linaro.org>
References: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D17904EDFD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:43:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YgHeZM+q2jlP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 12:43:05 -0400 (EDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
 [209.85.212.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54A3E4EDBE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:43:01 -0400 (EDT)
Received: by widdi4 with SMTP id di4so147975298wid.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 09:51:28 -0700 (PDT)
In-Reply-To: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com, agraf@suse.de, pbonzini@redhat.com, peter.crosthwaite@xilinx.com
Cc: patches@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Anticipating for the introduction of new add/remove functions taking
a qemu_irq parameter, let's rename existing ones with a gsi suffix.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 hw/s390x/virtio-ccw.c  | 8 ++++----
 hw/vfio/pci.c          | 6 +++---
 hw/virtio/virtio-pci.c | 4 ++--
 include/sysemu/kvm.h   | 7 ++++---
 kvm-all.c              | 7 ++++---
 kvm-stub.c             | 7 ++++---
 6 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/hw/s390x/virtio-ccw.c b/hw/s390x/virtio-ccw.c
index ed75c63..55a74fa 100644
--- a/hw/s390x/virtio-ccw.c
+++ b/hw/s390x/virtio-ccw.c
@@ -1238,8 +1238,8 @@ static int virtio_ccw_add_irqfd(VirtioCcwDevice *dev, int n)
     VirtQueue *vq = virtio_get_queue(vdev, n);
     EventNotifier *notifier = virtio_queue_get_guest_notifier(vq);
 
-    return kvm_irqchip_add_irqfd_notifier(kvm_state, notifier, NULL,
-                                          dev->routes.gsi[n]);
+    return kvm_irqchip_add_irqfd_notifier_gsi(kvm_state, notifier, NULL,
+                                              dev->routes.gsi[n]);
 }
 
 static void virtio_ccw_remove_irqfd(VirtioCcwDevice *dev, int n)
@@ -1249,8 +1249,8 @@ static void virtio_ccw_remove_irqfd(VirtioCcwDevice *dev, int n)
     EventNotifier *notifier = virtio_queue_get_guest_notifier(vq);
     int ret;
 
-    ret = kvm_irqchip_remove_irqfd_notifier(kvm_state, notifier,
-                                            dev->routes.gsi[n]);
+    ret = kvm_irqchip_remove_irqfd_notifier_gsi(kvm_state, notifier,
+                                                dev->routes.gsi[n]);
     assert(ret == 0);
 }
 
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index cd15b20..938f584 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -596,7 +596,7 @@ static void vfio_add_kvm_msi_virq(VFIOMSIVector *vector, MSIMessage *msg,
         return;
     }
 
-    if (kvm_irqchip_add_irqfd_notifier(kvm_state, &vector->kvm_interrupt,
+    if (kvm_irqchip_add_irqfd_notifier_gsi(kvm_state, &vector->kvm_interrupt,
                                        NULL, virq) < 0) {
         kvm_irqchip_release_virq(kvm_state, virq);
         event_notifier_cleanup(&vector->kvm_interrupt);
@@ -608,8 +608,8 @@ static void vfio_add_kvm_msi_virq(VFIOMSIVector *vector, MSIMessage *msg,
 
 static void vfio_remove_kvm_msi_virq(VFIOMSIVector *vector)
 {
-    kvm_irqchip_remove_irqfd_notifier(kvm_state, &vector->kvm_interrupt,
-                                      vector->virq);
+    kvm_irqchip_remove_irqfd_notifier_gsi(kvm_state, &vector->kvm_interrupt,
+                                          vector->virq);
     kvm_irqchip_release_virq(kvm_state, vector->virq);
     vector->virq = -1;
     event_notifier_cleanup(&vector->kvm_interrupt);
diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index c7c3f72..3be7fad 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -477,7 +477,7 @@ static int kvm_virtio_pci_irqfd_use(VirtIOPCIProxy *proxy,
     VirtQueue *vq = virtio_get_queue(vdev, queue_no);
     EventNotifier *n = virtio_queue_get_guest_notifier(vq);
     int ret;
-    ret = kvm_irqchip_add_irqfd_notifier(kvm_state, n, NULL, irqfd->virq);
+    ret = kvm_irqchip_add_irqfd_notifier_gsi(kvm_state, n, NULL, irqfd->virq);
     return ret;
 }
 
@@ -491,7 +491,7 @@ static void kvm_virtio_pci_irqfd_release(VirtIOPCIProxy *proxy,
     VirtIOIRQFD *irqfd = &proxy->vector_irqfd[vector];
     int ret;
 
-    ret = kvm_irqchip_remove_irqfd_notifier(kvm_state, n, irqfd->virq);
+    ret = kvm_irqchip_remove_irqfd_notifier_gsi(kvm_state, n, irqfd->virq);
     assert(ret == 0);
 }
 
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 197e6c0..0f28d6f 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -413,9 +413,10 @@ void kvm_irqchip_release_virq(KVMState *s, int virq);
 
 int kvm_irqchip_add_adapter_route(KVMState *s, AdapterInfo *adapter);
 
-int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
-                                   EventNotifier *rn, int virq);
-int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n, int virq);
+int kvm_irqchip_add_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
+                                       EventNotifier *rn, int virq);
+int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
+                                          int virq);
 void kvm_pc_gsi_handler(void *opaque, int n, int level);
 void kvm_pc_setup_irq_routing(bool pci_enabled);
 void kvm_init_irq_routing(KVMState *s);
diff --git a/kvm-all.c b/kvm-all.c
index 4ec153d..42bb923 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -1368,14 +1368,15 @@ int kvm_irqchip_update_msi_route(KVMState *s, int virq, MSIMessage msg)
 }
 #endif /* !KVM_CAP_IRQ_ROUTING */
 
-int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
-                                   EventNotifier *rn, int virq)
+int kvm_irqchip_add_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
+                                       EventNotifier *rn, int virq)
 {
     return kvm_irqchip_assign_irqfd(s, event_notifier_get_fd(n),
            rn ? event_notifier_get_fd(rn) : -1, virq, true);
 }
 
-int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n, int virq)
+int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
+                                          int virq)
 {
     return kvm_irqchip_assign_irqfd(s, event_notifier_get_fd(n), -1, virq,
            false);
diff --git a/kvm-stub.c b/kvm-stub.c
index 7ba90c5..977de21 100644
--- a/kvm-stub.c
+++ b/kvm-stub.c
@@ -137,13 +137,14 @@ int kvm_irqchip_add_adapter_route(KVMState *s, AdapterInfo *adapter)
     return -ENOSYS;
 }
 
-int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
-                                   EventNotifier *rn, int virq)
+int kvm_irqchip_add_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
+                                       EventNotifier *rn, int virq)
 {
     return -ENOSYS;
 }
 
-int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n, int virq)
+int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
+                                          int virq)
 {
     return -ENOSYS;
 }
-- 
1.8.3.2
