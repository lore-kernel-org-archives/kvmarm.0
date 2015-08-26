From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH] KVM: arm/arm64: BUG: Fix losing level-sensitive interrupts
Date: Wed, 26 Aug 2015 09:46:03 +0300
Message-ID: <1440571563-7004-1-git-send-email-p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Commit 71760950bf3dc796e5e53ea3300dec724a09f593
("arm/arm64: KVM: add a common vgic_queue_irq_to_lr fn") introduced
vgic_queue_irq_to_lr() function which checks vgic_dist_irq_is_pending()
before setting LR_STATE_PENDING bit. However, in some cases, the following
race condition is possible:
1. Userland injects an IRQ with level == 1, this ends up in
   vgic_update_irq_pending(), which in turn calls
   vgic_dist_irq_set_pending() for this IRQ.
2. vCPU gets kicked. But kernel does not manage to reschedule it quickly
   (!!!)
3. Userland quickly resets the IRQ to level == 0. vgic_update_irq_pending()
   in this case will call vgic_dist_irq_clear_pending() and reset the
   pending flag.
4. vCPU finally wakes up. It successfully rolls through through
   __kvm_vgic_flush_hwstate(), which populates vGIC registers. Before the
   aforementioned commit LR_STATE_PENDING bit was set unconditionally, and
   nothing bad happened. However, now vgic_queue_irq_to_lr() does not set
   any state bits on this LR at all, because vgic_dist_irq_is_pending()
   returns zero (it was reset in step 3). Since this is level-sensitive
   IRQ, we end up in LR containing only LR_EOI_INT bit. The guest will not
   get this interrupt.

This patch fixes the problem by bringing back unconditional setting of
LR_STATE_PENDING bit.

The bug was caught on Cavium ThunderX machine, kernel v4.1.6, running
qemu "virt" guest, where it affected pl011 driver.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 virt/kvm/arm/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index fdcad86..90d1671 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1111,7 +1111,7 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
 		kvm_debug("Set active, clear distributor: 0x%x\n", vlr.state);
 		vgic_irq_clear_active(vcpu, irq);
 		vgic_update_state(vcpu->kvm);
-	} else if (vgic_dist_irq_is_pending(vcpu, irq)) {
+	} else {
 		vlr.state |= LR_STATE_PENDING;
 		kvm_debug("Set pending: 0x%x\n", vlr.state);
 	}
-- 
2.4.4

