From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 56/57] KVM: arm/arm64: vgic-new: implement mapped IRQ handling
Date: Thu, 19 May 2016 19:08:35 +0100
Message-ID: <1463681316-23039-57-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

As we now store the mapped hardware IRQ number in our vgic_irq struct,
we no longer need the irq_phys_map for the new VGIC.
Implement the hardware IRQ mapping on top of the reworked arch timer
interface.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changelog RFC..v1:
- adapt to new arch_timer mapped IRQ interface
- implement inject_mapped_irq() as a macro (since it is identical to
  the "un-mapped" IRQ implementation)

Changelog v1 .. v2:
- replace inject_mapped_irq() macro with a separate implementation,
  which only allows mapped IRQs to be injected via this interface

Changelog v4 .. v5:
- avoid accessing uninitialized spinlock on kvm_vgic_unmap_phys_irq

 include/kvm/vgic/vgic.h  |  5 +++++
 virt/kvm/arm/vgic/vgic.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 17b2a73..3fbd175 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -206,6 +206,11 @@ int kvm_vgic_hyp_init(void);
 
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level);
+int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
+			       bool level);
+int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq);
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 6b892a4..fc74367 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -312,6 +312,47 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 	return vgic_update_irq_pending(kvm, cpuid, intid, level, false);
 }
 
+int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
+			       bool level)
+{
+	return vgic_update_irq_pending(kvm, cpuid, intid, level, true);
+}
+
+int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
+{
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
+
+	BUG_ON(!irq);
+
+	spin_lock(&irq->irq_lock);
+
+	irq->hw = true;
+	irq->hwintid = phys_irq;
+
+	spin_unlock(&irq->irq_lock);
+
+	return 0;
+}
+
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
+{
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
+
+	BUG_ON(!irq);
+
+	if (!vgic_initialized(vcpu->kvm))
+		return -EAGAIN;
+
+	spin_lock(&irq->irq_lock);
+
+	irq->hw = false;
+	irq->hwintid = 0;
+
+	spin_unlock(&irq->irq_lock);
+
+	return 0;
+}
+
 /**
  * vgic_prune_ap_list - Remove non-relevant interrupts from the list
  *
@@ -564,3 +605,15 @@ void vgic_kick_vcpus(struct kvm *kvm)
 			kvm_vcpu_kick(vcpu);
 	}
 }
+
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
+{
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
+	bool map_is_active;
+
+	spin_lock(&irq->irq_lock);
+	map_is_active = irq->hw && irq->active;
+	spin_unlock(&irq->irq_lock);
+
+	return map_is_active;
+}
-- 
2.8.2

