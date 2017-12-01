From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 1/3] arm64: KVM: Move CPU ID reg trap setup off the world
 switch path
Date: Fri,  1 Dec 2017 15:19:40 +0000
Message-ID: <1512141582-17474-2-git-send-email-Dave.Martin@arm.com>
References: <1512141582-17474-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7731B49D19
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Dec 2017 10:16:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NMxXYhIZuzIQ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Dec 2017 10:16:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5620549D6A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Dec 2017 10:16:53 -0500 (EST)
In-Reply-To: <1512141582-17474-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The HCR_EL2.TID3 flag needs to be set when trapping guest access to
the CPU ID registers is required.  However, the decision about
whether to set this bit does not need to be repeated at every
switch to the guest.

Instead, it's sufficient to make this decision once and record the
outcome.

This patch moves the decision to vcpu_reset_hcr() and records the
choice made in vcpu->arch.hcr_el2.  The world switch code can then
load this directly when switching to the guest without the need for
conditional logic on the critical path.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Suggested-by: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>

---

Note to maintainers: this was discussed on-list [1] prior to the merge
window, but this patch implementing the agreed decision hasn't been
posted previously.

This should be considered a fix for v4.15.

[1] [PATCH v3 02/28] arm64: KVM: Hide unsupported AArch64 CPU features from guests
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-October/537420.html
---
 arch/arm64/include/asm/kvm_emulate.h | 8 ++++++++
 arch/arm64/kvm/hyp/switch.c          | 4 ----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5f28dfa..8ff5aef 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -52,6 +52,14 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_E2H;
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
+
+	/*
+	 * TID3: trap feature register accesses that we virtualise.
+	 * For now this is conditional, since no AArch32 feature regs
+	 * are currently virtualised.
+	 */
+	if (vcpu->arch.hcr_el2 & HCR_RW)
+		vcpu->arch.hcr_el2 |= HCR_TID3;
 }
 
 static inline unsigned long vcpu_get_hcr(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 525c01f..87fd590 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -86,10 +86,6 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 		write_sysreg(1 << 30, fpexc32_el2);
 		isb();
 	}
-
-	if (val & HCR_RW) /* for AArch64 only: */
-		val |= HCR_TID3; /* TID3: trap feature register accesses */
-
 	write_sysreg(val, hcr_el2);
 
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
-- 
2.1.4
