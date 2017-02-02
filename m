From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v9 14/15] extend GSI IRQ routing to take a device ID
Date: Thu,  2 Feb 2017 16:32:22 +0000
Message-ID: <20170202163223.15372-15-andre.przywara@arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E19FB40A4E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 11:31:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id neU61TAIYDqo for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Feb 2017 11:31:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CE8A40A7C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 11:31:08 -0500 (EST)
In-Reply-To: <20170202163223.15372-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

For ITS emulation we need the device ID along with the MSI payload
and doorbell address to identify an MSI, so we need to put it in the
GSI IRQ routing table too.
There is a per-VM capability by which the kernel signals the need for
a device ID, so check this and put the device ID into the routing
table if needed.
For PCI devices we take the bus/device/function triplet and and that
to the routing setup call.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 hw/pci-shmem.c    |  3 ++-
 include/kvm/irq.h |  2 +-
 irq.c             | 24 ++++++++++++++++++++++--
 virtio/pci.c      |  6 ++++--
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/hw/pci-shmem.c b/hw/pci-shmem.c
index 7ce98cb..512b5b0 100644
--- a/hw/pci-shmem.c
+++ b/hw/pci-shmem.c
@@ -135,7 +135,8 @@ int pci_shmem__get_local_irqfd(struct kvm *kvm)
 			return fd;
 
 		if (pci_shmem_pci_device.msix.ctrl & cpu_to_le16(PCI_MSIX_FLAGS_ENABLE)) {
-			gsi = irq__add_msix_route(kvm, &msix_table[0].msg);
+			gsi = irq__add_msix_route(kvm, &msix_table[0].msg,
+						  pci_shmem_device.dev_num << 3);
 			if (gsi < 0)
 				return gsi;
 		} else {
diff --git a/include/kvm/irq.h b/include/kvm/irq.h
index f35eb7e..ee059e3 100644
--- a/include/kvm/irq.h
+++ b/include/kvm/irq.h
@@ -20,7 +20,7 @@ int irq__init(struct kvm *kvm);
 int irq__exit(struct kvm *kvm);
 
 int irq__allocate_routing_entry(void);
-int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg);
+int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg, u32 device_id);
 void irq__update_msix_route(struct kvm *kvm, u32 gsi, struct msi_msg *msg);
 
 #endif
diff --git a/irq.c b/irq.c
index 6ec71c3..9ca6b19 100644
--- a/irq.c
+++ b/irq.c
@@ -66,7 +66,21 @@ static bool check_for_irq_routing(struct kvm *kvm)
 	return has_irq_routing > 0;
 }
 
-int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg)
+static bool check_for_msi_devid(struct kvm *kvm)
+{
+	static int needs_devid = 0;
+
+	if (needs_devid == 0) {
+		if (kvm__supports_vm_extension(kvm, KVM_CAP_MSI_DEVID))
+			needs_devid = 1;
+		else
+			needs_devid = -1;
+	}
+
+	return needs_devid > 0;
+}
+
+int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg, u32 device_id)
 {
 	int r;
 
@@ -77,7 +91,7 @@ int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg)
 	if (r)
 		return r;
 
-	irq_routing->entries[irq_routing->nr++] =
+	irq_routing->entries[irq_routing->nr] =
 		(struct kvm_irq_routing_entry) {
 			.gsi = next_gsi,
 			.type = KVM_IRQ_ROUTING_MSI,
@@ -86,6 +100,12 @@ int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg)
 			.u.msi.data = msg->data,
 		};
 
+	if (check_for_msi_devid(kvm)) {
+		irq_routing->entries[irq_routing->nr].flags = KVM_MSI_VALID_DEVID;
+		irq_routing->entries[irq_routing->nr].u.msi.devid = device_id;
+	}
+	irq_routing->nr++;
+
 	r = ioctl(kvm->vm_fd, KVM_SET_GSI_ROUTING, irq_routing);
 	if (r)
 		return r;
diff --git a/virtio/pci.c b/virtio/pci.c
index cecfe8a..b6ef389 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -192,7 +192,8 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
 				break;
 
 			gsi = irq__add_msix_route(kvm,
-						  &vpci->msix_table[vec].msg);
+						  &vpci->msix_table[vec].msg,
+						  vpci->dev_hdr.dev_num << 3);
 			if (gsi >= 0) {
 				vpci->config_gsi = gsi;
 				break;
@@ -210,7 +211,8 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
 				break;
 
 			gsi = irq__add_msix_route(kvm,
-						  &vpci->msix_table[vec].msg);
+						  &vpci->msix_table[vec].msg,
+						  vpci->dev_hdr.dev_num << 3);
 			if (gsi < 0) {
 				if (gsi == -ENXIO &&
 				    vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
-- 
2.9.0
