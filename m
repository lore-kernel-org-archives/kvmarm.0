From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 1/6] KVM: arm/arm64: Do not inject spurious interrupts
Date: Tue, 20 Oct 2015 18:19:02 +0200
Message-ID: <1445357947-6022-2-git-send-email-christoffer.dall@linaro.org>
References: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Pavel Fedin <p.fedin@samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Pavel Fedin <p.fedin@samsung.com>

When lowering a level-triggered line from userspace, we forgot to lower
the pending bit on the emulated CPU interface and we also did not
re-compute the pending_on_cpu bitmap for the CPU affected by the change.

Update vgic_update_irq_pending() to fix the two issues above and also
raise a warning in vgic_quue_irq_to_lr if we encounter an interrupt
pending on a CPU which is neither marked active nor pending.

  [ Commit text reworked completely - Christoffer ]

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 6bd1c9b..596455a 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1132,7 +1132,8 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
 		kvm_debug("Set active, clear distributor: 0x%x\n", vlr.state);
 		vgic_irq_clear_active(vcpu, irq);
 		vgic_update_state(vcpu->kvm);
-	} else if (vgic_dist_irq_is_pending(vcpu, irq)) {
+	} else {
+		WARN_ON(!vgic_dist_irq_is_pending(vcpu, irq));
 		vlr.state |= LR_STATE_PENDING;
 		kvm_debug("Set pending: 0x%x\n", vlr.state);
 	}
@@ -1607,8 +1608,12 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	} else {
 		if (level_triggered) {
 			vgic_dist_irq_clear_level(vcpu, irq_num);
-			if (!vgic_dist_irq_soft_pend(vcpu, irq_num))
+			if (!vgic_dist_irq_soft_pend(vcpu, irq_num)) {
 				vgic_dist_irq_clear_pending(vcpu, irq_num);
+				vgic_cpu_irq_clear(vcpu, irq_num);
+				if (!compute_pending_for_cpu(vcpu))
+					clear_bit(cpuid, dist->irq_pending_on_cpu);
+			}
 		}
 
 		ret = false;
-- 
2.1.2.330.g565301e.dirty

