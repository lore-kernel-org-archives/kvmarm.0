From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v11 7/9] hw/arm/sysbus-fdt: enable vfio-calxeda-xgmac dynamic
 instantiation
Date: Thu, 19 Mar 2015 10:05:36 +0000
Message-ID: <1426759538-18030-8-git-send-email-eric.auger@linaro.org>
References: <1426759538-18030-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2FF491FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 05:59:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X06mD4oy-Ox7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2015 05:59:16 -0400 (EDT)
Received: from mail-wg0-f46.google.com (mail-wg0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96F6C49216
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 05:59:12 -0400 (EDT)
Received: by wgra20 with SMTP id a20so57786118wgr.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 03:05:53 -0700 (PDT)
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

This patch allows the instantiation of the vfio-calxeda-xgmac device
from the QEMU command line (-device vfio-calxeda-xgmac,host="<device>").

A specialized device tree node is created for the guest, containing
compat, dma-coherent, reg and interrupts properties.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v10 -> v11:
- add dma-coherent property to calxeda midway xgmac node (fix)
- use qemu_fdt_setprop to add reg property instead of
  qemu_fdt_setprop_sized_cells_from_array
- commit message rewording

v8 -> v9:
- properly free resources in case of errors in
  add_calxeda_midway_xgmac_fdt_node

v7 -> v8:
- move the add_fdt_node_functions array declaration between the device
  specific code and the generic code to avoid forward declarations of
  decice specific functions
- rename add_basic_vfio_fdt_node into
  add_calxeda_midway_xgmac_fdt_node

v6 -> v7:
- compat string re-formatting removed since compat string is not exposed
  anymore as a user option
- VFIO IRQ kick-off removed from sysbus-fdt and moved to VFIO platform
  device
---
 hw/arm/sysbus-fdt.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/hw/arm/sysbus-fdt.c b/hw/arm/sysbus-fdt.c
index 3038b94..6e465b2 100644
--- a/hw/arm/sysbus-fdt.c
+++ b/hw/arm/sysbus-fdt.c
@@ -26,6 +26,8 @@
 #include "sysemu/device_tree.h"
 #include "hw/platform-bus.h"
 #include "sysemu/sysemu.h"
+#include "hw/vfio/vfio-platform.h"
+#include "hw/vfio/vfio-calxeda-xgmac.h"
 
 /*
  * internal struct that contains the information to create dynamic
@@ -53,11 +55,81 @@ typedef struct NodeCreationPair {
     int (*add_fdt_node_fn)(SysBusDevice *sbdev, void *opaque);
 } NodeCreationPair;
 
+/* Device Specific Code */
+
+/**
+ * add_calxeda_midway_xgmac_fdt_node
+ *
+ * Generates a simple node with following properties:
+ * compatible string, regs, interrupts, dma-coherent
+ */
+static int add_calxeda_midway_xgmac_fdt_node(SysBusDevice *sbdev, void *opaque)
+{
+    PlatformBusFDTData *data = opaque;
+    PlatformBusDevice *pbus = data->pbus;
+    void *fdt = data->fdt;
+    const char *parent_node = data->pbus_node_name;
+    int compat_str_len, i, ret = -1;
+    char *nodename;
+    uint32_t *irq_attr, *reg_attr;
+    uint64_t mmio_base, irq_number;
+    VFIOPlatformDevice *vdev = VFIO_PLATFORM_DEVICE(sbdev);
+    VFIODevice *vbasedev = &vdev->vbasedev;
+    Object *obj = OBJECT(sbdev);
+
+    mmio_base = object_property_get_int(obj, "mmio[0]", NULL);
+    nodename = g_strdup_printf("%s/%s@%" PRIx64, parent_node,
+                               vbasedev->name, mmio_base);
+    qemu_fdt_add_subnode(fdt, nodename);
+
+    compat_str_len = strlen(vdev->compat) + 1;
+    qemu_fdt_setprop(fdt, nodename, "compatible",
+                          vdev->compat, compat_str_len);
+
+    qemu_fdt_setprop(fdt, nodename, "dma-coherent", "", 0);
+
+    reg_attr = g_new(uint32_t, vbasedev->num_regions*2);
+    for (i = 0; i < vbasedev->num_regions; i++) {
+        mmio_base = platform_bus_get_mmio_addr(pbus, sbdev, i);
+        reg_attr[2*i] = (uint32_t)mmio_base;
+        reg_attr[2*i+1] = (uint32_t)memory_region_size(&vdev->regions[i]->mem);
+    }
+    ret = qemu_fdt_setprop(fdt, nodename, "reg", reg_attr,
+                           vbasedev->num_regions*2*sizeof(uint32_t));
+    if (ret) {
+        error_report("could not set reg property of node %s", nodename);
+        goto fail_reg;
+    }
+
+    irq_attr = g_new(uint32_t, vbasedev->num_irqs*3);
+    for (i = 0; i < vbasedev->num_irqs; i++) {
+        irq_number = platform_bus_get_irqn(pbus, sbdev , i)
+                         + data->irq_start;
+        irq_attr[3*i] = cpu_to_be32(0);
+        irq_attr[3*i+1] = cpu_to_be32(irq_number);
+        irq_attr[3*i+2] = cpu_to_be32(0x4);
+    }
+   ret = qemu_fdt_setprop(fdt, nodename, "interrupts",
+                     irq_attr, vbasedev->num_irqs*3*sizeof(uint32_t));
+    if (ret) {
+        error_report("could not set interrupts property of node %s",
+                     nodename);
+    }
+    g_free(irq_attr);
+fail_reg:
+    g_free(reg_attr);
+    g_free(nodename);
+    return ret;
+}
+
 /* list of supported dynamic sysbus devices */
 static const NodeCreationPair add_fdt_node_functions[] = {
+    {TYPE_VFIO_CALXEDA_XGMAC, add_calxeda_midway_xgmac_fdt_node},
     {"", NULL}, /* last element */
 };
 
+/* Generic Code */
+
 /**
  * add_fdt_node - add the device tree node of a dynamic sysbus device
  *
-- 
1.8.3.2
