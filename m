From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 36/45] KVM: arm/arm64: vgic-new: Add GICH_VMCR accessors
Date: Fri, 25 Mar 2016 02:04:59 +0000
Message-ID: <1458871508-17279-37-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 307F849AFA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iZ4mD9FS+HGs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:05:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1877640FA2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:19 -0400 (EDT)
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

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h     |  7 +++++++
 virt/kvm/arm/vgic/vgic-v2.c | 29 +++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c | 22 ++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c    | 16 ++++++++++++++++
 virt/kvm/arm/vgic/vgic.h    | 18 ++++++++++++++++++
 5 files changed, 92 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 43b4537..c4102a0 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -167,6 +167,13 @@ struct vgic_v3_cpu_if {
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
index 1cec423..fe6da47 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -180,6 +180,35 @@ out:
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = val;
 }
 
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
+
 void vgic_v2_irq_change_affinity(struct kvm *kvm, u32 intid, u8 new_targets)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 71b4bad..04ef7f9 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -189,3 +189,25 @@ void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid, u64 mpidr)
 	irq->target_vcpu = vcpu;
 	spin_unlock(&irq->irq_lock);
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
index d6c8c92..8c19379 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -401,6 +401,22 @@ static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
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
index c8fd30c..c6d3ff6 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -36,6 +36,8 @@ void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
 int vgic_v2_dist_access(struct kvm_vcpu *vcpu, bool is_write,
 			int offset, int len, void *val);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
+void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid, u64 mpidr);
@@ -47,6 +49,8 @@ int vgic_v3_dist_access(struct kvm_vcpu *vcpu, bool is_write,
 			int offset, int len, void *val);
 int vgic_v3_redist_access(struct kvm_vcpu *vcpu, bool is_write,
 			  int offset, int len, void *val);
+void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 #else
 static inline void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid,
 					       u64 mpidr)
@@ -81,8 +85,22 @@ static inline int vgic_v3_redist_access(struct kvm_vcpu *vcpu, bool is_write,
 {
 	return -ENXIO;
 }
+
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
