From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 15/15] KVM: arm64: Invoke FPSIMD context switch trap from C
Date: Tue,  8 May 2018 17:45:00 +0100
Message-ID: <1525797900-5548-16-git-send-email-Dave.Martin@arm.com>
References: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
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

The conversion of the FPSIMD context switch trap code to C has added
some overhead to calling it, due to the need to save registers that
the procedure call standard defines as caller-saved.

So, perhaps it is no longer worth invoking this trap handler quite
so early.

Instead, we can invoke it from fixup_guest_exit(), with little
likelihood of increasing the overhead much further.

As a convenience, this patch gives __hyp_switch_fpsimd() the same
return semantics fixup_guest_exit().  For now there is no
possibility of a spurious FPSIMD trap, so the function always
returns true, but this allows it to be tail-called with a single
return statement.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/entry.S     | 30 ------------------------------
 arch/arm64/kvm/hyp/hyp-entry.S | 19 -------------------
 arch/arm64/kvm/hyp/switch.c    | 15 +++++++++++++--
 3 files changed, 13 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 40f349b..fad1e16 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -166,33 +166,3 @@ abort_guest_exit_end:
 	orr	x0, x0, x5
 1:	ret
 ENDPROC(__guest_exit)
-
-ENTRY(__fpsimd_guest_restore)
-	// x0: esr
-	// x1: vcpu
-	// x2-x29,lr: vcpu regs
-	// vcpu x0-x1 on the stack
-	stp	x2, x3, [sp, #-144]!
-	stp	x4, x5, [sp, #16]
-	stp	x6, x7, [sp, #32]
-	stp	x8, x9, [sp, #48]
-	stp	x10, x11, [sp, #64]
-	stp	x12, x13, [sp, #80]
-	stp	x14, x15, [sp, #96]
-	stp	x16, x17, [sp, #112]
-	stp	x18, lr, [sp, #128]
-
-	bl	__hyp_switch_fpsimd
-
-	ldp	x4, x5, [sp, #16]
-	ldp	x6, x7, [sp, #32]
-	ldp	x8, x9, [sp, #48]
-	ldp	x10, x11, [sp, #64]
-	ldp	x12, x13, [sp, #80]
-	ldp	x14, x15, [sp, #96]
-	ldp	x16, x17, [sp, #112]
-	ldp	x18, lr, [sp, #128]
-	ldp	x0, x1, [sp, #144]
-	ldp	x2, x3, [sp], #160
-	eret
-ENDPROC(__fpsimd_guest_restore)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index bffece2..753b9d2 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -113,25 +113,6 @@ el1_hvc_guest:
 
 el1_trap:
 	get_vcpu_ptr	x1, x0
-
-	mrs		x0, esr_el2
-	lsr		x0, x0, #ESR_ELx_EC_SHIFT
-	/*
-	 * x0: ESR_EC
-	 * x1: vcpu pointer
-	 */
-
-	/*
-	 * We trap the first access to the FP/SIMD to save the host context
-	 * and restore the guest context lazily.
-	 * If FP/SIMD is not implemented, handle the trap and inject an
-	 * undefined instruction exception to the guest.
-	 */
-alternative_if_not ARM64_HAS_NO_FPSIMD
-	cmp	x0, #ESR_ELx_EC_FP_ASIMD
-	b.eq	__fpsimd_guest_restore
-alternative_else_nop_endif
-
 	mov	x0, #ARM_EXCEPTION_TRAP
 	b	__guest_exit
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 5be472d..6eeda72 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -327,8 +327,7 @@ static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
 	}
 }
 
-void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
-				    struct kvm_vcpu *vcpu)
+static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
 {
 	struct user_fpsimd_state *host_fpsimd = vcpu->arch.host_fpsimd_state;
 
@@ -368,6 +367,8 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 			     fpexc32_el2);
 
 	vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
+
+	return true;
 }
 
 /*
@@ -389,6 +390,16 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (*exit_code != ARM_EXCEPTION_TRAP)
 		goto exit;
 
+	/*
+	 * We trap the first access to the FP/SIMD to save the host context
+	 * and restore the guest context lazily.
+	 * If FP/SIMD is not implemented, handle the trap and inject an
+	 * undefined instruction exception to the guest.
+	 */
+	if (system_supports_fpsimd() &&
+	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_FP_ASIMD)
+		return __hyp_switch_fpsimd(vcpu);
+
 	if (!__populate_fault_info(vcpu))
 		return true;
 
-- 
2.1.4
