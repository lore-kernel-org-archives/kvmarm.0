From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] KVM: arm/arm64: Avoid attempting to load timer vgic state without a vgic
Date: Wed, 29 Nov 2017 17:30:09 +0100
Message-ID: <1511973009-56442-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The timer optimization patches inadvertendly changed the logic to always
load the timer state as if we have a vgic, even if we don't have a vgic.

Fix this by doing the usual irqchip_in_kernel() check and call the
appropriate load function.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
I'm aware that this looks slightly ugly following the no_vgic label, but
this code is about to disappear with the vcpu_load/vcpu_put series, so
it's just a fix for the current version.

 virt/kvm/arm/arch_timer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 190c99e..f9555b1 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -835,7 +835,10 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 no_vgic:
 	preempt_disable();
 	timer->enabled = 1;
-	kvm_timer_vcpu_load_vgic(vcpu);
+	if (!irqchip_in_kernel(vcpu->kvm))
+		kvm_timer_vcpu_load_user(vcpu);
+	else
+		kvm_timer_vcpu_load_vgic(vcpu);
 	preempt_enable();
 
 	return 0;
-- 
2.7.4
