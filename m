From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 03/57] KVM: arm/arm64: vgic: avoid map in
 kvm_vgic_map_is_active()
Date: Thu, 19 May 2016 19:07:42 +0100
Message-ID: <1463681316-23039-4-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 009D649B4A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 14:05:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C6x63OqPVSaZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2016 14:05:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F84D499A1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 14:04:58 -0400 (EDT)
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

For getting the active state of a mapped IRQ, we actually only need
the virtual IRQ number, not the pointer to the mapping entry.
Pass the virtual IRQ number from the arch timer to the VGIC directly.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
---
Changelog v1 .. v2:
- rewrap phys_active determination to fit in 80 characters

 include/kvm/arm_vgic.h    | 2 +-
 virt/kvm/arm/arch_timer.c | 6 ++----
 virt/kvm/arm/vgic.c       | 6 +++---
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index e22f015..9830232 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -348,7 +348,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 					   int virt_irq, int irq);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
-bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index a9c6c1c..37f82c1 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -274,10 +274,8 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	* to ensure that hardware interrupts from the timer triggers a guest
 	* exit.
 	*/
-	if (timer->irq.level || kvm_vgic_map_is_active(vcpu, timer->map))
-		phys_active = true;
-	else
-		phys_active = false;
+	phys_active = timer->irq.level ||
+			kvm_vgic_map_is_active(vcpu, timer->map->virt_irq);
 
 	/*
 	 * We want to avoid hitting the (re)distributor as much as
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 81c557c..2fd43a6 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1102,18 +1102,18 @@ static bool dist_active_irq(struct kvm_vcpu *vcpu)
 	return test_bit(vcpu->vcpu_id, dist->irq_active_on_cpu);
 }
 
-bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 {
 	int i;
 
 	for (i = 0; i < vcpu->arch.vgic_cpu.nr_lr; i++) {
 		struct vgic_lr vlr = vgic_get_lr(vcpu, i);
 
-		if (vlr.irq == map->virt_irq && vlr.state & LR_STATE_ACTIVE)
+		if (vlr.irq == virt_irq && vlr.state & LR_STATE_ACTIVE)
 			return true;
 	}
 
-	return vgic_irq_is_active(vcpu, map->virt_irq);
+	return vgic_irq_is_active(vcpu, virt_irq);
 }
 
 /*
-- 
2.8.2
