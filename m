From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 09/12] KVM: arm: vgic: Drop useless Group0 warning
Date: Fri, 19 Jun 2015 13:53:13 +0100
Message-ID: <1434718396-13110-10-git-send-email-marc.zyngier@arm.com>
References: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43A4556186
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 08:43:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MnGExuYGQ1sz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jun 2015 08:43:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16840561A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 08:43:15 -0400 (EDT)
In-Reply-To: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, Firo Yang <firogm@gmail.com>, Tiejun Chen <tiejun.chen@intel.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

If a GICv3-enabled guest tries to configure Group0, we print a
warning on the console (because we don't support Group0 interrupts).

This is fairly pointless, and would allow a guest to spam the
console. Let's just drop the warning.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic-v3-emul.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 2b369de..e661e7f 100644
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
