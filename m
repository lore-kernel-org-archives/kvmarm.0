From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 1/4] target-arm: Add GIC phandle to VirtBoardInfo
Date: Fri, 29 May 2015 13:01:07 +0200
Message-ID: <1432897270-7780-2-git-send-email-christoffer.dall@linaro.org>
References: <1432897270-7780-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 985F6524AF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 06:51:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EhRgZd0Acbdg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2015 06:50:58 -0400 (EDT)
Received: from mail-la0-f50.google.com (mail-la0-f50.google.com
 [209.85.215.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D80D95236A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 06:50:57 -0400 (EDT)
Received: by lagv1 with SMTP id v1so52814938lag.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 04:00:43 -0700 (PDT)
In-Reply-To: <1432897270-7780-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Instead of passing the GIC phandle around between functions, add it to
the VirtBoardInfo just like we do for the clock_phandle.  We are about
to add the v2m phandle as well, and it's easier not having to pass
around a bunch of phandles, return multiple values from functions, etc.

Reviewed-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changes since v3:
 - Added reviewed-by tag
Changes since v2:
 - None
Changes since v1:
 - Added reviewed-by tag

 hw/arm/virt.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 05db8cb..e5235ef 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -69,6 +69,7 @@ typedef struct VirtBoardInfo {
     void *fdt;
     int fdt_size;
     uint32_t clock_phandle;
+    uint32_t gic_phandle;
 } VirtBoardInfo;
 
 typedef struct {
@@ -299,12 +300,11 @@ static void fdt_add_cpu_nodes(const VirtBoardInfo *vbi)
     }
 }
 
-static uint32_t fdt_add_gic_node(const VirtBoardInfo *vbi)
+static void fdt_add_gic_node(VirtBoardInfo *vbi)
 {
-    uint32_t gic_phandle;
 
-    gic_phandle = qemu_fdt_alloc_phandle(vbi->fdt);
-    qemu_fdt_setprop_cell(vbi->fdt, "/", "interrupt-parent", gic_phandle);
+    vbi->gic_phandle = qemu_fdt_alloc_phandle(vbi->fdt);
+    qemu_fdt_setprop_cell(vbi->fdt, "/", "interrupt-parent", vbi->gic_phandle);
 
     qemu_fdt_add_subnode(vbi->fdt, "/intc");
     /* 'cortex-a15-gic' means 'GIC v2' */
@@ -317,12 +317,10 @@ static uint32_t fdt_add_gic_node(const VirtBoardInfo *vbi)
                                      2, vbi->memmap[VIRT_GIC_DIST].size,
                                      2, vbi->memmap[VIRT_GIC_CPU].base,
                                      2, vbi->memmap[VIRT_GIC_CPU].size);
-    qemu_fdt_setprop_cell(vbi->fdt, "/intc", "phandle", gic_phandle);
-
-    return gic_phandle;
+    qemu_fdt_setprop_cell(vbi->fdt, "/intc", "phandle", vbi->gic_phandle);
 }
 
-static uint32_t create_gic(const VirtBoardInfo *vbi, qemu_irq *pic)
+static void create_gic(VirtBoardInfo *vbi, qemu_irq *pic)
 {
     /* We create a standalone GIC v2 */
     DeviceState *gicdev;
@@ -371,7 +369,7 @@ static uint32_t create_gic(const VirtBoardInfo *vbi, qemu_irq *pic)
         pic[i] = qdev_get_gpio_in(gicdev, i);
     }
 
-    return fdt_add_gic_node(vbi);
+    fdt_add_gic_node(vbi);
 }
 
 static void create_uart(const VirtBoardInfo *vbi, qemu_irq *pic)
@@ -618,8 +616,7 @@ static void create_pcie_irq_map(const VirtBoardInfo *vbi, uint32_t gic_phandle,
                            0x7           /* PCI irq */);
 }
 
-static void create_pcie(const VirtBoardInfo *vbi, qemu_irq *pic,
-                        uint32_t gic_phandle)
+static void create_pcie(const VirtBoardInfo *vbi, qemu_irq *pic)
 {
     hwaddr base_mmio = vbi->memmap[VIRT_PCIE_MMIO].base;
     hwaddr size_mmio = vbi->memmap[VIRT_PCIE_MMIO].size;
@@ -685,7 +682,7 @@ static void create_pcie(const VirtBoardInfo *vbi, qemu_irq *pic,
                                  2, base_mmio, 2, size_mmio);
 
     qemu_fdt_setprop_cell(vbi->fdt, nodename, "#interrupt-cells", 1);
-    create_pcie_irq_map(vbi, gic_phandle, irq, nodename);
+    create_pcie_irq_map(vbi, vbi->gic_phandle, irq, nodename);
 
     g_free(nodename);
 }
@@ -717,7 +714,6 @@ static void machvirt_init(MachineState *machine)
     VirtBoardInfo *vbi;
     VirtGuestInfoState *guest_info_state = g_malloc0(sizeof *guest_info_state);
     VirtGuestInfo *guest_info = &guest_info_state->info;
-    uint32_t gic_phandle;
     char **cpustr;
 
     if (!cpu_model) {
@@ -794,13 +790,13 @@ static void machvirt_init(MachineState *machine)
 
     create_flash(vbi);
 
-    gic_phandle = create_gic(vbi, pic);
+    create_gic(vbi, pic);
 
     create_uart(vbi, pic);
 
     create_rtc(vbi, pic);
 
-    create_pcie(vbi, pic, gic_phandle);
+    create_pcie(vbi, pic);
 
     /* Create mmio transports, so the user can create virtio backends
      * (which will be automatically plugged in to the transports). If
-- 
2.1.2.330.g565301e.dirty
