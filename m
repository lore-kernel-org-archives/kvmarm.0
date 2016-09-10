From: vijay.kilari@gmail.com
Subject: [PATCH v4 4/5] arm/arm64: vgic-new: Implement VGICv3 CPU interface
 access
Date: Sat, 10 Sep 2016 17:52:17 +0530
Message-ID: <1473510138-4719-5-git-send-email-vijay.kilari@gmail.com>
References: <1473510138-4719-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD47940F9B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2016 08:14:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9tViBm4xpv+Z for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Sep 2016 08:14:15 -0400 (EDT)
Received: from mail-pa0-f68.google.com (mail-pa0-f68.google.com
 [209.85.220.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A536748529
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2016 08:14:14 -0400 (EDT)
Received: by mail-pa0-f68.google.com with SMTP id h5so5184664pao.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2016 05:22:49 -0700 (PDT)
In-Reply-To: <1473510138-4719-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

VGICv3 CPU interface registers are accessed using
KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
as 64-bit. The cpu MPIDR value is passed along with register id.
is used to identify the cpu for registers access.

The version of VGIC v3 specification is define here
http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 arch/arm64/include/uapi/asm/kvm.h   |   3 +
 arch/arm64/kvm/Makefile             |   1 +
 include/linux/irqchip/arm-gic-v3.h  |  32 ++++-
 virt/kvm/arm/vgic/vgic-kvm-device.c |  27 ++++
 virt/kvm/arm/vgic/vgic-mmio-v2.c    |  16 ---
 virt/kvm/arm/vgic/vgic-mmio-v3.c    |  18 +++
 virt/kvm/arm/vgic/vgic-mmio.c       |  16 +++
 virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 261 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c         |   4 +
 virt/kvm/arm/vgic/vgic.h            |  15 +++
 10 files changed, 376 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 56dc08d..91c7137 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -206,9 +206,12 @@ struct kvm_arch_memory_slot {
 			(0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
 #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
 #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
+#define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
 #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
+#define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
+
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
 
 /* Device Control API on vcpu fd */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index d50a82a..1a14e29 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -32,5 +32,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-sys-reg-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 99ac022..22ec183 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -354,6 +354,24 @@
  */
 #define ICC_CTLR_EL1_EOImode_drop_dir	(0U << 1)
 #define ICC_CTLR_EL1_EOImode_drop	(1U << 1)
+#define ICC_CTLR_EL1_CBPR_SHIFT		(0)
+#define ICC_CTLR_EL1_CBPR_MASK		(1 << ICC_CTLR_EL1_CBPR_SHIFT)
+#define ICC_CTLR_EL1_EOImode_SHIFT	(1)
+#define ICC_CTLR_EL1_EOImode_MASK	(1 << ICC_CTLR_EL1_EOImode_SHIFT)
+#define ICC_CTLR_EL1_PRI_BITS_SHIFT	(8)
+#define ICC_CTLR_EL1_PRI_BITS_MASK	(0x7 << ICC_CTLR_EL1_PRI_BITS_SHIFT)
+#define ICC_CTLR_EL1_ID_BITS_SHIFT	(11)
+#define ICC_CTLR_EL1_ID_BITS_MASK	(0x7 << ICC_CTLR_EL1_ID_BITS_SHIFT)
+#define ICC_PMR_EL1_SHIFT		(0)
+#define ICC_PMR_EL1_MASK		(0xff << ICC_PMR_EL1_SHIFT)
+#define ICC_BPR0_EL1_SHIFT		(0)
+#define ICC_BPR0_EL1_MASK		(0x7 << ICC_PMR_EL1_SHIFT)
+#define ICC_BPR1_EL1_SHIFT		(0)
+#define ICC_BPR1_EL1_MASK		(0x7 << ICC_PMR_EL1_SHIFT)
+#define ICC_IGRPEN0_EL1_SHIFT		(0)
+#define ICC_IGRPEN0_EL1_MASK		(1 << ICC_IGRPEN0_EL1_SHIFT)
+#define ICC_IGRPEN1_EL1_SHIFT		(0)
+#define ICC_IGRPEN1_EL1_MASK		(1 << ICC_IGRPEN1_EL1_SHIFT)
 #define ICC_SRE_EL1_SRE			(1U << 0)
 
 /*
@@ -383,7 +401,19 @@
 #define ICH_HCR_UIE			(1 << 1)
 
 #define ICH_VMCR_CTLR_SHIFT		0
-#define ICH_VMCR_CTLR_MASK		(0x21f << ICH_VMCR_CTLR_SHIFT)
+#define ICH_VMCR_CTLR_MASK		(0x210 << ICH_VMCR_CTLR_SHIFT)
+#define ICH_VMCR_CBPR_SHIFT		4
+#define ICH_VMCR_CBPR_MASK		(1 << ICH_VMCR_CBPR_SHIFT)
+#define ICH_VMCR_EOIM_SHIFT		9
+#define ICH_VMCR_EOIM_MASK		(1 << ICH_VMCR_EOIM_SHIFT)
+#define ICH_VMCR_ENG0_SHIFT		0
+#define ICH_VMCR_ENG0_MASK		(1 << ICH_VMCR_ENG0_SHIFT)
+#define ICH_VMCR_ENG1_SHIFT		1
+#define ICH_VMCR_ENG1_MASK		(1 << ICH_VMCR_ENG1_SHIFT)
+#define ICH_VMCR_ENG0_SHIFT		0
+#define ICH_VMCR_ENG0			(1 << ICH_VMCR_ENG0_SHIFT)
+#define ICH_VMCR_ENG1_SHIFT		1
+#define ICH_VMCR_ENG1			(1 << ICH_VMCR_ENG1_SHIFT)
 #define ICH_VMCR_BPR1_SHIFT		18
 #define ICH_VMCR_BPR1_MASK		(7 << ICH_VMCR_BPR1_SHIFT)
 #define ICH_VMCR_BPR0_SHIFT		21
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 3225388..e580b6d 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -509,6 +509,14 @@ static int vgic_attr_regs_access_v3(struct kvm_device *dev,
 		if (!is_write)
 			*reg = tmp32;
 		break;
+	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
+		u64 regid;
+
+		regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
+		ret = vgic_v3_cpu_sysregs_uaccess(vcpu, is_write,
+						  regid, reg);
+		break;
+	}
 	default:
 		ret = -EINVAL;
 		break;
@@ -542,6 +550,15 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		reg = tmp32;
 		return vgic_attr_regs_access_v3(dev, attr, &reg, true);
 	}
+	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		u64 reg;
+
+		if (get_user(reg, uaddr))
+			return -EFAULT;
+
+		return vgic_attr_regs_access_v3(dev, attr, &reg, true);
+	}
 	}
 	return -ENXIO;
 }
@@ -569,6 +586,15 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 		ret = put_user(tmp32, uaddr);
 		return ret;
 	}
+	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		u64 reg;
+
+		ret = vgic_attr_regs_access_v3(dev, attr, &reg, false);
+		if (ret)
+			return ret;
+		return  put_user(reg, uaddr);
+	}
 	}
 
 	return -ENXIO;
@@ -587,6 +613,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+	case KVM_DEV_ARM_VGIC_CPU_SYSREGS:
 		return vgic_v3_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 2cb04b7..ad353b5 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -212,22 +212,6 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 	}
 }
 
-static void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
-{
-	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_set_vmcr(vcpu, vmcr);
-	else
-		vgic_v3_set_vmcr(vcpu, vmcr);
-}
-
-static void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
-{
-	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_get_vmcr(vcpu, vmcr);
-	else
-		vgic_v3_get_vmcr(vcpu, vmcr);
-}
-
 #define GICC_ARCH_VERSION_V2	0x2
 
 /* These are for userland accesses only, there is no guest-facing emulation. */
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index ffbe1ae..04e0f2c 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -23,6 +23,7 @@
 
 #include "vgic.h"
 #include "vgic-mmio.h"
+#include "sys_regs.h"
 
 /* extract @num bytes at @offset bytes offset in data */
 unsigned long extract_bytes(unsigned long data, unsigned int offset,
@@ -581,6 +582,23 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 		nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
 		break;
 	}
+	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
+		u64 reg, id;
+		unsigned long mpidr;
+		struct kvm_vcpu *vcpu;
+
+		mpidr = (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
+			 KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
+
+		vcpu = kvm_mpidr_to_vcpu(dev->kvm, mpidr);
+		if (!vcpu)
+			return -EINVAL;
+		if (vcpu->vcpu_id >= atomic_read(&dev->kvm->online_vcpus))
+			return -EINVAL;
+
+		id = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
+		return vgic_v3_has_cpu_sysregs_attr(vcpu, 0, id, &reg);
+	}
 	default:
 		return -ENXIO;
 	}
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 9294555..81d851c 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -470,6 +470,22 @@ int vgic_validate_mmio_region_addr(struct kvm_device *dev,
 	return -ENXIO;
 }
 
+void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
+{
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_set_vmcr(vcpu, vmcr);
+	else
+		vgic_v3_set_vmcr(vcpu, vmcr);
+}
+
+void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
+{
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_get_vmcr(vcpu, vmcr);
+	else
+		vgic_v3_get_vmcr(vcpu, vmcr);
+}
+
 /*
  * kvm_mmio_read_buf() returns a value in a format where it can be converted
  * to a byte array and be directly observed as the guest wanted it to appear
diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
new file mode 100644
index 0000000..437ed27
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
@@ -0,0 +1,261 @@
+#include <linux/irqchip/arm-gic-v3.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <kvm/iodev.h>
+#include <kvm/arm_vgic.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_mmu.h>
+
+#include "vgic.h"
+#include "vgic-mmio.h"
+#include "sys_regs.h"
+
+static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	struct vgic_vmcr vmcr;
+	u64 val;
+	u32 id_bits;
+
+	vgic_get_vmcr(vcpu, &vmcr);
+	if (p->is_write) {
+		val = p->regval;
+		vmcr.ctlr &= ~(ICH_VMCR_CBPR_MASK | ICH_VMCR_EOIM_MASK);
+		vmcr.ctlr |= ((val & ICC_CTLR_EL1_CBPR_MASK) >>
+			      ICC_CTLR_EL1_CBPR_SHIFT) << ICH_VMCR_CBPR_SHIFT;
+		vmcr.ctlr |= ((val & ICC_CTLR_EL1_EOImode_MASK) >>
+			     ICC_CTLR_EL1_EOImode_SHIFT) << ICH_VMCR_EOIM_SHIFT;
+		vgic_set_vmcr(vcpu, &vmcr);
+	} else {
+		val = 0;
+		/* ICC_CTLR_EL1.A3V and ICC_CTRL_EL1.SEIS are not set */
+		val |= VGIC_PRI_BITS << ICC_CTLR_EL1_PRI_BITS_SHIFT;
+
+		if (vgic_has_its(vcpu->kvm))
+			id_bits = INTERRUPT_ID_BITS_ITS;
+		else
+			id_bits = INTERRUPT_ID_BITS_SPIS;
+
+		if (id_bits >= 24)
+			val |= (1 << ICC_CTLR_EL1_ID_BITS_SHIFT);
+		else
+			val |= (0 << ICC_CTLR_EL1_ID_BITS_SHIFT);
+
+		val |= ((vmcr.ctlr & ICH_VMCR_CBPR_MASK) >>
+			ICH_VMCR_CBPR_SHIFT) << ICC_CTLR_EL1_CBPR_SHIFT;
+		val |= ((vmcr.ctlr & ICH_VMCR_EOIM_MASK) >>
+			ICH_VMCR_EOIM_SHIFT) << ICC_CTLR_EL1_EOImode_SHIFT;
+
+		p->regval = val;
+	}
+
+	return true;
+}
+
+static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	struct vgic_vmcr vmcr;
+
+	vgic_get_vmcr(vcpu, &vmcr);
+	if (p->is_write) {
+		vmcr.pmr = (p->regval << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
+		vgic_set_vmcr(vcpu, &vmcr);
+	} else {
+		p->regval = (vmcr.pmr & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
+	}
+
+	return true;
+}
+
+static bool access_gic_bpr0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	struct vgic_vmcr vmcr;
+
+	vgic_get_vmcr(vcpu, &vmcr);
+	if (p->is_write) {
+		vmcr.bpr = (p->regval << ICC_BPR0_EL1_SHIFT) &
+			    ICC_BPR0_EL1_MASK;
+		vgic_set_vmcr(vcpu, &vmcr);
+	} else {
+		p->regval = (vmcr.bpr & ICC_BPR0_EL1_MASK) >>
+			     ICC_BPR0_EL1_SHIFT;
+	}
+
+	return true;
+}
+
+static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	struct vgic_vmcr vmcr;
+
+	vgic_get_vmcr(vcpu, &vmcr);
+	if (p->is_write) {
+		vmcr.abpr = (p->regval << ICC_BPR1_EL1_SHIFT) &
+			     ICC_BPR1_EL1_MASK;
+		vgic_set_vmcr(vcpu, &vmcr);
+	} else {
+		p->regval = (vmcr.abpr & ICC_BPR1_EL1_MASK) >>
+			     ICC_BPR1_EL1_SHIFT;
+	}
+
+	return true;
+}
+
+static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	struct vgic_vmcr vmcr;
+
+	vgic_get_vmcr(vcpu, &vmcr);
+	if (p->is_write) {
+		vmcr.grpen0 = (p->regval << ICC_IGRPEN0_EL1_SHIFT) &
+				      ICC_IGRPEN0_EL1_MASK;
+		vgic_set_vmcr(vcpu, &vmcr);
+	} else {
+		p->regval = (vmcr.grpen0 & ICC_IGRPEN0_EL1_MASK) >>
+			     ICC_IGRPEN0_EL1_SHIFT;
+	}
+
+	return true;
+}
+
+static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	struct vgic_vmcr vmcr;
+
+	vgic_get_vmcr(vcpu, &vmcr);
+	if (p->is_write) {
+		vmcr.grpen1 = (p->regval << ICC_IGRPEN1_EL1_SHIFT) &
+				      ICC_IGRPEN1_EL1_MASK;
+		vgic_set_vmcr(vcpu, &vmcr);
+	} else {
+		p->regval = (vmcr.grpen1 & ICC_IGRPEN1_EL1_MASK) >>
+			     ICC_IGRPEN1_EL1_SHIFT;
+	}
+
+	return true;
+}
+
+static bool access_gic_ap0r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+	u8 idx = r->Op2 & 3;
+
+	if (p->is_write)
+		vgicv3->vgic_ap0r[idx] = p->regval;
+	else
+		p->regval = vgicv3->vgic_ap0r[idx];
+
+	return true;
+}
+
+static bool access_gic_ap1r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+	u8 idx = r->Op2 & 3;
+
+	if (p->is_write)
+		vgicv3->vgic_ap1r[idx] = p->regval;
+	else
+		p->regval = vgicv3->vgic_ap1r[idx];
+
+	return true;
+}
+
+static bool access_gic_sre(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	/* Read only. Write ignore */
+	if (!p->is_write)
+		p->regval = vgicv3->vgic_sre;
+
+	return true;
+}
+
+static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
+	/* ICC_PMR_EL1 */
+	{ Op0(3), Op1(0), CRn(4), CRm(6), Op2(0), access_gic_pmr },
+	/* ICC_BPR0_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(3), access_gic_bpr0 },
+	/* ICC_AP0R0_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(4), access_gic_ap0r },
+	/* ICC_AP0R1_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(5), access_gic_ap0r },
+	/* ICC_AP0R2_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(6), access_gic_ap0r },
+	/* ICC_AP0R3_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(7), access_gic_ap0r },
+	/* ICC_AP1R0_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(0), access_gic_ap1r },
+	/* ICC_AP1R1_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(1), access_gic_ap1r },
+	/* ICC_AP1R2_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(2), access_gic_ap1r },
+	/* ICC_AP1R3_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(3), access_gic_ap1r },
+	/* ICC_BPR1_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(3), access_gic_bpr1 },
+	/* ICC_CTLR_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(4), access_gic_ctlr },
+	/* ICC_SRE_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(5), access_gic_sre },
+	/* ICC_IGRPEN0_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(6), access_gic_grpen0 },
+	/* ICC_GRPEN1_EL1 */
+	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(7), access_gic_grpen1 },
+};
+
+int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
+				u64 *reg)
+{
+	struct sys_reg_params params;
+	u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
+
+	params.regval = *reg;
+	params.is_write = is_write;
+	params.is_aarch32 = false;
+	params.is_32bit = false;
+
+	if (find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
+			      ARRAY_SIZE(gic_v3_icc_reg_descs)))
+		return 0;
+	else
+		return -ENXIO;
+}
+
+int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
+				u64 *reg)
+{
+	struct sys_reg_params params;
+	const struct sys_reg_desc *r;
+	u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
+
+	if (is_write)
+		params.regval = *reg;
+	params.is_write = is_write;
+	params.is_aarch32 = false;
+	params.is_32bit = false;
+
+	r = find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
+			   ARRAY_SIZE(gic_v3_icc_reg_descs));
+	if (!r)
+		return -ENXIO;
+
+	if (!r->access(vcpu, &params, r))
+		return -EINVAL;
+
+	if (!is_write)
+		*reg = params.regval;
+
+	return 0;
+}
+
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 9f0dae3..cf34095 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -179,6 +179,8 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 	vmcr |= (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
 	vmcr |= (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
 	vmcr |= (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
+	vmcr |= (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
+	vmcr |= (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
 
 	vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr = vmcr;
 }
@@ -191,6 +193,8 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 	vmcrp->abpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
 	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
 	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
+	vmcrp->grpen0 = (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
+	vmcrp->grpen1 = (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
 }
 
 #define INITIAL_PENDBASER_VALUE						  \
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 94b3479..04a397c 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -30,11 +30,20 @@
 
 #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
 
+#define   KVM_DEV_ARM_VGIC_SYSREG_MASK (KVM_REG_ARM64_SYSREG_OP0_MASK | \
+					KVM_REG_ARM64_SYSREG_OP1_MASK | \
+					KVM_REG_ARM64_SYSREG_CRN_MASK | \
+					KVM_REG_ARM64_SYSREG_CRM_MASK | \
+					KVM_REG_ARM64_SYSREG_OP2_MASK)
+
 struct vgic_vmcr {
 	u32	ctlr;
 	u32	abpr;
 	u32	bpr;
 	u32	pmr;
+	/* Below member variable are valid only for GICv3 */
+	u32	grpen0;
+	u32	grpen1;
 };
 
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
@@ -94,6 +103,10 @@ int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
 int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
+int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			 u64 id, u64 *val);
+int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
+				u64 *reg);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -172,6 +185,8 @@ static inline int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 #endif
 
 int kvm_register_vgic_device(unsigned long type);
+void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 int vgic_lazy_init(struct kvm *kvm);
 int vgic_init(struct kvm *kvm);
 
-- 
1.9.1
