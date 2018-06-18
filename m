From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 08/13] Add PCI device passthrough using VFIO
Date: Mon, 18 Jun 2018 19:42:06 +0100
Message-ID: <20180618184211.43904-9-jean-philippe.brucker@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D38554A0D4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:32:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RhpNSiHVC01R for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:47 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 044944A0DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:38 -0400 (EDT)
In-Reply-To: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: lorenzo.pieralisi@arm.com, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, alex.williamson@redhat.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Assigning devices using VFIO allows the guest to have direct access to the
device, whilst filtering accesses to sensitive areas by trapping config
space accesses and mapping DMA with an IOMMU.

This patch adds a new option to lkvm run: --vfio-pci=<BDF>. Before
assigning a device to a VM, some preparation is required. As described in
Linux Documentation/vfio.txt, the device driver needs to be changed to
vfio-pci:

  $ dev=0000:00:00.0

  $ echo $dev > /sys/bus/pci/devices/$dev/driver/unbind
  $ echo vfio-pci > /sys/bus/pci/devices/$dev/driver_override
  $ echo $dev > /sys/bus/pci/drivers_probe

Adding --vfio-pci=$dev to lkvm-run will pass the device to the guest.
Multiple devices can be passed to the guest by adding more --vfio-pci
parameters.

This patch only implements PCI with INTx. MSI-X routing will be added in a
subsequent patch, and at some point we might add support for passing
platform devices to guests.

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 Makefile                 |   2 +
 arm/pci.c                |   1 +
 builtin-run.c            |   5 +
 include/kvm/kvm-config.h |   3 +
 include/kvm/pci.h        |   3 +-
 include/kvm/vfio.h       |  71 ++++++
 vfio/core.c              | 494 +++++++++++++++++++++++++++++++++++++++
 vfio/pci.c               | 395 +++++++++++++++++++++++++++++++
 8 files changed, 973 insertions(+), 1 deletion(-)
 create mode 100644 include/kvm/vfio.h
 create mode 100644 vfio/core.c
 create mode 100644 vfio/pci.c

diff --git a/Makefile b/Makefile
index 5453199b3..e3088a466 100644
--- a/Makefile
+++ b/Makefile
@@ -59,6 +59,8 @@ OBJS	+= main.o
 OBJS	+= mmio.o
 OBJS	+= pci.o
 OBJS	+= term.o
+OBJS	+= vfio/core.o
+OBJS	+= vfio/pci.o
 OBJS	+= virtio/blk.o
 OBJS	+= virtio/scsi.o
 OBJS	+= virtio/console.o
diff --git a/arm/pci.c b/arm/pci.c
index 744b14c26..557cfa989 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -1,5 +1,6 @@
 #include "kvm/devices.h"
 #include "kvm/fdt.h"
+#include "kvm/kvm.h"
 #include "kvm/of_pci.h"
 #include "kvm/pci.h"
 #include "kvm/util.h"
diff --git a/builtin-run.c b/builtin-run.c
index b56aea7d1..443c10ba4 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -146,6 +146,11 @@ void kvm_run_set_wrapper_sandbox(void)
 	OPT_BOOLEAN('\0', "no-dhcp", &(cfg)->no_dhcp, "Disable kernel"	\
 			" DHCP in rootfs mode"),			\
 									\
+	OPT_GROUP("VFIO options:"),					\
+	OPT_CALLBACK('\0', "vfio-pci", NULL, "[domain:]bus:dev.fn",	\
+		     "Assign a PCI device to the virtual machine",	\
+		     vfio_device_parser, kvm),				\
+									\
 	OPT_GROUP("Debug options:"),					\
 	OPT_BOOLEAN('\0', "debug", &do_debug_print,			\
 			"Enable debug messages"),			\
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 386fa8c59..a052b0bc7 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -2,6 +2,7 @@
 #define KVM_CONFIG_H_
 
 #include "kvm/disk-image.h"
+#include "kvm/vfio.h"
 #include "kvm/kvm-config-arch.h"
 
 #define DEFAULT_KVM_DEV		"/dev/kvm"
@@ -20,9 +21,11 @@
 struct kvm_config {
 	struct kvm_config_arch arch;
 	struct disk_image_params disk_image[MAX_DISK_IMAGES];
+	struct vfio_device_params *vfio_devices;
 	u64 ram_size;
 	u8  image_count;
 	u8 num_net_devices;
+	u8 num_vfio_devices;
 	bool virtio_rng;
 	int active_console;
 	int debug_iodelay;
diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index 01c244bcf..274b77ea6 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -7,7 +7,6 @@
 #include <endian.h>
 
 #include "kvm/devices.h"
-#include "kvm/kvm.h"
 #include "kvm/msi.h"
 #include "kvm/fdt.h"
 
@@ -22,6 +21,8 @@
 #define PCI_IO_SIZE		0x100
 #define PCI_CFG_SIZE		(1ULL << 24)
 
+struct kvm;
+
 union pci_config_address {
 	struct {
 #if __BYTE_ORDER == __LITTLE_ENDIAN
diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
new file mode 100644
index 000000000..c434703ab
--- /dev/null
+++ b/include/kvm/vfio.h
@@ -0,0 +1,71 @@
+#ifndef KVM__VFIO_H
+#define KVM__VFIO_H
+
+#include "kvm/parse-options.h"
+#include "kvm/pci.h"
+
+#include <linux/vfio.h>
+
+#define vfio_dev_err(vdev, fmt, ...) \
+	pr_err("%s: " fmt, (vdev)->params->name, ##__VA_ARGS__)
+#define vfio_dev_warn(vdev, fmt, ...) \
+	pr_warning("%s: " fmt, (vdev)->params->name, ##__VA_ARGS__)
+#define vfio_dev_info(vdev, fmt, ...) \
+	pr_info("%s: " fmt, (vdev)->params->name, ##__VA_ARGS__)
+#define vfio_dev_dbg(vdev, fmt, ...) \
+	pr_debug("%s: " fmt, (vdev)->params->name, ##__VA_ARGS__)
+#define vfio_dev_die(vdev, fmt, ...) \
+	die("%s: " fmt, (vdev)->params->name, ##__VA_ARGS__)
+
+/* Currently limited by num_vfio_devices */
+#define MAX_VFIO_DEVICES		256
+
+enum vfio_device_type {
+	VFIO_DEVICE_PCI,
+};
+
+struct vfio_pci_device {
+	struct pci_device_header	hdr;
+};
+
+struct vfio_region {
+	struct vfio_region_info		info;
+	u64				guest_phys_addr;
+	void				*host_addr;
+};
+
+struct vfio_device {
+	struct device_header		dev_hdr;
+	struct vfio_device_params	*params;
+	struct vfio_group		*group;
+
+	int				fd;
+	struct vfio_device_info		info;
+	struct vfio_region		*regions;
+
+	char				*sysfs_path;
+
+	struct vfio_pci_device		pci;
+};
+
+struct vfio_device_params {
+	char				*name;
+	const char			*bus;
+	enum vfio_device_type		type;
+};
+
+struct vfio_group {
+	unsigned long			id; /* iommu_group number in sysfs */
+	int				fd;
+	int				refs;
+	struct list_head		list;
+};
+
+int vfio_device_parser(const struct option *opt, const char *arg, int unset);
+int vfio_map_region(struct kvm *kvm, struct vfio_device *vdev,
+		    struct vfio_region *region);
+void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region);
+int vfio_pci_setup_device(struct kvm *kvm, struct vfio_device *device);
+void vfio_pci_teardown_device(struct kvm *kvm, struct vfio_device *vdev);
+
+#endif /* KVM__VFIO_H */
diff --git a/vfio/core.c b/vfio/core.c
new file mode 100644
index 000000000..6c78e89f1
--- /dev/null
+++ b/vfio/core.c
@@ -0,0 +1,494 @@
+#include "kvm/kvm.h"
+#include "kvm/vfio.h"
+
+#include <linux/list.h>
+
+#define VFIO_DEV_DIR		"/dev/vfio"
+#define VFIO_DEV_NODE		VFIO_DEV_DIR "/vfio"
+#define IOMMU_GROUP_DIR		"/sys/kernel/iommu_groups"
+
+static int vfio_container;
+static LIST_HEAD(vfio_groups);
+static struct vfio_device *vfio_devices;
+
+static int vfio_device_pci_parser(const struct option *opt, char *arg,
+				  struct vfio_device_params *dev)
+{
+	unsigned int domain, bus, devnr, fn;
+
+	int nr = sscanf(arg, "%4x:%2x:%2x.%1x", &domain, &bus, &devnr, &fn);
+	if (nr < 4) {
+		domain = 0;
+		nr = sscanf(arg, "%2x:%2x.%1x", &bus, &devnr, &fn);
+		if (nr < 3) {
+			pr_err("Invalid device identifier %s", arg);
+			return -EINVAL;
+		}
+	}
+
+	dev->type = VFIO_DEVICE_PCI;
+	dev->bus = "pci";
+	dev->name = malloc(13);
+	if (!dev->name)
+		return -ENOMEM;
+
+	snprintf(dev->name, 13, "%04x:%02x:%02x.%x", domain, bus, devnr, fn);
+
+	return 0;
+}
+
+int vfio_device_parser(const struct option *opt, const char *arg, int unset)
+{
+	int ret = -EINVAL;
+	static int idx = 0;
+	struct kvm *kvm = opt->ptr;
+	struct vfio_device_params *dev, *devs;
+	char *cur, *buf = strdup(arg);
+
+	if (!buf)
+		return -ENOMEM;
+
+	if (idx >= MAX_VFIO_DEVICES) {
+		pr_warning("Too many VFIO devices");
+		goto out_free_buf;
+	}
+
+	devs = realloc(kvm->cfg.vfio_devices, sizeof(*dev) * (idx + 1));
+	if (!devs) {
+		ret = -ENOMEM;
+		goto out_free_buf;
+	}
+
+	kvm->cfg.vfio_devices = devs;
+	dev = &devs[idx];
+
+	cur = strtok(buf, ",");
+	if (!cur)
+		goto out_free_buf;
+
+	if (!strcmp(opt->long_name, "vfio-pci"))
+		ret = vfio_device_pci_parser(opt, cur, dev);
+	else
+		ret = -EINVAL;
+
+	if (!ret)
+		kvm->cfg.num_vfio_devices = ++idx;
+
+out_free_buf:
+	free(buf);
+
+	return ret;
+}
+
+int vfio_map_region(struct kvm *kvm, struct vfio_device *vdev,
+		    struct vfio_region *region)
+{
+	void *base;
+	int ret, prot = 0;
+	/* KVM needs page-aligned regions */
+	u64 map_size = ALIGN(region->info.size, PAGE_SIZE);
+
+	/*
+	 * We don't want to mess about trapping config accesses, so require that
+	 * they can be mmap'd. Note that for PCI, this precludes the use of I/O
+	 * BARs in the guest (we will hide them from Configuration Space, which
+	 * is trapped).
+	 */
+	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_MMAP)) {
+		vfio_dev_info(vdev, "ignoring region %u, as it can't be mmap'd",
+			      region->info.index);
+		return 0;
+	}
+
+	if (region->info.flags & VFIO_REGION_INFO_FLAG_READ)
+		prot |= PROT_READ;
+	if (region->info.flags & VFIO_REGION_INFO_FLAG_WRITE)
+		prot |= PROT_WRITE;
+
+	base = mmap(NULL, region->info.size, prot, MAP_SHARED, vdev->fd,
+		    region->info.offset);
+	if (base == MAP_FAILED) {
+		ret = -errno;
+		vfio_dev_err(vdev, "failed to mmap region %u (0x%llx bytes)",
+			     region->info.index, region->info.size);
+		return ret;
+	}
+	region->host_addr = base;
+
+	ret = kvm__register_dev_mem(kvm, region->guest_phys_addr, map_size,
+				    region->host_addr);
+	if (ret) {
+		vfio_dev_err(vdev, "failed to register region with KVM");
+		return ret;
+	}
+
+	return 0;
+}
+
+void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
+{
+	munmap(region->host_addr, region->info.size);
+}
+
+static int vfio_configure_device(struct kvm *kvm, struct vfio_device *vdev)
+{
+	int ret;
+	struct vfio_group *group = vdev->group;
+
+	vdev->fd = ioctl(group->fd, VFIO_GROUP_GET_DEVICE_FD,
+			 vdev->params->name);
+	if (vdev->fd < 0) {
+		vfio_dev_warn(vdev, "failed to get fd");
+
+		/* The device might be a bridge without an fd */
+		return 0;
+	}
+
+	vdev->info.argsz = sizeof(vdev->info);
+	if (ioctl(vdev->fd, VFIO_DEVICE_GET_INFO, &vdev->info)) {
+		ret = -errno;
+		vfio_dev_err(vdev, "failed to get info");
+		goto err_close_device;
+	}
+
+	if (vdev->info.flags & VFIO_DEVICE_FLAGS_RESET &&
+	    ioctl(vdev->fd, VFIO_DEVICE_RESET) < 0)
+		vfio_dev_warn(vdev, "failed to reset device");
+
+	vdev->regions = calloc(vdev->info.num_regions, sizeof(*vdev->regions));
+	if (!vdev->regions) {
+		ret = -ENOMEM;
+		goto err_close_device;
+	}
+
+	/* Now for the bus-specific initialization... */
+	switch (vdev->params->type) {
+	case VFIO_DEVICE_PCI:
+		BUG_ON(!(vdev->info.flags & VFIO_DEVICE_FLAGS_PCI));
+		ret = vfio_pci_setup_device(kvm, vdev);
+		break;
+	default:
+		BUG_ON(1);
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		goto err_free_regions;
+
+	vfio_dev_info(vdev, "assigned to device number 0x%x in group %lu",
+		      vdev->dev_hdr.dev_num, group->id);
+
+	return 0;
+
+err_free_regions:
+	free(vdev->regions);
+err_close_device:
+	close(vdev->fd);
+
+	return ret;
+}
+
+static int vfio_configure_devices(struct kvm *kvm)
+{
+	int i, ret;
+
+	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
+		ret = vfio_configure_device(kvm, &vfio_devices[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int vfio_get_iommu_type(void)
+{
+	if (ioctl(vfio_container, VFIO_CHECK_EXTENSION, VFIO_TYPE1v2_IOMMU))
+		return VFIO_TYPE1v2_IOMMU;
+
+	if (ioctl(vfio_container, VFIO_CHECK_EXTENSION, VFIO_TYPE1_IOMMU))
+		return VFIO_TYPE1_IOMMU;
+
+	return -ENODEV;
+}
+
+static int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
+{
+	int ret = 0;
+	struct vfio_iommu_type1_dma_map dma_map = {
+		.argsz	= sizeof(dma_map),
+		.flags	= VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE,
+		.vaddr	= (unsigned long)bank->host_addr,
+		.iova	= (u64)bank->guest_phys_addr,
+		.size	= bank->size,
+	};
+
+	/* Map the guest memory for DMA (i.e. provide isolation) */
+	if (ioctl(vfio_container, VFIO_IOMMU_MAP_DMA, &dma_map)) {
+		ret = -errno;
+		pr_err("Failed to map 0x%llx -> 0x%llx (%llu) for DMA",
+		       dma_map.iova, dma_map.vaddr, dma_map.size);
+	}
+
+	return ret;
+}
+
+static int vfio_unmap_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
+{
+	struct vfio_iommu_type1_dma_unmap dma_unmap = {
+		.argsz = sizeof(dma_unmap),
+		.size = bank->size,
+		.iova = bank->guest_phys_addr,
+	};
+
+	ioctl(vfio_container, VFIO_IOMMU_UNMAP_DMA, &dma_unmap);
+
+	return 0;
+}
+
+static struct vfio_group *vfio_group_create(struct kvm *kvm, unsigned long id)
+{
+	int ret;
+	struct vfio_group *group;
+	char group_node[PATH_MAX];
+	struct vfio_group_status group_status = {
+		.argsz = sizeof(group_status),
+	};
+
+	group = calloc(1, sizeof(*group));
+	if (!group)
+		return NULL;
+
+	group->id	= id;
+	group->refs	= 1;
+
+	ret = snprintf(group_node, PATH_MAX, VFIO_DEV_DIR "/%lu", id);
+	if (ret < 0 || ret == PATH_MAX)
+		return NULL;
+
+	group->fd = open(group_node, O_RDWR);
+	if (group->fd < 0) {
+		pr_err("Failed to open IOMMU group %s", group_node);
+		goto err_free_group;
+	}
+
+	if (ioctl(group->fd, VFIO_GROUP_GET_STATUS, &group_status)) {
+		pr_err("Failed to determine status of IOMMU group %lu", id);
+		goto err_close_group;
+	}
+
+	if (!(group_status.flags & VFIO_GROUP_FLAGS_VIABLE)) {
+		pr_err("IOMMU group %lu is not viable", id);
+		goto err_close_group;
+	}
+
+	if (ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &vfio_container)) {
+		pr_err("Failed to add IOMMU group %lu to VFIO container", id);
+		goto err_close_group;
+	}
+
+	list_add(&group->list, &vfio_groups);
+
+	return group;
+
+err_close_group:
+	close(group->fd);
+err_free_group:
+	free(group);
+
+	return NULL;
+}
+
+static void vfio_group_exit(struct kvm *kvm, struct vfio_group *group)
+{
+	if (--group->refs != 0)
+		return;
+
+	ioctl(group->fd, VFIO_GROUP_UNSET_CONTAINER);
+
+	list_del(&group->list);
+	close(group->fd);
+	free(group);
+}
+
+static struct vfio_group *
+vfio_group_get_for_dev(struct kvm *kvm, struct vfio_device *vdev)
+{
+	int dirfd;
+	ssize_t ret;
+	char *group_name;
+	unsigned long group_id;
+	char group_path[PATH_MAX];
+	struct vfio_group *group = NULL;
+
+	/* Find IOMMU group for this device */
+	dirfd = open(vdev->sysfs_path, O_DIRECTORY | O_PATH | O_RDONLY);
+	if (dirfd < 0) {
+		vfio_dev_err(vdev, "failed to open '%s'", vdev->sysfs_path);
+		return NULL;
+	}
+
+	ret = readlinkat(dirfd, "iommu_group", group_path, PATH_MAX);
+	if (ret < 0) {
+		vfio_dev_err(vdev, "no iommu_group");
+		goto out_close;
+	}
+	if (ret == PATH_MAX)
+		goto out_close;
+
+	group_path[ret] = '\0';
+
+	group_name = basename(group_path);
+	errno = 0;
+	group_id = strtoul(group_name, NULL, 10);
+	if (errno)
+		goto out_close;
+
+	list_for_each_entry(group, &vfio_groups, list) {
+		if (group->id == group_id) {
+			group->refs++;
+			return group;
+		}
+	}
+
+	group = vfio_group_create(kvm, group_id);
+
+out_close:
+	close(dirfd);
+	return group;
+}
+
+static int vfio_device_init(struct kvm *kvm, struct vfio_device *vdev)
+{
+	int ret;
+	char dev_path[PATH_MAX];
+	struct vfio_group *group;
+
+	ret = snprintf(dev_path, PATH_MAX, "/sys/bus/%s/devices/%s",
+		       vdev->params->bus, vdev->params->name);
+	if (ret < 0 || ret == PATH_MAX)
+		return -EINVAL;
+
+	vdev->sysfs_path = strndup(dev_path, PATH_MAX);
+	if (!vdev->sysfs_path)
+		return -errno;
+
+	group = vfio_group_get_for_dev(kvm, vdev);
+	if (!group) {
+		free(vdev->sysfs_path);
+		return -EINVAL;
+	}
+
+	vdev->group = group;
+
+	return 0;
+}
+
+static void vfio_device_exit(struct kvm *kvm, struct vfio_device *vdev)
+{
+	vfio_group_exit(kvm, vdev->group);
+
+	switch (vdev->params->type) {
+	case VFIO_DEVICE_PCI:
+		vfio_pci_teardown_device(kvm, vdev);
+		break;
+	default:
+		vfio_dev_warn(vdev, "no teardown function for device");
+	}
+
+	close(vdev->fd);
+
+	free(vdev->regions);
+	free(vdev->sysfs_path);
+}
+
+static int vfio_container_init(struct kvm *kvm)
+{
+	int api, i, ret, iommu_type;;
+
+	/* Create a container for our IOMMU groups */
+	vfio_container = open(VFIO_DEV_NODE, O_RDWR);
+	if (vfio_container == -1) {
+		ret = errno;
+		pr_err("Failed to open %s", VFIO_DEV_NODE);
+		return ret;
+	}
+
+	api = ioctl(vfio_container, VFIO_GET_API_VERSION);
+	if (api != VFIO_API_VERSION) {
+		pr_err("Unknown VFIO API version %d", api);
+		return -ENODEV;
+	}
+
+	iommu_type = vfio_get_iommu_type();
+	if (iommu_type < 0) {
+		pr_err("VFIO type-1 IOMMU not supported on this platform");
+		return iommu_type;
+	}
+
+	/* Create groups for our devices and add them to the container */
+	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
+		vfio_devices[i].params = &kvm->cfg.vfio_devices[i];
+
+		ret = vfio_device_init(kvm, &vfio_devices[i]);
+		if (ret)
+			return ret;
+	}
+
+	/* Finalise the container */
+	if (ioctl(vfio_container, VFIO_SET_IOMMU, iommu_type)) {
+		ret = -errno;
+		pr_err("Failed to set IOMMU type %d for VFIO container",
+		       iommu_type);
+		return ret;
+	} else {
+		pr_info("Using IOMMU type %d for VFIO container", iommu_type);
+	}
+
+	return kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM, vfio_map_mem_bank,
+				      NULL);
+}
+
+static int vfio__init(struct kvm *kvm)
+{
+	int ret;
+
+	if (!kvm->cfg.num_vfio_devices)
+		return 0;
+
+	vfio_devices = calloc(kvm->cfg.num_vfio_devices, sizeof(*vfio_devices));
+	if (!vfio_devices)
+		return -ENOMEM;
+
+	ret = vfio_container_init(kvm);
+	if (ret)
+		return ret;
+
+	ret = vfio_configure_devices(kvm);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+dev_base_init(vfio__init);
+
+static int vfio__exit(struct kvm *kvm)
+{
+	int i;
+
+	if (!kvm->cfg.num_vfio_devices)
+		return 0;
+
+	for (i = 0; i < kvm->cfg.num_vfio_devices; i++)
+		vfio_device_exit(kvm, &vfio_devices[i]);
+
+	free(vfio_devices);
+
+	kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM, vfio_unmap_mem_bank, NULL);
+	close(vfio_container);
+
+	free(kvm->cfg.vfio_devices);
+
+	return 0;
+}
+dev_base_exit(vfio__exit);
diff --git a/vfio/pci.c b/vfio/pci.c
new file mode 100644
index 000000000..6b157cfa3
--- /dev/null
+++ b/vfio/pci.c
@@ -0,0 +1,395 @@
+#include "kvm/irq.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/vfio.h"
+
+#include <sys/ioctl.h>
+#include <sys/eventfd.h>
+
+/* Wrapper around UAPI vfio_irq_set */
+struct vfio_irq_eventfd {
+	struct vfio_irq_set	irq;
+	int			fd;
+};
+
+static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr,
+			      u8 offset, void *data, int sz)
+{
+	struct vfio_region_info *info;
+	struct vfio_pci_device *pdev;
+	struct vfio_device *vdev;
+	char base[sz];
+
+	pdev = container_of(pci_hdr, struct vfio_pci_device, hdr);
+	vdev = container_of(pdev, struct vfio_device, pci);
+	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
+
+	/* Dummy read in case of side-effects */
+	if (pread(vdev->fd, base, sz, info->offset + offset) != sz)
+		vfio_dev_warn(vdev, "failed to read %d bytes from Configuration Space at 0x%x",
+			      sz, offset);
+}
+
+static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hdr,
+			       u8 offset, void *data, int sz)
+{
+	struct vfio_region_info *info;
+	struct vfio_pci_device *pdev;
+	struct vfio_device *vdev;
+	void *base = pci_hdr;
+
+	pdev = container_of(pci_hdr, struct vfio_pci_device, hdr);
+	vdev = container_of(pdev, struct vfio_device, pci);
+	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
+
+	if (pwrite(vdev->fd, data, sz, info->offset + offset) != sz)
+		vfio_dev_warn(vdev, "Failed to write %d bytes to Configuration Space at 0x%x",
+			      sz, offset);
+
+	if (pread(vdev->fd, base + offset, sz, info->offset + offset) != sz)
+		vfio_dev_warn(vdev, "Failed to read %d bytes from Configuration Space at 0x%x",
+			      sz, offset);
+}
+
+static int vfio_pci_parse_caps(struct vfio_device *vdev)
+{
+	struct vfio_pci_device *pdev = &vdev->pci;
+
+	if (!(pdev->hdr.status & PCI_STATUS_CAP_LIST))
+		return 0;
+
+	pdev->hdr.status &= ~PCI_STATUS_CAP_LIST;
+	pdev->hdr.capabilities = 0;
+
+	/* TODO: install virtual capabilities */
+
+	return 0;
+}
+
+static int vfio_pci_parse_cfg_space(struct vfio_device *vdev)
+{
+	ssize_t sz = PCI_STD_HEADER_SIZEOF;
+	struct vfio_region_info *info;
+	struct vfio_pci_device *pdev = &vdev->pci;
+
+	if (vdev->info.num_regions < VFIO_PCI_CONFIG_REGION_INDEX) {
+		vfio_dev_err(vdev, "Config Space not found");
+		return -ENODEV;
+	}
+
+	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
+	*info = (struct vfio_region_info) {
+			.argsz = sizeof(*info),
+			.index = VFIO_PCI_CONFIG_REGION_INDEX,
+	};
+
+	ioctl(vdev->fd, VFIO_DEVICE_GET_REGION_INFO, info);
+	if (!info->size) {
+		vfio_dev_err(vdev, "Config Space has size zero?!");
+		return -EINVAL;
+	}
+
+	if (pread(vdev->fd, &pdev->hdr, sz, info->offset) != sz) {
+		vfio_dev_err(vdev, "failed to read %zd bytes of Config Space", sz);
+		return -EIO;
+	}
+
+	/* Strip bit 7, that indicates multifunction */
+	pdev->hdr.header_type &= 0x7f;
+
+	if (pdev->hdr.header_type != PCI_HEADER_TYPE_NORMAL) {
+		vfio_dev_err(vdev, "unsupported header type %u",
+			     pdev->hdr.header_type);
+		return -EOPNOTSUPP;
+	}
+
+	vfio_pci_parse_caps(vdev);
+
+	return 0;
+}
+
+static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
+{
+	int i;
+	ssize_t hdr_sz;
+	struct vfio_region_info *info;
+	struct vfio_pci_device *pdev = &vdev->pci;
+
+	/* Enable exclusively MMIO and bus mastering */
+	pdev->hdr.command &= ~PCI_COMMAND_IO;
+	pdev->hdr.command |= PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER;
+
+	/* Initialise the BARs */
+	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
+		struct vfio_region *region = &vdev->regions[i];
+		u64 base = region->guest_phys_addr;
+
+		if (!base)
+			continue;
+
+		pdev->hdr.bar_size[i] = region->info.size;
+
+		/* Construct a fake reg to match what we've mapped. */
+		pdev->hdr.bar[i] = (base & PCI_BASE_ADDRESS_MEM_MASK) |
+					PCI_BASE_ADDRESS_SPACE_MEMORY |
+					PCI_BASE_ADDRESS_MEM_TYPE_32;
+	}
+
+	/* I really can't be bothered to support cardbus. */
+	pdev->hdr.card_bus = 0;
+
+	/*
+	 * Nuke the expansion ROM for now. If we want to do this properly,
+	 * we need to save its size somewhere and map into the guest.
+	 */
+	pdev->hdr.exp_rom_bar = 0;
+
+	/* Install our fake Configuration Space */
+	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
+	hdr_sz = PCI_DEV_CFG_SIZE;
+	if (pwrite(vdev->fd, &pdev->hdr, hdr_sz, info->offset) != hdr_sz) {
+		vfio_dev_err(vdev, "failed to write %zd bytes to Config Space",
+			     hdr_sz);
+		return -EIO;
+	}
+
+	/* Register callbacks for cfg accesses */
+	pdev->hdr.cfg_ops = (struct pci_config_operations) {
+		.read	= vfio_pci_cfg_read,
+		.write	= vfio_pci_cfg_write,
+	};
+
+	pdev->hdr.irq_type = IRQ_TYPE_LEVEL_HIGH;
+
+	return 0;
+}
+
+static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
+				  size_t nr)
+{
+	int ret;
+	size_t map_size;
+	struct vfio_region *region = &vdev->regions[nr];
+
+	if (nr >= vdev->info.num_regions)
+		return 0;
+
+	region->info = (struct vfio_region_info) {
+		.argsz = sizeof(region->info),
+		.index = nr,
+	};
+
+	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_REGION_INFO, &region->info);
+	if (ret) {
+		ret = -errno;
+		vfio_dev_err(vdev, "cannot get info for BAR %zu", nr);
+		return ret;
+	}
+
+	/* Ignore invalid or unimplemented regions */
+	if (!region->info.size)
+		return 0;
+
+	/* Grab some MMIO space in the guest */
+	map_size = ALIGN(region->info.size, PAGE_SIZE);
+	region->guest_phys_addr = pci_get_io_space_block(map_size);
+
+	/*
+	 * Map the BARs into the guest. We'll later need to update
+	 * configuration space to reflect our allocation.
+	 */
+	ret = vfio_map_region(kvm, vdev, region);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int vfio_pci_configure_dev_regions(struct kvm *kvm,
+					  struct vfio_device *vdev)
+{
+	int ret;
+	u32 bar;
+	size_t i;
+	bool is_64bit = false;
+	struct vfio_pci_device *pdev = &vdev->pci;
+
+	ret = vfio_pci_parse_cfg_space(vdev);
+	if (ret)
+		return ret;
+
+	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
+		/* Ignore top half of 64-bit BAR */
+		if (i % 2 && is_64bit)
+			continue;
+
+		ret = vfio_pci_configure_bar(kvm, vdev, i);
+		if (ret)
+			return ret;
+
+		bar = pdev->hdr.bar[i];
+		is_64bit = (bar & PCI_BASE_ADDRESS_SPACE) ==
+			   PCI_BASE_ADDRESS_SPACE_MEMORY &&
+			   bar & PCI_BASE_ADDRESS_MEM_TYPE_64;
+	}
+
+	/* We've configured the BARs, fake up a Configuration Space */
+	return vfio_pci_fixup_cfg_space(vdev);
+}
+
+static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
+{
+	int ret;
+	int trigger_fd, unmask_fd;
+	struct vfio_irq_eventfd	trigger;
+	struct vfio_irq_eventfd	unmask;
+	struct vfio_pci_device *pdev = &vdev->pci;
+	int gsi = pdev->hdr.irq_line - KVM_IRQ_OFFSET;
+
+	struct vfio_irq_info irq_info = {
+		.argsz = sizeof(irq_info),
+		.index = VFIO_PCI_INTX_IRQ_INDEX,
+	};
+
+	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
+	if (ret || irq_info.count == 0) {
+		vfio_dev_err(vdev, "no INTx reported by VFIO");
+		return -ENODEV;
+	}
+
+	if (!(irq_info.flags & VFIO_IRQ_INFO_EVENTFD)) {
+		vfio_dev_err(vdev, "interrupt not eventfd capable");
+		return -EINVAL;
+	}
+
+	if (!(irq_info.flags & VFIO_IRQ_INFO_AUTOMASKED)) {
+		vfio_dev_err(vdev, "INTx interrupt not AUTOMASKED");
+		return -EINVAL;
+	}
+
+	/*
+	 * PCI IRQ is level-triggered, so we use two eventfds. trigger_fd
+	 * signals an interrupt from host to guest, and unmask_fd signals the
+	 * deassertion of the line from guest to host.
+	 */
+	trigger_fd = eventfd(0, 0);
+	if (trigger_fd < 0) {
+		vfio_dev_err(vdev, "failed to create trigger eventfd");
+		return trigger_fd;
+	}
+
+	unmask_fd = eventfd(0, 0);
+	if (unmask_fd < 0) {
+		vfio_dev_err(vdev, "failed to create unmask eventfd");
+		close(trigger_fd);
+		return unmask_fd;
+	}
+
+	ret = irq__add_irqfd(kvm, gsi, trigger_fd, unmask_fd);
+	if (ret)
+		goto err_close;
+
+	trigger.irq = (struct vfio_irq_set) {
+		.argsz	= sizeof(trigger),
+		.flags	= VFIO_IRQ_SET_DATA_EVENTFD | VFIO_IRQ_SET_ACTION_TRIGGER,
+		.index	= VFIO_PCI_INTX_IRQ_INDEX,
+		.start	= 0,
+		.count	= 1,
+	};
+	trigger.fd = trigger_fd;
+
+	ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &trigger);
+	if (ret < 0) {
+		vfio_dev_err(vdev, "failed to setup VFIO IRQ");
+		goto err_delete_line;
+	}
+
+	unmask.irq = (struct vfio_irq_set) {
+		.argsz	= sizeof(unmask),
+		.flags	= VFIO_IRQ_SET_DATA_EVENTFD | VFIO_IRQ_SET_ACTION_UNMASK,
+		.index	= VFIO_PCI_INTX_IRQ_INDEX,
+		.start	= 0,
+		.count	= 1,
+	};
+	unmask.fd = unmask_fd;
+
+	ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &unmask);
+	if (ret < 0) {
+		vfio_dev_err(vdev, "failed to setup unmask IRQ");
+		goto err_remove_event;
+	}
+
+	return 0;
+
+err_remove_event:
+	/* Remove trigger event */
+	trigger.irq.flags = VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_TRIGGER;
+	trigger.irq.count = 0;
+	ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &trigger);
+
+err_delete_line:
+	irq__del_irqfd(kvm, gsi, trigger_fd);
+
+err_close:
+	close(trigger_fd);
+	close(unmask_fd);
+	return ret;
+}
+
+static int vfio_pci_configure_dev_irqs(struct kvm *kvm, struct vfio_device *vdev)
+{
+	struct vfio_pci_device *pdev = &vdev->pci;
+
+	struct vfio_irq_info irq_info = {
+		.argsz = sizeof(irq_info),
+		.index = VFIO_PCI_INTX_IRQ_INDEX,
+	};
+
+	if (!pdev->hdr.irq_pin) {
+		/* TODO: add MSI support */
+		vfio_dev_err(vdev, "INTx not available, MSI-X not implemented");
+		return -ENOSYS;
+	}
+
+	return vfio_pci_enable_intx(kvm, vdev);
+}
+
+int vfio_pci_setup_device(struct kvm *kvm, struct vfio_device *vdev)
+{
+	int ret;
+
+	ret = vfio_pci_configure_dev_regions(kvm, vdev);
+	if (ret) {
+		vfio_dev_err(vdev, "failed to configure regions");
+		return ret;
+	}
+
+	vdev->dev_hdr = (struct device_header) {
+		.bus_type	= DEVICE_BUS_PCI,
+		.data		= &vdev->pci.hdr,
+	};
+
+	ret = device__register(&vdev->dev_hdr);
+	if (ret) {
+		vfio_dev_err(vdev, "failed to register VFIO device");
+		return ret;
+	}
+
+	ret = vfio_pci_configure_dev_irqs(kvm, vdev);
+	if (ret) {
+		vfio_dev_err(vdev, "failed to configure IRQs");
+		return ret;
+	}
+
+	return 0;
+}
+
+void vfio_pci_teardown_device(struct kvm *kvm, struct vfio_device *vdev)
+{
+	size_t i;
+
+	for (i = 0; i < vdev->info.num_regions; i++)
+		vfio_unmap_region(kvm, &vdev->regions[i]);
+
+	device__unregister(&vdev->dev_hdr);
+}
-- 
2.17.0
