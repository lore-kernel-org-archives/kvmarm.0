From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 45/54] KVM: arm/arm64: vgic-new: Add GICH_VMCR accessors
Date: Thu, 28 Apr 2016 17:46:04 +0100
Message-ID: <1461861973-26464-46-git-send-email-andre.przywara@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Since the GIC CPU interface is always virtualized by the hardware,
we don't have CPU interface state information readily available in our
emulation if userland wants to save or restore it.
Fortunately the GIC hypervisor interface provides the VMCR register to
access the required virtual CPU interface bits.
Provide wrappers for GICv2 and GICv3 hosts to have access to this
register.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h     |  7 +++++++
 virt/kvm/arm/vgic/vgic-v2.c | 29 +++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c | 22 ++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c    | 16 ++++++++++++++++
 virt/kvm/arm/vgic/vgic.h    | 17 +++++++++++++++++
 5 files changed, 91 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 73cab36..cfc3640 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -171,6 +171,13 @@ struct vgic_v3_cpu_if {
 #endif
 };
 
+struct vgic_vmcr {
+	u32	ctlr;
+	u32	abpr;
+	u32	bpr;
+	u32	pmr;
+};
+
 struct vgic_cpu {
 	/* CPU vif control registers for world switch */
 	union {
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 4cee616..70cac63 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -176,3 +176,32 @@ void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr)
 {
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = 0;
 }
+
+void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	u32 vmcr;
+
+	vmcr  = (vmcrp->ctlr << GICH_VMCR_CTRL_SHIFT) & GICH_VMCR_CTRL_MASK;
+	vmcr |= (vmcrp->abpr << GICH_VMCR_ALIAS_BINPOINT_SHIFT) &
+		GICH_VMCR_ALIAS_BINPOINT_MASK;
+	vmcr |= (vmcrp->bpr << GICH_VMCR_BINPOINT_SHIFT) &
+		GICH_VMCR_BINPOINT_MASK;
+	vmcr |= (vmcrp->pmr << GICH_VMCR_PRIMASK_SHIFT) &
+		GICH_VMCR_PRIMASK_MASK;
+
+	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = vmcr;
+}
+
+void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	u32 vmcr = vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr;
+
+	vmcrp->ctlr = (vmcr & GICH_VMCR_CTRL_MASK) >>
+			GICH_VMCR_CTRL_SHIFT;
+	vmcrp->abpr = (vmcr & GICH_VMCR_ALIAS_BINPOINT_MASK) >>
+			GICH_VMCR_ALIAS_BINPOINT_SHIFT;
+	vmcrp->bpr  = (vmcr & GICH_VMCR_BINPOINT_MASK) >>
+			GICH_VMCR_BINPOINT_SHIFT;
+	vmcrp->pmr  = (vmcr & GICH_VMCR_PRIMASK_MASK) >>
+			GICH_VMCR_PRIMASK_SHIFT;
+}
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 461229b..2c55bd5 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -167,3 +167,25 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
 {
 	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = 0;
 }
+
+void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	u32 vmcr;
+
+	vmcr  = (vmcrp->ctlr << ICH_VMCR_CTLR_SHIFT) & ICH_VMCR_CTLR_MASK;
+	vmcr |= (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
+	vmcr |= (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
+	vmcr |= (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
+
+	vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr = vmcr;
+}
+
+void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	u32 vmcr = vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr;
+
+	vmcrp->ctlr = (vmcr & ICH_VMCR_CTLR_MASK) >> ICH_VMCR_CTLR_SHIFT;
+	vmcrp->abpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
+	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
+	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
+}
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index eeb766e..763475d 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -440,6 +440,22 @@ static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
 		vgic_v3_set_underflow(vcpu);
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
 static int compute_ap_list_depth(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index a048a2b..ea72f32 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -39,6 +39,8 @@ void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
 int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
+void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
@@ -46,6 +48,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
+void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -68,8 +72,21 @@ static inline void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
 {
 }
 
+static inline
+void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
+{
+}
+
+static inline
+void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
+{
+}
+
 #endif
 
+void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+
 void kvm_register_vgic_device(unsigned long type);
 
 #endif
-- 
2.7.3

