From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 4/6] KVM: arm/arm64: Support VGIC dist pend/active changes for mapped IRQs
Date: Mon,  4 Sep 2017 12:24:54 +0200
Message-ID: <20170904102456.9025-5-cdall@linaro.org>
References: <20170904102456.9025-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170904102456.9025-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

For mapped IRQs (with the HW bit set in the LR) we have to follow some
rules of the architecture.  One of these rules is that VM must not be
allowed to deactivate a virtual interrupt with the HW bit set unless the
physical interrupt is also active.

This works fine when injecting mapped interrupts, because we leave it up
to the injector to either set EOImode==1 or manually set the active
state of the physical interrupt.

However, the guest can set virtual interrupt to be pending or active by
writing to the virtual distributor, which could lead to deactivating a
virtual interrupt with the HW bit set without the physical interrupt
being active.

We could set the physical interrupt to active whenever we are about to
eneter the VM with a HW interrupt either pending or active, but that
would be really slow, especially on GICv2.  So we take the long way
around and do the hard work when needed, which is expected to be
extremely rare.

When the VM sets the pending state for a HW interrupt on the virtual
distributor we set the active state on the physical distributor, because
the virtual interrupt can become active and then the guest can
deactivate it.

When the VM clears the pending state we also clear it on the physical
side, because the injector might otherwise raise the interrupt.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 27 +++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c      |  7 +++++++
 virt/kvm/arm/vgic/vgic.h      |  1 +
 3 files changed, 35 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index c1e4bdd..c825d7c 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -131,6 +131,12 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		spin_lock(&irq->irq_lock);
+		if (irq->hw) {
+			vgic_irq_set_phys_active(irq, true);
+			spin_unlock(&irq->irq_lock);
+			continue;
+		}
+
 		irq->pending_latch = true;
 
 		vgic_queue_irq_unlock(vcpu->kvm, irq);
@@ -149,6 +155,11 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		spin_lock(&irq->irq_lock);
+		if (irq->hw) {
+			vgic_irq_set_phys_pending(irq, false);
+			spin_unlock(&irq->irq_lock);
+			continue;
+		}
 
 		irq->pending_latch = false;
 
@@ -214,6 +225,22 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	       irq->vcpu->cpu != -1) /* VCPU thread is running */
 		cond_resched_lock(&irq->irq_lock);
 
+	if (irq->hw) {
+		/*
+		 * We cannot support setting the physical active state for
+		 * private interrupts from another CPU than the one running
+		 * the VCPU which identifies which private interrupt it is
+		 * trying to modify.
+		 */
+		if (irq->intid < VGIC_NR_PRIVATE_IRQS &&
+		    irq->target_vcpu != requester_vcpu) {
+			spin_unlock(&irq->irq_lock);
+			return;
+		}
+
+		vgic_irq_set_phys_active(irq, new_active_state);
+	}
+
 	irq->active = new_active_state;
 	if (new_active_state)
 		vgic_queue_irq_unlock(vcpu->kvm, irq);
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 8072969..7aec730 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -140,6 +140,13 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	kfree(irq);
 }
 
+void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending)
+{
+	WARN_ON(irq_set_irqchip_state(irq->host_irq,
+				      IRQCHIP_STATE_PENDING,
+				      pending));
+}
+
 /* Get the input level of a mapped IRQ directly from the physical GIC */
 bool vgic_get_phys_line_level(struct vgic_irq *irq)
 {
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 7bdcda2..498ee05 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -146,6 +146,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
 bool vgic_get_phys_line_level(struct vgic_irq *irq);
+void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
 void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
 void vgic_kick_vcpus(struct kvm *kvm);
-- 
2.9.0
