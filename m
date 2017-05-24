From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH] KVM: arm/arm64: Fix isues with GICv2 on GICv3 migration
Date: Wed, 24 May 2017 09:43:44 +0200
Message-ID: <20170524074344.11448-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, wanghaibin.wang@huawei.com, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We have been a little loose with our intermediate VMCR representation
where we had a 'ctlr' field, but we failed to differentiate between the
GICv2 GICC_CTLR and ICC_CTLR_EL1 layouts, and therefore ended up mapping
the wrong bits into the individual fields of the ICH_VMCR_EL2 when
emulating a GICv2 on a GICv3 system.

Fix this by using explicit fields for the VMCR bits instead.

Cc: Eric Auger <eric.auger@redhat.com>
Reported-by: wanghaibin <wanghaibin.wang@huawei.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c   | 10 ++++----
 include/linux/irqchip/arm-gic-v3.h |  4 ++++
 include/linux/irqchip/arm-gic.h    | 28 ++++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-mmio-v2.c   | 16 +++++++++++--
 virt/kvm/arm/vgic/vgic-v2.c        | 28 ++++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-v3.c        | 47 ++++++++++++++++++++++++++------------
 virt/kvm/arm/vgic/vgic.h           | 12 ++++++----
 7 files changed, 114 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 79f37e3..6260b69 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -65,8 +65,8 @@ static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		 * Here set VMCR.CTLR in ICC_CTLR_EL1 layout.
 		 * The vgic_set_vmcr() will convert to ICH_VMCR layout.
 		 */
-		vmcr.ctlr = val & ICC_CTLR_EL1_CBPR_MASK;
-		vmcr.ctlr |= val & ICC_CTLR_EL1_EOImode_MASK;
+		vmcr.cbpr = (val & ICC_CTLR_EL1_CBPR_MASK) >> ICC_CTLR_EL1_CBPR_SHIFT;
+		vmcr.eoim = (val & ICC_CTLR_EL1_EOImode_MASK) >> ICC_CTLR_EL1_EOImode_SHIFT;
 		vgic_set_vmcr(vcpu, &vmcr);
 	} else {
 		val = 0;
@@ -83,8 +83,8 @@ static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		 * The VMCR.CTLR value is in ICC_CTLR_EL1 layout.
 		 * Extract it directly using ICC_CTLR_EL1 reg definitions.
 		 */
-		val |= vmcr.ctlr & ICC_CTLR_EL1_CBPR_MASK;
-		val |= vmcr.ctlr & ICC_CTLR_EL1_EOImode_MASK;
+		val |= (vmcr.cbpr << ICC_CTLR_EL1_CBPR_SHIFT) & ICC_CTLR_EL1_CBPR_MASK;
+		val |= (vmcr.eoim << ICC_CTLR_EL1_EOImode_SHIFT) & ICC_CTLR_EL1_EOImode_MASK;
 
 		p->regval = val;
 	}
@@ -135,7 +135,7 @@ static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		p->regval = 0;
 
 	vgic_get_vmcr(vcpu, &vmcr);
-	if (!((vmcr.ctlr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT)) {
+	if (!vmcr.cbpr) {
 		if (p->is_write) {
 			vmcr.abpr = (p->regval & ICC_BPR1_EL1_MASK) >>
 				     ICC_BPR1_EL1_SHIFT;
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index fffb912..1fa293a 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -417,6 +417,10 @@
 #define ICH_HCR_EN			(1 << 0)
 #define ICH_HCR_UIE			(1 << 1)
 
+#define ICH_VMCR_ACK_CTL_SHIFT		2
+#define ICH_VMCR_ACK_CTL_MASK		(1 << ICH_VMCR_ACK_CTL_SHIFT)
+#define ICH_VMCR_FIQ_EN_SHIFT		3
+#define ICH_VMCR_FIQ_EN_MASK		(1 << ICH_VMCR_FIQ_EN_SHIFT)
 #define ICH_VMCR_CBPR_SHIFT		4
 #define ICH_VMCR_CBPR_MASK		(1 << ICH_VMCR_CBPR_SHIFT)
 #define ICH_VMCR_EOIM_SHIFT		9
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index dc30f3d..d3453ee 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -25,7 +25,18 @@
 #define GICC_ENABLE			0x1
 #define GICC_INT_PRI_THRESHOLD		0xf0
 
-#define GIC_CPU_CTRL_EOImodeNS		(1 << 9)
+#define GIC_CPU_CTRL_EnableGrp0_SHIFT	0
+#define GIC_CPU_CTRL_EnableGrp0		(1 << GIC_CPU_CTRL_EnableGrp0_SHIFT)
+#define GIC_CPU_CTRL_EnableGrp1_SHIFT	1
+#define GIC_CPU_CTRL_EnableGrp1		(1 << GIC_CPU_CTRL_EnableGrp1_SHIFT)
+#define GIC_CPU_CTRL_AckCtl_SHIFT	2
+#define GIC_CPU_CTRL_AckCtl		(1 << GIC_CPU_CTRL_AckCtl_SHIFT)
+#define GIC_CPU_CTRL_FIQEn_SHIFT	3
+#define GIC_CPU_CTRL_FIQEn		(1 << GIC_CPU_CTRL_FIQEn_SHIFT)
+#define GIC_CPU_CTRL_CBPR_SHIFT		4
+#define GIC_CPU_CTRL_CBPR		(1 << GIC_CPU_CTRL_CBPR_SHIFT)
+#define GIC_CPU_CTRL_EOImodeNS_SHIFT	9
+#define GIC_CPU_CTRL_EOImodeNS		(1 << GIC_CPU_CTRL_EOImodeNS_SHIFT)
 
 #define GICC_IAR_INT_ID_MASK		0x3ff
 #define GICC_INT_SPURIOUS		1023
@@ -84,8 +95,19 @@
 #define GICH_LR_EOI			(1 << 19)
 #define GICH_LR_HW			(1 << 31)
 
-#define GICH_VMCR_CTRL_SHIFT		0
-#define GICH_VMCR_CTRL_MASK		(0x21f << GICH_VMCR_CTRL_SHIFT)
+#define GICH_VMCR_ENABLE_GRP0_SHIFT	0
+#define GICH_VMCR_ENABLE_GRP0_MASK	(1 << GICH_VMCR_ENABLE_GRP0_SHIFT)
+#define GICH_VMCR_ENABLE_GRP1_SHIFT	1
+#define GICH_VMCR_ENABLE_GRP1_MASK	(1 << GICH_VMCR_ENABLE_GRP1_SHIFT)
+#define GICH_VMCR_ACK_CTL_SHIFT		2
+#define GICH_VMCR_ACK_CTL_MASK		(1 << GICH_VMCR_ACK_CTL_SHIFT)
+#define GICH_VMCR_FIQ_EN_SHIFT		3
+#define GICH_VMCR_FIQ_EN_MASK		(1 << GICH_VMCR_FIQ_EN_SHIFT)
+#define GICH_VMCR_CBPR_SHIFT		4
+#define GICH_VMCR_CBPR_MASK		(1 << GICH_VMCR_CBPR_SHIFT)
+#define GICH_VMCR_EOI_MODE_SHIFT	9
+#define GICH_VMCR_EOI_MODE_MASK		(1 << GICH_VMCR_EOI_MODE_SHIFT)
+
 #define GICH_VMCR_PRIMASK_SHIFT		27
 #define GICH_VMCR_PRIMASK_MASK		(0x1f << GICH_VMCR_PRIMASK_SHIFT)
 #define GICH_VMCR_BINPOINT_SHIFT	21
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 0a4283e..63e0bbd 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -226,7 +226,13 @@ static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
 
 	switch (addr & 0xff) {
 	case GIC_CPU_CTRL:
-		val = vmcr.ctlr;
+		val = vmcr.grpen0 << GIC_CPU_CTRL_EnableGrp0_SHIFT;
+		val |= vmcr.grpen1 << GIC_CPU_CTRL_EnableGrp1_SHIFT;
+		val |= vmcr.ackctl << GIC_CPU_CTRL_AckCtl_SHIFT;
+		val |= vmcr.fiqen << GIC_CPU_CTRL_FIQEn_SHIFT;
+		val |= vmcr.cbpr << GIC_CPU_CTRL_CBPR_SHIFT;
+		val |= vmcr.eoim << GIC_CPU_CTRL_EOImodeNS_SHIFT;
+
 		break;
 	case GIC_CPU_PRIMASK:
 		/*
@@ -267,7 +273,13 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 
 	switch (addr & 0xff) {
 	case GIC_CPU_CTRL:
-		vmcr.ctlr = val;
+		vmcr.grpen0 = !!(val & GIC_CPU_CTRL_EnableGrp0);
+		vmcr.grpen1 = !!(val & GIC_CPU_CTRL_EnableGrp1);
+		vmcr.ackctl = !!(val & GIC_CPU_CTRL_AckCtl);
+		vmcr.fiqen = !!(val & GIC_CPU_CTRL_FIQEn);
+		vmcr.cbpr = !!(val & GIC_CPU_CTRL_CBPR);
+		vmcr.eoim = !!(val & GIC_CPU_CTRL_EOImodeNS);
+
 		break;
 	case GIC_CPU_PRIMASK:
 		/*
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 504b4bd..e4187e5 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -177,7 +177,18 @@ void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 	u32 vmcr;
 
-	vmcr  = (vmcrp->ctlr << GICH_VMCR_CTRL_SHIFT) & GICH_VMCR_CTRL_MASK;
+	vmcr = (vmcrp->grpen0 << GICH_VMCR_ENABLE_GRP0_SHIFT) &
+		GICH_VMCR_ENABLE_GRP0_MASK;
+	vmcr |= (vmcrp->grpen1 << GICH_VMCR_ENABLE_GRP1_SHIFT) &
+		GICH_VMCR_ENABLE_GRP1_MASK;
+	vmcr |= (vmcrp->ackctl << GICH_VMCR_ACK_CTL_SHIFT) &
+		GICH_VMCR_ACK_CTL_MASK;
+	vmcr |= (vmcrp->fiqen << GICH_VMCR_FIQ_EN_SHIFT) &
+		GICH_VMCR_FIQ_EN_MASK;
+	vmcr |= (vmcrp->cbpr << GICH_VMCR_CBPR_SHIFT) &
+		GICH_VMCR_CBPR_MASK;
+	vmcr |= (vmcrp->eoim << GICH_VMCR_EOI_MODE_SHIFT) &
+		GICH_VMCR_EOI_MODE_MASK;
 	vmcr |= (vmcrp->abpr << GICH_VMCR_ALIAS_BINPOINT_SHIFT) &
 		GICH_VMCR_ALIAS_BINPOINT_MASK;
 	vmcr |= (vmcrp->bpr << GICH_VMCR_BINPOINT_SHIFT) &
@@ -195,8 +206,19 @@ void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 
 	vmcr = cpu_if->vgic_vmcr;
 
-	vmcrp->ctlr = (vmcr & GICH_VMCR_CTRL_MASK) >>
-			GICH_VMCR_CTRL_SHIFT;
+	vmcrp->grpen0 = (vmcr & GICH_VMCR_ENABLE_GRP0_MASK) >>
+		GICH_VMCR_ENABLE_GRP0_SHIFT;
+	vmcrp->grpen1 = (vmcr & GICH_VMCR_ENABLE_GRP1_MASK) >>
+		GICH_VMCR_ENABLE_GRP1_SHIFT;
+	vmcrp->ackctl = (vmcr & GICH_VMCR_ACK_CTL_MASK) >>
+		GICH_VMCR_ACK_CTL_SHIFT;
+	vmcrp->fiqen = (vmcr & GICH_VMCR_FIQ_EN_MASK) >>
+		GICH_VMCR_FIQ_EN_SHIFT;
+	vmcrp->cbpr = (vmcr & GICH_VMCR_CBPR_MASK) >>
+		GICH_VMCR_CBPR_SHIFT;
+	vmcrp->eoim = (vmcr & GICH_VMCR_EOI_MODE_MASK) >>
+		GICH_VMCR_EOI_MODE_SHIFT;
+
 	vmcrp->abpr = (vmcr & GICH_VMCR_ALIAS_BINPOINT_MASK) >>
 			GICH_VMCR_ALIAS_BINPOINT_SHIFT;
 	vmcrp->bpr  = (vmcr & GICH_VMCR_BINPOINT_MASK) >>
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 6fe3f00..030248e 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -159,15 +159,24 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	u32 vmcr;
 
-	/*
-	 * Ignore the FIQen bit, because GIC emulation always implies
-	 * SRE=1 which means the vFIQEn bit is also RES1.
-	 */
-	vmcr = ((vmcrp->ctlr >> ICC_CTLR_EL1_EOImode_SHIFT) <<
-		 ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
-	vmcr |= (vmcrp->ctlr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
+	if (model == KVM_DEV_TYPE_ARM_VGIC_V2) {
+		vmcr = (vmcrp->ackctl << ICH_VMCR_ACK_CTL_SHIFT) &
+			ICH_VMCR_ACK_CTL_MASK;
+		vmcr |= (vmcrp->fiqen << ICH_VMCR_FIQ_EN_SHIFT) &
+			ICH_VMCR_FIQ_EN_MASK;
+	} else {
+		/*
+		 * When emulating GICv3 on GICv3 with SRE=1 on the
+		 * VFIQEn bit is RES1 and the VAckCtl bit is RES0.
+		 */
+		vmcr = ICH_VMCR_FIQ_EN_MASK;
+	}
+
+	vmcr |= (vmcrp->cbpr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
+	vmcr |= (vmcrp->eoim << ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
 	vmcr |= (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
 	vmcr |= (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
 	vmcr |= (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
@@ -180,17 +189,27 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	u32 vmcr;
 
 	vmcr = cpu_if->vgic_vmcr;
 
-	/*
-	 * Ignore the FIQen bit, because GIC emulation always implies
-	 * SRE=1 which means the vFIQEn bit is also RES1.
-	 */
-	vmcrp->ctlr = ((vmcr >> ICH_VMCR_EOIM_SHIFT) <<
-			ICC_CTLR_EL1_EOImode_SHIFT) & ICC_CTLR_EL1_EOImode_MASK;
-	vmcrp->ctlr |= (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
+	if (model == KVM_DEV_TYPE_ARM_VGIC_V2) {
+		vmcrp->ackctl = (vmcr & ICH_VMCR_ACK_CTL_MASK) >>
+			ICH_VMCR_ACK_CTL_SHIFT;
+		vmcrp->fiqen = (vmcr & ICH_VMCR_FIQ_EN_MASK) >>
+			ICH_VMCR_FIQ_EN_SHIFT;
+	} else {
+		/*
+		 * When emulating GICv3 on GICv3 with SRE=1 on the
+		 * VFIQEn bit is RES1 and the VAckCtl bit is RES0.
+		 */
+		vmcrp->fiqen = 1;
+		vmcrp->ackctl = 0;
+	}
+
+	vmcrp->cbpr = (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
+	vmcrp->eoim = (vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT;
 	vmcrp->abpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
 	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
 	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index da83e4c..bba7fa2 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -111,14 +111,18 @@ static inline bool irq_is_pending(struct vgic_irq *irq)
  * registers regardless of the hardware backed GIC used.
  */
 struct vgic_vmcr {
-	u32	ctlr;
+	u32	grpen0;
+	u32	grpen1;
+
+	u32	ackctl;
+	u32	fiqen;
+	u32	cbpr;
+	u32	eoim;
+
 	u32	abpr;
 	u32	bpr;
 	u32	pmr;  /* Priority mask field in the GICC_PMR and
 		       * ICC_PMR_EL1 priority field format */
-	/* Below member variable are valid only for GICv3 */
-	u32	grpen0;
-	u32	grpen1;
 };
 
 struct vgic_reg_attr {
-- 
2.9.0
