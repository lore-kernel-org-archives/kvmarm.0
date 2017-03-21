From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH] KVM: arm/arm64: vgic: Fix GICC_PMR uaccess on GICv3 and
 clarify ABI
Date: Tue, 21 Mar 2017 22:05:22 +0100
Message-ID: <20170321210522.8362-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EBD540C41
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 17:03:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3oR99eIFHDSP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 17:03:39 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8288940C2A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 17:03:38 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id n11so21165637wma.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 14:05:26 -0700 (PDT)
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

As an oversight, for GICv2, we accidentally export the GICC_PMR register
in the format of the GICH_VMCR.VMPriMask field in the lower 5 bits of a
word, meaning that userspace must always use the lower 5 bits to
communicate with the KVM device and must shift the value left by 3
places to obtain the actual priority mask level.

Since GICv3 supports the full 8 bits of priority masking in the ICH_VMCR,
we have to fix the value we export when emulating a GICv2 on top of a
hardware GICv3 and exporting the emulated GICv2 state to userspace.

Take the chance to clarify this aspect of the ABI.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt |  6 ++++++
 include/linux/irqchip/arm-gic.h                |  3 +++
 virt/kvm/arm/vgic/vgic-mmio-v2.c               | 20 ++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-v2.c                    |  8 ++++----
 virt/kvm/arm/vgic/vgic.h                       |  9 ++++++++-
 5 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 76e61c8..b2f60ca 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -83,6 +83,12 @@ Groups:
 
     Bits for undefined preemption levels are RAZ/WI.
 
+    For historical reasons and to provide ABI compatibility with userspace we
+    export the GICC_PMR register in the format of the GICH_VMCR.VMPriMask
+    field in the lower 5 bits of a word, meaning that userspace must always
+    use the lower 5 bits to communicate with the KVM device and must shift the
+    value left by 3 places to obtain the actual priority mask level.
+
   Limitations:
     - Priorities are not implemented, and registers are RAZ/WI
     - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index eafc965..dc30f3d 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -96,6 +96,9 @@
 #define GICH_MISR_EOI			(1 << 0)
 #define GICH_MISR_U			(1 << 1)
 
+#define GICV_PMR_PRIORITY_SHIFT		3
+#define GICV_PMR_PRIORITY_MASK		(0x1f << GICV_PMR_PRIORITY_SHIFT)
+
 #ifndef __ASSEMBLY__
 
 #include <linux/irqdomain.h>
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index a3ad7ff..0a4283e 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -229,7 +229,15 @@ static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
 		val = vmcr.ctlr;
 		break;
 	case GIC_CPU_PRIMASK:
-		val = vmcr.pmr;
+		/*
+		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
+		 * the PMR field as GICH_VMCR.VMPriMask rather than
+		 * GICC_PMR.Priority, so we expose the upper five bits of
+		 * priority mask to userspace using the lower bits in the
+		 * unsigned long.
+		 */
+		val = (vmcr.pmr & GICV_PMR_PRIORITY_MASK) >>
+			GICV_PMR_PRIORITY_SHIFT;
 		break;
 	case GIC_CPU_BINPOINT:
 		val = vmcr.bpr;
@@ -262,7 +270,15 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 		vmcr.ctlr = val;
 		break;
 	case GIC_CPU_PRIMASK:
-		vmcr.pmr = val;
+		/*
+		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
+		 * the PMR field as GICH_VMCR.VMPriMask rather than
+		 * GICC_PMR.Priority, so we expose the upper five bits of
+		 * priority mask to userspace using the lower bits in the
+		 * unsigned long.
+		 */
+		vmcr.pmr = (val << GICV_PMR_PRIORITY_SHIFT) &
+			GICV_PMR_PRIORITY_MASK;
 		break;
 	case GIC_CPU_BINPOINT:
 		vmcr.bpr = val;
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index b834ecd..955f24c 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -191,8 +191,8 @@ void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 		GICH_VMCR_ALIAS_BINPOINT_MASK;
 	vmcr |= (vmcrp->bpr << GICH_VMCR_BINPOINT_SHIFT) &
 		GICH_VMCR_BINPOINT_MASK;
-	vmcr |= (vmcrp->pmr << GICH_VMCR_PRIMASK_SHIFT) &
-		GICH_VMCR_PRIMASK_MASK;
+	vmcr |= ((vmcrp->pmr >> GICV_PMR_PRIORITY_SHIFT) <<
+		 GICH_VMCR_PRIMASK_SHIFT) & GICH_VMCR_PRIMASK_MASK;
 
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = vmcr;
 }
@@ -207,8 +207,8 @@ void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 			GICH_VMCR_ALIAS_BINPOINT_SHIFT;
 	vmcrp->bpr  = (vmcr & GICH_VMCR_BINPOINT_MASK) >>
 			GICH_VMCR_BINPOINT_SHIFT;
-	vmcrp->pmr  = (vmcr & GICH_VMCR_PRIMASK_MASK) >>
-			GICH_VMCR_PRIMASK_SHIFT;
+	vmcrp->pmr  = ((vmcr & GICH_VMCR_PRIMASK_MASK) >>
+			GICH_VMCR_PRIMASK_SHIFT) << GICV_PMR_PRIORITY_SHIFT;
 }
 
 void vgic_v2_enable(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index db28f7c..1d8cb65 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -81,11 +81,18 @@ static inline bool irq_is_pending(struct vgic_irq *irq)
 		return irq->pending_latch || irq->line_level;
 }
 
+/*
+ * This struct provides an intermediate representation of the fields contained
+ * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC
+ * state to userspace can generate either GICv2 or GICv3 CPU interface
+ * registers regardless of the hardware backed GIC used.
+ */
 struct vgic_vmcr {
 	u32	ctlr;
 	u32	abpr;
 	u32	bpr;
-	u32	pmr;
+	u32	pmr;  /* Priority mask field in the GICC_PMR and
+		       * ICC_PMR_EL1 priority field format */
 	/* Below member variable are valid only for GICv3 */
 	u32	grpen0;
 	u32	grpen1;
-- 
2.9.0
