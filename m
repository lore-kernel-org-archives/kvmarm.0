From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 33/45] KVM: arm/arm64: vgic-new: vgic_kvm_device: access to VGIC registers
Date: Fri, 15 Apr 2016 18:11:44 +0100
Message-ID: <1460740316-8755-34-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch implements the switches for KVM_DEV_ARM_VGIC_GRP_DIST_REGS
and KVM_DEV_ARM_VGIC_GRP_CPU_REGS API which allows the userspace to
access VGIC registers.

At that stage the interfaces with the MMIO API are not implemented:
- vgic_attr_regs_access
- vgic_v2_has_attr_regs

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic.h            |  1 +
 virt/kvm/arm/vgic/vgic_kvm_device.c | 53 +++++++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic_mmio.c       | 34 ++++++++++++++++++++++++
 3 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index e1543a7..e9fbcc90 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -35,6 +35,7 @@ void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
 int vgic_v2_dist_access(struct kvm_vcpu *vcpu, bool is_write,
 			int offset, int len, void *val);
+int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/vgic/vgic_kvm_device.c b/virt/kvm/arm/vgic/vgic_kvm_device.c
index d6fb2d6..dfe40a0 100644
--- a/virt/kvm/arm/vgic/vgic_kvm_device.c
+++ b/virt/kvm/arm/vgic/vgic_kvm_device.c
@@ -140,6 +140,21 @@ void kvm_register_vgic_device(unsigned long type)
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
@@ -148,8 +163,23 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
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
@@ -158,7 +188,23 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
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
@@ -172,6 +218,9 @@ static int vgic_v2_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
+		return vgic_v2_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index fd95f3d..ec96188 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -1375,3 +1375,37 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 	}
 }
 #endif
+
+int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
+{
+	int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+	struct vgic_register_region *regions;
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
-- 
2.7.3

