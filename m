From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v12 4/9] hw/vfio/platform: add capability to start IRQ
 propagation
Date: Thu, 19 Mar 2015 17:16:36 +0000
Message-ID: <1426785402-2091-5-git-send-email-eric.auger@linaro.org>
References: <1426785402-2091-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BD4A49347
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 13:10:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5AkObEvLS23w for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2015 13:10:11 -0400 (EDT)
Received: from mail-wg0-f45.google.com (mail-wg0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3FE749336
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 13:10:10 -0400 (EDT)
Received: by wggv3 with SMTP id v3so68376682wgg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 10:16:52 -0700 (PDT)
In-Reply-To: <1426785402-2091-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de
Cc: patches@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Add a reset notify function that enables to start the propagation of
interrupts to the guest.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v10 -> v11:
- comment reword

v8 -> v9:
- handle failure in vfio_irq_starter
---
 hw/vfio/platform.c              | 64 +++++++++++++++++++++++++++++++++++++++++
 include/hw/vfio/vfio-platform.h |  8 ++++++
 2 files changed, 72 insertions(+)

diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
index 31c2701..361e01b 100644
--- a/hw/vfio/platform.c
+++ b/hw/vfio/platform.c
@@ -572,6 +572,70 @@ static void vfio_platform_realize(DeviceState *dev, Error **errp)
     }
 }
 
+/**
+ * vfio_irq_starter: Start IRQ forwarding for a specific VFIO device
+ * @sbdev: Sysbus device handle
+ * @opaque: DeviceState handle of the interrupt controller the device
+ *          is attached to
+ *
+ * The function retrieves the absolute GSI number each VFIO IRQ
+ * corresponds to and start forwarding.
+ */
+static int vfio_irq_starter(SysBusDevice *sbdev, void *opaque)
+{
+    DeviceState *intc = (DeviceState *)opaque;
+    VFIOPlatformDevice *vdev;
+    VFIOINTp *intp;
+    qemu_irq irq;
+    int gsi, ret;
+
+    if (object_dynamic_cast(OBJECT(sbdev), TYPE_VFIO_PLATFORM)) {
+        vdev = VFIO_PLATFORM_DEVICE(sbdev);
+
+        QLIST_FOREACH(intp, &vdev->intp_list, next) {
+            gsi = 0;
+            while (1) {
+                irq = qdev_get_gpio_in(intc, gsi);
+                if (irq == intp->qemuirq) {
+                    break;
+                }
+                gsi++;
+            }
+            intp->virtualID = gsi;
+            ret = vdev->start_irq_fn(intp);
+            if (ret) {
+                error_report("%s unable to start propagation of IRQ index %d",
+                             vdev->vbasedev.name, intp->pin);
+                exit(1);
+            }
+        }
+    }
+    return 0;
+}
+
+/**
+ * vfio_kick_irqs: start IRQ forwarding for all the VFIO devices
+ * attached to the platform bus
+ * @data: Device state handle of the interrupt controller the VFIO IRQs
+ *        must be bound to
+ *
+ * Binding to the platform bus IRQs happens on a machine init done
+ * notifier registered by the platform bus. Only at that time the
+ * absolute virtual IRQ = GSI is known and allows to setup IRQFD.
+ * This function typically can be called in a reset notifier registered
+ * by the machine file.
+ */
+void vfio_kick_irqs(void *data)
+{
+    DeviceState *intc = (DeviceState *)data;
+    DeviceState *dev =
+        qdev_find_recursive(sysbus_get_default(), TYPE_PLATFORM_BUS_DEVICE);
+    PlatformBusDevice *pbus = PLATFORM_BUS_DEVICE(dev);
+
+    assert(pbus->done_gathering);
+    foreach_dynamic_sysbus_device(vfio_irq_starter, intc);
+}
+
 static const VMStateDescription vfio_platform_vmstate = {
     .name = TYPE_VFIO_PLATFORM,
     .unmigratable = 1,
diff --git a/include/hw/vfio/vfio-platform.h b/include/hw/vfio/vfio-platform.h
index 31893a3..c9ee898 100644
--- a/include/hw/vfio/vfio-platform.h
+++ b/include/hw/vfio/vfio-platform.h
@@ -77,4 +77,12 @@ typedef struct VFIOPlatformDeviceClass {
 #define VFIO_PLATFORM_DEVICE_GET_CLASS(obj) \
      OBJECT_GET_CLASS(VFIOPlatformDeviceClass, (obj), TYPE_VFIO_PLATFORM)
 
+/**
+ * vfio_kick_irqs - reset notifier that starts IRQ injection
+ * for all VFIO dynamic sysbus devices attached to the platform bus.
+ *
+ * @opaque: handle to the interrupt controller DeviceState
+ */
+void vfio_kick_irqs(void *opaque);
+
 #endif /*HW_VFIO_VFIO_PLATFORM_H*/
-- 
1.8.3.2
