From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v7 04/15] MSI-X: update GSI routing after changed MSI-X configuration
Date: Wed, 20 Jul 2016 18:04:24 +0100
Message-ID: <20160720170435.28090-5-andre.przywara@arm.com>
References: <20160720170435.28090-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160720170435.28090-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When we set up GSI routing to map MSIs to KVM's GSI numbers, we
write the current device's MSI setup into the kernel routing table.
However the device driver in the guest can use PCI configuration space
accesses to change the MSI configuration (address and/or payload data).
Whenever this happens after we have setup the routing table already,
we must amend the previously sent data.
So when MSI-X PCI config space accesses write address or payload,
find the associated GSI number and the matching routing table entry
and update the kernel routing table (only if the data has changed).

This fixes vhost-net, where the queue's IRQFD was setup before the
MSI vectors.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/irq.h |  1 +
 irq.c             | 31 +++++++++++++++++++++++++++++++
 virtio/pci.c      | 36 +++++++++++++++++++++++++++++++++---
 3 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/include/kvm/irq.h b/include/kvm/irq.h
index bb71521..f35eb7e 100644
--- a/include/kvm/irq.h
+++ b/include/kvm/irq.h
@@ -21,5 +21,6 @@ int irq__exit(struct kvm *kvm);
 
 int irq__allocate_routing_entry(void);
 int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg);
+void irq__update_msix_route(struct kvm *kvm, u32 gsi, struct msi_msg *msg);
 
 #endif
diff --git a/irq.c b/irq.c
index c4b481c..4386a70 100644
--- a/irq.c
+++ b/irq.c
@@ -89,6 +89,37 @@ int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg)
 	return next_gsi++;
 }
 
+static bool update_data(u32 *ptr, u32 newdata)
+{
+	if (*ptr == newdata)
+		return false;
+
+	*ptr = newdata;
+	return true;
+}
+
+void irq__update_msix_route(struct kvm *kvm, u32 gsi, struct msi_msg *msg)
+{
+	struct kvm_irq_routing_msi *entry;
+	unsigned int i;
+	bool changed;
+
+	for (i = 0; i < irq_routing->nr; i++)
+		if (gsi == irq_routing->entries[i].gsi)
+			break;
+	if (i == irq_routing->nr)
+		return;
+
+	entry = &irq_routing->entries[i].u.msi;
+
+	changed  = update_data(&entry->address_hi, msg->address_hi);
+	changed |= update_data(&entry->address_lo, msg->address_lo);
+	changed |= update_data(&entry->data, msg->data);
+
+	if (changed)
+		ioctl(kvm->vm_fd, KVM_SET_GSI_ROUTING, irq_routing);
+}
+
 int __attribute__((weak)) irq__exit(struct kvm *kvm)
 {
 	free(irq_routing);
diff --git a/virtio/pci.c b/virtio/pci.c
index 072e5b7..b3b4aac 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -152,6 +152,30 @@ static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 p
 	return ret;
 }
 
+static void update_msix_map(struct virtio_pci *vpci,
+			    struct msix_table *msix_entry, u32 vecnum)
+{
+	u32 gsi, i;
+
+	/* Find the GSI number used for that vector */
+	if (vecnum == vpci->config_vector) {
+		gsi = vpci->config_gsi;
+	} else {
+		for (i = 0; i < VIRTIO_PCI_MAX_VQ; i++)
+			if (vpci->vq_vector[i] == vecnum)
+				break;
+		if (i == VIRTIO_PCI_MAX_VQ)
+			return;
+		gsi = vpci->gsis[i];
+	}
+
+	if (gsi == 0)
+		return;
+
+	msix_entry = &msix_entry[vecnum];
+	irq__update_msix_route(vpci->kvm, gsi, &msix_entry->msg);
+}
+
 static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *vdev, u16 port,
 					void *data, int size, int offset)
 {
@@ -270,10 +294,16 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
 		offset	= vpci->msix_io_block;
 	}
 
-	if (is_write)
-		memcpy(table + addr - offset, data, len);
-	else
+	if (!is_write) {
 		memcpy(data, table + addr - offset, len);
+		return;
+	}
+
+	memcpy(table + addr - offset, data, len);
+
+	/* Did we just update the address or payload? */
+	if (addr % 0x10 < 0xc)
+		update_msix_map(vpci, table, (addr - offset) / 16);
 }
 
 static void virtio_pci__signal_msi(struct kvm *kvm, struct virtio_pci *vpci, int vec)
-- 
2.9.0

