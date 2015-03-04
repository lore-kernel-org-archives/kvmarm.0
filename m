From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v11 1/4] hw/arm/sysbus-fdt: helpers for platform bus nodes
 addition
Date: Wed,  4 Mar 2015 16:18:26 +0000
Message-ID: <1425485909-5091-2-git-send-email-eric.auger@linaro.org>
References: <1425485909-5091-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE00247B5E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 11:12:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IYo3r+Zu6b+z for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 11:12:41 -0500 (EST)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
 [209.85.212.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2146047B4A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 11:12:41 -0500 (EST)
Received: by widem10 with SMTP id em10so32084337wid.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 08:18:43 -0800 (PST)
In-Reply-To: <1425485909-5091-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, qemu-devel@nongnu.org, peter.maydell@linaro.org
Cc: patches@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This new C module will be used by ARM machine files to generate
platform bus node and their dynamic sysbus device tree nodes.

Dynamic sysbus device node addition is done in a machine init
done notifier. arm_register_platform_bus_fdt_creator does the
registration of this latter and is supposed to be called by
ARM machine files that support platform bus and their dynamic
sysbus. Addition of dynamic sysbus nodes is done only if the
user did not provide any dtb.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Shannon Zhao <zhaoshenglong@huawei.com>
Reviewed-by: Alexander Graf <agraf@suse.de>

---
v9 -> v10:
- add assert and exit in add_fdt_node

v8 -> v9:
- s/Fdt/FDT in struct type names
- reorder fields in PlatformBusFdtNotifierParams and use DO_UPCAST
  instead of container_of
- use assert() when relevant (board model issue)
- g_free the ARMPlatformBusFDTParams and PlatformBusFDTNotifierParams
  pointers in platform_bus_fdt_notify

v7 -> v8:
add Reviewed-by from Alex and Shannon

v6 -> v7:
- revert indentation in add_fdt_node_functions

v5 -> v6:
- add_all_platform_bus_fdt_nodes is not a modify_dtb function anymore
- it now takes a handle to an ARMPlatformBusFdtParams.
- fdt pointer is checked in case this notifier is executed after the
  one that executes the load_dtb (this latter deallocates the fdt pointer)
- check of fdt_filename moved in here.
- upgrade_dtb is removed
- copyright aligned between .h and .c

v4 -> v5:
- change indentation in add_fdt_node_functions. Also becomes a
  static const.
- ARMPlatformBusFdtParams.system_params becomes a pointer to
  a const ARMPlatformBusSystemParams
- removes platform-bus.h second inclusion

v3 -> v4:
- dyn_sysbus_devtree.c renamed into sysbus-fdt.c
- use new PlatformBusDevice object
- the dtb upgrade is done through modify_dtb. Before the fdt
  was recreated from scratch. When the user provided a dtb this
  latter was overwritten which was not correct.
- an array contains the association between device type names
  and their node creation function
- I must aknowledge I did not find any cleaner way to implement
  a FDT_BUILDER interface, as suggested by Paolo. The class method
  would need to be initialized somewhere and since it cannot
  happen in the device itself - according to Alex & Peter comments -,
  I don't see when I shall associate the device type and its
  interface implementation.

v2 -> v3:
- add arm_ prefix
- arm_sysbus_device_create_devtree becomes static

v1 -> v2:
- Code moved in an arch specific file to accomodate architecture
  dependent specificities.
- remove platform_bus_base from PlatformDevtreeData

v1: code originally written by Alex Graf in e500.c and reused for
ARM [Eric Auger]
---
 hw/arm/Makefile.objs        |   1 +
 hw/arm/sysbus-fdt.c         | 174 ++++++++++++++++++++++++++++++++++++++++++++
 include/hw/arm/sysbus-fdt.h |  60 +++++++++++++++
 3 files changed, 235 insertions(+)
 create mode 100644 hw/arm/sysbus-fdt.c
 create mode 100644 include/hw/arm/sysbus-fdt.h

diff --git a/hw/arm/Makefile.objs b/hw/arm/Makefile.objs
index 6088e53..0cc63e1 100644
--- a/hw/arm/Makefile.objs
+++ b/hw/arm/Makefile.objs
@@ -3,6 +3,7 @@ obj-$(CONFIG_DIGIC) += digic_boards.o
 obj-y += integratorcp.o kzm.o mainstone.o musicpal.o nseries.o
 obj-y += omap_sx1.o palm.o realview.o spitz.o stellaris.o
 obj-y += tosa.o versatilepb.o vexpress.o virt.o xilinx_zynq.o z2.o
+obj-y += sysbus-fdt.o
 
 obj-y += armv7m.o exynos4210.o pxa2xx.o pxa2xx_gpio.o pxa2xx_pic.o
 obj-$(CONFIG_DIGIC) += digic.o
diff --git a/hw/arm/sysbus-fdt.c b/hw/arm/sysbus-fdt.c
new file mode 100644
index 0000000..3038b94
--- /dev/null
+++ b/hw/arm/sysbus-fdt.c
@@ -0,0 +1,174 @@
+/*
+ * ARM Platform Bus device tree generation helpers
+ *
+ * Copyright (c) 2014 Linaro Limited
+ *
+ * Authors:
+ *  Alex Graf <agraf@suse.de>
+ *  Eric Auger <eric.auger@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include "hw/arm/sysbus-fdt.h"
+#include "qemu/error-report.h"
+#include "sysemu/device_tree.h"
+#include "hw/platform-bus.h"
+#include "sysemu/sysemu.h"
+
+/*
+ * internal struct that contains the information to create dynamic
+ * sysbus device node
+ */
+typedef struct PlatformBusFDTData {
+    void *fdt; /* device tree handle */
+    int irq_start; /* index of the first IRQ usable by platform bus devices */
+    const char *pbus_node_name; /* name of the platform bus node */
+    PlatformBusDevice *pbus;
+} PlatformBusFDTData;
+
+/*
+ * struct used when calling the machine init done notifier
+ * that constructs the fdt nodes of platform bus devices
+ */
+typedef struct PlatformBusFDTNotifierParams {
+    Notifier notifier;
+    ARMPlatformBusFDTParams *fdt_params;
+} PlatformBusFDTNotifierParams;
+
+/* struct that associates a device type name and a node creation function */
+typedef struct NodeCreationPair {
+    const char *typename;
+    int (*add_fdt_node_fn)(SysBusDevice *sbdev, void *opaque);
+} NodeCreationPair;
+
+/* list of supported dynamic sysbus devices */
+static const NodeCreationPair add_fdt_node_functions[] = {
+    {"", NULL}, /* last element */
+};
+
+/**
+ * add_fdt_node - add the device tree node of a dynamic sysbus device
+ *
+ * @sbdev: handle to the sysbus device
+ * @opaque: handle to the PlatformBusFDTData
+ *
+ * Checks the sysbus type belongs to the list of device types that
+ * are dynamically instantiable and if so call the node creation
+ * function.
+ */
+static int add_fdt_node(SysBusDevice *sbdev, void *opaque)
+{
+    int i, ret;
+
+    for (i = 0; i < ARRAY_SIZE(add_fdt_node_functions); i++) {
+        if (!strcmp(object_get_typename(OBJECT(sbdev)),
+                    add_fdt_node_functions[i].typename)) {
+            ret = add_fdt_node_functions[i].add_fdt_node_fn(sbdev, opaque);
+            assert(!ret);
+            return 0;
+        }
+    }
+    error_report("Device %s can not be dynamically instantiated",
+                     qdev_fw_name(DEVICE(sbdev)));
+    exit(1);
+}
+
+/**
+ * add_all_platform_bus_fdt_nodes - create all the platform bus nodes
+ *
+ * builds the parent platform bus node and all the nodes of dynamic
+ * sysbus devices attached to it.
+ */
+static void add_all_platform_bus_fdt_nodes(ARMPlatformBusFDTParams *fdt_params)
+{
+    const char platcomp[] = "qemu,platform\0simple-bus";
+    PlatformBusDevice *pbus;
+    DeviceState *dev;
+    gchar *node;
+    uint64_t addr, size;
+    int irq_start, dtb_size;
+    struct arm_boot_info *info = fdt_params->binfo;
+    const ARMPlatformBusSystemParams *params = fdt_params->system_params;
+    const char *intc = fdt_params->intc;
+    void *fdt = info->get_dtb(info, &dtb_size);
+
+    /*
+     * If the user provided a dtb, we assume the dynamic sysbus nodes
+     * already are integrated there. This corresponds to a use case where
+     * the dynamic sysbus nodes are complex and their generation is not yet
+     * supported. In that case the user can take charge of the guest dt
+     * while qemu takes charge of the qom stuff.
+     */
+    if (info->dtb_filename) {
+        return;
+    }
+
+    assert(fdt);
+
+    node = g_strdup_printf("/platform@%"PRIx64, params->platform_bus_base);
+    addr = params->platform_bus_base;
+    size = params->platform_bus_size;
+    irq_start = params->platform_bus_first_irq;
+
+    /* Create a /platform node that we can put all devices into */
+    qemu_fdt_add_subnode(fdt, node);
+    qemu_fdt_setprop(fdt, node, "compatible", platcomp, sizeof(platcomp));
+
+    /* Our platform bus region is less than 32bits, so 1 cell is enough for
+     * address and size
+     */
+    qemu_fdt_setprop_cells(fdt, node, "#size-cells", 1);
+    qemu_fdt_setprop_cells(fdt, node, "#address-cells", 1);
+    qemu_fdt_setprop_cells(fdt, node, "ranges", 0, addr >> 32, addr, size);
+
+    qemu_fdt_setprop_phandle(fdt, node, "interrupt-parent", intc);
+
+    dev = qdev_find_recursive(sysbus_get_default(), TYPE_PLATFORM_BUS_DEVICE);
+    pbus = PLATFORM_BUS_DEVICE(dev);
+
+    /* We can only create dt nodes for dynamic devices when they're ready */
+    assert(pbus->done_gathering);
+
+    PlatformBusFDTData data = {
+        .fdt = fdt,
+        .irq_start = irq_start,
+        .pbus_node_name = node,
+        .pbus = pbus,
+    };
+
+    /* Loop through all dynamic sysbus devices and create their node */
+    foreach_dynamic_sysbus_device(add_fdt_node, &data);
+
+    g_free(node);
+}
+
+static void platform_bus_fdt_notify(Notifier *notifier, void *data)
+{
+    PlatformBusFDTNotifierParams *p = DO_UPCAST(PlatformBusFDTNotifierParams,
+                                                notifier, notifier);
+
+    add_all_platform_bus_fdt_nodes(p->fdt_params);
+    g_free(p->fdt_params);
+    g_free(p);
+}
+
+void arm_register_platform_bus_fdt_creator(ARMPlatformBusFDTParams *fdt_params)
+{
+    PlatformBusFDTNotifierParams *p = g_new(PlatformBusFDTNotifierParams, 1);
+
+    p->fdt_params = fdt_params;
+    p->notifier.notify = platform_bus_fdt_notify;
+    qemu_add_machine_init_done_notifier(&p->notifier);
+}
diff --git a/include/hw/arm/sysbus-fdt.h b/include/hw/arm/sysbus-fdt.h
new file mode 100644
index 0000000..e15bb81
--- /dev/null
+++ b/include/hw/arm/sysbus-fdt.h
@@ -0,0 +1,60 @@
+/*
+ * Dynamic sysbus device tree node generation API
+ *
+ * Copyright Linaro Limited, 2014
+ *
+ * Authors:
+ *  Alex Graf <agraf@suse.de>
+ *  Eric Auger <eric.auger@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#ifndef HW_ARM_SYSBUS_FDT_H
+#define HW_ARM_SYSBUS_FDT_H
+
+#include "hw/arm/arm.h"
+#include "qemu-common.h"
+#include "hw/sysbus.h"
+
+/*
+ * struct that contains dimensioning parameters of the platform bus
+ */
+typedef struct {
+    hwaddr platform_bus_base; /* start address of the bus */
+    hwaddr platform_bus_size; /* size of the bus */
+    int platform_bus_first_irq; /* first hwirq assigned to the bus */
+    int platform_bus_num_irqs; /* number of hwirq assigned to the bus */
+} ARMPlatformBusSystemParams;
+
+/*
+ * struct that contains all relevant info to build the fdt nodes of
+ * platform bus and attached dynamic sysbus devices
+ * in the future might be augmented with additional info
+ * such as PHY, CLK handles ...
+ */
+typedef struct {
+    const ARMPlatformBusSystemParams *system_params;
+    struct arm_boot_info *binfo;
+    const char *intc; /* parent interrupt controller name */
+} ARMPlatformBusFDTParams;
+
+/**
+ * arm_register_platform_bus_fdt_creator - register a machine init done
+ * notifier that creates the device tree nodes of the platform bus and
+ * associated dynamic sysbus devices
+ */
+void arm_register_platform_bus_fdt_creator(ARMPlatformBusFDTParams *fdt_params);
+
+#endif
-- 
1.8.3.2
