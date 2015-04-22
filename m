From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/2] KVM: arm: irqfd: fix value returned by kvm_irq_map_gsi
Date: Wed, 22 Apr 2015 16:08:37 +0100
Message-ID: <1429715318-31725-2-git-send-email-marc.zyngier@arm.com>
References: <1429715318-31725-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1429715318-31725-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Eric Auger <eric.auger@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

irqfd/arm curently does not support routing. kvm_irq_map_gsi is
supposed to return all the routing entries associated with the
provided gsi and return the number of those entries. We should
return 0 at this point.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 8d550ff..7ed7873 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2141,7 +2141,7 @@ int kvm_irq_map_gsi(struct kvm *kvm,
 		    struct kvm_kernel_irq_routing_entry *entries,
 		    int gsi)
 {
-	return gsi;
+	return 0;
 }
 
 int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
-- 
2.1.4

