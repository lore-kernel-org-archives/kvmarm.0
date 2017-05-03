From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 04/31] KVM: arm/arm64: vgic-v2: Do not use Active+Pending state for a HW interrupt
Date: Wed,  3 May 2017 11:45:39 +0100
Message-ID: <20170503104606.19342-5-marc.zyngier@arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When an interrupt is injected with the HW bit set (indicating that
deactivation should be propagated to the physical distributor),
special care must be taken so that we never mark the corresponding
LR with the Active+Pending state (as the pending state is kept in
the physycal distributor).

Cc: stable@vger.kernel.org
Fixes: 140b086dd197 ("KVM: arm/arm64: vgic-new: Add GICv2 world switch backend")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index a65757aab6d3..504b4bd0d651 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -149,6 +149,13 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	if (irq->hw) {
 		val |= GICH_LR_HW;
 		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
+		/*
+		 * Never set pending+active on a HW interrupt, as the
+		 * pending state is kept at the physical distributor
+		 * level.
+		 */
+		if (irq->active && irq_is_pending(irq))
+			val &= ~GICH_LR_PENDING_BIT;
 	} else {
 		if (irq->config == VGIC_CONFIG_LEVEL)
 			val |= GICH_LR_EOI;
-- 
2.11.0
