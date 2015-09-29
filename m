From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 7/8] arm/arm64: KVM: Rework the arch timer to use
 level-triggered semantics
Date: Tue, 29 Sep 2015 16:49:04 +0200
Message-ID: <1443538145-11990-8-git-send-email-christoffer.dall@linaro.org>
References: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F5C54156D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 10:47:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F0kvpfQJuMG7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2015 10:47:40 -0400 (EDT)
Received: from mail-la0-f50.google.com (mail-la0-f50.google.com
 [209.85.215.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A7184142D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 10:47:40 -0400 (EDT)
Received: by labzv5 with SMTP id zv5so11739060lab.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 07:49:14 -0700 (PDT)
In-Reply-To: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The arch timer currently uses edge-triggered semantics in the sense that
the line is never sampled by the vgic and lowering the line from the
timer to the vgic doesn't have any effect on the pending state of
virtual interrupts in the vgic.  This means that we do not support a
guest with the otherwise valid behavior of (1) disable interrupts (2)
enable the timer (3) disable the timer (4) enable interrupts.  Such a
guest would validly not expect to see any interrupts on real hardware,
but will see interrupts on KVM.

This patches fixes this shortcoming through the following series of
changes.

First, we change the flow of the timer/vgic sync/flush operations.  Now
the timer is always flushed/synced before the vgic, because the vgic
samples the state of the timer output.  This has the implication that we
move the timer operations in to non-preempible sections, but that is
fine after the previous commit getting rid of hrtimer schedules on every
entry/exit.

Second, we change the internal behavior of the timer, letting the timer
keep track of its previous output state, and only lower/raise the line
to the vgic when the state changes.  Note that in theory this could have
been accomplished more simply by signalling the vgic every time the
state *potentially* changed, but we don't want to be hitting the vgic
more often than necessary.

Third, we get rid of the use of the map->active field in the vgic and
instead simply set the interrupt as active on the physical distributor
whenever we signal a mapped interrupt to the guest, and we reset the
active state when we sync back the HW state from the vgic.

Fourth, and finally, we now initialize the timer PPIs (and all the other
unused PPIs for now), to be level-triggered, and modify the sync code to
sample the line state on HW sync and re-inject a new interrupt if it is
still pending at that time.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c           | 11 +++++--
 include/kvm/arm_arch_timer.h |  2 +-
 include/kvm/arm_vgic.h       |  3 --
 virt/kvm/arm/arch_timer.c    | 65 +++++++++++++++++++++++++-----------
 virt/kvm/arm/vgic.c          | 78 ++++++++++++++++++--------------------------
 5 files changed, 87 insertions(+), 72 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 134863f..a9491ef 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -561,9 +561,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
 			local_irq_enable();
+			kvm_timer_sync_hwstate(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
 			preempt_enable();
-			kvm_timer_sync_hwstate(vcpu);
 			continue;
 		}
 
@@ -608,12 +608,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		kvm_guest_exit();
 		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
 
+		/*
+		 * We must sync the timer state before the vgic state so that
+		 * the vgic can properly sample the updated state of the
+		 * interrupt line.
+		 */
+		kvm_timer_sync_hwstate(vcpu);
+
 		kvm_vgic_sync_hwstate(vcpu);
 
 		preempt_enable();
 
-		kvm_timer_sync_hwstate(vcpu);
-
 		ret = handle_exit(vcpu, run, ret);
 	}
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index ef14cc1..1800227 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -51,7 +51,7 @@ struct arch_timer_cpu {
 	bool				armed;
 
 	/* Timer IRQ */
-	const struct kvm_irq_level	*irq;
+	struct kvm_irq_level		irq;
 
 	/* VGIC mapping */
 	struct irq_phys_map		*map;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4e14dac..7bc5d02 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -159,7 +159,6 @@ struct irq_phys_map {
 	u32			virt_irq;
 	u32			phys_irq;
 	u32			irq;
-	bool			active;
 };
 
 struct irq_phys_map_entry {
@@ -354,8 +353,6 @@ int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 					   int virt_irq, int irq);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
-bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map);
-void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 756c62d..f653ae6 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -59,18 +59,6 @@ static void timer_disarm(struct arch_timer_cpu *timer)
 	}
 }
 
-static void kvm_timer_inject_irq(struct kvm_vcpu *vcpu)
-{
-	int ret;
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-
-	kvm_vgic_set_phys_irq_active(timer->map, true);
-	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
-					 timer->map,
-					 timer->irq->level);
-	WARN_ON(ret);
-}
-
 static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 {
 	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)dev_id;
@@ -116,8 +104,7 @@ static bool kvm_timer_irq_can_fire(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
 	return !(timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
-		(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE) &&
-		!kvm_vgic_get_phys_irq_active(timer->map);
+		(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE);
 }
 
 bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
@@ -134,6 +121,41 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
 	return cval <= now;
 }
 
+static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
+{
+	int ret;
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+
+	BUG_ON(!vgic_initialized(vcpu->kvm));
+
+	timer->irq.level = new_level;
+	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
+					 timer->map,
+					 timer->irq.level);
+	WARN_ON(ret);
+}
+
+/*
+ * Check if there was a change in the timer state (should we raise or lower
+ * the line level to the GIC).
+ */
+static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+
+	/*
+	 * If userspace modified the timer registers via SET_ONE_REG before
+	 * the vgic was initialized, we mustn't set the timer->irq.level value
+	 * because the guest would never see the interrupt.  Instead wait
+	 * until we call this function from kvm_timer_flush_hwstate.
+	 */
+	if (!vgic_initialized(vcpu->kvm))
+	    return;
+
+	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
+		kvm_timer_update_irq(vcpu, !timer->irq.level);
+}
+
 /*
  * Schedule the background timer before calling kvm_vcpu_block, so that this
  * thread is removed from its waitqueue and made runnable when there's a timer
@@ -188,8 +210,7 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
  */
 void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 {
-	if (kvm_timer_should_fire(vcpu))
-		kvm_timer_inject_irq(vcpu);
+	kvm_timer_update_state(vcpu);
 }
 
 /**
@@ -205,8 +226,11 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 
 	BUG_ON(timer_is_armed(timer));
 
-	if (kvm_timer_should_fire(vcpu))
-		kvm_timer_inject_irq(vcpu);
+	/*
+	 * The guest could have modified the timer registers or the timer
+	 * could have expired, update the timer state.
+	 */
+	kvm_timer_update_state(vcpu);
 }
 
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
@@ -221,7 +245,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * kvm_vcpu_set_target(). To handle this, we determine
 	 * vcpu timer irq number when the vcpu is reset.
 	 */
-	timer->irq = irq;
+	timer->irq.irq = irq->irq;
 
 	/*
 	 * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
@@ -230,6 +254,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * the ARMv7 architecture.
 	 */
 	timer->cntv_ctl = 0;
+	kvm_timer_update_state(vcpu);
 
 	/*
 	 * Tell the VGIC that the virtual interrupt is tied to a
@@ -274,6 +299,8 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 	default:
 		return -1;
 	}
+
+	kvm_timer_update_state(vcpu);
 	return 0;
 }
 
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 9ed8d53..53548f1 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1422,34 +1422,48 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 /*
  * Save the physical active state, and reset it to inactive.
  *
- * Return 1 if HW interrupt went from active to inactive, and 0 otherwise.
+ * Return true if there's a pending level triggered interrupt line to queue.
  */
-static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
+static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
 {
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct irq_phys_map *map;
+	bool phys_active;
+	bool level_pending;
 	int ret;
 
 	if (!(vlr.state & LR_HW))
-		return 0;
+		return false;
 
 	map = vgic_irq_map_search(vcpu, vlr.irq);
-	BUG_ON(!map || !map->active);
+	BUG_ON(!map);
 
 	ret = irq_get_irqchip_state(map->irq,
 				    IRQCHIP_STATE_ACTIVE,
-				    &map->active);
+				    &phys_active);
 
 	WARN_ON(ret);
 
-	if (map->active) {
+	if (phys_active) {
+		/*
+		 * Interrupt still marked as active on the physical
+		 * distributor, so guest did not EOI it yet.  Reset to
+		 * non-active so that other VMs can see interrupts from this
+		 * device.
+		 */
 		ret = irq_set_irqchip_state(map->irq,
 					    IRQCHIP_STATE_ACTIVE,
 					    false);
 		WARN_ON(ret);
-		return 0;
+		return false;
 	}
 
-	return 1;
+	/* Mapped edge-triggered interrupts not yet supported. */
+	WARN_ON(vgic_irq_is_edge(vcpu, vlr.irq));
+	spin_lock(&dist->lock);
+	level_pending = process_level_irq(vcpu, lr, vlr);
+	spin_unlock(&dist->lock);
+	return level_pending;
 }
 
 /* Sync back the VGIC state after a guest run */
@@ -1474,18 +1488,8 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 			continue;
 
 		vlr = vgic_get_lr(vcpu, lr);
-		if (vgic_sync_hwirq(vcpu, vlr)) {
-			/*
-			 * So this is a HW interrupt that the guest
-			 * EOI-ed. Clean the LR state and allow the
-			 * interrupt to be sampled again.
-			 */
-			vlr.state = 0;
-			vlr.hwirq = 0;
-			vgic_set_lr(vcpu, lr, vlr);
-			vgic_irq_clear_queued(vcpu, vlr.irq);
-			set_bit(lr, elrsr_ptr);
-		}
+		if (vgic_sync_hwirq(vcpu, lr, vlr))
+			level_pending = true;
 
 		if (!test_bit(lr, elrsr_ptr))
 			continue;
@@ -1861,30 +1865,6 @@ static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
 }
 
 /**
- * kvm_vgic_get_phys_irq_active - Return the active state of a mapped IRQ
- *
- * Return the logical active state of a mapped interrupt. This doesn't
- * necessarily reflects the current HW state.
- */
-bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map)
-{
-	BUG_ON(!map);
-	return map->active;
-}
-
-/**
- * kvm_vgic_set_phys_irq_active - Set the active state of a mapped IRQ
- *
- * Set the logical active state of a mapped interrupt. This doesn't
- * immediately affects the HW state.
- */
-void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active)
-{
-	BUG_ON(!map);
-	map->active = active;
-}
-
-/**
  * kvm_vgic_unmap_phys_irq - Remove a virtual to physical IRQ mapping
  * @vcpu: The VCPU pointer
  * @map: The pointer to a mapping obtained through kvm_vgic_map_phys_irq
@@ -2109,13 +2089,19 @@ int vgic_init(struct kvm *kvm)
 		}
 
 		for (i = 0; i < dist->nr_irqs; i++) {
-			if (i < VGIC_NR_SGIS)
+			if (i < VGIC_NR_SGIS) {
+				/* SGIs */
 				vgic_bitmap_set_irq_val(&dist->irq_enabled,
 							vcpu->vcpu_id, i, 1);
-			if (i < VGIC_NR_PRIVATE_IRQS)
 				vgic_bitmap_set_irq_val(&dist->irq_cfg,
 							vcpu->vcpu_id, i,
 							VGIC_CFG_EDGE);
+			} else if (i < VGIC_NR_PRIVATE_IRQS) {
+				/* PPIs */
+				vgic_bitmap_set_irq_val(&dist->irq_cfg,
+							vcpu->vcpu_id, i,
+							VGIC_CFG_LEVEL);
+			}
 		}
 
 		vgic_enable(vcpu);
-- 
2.1.2.330.g565301e.dirty
