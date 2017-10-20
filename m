From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 04/20] KVM: arm/arm64: Guard kvm_vgic_map_is_active against !vgic_initialized
Date: Fri, 20 Oct 2017 13:49:23 +0200
Message-ID: <20171020114939.12554-5-christoffer.dall@linaro.org>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171020114939.12554-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

If the vgic is not initialized, don't try to grab its spinlocks or
traverse its data structures.

This is important because we soon have to start considering the active
state of a virtual interrupts when doing vcpu_load, which may happen
early on before the vgic is initialized.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index fed717e07938..e1f7dbcfece0 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -777,6 +777,9 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
 	bool map_is_active;
 
+	if (!vgic_initialized(vcpu->kvm))
+		return false;
+
 	spin_lock(&irq->irq_lock);
 	map_is_active = irq->hw && irq->active;
 	spin_unlock(&irq->irq_lock);
-- 
2.14.2
