From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v5 4/8] KVM: arm/arm64: vgic: Support level-triggered mapped
 interrupts
Date: Mon, 20 Nov 2017 20:16:45 +0100
Message-ID: <20171120191649.17290-5-christoffer.dall@linaro.org>
References: <20171120191649.17290-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9063049D4E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Nov 2017 14:14:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vVBBQv0S9UBH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Nov 2017 14:14:22 -0500 (EST)
Received: from mail-wr0-f193.google.com (mail-wr0-f193.google.com
 [209.85.128.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA81C49D4C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Nov 2017 14:14:20 -0500 (EST)
Received: by mail-wr0-f193.google.com with SMTP id k61so9081673wrc.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Nov 2017 11:16:51 -0800 (PST)
In-Reply-To: <20171120191649.17290-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>
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

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-v2.c | 29 +++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c | 29 +++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c    | 23 +++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h    |  7 +++++++
 4 files changed, 88 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 80897102da26..c32d7b93ffd1 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -105,6 +105,26 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
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
+			irq->line_level = vgic_get_phys_line_level(irq);
+
+			if (!irq->line_level)
+				vgic_irq_set_phys_active(irq, false);
+		}
+
 		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -162,6 +182,15 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
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
index f47e8481fa45..6b329414e57a 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -96,6 +96,26 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
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
+			irq->line_level = vgic_get_phys_line_level(irq);
+
+			if (!irq->line_level)
+				vgic_irq_set_phys_active(irq, false);
+		}
+
 		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -145,6 +165,15 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 			val |= ICH_LR_EOI;
 	}
 
+	/*
+	 * Level-triggered mapped IRQs are special because we only observe
+	 * rising edges as input to the VGIC.  We therefore lower the line
+	 * level here, so that we can take new virtual IRQs.  See
+	 * vgic_v3_fold_lr_state for more info.
+	 */
+	if (vgic_irq_is_mapped_level(irq) && (val & ICH_LR_PENDING_BIT))
+		irq->line_level = false;
+
 	/*
 	 * We currently only support Group1 interrupts, which is a
 	 * known defect. This needs to be addressed at some point.
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 786cce7bd2ec..423a572c92f5 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -144,6 +144,29 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	kfree(irq);
 }
 
+/* Get the input level of a mapped IRQ directly from the physical GIC */
+bool vgic_get_phys_line_level(struct vgic_irq *irq)
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
+/* Set/Clear the physical active state */
+void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active)
+{
+
+	BUG_ON(!irq->hw);
+	WARN_ON(irq_set_irqchip_state(irq->host_irq,
+				      IRQCHIP_STATE_ACTIVE,
+				      active));
+}
+
 /**
  * kvm_vgic_target_oracle - compute the target vcpu for an irq
  *
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index efbcf8f96f9c..d0787983a357 100644
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
+bool vgic_get_phys_line_level(struct vgic_irq *irq);
+void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 			   unsigned long flags);
 void vgic_kick_vcpus(struct kvm *kvm);
-- 
2.14.2
