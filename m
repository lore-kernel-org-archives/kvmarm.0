From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 26/37] KVM: arm64: vgic-v3: KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
Date: Tue,  9 May 2017 12:44:55 +0200
Message-ID: <20170509104506.30929-27-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

This patch adds a new attribute to GICV3 KVM device
KVM_DEV_ARM_VGIC_GRP_CTRL group. This allows userspace to
flush all GICR pending tables into guest RAM.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/uapi/asm/kvm.h     |  1 +
 arch/arm64/include/uapi/asm/kvm.h   |  1 +
 virt/kvm/arm/vgic/vgic-kvm-device.c | 20 +++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c         | 51 +++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            |  1 +
 5 files changed, 74 insertions(+)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 0f7ee15..a3fbab5 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -204,6 +204,7 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES		1
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES	2
+#define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 5dd7be0..d46a99d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -224,6 +224,7 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
+#define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
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
index 9ae8add..54dee72 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -278,6 +278,57 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
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
index 433449b..8259f0a 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -173,6 +173,7 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
+int vgic_v3_save_pending_tables(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 
 void vgic_v3_load(struct kvm_vcpu *vcpu);
-- 
2.9.0
