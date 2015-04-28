From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v13 04/12] hw/vfio/platform: calxeda xgmac device
Date: Tue, 28 Apr 2015 17:51:05 +0100
Message-ID: <1430239873-31950-5-git-send-email-eric.auger@linaro.org>
References: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC8774ED87
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:43:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3VXDfsjlJLAg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 12:42:59 -0400 (EDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
 [209.85.212.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 846894ED89
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:42:59 -0400 (EDT)
Received: by wief7 with SMTP id f7so21492550wie.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 09:51:25 -0700 (PDT)
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

The platform device class has become abstract. This patch introduces
a calxeda xgmac device that derives from it.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Alex Bennee<alex.bennee@linaro.org>

---
v10 -> v11:
- add Alex Reviewed-by
- move virt modifications in a separate patch

v8 -> v9:
- renamed calxeda_xgmac.c into calxeda-xgmac.c

v7 -> v8:
- add a comment in the header about the MMIO regions and IRQ which
  are exposed by the device

v5 -> v6
- back again following Alex Graf advises
- fix a bug related to compat override

v4 -> v5:
removed since device tree was moved to hw/arm/dyn_sysbus_devtree.c

v4: creation for device tree specialization

Conflicts:
	hw/arm/virt.c
---
 hw/vfio/Makefile.objs                |  1 +
 hw/vfio/calxeda-xgmac.c              | 54 ++++++++++++++++++++++++++++++++++++
 include/hw/vfio/vfio-calxeda-xgmac.h | 46 ++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+)
 create mode 100644 hw/vfio/calxeda-xgmac.c
 create mode 100644 include/hw/vfio/vfio-calxeda-xgmac.h

diff --git a/hw/vfio/Makefile.objs b/hw/vfio/Makefile.objs
index c5c76fe..d540c9d 100644
--- a/hw/vfio/Makefile.objs
+++ b/hw/vfio/Makefile.objs
@@ -2,4 +2,5 @@ ifeq ($(CONFIG_LINUX), y)
 obj-$(CONFIG_SOFTMMU) += common.o
 obj-$(CONFIG_PCI) += pci.o
 obj-$(CONFIG_SOFTMMU) += platform.o
+obj-$(CONFIG_SOFTMMU) += calxeda-xgmac.o
 endif
diff --git a/hw/vfio/calxeda-xgmac.c b/hw/vfio/calxeda-xgmac.c
new file mode 100644
index 0000000..c4b8fef
--- /dev/null
+++ b/hw/vfio/calxeda-xgmac.c
@@ -0,0 +1,54 @@
+/*
+ * calxeda xgmac VFIO device
+ *
+ * Copyright Linaro Limited, 2014
+ *
+ * Authors:
+ *  Eric Auger <eric.auger@linaro.org>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+#include "hw/vfio/vfio-calxeda-xgmac.h"
+
+static void calxeda_xgmac_realize(DeviceState *dev, Error **errp)
+{
+    VFIOPlatformDevice *vdev = VFIO_PLATFORM_DEVICE(dev);
+    VFIOCalxedaXgmacDeviceClass *k = VFIO_CALXEDA_XGMAC_DEVICE_GET_CLASS(dev);
+
+    vdev->compat = g_strdup("calxeda,hb-xgmac");
+
+    k->parent_realize(dev, errp);
+}
+
+static const VMStateDescription vfio_platform_vmstate = {
+    .name = TYPE_VFIO_CALXEDA_XGMAC,
+    .unmigratable = 1,
+};
+
+static void vfio_calxeda_xgmac_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    VFIOCalxedaXgmacDeviceClass *vcxc =
+        VFIO_CALXEDA_XGMAC_DEVICE_CLASS(klass);
+    vcxc->parent_realize = dc->realize;
+    dc->realize = calxeda_xgmac_realize;
+    dc->desc = "VFIO Calxeda XGMAC";
+}
+
+static const TypeInfo vfio_calxeda_xgmac_dev_info = {
+    .name = TYPE_VFIO_CALXEDA_XGMAC,
+    .parent = TYPE_VFIO_PLATFORM,
+    .instance_size = sizeof(VFIOCalxedaXgmacDevice),
+    .class_init = vfio_calxeda_xgmac_class_init,
+    .class_size = sizeof(VFIOCalxedaXgmacDeviceClass),
+};
+
+static void register_calxeda_xgmac_dev_type(void)
+{
+    type_register_static(&vfio_calxeda_xgmac_dev_info);
+}
+
+type_init(register_calxeda_xgmac_dev_type)
diff --git a/include/hw/vfio/vfio-calxeda-xgmac.h b/include/hw/vfio/vfio-calxeda-xgmac.h
new file mode 100644
index 0000000..f994775
--- /dev/null
+++ b/include/hw/vfio/vfio-calxeda-xgmac.h
@@ -0,0 +1,46 @@
+/*
+ * VFIO calxeda xgmac device
+ *
+ * Copyright Linaro Limited, 2014
+ *
+ * Authors:
+ *  Eric Auger <eric.auger@linaro.org>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+#ifndef HW_VFIO_VFIO_CALXEDA_XGMAC_H
+#define HW_VFIO_VFIO_CALXEDA_XGMAC_H
+
+#include "hw/vfio/vfio-platform.h"
+
+#define TYPE_VFIO_CALXEDA_XGMAC "vfio-calxeda-xgmac"
+
+/**
+ * This device exposes:
+ * - a single MMIO region corresponding to its register space
+ * - 3 IRQS (main and 2 power related IRQs)
+ */
+typedef struct VFIOCalxedaXgmacDevice {
+    VFIOPlatformDevice vdev;
+} VFIOCalxedaXgmacDevice;
+
+typedef struct VFIOCalxedaXgmacDeviceClass {
+    /*< private >*/
+    VFIOPlatformDeviceClass parent_class;
+    /*< public >*/
+    DeviceRealize parent_realize;
+} VFIOCalxedaXgmacDeviceClass;
+
+#define VFIO_CALXEDA_XGMAC_DEVICE(obj) \
+     OBJECT_CHECK(VFIOCalxedaXgmacDevice, (obj), TYPE_VFIO_CALXEDA_XGMAC)
+#define VFIO_CALXEDA_XGMAC_DEVICE_CLASS(klass) \
+     OBJECT_CLASS_CHECK(VFIOCalxedaXgmacDeviceClass, (klass), \
+                        TYPE_VFIO_CALXEDA_XGMAC)
+#define VFIO_CALXEDA_XGMAC_DEVICE_GET_CLASS(obj) \
+     OBJECT_GET_CLASS(VFIOCalxedaXgmacDeviceClass, (obj), \
+                      TYPE_VFIO_CALXEDA_XGMAC)
+
+#endif
-- 
1.8.3.2
