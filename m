From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v8 16/17] KVM: arm64: implement MSI injection in ITS emulation
Date: Tue,  5 Jul 2016 12:23:08 +0100
Message-ID: <20160705112309.28877-17-andre.przywara@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160705112309.28877-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>
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
 virt/kvm/arm/vgic/vgic-its.c | 70 ++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h     |  6 ++++
 2 files changed, 76 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 432daed..79a1b80 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -423,6 +423,61 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
 	return 0;
 }
 
+static void vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
+				 u32 devid, u32 eventid)
+{
+	struct its_itte *itte;
+
+	if (!its->enabled)
+		return;
+
+	mutex_lock(&its->its_lock);
+
+	itte = find_itte(its, devid, eventid);
+	/* Triggering an unmapped IRQ gets silently dropped. */
+	if (itte && its_is_collection_mapped(itte->collection)) {
+		struct kvm_vcpu *vcpu;
+
+		vcpu = kvm_get_vcpu(kvm, itte->collection->target_addr);
+		if (vcpu && vcpu->arch.vgic_cpu.lpis_enabled) {
+			spin_lock(&itte->irq->irq_lock);
+			itte->irq->pending = true;
+			vgic_queue_irq_unlock(kvm, itte->irq);
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
+int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	u64 address;
+	struct kvm_io_device *kvm_io_dev;
+	struct vgic_io_device *iodev;
+
+	if (!vgic_has_its(kvm))
+		return -ENODEV;
+
+	if (!(msi->flags & KVM_MSI_VALID_DEVID))
+		return -EINVAL;
+
+	address = (u64)msi->address_hi << 32 | msi->address_lo;
+	address -= SZ_64K;
+
+	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
+	if (!kvm_io_dev)
+		return -ENODEV;
+
+	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
+	vgic_its_trigger_msi(kvm, iodev->its, msi->devid, msi->data);
+
+	return 0;
+}
+
 /* Requires the its_lock to be held. */
 static void its_free_itte(struct kvm *kvm, struct its_itte *itte)
 {
@@ -855,6 +910,18 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	return 0;
 }
 
+/* The INT command injects the LPI associated with that DevID/EvID pair. */
+static int vgic_its_cmd_handle_int(struct kvm *kvm, struct vgic_its *its,
+			       u64 *its_cmd)
+{
+	u32 msi_data = its_cmd_get_id(its_cmd);
+	u64 msi_devid = its_cmd_get_deviceid(its_cmd);
+
+	vgic_its_trigger_msi(kvm, its, msi_devid, msi_data);
+
+	return 0;
+}
+
 /*
  * This function is called with the its_cmd lock held, but the ITS data
  * structure lock dropped. It is within the responsibility of the actual
@@ -891,6 +958,9 @@ static int vgic_its_handle_command(struct kvm *kvm, struct vgic_its *its,
 	case GITS_CMD_MOVALL:
 		ret = vgic_its_cmd_handle_movall(kvm, its, its_cmd);
 		break;
+	case GITS_CMD_INT:
+		ret = vgic_its_cmd_handle_int(kvm, its, its_cmd);
+		break;
 	case GITS_CMD_INV:
 		ret = vgic_its_cmd_handle_inv(kvm, its, its_cmd);
 		break;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 4a9165f..b3e5678 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -81,6 +81,7 @@ bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
 struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
+int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -151,6 +152,11 @@ static inline struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
 static inline void vgic_enable_lpis(struct kvm_vcpu *vcpu)
 {
 }
+
+static inline int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	return -ENODEV;
+}
 #endif
 
 int kvm_register_vgic_device(unsigned long type);
-- 
2.9.0

