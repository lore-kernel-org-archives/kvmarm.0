From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 3/4] kvm: add kvm_vfio_get_device_irq
Date: Mon,  4 May 2015 13:49:57 +0100
Message-ID: <1430743798-8839-4-git-send-email-eric.auger@linaro.org>
References: <1430743798-8839-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D7B14F799
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2015 08:41:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UmP7DqpAYlD5 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 May 2015 08:41:28 -0400 (EDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
 [209.85.212.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C26A4F79C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2015 08:41:26 -0400 (EDT)
Received: by wizk4 with SMTP id k4so120233859wiz.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 May 2015 05:50:09 -0700 (PDT)
In-Reply-To: <1430743798-8839-1-git-send-email-eric.auger@linaro.org>
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
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Since the introduction of the qemu_irq/gsi hash table in kvm,
the gsi information is stored in kvm. New functions are introduced
to allocate/populate a kvm_vfio_dev_irq struct pointer from a
qemu_irq object and free it.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 include/sysemu/kvm.h |  5 +++++
 kvm-all.c            | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index bc3f230..42cc6c4 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -423,6 +423,11 @@ int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
 int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n,
                                       qemu_irq irq);
 void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_irq irq, int gsi);
+struct kvm_vfio_dev_irq;
+int kvm_vfio_get_device_irq(KVMState *s, int fd, int index,
+                            int start, int count, qemu_irq irq,
+                            struct kvm_vfio_dev_irq **vfio_dev_irq);
+void kvm_vfio_put_device_irq(struct kvm_vfio_dev_irq *vfio_dev_irq);
 void kvm_pc_gsi_handler(void *opaque, int n, int level);
 void kvm_pc_setup_irq_routing(bool pci_enabled);
 void kvm_init_irq_routing(KVMState *s);
diff --git a/kvm-all.c b/kvm-all.c
index d2cb7ed..83a9689 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -1454,6 +1454,38 @@ static int kvm_irqchip_create(MachineState *machine, KVMState *s)
     return 0;
 }
 
+int kvm_vfio_get_device_irq(KVMState *s, int fd, int index,
+                            int start, int count, qemu_irq irq,
+                            struct kvm_vfio_dev_irq **vfio_dev_irq)
+{
+    gpointer key, gsi;
+    gboolean found = g_hash_table_lookup_extended(s->gsimap, irq, &key, &gsi);
+    struct kvm_vfio_dev_irq *pirq;
+    __u32 *pgsi;
+    int argsz;
+
+    if (!found) {
+        return -ENXIO;
+    }
+
+    argsz = sizeof(*pirq) + sizeof(*pgsi);
+    pirq = g_malloc0(argsz);
+    pirq->argsz = argsz;
+    pirq->fd = fd;
+    pirq->index = index;
+    pirq->start = start;
+    pirq->count = count;
+    pgsi = (__u32 *)&pirq->gsi;
+    *pgsi = GPOINTER_TO_INT(gsi);
+    *vfio_dev_irq = pirq;
+    return 0;
+}
+
+void kvm_vfio_put_device_irq(struct kvm_vfio_dev_irq *vfio_dev_irq)
+{
+    g_free(vfio_dev_irq);
+}
+
 /* Find number of supported CPUs using the recommended
  * procedure from the kernel API documentation to cope with
  * older kernels that may be missing capabilities.
-- 
1.8.3.2
