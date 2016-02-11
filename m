From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/2] KVM: arm/arm64: Fix reference to uninitialised VGIC
Date: Thu, 11 Feb 2016 15:59:45 +0000
Message-ID: <1455206386-24997-2-git-send-email-marc.zyngier@arm.com>
References: <1455206386-24997-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1455206386-24997-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andre Przywara <andre.przywara@arm.com>, Cosmin Gorgovan <cosmin@linux-geek.org>, Christoffer Dall <christoffer.dall@linaro.org>, Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Gleb Natapov <gleb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Commit 4b4b4512da2a ("arm/arm64: KVM: Rework the arch timer to use
level-triggered semantics") brought the virtual architected timer
closer to the VGIC. There is one occasion were we don't properly
check for the VGIC actually having been initialized before, but
instead go on to check the active state of some IRQ number.
If userland hasn't instantiated a virtual GIC, we end up with a
kernel NULL pointer dereference:
=========
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = ffffffc9745c5000
[00000000] *pgd=00000009f631e003, *pud=00000009f631e003, *pmd=0000000000000000
Internal error: Oops: 96000006 [#2] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 2144 Comm: kvm_simplest-ar Tainted: G      D 4.5.0-rc2+ #1300
Hardware name: ARM Juno development board (r1) (DT)
task: ffffffc976da8000 ti: ffffffc976e28000 task.ti: ffffffc976e28000
PC is at vgic_bitmap_get_irq_val+0x78/0x90
LR is at kvm_vgic_map_is_active+0xac/0xc8
pc : [<ffffffc0000b7e28>] lr : [<ffffffc0000b972c>] pstate: 20000145
....
=========

Fix this by bailing out early of kvm_timer_flush_hwstate() if we don't
have a VGIC at all.

Reported-by: Cosmin Gorgovan <cosmin@linux-geek.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: <stable@vger.kernel.org> # 4.4.x
---
 virt/kvm/arm/arch_timer.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 69bca18..ea60646 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -143,7 +143,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
  * Check if there was a change in the timer state (should we raise or lower
  * the line level to the GIC).
  */
-static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
+static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
@@ -154,10 +154,12 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	 * until we call this function from kvm_timer_flush_hwstate.
 	 */
 	if (!vgic_initialized(vcpu->kvm))
-	    return;
+		return -ENODEV;
 
 	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
 		kvm_timer_update_irq(vcpu, !timer->irq.level);
+
+	return 0;
 }
 
 /*
@@ -218,7 +220,8 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	bool phys_active;
 	int ret;
 
-	kvm_timer_update_state(vcpu);
+	if (kvm_timer_update_state(vcpu))
+		return;
 
 	/*
 	* If we enter the guest with the virtual input level to the VGIC
-- 
2.1.4

