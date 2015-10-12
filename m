From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v5 6/7] KVM: arm64: Implement vGICv3 CPU interface access
Date: Mon, 12 Oct 2015 11:29:38 +0300
Message-ID: <384a5c3dd63ad07d65937d064f13172a751ada8a.1444638023.git.p.fedin@samsung.com>
References: <cover.1444638023.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76418411BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 04:27:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kaBrWPKXtx8r for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Oct 2015 04:27:47 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9D8141E71
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 04:27:44 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NW300IR6M9SKB80@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 12 Oct 2015 09:29:52 +0100 (BST)
In-reply-to: <cover.1444638023.git.p.fedin@samsung.com>
In-reply-to: <cover.1444638023.git.p.fedin@samsung.com>
References: <cover.1444638023.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Access size is always 64 bits. Since CPU interface state actually affects
only a single vCPU, no vGIC locking is done in order to avoid code
duplication. Just made sure that the vCPU is not running.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm64/include/uapi/asm/kvm.h  |  14 ++-
 include/linux/irqchip/arm-gic-v3.h |  18 ++-
 virt/kvm/arm/vgic-v3-emul.c        | 232 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 258 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 2db09d8..4f90454 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -179,14 +179,14 @@ struct kvm_arch_memory_slot {
 	KVM_REG_ARM64_SYSREG_ ## n ## _MASK)
 
 #define __ARM64_SYS_REG(op0,op1,crn,crm,op2) \
-	(KVM_REG_ARM64 | KVM_REG_ARM64_SYSREG | \
-	ARM64_SYS_REG_SHIFT_MASK(op0, OP0) | \
+	(ARM64_SYS_REG_SHIFT_MASK(op0, OP0) | \
 	ARM64_SYS_REG_SHIFT_MASK(op1, OP1) | \
 	ARM64_SYS_REG_SHIFT_MASK(crn, CRN) | \
 	ARM64_SYS_REG_SHIFT_MASK(crm, CRM) | \
 	ARM64_SYS_REG_SHIFT_MASK(op2, OP2))
 
-#define ARM64_SYS_REG(...) (__ARM64_SYS_REG(__VA_ARGS__) | KVM_REG_SIZE_U64)
+#define ARM64_SYS_REG(...) (__ARM64_SYS_REG(__VA_ARGS__) | KVM_REG_ARM64 | \
+			    KVM_REG_SIZE_U64 | KVM_REG_ARM64_SYSREG)
 
 #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
 #define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
@@ -204,6 +204,14 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
 #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
+#define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
+#define   KVM_DEV_ARM_VGIC_SYSREG_MASK	(KVM_REG_ARM64_SYSREG_OP0_MASK | \
+					 KVM_REG_ARM64_SYSREG_OP1_MASK | \
+					 KVM_REG_ARM64_SYSREG_CRN_MASK | \
+					 KVM_REG_ARM64_SYSREG_CRM_MASK | \
+					 KVM_REG_ARM64_SYSREG_OP2_MASK)
+#define   KVM_DEV_ARM_VGIC_SYSREG(op0,op1,crn,crm,op2) \
+					__ARM64_SYS_REG(op0,op1,crn,crm,op2)
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index add60bb..eafc47f 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -261,8 +261,14 @@
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
@@ -287,6 +293,14 @@
 
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
index ca1d553..c2e1e2a 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -48,6 +48,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
 
+#include "sys_regs.h"
 #include "vgic.h"
 
 static bool handle_mmio_rao_wi(struct kvm_vcpu *vcpu,
@@ -991,6 +992,227 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
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
+	if (p->is_write)
+		vgicv3->vgic_ap0r[idx] = *p->val;
+	else
+		*p->val = vgicv3->vgic_ap0r[idx];
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
+	if (p->is_write)
+		vgicv3->vgic_ap1r[idx] = *p->val;
+	else
+		*p->val = vgicv3->vgic_ap1r[idx];
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
+static int vgic_v3_cpu_regs_access(struct kvm_vcpu *vcpu, u64 id, u64 *reg,
+				   bool is_write)
+{
+	struct sys_reg_params params;
+	const struct sys_reg_desc *r;
+
+	params.val = (u_long *)reg;
+	params.is_write = is_write;
+	params.is_aarch32 = false;
+	params.is_32bit = false;
+
+	r = find_reg_by_id(id, &params, gic_v3_icc_reg_descs,
+			   ARRAY_SIZE(gic_v3_icc_reg_descs));
+	if (!r)
+		return -ENXIO;
+
+	/* Ensure that VCPU is not running */
+	if (unlikely(vcpu->cpu != -1))
+			return -EBUSY;
+
+	return r->access(vcpu, &params, r) ? 0 : -EINVAL;
+}
+
 static u32 vgic_v3_get_reg_size(u32 group, u32 offset)
 {
 	switch (group) {
@@ -1021,7 +1243,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 	const struct vgic_io_range *ranges;
 	phys_addr_t offset;
 	struct kvm_vcpu *vcpu;
-	u64 cpuid;
+	u64 cpuid, regid;
 	struct vgic_dist *vgic = &dev->kvm->arch.vgic;
 	struct kvm_exit_mmio mmio;
 	__le64 data;
@@ -1046,6 +1268,14 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		mmio.phys_addr = vgic->vgic_redist_base + offset;
 		ranges = vgic_redist_ranges;
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		/*
+		 * Our register ID is missing size specifier, expected by
+		 * index_to_params()
+		 */
+		regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_MASK) |
+			KVM_REG_SIZE_U64;
+		return vgic_v3_cpu_regs_access(vcpu, regid, reg, is_write);
 	default:
 		return -ENXIO;
 	}
-- 
2.4.4
