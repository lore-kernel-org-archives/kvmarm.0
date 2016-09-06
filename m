From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/19] arm: KVM: Preserve pending Virtual Abort in world switch
Date: Tue,  6 Sep 2016 14:02:08 +0100
Message-ID: <1473166937-15271-11-git-send-email-marc.zyngier@arm.com>
References: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The HCR.VA bit is used to signal an Abort to a guest, and has
the peculiar feature of getting cleared when the guest has taken
the abort (this is the only bit that behaves as such in this register).

This means that if we signal such an abort, we must leave it in
the guest context until it disappears from HCR, and at which point
it must be cleared from the context.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/switch.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index b13caa9..8cda887 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -54,6 +54,15 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 {
 	u32 val;
 
+	/*
+	 * If we pended a virtual abort, preserve it until it gets
+	 * cleared. See B1.9.9 (Virtual Abort exception) for details,
+	 * but the crucial bit is the zeroing of HCR.VA in the
+	 * pseudocode.
+	 */
+	if (vcpu->arch.hcr & HCR_VA)
+		vcpu->arch.hcr = read_sysreg(HCR);
+
 	write_sysreg(0, HCR);
 	write_sysreg(0, HSTR);
 	val = read_sysreg(HDCR);
-- 
2.1.4

