From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 24/24] KVM: arm64: vgic-v3: KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
Date: Thu,  4 May 2017 13:44:44 +0200
Message-ID: <1493898284-29504-25-git-send-email-eric.auger@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds a new attribute to GICV3 KVM device
KVM_DEV_ARM_VGIC_GRP_CTRL group. This allows userspace to
flush all GICR pending tables into guest RAM.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v5 -> v6:
- fix stored
- GICR_PEND/PROPBASER_ADDRESS were already introduced

v4 -> v5:
- move pending table save code/ctrl into VGICv3 instead of ITS
- remove useless gpa_t cast
- use the same optimization as in its_sync_lpi_pending_table

v3 -> v4:
- remove the wrong comment about locking
- pass kvm struct instead of its handle
- add comment about restore method
- remove GITR_PENDABASER.PTZ check
- continue if target_vcpu == NULL
- new locking strategy

v1 -> v2:
- do not care about the 1st KB which should be zeroed according to
  the spec.
---
 arch/arm/include/uapi/asm/kvm.h     |  1 +
 arch/arm64/include/uapi/asm/kvm.h   |  1 +
 include/linux/irqchip/arm-gic-v3.h  |  1 +
 virt/kvm/arm/vgic/vgic-kvm-device.c | 20 +++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c         | 51 +++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            |  1 +
 6 files changed, 75 insertions(+)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 8e6563c..78fe803 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -202,6 +202,7 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES		1
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES	2
+#define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 1e35115..8a3758a 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -222,6 +222,7 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
+#define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index e09e5d7..347d26f 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -186,6 +186,7 @@
 #define GICR_PENDBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWaWb)
 
 #define GICR_PENDBASER_PTZ				BIT_ULL(62)
+#define GICR_PENDBASER_ADDRESS(x)    ((x) & GENMASK_ULL(51, 16))
 
 /*
  * Re-Distributor registers, offsets from SGI_base
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 859bfa8..d48743c 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -580,6 +580,24 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		reg = tmp32;
 		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
 	}
+	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
+		int ret;
+
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
+			mutex_lock(&dev->kvm->lock);
+
+			if (!lock_all_vcpus(dev->kvm)) {
+				mutex_unlock(&dev->kvm->lock);
+				return -EBUSY;
+			}
+			ret = vgic_v3_save_pending_tables(dev->kvm);
+			unlock_all_vcpus(dev->kvm);
+			mutex_unlock(&dev->kvm->lock);
+			return ret;
+		}
+		break;
+	}
 	}
 	return -ENXIO;
 }
@@ -658,6 +676,8 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
+		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
+			return 0;
 		}
 	}
 	return -ENXIO;
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 0d753ae..6ff6510 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -296,6 +296,57 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
 	return 0;
 }
 
+/**
+ * vgic_its_save_pending_tables - Save the pending tables into guest RAM
+ * kvm lock and all vcpu lock must be held
+ */
+int vgic_v3_save_pending_tables(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	int last_byte_offset = -1;
+	struct vgic_irq *irq;
+	int ret;
+
+	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+		int byte_offset, bit_nr;
+		struct kvm_vcpu *vcpu;
+		gpa_t pendbase, ptr;
+		bool stored;
+		u8 val;
+
+		vcpu = irq->target_vcpu;
+		if (!vcpu)
+			continue;
+
+		pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
+
+		byte_offset = irq->intid / BITS_PER_BYTE;
+		bit_nr = irq->intid % BITS_PER_BYTE;
+		ptr = pendbase + byte_offset;
+
+		if (byte_offset != last_byte_offset) {
+			ret = kvm_read_guest(kvm, ptr, &val, 1);
+			if (ret)
+				return ret;
+			last_byte_offset = byte_offset;
+		}
+
+		stored = val & (1U << bit_nr);
+		if (stored == irq->pending_latch)
+			continue;
+
+		if (irq->pending_latch)
+			val |= 1 << bit_nr;
+		else
+			val &= ~(1 << bit_nr);
+
+		ret = kvm_write_guest(kvm, ptr, &val, 1);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 /* check for overlapping regions and for regions crossing the end of memory */
 static bool vgic_v3_check_base(struct kvm *kvm)
 {
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 92a8ca0..8de59a4 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -181,6 +181,7 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
+int vgic_v3_save_pending_tables(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 
 int vgic_register_its_iodevs(struct kvm *kvm);
-- 
2.5.5
