From: vijay.kilari@gmail.com
Subject: [PATCH v6 5/7] arm/arm64: vgic-new: Introduce VENG0 and VENG1 fields
 to vmcr struct
Date: Tue, 20 Sep 2016 11:42:43 +0530
Message-ID: <1474351965-11586-6-git-send-email-vijay.kilari@gmail.com>
References: <1474351965-11586-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D75749B2E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2016 02:04:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pnem8Imw+rEJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2016 02:04:58 -0400 (EDT)
Received: from mail-pf0-f196.google.com (mail-pf0-f196.google.com
 [209.85.192.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 400DA49B30
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2016 02:04:57 -0400 (EDT)
Received: by mail-pf0-f196.google.com with SMTP id 21so461477pfy.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2016 23:13:59 -0700 (PDT)
In-Reply-To: <1474351965-11586-1-git-send-email-vijay.kilari@gmail.com>
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

ICC_VMCR_EL2 supports virtual access to ICC_IGRPEN1_EL1.Enable
and ICC_IGRPEN0_EL1.Enable fields. Add grpen0 and grpen1 member
variables to struct vmcr to support read and write of these fields.

Also refactor vgic_set_vmcr and vgic_get_vmcr() code.
Drop ICH_VMCR_CTLR_SHIFT and ICH_VMCR_CTLR_MASK macros and instead
use ICH_VMCR_EOI* and ICH_VMCR_CBPR* macros
.
Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 include/linux/irqchip/arm-gic-v3.h |  2 --
 virt/kvm/arm/vgic/vgic-mmio-v2.c   | 16 ----------------
 virt/kvm/arm/vgic/vgic-mmio.c      | 16 ++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c        | 10 ++++++++--
 virt/kvm/arm/vgic/vgic.h           |  5 +++++
 5 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 36402d4..0016002 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -404,8 +404,6 @@
 #define ICH_HCR_EN			(1 << 0)
 #define ICH_HCR_UIE			(1 << 1)
 
-#define ICH_VMCR_CTLR_SHIFT		0
-#define ICH_VMCR_CTLR_MASK		(0x21f << ICH_VMCR_CTLR_SHIFT)
 #define ICH_VMCR_CBPR_SHIFT		4
 #define ICH_VMCR_CBPR_MASK		(1 << ICH_VMCR_CBPR_SHIFT)
 #define ICH_VMCR_EOIM_SHIFT		9
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
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 9939d1d..173d6f0 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -416,6 +416,22 @@ int vgic_validate_mmio_region_addr(struct kvm_device *dev,
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
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 9f0dae3..967c295 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -175,10 +175,13 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	u32 vmcr;
 
-	vmcr  = (vmcrp->ctlr << ICH_VMCR_CTLR_SHIFT) & ICH_VMCR_CTLR_MASK;
+	vmcr  = (vmcrp->ctlr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
+	vmcr |= (vmcrp->ctlr << ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
 	vmcr |= (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
 	vmcr |= (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
 	vmcr |= (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
+	vmcr |= (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
+	vmcr |= (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
 
 	vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr = vmcr;
 }
@@ -187,10 +190,13 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	u32 vmcr = vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr;
 
-	vmcrp->ctlr = (vmcr & ICH_VMCR_CTLR_MASK) >> ICH_VMCR_CTLR_SHIFT;
+	vmcrp->ctlr = (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
+	vmcrp->ctlr |= (vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT;
 	vmcrp->abpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
 	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
 	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
+	vmcrp->grpen0 = (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
+	vmcrp->grpen1 = (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
 }
 
 #define INITIAL_PENDBASER_VALUE						  \
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index d901b0c..c461f6b 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -63,6 +63,9 @@ struct vgic_vmcr {
 	u32	abpr;
 	u32	bpr;
 	u32	pmr;
+	/* Below member variable are valid only for GICv3 */
+	u32	grpen0;
+	u32	grpen1;
 };
 
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
@@ -150,6 +153,8 @@ static inline int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 #endif
 
 int kvm_register_vgic_device(unsigned long type);
+void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 int vgic_lazy_init(struct kvm *kvm);
 int vgic_init(struct kvm *kvm);
 
-- 
1.9.1
