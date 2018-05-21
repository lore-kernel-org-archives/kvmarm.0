From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v9 15/16] KVM: arm64: Fold redundant exit code checks out of
 fixup_guest_exit()
Date: Mon, 21 May 2018 15:17:16 +0100
Message-ID: <1526912237-25308-16-git-send-email-Dave.Martin@arm.com>
References: <1526912237-25308-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1526912237-25308-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
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
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 18d0faa..4fbee95 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -387,11 +387,13 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
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
@@ -417,11 +419,12 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
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
@@ -430,6 +433,7 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			return true;
 	}
 
+exit:
 	/* Return to the host kernel and handle the exit */
 	return false;
 }
-- 
2.1.4
