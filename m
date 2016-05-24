From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 03/59] KVM: arm/arm64: vgic: avoid map in
 kvm_vgic_inject_mapped_irq()
Date: Tue, 24 May 2016 11:08:57 +0200
Message-ID: <1464080993-10884-4-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A11049B77
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QSyRngcG-8rM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:26 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D87A49B78
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:25 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id z87so15336192wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:09:58 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

When we want to inject a hardware mapped IRQ into a guest, we actually
only need the virtual IRQ number from the irq_phys_map.
So let's pass this number directly from the arch timer to the VGIC
to avoid using the map as a parameter.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h    | 2 +-
 virt/kvm/arm/arch_timer.c | 2 +-
 virt/kvm/arm/vgic.c       | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index be6037a..e22f015 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -342,7 +342,7 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 			bool level);
 int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
-			       struct irq_phys_map *map, bool level);
+			       unsigned int virt_irq, bool level);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 409db33..a9c6c1c 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -177,7 +177,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->map->virt_irq,
 				   timer->irq.level);
 	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
-					 timer->map,
+					 timer->map->virt_irq,
 					 timer->irq.level);
 	WARN_ON(ret);
 }
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index f6c6172..81c557c 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1666,7 +1666,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
  * kvm_vgic_inject_mapped_irq - Inject a physically mapped IRQ to the vgic
  * @kvm:     The VM structure pointer
  * @cpuid:   The CPU for PPIs
- * @map:     Pointer to a irq_phys_map structure describing the mapping
+ * @virt_irq: The virtual IRQ to be injected
  * @level:   Edge-triggered:  true:  to trigger the interrupt
  *			      false: to ignore the call
  *	     Level-sensitive  true:  raise the input signal
@@ -1677,7 +1677,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
  * being HIGH and 0 being LOW and all devices being active-HIGH.
  */
 int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
-			       struct irq_phys_map *map, bool level)
+			       unsigned int virt_irq, bool level)
 {
 	int ret;
 
@@ -1685,7 +1685,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
 	if (ret)
 		return ret;
 
-	return vgic_update_irq_pending(kvm, cpuid, map->virt_irq, level);
+	return vgic_update_irq_pending(kvm, cpuid, virt_irq, level);
 }
 
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
-- 
2.1.2.330.g565301e.dirty
