From: vijay.kilari@gmail.com
Subject: [RFC PATCH v1 4/4] arm/arm64: vgic-new: Implement VGICv3 CPU
 interface access
Date: Wed, 20 Jul 2016 18:32:28 +0530
Message-ID: <1469019748-31005-5-git-send-email-vijay.kilari@gmail.com>
References: <1469019748-31005-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B162049B2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 08:56:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zom2wcPzLfmz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2016 08:56:52 -0400 (EDT)
Received: from mail-pf0-f194.google.com (mail-pf0-f194.google.com
 [209.85.192.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CEF049B3F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 08:56:52 -0400 (EDT)
Received: by mail-pf0-f194.google.com with SMTP id i6so3477157pfe.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 06:03:03 -0700 (PDT)
In-Reply-To: <1469019748-31005-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: Prasun.Kapoor@cavium.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

CPU sysregs access size is always 64 bits. MPIDR value
passed along with reg id is used to identify the CPU.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 arch/arm64/include/uapi/asm/kvm.h   |    9 ++
 arch/arm64/kvm/Makefile             |    1 +
 include/linux/irqchip/arm-gic-v3.h  |    4 +
 virt/kvm/arm/vgic/vgic-kvm-device.c |   31 +++++
 virt/kvm/arm/vgic/vgic-mmio-v2.c    |    4 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c    |    6 +
 virt/kvm/arm/vgic/vgic-sys-reg-v3.c |  225 +++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            |    6 +
 8 files changed, 284 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index a6b996e..35c4a99 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -206,7 +206,16 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
 #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
+#define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
+
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
+#define   KVM_DEV_ARM_VGIC_SYSREG_MASK (KVM_REG_ARM64_SYSREG_OP0_MASK | \
+					KVM_REG_ARM64_SYSREG_OP1_MASK | \
+					KVM_REG_ARM64_SYSREG_CRN_MASK | \
+					KVM_REG_ARM64_SYSREG_CRM_MASK | \
+					KVM_REG_ARM64_SYSREG_OP2_MASK)
+#define   KVM_DEV_ARM_VGIC_SYSREG(op0, op1, crn, crm, op2) \
+					__ARM64_SYS_REG(op0, op1, crn, crm, op2)
 
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index f00b2cd..53400c1 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -29,5 +29,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-sys-reg-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index bfbd707..ae84cde 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -288,6 +288,10 @@
 
 #define ICH_VMCR_CTLR_SHIFT		0
 #define ICH_VMCR_CTLR_MASK		(0x21f << ICH_VMCR_CTLR_SHIFT)
+#define ICH_VMCR_ENG0_SHIFT		0
+#define ICH_VMCR_ENG0			(1 << ICH_VMCR_ENG0_SHIFT)
+#define ICH_VMCR_ENG1_SHIFT		1
+#define ICH_VMCR_ENG1			(1 << ICH_VMCR_ENG1_SHIFT)
 #define ICH_VMCR_BPR1_SHIFT		18
 #define ICH_VMCR_BPR1_MASK		(7 << ICH_VMCR_BPR1_SHIFT)
 #define ICH_VMCR_BPR0_SHIFT		21
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 996a720..78c50cc 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -266,6 +266,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 	int cpuid, ret, c;
 	struct kvm_vcpu *vcpu, *tmp_vcpu;
 	int vcpu_lock_idx = -1;
+	u64 regid;
 	struct vgic_dist *vgic = &dev->kvm->arch.vgic;
 
 	if (vgic->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
@@ -322,6 +323,16 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 		else
 			ret = -EINVAL;
 		break;
+	case KVM_DEV_ARM_VGIC_CPU_SYSREGS:
+		if (vgic->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+			regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_MASK) |
+				KVM_REG_SIZE_U64;
+			ret = vgic_v3_cpu_sysregs_uaccess(vcpu, is_write,
+							  regid, &reg->reg64);
+		} else {
+			ret = -EINVAL;
+		}
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -447,6 +458,15 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 
 		return vgic_attr_regs_access(dev, attr, &reg, true);
 	}
+	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		union ureg reg;
+
+		if (get_user(reg.reg64, uaddr))
+			return -EFAULT;
+
+		return vgic_attr_regs_access(dev, attr, &reg, true);
+	}
 	}
 	return -ENXIO;
 }
@@ -472,6 +492,16 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 		ret = put_user(reg.reg32, uaddr);
 		return ret;
 	}
+	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		union ureg reg;
+
+		ret = vgic_attr_regs_access(dev, attr, &reg, false);
+		if (ret)
+			return ret;
+		ret = put_user(reg.reg64, uaddr);
+		return ret;
+	}
 	}
 
 	return -ENXIO;
@@ -490,6 +520,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+	case KVM_DEV_ARM_VGIC_CPU_SYSREGS:
 		return vgic_v3_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index a213936..97d94b2 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -204,7 +204,7 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 	}
 }
 
-static void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
+void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
 	if (kvm_vgic_global_state.type == VGIC_V2)
 		vgic_v2_set_vmcr(vcpu, vmcr);
@@ -212,7 +212,7 @@ static void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 		vgic_v3_set_vmcr(vcpu, vmcr);
 }
 
-static void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
+void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
 	if (kvm_vgic_global_state.type == VGIC_V2)
 		vgic_v2_get_vmcr(vcpu, vmcr);
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index f6a4e97..aa63f39 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -23,6 +23,7 @@
 
 #include "vgic.h"
 #include "vgic-mmio.h"
+#include "sys_regs.h"
 
 /* extract @num bytes at @offset bytes offset in data */
 static unsigned long extract_bytes(unsigned long data, unsigned int offset,
@@ -382,6 +383,11 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 		nr_regions = rd_dev->nr_regions;
 		break;
 	}
+	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
+		u64 reg;
+
+		return vgic_v3_has_cpu_sysregs_attr(vcpu, 0, cpuid, &reg);
+	}
 	default:
 		return -ENXIO;
 	}
diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
new file mode 100644
index 0000000..d877cd8
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
@@ -0,0 +1,225 @@
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
+
+	vgic_get_vmcr(vcpu, &vmcr);
+	if (p->is_write) {
+		vmcr.ctlr = (u32)p->regval;
+		vgic_set_vmcr(vcpu, &vmcr);
+	} else {
+		p->regval = vmcr.ctlr;
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
+		vmcr.pmr = (u32)p->regval;
+		vgic_set_vmcr(vcpu, &vmcr);
+	} else {
+		p->regval = vmcr.pmr;
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
+		vmcr.bpr = (u32)p->regval;
+		vgic_set_vmcr(vcpu, &vmcr);
+	} else {
+		p->regval = vmcr.bpr;
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
+		vmcr.abpr = (u32)p->regval;
+		vgic_set_vmcr(vcpu, &vmcr);
+	} else {
+		p->regval = vmcr.abpr;
+	}
+
+	return true;
+}
+
+static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (p->is_write) {
+		vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG0;
+		vgicv3->vgic_vmcr |= (p->regval << ICH_VMCR_ENG0_SHIFT) &
+				      ICH_VMCR_ENG0;
+	} else {
+		p->regval = (vgicv3->vgic_vmcr & ICH_VMCR_ENG0) >>
+			     ICH_VMCR_ENG0_SHIFT;
+	}
+
+	return true;
+}
+
+static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (p->is_write) {
+		vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG1;
+		vgicv3->vgic_vmcr |= (p->regval << ICH_VMCR_ENG1_SHIFT) &
+				      ICH_VMCR_ENG1;
+	} else {
+		p->regval = (vgicv3->vgic_vmcr & ICH_VMCR_ENG1) >>
+			     ICH_VMCR_ENG1_SHIFT;
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
+static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
+	/* ICC_PMR_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0100), CRm(0b0110), Op2(0b000),
+	  access_gic_pmr },
+	/* ICC_BPR0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1000), Op2(0b011),
+	  access_gic_bpr0 },
+	/* ICC_AP0R0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1000), Op2(0b100),
+	  access_gic_ap0r },
+	/* ICC_AP0R1_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1000), Op2(0b101),
+	  access_gic_ap0r },
+	/* ICC_AP0R2_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1000), Op2(0b110),
+	  access_gic_ap0r },
+	/* ICC_AP0R3_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1000), Op2(0b111),
+	  access_gic_ap0r },
+	/* ICC_AP1R0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1001), Op2(0b000),
+	  access_gic_ap1r },
+	/* ICC_AP1R1_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1001), Op2(0b001),
+	  access_gic_ap1r },
+	/* ICC_AP1R2_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1001), Op2(0b010),
+	  access_gic_ap1r },
+	/* ICC_AP1R3_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1001), Op2(0b011),
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
+int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
+				u64 *reg)
+{
+	struct sys_reg_params params;
+
+	params.regval = le64_to_cpu(*reg);
+	params.is_write = is_write;
+	params.is_aarch32 = false;
+	params.is_32bit = false;
+
+	return find_reg_by_id(id, &params, gic_v3_icc_reg_descs,
+			      ARRAY_SIZE(gic_v3_icc_reg_descs)) ?
+		0 : -ENXIO;
+}
+
+int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
+				u64 *reg)
+{
+	struct sys_reg_params params;
+	const struct sys_reg_desc *r;
+
+	if (is_write)
+		params.regval = le64_to_cpu(*reg);
+	params.is_write = is_write;
+	params.is_aarch32 = false;
+	params.is_32bit = false;
+
+	r = find_reg_by_id(id, &params, gic_v3_icc_reg_descs,
+			   ARRAY_SIZE(gic_v3_icc_reg_descs));
+	if (!r)
+		return -ENXIO;
+
+	if (!r->access(vcpu, &params, r))
+		return -EINVAL;
+
+	if (!is_write)
+		*reg = cpu_to_le64(params.regval);
+
+	return 0;
+}
+
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 8637690..23db38d 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -79,6 +79,10 @@ int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
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
@@ -132,6 +136,8 @@ static inline int vgic_register_redist_iodevs(struct kvm *kvm,
 }
 #endif
 
+void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void kvm_register_vgic_device(unsigned long type);
 int vgic_lazy_init(struct kvm *kvm);
 int vgic_init(struct kvm *kvm);
-- 
1.7.9.5
