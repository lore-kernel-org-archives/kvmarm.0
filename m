From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 5/5] KVM: arm/arm64: vgic: Get rid of struct vmcr for GICv2
Date: Tue, 21 Mar 2017 12:05:30 +0100
Message-ID: <20170321110530.15857-6-cdall@linaro.org>
References: <20170321110530.15857-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 016E040C56
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:04:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P1cwg5bs6SZc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 07:03:59 -0400 (EDT)
Received: from mail-wr0-f181.google.com (mail-wr0-f181.google.com
 [209.85.128.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3E2E40CE4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:03:57 -0400 (EDT)
Received: by mail-wr0-f181.google.com with SMTP id u108so109571955wrb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 04:05:44 -0700 (PDT)
In-Reply-To: <20170321110530.15857-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Vijaya.Kumar@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

There is no common code in the VGIC that uses the VMCR, so we have no
use of the intermediate architecture-agnostic representation of the VMCR
and might as well manipulate the bits specifically using the logic for
the version of the GIC that the code supports.

For GICv2, this means translating between the GICH_VMCR register format
stored in memory and the GICC_X registers exported to user space, with
the annoying quirk around the format of the GICC_PMR, where we export
the 8 bit prority field using the lower 5 bits and always assuming
bits[2:0] are clear.

This now lets us get completely rid of struct vmcr and its common
accessor functions.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 51 +++++++++++++++++++++++++++++-----------
 virt/kvm/arm/vgic/vgic-mmio.c    | 16 -------------
 virt/kvm/arm/vgic/vgic-v2.c      | 29 -----------------------
 virt/kvm/arm/vgic/vgic.h         | 14 -----------
 4 files changed, 37 insertions(+), 73 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index a3ad7ff..1bdb990 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -219,23 +219,33 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
 					   gpa_t addr, unsigned int len)
 {
-	struct vgic_vmcr vmcr;
+	u32 vmcr = vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr;
 	u32 val;
 
-	vgic_get_vmcr(vcpu, &vmcr);
 
 	switch (addr & 0xff) {
 	case GIC_CPU_CTRL:
-		val = vmcr.ctlr;
+		val = (vmcr & GICH_VMCR_CTRL_MASK) >>
+			GICH_VMCR_CTRL_SHIFT;
 		break;
 	case GIC_CPU_PRIMASK:
-		val = vmcr.pmr;
+		/*
+		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
+		 * the PMR field as GICH_VMCR.VMPriMask rather than
+		 * GICC_PMR.Priority, so we expose the upper five bits of
+		 * priority mask to userspace using the lower bits in the
+		 * 32-bit word provided by userspace.
+		 */
+		val = (vmcr & GICH_VMCR_PRIMASK_MASK) >>
+			GICH_VMCR_PRIMASK_SHIFT;
 		break;
 	case GIC_CPU_BINPOINT:
-		val = vmcr.bpr;
+		val = (vmcr & GICH_VMCR_BINPOINT_MASK) >>
+			GICH_VMCR_BINPOINT_SHIFT;
 		break;
 	case GIC_CPU_ALIAS_BINPOINT:
-		val = vmcr.abpr;
+		val = (vmcr & GICH_VMCR_ALIAS_BINPOINT_MASK) >>
+			GICH_VMCR_ALIAS_BINPOINT_SHIFT;
 		break;
 	case GIC_CPU_IDENT:
 		val = ((PRODUCT_ID_KVM << 20) |
@@ -253,26 +263,39 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 				   gpa_t addr, unsigned int len,
 				   unsigned long val)
 {
-	struct vgic_vmcr vmcr;
-
-	vgic_get_vmcr(vcpu, &vmcr);
+	u32 *vmcr = &vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr;
+	u32 mask, field;
 
 	switch (addr & 0xff) {
 	case GIC_CPU_CTRL:
-		vmcr.ctlr = val;
+		mask = GICH_VMCR_CTRL_MASK;
+		field = val << GICH_VMCR_CTRL_SHIFT;
 		break;
 	case GIC_CPU_PRIMASK:
-		vmcr.pmr = val;
+		/*
+		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
+		 * the PMR field as GICH_VMCR.VMPriMask rather than
+		 * GICC_PMR.Priority, so we obtain the upper five bits of
+		 * priority mask from userspace using the lower bits in the
+		 * 32-bit word provided by userspace.
+		 */
+		mask = GICH_VMCR_PRIMASK_MASK;
+		field = val << GICH_VMCR_PRIMASK_SHIFT;
 		break;
 	case GIC_CPU_BINPOINT:
-		vmcr.bpr = val;
+		mask = GICH_VMCR_BINPOINT_MASK;
+		field = val << GICH_VMCR_BINPOINT_SHIFT;
 		break;
 	case GIC_CPU_ALIAS_BINPOINT:
-		vmcr.abpr = val;
+		mask = GICH_VMCR_ALIAS_BINPOINT_MASK;
+		field = val << GICH_VMCR_ALIAS_BINPOINT_SHIFT;
 		break;
+	default:
+		return;
 	}
 
-	vgic_set_vmcr(vcpu, &vmcr);
+	*vmcr &= ~mask;
+	*vmcr |= (field & mask);
 }
 
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index b53c66e..07635d4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -439,22 +439,6 @@ vgic_find_mmio_region(const struct vgic_register_region *region, int nr_regions,
 		       sizeof(region[0]), match_region);
 }
 
-void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
-{
-	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_set_vmcr(vcpu, vmcr);
-	else
-		BUG();
-}
-
-void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
-{
-	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_get_vmcr(vcpu, vmcr);
-	else
-		BUG();
-}
-
 /*
  * kvm_mmio_read_buf() returns a value in a format where it can be converted
  * to a byte array and be directly observed as the guest wanted it to appear
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index b834ecd..bfd1da0 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -182,35 +182,6 @@ void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr)
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = 0;
 }
 
-void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
-{
-	u32 vmcr;
-
-	vmcr  = (vmcrp->ctlr << GICH_VMCR_CTRL_SHIFT) & GICH_VMCR_CTRL_MASK;
-	vmcr |= (vmcrp->abpr << GICH_VMCR_ALIAS_BINPOINT_SHIFT) &
-		GICH_VMCR_ALIAS_BINPOINT_MASK;
-	vmcr |= (vmcrp->bpr << GICH_VMCR_BINPOINT_SHIFT) &
-		GICH_VMCR_BINPOINT_MASK;
-	vmcr |= (vmcrp->pmr << GICH_VMCR_PRIMASK_SHIFT) &
-		GICH_VMCR_PRIMASK_MASK;
-
-	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = vmcr;
-}
-
-void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
-{
-	u32 vmcr = vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr;
-
-	vmcrp->ctlr = (vmcr & GICH_VMCR_CTRL_MASK) >>
-			GICH_VMCR_CTRL_SHIFT;
-	vmcrp->abpr = (vmcr & GICH_VMCR_ALIAS_BINPOINT_MASK) >>
-			GICH_VMCR_ALIAS_BINPOINT_SHIFT;
-	vmcrp->bpr  = (vmcr & GICH_VMCR_BINPOINT_MASK) >>
-			GICH_VMCR_BINPOINT_SHIFT;
-	vmcrp->pmr  = (vmcr & GICH_VMCR_PRIMASK_MASK) >>
-			GICH_VMCR_PRIMASK_SHIFT;
-}
-
 void vgic_v2_enable(struct kvm_vcpu *vcpu)
 {
 	/*
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 5652983..9ffc4d4 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -81,16 +81,6 @@ static inline bool irq_is_pending(struct vgic_irq *irq)
 		return irq->pending_latch || irq->line_level;
 }
 
-struct vgic_vmcr {
-	u32	ctlr;
-	u32	abpr;
-	u32	bpr;
-	u32	pmr;
-	/* Below member variable are valid only for GICv3 */
-	u32	grpen0;
-	u32	grpen1;
-};
-
 struct vgic_reg_attr {
 	struct kvm_vcpu *vcpu;
 	gpa_t addr;
@@ -122,8 +112,6 @@ int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
 int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			  int offset, u32 *val);
-void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
-void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_enable(struct kvm_vcpu *vcpu);
 int vgic_v2_probe(const struct gic_kvm_info *info);
 int vgic_v2_map_resources(struct kvm *kvm);
@@ -165,8 +153,6 @@ int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 				    u32 intid, u64 *val);
 int kvm_register_vgic_device(unsigned long type);
-void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
-void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 int vgic_lazy_init(struct kvm *kvm);
 int vgic_init(struct kvm *kvm);
 
-- 
2.9.0
