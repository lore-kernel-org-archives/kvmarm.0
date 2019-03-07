From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 14/16] virtio/pci: Make memory and IO BARs independent
Date: Thu,  7 Mar 2019 08:36:15 +0000
Message-ID: <1551947777-13044-15-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E96B4A4C5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EZ-ItyjJg6RC for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0021D4A4AD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:44 -0500 (EST)
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

Currently, callbacks for memory BAR (BAR[1]) sits on the IO BAR, calling
the IO port emulation. This means that BAR[1] needs COMMAND_IO to be
enabled whenever COMMAND_MEMORY is enabled.

Refactor the code so both BARs are indenpendent. Also, unify ioport/mmio
callback arguments so that they all receive a virtio_device.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 virtio/pci.c | 69 ++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 23 deletions(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index 5a6c0d0..32f9824 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -77,7 +77,7 @@ static inline bool virtio_pci__msix_enabled(struct virtio_pci *vpci)
 	return vpci->pci_hdr.msix.ctrl & cpu_to_le16(PCI_MSIX_FLAGS_ENABLE);
 }
 
-static bool virtio_pci__specific_io_in(struct kvm *kvm, struct virtio_device *vdev, u16 port,
+static bool virtio_pci__specific_io_in(struct kvm *kvm, struct virtio_device *vdev,
 					void *data, int size, int offset)
 {
 	u32 config_offset;
@@ -107,21 +107,18 @@ static bool virtio_pci__specific_io_in(struct kvm *kvm, struct virtio_device *vd
 	return false;
 }
 
-static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev,
+				unsigned long bar_offset, void *data, int size)
 {
-	unsigned long offset;
 	bool ret = true;
-	struct virtio_device *vdev;
 	struct virtio_pci *vpci;
 	struct kvm *kvm;
 	u32 val;
 
 	kvm = vcpu->kvm;
-	vdev = ioport->priv;
 	vpci = vdev->virtio;
-	offset = port - vpci->port_addr;
 
-	switch (offset) {
+	switch (bar_offset) {
 	case VIRTIO_PCI_HOST_FEATURES:
 		val = vdev->ops->get_host_features(kvm, vpci->dev);
 		ioport__write32(data, val);
@@ -143,13 +140,24 @@ static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 p
 		vpci->isr = VIRTIO_IRQ_LOW;
 		break;
 	default:
-		ret = virtio_pci__specific_io_in(kvm, vdev, port, data, size, offset);
+		ret = virtio_pci__specific_io_in(kvm, vdev, data, size, bar_offset);
 		break;
 	};
 
 	return ret;
 }
 
+static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+{
+	struct virtio_device *vdev;
+	struct virtio_pci *vpci;
+
+	vdev = ioport->priv;
+	vpci = vdev->virtio;
+
+	return virtio_pci__data_in(vcpu, vdev, port - vpci->port_addr, data, size);
+}
+
 static void update_msix_map(struct virtio_pci *vpci,
 			    struct msix_table *msix_entry, u32 vecnum)
 {
@@ -174,7 +182,7 @@ static void update_msix_map(struct virtio_pci *vpci,
 	irq__update_msix_route(vpci->kvm, gsi, &msix_entry->msg);
 }
 
-static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *vdev, u16 port,
+static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *vdev,
 					void *data, int size, int offset)
 {
 	struct virtio_pci *vpci = vdev->virtio;
@@ -248,21 +256,18 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
 	return false;
 }
 
-static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vdev,
+				 unsigned long bar_offset, void *data, int size)
 {
-	unsigned long offset;
 	bool ret = true;
-	struct virtio_device *vdev;
 	struct virtio_pci *vpci;
 	struct kvm *kvm;
 	u32 val;
 
 	kvm = vcpu->kvm;
-	vdev = ioport->priv;
 	vpci = vdev->virtio;
-	offset = port - vpci->port_addr;
 
-	switch (offset) {
+	switch (bar_offset) {
 	case VIRTIO_PCI_GUEST_FEATURES:
 		val = ioport__read32(data);
 		virtio_set_guest_features(kvm, vdev, vpci->dev, val);
@@ -289,13 +294,26 @@ static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16
 			vdev->ops->notify_status(kvm, vpci->dev, vpci->status);
 		break;
 	default:
-		ret = virtio_pci__specific_io_out(kvm, vdev, port, data, size, offset);
+		ret = virtio_pci__specific_io_out(kvm, vdev, data, size, bar_offset);
 		break;
 	};
 
 	return ret;
 }
 
+static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+{
+	unsigned long offset;
+	struct virtio_device *vdev;
+	struct virtio_pci *vpci;
+
+	vdev = ioport->priv;
+	vpci = vdev->virtio;
+	offset = port - vpci->port_addr;
+
+	return virtio_pci__data_out(vcpu, vdev, offset, data, size);
+}
+
 static struct ioport_operations virtio_pci__io_ops = {
 	.io_in	= virtio_pci__io_in,
 	.io_out	= virtio_pci__io_out,
@@ -305,7 +323,8 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
 					   u64 addr, u8 *data, u32 len,
 					   u8 is_write, void *ptr)
 {
-	struct virtio_pci *vpci = ptr;
+	struct virtio_device *vdev = ptr;
+	struct virtio_pci *vpci = vdev->virtio;
 	struct msix_table *table;
 	int vecnum;
 	size_t offset;
@@ -404,11 +423,15 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
 					 u64 addr, u8 *data, u32 len,
 					 u8 is_write, void *ptr)
 {
-	struct virtio_pci *vpci = ptr;
-	int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
-	u16 port = vpci->port_addr + (addr & (PCI_IO_SIZE - 1));
+	struct virtio_device *vdev = ptr;
+	struct virtio_pci *vpci = vdev->virtio;
 
-	kvm__emulate_io(vcpu, port, data, direction, len, 1);
+	if (!is_write)
+		virtio_pci__data_in(vcpu, vdev, addr - vpci->mmio_addr,
+				    data, len);
+	else
+		virtio_pci__data_out(vcpu, vdev, addr - vpci->mmio_addr,
+				     data, len);
 }
 
 int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
@@ -428,13 +451,13 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 	vpci->mmio_addr = pci_get_io_space_block(PCI_IO_SIZE);
 	r = kvm__register_mmio(kvm, vpci->mmio_addr, PCI_IO_SIZE, false,
-			       virtio_pci__io_mmio_callback, vpci);
+			       virtio_pci__io_mmio_callback, vdev);
 	if (r < 0)
 		goto free_ioport;
 
 	vpci->msix_io_block = pci_get_io_space_block(PCI_IO_SIZE * 2);
 	r = kvm__register_mmio(kvm, vpci->msix_io_block, PCI_IO_SIZE * 2, false,
-			       virtio_pci__msix_mmio_callback, vpci);
+			       virtio_pci__msix_mmio_callback, vdev);
 	if (r < 0)
 		goto free_mmio;
 
-- 
1.9.1
