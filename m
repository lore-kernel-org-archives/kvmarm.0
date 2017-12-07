From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v7 5/8] KVM: arm/arm64: Support a vgic interrupt line level sample function
Date: Thu,  7 Dec 2017 11:54:15 +0100
Message-ID: <20171207105418.22428-6-christoffer.dall@linaro.org>
References: <20171207105418.22428-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207105418.22428-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The GIC sometimes need to sample the physical line of a mapped
interrupt.  As we know this to be notoriously slow, provide a callback
function for devices (such as the timer) which can do this much faster
than talking to the distributor, for example by comparing a few
in-memory values.  Fall back to the good old method of poking the
physical GIC if no callback is provided.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h    | 13 ++++++++++++-
 virt/kvm/arm/arch_timer.c |  3 ++-
 virt/kvm/arm/vgic/vgic.c  | 12 +++++++++---
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8c896540a72c..cdbd142ca7f2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -130,6 +130,17 @@ struct vgic_irq {
 	u8 priority;
 	enum vgic_irq_config config;	/* Level or edge */
 
+	/*
+	 * Callback function pointer to in-kernel devices that can tell us the
+	 * state of the input level of mapped level-triggered IRQ faster than
+	 * peaking into the physical GIC.
+	 *
+	 * Always called in non-preemptible section and the functions can use
+	 * kvm_arm_get_running_vcpu() to get the vcpu pointer for private
+	 * IRQs.
+	 */
+	bool (*get_input_level)(int vintid);
+
 	void *owner;			/* Opaque pointer to reserve an interrupt
 					   for in-kernel devices. */
 };
@@ -331,7 +342,7 @@ void kvm_vgic_init_cpu_hardware(void);
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level, void *owner);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid);
+			  u32 vintid, bool (*get_input_level)(int vindid));
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index dd5aca05c500..e78ba5e20f74 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -840,7 +840,8 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
 
-	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq, vtimer->irq.irq);
+	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq, vtimer->irq.irq,
+				    NULL);
 	if (ret)
 		return ret;
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 607cbbc27a1c..eadabb249d2a 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -151,6 +151,9 @@ bool vgic_get_phys_line_level(struct vgic_irq *irq)
 
 	BUG_ON(!irq->hw);
 
+	if (irq->get_input_level)
+		return irq->get_input_level(irq->intid);
+
 	WARN_ON(irq_get_irqchip_state(irq->host_irq,
 				      IRQCHIP_STATE_PENDING,
 				      &line_level));
@@ -436,7 +439,8 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 
 /* @irq->irq_lock must be held */
 static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
-			    unsigned int host_irq)
+			    unsigned int host_irq,
+			    bool (*get_input_level)(int vindid))
 {
 	struct irq_desc *desc;
 	struct irq_data *data;
@@ -456,6 +460,7 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	irq->hw = true;
 	irq->host_irq = host_irq;
 	irq->hwintid = data->hwirq;
+	irq->get_input_level = get_input_level;
 	return 0;
 }
 
@@ -464,10 +469,11 @@ static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
 {
 	irq->hw = false;
 	irq->hwintid = 0;
+	irq->get_input_level = NULL;
 }
 
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid)
+			  u32 vintid, bool (*get_input_level)(int vindid))
 {
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
 	unsigned long flags;
@@ -476,7 +482,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 	BUG_ON(!irq);
 
 	spin_lock_irqsave(&irq->irq_lock, flags);
-	ret = kvm_vgic_map_irq(vcpu, irq, host_irq);
+	ret = kvm_vgic_map_irq(vcpu, irq, host_irq, get_input_level);
 	spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
 
-- 
2.14.2
