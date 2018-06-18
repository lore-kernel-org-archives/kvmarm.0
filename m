From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 11/13] vfio: Support non-mmappable regions
Date: Mon, 18 Jun 2018 19:42:09 +0100
Message-ID: <20180618184211.43904-12-jean-philippe.brucker@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 502A84A0D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:32:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bon4hjWl2k3e for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AAFB4A0E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:43 -0400 (EDT)
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

In some cases device regions don't support mmap. They can still be made
available to the guest by trapping all accesses and forwarding reads or
writes to VFIO. Such regions may be:

* PCI I/O port BARs.
* Sub-page regions, for example a 4kB region on a host with 64k pages.
* Similarly, sparse mmap regions. For example when VFIO allows to mmap
  fragments of a PCI BAR and forbids accessing things like MSI-X tables.
  We don't support the sparse capability at the moment, so trap these
  regions instead (if VFIO rejects the mmap).

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/vfio.h |   3 +
 vfio/core.c        | 165 ++++++++++++++++++++++++++++++++++++++++-----
 vfio/pci.c         |  41 ++++++-----
 3 files changed, 176 insertions(+), 33 deletions(-)

diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
index 2c621ec75..60e6c54d6 100644
--- a/include/kvm/vfio.h
+++ b/include/kvm/vfio.h
@@ -83,8 +83,11 @@ struct vfio_pci_device {
 
 struct vfio_region {
 	struct vfio_region_info		info;
+	struct vfio_device		*vdev;
 	u64				guest_phys_addr;
 	void				*host_addr;
+	u32				port_base;
+	int				is_ioport	:1;
 };
 
 struct vfio_device {
diff --git a/vfio/core.c b/vfio/core.c
index 6c78e89f1..a4a257a70 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -1,5 +1,6 @@
 #include "kvm/kvm.h"
 #include "kvm/vfio.h"
+#include "kvm/ioport.h"
 
 #include <linux/list.h>
 
@@ -80,6 +81,141 @@ out_free_buf:
 	return ret;
 }
 
+static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
+			   u16 port, void *data, int len)
+{
+	u32 val;
+	ssize_t nr;
+	struct vfio_region *region = ioport->priv;
+	struct vfio_device *vdev = region->vdev;
+
+	u32 offset = port - region->port_base;
+
+	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_READ))
+		return false;
+
+	nr = pread(vdev->fd, &val, len, region->info.offset + offset);
+	if (nr != len) {
+		vfio_dev_err(vdev, "could not read %d bytes from I/O port 0x%x\n",
+			     len, port);
+		return false;
+	}
+
+	switch (len) {
+	case 1:
+		ioport__write8(data, val);
+		break;
+	case 2:
+		ioport__write16(data, val);
+		break;
+	case 4:
+		ioport__write32(data, val);
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
+static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
+			    u16 port, void *data, int len)
+{
+	u32 val;
+	ssize_t nr;
+	struct vfio_region *region = ioport->priv;
+	struct vfio_device *vdev = region->vdev;
+
+	u32 offset = port - region->port_base;
+
+	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_WRITE))
+		return false;
+
+	switch (len) {
+	case 1:
+		val = ioport__read8(data);
+		break;
+	case 2:
+		val = ioport__read16(data);
+		break;
+	case 4:
+		val = ioport__read32(data);
+		break;
+	default:
+		return false;
+	}
+
+	nr = pwrite(vdev->fd, &val, len, region->info.offset + offset);
+	if (nr != len)
+		vfio_dev_err(vdev, "could not write %d bytes to I/O port 0x%x",
+			     len, port);
+
+	return nr == len;
+}
+
+static struct ioport_operations vfio_ioport_ops = {
+	.io_in	= vfio_ioport_in,
+	.io_out	= vfio_ioport_out,
+};
+
+static void vfio_mmio_access(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
+			     u8 is_write, void *ptr)
+{
+	u64 val;
+	ssize_t nr;
+	struct vfio_region *region = ptr;
+	struct vfio_device *vdev = region->vdev;
+
+	u32 offset = addr - region->guest_phys_addr;
+
+	if (len < 1 || len > 8)
+		goto err_report;
+
+	if (is_write) {
+		if (!(region->info.flags & VFIO_REGION_INFO_FLAG_WRITE))
+			goto err_report;
+
+		memcpy(&val, data, len);
+
+		nr = pwrite(vdev->fd, &val, len, region->info.offset + offset);
+		if ((u32)nr != len)
+			goto err_report;
+	} else {
+		if (!(region->info.flags & VFIO_REGION_INFO_FLAG_READ))
+			goto err_report;
+
+		nr = pread(vdev->fd, &val, len, region->info.offset + offset);
+		if ((u32)nr != len)
+			goto err_report;
+
+		memcpy(data, &val, len);
+	}
+
+	return;
+
+err_report:
+	vfio_dev_err(vdev, "could not %s %u bytes at 0x%x (0x%llx)", is_write ?
+		     "write" : "read", len, offset, addr);
+}
+
+static int vfio_setup_trap_region(struct kvm *kvm, struct vfio_device *vdev,
+				  struct vfio_region *region)
+{
+	if (region->is_ioport) {
+		int port = ioport__register(kvm, IOPORT_EMPTY, &vfio_ioport_ops,
+					    region->info.size, region);
+		if (port < 0)
+			return port;
+
+		region->port_base = port;
+		return 0;
+	}
+
+	return kvm__register_mmio(kvm, region->guest_phys_addr,
+				  region->info.size, false, vfio_mmio_access,
+				  region);
+}
+
 int vfio_map_region(struct kvm *kvm, struct vfio_device *vdev,
 		    struct vfio_region *region)
 {
@@ -88,17 +224,8 @@ int vfio_map_region(struct kvm *kvm, struct vfio_device *vdev,
 	/* KVM needs page-aligned regions */
 	u64 map_size = ALIGN(region->info.size, PAGE_SIZE);
 
-	/*
-	 * We don't want to mess about trapping config accesses, so require that
-	 * they can be mmap'd. Note that for PCI, this precludes the use of I/O
-	 * BARs in the guest (we will hide them from Configuration Space, which
-	 * is trapped).
-	 */
-	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_MMAP)) {
-		vfio_dev_info(vdev, "ignoring region %u, as it can't be mmap'd",
-			      region->info.index);
-		return 0;
-	}
+	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_MMAP))
+		return vfio_setup_trap_region(kvm, vdev, region);
 
 	if (region->info.flags & VFIO_REGION_INFO_FLAG_READ)
 		prot |= PROT_READ;
@@ -108,10 +235,10 @@ int vfio_map_region(struct kvm *kvm, struct vfio_device *vdev,
 	base = mmap(NULL, region->info.size, prot, MAP_SHARED, vdev->fd,
 		    region->info.offset);
 	if (base == MAP_FAILED) {
-		ret = -errno;
-		vfio_dev_err(vdev, "failed to mmap region %u (0x%llx bytes)",
-			     region->info.index, region->info.size);
-		return ret;
+		/* TODO: support sparse mmap */
+		vfio_dev_warn(vdev, "failed to mmap region %u (0x%llx bytes), falling back to trapping",
+			 region->info.index, region->info.size);
+		return vfio_setup_trap_region(kvm, vdev, region);
 	}
 	region->host_addr = base;
 
@@ -127,7 +254,13 @@ int vfio_map_region(struct kvm *kvm, struct vfio_device *vdev,
 
 void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
 {
-	munmap(region->host_addr, region->info.size);
+	if (region->host_addr) {
+		munmap(region->host_addr, region->info.size);
+	} else if (region->is_ioport) {
+		ioport__unregister(kvm, region->port_base);
+	} else {
+		kvm__deregister_mmio(kvm, region->guest_phys_addr);
+	}
 }
 
 static int vfio_configure_device(struct kvm *kvm, struct vfio_device *vdev)
diff --git a/vfio/pci.c b/vfio/pci.c
index 3ed07fb43..03de3c113 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -640,24 +640,27 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
 	struct vfio_region_info *info;
 	struct vfio_pci_device *pdev = &vdev->pci;
 
-	/* Enable exclusively MMIO and bus mastering */
-	pdev->hdr.command &= ~PCI_COMMAND_IO;
-	pdev->hdr.command |= PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER;
-
 	/* Initialise the BARs */
 	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
+		u64 base;
 		struct vfio_region *region = &vdev->regions[i];
-		u64 base = region->guest_phys_addr;
+
+		/* Construct a fake reg to match what we've mapped. */
+		if (region->is_ioport) {
+			base = (region->port_base & PCI_BASE_ADDRESS_IO_MASK) |
+				PCI_BASE_ADDRESS_SPACE_IO;
+		} else {
+			base = (region->guest_phys_addr &
+				PCI_BASE_ADDRESS_MEM_MASK) |
+				PCI_BASE_ADDRESS_SPACE_MEMORY;
+		}
+
+		pdev->hdr.bar[i] = base;
 
 		if (!base)
 			continue;
 
 		pdev->hdr.bar_size[i] = region->info.size;
-
-		/* Construct a fake reg to match what we've mapped. */
-		pdev->hdr.bar[i] = (base & PCI_BASE_ADDRESS_MEM_MASK) |
-					PCI_BASE_ADDRESS_SPACE_MEMORY |
-					PCI_BASE_ADDRESS_MEM_TYPE_32;
 	}
 
 	/* I really can't be bothered to support cardbus. */
@@ -794,6 +797,7 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 				  size_t nr)
 {
 	int ret;
+	u32 bar;
 	size_t map_size;
 	struct vfio_pci_device *pdev = &vdev->pci;
 	struct vfio_region *region = &vdev->regions[nr];
@@ -801,6 +805,10 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 	if (nr >= vdev->info.num_regions)
 		return 0;
 
+	bar = pdev->hdr.bar[nr];
+
+	region->vdev = vdev;
+	region->is_ioport = !!(bar & PCI_BASE_ADDRESS_SPACE_IO);
 	region->info = (struct vfio_region_info) {
 		.argsz = sizeof(region->info),
 		.index = nr,
@@ -828,14 +836,13 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 		}
 	}
 
-	/* Grab some MMIO space in the guest */
-	map_size = ALIGN(region->info.size, PAGE_SIZE);
-	region->guest_phys_addr = pci_get_io_space_block(map_size);
+	if (!region->is_ioport) {
+		/* Grab some MMIO space in the guest */
+		map_size = ALIGN(region->info.size, PAGE_SIZE);
+		region->guest_phys_addr = pci_get_io_space_block(map_size);
+	}
 
-	/*
-	 * Map the BARs into the guest. We'll later need to update
-	 * configuration space to reflect our allocation.
-	 */
+	/* Map the BARs into the guest or setup a trap region. */
 	ret = vfio_map_region(kvm, vdev, region);
 	if (ret)
 		return ret;
-- 
2.17.0
