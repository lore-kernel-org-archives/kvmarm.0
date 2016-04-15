From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 2/7] KVM: arm/arm64: directly pass virtual IRQ number on
 injecting mapped IRQ
Date: Fri, 15 Apr 2016 15:04:02 +0100
Message-ID: <1460729047-6346-3-git-send-email-andre.przywara@arm.com>
References: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A04449BDC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 10:02:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dlx3Yuynic2k for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 10:02:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A65BA49BE7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 10:02:19 -0400 (EDT)
In-Reply-To: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When we want to inject a hardware mapped IRQ into a guest, we actually
only need the virtual IRQ number from the irq_phys_map.
So let's pass this number directly from the arch timer to the VGIC
to avoid using the map as a parameter.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h    | 2 +-
 virt/kvm/arm/arch_timer.c | 2 +-
 virt/kvm/arm/vgic.c       | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 281caf8..c4574da 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -341,7 +341,7 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 			bool level);
 int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
-			       struct irq_phys_map *map, bool level);
+			       unsigned int virt_irq, bool level);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index a9ad4fe..eb56f1e 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -140,7 +140,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->map->virt_irq,
 				   timer->irq.level);
 	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
-					 timer->map,
+					 timer->map->virt_irq,
 					 timer->irq.level);
 	WARN_ON(ret);
 }
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 7282881..9937d41 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1667,7 +1667,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
  * kvm_vgic_inject_mapped_irq - Inject a physically mapped IRQ to the vgic
  * @kvm:     The VM structure pointer
  * @cpuid:   The CPU for PPIs
- * @map:     Pointer to a irq_phys_map structure describing the mapping
+ * @virt_irq: The virtual IRQ to be injected
  * @level:   Edge-triggered:  true:  to trigger the interrupt
  *			      false: to ignore the call
  *	     Level-sensitive  true:  raise the input signal
@@ -1678,7 +1678,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
  * being HIGH and 0 being LOW and all devices being active-HIGH.
  */
 int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
-			       struct irq_phys_map *map, bool level)
+			       unsigned int virt_irq, bool level)
 {
 	int ret;
 
@@ -1686,7 +1686,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
 	if (ret)
 		return ret;
 
-	return vgic_update_irq_pending(kvm, cpuid, map->virt_irq, level);
+	return vgic_update_irq_pending(kvm, cpuid, virt_irq, level);
 }
 
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
-- 
2.7.3
