From: vijay.kilari@gmail.com
Subject: [PATCH v11 5/8] arm/arm64: vgic: Introduce VENG0 and VENG1 fields to
 vmcr struct
Date: Thu, 26 Jan 2017 19:50:50 +0530
Message-ID: <1485440453-10597-6-git-send-email-vijay.kilari@gmail.com>
References: <1485440453-10597-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B3D240064
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 09:21:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WRHhHgK8e973 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Jan 2017 09:21:41 -0500 (EST)
Received: from mail-pg0-f67.google.com (mail-pg0-f67.google.com [74.125.83.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B09F40019
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 09:21:41 -0500 (EST)
Received: by mail-pg0-f67.google.com with SMTP id 204so22486661pge.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 06:21:51 -0800 (PST)
In-Reply-To: <1485440453-10597-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, eric.auger@redhat.com, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

ICC_VMCR_EL2 supports virtual access to ICC_IGRPEN1_EL1.Enable
and ICC_IGRPEN0_EL1.Enable fields. Add grpen0 and grpen1 member
variables to struct vmcr to support read and write of these fields.

Also refactor vgic_set_vmcr and vgic_get_vmcr() code.
Drop ICH_VMCR_CTLR_SHIFT and ICH_VMCR_CTLR_MASK macros and instead
use ICH_VMCR_EOI* and ICH_VMCR_CBPR* macros.

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/linux/irqchip/arm-gic-v3.h |  2 --
 virt/kvm/arm/vgic/vgic-mmio-v2.c   | 16 ----------------
 virt/kvm/arm/vgic/vgic-mmio.c      | 16 ++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c        | 20 ++++++++++++++++++--
 virt/kvm/arm/vgic/vgic.h           |  5 +++++
 5 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 7f6d904..170e00a 100644
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
index fa68dd4..a3ad7ff 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -213,22 +213,6 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
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
index 746c8af..1d1886e 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -385,6 +385,22 @@ static int match_region(const void *key, const void *elt)
 		       sizeof(region[0]), match_region);
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
index 679ba93..42ff9c9 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -175,10 +175,18 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	u32 vmcr;
 
-	vmcr  = (vmcrp->ctlr << ICH_VMCR_CTLR_SHIFT) & ICH_VMCR_CTLR_MASK;
+	/*
+	 * Ignore the FIQen bit, because GIC emulation always implies
+	 * SRE=1 which means the vFIQEn bit is also RES1.
+	 */
+	vmcr = ((vmcrp->ctlr >> ICC_CTLR_EL1_EOImode_SHIFT) <<
+		 ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
+	vmcr |= (vmcrp->ctlr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
 	vmcr |= (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
 	vmcr |= (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
 	vmcr |= (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
+	vmcr |= (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
+	vmcr |= (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
 
 	vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr = vmcr;
 }
@@ -187,10 +195,18 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	u32 vmcr = vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr;
 
-	vmcrp->ctlr = (vmcr & ICH_VMCR_CTLR_MASK) >> ICH_VMCR_CTLR_SHIFT;
+	/*
+	 * Ignore the FIQen bit, because GIC emulation always implies
+	 * SRE=1 which means the vFIQEn bit is also RES1.
+	 */
+	vmcrp->ctlr = ((vmcr >> ICH_VMCR_EOIM_SHIFT) <<
+			ICC_CTLR_EL1_EOImode_SHIFT) & ICC_CTLR_EL1_EOImode_MASK;
+	vmcrp->ctlr |= (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
 	vmcrp->abpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
 	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
 	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
+	vmcrp->grpen0 = (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
+	vmcrp->grpen1 = (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
 }
 
 #define INITIAL_PENDBASER_VALUE						  \
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 4505fd4..ecfe1a6 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -65,6 +65,9 @@ struct vgic_vmcr {
 	u32	abpr;
 	u32	bpr;
 	u32	pmr;
+	/* Below member variable are valid only for GICv3 */
+	u32	grpen0;
+	u32	grpen1;
 };
 
 struct vgic_reg_attr {
@@ -137,6 +140,8 @@ int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
 int kvm_register_vgic_device(unsigned long type);
+void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 int vgic_lazy_init(struct kvm *kvm);
 int vgic_init(struct kvm *kvm);
 
-- 
1.9.1
