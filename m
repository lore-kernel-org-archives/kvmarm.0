From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 11/12] KVM: arm64: implement MSI injection in ITS emulation
Date: Sat, 26 Mar 2016 02:14:09 +0000
Message-ID: <1458958450-19662-12-git-send-email-andre.przywara@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
 virt/kvm/arm/vgic/its-emul.c | 61 ++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h     |  6 +++++
 2 files changed, 67 insertions(+)

diff --git a/virt/kvm/arm/vgic/its-emul.c b/virt/kvm/arm/vgic/its-emul.c
index dcd0cac..166551d 100644
--- a/virt/kvm/arm/vgic/its-emul.c
+++ b/virt/kvm/arm/vgic/its-emul.c
@@ -371,6 +371,51 @@ static int vgic_mmio_read_its_idregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/*
+ * Translates an incoming MSI request into the redistributor (=VCPU) and
+ * the associated LPI number. Sets the LPI pending bit and also marks the
+ * VCPU as having a pending interrupt.
+ */
+int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_its *its = &dist->its;
+	struct its_itte *itte;
+	bool inject = false;
+	int ret = 0;
+
+	if (!vgic_has_its(kvm))
+		return -ENODEV;
+
+	if (!(msi->flags & KVM_MSI_VALID_DEVID))
+		return -EINVAL;
+
+	spin_lock(&its->lock);
+
+	if (!its->enabled || !dist->lpis_enabled) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	itte = find_itte(kvm, msi->devid, msi->data);
+	/* Triggering an unmapped IRQ gets silently dropped. */
+	if (!itte || !its_is_collection_mapped(itte->collection))
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
+		vgic_queue_irq(kvm, &itte->irq);
+	}
+
+	return ret;
+}
+
 struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
 {
 	struct its_itte *itte;
@@ -795,6 +840,19 @@ static int vits_cmd_handle_movall(struct kvm *kvm, u64 *its_cmd)
 	return 0;
 }
 
+/* The INT command injects the LPI associated with that DevID/EvID pair. */
+static int vits_cmd_handle_int(struct kvm *kvm, u64 *its_cmd)
+{
+	struct kvm_msi msi = {
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
  * This function is called with both the ITS and the distributor lock dropped,
  * so the actual command handlers must take the respective locks when needed.
@@ -829,6 +887,9 @@ static int vits_handle_command(struct kvm_vcpu *vcpu, u64 *its_cmd)
 	case GITS_CMD_MOVALL:
 		ret = vits_cmd_handle_movall(vcpu->kvm, its_cmd);
 		break;
+	case GITS_CMD_INT:
+		ret = vits_cmd_handle_int(vcpu->kvm, its_cmd);
+		break;
 	case GITS_CMD_INV:
 		ret = vits_cmd_handle_inv(vcpu->kvm, its_cmd);
 		break;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index a7218b0..223c778 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -65,6 +65,7 @@ int vgic_register_redist_regions(struct kvm *kvm, gpa_t dist_base_address);
 int vits_init(struct kvm *kvm);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid);
+int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
 void vits_destroy(struct kvm *kvm);
 #else
 static inline void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid,
@@ -146,6 +147,11 @@ static inline struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
 	return NULL;
 }
 
+static inline int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	return -ENODEV;
+}
+
 static inline void vits_destroy(struct kvm *kvm)
 {
 	return;
-- 
2.7.3

