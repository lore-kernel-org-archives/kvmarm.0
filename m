From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v11 3/4] hw/arm/virt: add dynamic sysbus device support
Date: Wed,  4 Mar 2015 16:18:28 +0000
Message-ID: <1425485909-5091-4-git-send-email-eric.auger@linaro.org>
References: <1425485909-5091-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA16F47B67
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 11:12:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3ZwRBgqcTeZK for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 11:12:43 -0500 (EST)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
 [209.85.212.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 332C947B47
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 11:12:42 -0500 (EST)
Received: by widem10 with SMTP id em10so32084618wid.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 08:18:45 -0800 (PST)
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

Allows sysbus devices to be instantiated from command line by
using -device option. Machvirt creates a platform bus at init.
The dynamic sysbus devices are attached to this platform bus device.

The platform bus device registers a machine init done notifier
whose role will be to bind the dynamic sysbus devices. Indeed
dynamic sysbus devices are created after machine init.

machvirt also registers a notifier that will build the device
tree nodes for the platform bus and its children dynamic sysbus
devices.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v8 -> v9:
- PLATFORM_BUS_NUM_IRQS set to 32 instead of 20
- platform bus irq now start at 64 instead of 48
- remove change of indentation in a15memmap
- correct misc style issues

v7 -> v8:
- rebase on 2.2.0
- in machvirt_init, create_platform_bus simply is added
  after the arm_load_kernel call instead of moving this latter.
  Related comment slighly reworded.
- Due to those changes I dropped Alex and Shannon's Reviewed-by

v6 -> v7:
Take into account Shannon comments:
- remove PLATFORM_BUS_FIRST_IRQ macro
- correct platform bus size to 0x400000
- add an additional comment in a15irqmap related to
  PLATFORM_BUS_NUM_IRQS

v5 -> v6:
- Take into account Peter's comments:
  - platform_bus_params initialized from vbi->memmap and vbi->irqmap.
    As a consequence, const is removed. Also alignment in a15memmap
    is slightly changed.
  - ARMPlatformBusSystemParams handle removed from create_platform_bus
    prototype
- arm_load_kernel has become a machine init done notifier registration.
  It must be called before platform_bus_create to guarantee the correct
  notifier execution sequence

v4 -> v5:
- platform_bus_params becomes static const
- reword comment in create_platform_bus
- reword the commit message

v3 -> v4:
- use platform bus object, instantiated in create_platform_bus
- device tree generation for platform bus and children dynamic
  sysbus devices is no more handled at reset but in a
  machine_init_done_notifier (due to the change in implementaion
  of ARM load dtb using rom_add_blob_fixed).
- device tree enhancement now takes into account the case of
  user provided dtb. Before the user dtb was overwritten which
  was wrong. However in case the dtb is provided by the user,
  dynamic sysbus nodes are not added there.
- renaming of MACHVIRT_PLATFORM defines
- MACHVIRT_PLATFORM_PAGE_SHIFT and SIZE_PAGES not needed anymore,
  hence removed.
- DynSysbusParams struct renamed into ARMPlatformBusSystemParams
  and above params removed.
- separation of dt creation and QEMU binding is not mandated anymore
  since the device tree is not created from scratch anymore. Instead
  the modify_dtb function is used.
- create_platform_bus registers another machine init done notifier
  to start VFIO IRQ handling. This latter executes after the
  dynamic sysbus device binding.

v2 -> v3:
- renaming of arm_platform_bus_create_devtree and arm_load_dtb
- add copyright in hw/arm/dyn_sysbus_devtree.c

v1 -> v2:
- remove useless vfio-platform.h include file
- s/MACHVIRT_PLATFORM_HOLE/MACHVIRT_PLATFORM_SIZE
- use dyn_sysbus_binding and dyn_sysbus_devtree
- dynamic sysbus platform buse size shrinked to 4MB and
  moved between RTC and MMIO

v1:

Inspired from what Alex Graf did in ppc e500
https://lists.gnu.org/archive/html/qemu-ppc/2014-07/msg00012.html

Conflicts:
	hw/arm/sysbus-fdt.c

Conflicts:
	hw/arm/virt.c

Conflicts:
	hw/arm/virt.c
---
 hw/arm/virt.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 69f51ac..c3f4c54 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -43,6 +43,8 @@
 #include "qemu/bitops.h"
 #include "qemu/error-report.h"
 #include "hw/pci-host/gpex.h"
+#include "hw/arm/sysbus-fdt.h"
+#include "hw/platform-bus.h"
 
 #define NUM_VIRTIO_TRANSPORTS 32
 
@@ -60,6 +62,8 @@
 #define GIC_FDT_IRQ_PPI_CPU_START 8
 #define GIC_FDT_IRQ_PPI_CPU_WIDTH 8
 
+#define PLATFORM_BUS_NUM_IRQS 32
+
 enum {
     VIRT_FLASH,
     VIRT_MEM,
@@ -71,8 +75,11 @@ enum {
     VIRT_RTC,
     VIRT_FW_CFG,
     VIRT_PCIE,
+    VIRT_PLATFORM_BUS,
 };
 
+static ARMPlatformBusSystemParams platform_bus_params;
+
 typedef struct MemMapEntry {
     hwaddr base;
     hwaddr size;
@@ -129,6 +136,7 @@ static const MemMapEntry a15memmap[] = {
     [VIRT_UART] =       { 0x09000000, 0x00001000 },
     [VIRT_RTC] =        { 0x09010000, 0x00001000 },
     [VIRT_FW_CFG] =     { 0x09020000, 0x0000000a },
+    [VIRT_PLATFORM_BUS] =   { 0x09400000, 0x00400000 },
     [VIRT_MMIO] =       { 0x0a000000, 0x00000200 },
     /* ...repeating for a total of NUM_VIRTIO_TRANSPORTS, each of that size */
     /*
@@ -147,6 +155,7 @@ static const int a15irqmap[] = {
     [VIRT_RTC] = 2,
     [VIRT_PCIE] = 3, /* ... to 6 */
     [VIRT_MMIO] = 16, /* ...to 16 + NUM_VIRTIO_TRANSPORTS - 1 */
+    [VIRT_PLATFORM_BUS] = 64, /* ... to 64 + PLATFORM_BUS_NUM_IRQS -1 */
 };
 
 static VirtBoardInfo machines[] = {
@@ -710,6 +719,47 @@ static void create_pcie(const VirtBoardInfo *vbi, qemu_irq *pic,
     g_free(nodename);
 }
 
+static void create_platform_bus(VirtBoardInfo *vbi, qemu_irq *pic)
+{
+    DeviceState *dev;
+    SysBusDevice *s;
+    int i;
+    ARMPlatformBusFDTParams *fdt_params = g_new(ARMPlatformBusFDTParams, 1);
+    MemoryRegion *sysmem = get_system_memory();
+
+    platform_bus_params.platform_bus_base = vbi->memmap[VIRT_PLATFORM_BUS].base;
+    platform_bus_params.platform_bus_size = vbi->memmap[VIRT_PLATFORM_BUS].size;
+    platform_bus_params.platform_bus_first_irq = vbi->irqmap[VIRT_PLATFORM_BUS];
+    platform_bus_params.platform_bus_num_irqs = PLATFORM_BUS_NUM_IRQS;
+
+    fdt_params->system_params = &platform_bus_params;
+    fdt_params->binfo = &vbi->bootinfo;
+    fdt_params->intc = "/intc";
+    /*
+     * register a machine init done notifier that creates the device tree
+     * nodes of the platform bus and its children dynamic sysbus devices
+     */
+    arm_register_platform_bus_fdt_creator(fdt_params);
+
+    dev = qdev_create(NULL, TYPE_PLATFORM_BUS_DEVICE);
+    dev->id = TYPE_PLATFORM_BUS_DEVICE;
+    qdev_prop_set_uint32(dev, "num_irqs",
+        platform_bus_params.platform_bus_num_irqs);
+    qdev_prop_set_uint32(dev, "mmio_size",
+        platform_bus_params.platform_bus_size);
+    qdev_init_nofail(dev);
+    s = SYS_BUS_DEVICE(dev);
+
+    for (i = 0; i < platform_bus_params.platform_bus_num_irqs; i++) {
+        int irqn = platform_bus_params.platform_bus_first_irq + i;
+        sysbus_connect_irq(s, i, pic[irqn]);
+    }
+
+    memory_region_add_subregion(sysmem,
+                                platform_bus_params.platform_bus_base,
+                                sysbus_mmio_get_region(s, 0));
+}
+
 static void *machvirt_dtb(const struct arm_boot_info *binfo, int *fdt_size)
 {
     const VirtBoardInfo *board = (const VirtBoardInfo *)binfo;
@@ -829,6 +879,14 @@ static void machvirt_init(MachineState *machine)
     vbi->bootinfo.get_dtb = machvirt_dtb;
     vbi->bootinfo.firmware_loaded = bios_name || drive_get(IF_PFLASH, 0, 0);
     arm_load_kernel(ARM_CPU(first_cpu), &vbi->bootinfo);
+
+    /*
+     * arm_load_kernel machine init done notifier registration must
+     * happen before the platform_bus_create call. In this latter,
+     * another notifier is registered which adds platform bus nodes.
+     * Notifiers are executed in registration reverse order.
+     */
+    create_platform_bus(vbi, pic);
 }
 
 static bool virt_get_secure(Object *obj, Error **errp)
@@ -867,6 +925,7 @@ static void virt_class_init(ObjectClass *oc, void *data)
     mc->desc = "ARM Virtual Machine",
     mc->init = machvirt_init;
     mc->max_cpus = 8;
+    mc->has_dynamic_sysbus = true;
 }
 
 static const TypeInfo machvirt_info = {
-- 
1.8.3.2
