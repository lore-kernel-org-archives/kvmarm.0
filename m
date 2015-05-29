From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm: vgic: Drop useless Group0 warning
Date: Fri, 29 May 2015 17:30:15 +0100
Message-ID: <1432917015-31439-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

If a GICv3-enabled guest tries to configure Group0, we print a
warning on the console (because we don't support Group0 interrupts).

This is fairly pointless, and would allow a guest to spam the
console. Let's just drop the warning.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic-v3-emul.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index e9c3a7a..53e6a6d 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -76,8 +76,6 @@ static bool handle_mmio_ctlr(struct kvm_vcpu *vcpu,
 	vgic_reg_access(mmio, &reg, offset,
 			ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
 	if (mmio->is_write) {
-		if (reg & GICD_CTLR_ENABLE_SS_G0)
-			kvm_info("guest tried to enable unsupported Group0 interrupts\n");
 		vcpu->kvm->arch.vgic.enabled = !!(reg & GICD_CTLR_ENABLE_SS_G1);
 		vgic_update_state(vcpu->kvm);
 		return true;
-- 
2.1.4

