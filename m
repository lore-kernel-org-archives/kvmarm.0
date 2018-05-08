From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 14/15] KVM: arm64: Fold redundant exit code checks out of
 fixup_guest_exit()
Date: Tue,  8 May 2018 17:44:59 +0100
Message-ID: <1525797900-5548-15-git-send-email-Dave.Martin@arm.com>
References: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C91B400D4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 May 2018 12:36:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JXLgZYjVTHrU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 May 2018 12:36:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF8904A0E2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 May 2018 12:36:07 -0400 (EDT)
In-Reply-To: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The entire tail of fixup_guest_exit() is contained in if statements
of the form if (x && *exit_code == ARM_EXCEPTION_TRAP).  As a result,
we can check just once and bail out of the function early, allowing
the remaining if conditions to be simplified.

The only awkward case is where *exit_code is changed to
ARM_EXCEPTION_EL1_SERROR in the case of an illegal GICv2 CPU
interface access: in that case, the GICv3 trap handling code is
skipped using a goto.  This avoids pointlessly evaluating the
static branch check for the GICv3 case, even though we can't have
vgic_v2_cpuif_trap and vgic_v3_cpuif_trap true simultaneously
unless we have a GICv3 and GICv2 on the host: that sounds stupid,
but I haven't satisfied myself that it can't happen.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Changes since v5:

Requested by Marc Zyngier:

 * Move "goto exit" to the end of the data abort handling code under
   gicv2 cpuif trap handling, since the gicv3-specific handling is only
   for sysreg traps.
---
 arch/arm64/kvm/hyp/switch.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 21e5543..5be472d 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -386,11 +386,13 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * same PC once the SError has been injected, and replay the
 	 * trapping instruction.
 	 */
-	if (*exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
+	if (*exit_code != ARM_EXCEPTION_TRAP)
+		goto exit;
+
+	if (!__populate_fault_info(vcpu))
 		return true;
 
-	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
-	    *exit_code == ARM_EXCEPTION_TRAP) {
+	if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
 		bool valid;
 
 		valid = kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW &&
@@ -416,11 +418,12 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 					*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
 				*exit_code = ARM_EXCEPTION_EL1_SERROR;
 			}
+
+			goto exit;
 		}
 	}
 
 	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
-	    *exit_code == ARM_EXCEPTION_TRAP &&
 	    (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 ||
 	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_CP15_32)) {
 		int ret = __vgic_v3_perform_cpuif_access(vcpu);
@@ -429,6 +432,7 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			return true;
 	}
 
+exit:
 	/* Return to the host kernel and handle the exit */
 	return false;
 }
-- 
2.1.4
