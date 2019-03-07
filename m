From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 15/16] virtio/pci: update virtio mapping when PCI BARs
 are reconfigured
Date: Thu,  7 Mar 2019 08:36:16 +0000
Message-ID: <1551947777-13044-16-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60F514A48E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1i0Ro-FsSQlU for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:46 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EB5A4A4C3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:46 -0500 (EST)
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

Software can change the addresses of PCI BARs. In the case of virtio, the
BARs are associated with some IO ports or mmio regions. These are not
updated when the guest modifies PCI BARs, leading to some surprises.

Re-register the ports and mmio regions related to PCI BARs when they are
updated.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 include/kvm/virtio-pci.h |   1 +
 virtio/pci.c             | 153 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 144 insertions(+), 10 deletions(-)

diff --git a/include/kvm/virtio-pci.h b/include/kvm/virtio-pci.h
index b70cadd..37ffe02 100644
--- a/include/kvm/virtio-pci.h
+++ b/include/kvm/virtio-pci.h
@@ -23,6 +23,7 @@ struct virtio_pci {
 	struct device_header	dev_hdr;
 	void			*dev;
 	struct kvm		*kvm;
+	struct virtio_device	*vdev;
 
 	u16			port_addr;
 	u32			mmio_addr;
diff --git a/virtio/pci.c b/virtio/pci.c
index 32f9824..1275d82 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -434,6 +434,132 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
 				     data, len);
 }
 
+static inline int virtio_pci__register_io(struct kvm *kvm,
+					  struct virtio_pci *vpci)
+{
+	int r;
+
+	r = ioport__register(kvm, vpci->port_addr, &virtio_pci__io_ops,
+			     PCI_IO_SIZE, vpci->vdev);
+	if (r < 0)
+		pr_warning("failed to register io port virtio_pci bar[0]: 0x%x, err: %d\n",
+			   (u32) vpci->port_addr, r);
+
+	return r;
+}
+
+static inline int virtio_pci__register_mmio(struct kvm *kvm,
+					    struct virtio_pci *vpci)
+{
+	int r;
+
+	r = kvm__register_mmio(kvm, vpci->mmio_addr, PCI_IO_SIZE, false,
+			       virtio_pci__io_mmio_callback, vpci->vdev);
+	if (r < 0)
+		pr_warning("failed to register mmio virtio_pci bar[1]: 0x%x, err: %d\n",
+			   vpci->mmio_addr, r);
+
+	return r;
+}
+
+static inline int virtio_pci__register_msix(struct kvm *kvm,
+					    struct virtio_pci *vpci)
+{
+	int r;
+
+	r = kvm__register_mmio(kvm, vpci->msix_io_block,
+			       PCI_IO_SIZE * 2, false,
+			       virtio_pci__msix_mmio_callback,
+			       vpci->vdev);
+	if (r < 0)
+		pr_warning("failed to register mmio virtio_pci bar[2]: 0x%x, err: %d\n",
+			   vpci->msix_io_block, r);
+
+	return r;
+}
+
+static void virtio_pci__config_write(struct kvm *kvm,
+				     struct pci_device_header *pci_hdr,
+				     u8 offset, void *data, int sz)
+{
+	struct virtio_pci *vpci;
+
+	vpci = container_of(pci_hdr, struct virtio_pci, pci_hdr);
+
+	switch (offset) {
+	case PCI_COMMAND:
+	{
+		u16 cmd;
+
+		if (sz != 2)
+			die("unsupported size for pci command access");
+
+		cmd = ioport__read16(data);
+
+		/* Enable I/O response? */
+		if (cmd & PCI_COMMAND_IO
+		    && !(pci_hdr->command & PCI_COMMAND_IO))
+			virtio_pci__register_io(kvm, vpci);
+
+		/* Enable mmio response? */
+		if (cmd & PCI_COMMAND_MEMORY
+		    && !(pci_hdr->command & PCI_COMMAND_MEMORY)) {
+			virtio_pci__register_mmio(kvm, vpci);
+			virtio_pci__register_msix(kvm, vpci);
+		}
+
+		/* Disable mmio response? */
+		if (!(cmd & PCI_COMMAND_MEMORY)
+			   && pci_hdr->command & PCI_COMMAND_MEMORY) {
+			kvm__deregister_mmio(kvm, vpci->msix_io_block);
+			kvm__deregister_mmio(kvm, vpci->mmio_addr);
+		}
+
+		/* Disable I/O response? */
+		if (!(cmd & PCI_COMMAND_IO)
+		    && pci_hdr->command & PCI_COMMAND_IO)
+			ioport__unregister(kvm, vpci->port_addr);
+
+		break;
+	}
+	case PCI_BASE_ADDRESS_0:
+		if (sz != 4)
+			die("unsupported size for pci bar[0] access");
+
+		if (pci_hdr->command & PCI_COMMAND_IO)
+			ioport__unregister(kvm, vpci->port_addr);
+
+		vpci->port_addr = ioport__read32(data) & 0xFFFF;
+
+		vpci->port_addr &= PCI_BASE_ADDRESS_IO_MASK;
+
+		if (pci_hdr->command & PCI_COMMAND_IO)
+			virtio_pci__register_io(kvm, vpci);
+		break;
+	case PCI_BASE_ADDRESS_1:
+		if (pci_hdr->command & PCI_COMMAND_MEMORY)
+			kvm__deregister_mmio(kvm, vpci->mmio_addr);
+
+		vpci->mmio_addr = ioport__read32(data) & PCI_BASE_ADDRESS_MEM_MASK;
+
+		if (pci_hdr->command & PCI_COMMAND_MEMORY)
+			virtio_pci__register_mmio(kvm, vpci);
+		break;
+	case PCI_BASE_ADDRESS_2:
+		if (pci_hdr->command & PCI_COMMAND_MEMORY)
+			kvm__deregister_mmio(kvm, vpci->msix_io_block);
+
+		vpci->msix_io_block = ioport__read32(data) & PCI_BASE_ADDRESS_MEM_MASK;
+
+		if (pci_hdr->command & PCI_COMMAND_MEMORY)
+			virtio_pci__register_msix(kvm, vpci);
+		break;
+	default:
+		/* Default PCI config code is enough */
+		break;
+	}
+}
+
 int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		     int device_id, int subsys_id, int class)
 {
@@ -442,22 +568,20 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 	vpci->kvm = kvm;
 	vpci->dev = dev;
+	vpci->vdev = vdev;
 
-	r = pci_get_io_port_block(PCI_IO_SIZE);
-	r = ioport__register(kvm, r, &virtio_pci__io_ops, PCI_IO_SIZE, vdev);
+	vpci->port_addr = pci_get_io_port_block(PCI_IO_SIZE);
+	r = virtio_pci__register_io(kvm, vpci);
 	if (r < 0)
 		return r;
-	vpci->port_addr = (u16)r;
 
 	vpci->mmio_addr = pci_get_io_space_block(PCI_IO_SIZE);
-	r = kvm__register_mmio(kvm, vpci->mmio_addr, PCI_IO_SIZE, false,
-			       virtio_pci__io_mmio_callback, vdev);
+	r = virtio_pci__register_mmio(kvm, vpci);
 	if (r < 0)
 		goto free_ioport;
 
 	vpci->msix_io_block = pci_get_io_space_block(PCI_IO_SIZE * 2);
-	r = kvm__register_mmio(kvm, vpci->msix_io_block, PCI_IO_SIZE * 2, false,
-			       virtio_pci__msix_mmio_callback, vdev);
+	r = virtio_pci__register_msix(kvm, vpci);
 	if (r < 0)
 		goto free_mmio;
 
@@ -485,6 +609,10 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
 	};
 
+	vpci->pci_hdr.cfg_ops = (struct pci_config_operations) {
+		.write	= virtio_pci__config_write,
+	};
+
 	vpci->dev_hdr = (struct device_header) {
 		.bus_type		= DEVICE_BUS_PCI,
 		.data			= &vpci->pci_hdr,
@@ -534,11 +662,16 @@ free_ioport:
 int virtio_pci__exit(struct kvm *kvm, struct virtio_device *vdev)
 {
 	struct virtio_pci *vpci = vdev->virtio;
+	struct pci_device_header *pci_hdr = &vpci->pci_hdr;
 	int i;
 
-	kvm__deregister_mmio(kvm, vpci->mmio_addr);
-	kvm__deregister_mmio(kvm, vpci->msix_io_block);
-	ioport__unregister(kvm, vpci->port_addr);
+	if (pci_hdr->command & PCI_COMMAND_MEMORY) {
+		kvm__deregister_mmio(kvm, vpci->mmio_addr);
+		kvm__deregister_mmio(kvm, vpci->msix_io_block);
+	}
+
+	if (pci_hdr->command & PCI_COMMAND_IO)
+		ioport__unregister(kvm, vpci->port_addr);
 
 	for (i = 0; i < VIRTIO_PCI_MAX_VQ; i++) {
 		ioeventfd__del_event(vpci->port_addr + VIRTIO_PCI_QUEUE_NOTIFY, i);
-- 
1.9.1
