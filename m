From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 6/7] arm64: KVM: vgic-v3: Prevent the guest from messing with ICC_SRE_EL1
Date: Mon, 23 May 2016 13:37:02 +0100
Message-ID: <1464007023-11736-7-git-send-email-marc.zyngier@arm.com>
References: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Both our GIC emulations are "strict", in the sense that we either
emulate a GICv2 or a GICv3, and not a GICv3 with GICv2 legacy
support.

But when running on a GICv3 host, we still allow the guest to
tinker with the ICC_SRE_EL1 register during its time slice:
it can switch SRE off, observe that it is off, and yet on the
next world switch, find the SRE bit to be set again. Not very
nice.

An obvious solution is to always trap accesses to ICC_SRE_EL1
(by clearing ICC_SRE_EL2.Enable), and to let the handler return
the programmed value on a read, or ignore the write.

That way, the guest can always observe that our GICv3 is SRE==1
only.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 3129df9..40c3b4c 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -313,10 +313,8 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	 * Prevent the guest from touching the GIC system registers if
 	 * SRE isn't enabled for GICv3 emulation.
 	 */
-	if (!cpu_if->vgic_sre) {
-		write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
-			     ICC_SRE_EL2);
-	}
+	write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
+		     ICC_SRE_EL2);
 }
 
 void __hyp_text __vgic_v3_init_lrs(void)
-- 
2.1.4

