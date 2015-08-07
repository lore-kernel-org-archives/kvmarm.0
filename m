From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 04/11] KVM: arm/arm64: vgic: Allow HW irq to be encoded in
 LR
Date: Fri,  7 Aug 2015 16:45:40 +0100
Message-ID: <1438962347-17541-5-git-send-email-marc.zyngier@arm.com>
References: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A3965A47C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 11:33:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B+ET63WZ+zJC for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Aug 2015 11:33:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95F815A476
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Aug 2015 11:33:05 -0400 (EDT)
In-Reply-To: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Now that struct vgic_lr supports the LR_HW bit and carries a hwirq
field, we can encode that information into the list registers.

This patch provides implementations for both GICv2 and GICv3.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h |  3 +++
 include/linux/irqchip/arm-gic.h    |  3 ++-
 virt/kvm/arm/vgic-v2.c             | 16 +++++++++++++++-
 virt/kvm/arm/vgic-v3.c             | 21 ++++++++++++++++++---
 4 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index ffbc034..cf637d6 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -268,9 +268,12 @@
 
 #define ICH_LR_EOI			(1UL << 41)
 #define ICH_LR_GROUP			(1UL << 60)
+#define ICH_LR_HW			(1UL << 61)
 #define ICH_LR_STATE			(3UL << 62)
 #define ICH_LR_PENDING_BIT		(1UL << 62)
 #define ICH_LR_ACTIVE_BIT		(1UL << 63)
+#define ICH_LR_PHYS_ID_SHIFT		32
+#define ICH_LR_PHYS_ID_MASK		(0x3ffUL << ICH_LR_PHYS_ID_SHIFT)
 
 #define ICH_MISR_EOI			(1 << 0)
 #define ICH_MISR_U			(1 << 1)
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 9de976b..ca88dad 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -71,11 +71,12 @@
 
 #define GICH_LR_VIRTUALID		(0x3ff << 0)
 #define GICH_LR_PHYSID_CPUID_SHIFT	(10)
-#define GICH_LR_PHYSID_CPUID		(7 << GICH_LR_PHYSID_CPUID_SHIFT)
+#define GICH_LR_PHYSID_CPUID		(0x3ff << GICH_LR_PHYSID_CPUID_SHIFT)
 #define GICH_LR_STATE			(3 << 28)
 #define GICH_LR_PENDING_BIT		(1 << 28)
 #define GICH_LR_ACTIVE_BIT		(1 << 29)
 #define GICH_LR_EOI			(1 << 19)
+#define GICH_LR_HW			(1 << 31)
 
 #define GICH_VMCR_CTRL_SHIFT		0
 #define GICH_VMCR_CTRL_MASK		(0x21f << GICH_VMCR_CTRL_SHIFT)
diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index f9b9c7c..8d7b04d 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -48,6 +48,10 @@ static struct vgic_lr vgic_v2_get_lr(const struct kvm_vcpu *vcpu, int lr)
 		lr_desc.state |= LR_STATE_ACTIVE;
 	if (val & GICH_LR_EOI)
 		lr_desc.state |= LR_EOI_INT;
+	if (val & GICH_LR_HW) {
+		lr_desc.state |= LR_HW;
+		lr_desc.hwirq = (val & GICH_LR_PHYSID_CPUID) >> GICH_LR_PHYSID_CPUID_SHIFT;
+	}
 
 	return lr_desc;
 }
@@ -55,7 +59,9 @@ static struct vgic_lr vgic_v2_get_lr(const struct kvm_vcpu *vcpu, int lr)
 static void vgic_v2_set_lr(struct kvm_vcpu *vcpu, int lr,
 			   struct vgic_lr lr_desc)
 {
-	u32 lr_val = (lr_desc.source << GICH_LR_PHYSID_CPUID_SHIFT) | lr_desc.irq;
+	u32 lr_val;
+
+	lr_val = lr_desc.irq;
 
 	if (lr_desc.state & LR_STATE_PENDING)
 		lr_val |= GICH_LR_PENDING_BIT;
@@ -64,6 +70,14 @@ static void vgic_v2_set_lr(struct kvm_vcpu *vcpu, int lr,
 	if (lr_desc.state & LR_EOI_INT)
 		lr_val |= GICH_LR_EOI;
 
+	if (lr_desc.state & LR_HW) {
+		lr_val |= GICH_LR_HW;
+		lr_val |= (u32)lr_desc.hwirq << GICH_LR_PHYSID_CPUID_SHIFT;
+	}
+
+	if (lr_desc.irq < VGIC_NR_SGIS)
+		lr_val |= (lr_desc.source << GICH_LR_PHYSID_CPUID_SHIFT);
+
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = lr_val;
 }
 
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index dff0602..afbf925 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -67,6 +67,10 @@ static struct vgic_lr vgic_v3_get_lr(const struct kvm_vcpu *vcpu, int lr)
 		lr_desc.state |= LR_STATE_ACTIVE;
 	if (val & ICH_LR_EOI)
 		lr_desc.state |= LR_EOI_INT;
+	if (val & ICH_LR_HW) {
+		lr_desc.state |= LR_HW;
+		lr_desc.hwirq = (val >> ICH_LR_PHYS_ID_SHIFT) & GENMASK(9, 0);
+	}
 
 	return lr_desc;
 }
@@ -84,10 +88,17 @@ static void vgic_v3_set_lr(struct kvm_vcpu *vcpu, int lr,
 	 * Eventually we want to make this configurable, so we may revisit
 	 * this in the future.
 	 */
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+	switch (vcpu->kvm->arch.vgic.vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		lr_val |= ICH_LR_GROUP;
-	else
-		lr_val |= (u32)lr_desc.source << GICH_LR_PHYSID_CPUID_SHIFT;
+		break;
+	case  KVM_DEV_TYPE_ARM_VGIC_V2:
+		if (lr_desc.irq < VGIC_NR_SGIS)
+			lr_val |= (u32)lr_desc.source << GICH_LR_PHYSID_CPUID_SHIFT;
+		break;
+	default:
+		BUG();
+	}
 
 	if (lr_desc.state & LR_STATE_PENDING)
 		lr_val |= ICH_LR_PENDING_BIT;
@@ -95,6 +106,10 @@ static void vgic_v3_set_lr(struct kvm_vcpu *vcpu, int lr,
 		lr_val |= ICH_LR_ACTIVE_BIT;
 	if (lr_desc.state & LR_EOI_INT)
 		lr_val |= ICH_LR_EOI;
+	if (lr_desc.state & LR_HW) {
+		lr_val |= ICH_LR_HW;
+		lr_val |= ((u64)lr_desc.hwirq) << ICH_LR_PHYS_ID_SHIFT;
+	}
 
 	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[LR_INDEX(lr)] = lr_val;
 }
-- 
2.1.4
