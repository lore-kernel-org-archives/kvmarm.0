From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2] KVM: arm/arm64: vgic: Disallow Active+Pending for level
 interrupts
Date: Fri, 16 Mar 2018 14:30:15 +0000
Message-ID: <20180316143015.32055-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Eric Auger <eric.auger@redhat.com>, Christoffer Dall <cdall@kernel.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Andre Przywara <Andre.Przywara@arm.com>
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

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
- From v1:
  * Only clear the latch when going via an invalid state

 virt/kvm/arm/vgic/vgic-v2.c | 54 +++++++++++++++++++++++++--------------------
 virt/kvm/arm/vgic/vgic-v3.c | 54 +++++++++++++++++++++++++--------------------
 2 files changed, 60 insertions(+), 48 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 29556f71b691..8427586760fc 100644
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
index 0ff2006f3781..dd984f726805 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -96,12 +96,9 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 
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
@@ -135,8 +132,35 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
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
@@ -154,24 +178,6 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
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
