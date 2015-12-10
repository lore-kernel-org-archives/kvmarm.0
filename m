From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] KVM: arm/arm64: vgic: Fix kvm_vgic_map_is_active's dist check
Date: Thu, 10 Dec 2015 22:46:50 +0100
Message-ID: <1449784010-21761-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

External inputs to the vgic from time to time need to poke into the
state of a virtual interrupt, the prime example is the architected timer
code.

Since the IRQ's active state can be represented in two places; the LR or
the distributor, we first loop over the LRs but if not active in the LRs
we just return if *any* IRQ is active on the VCPU in question.

This is of course bogus, as we should check if the specific IRQ in
quesiton is active on the distributor instead.

Reported-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 65461f8..7a2f449 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1114,7 +1114,7 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
 			return true;
 	}
 
-	return dist_active_irq(vcpu);
+	return vgic_irq_is_active(vcpu, map->virt_irq);
 }
 
 /*
-- 
2.1.2.330.g565301e.dirty

