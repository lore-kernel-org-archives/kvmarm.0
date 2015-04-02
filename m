From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 07/27] KVM: arm/arm64: remove coarse grain dist locking at
 kvm_vgic_sync_hwstate
Date: Thu,  2 Apr 2015 11:05:11 +0100
Message-ID: <1427969131-8445-8-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EE5E4AD3D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 05:57:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YcJjDdNu0Nid for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2015 05:57:58 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 940834AD5C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 05:57:56 -0400 (EDT)
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

To prepare for irqfd addition, coarse grain locking is removed at
kvm_vgic_sync_hwstate level and finer grain locking is introduced in
vgic_process_maintenance only.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 86cec79..897c849 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1081,6 +1081,7 @@ epilog:
 static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 {
 	u32 status = vgic_get_interrupt_status(vcpu);
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	bool level_pending = false;
 
 	kvm_debug("STATUS = %08x\n", status);
@@ -1098,6 +1099,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 			struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
 			WARN_ON(vgic_irq_is_edge(vcpu, vlr.irq));
 
+			spin_lock(&dist->lock);
 			vgic_irq_clear_queued(vcpu, vlr.irq);
 			WARN_ON(vlr.state & LR_STATE_MASK);
 			vlr.state = 0;
@@ -1125,6 +1127,8 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 				vgic_cpu_irq_clear(vcpu, vlr.irq);
 			}
 
+			spin_unlock(&dist->lock);
+
 			/*
 			 * Despite being EOIed, the LR may not have
 			 * been marked as empty.
@@ -1139,10 +1143,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 	return level_pending;
 }
 
-/*
- * Sync back the VGIC state after a guest run. The distributor lock is
- * needed so we don't get preempted in the middle of the state processing.
- */
+/* Sync back the VGIC state after a guest run */
 static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
@@ -1189,14 +1190,10 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return;
 
-	spin_lock(&dist->lock);
 	__kvm_vgic_sync_hwstate(vcpu);
-	spin_unlock(&dist->lock);
 }
 
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
-- 
2.1.4
