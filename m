From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 82/85] KVM: arm/arm64: vgic: Disallow Active+Pending for level
 interrupts
Date: Wed, 28 Mar 2018 13:52:51 +0100
Message-ID: <20180328125254.31380-83-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86A634A0EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 09:02:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WkmJhg+gV7QP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 09:02:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4873742121
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:50:34 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

It was recently reported that VFIO mediated devices, and anything
that VFIO exposes as level interrupts, do no strictly follow the
expected logic of such interrupts as it only lowers the input
line when the guest has EOId the interrupt at the GIC level, rather
than when it Acked the interrupt at the device level.

THe GIC's Active+Pending state is fundamentally incompatible with
this behaviour, as it prevents KVM from observing the EOI, and in
turn results in VFIO never dropping the line. This results in an
interrupt storm in the guest, which it really never expected.

As we cannot really change VFIO to follow the strict rules of level
signalling, let's forbid the A+P state altogether, as it is in the
end only an optimization. It ensures that we will transition via
an invalid state, which we can use to notify VFIO of the EOI.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Shunyong Yang <shunyong.yang@hxt-semitech.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v2.c | 54 +++++++++++++++++++++++++--------------------
 virt/kvm/arm/vgic/vgic-v3.c | 54 +++++++++++++++++++++++++--------------------
 2 files changed, 60 insertions(+), 48 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 8327ea932aea..45aa433f018f 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -105,12 +105,9 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 
 		/*
 		 * Clear soft pending state when level irqs have been acked.
-		 * Always regenerate the pending state.
 		 */
-		if (irq->config == VGIC_CONFIG_LEVEL) {
-			if (!(val & GICH_LR_PENDING_BIT))
-				irq->pending_latch = false;
-		}
+		if (irq->config == VGIC_CONFIG_LEVEL && !(val & GICH_LR_STATE))
+			irq->pending_latch = false;
 
 		/*
 		 * Level-triggered mapped IRQs are special because we only
@@ -153,8 +150,35 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 {
 	u32 val = irq->intid;
+	bool allow_pending = true;
+
+	if (irq->active)
+		val |= GICH_LR_ACTIVE_BIT;
+
+	if (irq->hw) {
+		val |= GICH_LR_HW;
+		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
+		/*
+		 * Never set pending+active on a HW interrupt, as the
+		 * pending state is kept at the physical distributor
+		 * level.
+		 */
+		if (irq->active)
+			allow_pending = false;
+	} else {
+		if (irq->config == VGIC_CONFIG_LEVEL) {
+			val |= GICH_LR_EOI;
 
-	if (irq_is_pending(irq)) {
+			/*
+			 * Software resampling doesn't work very well
+			 * if we allow P+A, so let's not do that.
+			 */
+			if (irq->active)
+				allow_pending = false;
+		}
+	}
+
+	if (allow_pending && irq_is_pending(irq)) {
 		val |= GICH_LR_PENDING_BIT;
 
 		if (irq->config == VGIC_CONFIG_EDGE)
@@ -171,24 +195,6 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 		}
 	}
 
-	if (irq->active)
-		val |= GICH_LR_ACTIVE_BIT;
-
-	if (irq->hw) {
-		val |= GICH_LR_HW;
-		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
-		/*
-		 * Never set pending+active on a HW interrupt, as the
-		 * pending state is kept at the physical distributor
-		 * level.
-		 */
-		if (irq->active && irq_is_pending(irq))
-			val &= ~GICH_LR_PENDING_BIT;
-	} else {
-		if (irq->config == VGIC_CONFIG_LEVEL)
-			val |= GICH_LR_EOI;
-	}
-
 	/*
 	 * Level-triggered mapped IRQs are special because we only observe
 	 * rising edges as input to the VGIC.  We therefore lower the line
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index e17f61a434fa..8195f52ae6f0 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -97,12 +97,9 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 
 		/*
 		 * Clear soft pending state when level irqs have been acked.
-		 * Always regenerate the pending state.
 		 */
-		if (irq->config == VGIC_CONFIG_LEVEL) {
-			if (!(val & ICH_LR_PENDING_BIT))
-				irq->pending_latch = false;
-		}
+		if (irq->config == VGIC_CONFIG_LEVEL && !(val & ICH_LR_STATE))
+			irq->pending_latch = false;
 
 		/*
 		 * Level-triggered mapped IRQs are special because we only
@@ -136,8 +133,35 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 {
 	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	u64 val = irq->intid;
+	bool allow_pending = true;
+
+	if (irq->active)
+		val |= ICH_LR_ACTIVE_BIT;
+
+	if (irq->hw) {
+		val |= ICH_LR_HW;
+		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
+		/*
+		 * Never set pending+active on a HW interrupt, as the
+		 * pending state is kept at the physical distributor
+		 * level.
+		 */
+		if (irq->active)
+			allow_pending = false;
+	} else {
+		if (irq->config == VGIC_CONFIG_LEVEL) {
+			val |= ICH_LR_EOI;
 
-	if (irq_is_pending(irq)) {
+			/*
+			 * Software resampling doesn't work very well
+			 * if we allow P+A, so let's not do that.
+			 */
+			if (irq->active)
+				allow_pending = false;
+		}
+	}
+
+	if (allow_pending && irq_is_pending(irq)) {
 		val |= ICH_LR_PENDING_BIT;
 
 		if (irq->config == VGIC_CONFIG_EDGE)
@@ -155,24 +179,6 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 		}
 	}
 
-	if (irq->active)
-		val |= ICH_LR_ACTIVE_BIT;
-
-	if (irq->hw) {
-		val |= ICH_LR_HW;
-		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
-		/*
-		 * Never set pending+active on a HW interrupt, as the
-		 * pending state is kept at the physical distributor
-		 * level.
-		 */
-		if (irq->active && irq_is_pending(irq))
-			val &= ~ICH_LR_PENDING_BIT;
-	} else {
-		if (irq->config == VGIC_CONFIG_LEVEL)
-			val |= ICH_LR_EOI;
-	}
-
 	/*
 	 * Level-triggered mapped IRQs are special because we only observe
 	 * rising edges as input to the VGIC.  We therefore lower the line
-- 
2.14.2
