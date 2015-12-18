From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: vgic: Fix kvm_vgic_map_is_active's dist check
Date: Fri, 18 Dec 2015 14:05:52 +0000
Message-ID: <1450447552-3161-2-git-send-email-marc.zyngier@arm.com>
References: <1450447552-3161-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450447552-3161-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

External inputs to the vgic from time to time need to poke into the
state of a virtual interrupt, the prime example is the architected timer
code.

Since the IRQ's active state can be represented in two places; the LR or
the distributor, we first loop over the LRs but if not active in the LRs
we just return if *any* IRQ is active on the VCPU in question.

This is of course bogus, as we should check if the specific IRQ in
quesiton is active on the distributor instead.

Reported-by: Eric Auger <eric.auger@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
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
2.1.4

