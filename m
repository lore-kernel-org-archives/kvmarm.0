From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH] KVM: arm/arm64: vgic-v2: Set active_source to 0 when restoring state
Date: Tue, 11 Dec 2018 12:51:03 +0100
Message-ID: <20181211115103.12212-1-christoffer.dall@arm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When restoring the active state from userspace, we don't know which CPU
was the source for the active state, and this is not architecturally
exposed in any of the register state.

Set the active_source to 0 in this case.  In the future, we can expand
on this and exposse the information as additional information to
userspace for GICv2 if anyone cares.

Cc: stable@vger.kernel.org
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index f56ff1cf52ec..2b450d49a046 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -338,11 +338,26 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 		vgic_hw_irq_change_active(vcpu, irq, active, !requester_vcpu);
 	} else {
 		u32 model = vcpu->kvm->arch.vgic.vgic_model;
+		u8 active_source;
 
 		irq->active = active;
+
+		/*
+		 * The GICv2 architecture indicates that the source CPUID for
+		 * an SGI should be provided during an EOI which implies that
+		 * the active state is stored somewhere, but at the same time
+		 * this state is not architecturally exposed anywhere and we
+		 * have no way of knowing the right source.
+		 *
+		 * This may lead to a VCPU not being able to receive
+		 * additional instances of a particular SGI after migration
+		 * for a GICv2 VM on some GIC implementations.  Oh well.
+		 */
+		active_source = (requester_vcpu) ? requester_vcpu->vcpu_id : 0;
+
 		if (model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
 		    active && vgic_irq_is_sgi(irq->intid))
-			irq->active_source = requester_vcpu->vcpu_id;
+			irq->active_source = active_source;
 	}
 
 	if (irq->active)
-- 
2.18.0
