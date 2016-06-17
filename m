From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v6 14/15] KVM: arm64: implement MSI injection in ITS emulation
Date: Fri, 17 Jun 2016 13:08:46 +0100
Message-ID: <1466165327-32060-15-git-send-email-andre.przywara@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When userland wants to inject a MSI into the guest, it uses the
KVM_SIGNAL_MSI ioctl, which carries the doorbell address along with
the payload and the device ID.
We convert this into an MMIO write to the ITS translation register,
so we can use the knowledge of the kvm_io_bus framework about the
different ITSes and magically end up in the right ITS.
The device ID is combined with the payload into a 64-bit write.
Inside the handler we use our wrapper functions to iterate the linked
lists and find the proper Interrupt Translation Table Entry and thus
the corresponding struct vgic_irq to finally set the pending bit.
We provide a VGIC emulation model specific routine for the actual
MSI injection. The wrapper functions return an error for models not
(yet) implementing MSIs (like the GICv2 emulation).
We also provide the handler for the ITS "INT" command, which allows a
guest to trigger an MSI via the ITS command queue. Since this one knows
about the right ITS already, we directly call the MMIO handler function
without using the kvm_io_bus framework.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 72 +++++++++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h     |  6 ++++
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index c2a4b88..3b7adee 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -451,6 +451,56 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
 	return 0;
 }
 
+static void vgic_mmio_write_its_translater(struct kvm *kvm,
+					   struct vgic_its *its,
+					   gpa_t addr, unsigned int len,
+					   unsigned long val)
+{
+	struct its_itte *itte;
+	u32 data = val & 0xffffffff, devid = val >> 32;
+
+	if (!its->enabled)
+		return;
+
+	mutex_lock(&its->its_lock);
+
+	itte = find_itte(its, devid, data);
+	/* Triggering an unmapped IRQ gets silently dropped. */
+	if (itte && its_is_collection_mapped(itte->collection)) {
+		struct kvm_vcpu *vcpu;
+
+		vcpu = kvm_get_vcpu(kvm, itte->collection->target_addr);
+		if (vcpu && vcpu->arch.vgic_cpu.lpis_enabled) {
+			spin_lock(&itte->irq->irq_lock);
+			itte->irq->pending = true;
+			vgic_queue_irq_put(kvm, itte->irq);
+		}
+	}
+
+	mutex_unlock(&its->its_lock);
+}
+
+/*
+ * Dispatches an incoming MSI request to the KVM IO bus, which will redirect
+ * it for us to the proper ITS and the translation register write handler.
+ */
+int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	u64 address, data;
+
+	if (!vgic_has_its(kvm))
+		return -ENODEV;
+
+	if (!(msi->flags & KVM_MSI_VALID_DEVID))
+		return -EINVAL;
+
+	address = (u64)msi->address_hi << 32 | msi->address_lo;
+	data = msi->data | ((u64)msi->devid << 32);
+
+	return kvm_io_bus_write(kvm_get_vcpu(kvm, 0), KVM_MMIO_BUS,
+				address, 8, &data);
+}
+
 static void its_free_itte(struct kvm *kvm, struct its_itte *itte)
 {
 	list_del(&itte->itte_list);
@@ -869,6 +919,20 @@ static int vits_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	return 0;
 }
 
+#define ITS_DOORBELL_OFFSET (SZ_64K + 0x40)
+/* The INT command injects the LPI associated with that DevID/EvID pair. */
+static int vits_cmd_handle_int(struct kvm *kvm, struct vgic_its *its,
+			       u64 *its_cmd)
+{
+	u64 doorbell = its->vgic_its_base + ITS_DOORBELL_OFFSET;
+	u32 msi_data = its_cmd_get_id(its_cmd);
+	u64 msi_devid = its_cmd_get_deviceid(its_cmd);
+
+	vgic_mmio_write_its_translater(kvm, its, doorbell, 8,
+				       msi_devid << 32 | msi_data);
+	return 0;
+}
+
 /*
  * This function is called with the its_cmd lock held, but the ITS data
  * structure lock dropped. It is within the responsibility of the actual
@@ -905,6 +969,9 @@ static int vits_handle_command(struct kvm *kvm, struct vgic_its *its,
 	case GITS_CMD_MOVALL:
 		ret = vits_cmd_handle_movall(kvm, its, its_cmd);
 		break;
+	case GITS_CMD_INT:
+		ret = vits_cmd_handle_int(kvm, its, its_cmd);
+		break;
 	case GITS_CMD_INV:
 		ret = vits_cmd_handle_inv(kvm, its, its_cmd);
 		break;
@@ -1124,6 +1191,9 @@ struct vgic_register_region its_registers[] = {
 	REGISTER_ITS_DESC(GITS_IDREGS_BASE,
 		vgic_mmio_read_its_idregs, its_mmio_write_wi, 0x30,
 		VGIC_ACCESS_32bit),
+	REGISTER_ITS_DESC(0x10040,
+		its_mmio_read_raz, vgic_mmio_write_its_translater, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 };
 
 /* This is called on setting the LPI enable bit in the redistributor. */
@@ -1145,7 +1215,7 @@ static int vits_register(struct kvm *kvm, struct vgic_its *its)
 	iodev->its = its;
 	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
-				      SZ_64K, &iodev->dev);
+				      SZ_128K, &iodev->dev);
 	mutex_unlock(&kvm->slots_lock);
 
 	return ret;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 8c2105a..26b7a0d 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -84,6 +84,7 @@ bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
 struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
+int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -154,6 +155,11 @@ static inline struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
 static inline void vgic_enable_lpis(struct kvm_vcpu *vcpu)
 {
 }
+
+static inline int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	return -ENODEV;
+}
 #endif
 
 int kvm_register_vgic_device(unsigned long type);
-- 
2.8.2

