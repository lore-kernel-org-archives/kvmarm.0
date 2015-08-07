From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 05/11] KVM: arm/arm64: vgic: Relax vgic_can_sample_irq for edge IRQs
Date: Fri,  7 Aug 2015 16:45:41 +0100
Message-ID: <1438962347-17541-6-git-send-email-marc.zyngier@arm.com>
References: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
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

