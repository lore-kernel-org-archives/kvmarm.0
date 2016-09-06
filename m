From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/19] arm64: KVM: Preserve pending vSError in world switch
Date: Tue,  6 Sep 2016 14:02:00 +0100
Message-ID: <1473166937-15271-3-git-send-email-marc.zyngier@arm.com>
References: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B575E49B5B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:54:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Sy28z4HpetV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 08:54:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B34249B5D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:54:01 -0400 (EDT)
In-Reply-To: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The HCR_EL2.VSE bit is used to signal an SError to a guest, and has
the peculiar feature of getting cleared when the guest has taken
the abort (this is the only bit that behaves as such in this register).

This means that if we signal such an abort, we must leave it
in the guest context until it disappears from HCR_EL2, and at which
point it must be cleared from the context. This is achieved by
reading back from HCR_EL2 until the guest takes the fault.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index fcb7aae..5148b06 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -110,6 +110,15 @@ static hyp_alternate_select(__deactivate_traps_arch,
 
 static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * If we pended a virtual abort, preserve it until it gets
+	 * cleared. See D1.14.3 (Virtual Interrupts) for details, but
+	 * the crucial bit is "On taking a vSError interrupt,
+	 * HCR_EL2.VSE is cleared to 0."
+	 */
+	if (vcpu->arch.hcr_el2 & HCR_VSE)
+		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
+
 	__deactivate_traps_arch()();
 	write_sysreg(0, hstr_el2);
 	write_sysreg(read_sysreg(mdcr_el2) & MDCR_EL2_HPMN_MASK, mdcr_el2);
-- 
2.1.4
