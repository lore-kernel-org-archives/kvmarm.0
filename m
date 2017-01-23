From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] KVM: arm/arm64: Remove struct vgic_irq pending field
Date: Mon, 23 Jan 2017 14:39:51 +0100
Message-ID: <20170123133951.10329-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D4684092C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 08:40:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b3K57N9TP3HJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Jan 2017 08:40:00 -0500 (EST)
Received: from mail-lf0-f50.google.com (mail-lf0-f50.google.com
 [209.85.215.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1136C40194
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 08:39:59 -0500 (EST)
Received: by mail-lf0-f50.google.com with SMTP id v186so93575062lfa.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 05:40:05 -0800 (PST)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

One of the goals behind the VGIC redesign was to get rid of cached or
intermediate state in the data structures, but we decided to allow
ourselves to precompute the pending value of an IRQ based on the line
level and pending latch state.  However, this has now become difficult
to base proper GICv3 save/restore on, because there is a potential to
modify the pending state without knowing if an interrupt is edge or
level configured.

See the following post and related message for more background:
https://lists.cs.columbia.edu/pipermail/kvmarm/2017-January/023195.html

This commit gets rid of the precomputed pending field in favor of a
function that calculates the value when needed, irq_is_pending().

The soft_pending field is renamed to pending_latch to represent that
this latch is the equivalent hardware latch which gets manipulated by
the input signal for edge-triggered interrupts and when writing to the
SPENDR/CPENDR registers.

After this commit save/restore code should be able to simply restore the
pending_latch state, line_level state, and config state in any order and
get the desired result.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h           |  5 +++--
 virt/kvm/arm/vgic/vgic-its.c     |  6 +++---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  6 +++---
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  2 +-
 virt/kvm/arm/vgic/vgic-mmio.c    | 19 +++++--------------
 virt/kvm/arm/vgic/vgic-v2.c      | 12 +++++-------
 virt/kvm/arm/vgic/vgic-v3.c      | 12 +++++-------
 virt/kvm/arm/vgic/vgic.c         | 16 +++++++---------
 virt/kvm/arm/vgic/vgic.h         | 13 +++++++++++++
 9 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 002f092..da2ce08 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -101,9 +101,10 @@ struct vgic_irq {
 					 */
 
 	u32 intid;			/* Guest visible INTID */
-	bool pending;
 	bool line_level;		/* Level only */
-	bool soft_pending;		/* Level only */
+	bool pending_latch;		/* The pending latch state used to calculate
+					 * the pending state for both level
+					 * and edge triggered IRQs. */
 	bool active;			/* not used for LPIs */
 	bool enabled;
 	bool hw;			/* Tied to HW IRQ */
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 8c2b3cd..7170a00 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -350,7 +350,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 
 		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
 		spin_lock(&irq->irq_lock);
-		irq->pending = pendmask & (1U << bit_nr);
+		irq_set_pending_latch(irq, pendmask & (1U << bit_nr));
 		vgic_queue_irq_unlock(vcpu->kvm, irq);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -465,7 +465,7 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 		return -EBUSY;
 
 	spin_lock(&itte->irq->irq_lock);
-	itte->irq->pending = true;
+	irq_set_pending_latch(itte->irq, true);
 	vgic_queue_irq_unlock(kvm, itte->irq);
 
 	return 0;
@@ -913,7 +913,7 @@ static int vgic_its_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
 	if (!itte)
 		return E_ITS_CLEAR_UNMAPPED_INTERRUPT;
 
-	itte->irq->pending = false;
+	irq_set_pending_latch(itte->irq, false);
 
 	return 0;
 }
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 78e34bc..6b07fa9 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -98,7 +98,7 @@ static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
 		irq = vgic_get_irq(source_vcpu->kvm, vcpu, intid);
 
 		spin_lock(&irq->irq_lock);
-		irq->pending = true;
+		irq_set_pending_latch(irq, true);
 		irq->source |= 1U << source_vcpu->vcpu_id;
 
 		vgic_queue_irq_unlock(source_vcpu->kvm, irq);
@@ -182,7 +182,7 @@ static void vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
 
 		irq->source &= ~((val >> (i * 8)) & 0xff);
 		if (!irq->source)
-			irq->pending = false;
+			irq_set_pending_latch(irq, false);
 
 		spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
@@ -204,7 +204,7 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 		irq->source |= (val >> (i * 8)) & 0xff;
 
 		if (irq->source) {
-			irq->pending = true;
+			irq_set_pending_latch(irq, true);
 			vgic_queue_irq_unlock(vcpu->kvm, irq);
 		} else {
 			spin_unlock(&irq->irq_lock);
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 50f42f0..7300ec4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -646,7 +646,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 		irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
 
 		spin_lock(&irq->irq_lock);
-		irq->pending = true;
+		irq_set_pending_latch(irq, true);
 
 		vgic_queue_irq_unlock(vcpu->kvm, irq);
 		vgic_put_irq(vcpu->kvm, irq);
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index ebe1b9f..0dfd306 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -111,7 +111,7 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	for (i = 0; i < len * 8; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		if (irq->pending)
+		if (irq_is_pending(irq))
 			value |= (1U << i);
 
 		vgic_put_irq(vcpu->kvm, irq);
@@ -131,9 +131,7 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		spin_lock(&irq->irq_lock);
-		irq->pending = true;
-		if (irq->config == VGIC_CONFIG_LEVEL)
-			irq->soft_pending = true;
+		irq_set_pending_latch(irq, true);
 
 		vgic_queue_irq_unlock(vcpu->kvm, irq);
 		vgic_put_irq(vcpu->kvm, irq);
@@ -152,12 +150,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 
 		spin_lock(&irq->irq_lock);
 
-		if (irq->config == VGIC_CONFIG_LEVEL) {
-			irq->soft_pending = false;
-			irq->pending = irq->line_level;
-		} else {
-			irq->pending = false;
-		}
+		irq_set_pending_latch(irq, false);
 
 		spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
@@ -359,12 +352,10 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 		irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 		spin_lock(&irq->irq_lock);
 
-		if (test_bit(i * 2 + 1, &val)) {
+		if (test_bit(i * 2 + 1, &val))
 			irq->config = VGIC_CONFIG_EDGE;
-		} else {
+		else
 			irq->config = VGIC_CONFIG_LEVEL;
-			irq->pending = irq->line_level | irq->soft_pending;
-		}
 
 		spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 834137e..a29cf33 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -104,7 +104,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		/* Edge is the only case where we preserve the pending bit */
 		if (irq->config == VGIC_CONFIG_EDGE &&
 		    (val & GICH_LR_PENDING_BIT)) {
-			irq->pending = true;
+			irq_set_pending_latch(irq, true);
 
 			if (vgic_irq_is_sgi(intid)) {
 				u32 cpuid = val & GICH_LR_PHYSID_CPUID;
@@ -120,9 +120,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		 */
 		if (irq->config == VGIC_CONFIG_LEVEL) {
 			if (!(val & GICH_LR_PENDING_BIT))
-				irq->soft_pending = false;
-
-			irq->pending = irq->line_level || irq->soft_pending;
+				irq_set_pending_latch(irq, false);
 		}
 
 		spin_unlock(&irq->irq_lock);
@@ -145,11 +143,11 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 {
 	u32 val = irq->intid;
 
-	if (irq->pending) {
+	if (irq_is_pending(irq)) {
 		val |= GICH_LR_PENDING_BIT;
 
 		if (irq->config == VGIC_CONFIG_EDGE)
-			irq->pending = false;
+			irq_set_pending_latch(irq, false);
 
 		if (vgic_irq_is_sgi(irq->intid)) {
 			u32 src = ffs(irq->source);
@@ -158,7 +156,7 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
 			irq->source &= ~(1 << (src - 1));
 			if (irq->source)
-				irq->pending = true;
+				irq_set_pending_latch(irq, true);
 		}
 	}
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index e6b03fd..76d7d75 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -94,7 +94,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		/* Edge is the only case where we preserve the pending bit */
 		if (irq->config == VGIC_CONFIG_EDGE &&
 		    (val & ICH_LR_PENDING_BIT)) {
-			irq->pending = true;
+			irq_set_pending_latch(irq, true);
 
 			if (vgic_irq_is_sgi(intid) &&
 			    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
@@ -111,9 +111,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		 */
 		if (irq->config == VGIC_CONFIG_LEVEL) {
 			if (!(val & ICH_LR_PENDING_BIT))
-				irq->soft_pending = false;
-
-			irq->pending = irq->line_level || irq->soft_pending;
+				irq_set_pending_latch(irq, false);
 		}
 
 		spin_unlock(&irq->irq_lock);
@@ -127,11 +125,11 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	u64 val = irq->intid;
 
-	if (irq->pending) {
+	if (irq_is_pending(irq)) {
 		val |= ICH_LR_PENDING_BIT;
 
 		if (irq->config == VGIC_CONFIG_EDGE)
-			irq->pending = false;
+			irq_set_pending_latch(irq, false);
 
 		if (vgic_irq_is_sgi(irq->intid) &&
 		    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
@@ -141,7 +139,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
 			irq->source &= ~(1 << (src - 1));
 			if (irq->source)
-				irq->pending = true;
+				irq_set_pending_latch(irq, true);
 		}
 	}
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 6440b56..ac978b4 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -160,7 +160,7 @@ static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
 	 * If the distributor is disabled, pending interrupts shouldn't be
 	 * forwarded.
 	 */
-	if (irq->enabled && irq->pending) {
+	if (irq->enabled && irq_is_pending(irq)) {
 		if (unlikely(irq->target_vcpu &&
 			     !irq->target_vcpu->kvm->arch.vgic.enabled))
 			return NULL;
@@ -204,8 +204,8 @@ static int vgic_irq_cmp(void *priv, struct list_head *a, struct list_head *b)
 		goto out;
 	}
 
-	penda = irqa->enabled && irqa->pending;
-	pendb = irqb->enabled && irqb->pending;
+	penda = irqa->enabled && irq_is_pending(irqa);
+	pendb = irqb->enabled && irq_is_pending(irqb);
 
 	if (!penda || !pendb) {
 		ret = (int)pendb - (int)penda;
@@ -371,12 +371,10 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 		return 0;
 	}
 
-	if (irq->config == VGIC_CONFIG_LEVEL) {
+	if (irq->config == VGIC_CONFIG_LEVEL)
 		irq->line_level = level;
-		irq->pending = level || irq->soft_pending;
-	} else {
-		irq->pending = true;
-	}
+	else
+		irq_set_pending_latch(irq, true);
 
 	vgic_queue_irq_unlock(kvm, irq);
 	vgic_put_irq(kvm, irq);
@@ -689,7 +687,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
 		spin_lock(&irq->irq_lock);
-		pending = irq->pending && irq->enabled;
+		pending = irq_is_pending(irq) && irq->enabled;
 		spin_unlock(&irq->irq_lock);
 
 		if (pending)
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 859f65c..70c7e40 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -30,6 +30,19 @@
 
 #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
 
+static inline bool irq_is_pending(struct vgic_irq *irq)
+{
+	if (irq->config == VGIC_CONFIG_EDGE)
+		return irq->pending_latch;
+	else
+		return irq->pending_latch || irq->line_level;
+}
+
+static inline void irq_set_pending_latch(struct vgic_irq *irq, bool val)
+{
+	irq->pending_latch = val;
+}
+
 struct vgic_vmcr {
 	u32	ctlr;
 	u32	abpr;
-- 
2.9.0
