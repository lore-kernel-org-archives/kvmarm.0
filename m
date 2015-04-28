From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v13 09/12] qdev: pass the check callback to
 qdev_init_gpio_out_named
Date: Tue, 28 Apr 2015 17:51:10 +0100
Message-ID: <1430239873-31950-10-git-send-email-eric.auger@linaro.org>
References: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B04A4EDCF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:43:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qP-P5XyXUZyX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 12:43:08 -0400 (EDT)
Received: from mail-wg0-f44.google.com (mail-wg0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23C674EE06
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:43:06 -0400 (EDT)
Received: by wgyo15 with SMTP id o15so799507wgy.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 09:51:33 -0700 (PDT)
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

qdev_init_gpio_out_named takes a new argument corresponding to the
check callback passed to object_property_add_link. In qdev_init_gpio_out
and sysbus_init_irq, this callback is currently set to the dummy
object_property_allow_set_link.

This will allow qdev_init_gpio_out_named callers to specialize this
callback. A subsequent patch will implement that for sysbus.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- fix qdev_init_gpio_out_named call in sysbus_init_irq
- rewording of commit message
---
 hw/core/qdev.c         | 8 +++++---
 hw/core/sysbus.c       | 3 ++-
 include/hw/qdev-core.h | 3 ++-
 include/qom/object.h   | 6 ++++--
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/hw/core/qdev.c b/hw/core/qdev.c
index 6e6a65d..857217d 100644
--- a/hw/core/qdev.c
+++ b/hw/core/qdev.c
@@ -452,7 +452,8 @@ void qdev_init_gpio_in(DeviceState *dev, qemu_irq_handler handler, int n)
 }
 
 void qdev_init_gpio_out_named(DeviceState *dev, qemu_irq *pins,
-                              const char *name, int n)
+                              const char *name, int n,
+                              LinkPropertySetter check_cb)
 {
     int i;
     NamedGPIOList *gpio_list = qdev_get_named_gpio_list(dev, name);
@@ -465,7 +466,7 @@ void qdev_init_gpio_out_named(DeviceState *dev, qemu_irq *pins,
         memset(&pins[i], 0, sizeof(*pins));
         object_property_add_link(OBJECT(dev), propname, TYPE_IRQ,
                                  (Object **)&pins[i],
-                                 object_property_allow_set_link,
+                                 check_cb,
                                  OBJ_PROP_LINK_UNREF_ON_RELEASE,
                                  &error_abort);
     }
@@ -474,7 +475,8 @@ void qdev_init_gpio_out_named(DeviceState *dev, qemu_irq *pins,
 
 void qdev_init_gpio_out(DeviceState *dev, qemu_irq *pins, int n)
 {
-    qdev_init_gpio_out_named(dev, pins, NULL, n);
+    qdev_init_gpio_out_named(dev, pins, NULL, n,
+                             object_property_allow_set_link);
 }
 
 qemu_irq qdev_get_gpio_in_named(DeviceState *dev, const char *name, int n)
diff --git a/hw/core/sysbus.c b/hw/core/sysbus.c
index b53c351..1bcb64d 100644
--- a/hw/core/sysbus.c
+++ b/hw/core/sysbus.c
@@ -159,7 +159,8 @@ void sysbus_mmio_map_overlap(SysBusDevice *dev, int n, hwaddr addr,
 /* Request an IRQ source.  The actual IRQ object may be populated later.  */
 void sysbus_init_irq(SysBusDevice *dev, qemu_irq *p)
 {
-    qdev_init_gpio_out_named(DEVICE(dev), p, SYSBUS_DEVICE_GPIO_IRQ, 1);
+    qdev_init_gpio_out_named(DEVICE(dev), p, SYSBUS_DEVICE_GPIO_IRQ, 1,
+                             object_property_allow_set_link);
 }
 
 /* Pass IRQs from a target device.  */
diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
index 4e673f9..0885f39 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -293,7 +293,8 @@ void qdev_init_gpio_out(DeviceState *dev, qemu_irq *pins, int n);
 void qdev_init_gpio_in_named(DeviceState *dev, qemu_irq_handler handler,
                              const char *name, int n);
 void qdev_init_gpio_out_named(DeviceState *dev, qemu_irq *pins,
-                              const char *name, int n);
+                              const char *name, int n,
+                              LinkPropertySetter fn);
 
 void qdev_pass_gpios(DeviceState *dev, DeviceState *container,
                      const char *name);
diff --git a/include/qom/object.h b/include/qom/object.h
index d2d7748..95d1a1d 100644
--- a/include/qom/object.h
+++ b/include/qom/object.h
@@ -33,6 +33,9 @@ typedef struct TypeInfo TypeInfo;
 typedef struct InterfaceClass InterfaceClass;
 typedef struct InterfaceInfo InterfaceInfo;
 
+typedef void (*LinkPropertySetter)(Object *, const char *,
+                                   Object *, Error **);
+
 #define TYPE_OBJECT "object"
 
 /**
@@ -1165,8 +1168,7 @@ void object_property_allow_set_link(Object *, const char *,
  */
 void object_property_add_link(Object *obj, const char *name,
                               const char *type, Object **child,
-                              void (*check)(Object *obj, const char *name,
-                                            Object *val, Error **errp),
+                              LinkPropertySetter check,
                               ObjectPropertyLinkFlags flags,
                               Error **errp);
 
-- 
1.8.3.2
