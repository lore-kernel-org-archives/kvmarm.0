From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 45/57] KVM: arm/arm64: vgic-new: vgic_kvm_device: access to VGIC registers
Date: Thu, 19 May 2016 19:08:24 +0100
Message-ID: <1463681316-23039-46-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch implements the switches for KVM_DEV_ARM_VGIC_GRP_DIST_REGS
and KVM_DEV_ARM_VGIC_GRP_CPU_REGS API which allows the userspace to
access VGIC registers.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changelog v3 .. v4:
- check for proper alignment on userland GIC accesses

 virt/kvm/arm/vgic/vgic-kvm-device.c | 53 +++++++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio-v2.c    | 38 ++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            |  1 +
 3 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index a709097..78621283 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -226,6 +226,21 @@ void kvm_register_vgic_device(unsigned long type)
 	}
 }
 
+/** vgic_attr_regs_access: allows user space to read/write VGIC registers
+ *
+ * @dev: kvm device handle
+ * @attr: kvm device attribute
+ * @reg: address the value is read or written
+ * @is_write: write flag
+ *
+ */
+static int vgic_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u32 *reg, bool is_write)
+{
+	return -ENXIO;
+}
+
 /* V2 ops */
 
 static int vgic_v2_set_attr(struct kvm_device *dev,
@@ -234,8 +249,23 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
 	int ret;
 
 	ret = vgic_set_common_attr(dev, attr);
-	return ret;
+	if (ret != -ENXIO)
+		return ret;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+		u32 reg;
+
+		if (get_user(reg, uaddr))
+			return -EFAULT;
 
+		return vgic_attr_regs_access(dev, attr, &reg, true);
+	}
+	}
+
+	return -ENXIO;
 }
 
 static int vgic_v2_get_attr(struct kvm_device *dev,
@@ -244,7 +274,23 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
 	int ret;
 
 	ret = vgic_get_common_attr(dev, attr);
-	return ret;
+	if (ret != -ENXIO)
+		return ret;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+		u32 reg = 0;
+
+		ret = vgic_attr_regs_access(dev, attr, &reg, false);
+		if (ret)
+			return ret;
+		return put_user(reg, uaddr);
+	}
+	}
+
+	return -ENXIO;
 }
 
 static int vgic_v2_has_attr(struct kvm_device *dev,
@@ -258,6 +304,9 @@ static int vgic_v2_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
+		return vgic_v2_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 3925d4c..7189690 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -258,3 +258,41 @@ unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev)
 
 	return SZ_4K;
 }
+
+int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
+{
+	int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+	const struct vgic_register_region *regions;
+	gpa_t addr;
+	int nr_regions, i, len;
+
+	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+		regions = vgic_v2_dist_registers;
+		nr_regions = ARRAY_SIZE(vgic_v2_dist_registers);
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
+		return -ENXIO;		/* TODO: describe CPU i/f regs also */
+	default:
+		return -ENXIO;
+	}
+
+	/* We only support aligned 32-bit accesses. */
+	if (addr & 3)
+		return -ENXIO;
+
+	for (i = 0; i < nr_regions; i++) {
+		if (regions[i].bits_per_irq)
+			len = (regions[i].bits_per_irq * nr_irqs) / 8;
+		else
+			len = regions[i].len;
+
+		if (regions[i].reg_offset <= addr &&
+		    regions[i].reg_offset + len > addr)
+			return 0;
+	}
+
+	return -ENXIO;
+}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 6abc9a3..a264c5f 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -37,6 +37,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
+int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type);
 
-- 
2.8.2

