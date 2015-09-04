From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 2/2] arm/arm64: KVM: arch timer: Reset CNTV_CTL to 0
Date: Fri,  4 Sep 2015 16:24:39 +0200
Message-ID: <1441376679-8341-3-git-send-email-christoffer.dall@linaro.org>
References: <1441376679-8341-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1441376679-8341-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Laszlo Ersek <lersek@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Drew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Provide a better quality of implementation and be architecture compliant
on ARMv7 for the architected timer by resetting the CNTV_CTL to 0 on
reset of the timer, and call kvm_timer_update_state(vcpu) at the same
time, ensuring the timer output is not asserted after, for example, a
PSCI system reset.

This change alone fixes the UEFI reset issue reported by Laszlo back in
February.

Cc: Laszlo Ersek <lersek@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Drew Jones <drjones@redhat.com>
Cc: Wei Huang <wei@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 76e38d2..48c6e1a 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -200,6 +200,14 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	timer->irq = irq;
 
 	/*
+	 * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
+	 * and to 0 for ARMv7.  We provide an implementation that always
+	 * resets the timer to be disabled and unmasked and is compliant with
+	 * the ARMv7 architecture.
+	 */
+	timer->cntv_ctl = 0;
+
+	/*
 	 * Tell the VGIC that the virtual interrupt is tied to a
 	 * physical interrupt. We do that once per VCPU.
 	 */
-- 
2.1.2.330.g565301e.dirty

