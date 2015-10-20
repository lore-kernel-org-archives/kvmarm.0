From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 6/6] arm/arm64: KVM: Fix disabled distributor operation
Date: Tue, 20 Oct 2015 18:19:07 +0200
Message-ID: <1445357947-6022-7-git-send-email-christoffer.dall@linaro.org>
References: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We currently do a single update of the vgic state when the distributor
enable/disable control register is accessed and then bypass updating the
state for as long as the distributor remains disabled.

This is incorrect, because updating the state does not consider the
distributor enable bit, and this you can end up in a situation where an
interrupt is marked as pending on the CPU interface, but not pending on
the distributor, which is an impossible state to be in, and triggers a
warning.  Consider for example the following sequence of events:

1. An interrupt is marked as pending on the distributor
   - the interrupt is also forwarded to the CPU interface
2. The guest turns off the distributor (it's about to do a reboot)
   - we stop updating the CPU interface state from now on
3. The guest disables the pending interrupt
   - we remove the pending state from the distributor, but don't touch
     the CPU interface, see point 2.

Since the distributor disable bit really means that no interrupts should
be forwarded to the CPU interface, we modify the code to keep updating
the internal VGIC state, but always set the CPU interface pending bits
to zero when the distributor is disabled.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 58b1256..66c6616 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1012,6 +1012,12 @@ static int compute_pending_for_cpu(struct kvm_vcpu *vcpu)
 	pend_percpu = vcpu->arch.vgic_cpu.pending_percpu;
 	pend_shared = vcpu->arch.vgic_cpu.pending_shared;
 
+	if (!dist->enabled) {
+		bitmap_zero(pend_percpu, VGIC_NR_PRIVATE_IRQS);
+		bitmap_zero(pend_shared, nr_shared);
+		return 0;
+	}
+
 	pending = vgic_bitmap_get_cpu_map(&dist->irq_pending, vcpu_id);
 	enabled = vgic_bitmap_get_cpu_map(&dist->irq_enabled, vcpu_id);
 	bitmap_and(pend_percpu, pending, enabled, VGIC_NR_PRIVATE_IRQS);
@@ -1039,11 +1045,6 @@ void vgic_update_state(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	int c;
 
-	if (!dist->enabled) {
-		set_bit(0, dist->irq_pending_on_cpu);
-		return;
-	}
-
 	kvm_for_each_vcpu(c, vcpu, kvm) {
 		if (compute_pending_for_cpu(vcpu))
 			set_bit(c, dist->irq_pending_on_cpu);
-- 
2.1.2.330.g565301e.dirty

