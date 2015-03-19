From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v11 9/9] hw/vfio/platform: add irqfd support
Date: Thu, 19 Mar 2015 10:05:38 +0000
Message-ID: <1426759538-18030-10-git-send-email-eric.auger@linaro.org>
References: <1426759538-18030-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D06149207
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 05:59:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i4S+7XO+IrQg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2015 05:59:16 -0400 (EDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
 [209.85.212.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4ADBE49221
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 05:59:14 -0400 (EDT)
Received: by wibg7 with SMTP id g7so6813075wib.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 03:05:55 -0700 (PDT)
In-Reply-To: <1426759538-18030-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de, b.reynal@virtualopensystems.com
Cc: patches@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This patch aims at optimizing IRQ handling using irqfd framework.

Instead of handling the eventfds on user-side they are handled on
kernel side using
- the KVM irqfd framework,
- the VFIO driver virqfd framework.

the virtual IRQ completion is trapped at interrupt controller
This removes the need for fast/slow path swap.

Overall this brings significant performance improvements.

it depends on host kernel KVM irqfd.

Signed-off-by: Alvise Rigo <a.rigo@virtualopensystems.com>
Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Alex Bennee<alex.bennee@linaro.org>

---
v10 -> v11:
- Add Alex' Reviewed-by
- introduce kvm_accel in this patch and initialize it

v5 -> v6
- rely on kvm_irqfds_enabled() and kvm_resamplefds_enabled()
- guard KVM code with #ifdef CONFIG_KVM

v3 -> v4:
[Alvise Rigo]
Use of VFIO Platform driver v6 unmask/virqfd feature and removal
of resamplefd handler. Physical IRQ unmasking is now done in
VFIO driver.

v3:
[Eric Auger]
initial support with resamplefd handled on QEMU side since the
unmask was not supported on VFIO platform driver v5.

Conflicts:
	hw/vfio/platform.c
---
 hw/vfio/platform.c              | 96 +++++++++++++++++++++++++++++++++++++++++
 include/hw/vfio/vfio-platform.h |  2 +
 trace-events                    |  2 +
 3 files changed, 100 insertions(+)

diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
index 59eeca2..98872ec 100644
--- a/hw/vfio/platform.c
+++ b/hw/vfio/platform.c
@@ -26,6 +26,7 @@
 #include "hw/sysbus.h"
 #include "trace.h"
 #include "hw/platform-bus.h"
+#include "sysemu/kvm.h"
 
 /*
  * Functions used whatever the injection method
@@ -51,6 +52,7 @@ static VFIOINTp *vfio_init_intp(VFIODevice *vbasedev,
     intp->pin = info.index;
     intp->flags = info.flags;
     intp->state = VFIO_IRQ_INACTIVE;
+    intp->kvm_accel = false;
 
     sysbus_init_irq(sbdev, &intp->qemuirq);
 
@@ -61,6 +63,13 @@ static VFIOINTp *vfio_init_intp(VFIODevice *vbasedev,
         error_report("vfio: Error: trigger event_notifier_init failed ");
         return NULL;
     }
+    /* Get an eventfd for resample/unmask */
+    ret = event_notifier_init(&intp->unmask, 0);
+    if (ret) {
+        g_free(intp);
+        error_report("vfio: Error: resample event_notifier_init failed eoi");
+        return NULL;
+    }
 
     QLIST_INSERT_HEAD(&vdev->intp_list, intp, next);
     return intp;
@@ -315,6 +324,82 @@ static int vfio_start_eventfd_injection(VFIOINTp *intp)
     return ret;
 }
 
+/*
+ * Functions used for irqfd
+ */
+
+#ifdef CONFIG_KVM
+
+/**
+ * vfio_set_resample_eventfd - sets the resamplefd for an IRQ
+ * @intp: the IRQ struct handle
+ * programs the VFIO driver to unmask this IRQ when the
+ * intp->unmask eventfd is triggered
+ */
+static int vfio_set_resample_eventfd(VFIOINTp *intp)
+{
+    VFIODevice *vbasedev = &intp->vdev->vbasedev;
+    struct vfio_irq_set *irq_set;
+    int argsz, ret;
+    int32_t *pfd;
+
+    argsz = sizeof(*irq_set) + sizeof(*pfd);
+    irq_set = g_malloc0(argsz);
+    irq_set->argsz = argsz;
+    irq_set->flags = VFIO_IRQ_SET_DATA_EVENTFD | VFIO_IRQ_SET_ACTION_UNMASK;
+    irq_set->index = intp->pin;
+    irq_set->start = 0;
+    irq_set->count = 1;
+    pfd = (int32_t *)&irq_set->data;
+    *pfd = event_notifier_get_fd(&intp->unmask);
+    qemu_set_fd_handler(*pfd, NULL, NULL, NULL);
+    ret = ioctl(vbasedev->fd, VFIO_DEVICE_SET_IRQS, irq_set);
+    g_free(irq_set);
+    if (ret < 0) {
+        error_report("vfio: Failed to set resample eventfd: %m");
+    }
+    return ret;
+}
+
+/**
+ * vfio_start_irqfd_injection - starts irqfd injection for an IRQ
+ * programs VFIO driver with both the trigger and resamplefd
+ * programs KVM with the gsi, trigger & resample eventfds
+ */
+static int vfio_start_irqfd_injection(VFIOINTp *intp)
+{
+    struct kvm_irqfd irqfd = {
+        .fd = event_notifier_get_fd(&intp->interrupt),
+        .resamplefd = event_notifier_get_fd(&intp->unmask),
+        .gsi = intp->virtualID,
+        .flags = KVM_IRQFD_FLAG_RESAMPLE,
+    };
+
+    if (kvm_vm_ioctl(kvm_state, KVM_IRQFD, &irqfd)) {
+        error_report("vfio: Error: Failed to assign the irqfd: %m");
+        goto fail_irqfd;
+    }
+    if (vfio_set_trigger_eventfd(intp, NULL) < 0) {
+        goto fail_vfio;
+    }
+    if (vfio_set_resample_eventfd(intp) < 0) {
+        goto fail_vfio;
+    }
+
+    intp->kvm_accel = true;
+    trace_vfio_platform_start_irqfd_injection(intp->pin, intp->virtualID,
+                                     irqfd.fd, irqfd.resamplefd);
+    return 0;
+
+fail_vfio:
+    irqfd.flags = KVM_IRQFD_FLAG_DEASSIGN;
+    kvm_vm_ioctl(kvm_state, KVM_IRQFD, &irqfd);
+fail_irqfd:
+    return -1;
+}
+
+#endif /* CONFIG_KVM */
+
 /* VFIO skeleton */
 
 /* not implemented yet */
@@ -555,7 +640,17 @@ static void vfio_platform_realize(DeviceState *dev, Error **errp)
 
     vbasedev->type = VFIO_DEVICE_TYPE_PLATFORM;
     vbasedev->ops = &vfio_platform_ops;
+
+#ifdef CONFIG_KVM
+    if (kvm_irqfds_enabled() && kvm_resamplefds_enabled() &&
+        vdev->irqfd_allowed) {
+        vdev->start_irq_fn = vfio_start_irqfd_injection;
+    } else {
+        vdev->start_irq_fn = vfio_start_eventfd_injection;
+    }
+#else
     vdev->start_irq_fn = vfio_start_eventfd_injection;
+#endif
 
     trace_vfio_platform_realize(vbasedev->name, vdev->compat);
 
@@ -645,6 +740,7 @@ static Property vfio_platform_dev_properties[] = {
     DEFINE_PROP_STRING("host", VFIOPlatformDevice, vbasedev.name),
     DEFINE_PROP_UINT32("mmap-timeout-ms", VFIOPlatformDevice,
                        mmap_timeout, 1100),
+    DEFINE_PROP_BOOL("x-irqfd", VFIOPlatformDevice, irqfd_allowed, true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/include/hw/vfio/vfio-platform.h b/include/hw/vfio/vfio-platform.h
index c9ee898..25d2c46 100644
--- a/include/hw/vfio/vfio-platform.h
+++ b/include/hw/vfio/vfio-platform.h
@@ -42,6 +42,7 @@ typedef struct VFIOINTp {
     uint8_t pin; /* index */
     uint32_t virtualID; /* virtual IRQ */
     uint32_t flags; /* IRQ info flags */
+    bool kvm_accel; /* set when QEMU bypass through KVM enabled */
 } VFIOINTp;
 
 /* function type for routine starting IRQ propagation to the guest */
@@ -62,6 +63,7 @@ typedef struct VFIOPlatformDevice {
     /* function used to start IRQ propagation to the guest */
     start_irq_fn_t start_irq_fn;
     QemuMutex intp_mutex; /* protect the intp_list IRQ state */
+    bool irqfd_allowed; /* debug option to force irqfd on/off */
 } VFIOPlatformDevice;
 
 typedef struct VFIOPlatformDeviceClass {
diff --git a/trace-events b/trace-events
index c3dbfc3..31371b4 100644
--- a/trace-events
+++ b/trace-events
@@ -1571,6 +1571,8 @@ vfio_platform_populate_regions(int region_index, unsigned long flag, unsigned lo
 vfio_platform_base_device_init(char *name, int groupid) "%s belongs to group #%d"
 vfio_platform_realize(char *name, char *compat) "vfio device %s, compat = %s"
 vfio_intp_interrupt_set_pending(int index) "irq %d is set PENDING"
+vfio_platform_start_irqfd_injection(int index, int gsi, int fd, int resamplefd) "IRQ index=%d, gsi =%d, fd = %d, resamplefd = %d"
+vfio_start_eventfd_injection(int index, int fd) "IRQ index=%d, fd = %d"
 
 #hw/acpi/memory_hotplug.c
 mhp_acpi_invalid_slot_selected(uint32_t slot) "0x%"PRIx32
-- 
1.8.3.2
