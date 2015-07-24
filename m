From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 05/11] KVM: arm/arm64: vgic: Relax vgic_can_sample_irq for edge IRQs
Date: Fri, 24 Jul 2015 16:55:03 +0100
Message-ID: <1437753309-17989-6-git-send-email-marc.zyngier@arm.com>
References: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We only set the irq_queued flag for level interrupts, meaning
that "!vgic_irq_is_queued(vcpu, irq)" is a good enough predicate
for all interrupts.

This will allow us to inject edge HW interrupts, for which the
state ACTIVE+PENDING is not allowed.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index bc40137..5bd1695 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -375,7 +375,7 @@ void vgic_cpu_irq_clear(struct kvm_vcpu *vcpu, int irq)
 
 static bool vgic_can_sample_irq(struct kvm_vcpu *vcpu, int irq)
 {
-	return vgic_irq_is_edge(vcpu, irq) || !vgic_irq_is_queued(vcpu, irq);
+	return !vgic_irq_is_queued(vcpu, irq);
 }
 
 /**
-- 
2.1.4

