From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v10 16/17] KVM: arm64: implement MSI injection in ITS emulation
Date: Fri, 15 Jul 2016 12:43:37 +0100
Message-ID: <20160715114338.10484-17-andre.przywara@arm.com>
References: <20160715114338.10484-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CD0B49B63
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2016 07:37:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MaLOxzRZpS04 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2016 07:37:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C230149B94
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2016 07:37:16 -0400 (EDT)
In-Reply-To: <20160715114338.10484-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When userland wants to inject an MSI into the guest, it uses the
KVM_SIGNAL_MSI ioctl, which carries the doorbell address along with
the payload and the device ID.
With the help of the KVM IO bus framework we learn the corresponding
ITS from the doorbell address. We then use our wrapper functions to
iterate the linked lists and find the proper Interrupt Translation Table
Entry (ITTE) and thus the corresponding struct vgic_irq to finally set
the pending bit.
We also provide the handler for the ITS "INT" command, which allows a
guest to trigger an MSI via the ITS command queue. Since this one knows
about the right ITS already, we directly call the MMIO handler function
without using the kvm_io_bus framework.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 77 ++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h     |  6 ++++
 2 files changed, 83 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 1408c88..d8e8f14 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -437,6 +437,65 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
 	return 0;
 }
 
+/*
+ * Find the target VCPU and the LPI number for a given devid/eventid pair
+ * and make this IRQ pending, possibly injecting it.
+ * Must be called with the its_lock mutex held.
+ */
+static void vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
+				 u32 devid, u32 eventid)
+{
+	struct its_itte *itte;
+
+	if (!its->enabled)
+		return;
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
+}
+
+/*
+ * Queries the KVM IO bus framework to get the ITS pointer from the given
+ * doorbell address.
+ * We then call vgic_its_trigger_msi() with the decoded data.
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
+
+	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
+	if (!kvm_io_dev)
+		return -ENODEV;
+
+	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
+
+	mutex_lock(&iodev->its->its_lock);
+	vgic_its_trigger_msi(kvm, iodev->its, msi->devid, msi->data);
+	mutex_unlock(&iodev->its->its_lock);
+
+	return 0;
+}
+
 /* Requires the its_lock to be held. */
 static void its_free_itte(struct kvm *kvm, struct its_itte *itte)
 {
@@ -897,6 +956,21 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 }
 
 /*
+ * The INT command injects the LPI associated with that DevID/EvID pair.
+ * Must be called with the its_lock mutex held.
+ */
+static int vgic_its_cmd_handle_int(struct kvm *kvm, struct vgic_its *its,
+				   u64 *its_cmd)
+{
+	u32 msi_data = its_cmd_get_id(its_cmd);
+	u64 msi_devid = its_cmd_get_deviceid(its_cmd);
+
+	vgic_its_trigger_msi(kvm, its, msi_devid, msi_data);
+
+	return 0;
+}
+
+/*
  * This function is called with the its_cmd lock held, but the ITS data
  * structure lock dropped.
  */
@@ -932,6 +1006,9 @@ static int vgic_its_handle_command(struct kvm *kvm, struct vgic_its *its,
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
index ee348de..9d557f2 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -78,6 +78,7 @@ int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 bool vgic_has_its(struct kvm *kvm);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
+int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -138,6 +139,11 @@ static inline bool vgic_has_its(struct kvm *kvm)
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
