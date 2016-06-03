From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 12/13] KVM: arm64: implement MSI injection in ITS emulation
Date: Fri,  3 Jun 2016 15:02:51 +0100
Message-ID: <1464962572-3925-13-git-send-email-andre.przywara@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When userland wants to inject a MSI into the guest, we have to use
our data structures to find the LPI number and the VCPU to receive
the interrupt.
Use the wrapper functions to iterate the linked lists and find the
proper Interrupt Translation Table Entry. Then set the pending bit
in this ITTE to be later picked up by the LR handling code. Kick
the VCPU which is meant to handle this interrupt.
We provide a VGIC emulation model specific routine for the actual
MSI injection. The wrapper functions return an error for models not
(yet) implementing MSIs (like the GICv2 emulation).
We also provide the handler for the ITS "INT" command, which allows a
guest to trigger an MSI via the ITS command queue.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 85 ++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h     |  6 ++++
 2 files changed, 91 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 72145c1..c257b08 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -46,6 +46,16 @@ static struct vgic_its *find_its(struct kvm *kvm, gpa_t base_address)
 	return NULL;
 }
 
+#define ITS_DOORBELL_OFFSET (SZ_64K + 0x40)
+static struct vgic_its *find_its_doorbell(struct kvm *kvm, gpa_t doorbell)
+{
+	/*
+	 * The actual doorbell address is in the second page of the ITS
+	 * frame, at offset 0x40.
+	 */
+	return find_its(kvm, doorbell - ITS_DOORBELL_OFFSET);
+}
+
 struct its_device {
 	struct list_head dev_list;
 
@@ -363,6 +373,61 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/*
+ * Translates an incoming MSI request into the redistributor (=VCPU) and
+ * the associated LPI number. Sets the LPI pending bit and also marks the
+ * VCPU as having a pending interrupt.
+ */
+int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	struct vgic_its *its;
+	struct its_itte *itte;
+	struct kvm_vcpu *vcpu;
+	bool inject = false;
+	u64 doorbell;
+	int ret = 0;
+
+	if (!vgic_has_its(kvm))
+		return -ENODEV;
+
+	if (!(msi->flags & KVM_MSI_VALID_DEVID))
+		return -EINVAL;
+
+	doorbell = (u64)msi->address_hi << 32 | msi->address_lo;
+	its = find_its_doorbell(kvm, doorbell);
+	if (!its)
+		return -EINVAL;
+
+	spin_lock(&its->lock);
+
+	if (!its->enabled) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	itte = find_itte(its, msi->devid, msi->data);
+	/* Triggering an unmapped IRQ gets silently dropped. */
+	if (!itte || !its_is_collection_mapped(itte->collection))
+		goto out_unlock;
+
+	vcpu = kvm_get_vcpu(kvm, itte->collection->target_addr);
+	if (!vcpu || !vcpu->arch.vgic_cpu.lpis_enabled)
+		goto out_unlock;
+
+	inject = true;
+
+out_unlock:
+	spin_unlock(&its->lock);
+
+	if (inject) {
+		spin_lock(&itte->irq.irq_lock);
+		itte->irq.pending = true;
+		vgic_queue_irq_unlock(kvm, &itte->irq);
+	}
+
+	return ret;
+}
+
 struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
 {
 	struct vgic_its *its;
@@ -791,6 +856,23 @@ static int vits_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	return 0;
 }
 
+/* The INT command injects the LPI associated with that DevID/EvID pair. */
+static int vits_cmd_handle_int(struct kvm *kvm, struct vgic_its *its,
+			       u64 *its_cmd)
+{
+	u64 doorbell = its->vgic_its_base + ITS_DOORBELL_OFFSET;
+	struct kvm_msi msi = {
+		.address_lo = doorbell & 0xffffffff,
+		.address_hi = doorbell >> 32,
+		.data = its_cmd_get_id(its_cmd),
+		.devid = its_cmd_get_deviceid(its_cmd),
+		.flags = KVM_MSI_VALID_DEVID,
+	};
+
+	vits_inject_msi(kvm, &msi);
+	return 0;
+}
+
 /*
  * This function expects the ITS lock to be dropped, so the actual command
  * handlers must take care of proper locking when needed.
@@ -826,6 +908,9 @@ static int vits_handle_command(struct kvm *kvm, struct vgic_its *its,
 	case GITS_CMD_MOVALL:
 		ret = vits_cmd_handle_movall(kvm, its, its_cmd);
 		break;
+	case GITS_CMD_INT:
+		ret = vits_cmd_handle_int(kvm, its, its_cmd);
+		break;
 	case GITS_CMD_INV:
 		ret = vits_cmd_handle_inv(kvm, its, its_cmd);
 		break;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 46c239f..5949d69 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -81,6 +81,7 @@ void vits_destroy(struct kvm *kvm, struct vgic_its *its);
 int kvm_vgic_register_its_device(void);
 struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
+int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -160,6 +161,11 @@ static inline struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
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

