From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 2/2] KVM: arm/arm64: Fix lost IRQs from emulated physcial timer when blocked
Date: Wed, 25 Jul 2018 10:21:28 +0100
Message-ID: <20180725092128.11534-3-andre.przywara@arm.com>
References: <20180725092128.11534-1-andre.przywara@arm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180725092128.11534-1-andre.przywara@arm.com>
Sender: stable-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Stable <stable@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

When the VCPU is blocked (for example from WFI) we don't inject the
physical timer interrupt if it should fire while the CPU is blocked, but
instead we just wake up the VCPU and expect kvm_timer_vcpu_load to take
care of injecting the interrupt.

Unfortunately, kvm_timer_vcpu_load() doesn't actually do that, it only
has support to schedule a soft timer if the emulated phys timer is
expected to fire in the future.

Follow the same pattern as kvm_timer_update_state() and update the irq
state after potentially scheduling a soft timer.

Reported-by: Andre Przywara <andre.przywara@arm.com>
Cc: Stable <stable@vger.kernel.org> # 4.15+
Fixes: bbdd52cfcba29 ("KVM: arm/arm64: Avoid phys timer emulation in vcpu entry/exit")
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 virt/kvm/arm/arch_timer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 18ff6203079d..17cecc96f735 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -487,6 +487,7 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	if (unlikely(!timer->enabled))
 		return;
@@ -502,6 +503,10 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 
 	/* Set the background timer for the physical timer emulation. */
 	phys_timer_emulate(vcpu);
+
+	/* If the timer fired while we weren't running, inject it now */
+	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
+		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
-- 
2.14.4
