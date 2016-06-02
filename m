From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 6/8] arm64: KVM: vgic-v3: Prevent the guest from messing with
 ICC_SRE_EL1
Date: Thu,  2 Jun 2016 12:20:58 +0200
Message-ID: <1464862860-1183-7-git-send-email-christoffer.dall@linaro.org>
References: <1464862860-1183-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55FAE410EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2016 06:17:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NTRLJWFakQ80 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2016 06:17:21 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FE93412DD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2016 06:17:21 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id z87so63395602wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jun 2016 03:21:19 -0700 (PDT)
In-Reply-To: <1464862860-1183-1-git-send-email-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

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

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
2.1.2.330.g565301e.dirty
