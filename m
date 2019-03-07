From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 13/16] vfio: Add support for BAR configuration
Date: Thu,  7 Mar 2019 08:36:14 +0000
Message-ID: <1551947777-13044-14-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61C204A4C6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XdwnUkgb3NB3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:44 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 958C74A4D5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:43 -0500 (EST)
In-Reply-To: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Andre.Przywara@arm.com, Sami.Mujawar@arm.com, will.deacon@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When a guest can reassign BARs, kvmtool needs to maintain the vfio_region
consistent with their corresponding BARs. Take the new updated addresses
from the PCI header read back from the vfio driver.

Also, to modify the BARs, it is expected that guests will disable
IO/Memory response in the PCI command. Support this by mapping/unmapping
regions when the corresponding response gets enabled/disabled.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 vfio/core.c |  8 +++---
 vfio/pci.c  | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/vfio/core.c b/vfio/core.c
index 0ed1e6f..b554897 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -202,14 +202,13 @@ static int vfio_setup_trap_region(struct kvm *kvm, struct vfio_device *vdev,
 				  struct vfio_region *region)
 {
 	if (region->is_ioport) {
-		int port = pci_get_io_port_block(region->info.size);
+		int port = ioport__register(kvm, region->port_base,
+					    &vfio_ioport_ops,
+					    region->info.size, region);
 
-		port = ioport__register(kvm, port, &vfio_ioport_ops,
-					region->info.size, region);
 		if (port < 0)
 			return port;
 
-		region->port_base = port;
 		return 0;
 	}
 
@@ -258,6 +257,7 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
 {
 	if (region->host_addr) {
 		munmap(region->host_addr, region->info.size);
+		region->host_addr = NULL;
 	} else if (region->is_ioport) {
 		ioport__unregister(kvm, region->port_base);
 	} else {
diff --git a/vfio/pci.c b/vfio/pci.c
index 03de3c1..474f1c1 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -1,3 +1,4 @@
+#include "kvm/ioport.h"
 #include "kvm/irq.h"
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
@@ -452,6 +453,64 @@ static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr
 			      sz, offset);
 }
 
+static void vfio_pci_cfg_handle_command(struct kvm *kvm, struct vfio_device *vdev,
+					void *data, int sz)
+{
+	struct pci_device_header *hdr = &vdev->pci.hdr;
+	bool switch_io;
+	bool switch_mem;
+	u16 cmd;
+	int i;
+
+	cmd = ioport__read16(data);
+	switch_io = !!((cmd ^ hdr->command) & PCI_COMMAND_IO);
+	switch_mem = !!((cmd ^ hdr->command) & PCI_COMMAND_MEMORY);
+
+	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
+		struct vfio_region *region = &vdev->regions[i];
+
+		if (region->is_ioport && switch_io) {
+			if (cmd & PCI_COMMAND_IO)
+				vfio_map_region(kvm, vdev, region);
+			else
+				vfio_unmap_region(kvm, region);
+		}
+
+		if (!region->is_ioport && switch_mem) {
+			if (cmd & PCI_COMMAND_MEMORY)
+				vfio_map_region(kvm, vdev, region);
+			else
+				vfio_unmap_region(kvm, region);
+		}
+	}
+}
+
+static void vfio_pci_cfg_update_bar(struct kvm *kvm, struct vfio_device *vdev, int bar)
+{
+	struct pci_device_header *hdr = &vdev->pci.hdr;
+	struct vfio_region *bar_region;
+
+	bar_region = &vdev->regions[bar + VFIO_PCI_BAR0_REGION_INDEX];
+
+	if (bar_region->is_ioport) {
+		if (hdr->command & PCI_COMMAND_IO)
+			vfio_unmap_region(kvm, bar_region);
+
+		bar_region->port_base = hdr->bar[bar] & PCI_BASE_ADDRESS_IO_MASK;
+
+		if (hdr->command & PCI_COMMAND_IO)
+			vfio_map_region(kvm, vdev, bar_region);
+	} else {
+		if (hdr->command & PCI_COMMAND_MEMORY)
+			vfio_unmap_region(kvm, bar_region);
+
+		bar_region->guest_phys_addr = hdr->bar[bar] & PCI_BASE_ADDRESS_MEM_MASK;
+
+		if (hdr->command & PCI_COMMAND_MEMORY)
+			vfio_map_region(kvm, vdev, bar_region);
+	}
+}
+
 static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hdr,
 			       u8 offset, void *data, int sz)
 {
@@ -475,9 +534,15 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
 	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSI)
 		vfio_pci_msi_cap_write(kvm, vdev, offset, data, sz);
 
+	if (offset == PCI_COMMAND)
+		vfio_pci_cfg_handle_command(kvm, vdev, data, sz);
+
 	if (pread(vdev->fd, base + offset, sz, info->offset + offset) != sz)
 		vfio_dev_warn(vdev, "Failed to read %d bytes from Configuration Space at 0x%x",
 			      sz, offset);
+
+	if (offset >= PCI_BASE_ADDRESS_0 && offset <= PCI_BASE_ADDRESS_5)
+		vfio_pci_cfg_update_bar(kvm, vdev, offset - PCI_BASE_ADDRESS_0);
 }
 
 static ssize_t vfio_pci_msi_cap_size(struct msi_cap_64 *cap_hdr)
@@ -801,6 +866,7 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 	size_t map_size;
 	struct vfio_pci_device *pdev = &vdev->pci;
 	struct vfio_region *region = &vdev->regions[nr];
+	bool map_now;
 
 	if (nr >= vdev->info.num_regions)
 		return 0;
@@ -840,12 +906,20 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 		/* Grab some MMIO space in the guest */
 		map_size = ALIGN(region->info.size, PAGE_SIZE);
 		region->guest_phys_addr = pci_get_io_space_block(map_size);
+
+		map_now = pdev->hdr.command & PCI_COMMAND_MEMORY;
+	} else {
+		region->port_base = pci_get_io_port_block(region->info.size);
+
+		map_now = pdev->hdr.command & PCI_COMMAND_IO;
 	}
 
-	/* Map the BARs into the guest or setup a trap region. */
-	ret = vfio_map_region(kvm, vdev, region);
-	if (ret)
-		return ret;
+	if (map_now) {
+		/* Map the BARs into the guest or setup a trap region. */
+		ret = vfio_map_region(kvm, vdev, region);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
-- 
1.9.1
