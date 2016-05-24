From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 57/59] KVM: arm/arm64: vgic-new: implement mapped IRQ handling
Date: Tue, 24 May 2016 11:09:51 +0200
Message-ID: <1464080993-10884-58-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

We now store the mapped hardware IRQ number in our struct, so we
don't need the irq_phys_map for the new VGIC.
Implement the hardware IRQ mapping on top of the reworked arch
timer interface.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
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
index 3318855..69b61ab 100644
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
2.1.2.330.g565301e.dirty

