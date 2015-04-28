From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v13 03/12] hw/vfio/platform: add irq assignment
Date: Tue, 28 Apr 2015 17:51:04 +0100
Message-ID: <1430239873-31950-4-git-send-email-eric.auger@linaro.org>
References: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3BF14ED8F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:42:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V3JPMn0QAgGz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 12:42:58 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34C184ED90
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:42:58 -0400 (EDT)
Received: by wiun10 with SMTP id n10so36393504wiu.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 09:51:24 -0700 (PDT)
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

This patch adds the code requested to assign interrupts to
a guest. The interrupts are mediated through user handled
eventfds only.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v12 -> v13:
- start user-side eventfd handling at realize time
- remove start_irq_fn

v10 -> v11:
- use block declaration when possible
- change order of vfio_platform_eoi vs vfio_intp_interrupt
- introduce vfio_intp_inject_pending_lockheld following Alex Bennee
  comments
- remove unmasking/masked when setting up VFIO signaling
- remove unused kvm_accel member in VFIOINTp struct
- add flags member in VFIOINTp in order to properly discriminate
  edge/level-sensitive IRQs; unmask the physical IRQ only in case of
  level-sensitive IRQ
- some comment rewording

v8 -> v9:
- free irq related resources in case of error in vfio_populate_device
---
 hw/vfio/platform.c              | 331 +++++++++++++++++++++++++++++++++++++++-
 include/hw/vfio/vfio-platform.h |  32 ++++
 trace-events                    |   7 +
 3 files changed, 369 insertions(+), 1 deletion(-)

diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
index 48dfc55..f484764 100644
--- a/hw/vfio/platform.c
+++ b/hw/vfio/platform.c
@@ -22,10 +22,299 @@
 #include "qemu/range.h"
 #include "sysemu/sysemu.h"
 #include "exec/memory.h"
+#include "qemu/queue.h"
 #include "hw/sysbus.h"
 #include "trace.h"
 #include "hw/platform-bus.h"
 
+/*
+ * Functions used whatever the injection method
+ */
+
+/**
+ * vfio_init_intp - allocate, initialize the IRQ struct pointer
+ * and add it into the list of IRQs
+ * @vbasedev: the VFIO device handle
+ * @info: irq info struct retrieved from VFIO driver
+ */
+static VFIOINTp *vfio_init_intp(VFIODevice *vbasedev,
+                                struct vfio_irq_info info)
+{
+    int ret;
+    VFIOPlatformDevice *vdev =
+        container_of(vbasedev, VFIOPlatformDevice, vbasedev);
+    SysBusDevice *sbdev = SYS_BUS_DEVICE(vdev);
+    VFIOINTp *intp;
+
+    intp = g_malloc0(sizeof(*intp));
+    intp->vdev = vdev;
+    intp->pin = info.index;
+    intp->flags = info.flags;
+    intp->state = VFIO_IRQ_INACTIVE;
+
+    sysbus_init_irq(sbdev, &intp->qemuirq);
+
+    /* Get an eventfd for trigger */
+    ret = event_notifier_init(&intp->interrupt, 0);
+    if (ret) {
+        g_free(intp);
+        error_report("vfio: Error: trigger event_notifier_init failed ");
+        return NULL;
+    }
+
+    QLIST_INSERT_HEAD(&vdev->intp_list, intp, next);
+    return intp;
+}
+
+/**
+ * vfio_set_trigger_eventfd - set VFIO eventfd handling
+ *
+ * @intp: IRQ struct handle
+ * @handler: handler to be called on eventfd signaling
+ *
+ * Setup VFIO signaling and attach an optional user-side handler
+ * to the eventfd
+ */
+static int vfio_set_trigger_eventfd(VFIOINTp *intp,
+                                    eventfd_user_side_handler_t handler)
+{
+    VFIODevice *vbasedev = &intp->vdev->vbasedev;
+    struct vfio_irq_set *irq_set;
+    int argsz, ret;
+    int32_t *pfd;
+
+    argsz = sizeof(*irq_set) + sizeof(*pfd);
+    irq_set = g_malloc0(argsz);
+    irq_set->argsz = argsz;
+    irq_set->flags = VFIO_IRQ_SET_DATA_EVENTFD | VFIO_IRQ_SET_ACTION_TRIGGER;
+    irq_set->index = intp->pin;
+    irq_set->start = 0;
+    irq_set->count = 1;
+    pfd = (int32_t *)&irq_set->data;
+    *pfd = event_notifier_get_fd(&intp->interrupt);
+    qemu_set_fd_handler(*pfd, (IOHandler *)handler, NULL, intp);
+    ret = ioctl(vbasedev->fd, VFIO_DEVICE_SET_IRQS, irq_set);
+    g_free(irq_set);
+    if (ret < 0) {
+        error_report("vfio: Failed to set trigger eventfd: %m");
+        qemu_set_fd_handler(*pfd, NULL, NULL, NULL);
+    }
+    return ret;
+}
+
+/*
+ * Functions only used when eventfds are handled on user-side
+ * ie. without irqfd
+ */
+
+/**
+ * vfio_mmap_set_enabled - enable/disable the fast path mode
+ * @vdev: the VFIO platform device
+ * @enabled: the target mmap state
+ *
+ * enabled = true ~ fast path = MMIO region is mmaped (no KVM TRAP);
+ * enabled = false ~ slow path = MMIO region is trapped and region callbacks
+ * are called; slow path enables to trap the device IRQ status register reset
+*/
+
+static void vfio_mmap_set_enabled(VFIOPlatformDevice *vdev, bool enabled)
+{
+    int i;
+
+    trace_vfio_platform_mmap_set_enabled(enabled);
+
+    for (i = 0; i < vdev->vbasedev.num_regions; i++) {
+        VFIORegion *region = vdev->regions[i];
+
+        memory_region_set_enabled(&region->mmap_mem, enabled);
+    }
+}
+
+/**
+ * vfio_intp_mmap_enable - timer function, restores the fast path
+ * if there is no more active IRQ
+ * @opaque: actually points to the VFIO platform device
+ *
+ * Called on mmap timer timout, this function checks whether the
+ * IRQ is still active and if not, restores the fast path.
+ * by construction a single eventfd is handled at a time.
+ * if the IRQ is still active, the timer is re-programmed.
+ */
+static void vfio_intp_mmap_enable(void *opaque)
+{
+    VFIOINTp *tmp;
+    VFIOPlatformDevice *vdev = (VFIOPlatformDevice *)opaque;
+
+    qemu_mutex_lock(&vdev->intp_mutex);
+    QLIST_FOREACH(tmp, &vdev->intp_list, next) {
+        if (tmp->state == VFIO_IRQ_ACTIVE) {
+            trace_vfio_platform_intp_mmap_enable(tmp->pin);
+            /* re-program the timer to check active status later */
+            timer_mod(vdev->mmap_timer,
+                      qemu_clock_get_ms(QEMU_CLOCK_VIRTUAL) +
+                          vdev->mmap_timeout);
+            qemu_mutex_unlock(&vdev->intp_mutex);
+            return;
+        }
+    }
+    vfio_mmap_set_enabled(vdev, true);
+    qemu_mutex_unlock(&vdev->intp_mutex);
+}
+
+/**
+ * vfio_intp_inject_pending_lockheld - Injects a pending IRQ
+ * @opaque: opaque pointer, in practice the VFIOINTp handle
+ *
+ * The function is called on a previous IRQ completion, from
+ * vfio_platform_eoi, while the intp_mutex is locked.
+ * Also in such situation, the slow path already is set and
+ * the mmap timer was already programmed.
+ */
+static void vfio_intp_inject_pending_lockheld(VFIOINTp *intp)
+{
+    trace_vfio_platform_intp_inject_pending_lockheld(intp->pin,
+                              event_notifier_get_fd(&intp->interrupt));
+
+    intp->state = VFIO_IRQ_ACTIVE;
+
+    /* trigger the virtual IRQ */
+    qemu_set_irq(intp->qemuirq, 1);
+}
+
+/**
+ * vfio_intp_interrupt - The user-side eventfd handler
+ * @opaque: opaque pointer which in practice is the VFIOINTp handle
+ *
+ * the function is entered in event handler context:
+ * the vIRQ is injected into the guest if there is no other active
+ * or pending IRQ.
+ */
+static void vfio_intp_interrupt(VFIOINTp *intp)
+{
+    int ret;
+    VFIOINTp *tmp;
+    VFIOPlatformDevice *vdev = intp->vdev;
+    bool delay_handling = false;
+
+    qemu_mutex_lock(&vdev->intp_mutex);
+    if (intp->state == VFIO_IRQ_INACTIVE) {
+        QLIST_FOREACH(tmp, &vdev->intp_list, next) {
+            if (tmp->state == VFIO_IRQ_ACTIVE ||
+                tmp->state == VFIO_IRQ_PENDING) {
+                delay_handling = true;
+                break;
+            }
+        }
+    }
+    if (delay_handling) {
+        /*
+         * the new IRQ gets a pending status and is pushed in
+         * the pending queue
+         */
+        intp->state = VFIO_IRQ_PENDING;
+        trace_vfio_intp_interrupt_set_pending(intp->pin);
+        QSIMPLEQ_INSERT_TAIL(&vdev->pending_intp_queue,
+                             intp, pqnext);
+        ret = event_notifier_test_and_clear(&intp->interrupt);
+        qemu_mutex_unlock(&vdev->intp_mutex);
+        return;
+    }
+
+    trace_vfio_platform_intp_interrupt(intp->pin,
+                              event_notifier_get_fd(&intp->interrupt));
+
+    ret = event_notifier_test_and_clear(&intp->interrupt);
+    if (!ret) {
+        error_report("Error when clearing fd=%d (ret = %d)\n",
+                     event_notifier_get_fd(&intp->interrupt), ret);
+    }
+
+    intp->state = VFIO_IRQ_ACTIVE;
+
+    /* sets slow path */
+    vfio_mmap_set_enabled(vdev, false);
+
+    /* trigger the virtual IRQ */
+    qemu_set_irq(intp->qemuirq, 1);
+
+    /*
+     * Schedule the mmap timer which will restore fastpath when no IRQ
+     * is active anymore
+     */
+    if (vdev->mmap_timeout) {
+        timer_mod(vdev->mmap_timer,
+                  qemu_clock_get_ms(QEMU_CLOCK_VIRTUAL) +
+                      vdev->mmap_timeout);
+    }
+    qemu_mutex_unlock(&vdev->intp_mutex);
+}
+
+/**
+ * vfio_platform_eoi - IRQ completion routine
+ * @vbasedev: the VFIO device handle
+ *
+ * De-asserts the active virtual IRQ and unmasks the physical IRQ
+ * (effective for level sensitive IRQ auto-masked by the  VFIO driver).
+ * Then it handles next pending IRQ if any.
+ * eoi function is called on the first access to any MMIO region
+ * after an IRQ was triggered, trapped since slow path was set.
+ * It is assumed this access corresponds to the IRQ status
+ * register reset. With such a mechanism, a single IRQ can be
+ * handled at a time since there is no way to know which IRQ
+ * was completed by the guest (we would need additional details
+ * about the IRQ status register mask).
+ */
+static void vfio_platform_eoi(VFIODevice *vbasedev)
+{
+    VFIOINTp *intp;
+    VFIOPlatformDevice *vdev =
+        container_of(vbasedev, VFIOPlatformDevice, vbasedev);
+
+    qemu_mutex_lock(&vdev->intp_mutex);
+    QLIST_FOREACH(intp, &vdev->intp_list, next) {
+        if (intp->state == VFIO_IRQ_ACTIVE) {
+            trace_vfio_platform_eoi(intp->pin,
+                                event_notifier_get_fd(&intp->interrupt));
+            intp->state = VFIO_IRQ_INACTIVE;
+
+            /* deassert the virtual IRQ */
+            qemu_set_irq(intp->qemuirq, 0);
+
+            if (intp->flags & VFIO_IRQ_INFO_AUTOMASKED) {
+                /* unmasks the physical level-sensitive IRQ */
+                vfio_unmask_single_irqindex(vbasedev, intp->pin);
+            }
+
+            /* a single IRQ can be active at a time */
+            break;
+        }
+    }
+    /* in case there are pending IRQs, handle the first one */
+    if (!QSIMPLEQ_EMPTY(&vdev->pending_intp_queue)) {
+        intp = QSIMPLEQ_FIRST(&vdev->pending_intp_queue);
+        vfio_intp_inject_pending_lockheld(intp);
+        QSIMPLEQ_REMOVE_HEAD(&vdev->pending_intp_queue, pqnext);
+    }
+    qemu_mutex_unlock(&vdev->intp_mutex);
+}
+
+/**
+ * vfio_start_eventfd_injection - starts the virtual IRQ injection using
+ * user-side handled eventfds
+ * @intp: the IRQ struct pointer
+ */
+
+static int vfio_start_eventfd_injection(VFIOINTp *intp)
+{
+    int ret;
+
+    ret = vfio_set_trigger_eventfd(intp, vfio_intp_interrupt);
+    if (ret) {
+        error_report("vfio: Error: Failed to pass IRQ fd to the driver: %m");
+    }
+    return ret;
+}
+
 /* VFIO skeleton */
 
 /* not implemented yet */
@@ -42,12 +331,13 @@ static int vfio_platform_hot_reset_multi(VFIODevice *vbasedev)
 
 /**
  * vfio_populate_device - Allocate and populate MMIO region
- * structs according to driver returned information
+ * and IRQ structs according to driver returned information
  * @vbasedev: the VFIO device handle
  *
  */
 static int vfio_populate_device(VFIODevice *vbasedev)
 {
+    VFIOINTp *intp, *tmp;
     int i, ret = -1;
     VFIOPlatformDevice *vdev =
         container_of(vbasedev, VFIOPlatformDevice, vbasedev);
@@ -85,7 +375,38 @@ static int vfio_populate_device(VFIODevice *vbasedev)
                             (unsigned long)ptr->fd_offset);
     }
 
+    vdev->mmap_timer = timer_new_ms(QEMU_CLOCK_VIRTUAL,
+                                    vfio_intp_mmap_enable, vdev);
+
+    QSIMPLEQ_INIT(&vdev->pending_intp_queue);
+
+    for (i = 0; i < vbasedev->num_irqs; i++) {
+        struct vfio_irq_info irq = { .argsz = sizeof(irq) };
+
+        irq.index = i;
+        ret = ioctl(vbasedev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq);
+        if (ret) {
+            error_printf("vfio: error getting device %s irq info",
+                         vbasedev->name);
+            goto irq_err;
+        } else {
+            trace_vfio_platform_populate_interrupts(irq.index,
+                                                    irq.count,
+                                                    irq.flags);
+            intp = vfio_init_intp(vbasedev, irq);
+            if (!intp) {
+                error_report("vfio: Error installing IRQ %d up", i);
+                goto irq_err;
+            }
+        }
+    }
     return 0;
+irq_err:
+    timer_del(vdev->mmap_timer);
+    QLIST_FOREACH_SAFE(intp, &vdev->intp_list, next, tmp) {
+        QLIST_REMOVE(intp, next);
+        g_free(intp);
+    }
 reg_error:
     for (i = 0; i < vbasedev->num_regions; i++) {
         g_free(vdev->regions[i]);
@@ -98,6 +419,7 @@ reg_error:
 static VFIODeviceOps vfio_platform_ops = {
     .vfio_compute_needs_reset = vfio_platform_compute_needs_reset,
     .vfio_hot_reset_multi = vfio_platform_hot_reset_multi,
+    .vfio_eoi = vfio_platform_eoi,
 };
 
 /**
@@ -229,6 +551,7 @@ static void vfio_platform_realize(DeviceState *dev, Error **errp)
     VFIOPlatformDevice *vdev = VFIO_PLATFORM_DEVICE(dev);
     SysBusDevice *sbdev = SYS_BUS_DEVICE(dev);
     VFIODevice *vbasedev = &vdev->vbasedev;
+    VFIOINTp *intp;
     int i, ret;
 
     vbasedev->type = VFIO_DEVICE_TYPE_PLATFORM;
@@ -247,6 +570,10 @@ static void vfio_platform_realize(DeviceState *dev, Error **errp)
         vfio_map_region(vdev, i);
         sysbus_init_mmio(sbdev, &vdev->regions[i]->mem);
     }
+
+    QLIST_FOREACH(intp, &vdev->intp_list, next) {
+        vfio_start_eventfd_injection(intp);
+    }
 }
 
 static const VMStateDescription vfio_platform_vmstate = {
@@ -257,6 +584,8 @@ static const VMStateDescription vfio_platform_vmstate = {
 static Property vfio_platform_dev_properties[] = {
     DEFINE_PROP_STRING("host", VFIOPlatformDevice, vbasedev.name),
     DEFINE_PROP_BOOL("x-mmap", VFIOPlatformDevice, vbasedev.allow_mmap, true),
+    DEFINE_PROP_UINT32("mmap-timeout-ms", VFIOPlatformDevice,
+                       mmap_timeout, 1100),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/include/hw/vfio/vfio-platform.h b/include/hw/vfio/vfio-platform.h
index 338f0c6..ec97e97 100644
--- a/include/hw/vfio/vfio-platform.h
+++ b/include/hw/vfio/vfio-platform.h
@@ -18,14 +18,46 @@
 
 #include "hw/sysbus.h"
 #include "hw/vfio/vfio-common.h"
+#include "qemu/event_notifier.h"
+#include "qemu/queue.h"
+#include "hw/irq.h"
 
 #define TYPE_VFIO_PLATFORM "vfio-platform"
 
+enum {
+    VFIO_IRQ_INACTIVE = 0,
+    VFIO_IRQ_PENDING = 1,
+    VFIO_IRQ_ACTIVE = 2,
+    /* VFIO_IRQ_ACTIVE_AND_PENDING cannot happen with VFIO */
+};
+
+typedef struct VFIOINTp {
+    QLIST_ENTRY(VFIOINTp) next; /* entry for IRQ list */
+    QSIMPLEQ_ENTRY(VFIOINTp) pqnext; /* entry for pending IRQ queue */
+    EventNotifier interrupt; /* eventfd triggered on interrupt */
+    EventNotifier unmask; /* eventfd for unmask on QEMU bypass */
+    qemu_irq qemuirq;
+    struct VFIOPlatformDevice *vdev; /* back pointer to device */
+    int state; /* inactive, pending, active */
+    uint8_t pin; /* index */
+    uint32_t virtualID; /* virtual IRQ */
+    uint32_t flags; /* IRQ info flags */
+} VFIOINTp;
+
+/* function type for user side eventfd handler */
+typedef void (*eventfd_user_side_handler_t)(VFIOINTp *intp);
+
 typedef struct VFIOPlatformDevice {
     SysBusDevice sbdev;
     VFIODevice vbasedev; /* not a QOM object */
     VFIORegion **regions;
+    QLIST_HEAD(, VFIOINTp) intp_list; /* list of IRQs */
+    /* queue of pending IRQs */
+    QSIMPLEQ_HEAD(pending_intp_queue, VFIOINTp) pending_intp_queue;
     char *compat; /* compatibility string */
+    uint32_t mmap_timeout; /* delay to re-enable mmaps after interrupt */
+    QEMUTimer *mmap_timer; /* allows fast-path resume after IRQ hit */
+    QemuMutex intp_mutex; /* protect the intp_list IRQ state */
 } VFIOPlatformDevice;
 
 typedef struct VFIOPlatformDeviceClass {
diff --git a/trace-events b/trace-events
index 2ccc822..ed8ed90 100644
--- a/trace-events
+++ b/trace-events
@@ -1564,6 +1564,13 @@ vfio_put_base_device(int fd) "close vdev->fd=%d"
 vfio_platform_populate_regions(int region_index, unsigned long flag, unsigned long size, int fd, unsigned long offset) "- region %d flags = 0x%lx, size = 0x%lx, fd= %d, offset = 0x%lx"
 vfio_platform_base_device_init(char *name, int groupid) "%s belongs to group #%d"
 vfio_platform_realize(char *name, char *compat) "vfio device %s, compat = %s"
+vfio_platform_eoi(int pin, int fd) "EOI IRQ pin %d (fd=%d)"
+vfio_platform_mmap_set_enabled(bool enabled) "fast path = %d"
+vfio_platform_intp_mmap_enable(int pin) "IRQ #%d still active, stay in slow path"
+vfio_platform_intp_interrupt(int pin, int fd) "Inject IRQ #%d (fd = %d)"
+vfio_platform_intp_inject_pending_lockheld(int pin, int fd) "Inject pending IRQ #%d (fd = %d)"
+vfio_platform_populate_interrupts(int pin, int count, int flags) "- IRQ index %d: count %d, flags=0x%x"
+vfio_intp_interrupt_set_pending(int index) "irq %d is set PENDING"
 
 #hw/acpi/memory_hotplug.c
 mhp_acpi_invalid_slot_selected(uint32_t slot) "0x%"PRIx32
-- 
1.8.3.2
