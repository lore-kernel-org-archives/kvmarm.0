From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 48/57] KVM: arm/arm64: vgic-new: Add GICH_VMCR accessors
Date: Thu, 19 May 2016 19:08:27 +0100
Message-ID: <1463681316-23039-49-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Since the GIC CPU interface is always virtualized by the hardware,
we don't have CPU interface state information readily available in our
emulation if userland wants to save or restore it.
Fortunately the GIC hypervisor interface provides the VMCR register to
access the required virtual CPU interface bits.
Provide wrappers for GICv2 and GICv3 hosts to have access to this
register.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changelog v2 .. v3:
- remove exported v2/v3 selector functions (as per Marc's patch)

Changelog v3 .. v4:
- move struct vgic_vmcr into the VGIC's private header file

 virt/kvm/arm/vgic/vgic-v2.c | 29 +++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c | 22 ++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h    | 21 +++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index fb5e65c..d943059 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -174,3 +174,32 @@ void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr)
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
index fb547da..8548297 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -160,3 +160,25 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
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
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index f826026..d2c1fd5 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -27,6 +27,13 @@
 
 #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
 
+struct vgic_vmcr {
+	u32	ctlr;
+	u32	abpr;
+	u32	bpr;
+	u32	pmr;
+};
+
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
@@ -40,6 +47,8 @@ void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
+void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type);
 
@@ -49,6 +58,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
+void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
@@ -72,6 +83,16 @@ static inline void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
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
 static inline int vgic_register_redist_iodevs(struct kvm *kvm,
 					      gpa_t dist_base_address)
 {
-- 
2.8.2

