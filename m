From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/2] KVM: arm/arm64: vgic-v2: Expose the correct GICC_PMR values to userspace
Date: Thu, 16 Mar 2017 11:45:34 +0000
Message-ID: <20170316114535.25233-2-marc.zyngier@arm.com>
References: <20170316114535.25233-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170316114535.25233-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We allow userspace to save/restore the GICC_PMR values in order
to allow migration. This value is extracted from GICH_PMCR, where
it occupies a 5 bit field. But the canonical PMR is an 8 bit
value and we fail to shift the virtual priority, resulting in
a non-sensical value being reported to userspace.

Fixing it once and for all would be ideal, but that would break
migration of guest from old to new kernels. We thus introduce
a new GICv2 attribute (KVM_DEV_ARM_VGIC_CTRL_CANONICAL_PMR)
that allows userspace to register its interest for the one true
representation of PMR.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/uapi/asm/kvm.h     |  4 ++--
 arch/arm64/include/uapi/asm/kvm.h   |  4 ++--
 include/kvm/arm_vgic.h              |  5 +++++
 virt/kvm/arm/vgic/vgic-kvm-device.c |  5 +++++
 virt/kvm/arm/vgic/vgic-v2.c         | 16 ++++++++++++++++
 5 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 6ebd3e6a1fd1..2852836221c0 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -189,6 +189,8 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
 #define KVM_DEV_ARM_VGIC_GRP_CTRL       4
+#define   KVM_DEV_ARM_VGIC_CTRL_INIT    	0
+#define   KVM_DEV_ARM_VGIC_CTRL_CANONICAL_PMR	1
 #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
@@ -198,8 +200,6 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK 0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
 
-#define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
-
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
 #define KVM_ARM_IRQ_TYPE_MASK		0xff
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index c2860358ae3e..e649dc753759 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -209,6 +209,8 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
+#define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
+#define   KVM_DEV_ARM_VGIC_CTRL_CANONICAL_PMR	1
 #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
@@ -218,8 +220,6 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
 
-#define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
-
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b72dd2ad5f44..af46ec3c427d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -170,6 +170,8 @@ struct vgic_its {
 
 struct vgic_state_iter;
 
+#define VGIC_QUIRK_CANONICAL_PMR	0
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
@@ -218,6 +220,9 @@ struct vgic_dist {
 	struct list_head	lpi_list_head;
 	int			lpi_list_count;
 
+	/* Quirks driven by userspace requests */
+	unsigned long		quirks;
+
 	/* used by vgic-debug */
 	struct vgic_state_iter *iter;
 };
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index d181d2baee9c..b4935cd49c24 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -160,6 +160,10 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 			r = vgic_init(dev->kvm);
 			mutex_unlock(&dev->kvm->lock);
 			return r;
+		case KVM_DEV_ARM_VGIC_CTRL_CANONICAL_PMR:
+			set_bit(VGIC_QUIRK_CANONICAL_PMR,
+				&dev->kvm->arch.vgic.quirks);
+			break;
 		}
 		break;
 	}
@@ -408,6 +412,7 @@ static int vgic_v2_has_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+		case KVM_DEV_ARM_VGIC_CTRL_CANONICAL_PMR:
 			return 0;
 		}
 	}
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index b834ecdf3225..87f9dd1eaf1c 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -191,6 +191,15 @@ void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 		GICH_VMCR_ALIAS_BINPOINT_MASK;
 	vmcr |= (vmcrp->bpr << GICH_VMCR_BINPOINT_SHIFT) &
 		GICH_VMCR_BINPOINT_MASK;
+
+	/*
+	 * If userspace is happy to deal with the normal PMR range (8
+	 * bits), we need to strip the 3 lowest bits so that we fit
+	 * into the 5 bits that GICv2 gives us on the virtual side.
+	 */
+	if (test_bit(VGIC_QUIRK_CANONICAL_PMR, &vcpu->kvm->arch.vgic.quirks))
+		vmcrp->pmr >>= 3;
+
 	vmcr |= (vmcrp->pmr << GICH_VMCR_PRIMASK_SHIFT) &
 		GICH_VMCR_PRIMASK_MASK;
 
@@ -209,6 +218,13 @@ void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 			GICH_VMCR_BINPOINT_SHIFT;
 	vmcrp->pmr  = (vmcr & GICH_VMCR_PRIMASK_MASK) >>
 			GICH_VMCR_PRIMASK_SHIFT;
+	/*
+	 * If userspace is happy to deal with the normal PMR range (8
+	 * bits), we need to shift the reduced range (5 bits) to
+	 * expose it as if it was a normal value.
+	 */
+	if (test_bit(VGIC_QUIRK_CANONICAL_PMR, &vcpu->kvm->arch.vgic.quirks))
+		vmcrp->pmr <<= 3;
 }
 
 void vgic_v2_enable(struct kvm_vcpu *vcpu)
-- 
2.11.0
