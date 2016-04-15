From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 1/7] KVM: arm/arm64: remove unneeded map parameter for vgic_update_irq_pending()
Date: Fri, 15 Apr 2016 15:04:01 +0100
Message-ID: <1460729047-6346-2-git-send-email-andre.przywara@arm.com>
References: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

We actually don't use the irq_phys_map parameter in
vgic_update_irq_pending(), so let's just remove it.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 00429b3..7282881 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1522,7 +1522,6 @@ static int vgic_validate_injection(struct kvm_vcpu *vcpu, int irq, int level)
 }
 
 static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
-				   struct irq_phys_map *map,
 				   unsigned int irq_num, bool level)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
@@ -1661,7 +1660,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 	if (map)
 		return -EINVAL;
 
-	return vgic_update_irq_pending(kvm, cpuid, NULL, irq_num, level);
+	return vgic_update_irq_pending(kvm, cpuid, irq_num, level);
 }
 
 /**
@@ -1687,7 +1686,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
 	if (ret)
 		return ret;
 
-	return vgic_update_irq_pending(kvm, cpuid, map, map->virt_irq, level);
+	return vgic_update_irq_pending(kvm, cpuid, map->virt_irq, level);
 }
 
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
-- 
2.7.3

