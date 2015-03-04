From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v11 2/4] hw/arm/boot: arm_load_kernel implemented as a machine
 init done notifier
Date: Wed,  4 Mar 2015 16:18:27 +0000
Message-ID: <1425485909-5091-3-git-send-email-eric.auger@linaro.org>
References: <1425485909-5091-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0633647B7B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 11:12:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x9T4PCOTFdoj for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 11:12:42 -0500 (EST)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F5F847B5D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 11:12:41 -0500 (EST)
Received: by wggx12 with SMTP id x12so47750013wgg.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 08:18:44 -0800 (PST)
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

Device tree nodes for the platform bus and its children dynamic sysbus
devices are added in a machine init done notifier. To load the dtb once,
after those latter nodes are built and before ROM freeze, the actual
arm_load_kernel existing code is moved into a notifier notify function,
arm_load_kernel_notify. arm_load_kernel now only registers the
corresponding notifier.

Machine files that do not support platform bus stay unchanged. Machine
files willing to support dynamic sysbus devices must call arm_load_kernel
before sysbus-fdt arm_register_platform_bus_fdt_creator to make sure
dynamic sysbus device nodes are integrated in the dtb.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Shannon Zhao <zhaoshenglong@huawei.com>
Reviewed-by: Alexander Graf <agraf@suse.de>

---

v8 -> v9:
- fix compilation with arm-linux-user
- reorder fields in ArmLoadKernelNotifier and use DO_UPCAST

v7 -> v8:
- Add Reviewed-by from Alex & Shannon
- rebase on 2.2.0

v6: creation of this patch file
---
 hw/arm/boot.c        | 14 +++++++++++++-
 include/hw/arm/arm.h | 28 ++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/hw/arm/boot.c b/hw/arm/boot.c
index a48d1b2..5ac5479 100644
--- a/hw/arm/boot.c
+++ b/hw/arm/boot.c
@@ -555,7 +555,7 @@ static void load_image_to_fw_cfg(FWCfgState *fw_cfg, uint16_t size_key,
     fw_cfg_add_bytes(fw_cfg, data_key, data, size);
 }
 
-void arm_load_kernel(ARMCPU *cpu, struct arm_boot_info *info)
+static void arm_load_kernel_notify(Notifier *notifier, void *data)
 {
     CPUState *cs;
     int kernel_size;
@@ -566,6 +566,11 @@ void arm_load_kernel(ARMCPU *cpu, struct arm_boot_info *info)
     hwaddr entry, kernel_load_offset;
     int big_endian;
     static const ARMInsnFixup *primary_loader;
+    ArmLoadKernelNotifier *n = DO_UPCAST(ArmLoadKernelNotifier,
+                                         notifier, notifier);
+    ARMCPU *cpu = n->cpu;
+    struct arm_boot_info *info =
+        container_of(n, struct arm_boot_info, load_kernel_notifier);
 
     /* CPU objects (unlike devices) are not automatically reset on system
      * reset, so we must always register a handler to do so. If we're
@@ -773,3 +778,10 @@ void arm_load_kernel(ARMCPU *cpu, struct arm_boot_info *info)
         ARM_CPU(cs)->env.boot_info = info;
     }
 }
+
+void arm_load_kernel(ARMCPU *cpu, struct arm_boot_info *info)
+{
+    info->load_kernel_notifier.cpu = cpu;
+    info->load_kernel_notifier.notifier.notify = arm_load_kernel_notify;
+    qemu_add_machine_init_done_notifier(&info->load_kernel_notifier.notifier);
+}
diff --git a/include/hw/arm/arm.h b/include/hw/arm/arm.h
index 5c940eb..760804c 100644
--- a/include/hw/arm/arm.h
+++ b/include/hw/arm/arm.h
@@ -13,11 +13,21 @@
 
 #include "exec/memory.h"
 #include "hw/irq.h"
+#include "qemu/notify.h"
 
 /* armv7m.c */
 qemu_irq *armv7m_init(MemoryRegion *system_memory, int mem_size, int num_irq,
                       const char *kernel_filename, const char *cpu_model);
 
+/*
+ * struct used as a parameter of the arm_load_kernel machine init
+ * done notifier
+ */
+typedef struct {
+    Notifier notifier; /* actual notifier */
+    ARMCPU *cpu; /* handle to the first cpu object */
+} ArmLoadKernelNotifier;
+
 /* arm_boot.c */
 struct arm_boot_info {
     uint64_t ram_size;
@@ -64,6 +74,8 @@ struct arm_boot_info {
      * the user it should implement this hook.
      */
     void (*modify_dtb)(const struct arm_boot_info *info, void *fdt);
+    /* machine init done notifier executing arm_load_dtb */
+    ArmLoadKernelNotifier load_kernel_notifier;
     /* Used internally by arm_boot.c */
     int is_linux;
     hwaddr initrd_start;
@@ -75,6 +87,22 @@ struct arm_boot_info {
      */
     bool firmware_loaded;
 };
+
+/**
+ * arm_load_kernel - Loads memory with everything needed to boot
+ *
+ * @cpu: handle to the first CPU object
+ * @info: handle to the boot info struct
+ * Registers a machine init done notifier that copies to memory
+ * everything needed to boot, depending on machine and user options:
+ * kernel image, boot loaders, initrd, dtb. Also registers the CPU
+ * reset handler.
+ *
+ * In case the machine file supports the platform bus device and its
+ * dynamically instantiable sysbus devices, this function must be called
+ * before sysbus-fdt arm_register_platform_bus_fdt_creator. Indeed the
+ * machine init done notifiers are called in registration reverse order.
+ */
 void arm_load_kernel(ARMCPU *cpu, struct arm_boot_info *info);
 
 /* Multiplication factor to convert from system clock ticks to qemu timer
-- 
1.8.3.2
