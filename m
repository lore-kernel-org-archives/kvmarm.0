From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v11 2/9] hw/vfio/platform: vfio-platform skeleton
Date: Thu, 19 Mar 2015 10:05:31 +0000
Message-ID: <1426759538-18030-3-git-send-email-eric.auger@linaro.org>
References: <1426759538-18030-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6E51491F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 05:59:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mdj1ABORcidj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2015 05:59:08 -0400 (EDT)
Received: from mail-wg0-f41.google.com (mail-wg0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31A58491F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 05:59:07 -0400 (EDT)
Received: by wgra20 with SMTP id a20so57784404wgr.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 03:05:49 -0700 (PDT)
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

Minimal VFIO platform implementation supporting register space
user mapping but not IRQ assignment.

Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v10 -> v11:
x Take into account Alex Bennee's comments:
- use g_malloc0_n instead of g_malloc0
- use block declarations when possible
- rework readlink returned value treatment
- use g_strlcat in place of strncat
x use g_snprintf in place of snprintf
x correct error handling in vfio_populate_device,
  in case of flag not corresponding to platform device
x various cosmetic changes

v9 -> v10:
- vfio_populate_device no more called in common vfio_get_device
  but in vfio_base_device_init

v8 -> v9:
- irq management is moved into a separate patch to ease the review
- VFIO_DEVICE_FLAGS_PLATFORM is checked in vfio_populate_device
- g_free of regions added in vfio_populate_device error label
- virtualID becomes 32b

v7 -> v8:
- change proto of vfio_platform_compute_needs_reset and sets
  vbasedev->needs_reset to false there
- vfio_[un]mask_irqindex renamed into vfio_[un]mask_single_irqindex
- vfio_register_irq_starter renamed into vfio_kick_irqs
  we now use a reset notifier instead of a machine init done notifier.
  Enables to get rid of the VfioIrqStarterNotifierParams dangling
  pointer. Previously we use pbus first_irq. This is no more possible
  since the reset notifier takes a void * and first_irq is a field of
  a const struct. So now we pass the DeviceState handle of the
  interrupt controller. I tried to keep the code generic, reason why
  I did not rely on an architecture specific accessor to retrieve
  the gsi number (gic accessor as proposed by Alex). I would like to
  avoid creating an ARM VFIO device model. I hope this model
  model can work on other archs than arm (no multiple intc?);
  wouldn't it be simpler to keep the previous first_irq parameter and
  relax the const constraint.

v6 -> v7:
- compat is not exposed anymore as a user option. Rationale is
  the vfio device became abstract and a specialization is needed
  anyway. The derived device must set the compat string.
- in v6 vfio_start_irq_injection was exposed in vfio-platform.h.
  A new function dubbed vfio_register_irq_starter replaces it. It
  registers a machine init done notifier that programs & starts
  all dynamic VFIO device IRQs. This function is supposed to be
  called by the machine file. A set of static helper routines are
  added too. It must be called before the creation of the platform
  bus device.

v5 -> v6:
- vfio_device property renamed into host property
- correct error handling of VFIO_DEVICE_GET_IRQ_INFO ioctl
  and remove PCI related comment
- remove declaration of vfio_setup_irqfd and irqfd_allowed
  property.Both belong to next patch (irqfd)
- remove declaration of vfio_intp_interrupt in vfio-platform.h
- functions that can be static get this characteristic
- remove declarations of vfio_region_ops, vfio_memory_listener,
  group_list, vfio_address_spaces. All are moved to vfio-common.h
- remove vfio_put_device declaration and definition
- print_regions removed. code moved into vfio_populate_regions
- replace DPRINTF by trace events
- new helper routine to set the trigger eventfd
- dissociate intp init from the injection enablement:
  vfio_enable_intp renamed into vfio_init_intp and new function
  named vfio_start_eventfd_injection
- injection start moved to vfio_start_irq_injection (not anymore
  in vfio_populate_interrupt)
- new start_irq_fn field in VFIOPlatformDevice corresponding to
  the function that will be used for starting injection
- user handled eventfd:
  x add mutex to protect IRQ state & list manipulation,
  x correct misleading comment in vfio_intp_interrupt.
  x Fix bugs thanks to fake interrupt modality
- VFIOPlatformDeviceClass becomes abstract
- add error_setg in vfio_platform_realize

v4 -> v5:
- vfio-plaform.h included first
- cleanup error handling in *populate*, vfio_get_device,
  vfio_enable_intp
- vfio_put_device not called anymore
- add some includes to follow vfio policy

v3 -> v4:
[Eric Auger]
- merge of "vfio: Add initial IRQ support in platform device"
  to get a full functional patch although perfs are limited.
- removal of unrealize function since I currently understand
  it is only used with device hot-plug feature.

v2 -> v3:
[Eric Auger]
- further factorization between PCI and platform (VFIORegion,
  VFIODevice). same level of functionality.

<= v2:
[Kim Philipps]
- Initial Creation of the device supporting register space mapping
---
 hw/vfio/Makefile.objs           |   1 +
 hw/vfio/platform.c              | 287 ++++++++++++++++++++++++++++++++++++++++
 include/hw/vfio/vfio-common.h   |   1 +
 include/hw/vfio/vfio-platform.h |  44 ++++++
 trace-events                    |  12 ++
 5 files changed, 345 insertions(+)
 create mode 100644 hw/vfio/platform.c
 create mode 100644 include/hw/vfio/vfio-platform.h

diff --git a/hw/vfio/Makefile.objs b/hw/vfio/Makefile.objs
index e31f30e..c5c76fe 100644
--- a/hw/vfio/Makefile.objs
+++ b/hw/vfio/Makefile.objs
@@ -1,4 +1,5 @@
 ifeq ($(CONFIG_LINUX), y)
 obj-$(CONFIG_SOFTMMU) += common.o
 obj-$(CONFIG_PCI) += pci.o
+obj-$(CONFIG_SOFTMMU) += platform.o
 endif
diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
new file mode 100644
index 0000000..9cbfeb5
--- /dev/null
+++ b/hw/vfio/platform.c
@@ -0,0 +1,287 @@
+/*
+ * vfio based device assignment support - platform devices
+ *
+ * Copyright Linaro Limited, 2014
+ *
+ * Authors:
+ *  Kim Phillips <kim.phillips@linaro.org>
+ *  Eric Auger <eric.auger@linaro.org>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ * Based on vfio based PCI device assignment support:
+ *  Copyright Red Hat, Inc. 2012
+ */
+
+#include <linux/vfio.h>
+#include <sys/ioctl.h>
+
+#include "hw/vfio/vfio-platform.h"
+#include "qemu/error-report.h"
+#include "qemu/range.h"
+#include "sysemu/sysemu.h"
+#include "exec/memory.h"
+#include "hw/sysbus.h"
+#include "trace.h"
+#include "hw/platform-bus.h"
+
+/* VFIO skeleton */
+
+/* not implemented yet */
+static void vfio_platform_compute_needs_reset(VFIODevice *vbasedev)
+{
+    vbasedev->needs_reset = false;
+}
+
+/* not implemented yet */
+static int vfio_platform_hot_reset_multi(VFIODevice *vbasedev)
+{
+    return 0;
+}
+
+/**
+ * vfio_populate_device - Allocate and populate MMIO region
+ * structs according to driver returned information
+ * @vbasedev: the VFIO device handle
+ *
+ */
+static int vfio_populate_device(VFIODevice *vbasedev)
+{
+    int i, ret = -1;
+    VFIOPlatformDevice *vdev =
+        container_of(vbasedev, VFIOPlatformDevice, vbasedev);
+
+    if (!(vbasedev->flags & VFIO_DEVICE_FLAGS_PLATFORM)) {
+        error_report("vfio: Um, this isn't a platform device");
+        return ret;
+    }
+
+    vdev->regions = g_malloc0_n(1,
+                                sizeof(VFIORegion *) * vbasedev->num_regions);
+
+    for (i = 0; i < vbasedev->num_regions; i++) {
+        struct vfio_region_info reg_info = { .argsz = sizeof(reg_info) };
+        VFIORegion *ptr;
+
+        vdev->regions[i] = g_malloc0_n(1, sizeof(VFIORegion));
+        ptr = vdev->regions[i];
+        reg_info.index = i;
+        ret = ioctl(vbasedev->fd, VFIO_DEVICE_GET_REGION_INFO, &reg_info);
+        if (ret) {
+            error_report("vfio: Error getting region %d info: %m", i);
+            goto reg_error;
+        }
+        ptr->flags = reg_info.flags;
+        ptr->size = reg_info.size;
+        ptr->fd_offset = reg_info.offset;
+        ptr->nr = i;
+        ptr->vbasedev = vbasedev;
+
+        trace_vfio_platform_populate_regions(ptr->nr,
+                            (unsigned long)ptr->flags,
+                            (unsigned long)ptr->size,
+                            ptr->vbasedev->fd,
+                            (unsigned long)ptr->fd_offset);
+    }
+
+    return 0;
+reg_error:
+    for (i = 0; i < vbasedev->num_regions; i++) {
+        g_free(vdev->regions[i]);
+    }
+    g_free(vdev->regions);
+    return ret;
+}
+
+/* specialized functions for VFIO Platform devices */
+static VFIODeviceOps vfio_platform_ops = {
+    .vfio_compute_needs_reset = vfio_platform_compute_needs_reset,
+    .vfio_hot_reset_multi = vfio_platform_hot_reset_multi,
+};
+
+/**
+ * vfio_base_device_init - perform preliminary VFIO setup
+ * @vbasedev: the VFIO device handle
+ *
+ * Implement the VFIO command sequence that allows to discover
+ * assigned device resources: group extraction, device
+ * fd retrieval, resource query.
+ * Precondition: the device name must be initialized
+ */
+static int vfio_base_device_init(VFIODevice *vbasedev)
+{
+    VFIOGroup *group;
+    VFIODevice *vbasedev_iter;
+    char path[PATH_MAX], iommu_group_path[PATH_MAX], *group_name;
+    ssize_t len;
+    struct stat st;
+    int groupid;
+    int ret;
+
+    /* name must be set prior to the call */
+    if (!vbasedev->name) {
+        return -EINVAL;
+    }
+
+    /* Check that the host device exists */
+    g_snprintf(path, sizeof(path), "/sys/bus/platform/devices/%s/",
+               vbasedev->name);
+
+    if (stat(path, &st) < 0) {
+        error_report("vfio: error: no such host device: %s", path);
+        return -errno;
+    }
+
+    g_strlcat(path, "iommu_group", sizeof(path));
+    len = readlink(path, iommu_group_path, sizeof(iommu_group_path));
+    if (len < 0) {
+        error_report("vfio: error no iommu_group for device");
+        return -errno;
+    }
+
+    iommu_group_path[len] = 0;
+    group_name = basename(iommu_group_path);
+
+    if (sscanf(group_name, "%d", &groupid) != 1) {
+        error_report("vfio: error reading %s: %m", path);
+        return -errno;
+    }
+
+    trace_vfio_platform_base_device_init(vbasedev->name, groupid);
+
+    group = vfio_get_group(groupid, &address_space_memory);
+    if (!group) {
+        error_report("vfio: failed to get group %d", groupid);
+        return -ENOENT;
+    }
+
+    g_snprintf(path, sizeof(path), "%s", vbasedev->name);
+
+    QLIST_FOREACH(vbasedev_iter, &group->device_list, next) {
+        if (strcmp(vbasedev_iter->name, vbasedev->name) == 0) {
+            error_report("vfio: error: device %s is already attached", path);
+            vfio_put_group(group);
+            return -EBUSY;
+        }
+    }
+    ret = vfio_get_device(group, path, vbasedev);
+    if (ret) {
+        error_report("vfio: failed to get device %s", path);
+        vfio_put_group(group);
+        return ret;
+    }
+
+    ret = vfio_populate_device(vbasedev);
+    if (ret) {
+        error_report("vfio: failed to populate device %s", path);
+        vfio_put_group(group);
+    }
+
+    return ret;
+}
+
+/**
+ * vfio_map_region - initialize the 2 memory regions for a given
+ * MMIO region index
+ * @vdev: the VFIO platform device handle
+ * @nr: the index of the region
+ *
+ * Init the top memory region and the mmapped memory region beneath
+ * VFIOPlatformDevice is used since VFIODevice is not a QOM Object
+ * and could not be passed to memory region functions
+*/
+static void vfio_map_region(VFIOPlatformDevice *vdev, int nr)
+{
+    VFIORegion *region = vdev->regions[nr];
+    unsigned size = region->size;
+    char name[64];
+
+    if (!size) {
+        return;
+    }
+
+    g_snprintf(name, sizeof(name), "VFIO %s region %d",
+               vdev->vbasedev.name, nr);
+
+    /* A "slow" read/write mapping underlies all regions */
+    memory_region_init_io(&region->mem, OBJECT(vdev), &vfio_region_ops,
+                          region, name, size);
+
+    g_strlcat(name, " mmap", sizeof(name));
+
+    if (vfio_mmap_region(OBJECT(vdev), region, &region->mem,
+                         &region->mmap_mem, &region->mmap, size, 0, name)) {
+        error_report("%s unsupported. Performance may be slow", name);
+    }
+}
+
+/**
+ * vfio_platform_realize  - the device realize function
+ * @dev: device state pointer
+ * @errp: error
+ *
+ * initialize the device, its memory regions and IRQ structures
+ * IRQ are started separately
+ */
+static void vfio_platform_realize(DeviceState *dev, Error **errp)
+{
+    VFIOPlatformDevice *vdev = VFIO_PLATFORM_DEVICE(dev);
+    SysBusDevice *sbdev = SYS_BUS_DEVICE(dev);
+    VFIODevice *vbasedev = &vdev->vbasedev;
+    int i, ret;
+
+    vbasedev->type = VFIO_DEVICE_TYPE_PLATFORM;
+    vbasedev->ops = &vfio_platform_ops;
+
+    trace_vfio_platform_realize(vbasedev->name, vdev->compat);
+
+    ret = vfio_base_device_init(vbasedev);
+    if (ret) {
+        error_setg(errp, "vfio: vfio_base_device_init failed for %s",
+                   vbasedev->name);
+        return;
+    }
+
+    for (i = 0; i < vbasedev->num_regions; i++) {
+        vfio_map_region(vdev, i);
+        sysbus_init_mmio(sbdev, &vdev->regions[i]->mem);
+    }
+}
+
+static const VMStateDescription vfio_platform_vmstate = {
+    .name = TYPE_VFIO_PLATFORM,
+    .unmigratable = 1,
+};
+
+static Property vfio_platform_dev_properties[] = {
+    DEFINE_PROP_STRING("host", VFIOPlatformDevice, vbasedev.name),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void vfio_platform_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+
+    dc->realize = vfio_platform_realize;
+    dc->props = vfio_platform_dev_properties;
+    dc->vmsd = &vfio_platform_vmstate;
+    dc->desc = "VFIO-based platform device assignment";
+    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
+}
+
+static const TypeInfo vfio_platform_dev_info = {
+    .name = TYPE_VFIO_PLATFORM,
+    .parent = TYPE_SYS_BUS_DEVICE,
+    .instance_size = sizeof(VFIOPlatformDevice),
+    .class_init = vfio_platform_class_init,
+    .class_size = sizeof(VFIOPlatformDeviceClass),
+    .abstract   = true,
+};
+
+static void register_vfio_platform_dev_type(void)
+{
+    type_register_static(&vfio_platform_dev_info);
+}
+
+type_init(register_vfio_platform_dev_type)
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 0d1fb80..59a321d 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -42,6 +42,7 @@
 
 enum {
     VFIO_DEVICE_TYPE_PCI = 0,
+    VFIO_DEVICE_TYPE_PLATFORM = 1,
 };
 
 typedef struct VFIORegion {
diff --git a/include/hw/vfio/vfio-platform.h b/include/hw/vfio/vfio-platform.h
new file mode 100644
index 0000000..338f0c6
--- /dev/null
+++ b/include/hw/vfio/vfio-platform.h
@@ -0,0 +1,44 @@
+/*
+ * vfio based device assignment support - platform devices
+ *
+ * Copyright Linaro Limited, 2014
+ *
+ * Authors:
+ *  Kim Phillips <kim.phillips@linaro.org>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ * Based on vfio based PCI device assignment support:
+ *  Copyright Red Hat, Inc. 2012
+ */
+
+#ifndef HW_VFIO_VFIO_PLATFORM_H
+#define HW_VFIO_VFIO_PLATFORM_H
+
+#include "hw/sysbus.h"
+#include "hw/vfio/vfio-common.h"
+
+#define TYPE_VFIO_PLATFORM "vfio-platform"
+
+typedef struct VFIOPlatformDevice {
+    SysBusDevice sbdev;
+    VFIODevice vbasedev; /* not a QOM object */
+    VFIORegion **regions;
+    char *compat; /* compatibility string */
+} VFIOPlatformDevice;
+
+typedef struct VFIOPlatformDeviceClass {
+    /*< private >*/
+    SysBusDeviceClass parent_class;
+    /*< public >*/
+} VFIOPlatformDeviceClass;
+
+#define VFIO_PLATFORM_DEVICE(obj) \
+     OBJECT_CHECK(VFIOPlatformDevice, (obj), TYPE_VFIO_PLATFORM)
+#define VFIO_PLATFORM_DEVICE_CLASS(klass) \
+     OBJECT_CLASS_CHECK(VFIOPlatformDeviceClass, (klass), TYPE_VFIO_PLATFORM)
+#define VFIO_PLATFORM_DEVICE_GET_CLASS(obj) \
+     OBJECT_GET_CLASS(VFIOPlatformDeviceClass, (obj), TYPE_VFIO_PLATFORM)
+
+#endif /*HW_VFIO_VFIO_PLATFORM_H*/
diff --git a/trace-events b/trace-events
index 30eba92..17c7108 100644
--- a/trace-events
+++ b/trace-events
@@ -1560,6 +1560,18 @@ vfio_put_group(int fd) "close group->fd=%d"
 vfio_get_device(const char * name, unsigned int flags, unsigned int num_regions, unsigned int num_irqs) "Device %s flags: %u, regions: %u, irqs: %u"
 vfio_put_base_device(int fd) "close vdev->fd=%d"
 
+# hw/vfio/platform.c
+vfio_platform_eoi(int pin, int fd) "EOI IRQ pin %d (fd=%d)"
+vfio_platform_mmap_set_enabled(bool enabled) "fast path = %d"
+vfio_platform_intp_mmap_enable(int pin) "IRQ #%d still active, stay in slow path"
+vfio_platform_intp_interrupt(int pin, int fd) "Handle IRQ #%d (fd = %d)"
+vfio_platform_populate_interrupts(int pin, int count, int flags) "- IRQ index %d: count %d, flags=0x%x"
+vfio_platform_populate_regions(int region_index, unsigned long flag, unsigned long size, int fd, unsigned long offset) "- region %d flags = 0x%lx, size = 0x%lx, fd= %d, offset = 0x%lx"
+vfio_platform_base_device_init(char *name, int groupid) "%s belongs to group #%d"
+vfio_platform_realize(char *name, char *compat) "vfio device %s, compat = %s"
+vfio_intp_interrupt_set_pending(int index) "irq %d is set PENDING"
+vfio_platform_eoi_handle_pending(int index) "handle PENDING IRQ %d"
+
 #hw/acpi/memory_hotplug.c
 mhp_acpi_invalid_slot_selected(uint32_t slot) "0x%"PRIx32
 mhp_acpi_read_addr_lo(uint32_t slot, uint32_t addr) "slot[0x%"PRIx32"] addr lo: 0x%"PRIx32
-- 
1.8.3.2
