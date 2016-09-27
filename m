From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 18/50] arm64: KVM: Preserve pending vSError in world switch
Date: Tue, 27 Sep 2016 20:05:26 +0200
Message-ID: <20160927180558.14699-19-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B453249BA7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kb6y98YJhZhJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:42 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 676F349B9A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:41 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id 197so30492590wmk.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:04 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The HCR_EL2.VSE bit is used to signal an SError to a guest, and has
the peculiar feature of getting cleared when the guest has taken
the abort (this is the only bit that behaves as such in this register).

This means that if we signal such an abort, we must leave it
in the guest context until it disappears from HCR_EL2, and at which
point it must be cleared from the context. This is achieved by
reading back from HCR_EL2 until the guest takes the fault.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/switch.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index b3a66c5..8246de2 100644
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
2.9.0
