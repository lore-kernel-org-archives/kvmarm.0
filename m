From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v15 10/10] hw/vfio/platform: add irqfd support
Date: Thu, 30 Apr 2015 13:49:15 +0100
Message-ID: <1430398155-11214-11-git-send-email-eric.auger@linaro.org>
References: <1430398155-11214-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85B704F028
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 08:41:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j4TdKc3wSx1v for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2015 08:41:08 -0400 (EDT)
Received: from mail-wg0-f52.google.com (mail-wg0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C2FF4F04B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 08:41:06 -0400 (EDT)
Received: by wgso17 with SMTP id o17so61158171wgs.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 05:49:38 -0700 (PDT)
In-Reply-To: <1430398155-11214-1-git-send-email-eric.auger@linaro.org>
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
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch aims at optimizing IRQ handling using irqfd framework.

Instead of handling the eventfds on user-side they are handled on
kernel side using
- the KVM irqfd framework,
- the VFIO driver virqfd framework.

the virtual IRQ completion is trapped at interrupt controller
This removes the need for fast/slow path swap.

Overall this brings significant performance improvements.

Signed-off-by: Alvise Rigo <a.rigo@virtualopensystems.com>
Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Alex Bennee<alex.bennee@linaro.org>

---
v13 -> v14:
- use connect_irq_notifier
- remove trace_vfio_platform_start_eventfd

v12 -> v13:
- setup the new mechanism for starting irqfd, based on
  LinkPropertySetter override
- use kvm_irqchip_[add,remove]_irqfd_notifier new functions: no need
  to bother about gsi (hence virtualID could be removed with small
  change in trace-events)

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
 hw/vfio/platform.c              | 107 ++++++++++++++++++++++++++++++++++++++++
 include/hw/vfio/vfio-platform.h |   2 +
 trace-events                    |   1 +
 3 files changed, 110 insertions(+)

diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
index 35266a8..901b98e 100644
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
@@ -315,6 +324,95 @@ static int vfio_start_eventfd_injection(VFIOINTp *intp)
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
+static void vfio_start_irqfd_injection(SysBusDevice *sbdev, qemu_irq irq)
+{
+    VFIOPlatformDevice *vdev = VFIO_PLATFORM_DEVICE(sbdev);
+    VFIOINTp *intp;
+    bool found = false;
+
+    QLIST_FOREACH(intp, &vdev->intp_list, next) {
+        if (intp->qemuirq == irq) {
+            found  = true;
+            break;
+        }
+    }
+    assert(found);
+
+    /* Get to a known interrupt state */
+    qemu_set_fd_handler(event_notifier_get_fd(&intp->interrupt),
+                        NULL, NULL, vdev);
+
+    vfio_mask_single_irqindex(&vdev->vbasedev, intp->pin);
+    qemu_set_irq(intp->qemuirq, 0);
+
+    if (kvm_irqchip_add_irqfd_notifier(kvm_state, &intp->interrupt,
+                                   &intp->unmask, irq) < 0) {
+        goto fail_irqfd;
+    }
+
+    if (vfio_set_trigger_eventfd(intp, NULL) < 0) {
+        goto fail_vfio;
+    }
+    if (vfio_set_resample_eventfd(intp) < 0) {
+        goto fail_vfio;
+    }
+
+    /* Let'em rip */
+    vfio_unmask_single_irqindex(&vdev->vbasedev, intp->pin);
+
+    intp->kvm_accel = true;
+
+    trace_vfio_platform_start_irqfd_injection(intp->pin,
+                                     event_notifier_get_fd(&intp->interrupt),
+                                     event_notifier_get_fd(&intp->unmask));
+    return;
+fail_vfio:
+    kvm_irqchip_remove_irqfd_notifier(kvm_state, &intp->interrupt, irq);
+fail_irqfd:
+    vfio_start_eventfd_injection(intp);
+    vfio_unmask_single_irqindex(&vdev->vbasedev, intp->pin);
+    return;
+}
+
+#endif /* CONFIG_KVM */
+
 /* VFIO skeleton */
 
 static void vfio_platform_compute_needs_reset(VFIODevice *vbasedev)
@@ -549,6 +647,7 @@ static void vfio_platform_realize(DeviceState *dev, Error **errp)
 {
     VFIOPlatformDevice *vdev = VFIO_PLATFORM_DEVICE(dev);
     SysBusDevice *sbdev = SYS_BUS_DEVICE(dev);
+    SysBusDeviceClass *sbc = SYS_BUS_DEVICE_GET_CLASS(dev);
     VFIODevice *vbasedev = &vdev->vbasedev;
     VFIOINTp *intp;
     int i, ret;
@@ -556,6 +655,13 @@ static void vfio_platform_realize(DeviceState *dev, Error **errp)
     vbasedev->type = VFIO_DEVICE_TYPE_PLATFORM;
     vbasedev->ops = &vfio_platform_ops;
 
+#ifdef CONFIG_KVM
+    if (kvm_irqfds_enabled() && kvm_resamplefds_enabled() &&
+        vdev->irqfd_allowed) {
+        sbc->connect_irq_notifier = vfio_start_irqfd_injection;
+    }
+#endif
+
     trace_vfio_platform_realize(vbasedev->name, vdev->compat);
 
     ret = vfio_base_device_init(vbasedev);
@@ -585,6 +691,7 @@ static Property vfio_platform_dev_properties[] = {
     DEFINE_PROP_BOOL("x-mmap", VFIOPlatformDevice, vbasedev.allow_mmap, true),
     DEFINE_PROP_UINT32("mmap-timeout-ms", VFIOPlatformDevice,
                        mmap_timeout, 1100),
+    DEFINE_PROP_BOOL("x-irqfd", VFIOPlatformDevice, irqfd_allowed, true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/include/hw/vfio/vfio-platform.h b/include/hw/vfio/vfio-platform.h
index 26b2ad6..c5cf1d7 100644
--- a/include/hw/vfio/vfio-platform.h
+++ b/include/hw/vfio/vfio-platform.h
@@ -41,6 +41,7 @@ typedef struct VFIOINTp {
     int state; /* inactive, pending, active */
     uint8_t pin; /* index */
     uint32_t flags; /* IRQ info flags */
+    bool kvm_accel; /* set when QEMU bypass through KVM enabled */
 } VFIOINTp;
 
 /* function type for user side eventfd handler */
@@ -57,6 +58,7 @@ typedef struct VFIOPlatformDevice {
     uint32_t mmap_timeout; /* delay to re-enable mmaps after interrupt */
     QEMUTimer *mmap_timer; /* allows fast-path resume after IRQ hit */
     QemuMutex intp_mutex; /* protect the intp_list IRQ state */
+    bool irqfd_allowed; /* debug option to force irqfd on/off */
 } VFIOPlatformDevice;
 
 typedef struct VFIOPlatformDeviceClass {
diff --git a/trace-events b/trace-events
index ed8ed90..cb6381a 100644
--- a/trace-events
+++ b/trace-events
@@ -1571,6 +1571,7 @@ vfio_platform_intp_interrupt(int pin, int fd) "Inject IRQ #%d (fd = %d)"
 vfio_platform_intp_inject_pending_lockheld(int pin, int fd) "Inject pending IRQ #%d (fd = %d)"
 vfio_platform_populate_interrupts(int pin, int count, int flags) "- IRQ index %d: count %d, flags=0x%x"
 vfio_intp_interrupt_set_pending(int index) "irq %d is set PENDING"
+vfio_platform_start_irqfd_injection(int index, int fd, int resamplefd) "IRQ index=%d, fd = %d, resamplefd = %d"
 
 #hw/acpi/memory_hotplug.c
 mhp_acpi_invalid_slot_selected(uint32_t slot) "0x%"PRIx32
-- 
1.8.3.2
