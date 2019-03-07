From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 05/16] ioport: pci: Move port allocations to PCI
 devices
Date: Thu,  7 Mar 2019 08:36:06 +0000
Message-ID: <1551947777-13044-6-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 485304A4B0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HEbYtlrAmfN9 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:33 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 326394A4CA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:32 -0500 (EST)
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

The dynamic ioport allocation with IOPORT_EMPTY is currently only used
by PCI devices. Other devices use fixed ports for which they request
registration to the ioport API.

PCI ports need to be in the PCI IO space and there is no reason ioport
API should know a PCI port is being allocated and needs to be placed in
PCI IO space. This currently just happens to be the case.

Move the responsability of dynamic allocation of ioports from the ioport
API to PCI.

In the future, if other types of devices also need dynamic ioport
allocation, they'll have to figure out the range of ports they are
allowed to use.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 hw/pci-shmem.c       |  3 ++-
 hw/vesa.c            |  4 ++--
 include/kvm/ioport.h |  3 ---
 include/kvm/pci.h    |  2 ++
 ioport.c             | 18 ------------------
 pci.c                |  8 ++++++++
 vfio/core.c          |  6 ++++--
 virtio/pci.c         |  3 ++-
 8 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/hw/pci-shmem.c b/hw/pci-shmem.c
index f92bc75..a0c5ba8 100644
--- a/hw/pci-shmem.c
+++ b/hw/pci-shmem.c
@@ -357,7 +357,8 @@ int pci_shmem__init(struct kvm *kvm)
 		return 0;
 
 	/* Register MMIO space for MSI-X */
-	r = ioport__register(kvm, IOPORT_EMPTY, &shmem_pci__io_ops, IOPORT_SIZE, NULL);
+	r = pci_get_io_port_block(IOPORT_SIZE);
+	r = ioport__register(kvm, r, &shmem_pci__io_ops, IOPORT_SIZE, NULL);
 	if (r < 0)
 		return r;
 	ivshmem_registers = (u16)r;
diff --git a/hw/vesa.c b/hw/vesa.c
index f3c5114..404a8a3 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -60,8 +60,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 
 	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
 		return NULL;
-
-	r = ioport__register(kvm, IOPORT_EMPTY, &vesa_io_ops, IOPORT_SIZE, NULL);
+	r = pci_get_io_space_block(IOPORT_SIZE);
+	r = ioport__register(kvm, r, &vesa_io_ops, IOPORT_SIZE, NULL);
 	if (r < 0)
 		return ERR_PTR(r);
 
diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
index db52a47..b10fcd5 100644
--- a/include/kvm/ioport.h
+++ b/include/kvm/ioport.h
@@ -14,11 +14,8 @@
 
 /* some ports we reserve for own use */
 #define IOPORT_DBG			0xe0
-#define IOPORT_START			0x6200
 #define IOPORT_SIZE			0x400
 
-#define IOPORT_EMPTY			USHRT_MAX
-
 struct kvm;
 
 struct ioport {
diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index a86c15a..bdbd183 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -19,6 +19,7 @@
 #define PCI_CONFIG_DATA		0xcfc
 #define PCI_CONFIG_BUS_FORWARD	0xcfa
 #define PCI_IO_SIZE		0x100
+#define PCI_IOPORT_START	0x6200
 #define PCI_CFG_SIZE		(1ULL << 24)
 
 struct kvm;
@@ -153,6 +154,7 @@ int pci__init(struct kvm *kvm);
 int pci__exit(struct kvm *kvm);
 struct pci_device_header *pci__find_dev(u8 dev_num);
 u32 pci_get_io_space_block(u32 size);
+u16 pci_get_io_port_block(u32 size);
 void pci__assign_irq(struct device_header *dev_hdr);
 void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size);
 void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size);
diff --git a/ioport.c b/ioport.c
index a6dc65e..a72e403 100644
--- a/ioport.c
+++ b/ioport.c
@@ -16,24 +16,8 @@
 
 #define ioport_node(n) rb_entry(n, struct ioport, node)
 
-DEFINE_MUTEX(ioport_mutex);
-
-static u16			free_io_port_idx; /* protected by ioport_mutex */
-
 static struct rb_root		ioport_tree = RB_ROOT;
 
-static u16 ioport__find_free_port(void)
-{
-	u16 free_port;
-
-	mutex_lock(&ioport_mutex);
-	free_port = IOPORT_START + free_io_port_idx * IOPORT_SIZE;
-	free_io_port_idx++;
-	mutex_unlock(&ioport_mutex);
-
-	return free_port;
-}
-
 static struct ioport *ioport_search(struct rb_root *root, u64 addr)
 {
 	struct rb_int_node *node;
@@ -85,8 +69,6 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 	int r;
 
 	br_write_lock(kvm);
-	if (port == IOPORT_EMPTY)
-		port = ioport__find_free_port();
 
 	entry = ioport_search(&ioport_tree, port);
 	if (entry) {
diff --git a/pci.c b/pci.c
index 9edefa5..cd749db 100644
--- a/pci.c
+++ b/pci.c
@@ -19,6 +19,14 @@ static u32 pci_config_address_bits;
  * PCI isn't currently supported.)
  */
 static u32 io_space_blocks		= KVM_PCI_MMIO_AREA;
+static u16 io_port_blocks		= PCI_IOPORT_START;
+
+u16 pci_get_io_port_block(u32 size)
+{
+	u16 port = ALIGN(io_port_blocks, IOPORT_SIZE);
+	io_port_blocks = port + size;
+	return port;
+}
 
 /*
  * BARs must be naturally aligned, so enforce this in the allocator.
diff --git a/vfio/core.c b/vfio/core.c
index 17b5b0c..0ed1e6f 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -202,8 +202,10 @@ static int vfio_setup_trap_region(struct kvm *kvm, struct vfio_device *vdev,
 				  struct vfio_region *region)
 {
 	if (region->is_ioport) {
-		int port = ioport__register(kvm, IOPORT_EMPTY, &vfio_ioport_ops,
-					    region->info.size, region);
+		int port = pci_get_io_port_block(region->info.size);
+
+		port = ioport__register(kvm, port, &vfio_ioport_ops,
+					region->info.size, region);
 		if (port < 0)
 			return port;
 
diff --git a/virtio/pci.c b/virtio/pci.c
index 5a5fc6e..c8e16dd 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -420,7 +420,8 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	vpci->kvm = kvm;
 	vpci->dev = dev;
 
-	r = ioport__register(kvm, IOPORT_EMPTY, &virtio_pci__io_ops, IOPORT_SIZE, vdev);
+	r = pci_get_io_port_block(IOPORT_SIZE);
+	r = ioport__register(kvm, r, &virtio_pci__io_ops, IOPORT_SIZE, vdev);
 	if (r < 0)
 		return r;
 	vpci->port_addr = (u16)r;
-- 
1.9.1
