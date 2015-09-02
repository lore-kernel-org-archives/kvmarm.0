From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v2 5/5] Implement vGICv3 CPU interface access
Date: Wed, 02 Sep 2015 11:09:49 +0300
Message-ID: <32a2a871d5ee6c15860b21a73fb26f6372304c4d.1441180858.git.p.fedin@samsung.com>
References: <cover.1441180858.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1441180858.git.p.fedin@samsung.com>
In-reply-to: <cover.1441180858.git.p.fedin@samsung.com>
References: <cover.1441180858.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The access is done similar to GICv2, using KVM_DEV_ARM_VGIC_GRP_CPU_REGS
group, however attribute ID encodes corresponding system register. Access
size is always 64 bits.

Since CPU interface state actually affects only a single vCPU, no vGIC
locking is done. Just made sure that the vCPU is not running.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt |  38 +++-
 arch/arm64/include/uapi/asm/kvm.h              |   7 +
 include/linux/irqchip/arm-gic-v3.h             |  18 +-
 virt/kvm/arm/vgic-v3-emul.c                    | 246 +++++++++++++++++++++++++
 4 files changed, 305 insertions(+), 4 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 43f2627..f7dd916 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -89,7 +89,7 @@ Groups:
     -ENODEV: Getting or setting this register is not yet supported
     -EBUSY: One or more VCPUs are running
 
-  KVM_DEV_ARM_VGIC_GRP_CPU_REGS
+  KVM_DEV_ARM_VGIC_GRP_CPU_REGS (vGICv2)
   Attributes:
     The attr field of kvm_device_attr encodes two values:
     bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
@@ -117,11 +117,45 @@ Groups:
 
   Limitations:
     - Priorities are not implemented, and registers are RAZ/WI
-    - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
   Errors:
     -ENODEV: Getting or setting this register is not yet supported
     -EBUSY: One or more VCPUs are running
 
+  KVM_DEV_ARM_VGIC_GRP_CPU_REGS (vGICv3)
+  Attributes:
+    The attr field of kvm_device_attr encodes the following values:
+    bits:   | 63 .. 56 | 55 .. 48 | 47 ... 40 | 39 .. 32 | 31 .. 0 |
+    values: |   arch   |   size   | reserved  |  cpu id  |  reg id |
+
+    All CPU interface regs are (rw, 64-bit). The only supported size value is
+    KVM_REG_SIZE_U64.
+
+    Arch, size and reg id fields actually encode system register to be
+    accessed. Normally these values are obtained using  ARM64_SYS_REG() macro.
+    Getting or setting such a register has the same effect as reading or
+    writing the register on the actual hardware.
+
+    The Active Priorities Registers AP0Rn and AP1Rn are implementation defined,
+    so we set a fixed format for our implementation that fits with the model of
+    a "GICv3 implementation without the security extensions" which we present
+    to the guest. This interface always exposes four register APR[0-3]
+    describing the maximum possible 128 preemption levels. The semantics of the
+    register indicates if any interrupts in a given preemption level are in the
+    active state by setting the corresponding bit.
+
+    Thus, preemption level X has one or more active interrupts if and only if:
+
+      APRn[X mod 32] == 0b1,  where n = X / 32
+
+    Bits for undefined preemption levels are RAZ/WI.
+
+  Limitations:
+    - Priorities are not implemented, and registers are RAZ/WI
+  Errors:
+    -ENODEV: Getting or setting this register is not yet supported
+    -EBUSY: One or more VCPUs are running
+
+
   KVM_DEV_ARM_VGIC_GRP_NR_IRQS
   Attributes:
     A value describing the number of interrupts (SGI, PPI and SPI) for
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b7a0a6d..1d052f4 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -201,6 +201,13 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
 #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
 #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
+#define   KVM_DEV_ARM_VGIC_REG_MASK	(KVM_REG_SIZE_MASK | \
+					 KVM_REG_ARM64_SYSREG_OP0_MASK | \
+					 KVM_REG_ARM64_SYSREG_OP1_MASK | \
+					 KVM_REG_ARM64_SYSREG_CRN_MASK | \
+					 KVM_REG_ARM64_SYSREG_CRM_MASK | \
+					 KVM_REG_ARM64_SYSREG_OP2_MASK)
+
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 9eeeb95..dbc5c49 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -259,8 +259,14 @@
 /*
  * CPU interface registers
  */
-#define ICC_CTLR_EL1_EOImode_drop_dir	(0U << 1)
-#define ICC_CTLR_EL1_EOImode_drop	(1U << 1)
+#define ICC_CTLR_EL1_CBPR_SHIFT		0
+#define ICC_CTLR_EL1_EOImode_SHIFT	1
+#define ICC_CTLR_EL1_EOImode_drop_dir	(0U << ICC_CTLR_EL1_EOImode_SHIFT)
+#define ICC_CTLR_EL1_EOImode_drop	(1U << ICC_CTLR_EL1_EOImode_SHIFT)
+#define ICC_CTLR_EL1_PRIbits_MASK	(7U << 8)
+#define ICC_CTLR_EL1_IDbits_MASK	(7U << 11)
+#define ICC_CTLR_EL1_SEIS		(1U << 14)
+#define ICC_CTLR_EL1_A3V		(1U << 15)
 #define ICC_SRE_EL1_SRE			(1U << 0)
 
 /*
@@ -285,6 +291,14 @@
 
 #define ICH_VMCR_CTLR_SHIFT		0
 #define ICH_VMCR_CTLR_MASK		(0x21f << ICH_VMCR_CTLR_SHIFT)
+#define ICH_VMCR_ENG0_SHIFT		0
+#define ICH_VMCR_ENG0			(1 << ICH_VMCR_ENG0_SHIFT)
+#define ICH_VMCR_ENG1_SHIFT		1
+#define ICH_VMCR_ENG1			(1 << ICH_VMCR_ENG1_SHIFT)
+#define ICH_VMCR_CBPR_SHIFT		4
+#define ICH_VMCR_CBPR			(1 << ICH_VMCR_CBPR_SHIFT)
+#define ICH_VMCR_EOIM_SHIFT		9
+#define ICH_VMCR_EOIM			(1 << ICH_VMCR_EOIM_SHIFT)
 #define ICH_VMCR_BPR1_SHIFT		18
 #define ICH_VMCR_BPR1_MASK		(7 << ICH_VMCR_BPR1_SHIFT)
 #define ICH_VMCR_BPR0_SHIFT		21
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 66d2b54..c01cc62 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -48,6 +48,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
 
+#include "sys_regs.h"
 #include "vgic.h"
 
 static bool handle_mmio_rao_wi(struct kvm_vcpu *vcpu,
@@ -991,6 +992,249 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 		vgic_kick_vcpus(vcpu->kvm);
 }
 
+static bool access_gic_ctlr(struct kvm_vcpu *vcpu,
+			    const struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	u64 val;
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (p->is_write) {
+		val = *p->val;
+
+		vgicv3->vgic_vmcr &= ~(ICH_VMCR_CBPR|ICH_VMCR_EOIM);
+		vgicv3->vgic_vmcr |= (val << (ICH_VMCR_CBPR_SHIFT -
+						ICC_CTLR_EL1_CBPR_SHIFT)) &
+					ICH_VMCR_CBPR;
+		vgicv3->vgic_vmcr |= (val << (ICH_VMCR_EOIM_SHIFT -
+						ICC_CTLR_EL1_EOImode_SHIFT)) &
+					ICH_VMCR_EOIM;
+	} else {
+		asm volatile("mrs_s %0," __stringify(ICC_IAR1_EL1)
+			     : "=r" (val));
+		val &= (ICC_CTLR_EL1_A3V | ICC_CTLR_EL1_SEIS |
+			ICC_CTLR_EL1_IDbits_MASK | ICC_CTLR_EL1_PRIbits_MASK);
+		val |= (vgicv3->vgic_vmcr & ICH_VMCR_CBPR) >>
+			(ICH_VMCR_CBPR_SHIFT - ICC_CTLR_EL1_CBPR_SHIFT);
+		val |= (vgicv3->vgic_vmcr & ICH_VMCR_EOIM) >>
+			(ICH_VMCR_EOIM_SHIFT - ICC_CTLR_EL1_EOImode_SHIFT);
+
+		*p->val = val;
+	}
+
+	return true;
+}
+
+static bool access_gic_pmr(struct kvm_vcpu *vcpu,
+			   const struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (p->is_write) {
+		vgicv3->vgic_vmcr &= ~ICH_VMCR_PMR_MASK;
+		vgicv3->vgic_vmcr |= (*p->val << ICH_VMCR_PMR_SHIFT) &
+					ICH_VMCR_PMR_MASK;
+	} else {
+		*p->val = (vgicv3->vgic_vmcr & ICH_VMCR_PMR_MASK) >>
+			  ICH_VMCR_PMR_SHIFT;
+	}
+
+	return true;
+}
+
+static bool access_gic_bpr0(struct kvm_vcpu *vcpu,
+			    const struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (p->is_write) {
+		vgicv3->vgic_vmcr &= ~ICH_VMCR_BPR0_MASK;
+		vgicv3->vgic_vmcr |= (*p->val << ICH_VMCR_BPR0_SHIFT) &
+				     ICH_VMCR_BPR0_MASK;
+	} else {
+		*p->val = (vgicv3->vgic_vmcr & ICH_VMCR_BPR0_MASK) >>
+			  ICH_VMCR_BPR0_SHIFT;
+	}
+
+	return true;
+}
+
+static bool access_gic_bpr1(struct kvm_vcpu *vcpu,
+			    const struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (p->is_write) {
+		vgicv3->vgic_vmcr &= ~ICH_VMCR_BPR1_MASK;
+		vgicv3->vgic_vmcr |= (*p->val << ICH_VMCR_BPR1_SHIFT) &
+				     ICH_VMCR_BPR1_MASK;
+	} else {
+		*p->val = (vgicv3->vgic_vmcr & ICH_VMCR_BPR1_MASK) >>
+			  ICH_VMCR_BPR1_SHIFT;
+	}
+
+	return true;
+}
+
+static bool access_gic_grpen0(struct kvm_vcpu *vcpu,
+			      const struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (p->is_write) {
+		vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG0;
+		vgicv3->vgic_vmcr |= (*p->val << ICH_VMCR_ENG0_SHIFT) &
+				     ICH_VMCR_ENG0;
+	} else {
+		*p->val = (vgicv3->vgic_vmcr & ICH_VMCR_ENG0) >>
+			  ICH_VMCR_ENG0_SHIFT;
+	}
+
+	return true;
+}
+
+static bool access_gic_grpen1(struct kvm_vcpu *vcpu,
+			      const struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (p->is_write) {
+		vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG1;
+		vgicv3->vgic_vmcr |= (*p->val << ICH_VMCR_ENG1_SHIFT) &
+				     ICH_VMCR_ENG1;
+	} else {
+		*p->val = (vgicv3->vgic_vmcr & ICH_VMCR_ENG1) >>
+			  ICH_VMCR_ENG1_SHIFT;
+	}
+
+	return true;
+}
+
+static bool access_gic_ap0r(struct kvm_vcpu *vcpu,
+			      const struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+	u8 idx = r->Op2 & 3;
+
+	if (p->is_write) {
+		vgicv3->vgic_ap0r[idx] = *p->val;
+	} else {
+		*p->val = vgicv3->vgic_ap0r[idx];
+	}
+
+	return true;
+}
+
+static bool access_gic_ap1r(struct kvm_vcpu *vcpu,
+			      const struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+	u8 idx = r->Op2 & 3;
+
+	if (p->is_write) {
+		vgicv3->vgic_ap0r[idx] = *p->val;
+	} else {
+		*p->val = vgicv3->vgic_ap0r[idx];
+	}
+
+	return true;
+}
+
+static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
+	/* ICC_PMR_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0100), CRm(0b0110), Op2(0b000),
+	  access_gic_pmr },
+	/* ICC_BPR0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1000), Op2(0b011),
+	  access_gic_bpr0 },
+	/* ICC_AP0R0_EL1 */
+        { Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1000), Op2(0b100),
+	  access_gic_ap0r },
+	/* ICC_AP0R1_EL1 */
+        { Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1000), Op2(0b101),
+	  access_gic_ap0r },
+	/* ICC_AP0R2_EL1 */
+        { Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1000), Op2(0b110),
+	  access_gic_ap0r },
+	/* ICC_AP0R3_EL1 */
+        { Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1000), Op2(0b111),
+	  access_gic_ap0r },
+	/* ICC_AP1R0_EL1 */
+        { Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1001), Op2(0b000),
+	  access_gic_ap1r },
+	/* ICC_AP1R1_EL1 */
+        { Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1001), Op2(0b001),
+	  access_gic_ap1r },
+	/* ICC_AP1R2_EL1 */
+        { Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1001), Op2(0b010),
+	  access_gic_ap1r },
+	/* ICC_AP1R3_EL1 */
+        { Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1001), Op2(0b011),
+	  access_gic_ap1r },
+	/* ICC_BPR1_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1100), Op2(0b011),
+	  access_gic_bpr1 },
+	/* ICC_CTLR_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1100), Op2(0b100),
+	  access_gic_ctlr },
+	/* ICC_IGRPEN0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1100), Op2(0b110),
+	  access_gic_grpen0 },
+	/* ICC_GRPEN1_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1100), Op2(0b111),
+	  access_gic_grpen1 },
+};
+
+static int vgic_v3_cpu_regs_access(struct kvm_device *dev,
+				   struct kvm_device_attr *attr,
+				   bool is_write, int cpuid)
+{
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+	u64 id = attr->attr & KVM_DEV_ARM_VGIC_REG_MASK;
+	struct kvm_vcpu *vcpu;
+	struct sys_reg_params params;
+	u_long reg;
+	const struct sys_reg_desc *r;
+
+	params.val = &reg;
+	params.is_write = is_write;
+	params.is_aarch32 = false;
+	params.is_32bit = false;
+
+	r = find_reg_by_id(id, &params, gic_v3_icc_reg_descs,
+			   ARRAY_SIZE(gic_v3_icc_reg_descs));
+	if (!r)
+		return -ENXIO;
+
+	if (is_write) {
+		if (get_user(reg, uaddr))
+			return -EFAULT;
+	}
+
+	if (cpuid >= atomic_read(&dev->kvm->online_vcpus))
+		return -EINVAL;
+
+	vcpu = kvm_get_vcpu(dev->kvm, cpuid);
+	/* Ensure that VCPU is not running */
+	if (unlikely(vcpu->cpu != -1))
+			return -EBUSY;
+
+	if (!r->access(vcpu, &params, r))
+		return -EINVAL;
+
+	if (!is_write)
+		return put_user(reg, uaddr);
+
+	return 0;
+}
+
 static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 				    struct kvm_device_attr *attr,
 				    bool is_write)
@@ -1015,6 +1259,8 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		mmio.phys_addr = vgic->vgic_redist_base;
 		ranges = vgic_redist_ranges;
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
+		return vgic_v3_cpu_regs_access(dev, attr, is_write, cpuid);
 	default:
 		return -ENXIO;
 	}
-- 
2.4.4

