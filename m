From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 6/7] arm64: KVM: vgic-v3: Prevent the guest from messing
 with ICC_SRE_EL1
Date: Wed, 25 May 2016 15:26:38 +0100
Message-ID: <1464186399-16604-7-git-send-email-marc.zyngier@arm.com>
References: <1464186399-16604-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8B9949B36
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2016 10:23:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JO070v9EK8mH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2016 10:23:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A300349B67
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2016 10:23:22 -0400 (EDT)
In-Reply-To: <1464186399-16604-1-git-send-email-marc.zyngier@arm.com>
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
