From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 05/13] KVM: arm/arm64: vgic-v3: Do not use Active+Pending state for a HW interrupt
Date: Thu, 18 May 2017 11:47:14 +0200
Message-ID: <20170518094722.9926-6-cdall@linaro.org>
References: <20170518094722.9926-1-cdall@linaro.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170518094722.9926-1-cdall@linaro.org>
Sender: stable-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

When an interrupt is injected with the HW bit set (indicating that
deactivation should be propagated to the physical distributor),
special care must be taken so that we never mark the corresponding
LR with the Active+Pending state (as the pending state is kept in
the physycal distributor).

Cc: stable@vger.kernel.org
Fixes: 59529f69f504 ("KVM: arm/arm64: vgic-new: Add GICv3 world switch backend")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-v3.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 8fa737e..6fe3f00 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -127,6 +127,13 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	if (irq->hw) {
 		val |= ICH_LR_HW;
 		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
+		/*
+		 * Never set pending+active on a HW interrupt, as the
+		 * pending state is kept at the physical distributor
+		 * level.
+		 */
+		if (irq->active && irq_is_pending(irq))
+			val &= ~ICH_LR_PENDING_BIT;
 	} else {
 		if (irq->config == VGIC_CONFIG_LEVEL)
 			val |= ICH_LR_EOI;
-- 
2.9.0
