From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 11/45] KVM: arm/arm64: vgic-new: Implement kvm_vgic_vcpu_pending_irq
Date: Fri, 25 Mar 2016 02:04:34 +0000
Message-ID: <1458871508-17279-12-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

Tell KVM whether a particular VCPU has an IRQ that needs handling
in the guest. This is used to decide whether a VCPU is runnable.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h  |  2 ++
 virt/kvm/arm/vgic/vgic.c | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 986f23f..2ce9b4a 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -181,6 +181,8 @@ struct vgic_cpu {
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level);
 
+int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
+
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(false)
 #define vgic_ready(k)		((k)->arch.vgic.ready)
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 9eb031e8..d6c8c92 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -477,3 +477,25 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	vgic_populate_lrs(vcpu);
 	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
 }
+
+int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_irq *irq;
+	bool pending = false;
+
+	spin_lock(&vgic_cpu->ap_list_lock);
+
+	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
+		spin_lock(&irq->irq_lock);
+		pending = irq->pending && irq->enabled;
+		spin_unlock(&irq->irq_lock);
+
+		if (pending)
+			break;
+	}
+
+	spin_unlock(&vgic_cpu->ap_list_lock);
+
+	return pending;
+}
-- 
2.7.3

