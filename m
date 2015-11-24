From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 2/3] KVM: arm/arm64: arch_timer: Preserve physical dist.
 active state on LR.active
Date: Tue, 24 Nov 2015 16:43:59 +0100
Message-ID: <1448379840-17516-3-git-send-email-christoffer.dall@linaro.org>
References: <1448379840-17516-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 287254852F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 10:42:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KuyUxUV7r3Ao for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 10:42:48 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E5C6412DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 10:42:47 -0500 (EST)
Received: by wmec201 with SMTP id c201so32374882wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 07:43:46 -0800 (PST)
In-Reply-To: <1448379840-17516-1-git-send-email-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We were incorrectly removing the active state from the physical
distributor on the timer interrupt when the timer output level was
deasserted.  We shouldn't be doing this without considering the virtual
interrupt's active state, because the architecture requires that when an
LR has the HW bit set and the pending or active bits set, then the
physical interrupt must also have the corresponding bits set.

This addresses an issue where we have been observing an inconsistency
between the LR state and the physical distributor state where the LR
state was active and the physical distributor was not active, which
shouldn't happen.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h    |  2 +-
 virt/kvm/arm/arch_timer.c | 28 +++++++++++++++++-----------
 virt/kvm/arm/vgic.c       | 37 +++++++++++++++++++++++++------------
 3 files changed, 43 insertions(+), 24 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9c747cb..d2f4147 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -342,10 +342,10 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
 			       struct irq_phys_map *map, bool level);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
-int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 					   int virt_irq, int irq);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 21a0ab2..69bca18 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -221,17 +221,23 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	kvm_timer_update_state(vcpu);
 
 	/*
-	 * If we enter the guest with the virtual input level to the VGIC
-	 * asserted, then we have already told the VGIC what we need to, and
-	 * we don't need to exit from the guest until the guest deactivates
-	 * the already injected interrupt, so therefore we should set the
-	 * hardware active state to prevent unnecessary exits from the guest.
-	 *
-	 * Conversely, if the virtual input level is deasserted, then always
-	 * clear the hardware active state to ensure that hardware interrupts
-	 * from the timer triggers a guest exit.
-	 */
-	if (timer->irq.level)
+	* If we enter the guest with the virtual input level to the VGIC
+	* asserted, then we have already told the VGIC what we need to, and
+	* we don't need to exit from the guest until the guest deactivates
+	* the already injected interrupt, so therefore we should set the
+	* hardware active state to prevent unnecessary exits from the guest.
+	*
+	* Also, if we enter the guest with the virtual timer interrupt active,
+	* then it must be active on the physical distributor, because we set
+	* the HW bit and the guest must be able to deactivate the virtual and
+	* physical interrupt at the same time.
+	*
+	* Conversely, if the virtual input level is deasserted and the virtual
+	* interrupt is not active, then always clear the hardware active state
+	* to ensure that hardware interrupts from the timer triggers a guest
+	* exit.
+	*/
+	if (timer->irq.level || kvm_vgic_map_is_active(vcpu, timer->map))
 		phys_active = true;
 	else
 		phys_active = false;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 5335383..9002f0d 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1096,6 +1096,30 @@ static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu)
 	vgic_set_lr(vcpu, lr_nr, vlr);
 }
 
+static int dist_active_irq(struct kvm_vcpu *vcpu)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return 0;
+
+	return test_bit(vcpu->vcpu_id, dist->irq_active_on_cpu);
+}
+
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
+{
+	int i;
+
+	for (i = 0; i < vcpu->arch.vgic_cpu.nr_lr; i++) {
+		struct vgic_lr vlr = vgic_get_lr(vcpu, i);
+
+		if (vlr.irq == map->virt_irq && vlr.state & LR_STATE_ACTIVE)
+			return true;
+	}
+
+	return dist_active_irq(vcpu);
+}
+
 /*
  * An interrupt may have been disabled after being made pending on the
  * CPU interface (the classic case is a timer running while we're
@@ -1248,7 +1272,7 @@ static void __kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * may have been serviced from another vcpu. In all cases,
 	 * move along.
 	 */
-	if (!kvm_vgic_vcpu_pending_irq(vcpu) && !kvm_vgic_vcpu_active_irq(vcpu))
+	if (!kvm_vgic_vcpu_pending_irq(vcpu) && !dist_active_irq(vcpu))
 		goto epilog;
 
 	/* SGIs */
@@ -1479,17 +1503,6 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	return test_bit(vcpu->vcpu_id, dist->irq_pending_on_cpu);
 }
 
-int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu)
-{
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-
-	if (!irqchip_in_kernel(vcpu->kvm))
-		return 0;
-
-	return test_bit(vcpu->vcpu_id, dist->irq_active_on_cpu);
-}
-
-
 void vgic_kick_vcpus(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
-- 
2.1.2.330.g565301e.dirty
