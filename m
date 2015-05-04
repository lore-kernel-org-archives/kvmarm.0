From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 4/4] hw/vfio/platform: add forwarded irq support
Date: Mon,  4 May 2015 13:49:58 +0100
Message-ID: <1430743798-8839-5-git-send-email-eric.auger@linaro.org>
References: <1430743798-8839-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A635B4F799
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2015 08:41:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DQXGGIAkHk8H for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 May 2015 08:41:28 -0400 (EDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
 [209.85.212.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D0AF4F7A1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2015 08:41:28 -0400 (EDT)
Received: by wiun10 with SMTP id n10so108831394wiu.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 May 2015 05:50:10 -0700 (PDT)
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

Tests whether the forwarded IRQ modality is available.
In the positive device IRQs are forwarded. This control is
achieved with KVM-VFIO device. with such a modality injection
still is handled through irqfds. However end of interrupt is
not trapped anymore. As soon as the guest completes its virtual
IRQ, the corresponding physical IRQ is completed and the same
physical IRQ can hit again.

A new x-forward property enables to force forwarding off although
enabled by the kernel.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- use kvm_vfio_get|put_device_irq, new irq connect notifier and
  integrate with 2 stage eventfd/irqfd setup

v1:
- moved in a separate series

v8 -> v9 (KVM platform device passthrough series):
- use new kvm_vfio_dev_irq struct

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 hw/vfio/platform.c              | 103 +++++++++++++++++++++++++++++++++++++---
 include/hw/vfio/vfio-platform.h |   3 ++
 trace-events                    |   1 +
 3 files changed, 100 insertions(+), 7 deletions(-)

diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
index 901b98e..52c6d59 100644
--- a/hw/vfio/platform.c
+++ b/hw/vfio/platform.c
@@ -411,6 +411,88 @@ fail_irqfd:
     return;
 }
 
+/*
+ * Functions used with forwarding capability
+ */
+
+static bool has_kvm_vfio_forward_capability(void)
+{
+    struct kvm_device_attr attr = {
+         .group = KVM_DEV_VFIO_DEVICE,
+         .attr = KVM_DEV_VFIO_DEVICE_FORWARD_IRQ};
+
+    if (ioctl(vfio_kvm_device_fd, KVM_HAS_DEVICE_ATTR, &attr) == 0) {
+        return true;
+    } else {
+        return false;
+    }
+}
+
+static void vfio_start_forward_injection(SysBusDevice *sbdev, qemu_irq irq)
+{
+    VFIOPlatformDevice *vdev = VFIO_PLATFORM_DEVICE(sbdev);
+    VFIOINTp *intp;
+    bool found = false;
+    struct kvm_device_attr attr = {
+         .group = KVM_DEV_VFIO_DEVICE,
+         .attr = KVM_DEV_VFIO_DEVICE_FORWARD_IRQ};
+
+    QLIST_FOREACH(intp, &vdev->intp_list, next) {
+        if (intp->qemuirq == irq) {
+            found  = true;
+            break;
+        }
+    }
+    assert(found);
+
+    if (intp->forwarded) {
+        return;
+    }
+
+    /*
+     * stop VFIO signaling and unmask the physical IRQ since
+     * forwarding cannot be set if the IRQ is active or vfio masked
+     */
+    vfio_disable_irqindex(&intp->vdev->vbasedev, intp->pin);
+    vfio_unmask_single_irqindex(&intp->vdev->vbasedev, intp->pin);
+
+    kvm_vfio_get_device_irq(kvm_state, intp->vdev->vbasedev.fd,
+                            intp->pin, 0, 1, intp->qemuirq, &intp->fwd_irq);
+
+    attr.addr = (uint64_t)(unsigned long)intp->fwd_irq;
+
+    if (ioctl(vfio_kvm_device_fd, KVM_SET_DEVICE_ATTR, &attr) < 0) {
+        error_report("vfio: failed to forward irq %d, do standard irqfd",
+                     intp->pin);
+        kvm_vfio_put_device_irq(intp->fwd_irq);
+    } else {
+        trace_vfio_platform_start_fwd_injection(intp->pin);
+        intp->forwarded = true;
+    }
+
+    if (kvm_irqchip_add_irqfd_notifier(kvm_state, &intp->interrupt,
+                                   &intp->unmask, irq) < 0) {
+        goto fail_irqfd;
+    }
+
+    if (vfio_set_trigger_eventfd(intp, NULL) < 0) {
+        goto fail_vfio;
+    }
+    /* only used if forwarding setup failed */
+    if (vfio_set_resample_eventfd(intp) < 0) {
+        goto fail_vfio;
+    }
+
+    intp->kvm_accel = true;
+    return;
+fail_vfio:
+    kvm_irqchip_remove_irqfd_notifier(kvm_state, &intp->interrupt, irq);
+fail_irqfd:
+    vfio_start_eventfd_injection(intp);
+    vfio_unmask_single_irqindex(&vdev->vbasedev, intp->pin);
+    return;
+}
+
 #endif /* CONFIG_KVM */
 
 /* VFIO skeleton */
@@ -655,13 +737,6 @@ static void vfio_platform_realize(DeviceState *dev, Error **errp)
     vbasedev->type = VFIO_DEVICE_TYPE_PLATFORM;
     vbasedev->ops = &vfio_platform_ops;
 
-#ifdef CONFIG_KVM
-    if (kvm_irqfds_enabled() && kvm_resamplefds_enabled() &&
-        vdev->irqfd_allowed) {
-        sbc->connect_irq_notifier = vfio_start_irqfd_injection;
-    }
-#endif
-
     trace_vfio_platform_realize(vbasedev->name, vdev->compat);
 
     ret = vfio_base_device_init(vbasedev);
@@ -679,6 +754,19 @@ static void vfio_platform_realize(DeviceState *dev, Error **errp)
     QLIST_FOREACH(intp, &vdev->intp_list, next) {
         vfio_start_eventfd_injection(intp);
     }
+
+#ifdef CONFIG_KVM
+    if (kvm_irqfds_enabled() && kvm_resamplefds_enabled() &&
+        vdev->irqfd_allowed) {
+        if (has_kvm_vfio_forward_capability() &&
+                 vdev->forward_allowed) {
+            sbc->connect_irq_notifier = vfio_start_forward_injection;
+        } else {
+            sbc->connect_irq_notifier = vfio_start_irqfd_injection;
+        }
+    }
+#endif
+
 }
 
 static const VMStateDescription vfio_platform_vmstate = {
@@ -692,6 +780,7 @@ static Property vfio_platform_dev_properties[] = {
     DEFINE_PROP_UINT32("mmap-timeout-ms", VFIOPlatformDevice,
                        mmap_timeout, 1100),
     DEFINE_PROP_BOOL("x-irqfd", VFIOPlatformDevice, irqfd_allowed, true),
+    DEFINE_PROP_BOOL("x-forward", VFIOPlatformDevice, forward_allowed, true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/include/hw/vfio/vfio-platform.h b/include/hw/vfio/vfio-platform.h
index c5cf1d7..900f918 100644
--- a/include/hw/vfio/vfio-platform.h
+++ b/include/hw/vfio/vfio-platform.h
@@ -42,6 +42,8 @@ typedef struct VFIOINTp {
     uint8_t pin; /* index */
     uint32_t flags; /* IRQ info flags */
     bool kvm_accel; /* set when QEMU bypass through KVM enabled */
+    struct kvm_vfio_dev_irq *fwd_irq;
+    bool forwarded;
 } VFIOINTp;
 
 /* function type for user side eventfd handler */
@@ -59,6 +61,7 @@ typedef struct VFIOPlatformDevice {
     QEMUTimer *mmap_timer; /* allows fast-path resume after IRQ hit */
     QemuMutex intp_mutex; /* protect the intp_list IRQ state */
     bool irqfd_allowed; /* debug option to force irqfd on/off */
+    bool forward_allowed; /* debug option to force forwarding on/off */
 } VFIOPlatformDevice;
 
 typedef struct VFIOPlatformDeviceClass {
diff --git a/trace-events b/trace-events
index cb6381a..99d2b9c 100644
--- a/trace-events
+++ b/trace-events
@@ -1572,6 +1572,7 @@ vfio_platform_intp_inject_pending_lockheld(int pin, int fd) "Inject pending IRQ
 vfio_platform_populate_interrupts(int pin, int count, int flags) "- IRQ index %d: count %d, flags=0x%x"
 vfio_intp_interrupt_set_pending(int index) "irq %d is set PENDING"
 vfio_platform_start_irqfd_injection(int index, int fd, int resamplefd) "IRQ index=%d, fd = %d, resamplefd = %d"
+vfio_platform_start_fwd_injection(int pin) "forwarding set for IRQ pin %d"
 
 #hw/acpi/memory_hotplug.c
 mhp_acpi_invalid_slot_selected(uint32_t slot) "0x%"PRIx32
-- 
1.8.3.2
