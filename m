From: Christoffer Dall <cdall@linaro.org>
Subject: [RFC PATCH 2/4] KVM: arm/arm64: vgic: Support level-triggered mapped
 interrupts
Date: Tue, 29 Aug 2017 11:39:00 +0200
Message-ID: <20170829093902.15379-3-cdall@linaro.org>
References: <20170829093902.15379-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3301949C3A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Aug 2017 05:37:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9cxNFlyhr1bu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Aug 2017 05:37:01 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C425D40CE9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Aug 2017 05:37:00 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id u26so18692724wma.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Aug 2017 02:39:10 -0700 (PDT)
In-Reply-To: <20170829093902.15379-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Level-triggered mapped IRQs are special because we only observe rising
edges as input to the VGIC, and we don't set the EOI flag and therefore
are not told when the level goes down, so that we can re-queue a new
interrupt when the level goes up.

One way to solve this problem is to side-step the logic of the VGIC and
special case the validation in the injection path, but it has the
unfortunate drawback of having to peak into the physical GIC state
whenever we want to know if the interrupt is pending on the virtual
distributor.

Instead, we can maintain the current semantics of a level triggered
interrupt by sort of treating it as an edge-triggered interrupt,
following from the fact that we only observe an asserting edge.  This
requires us to be a bit careful when populating the LRs and when folding
the state back in though:

 * We lower the line level when populating the LR, so that when
   subsequently observing an asserting edge, the VGIC will do the right
   thing.

 * If the guest never acked the interrupt while running (for example if
   it had masked interrupts at the CPU level while running), we have
   to preserve the pending state of the LR and move it back to the
   line_level field of the struct irq when folding LR state.

   If the guest never acked the interrupt while running, but changed the
   device state and lowered the line (again with interrupts masked) then
   we need to observe this change in the line_level.

   Both of the above situations are solved by sampling the physical line
   and set the line level when folding the LR back.

 * Finally, if the guest never acked the interrupt while running and
   sampling the line reveals that the device state has changed and the
   line has been lowered, we must clear the physical active state, since
   we will otherwise never be told when the interrupt becomes asserted
   again.

This has the added benefit of making the timer optimization patches
(https://lists.cs.columbia.edu/pipermail/kvmarm/2017-July/026343.html) a
bit simpler, because the timer code doesn't have to clear the active
state on the sync anymore.  It also potentially improves the performance
of the timer implementation because the GIC knows the state or the LR
and only needs to clear the
active state when the pending bit in the LR is still set, where the
timer has to always clear it when returning from running the guest with
an injected timer interrupt.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-v2.c | 29 +++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c | 29 +++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c    | 23 +++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h    |  7 +++++++
 4 files changed, 88 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index e4187e5..f7c5cb5 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -104,6 +104,26 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 				irq->pending_latch = false;
 		}
 
+		/*
+		 * Level-triggered mapped IRQs are special because we only
+		 * observe rising edges as input to the VGIC.
+		 *
+		 * If the guest never acked the interrupt we have to sample
+		 * the physical line and set the line level, because the
+		 * device state could have changed or we simply need to
+		 * process the still pending interrupt later.
+		 *
+		 * If this causes us to lower the level, we have to also clear
+		 * the physical active state, since we will otherwise never be
+		 * told when the interrupt becomes asserted again.
+		 */
+		if (vgic_irq_is_mapped_level(irq) && (val & GICH_LR_PENDING_BIT)) {
+			irq->line_level = vgic_irq_line_level(irq);
+
+			if (!irq->line_level)
+				vgic_irq_clear_phys_active(irq);
+		}
+
 		spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -161,6 +181,15 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 			val |= GICH_LR_EOI;
 	}
 
+	/*
+	 * Level-triggered mapped IRQs are special because we only observe
+	 * rising edges as input to the VGIC.  We therefore lower the line
+	 * level here, so that we can take new virtual IRQs.  See
+	 * vgic_v2_fold_lr_state for more info.
+	 */
+	if (vgic_irq_is_mapped_level(irq) && (val & GICH_LR_PENDING_BIT))
+		irq->line_level = false;
+
 	/* The GICv2 LR only holds five bits of priority. */
 	val |= (irq->priority >> 3) << GICH_LR_PRIORITY_SHIFT;
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 96ea597..e377036 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -94,6 +94,26 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 				irq->pending_latch = false;
 		}
 
+		/*
+		 * Level-triggered mapped IRQs are special because we only
+		 * observe rising edges as input to the VGIC.
+		 *
+		 * If the guest never acked the interrupt we have to sample
+		 * the physical line and set the line level, because the
+		 * device state could have changed or we simply need to
+		 * process the still pending interrupt later.
+		 *
+		 * If this causes us to lower the level, we have to also clear
+		 * the physical active state, since we will otherwise never be
+		 * told when the interrupt becomes asserted again.
+		 */
+		if (vgic_irq_is_mapped_level(irq) && (val & ICH_LR_PENDING_BIT)) {
+			irq->line_level = vgic_irq_line_level(irq);
+
+			if (!irq->line_level)
+				vgic_irq_clear_phys_active(irq);
+		}
+
 		spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -144,6 +164,15 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	}
 
 	/*
+	 * Level-triggered mapped IRQs are special because we only observe
+	 * rising edges as input to the VGIC.  We therefore lower the line
+	 * level here, so that we can take new virtual IRQs.  See
+	 * vgic_v3_fold_lr_state for more info.
+	 */
+	if (vgic_irq_is_mapped_level(irq) && (val & ICH_LR_PENDING_BIT))
+		irq->line_level = false;
+
+	/*
 	 * We currently only support Group1 interrupts, which is a
 	 * known defect. This needs to be addressed at some point.
 	 */
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 9d557efd..2691a0a 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -140,6 +140,29 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	kfree(irq);
 }
 
+/* Get the input level of a mapped IRQ directly from the physical GIC */
+bool vgic_irq_line_level(struct vgic_irq *irq)
+{
+	bool line_level;
+
+	BUG_ON(!irq->hw);
+
+	WARN_ON(irq_get_irqchip_state(irq->host_irq,
+				      IRQCHIP_STATE_PENDING,
+				      &line_level));
+	return line_level;
+}
+
+/* Clear the physical active state */
+void vgic_irq_clear_phys_active(struct vgic_irq *irq)
+{
+
+	BUG_ON(!irq->hw);
+	WARN_ON(irq_set_irqchip_state(irq->host_irq,
+				      IRQCHIP_STATE_ACTIVE,
+				      false));
+}
+
 /**
  * kvm_vgic_target_oracle - compute the target vcpu for an irq
  *
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index bba7fa2..22f106d 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -104,6 +104,11 @@ static inline bool irq_is_pending(struct vgic_irq *irq)
 		return irq->pending_latch || irq->line_level;
 }
 
+static inline bool vgic_irq_is_mapped_level(struct vgic_irq *irq)
+{
+	return irq->config == VGIC_CONFIG_LEVEL && irq->hw;
+}
+
 /*
  * This struct provides an intermediate representation of the fields contained
  * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC
@@ -140,6 +145,8 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
+bool vgic_irq_line_level(struct vgic_irq *irq);
+void vgic_irq_clear_phys_active(struct vgic_irq *irq);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
 void vgic_kick_vcpus(struct kvm *kvm);
 
-- 
2.9.0
