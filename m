From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 1/3] qdev: pass the check callback to qdev_init_gpio_out_named
Date: Tue, 28 Apr 2015 10:18:01 +0100
Message-ID: <1430212683-10984-2-git-send-email-eric.auger@linaro.org>
References: <1430212683-10984-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16BF34ECA5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 05:09:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OvHEgDhlr+zo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 05:09:45 -0400 (EDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
 [209.85.212.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D59874EC90
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 05:09:44 -0400 (EDT)
Received: by wiun10 with SMTP id n10so21093666wiu.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 02:18:10 -0700 (PDT)
In-Reply-To: <1430212683-10984-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, pbonzini@redhat.com, peter.crosthwaite@xilinx.com
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

qdev_init_gpio_out_named takes a new argument corresponding to the
check callback passed to object_property_add_link. In qdev_init_gpio_out
this callback is set to the dummy object_property_allow_set_link.

This will allow qdev_init_gpio_out_named callers to specialize this
callback, typically sysbus.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 hw/core/qdev.c         | 8 +++++---
 include/hw/qdev-core.h | 3 ++-
 include/qom/object.h   | 3 +++
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/hw/core/qdev.c b/hw/core/qdev.c
index 7fa58be..dc82df4 100644
--- a/hw/core/qdev.c
+++ b/hw/core/qdev.c
@@ -452,7 +452,8 @@ void qdev_init_gpio_in(DeviceState *dev, qemu_irq_handler handler, int n)
 }
 
 void qdev_init_gpio_out_named(DeviceState *dev, qemu_irq *pins,
-                              const char *name, int n)
+                              const char *name, int n,
+                              object_property_set_link_t check_cb)
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
diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
index 24c973d..9d500a3 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -294,7 +294,8 @@ void qdev_init_gpio_out(DeviceState *dev, qemu_irq *pins, int n);
 void qdev_init_gpio_in_named(DeviceState *dev, qemu_irq_handler handler,
                              const char *name, int n);
 void qdev_init_gpio_out_named(DeviceState *dev, qemu_irq *pins,
-                              const char *name, int n);
+                              const char *name, int n,
+                              object_property_set_link_t fn);
 
 void qdev_pass_gpios(DeviceState *dev, DeviceState *container,
                      const char *name);
diff --git a/include/qom/object.h b/include/qom/object.h
index d2d7748..4687fa1 100644
--- a/include/qom/object.h
+++ b/include/qom/object.h
@@ -33,6 +33,9 @@ typedef struct TypeInfo TypeInfo;
 typedef struct InterfaceClass InterfaceClass;
 typedef struct InterfaceInfo InterfaceInfo;
 
+typedef void (*object_property_set_link_t)(Object *, const char *,
+                                           Object *, Error **);
+
 #define TYPE_OBJECT "object"
 
 /**
-- 
1.8.3.2
