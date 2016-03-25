From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 33/45] KVM: arm/arm64: vgic-new: vgic_kvm_device: access
 to VGIC registers
Date: Fri, 25 Mar 2016 02:04:56 +0000
Message-ID: <1458871508-17279-34-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE29C49B40
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zdQZ3lA3fu6a for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:05:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A451049B3F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:14 -0400 (EDT)
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
index 072bec1..ff7ac9a 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -32,6 +32,7 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
 int vgic_v2_dist_access(struct kvm_vcpu *vcpu, bool is_write,
 			int offset, int len, void *val);
+int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid, u64 mpidr);
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
index 7eb6b93..7d5d630 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -1241,3 +1241,37 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
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
