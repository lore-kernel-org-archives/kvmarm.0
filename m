From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 02/16] KVM: arm/arm64: remove now unused code after stay-in-LR rework
Date: Wed,  7 Oct 2015 15:55:12 +0100
Message-ID: <1444229726-31559-3-git-send-email-andre.przywara@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: eric.auger@linaro.org, p.fedin@samsung.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that we synchronize the LR state into our emulation upon guest
exit, there is no need for taking extra care of disabled IRQs.
Remove that code.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v2..v3:
- new patch

 virt/kvm/arm/vgic.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index da0a866..a5360b7 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -101,7 +101,6 @@
 
 #include "vgic.h"
 
-static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
 static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu);
 static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
 static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
@@ -477,7 +476,6 @@ bool vgic_handle_enable_reg(struct kvm *kvm, struct kvm_exit_mmio *mmio,
 {
 	u32 *reg;
 	int mode = ACCESS_READ_VALUE | access;
-	struct kvm_vcpu *target_vcpu = kvm_get_vcpu(kvm, vcpu_id);
 
 	reg = vgic_bitmap_get_reg(&kvm->arch.vgic.irq_enabled, vcpu_id, offset);
 	vgic_reg_access(mmio, reg, offset, mode);
@@ -485,7 +483,6 @@ bool vgic_handle_enable_reg(struct kvm *kvm, struct kvm_exit_mmio *mmio,
 		if (access & ACCESS_WRITE_CLEARBIT) {
 			if (offset < 4) /* Force SGI enabled */
 				*reg |= 0xffff;
-			vgic_retire_disabled_irqs(target_vcpu);
 		}
 		vgic_update_state(kvm);
 		return true;
@@ -1099,32 +1096,6 @@ static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu)
 	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
 }
 
-/*
- * An interrupt may have been disabled after being made pending on the
- * CPU interface (the classic case is a timer running while we're
- * rebooting the guest - the interrupt would kick as soon as the CPU
- * interface gets enabled, with deadly consequences).
- *
- * The solution is to examine already active LRs, and check the
- * interrupt is still enabled. If not, just retire it.
- */
-static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu)
-{
-	u64 elrsr = vgic_get_elrsr(vcpu);
-	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
-	int lr;
-
-	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
-		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
-
-		if (!vgic_irq_is_enabled(vcpu, vlr.irq)) {
-			vgic_retire_lr(lr, vcpu);
-			if (vgic_irq_is_queued(vcpu, vlr.irq))
-				vgic_irq_clear_queued(vcpu, vlr.irq);
-		}
-	}
-}
-
 static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
 				 int lr_nr, struct vgic_lr vlr)
 {
-- 
2.5.1

