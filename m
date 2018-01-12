From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 13/41] KVM: arm64: Factor out fault info population and gic
 workarounds
Date: Fri, 12 Jan 2018 13:07:19 +0100
Message-ID: <20180112120747.27999-14-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 657EC49DEA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vn22jCfbFcMi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 07:03:25 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA72749DF2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:21 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id i186so11586420wmi.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 04:08:12 -0800 (PST)
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The current world-switch function has functionality to detect a number
of cases where we need to fixup some part of the exit condition and
possibly run the guest again, before having restored the host state.

This includes populating missing fault info, emulating GICv2 CPU
interface accesses when mapped at unaligned addresses, and emulating
the GICv3 CPU interface on systems that need it.

As we are about to have an alternative switch function for VHE systems,
but VHE systems still need the same early fixup logic, factor out this
logic into a separate function that can be shared by both switch
functions.

No functional change.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/switch.c | 99 ++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 63284647ed11..55ca2e3d42eb 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -270,50 +270,24 @@ static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
 	}
 }
 
-int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+/*
+ * Return true when we were able to fixup the guest exit and should return to
+ * the guest, false when we should restore the host state and return to the
+ * main run loop.
+ */
+static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	struct kvm_cpu_context *host_ctxt;
-	struct kvm_cpu_context *guest_ctxt;
-	u64 exit_code;
-
-	vcpu = kern_hyp_va(vcpu);
-
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
-	host_ctxt->__hyp_running_vcpu = vcpu;
-	guest_ctxt = &vcpu->arch.ctxt;
-
-	__sysreg_save_host_state(host_ctxt);
-
-	__activate_traps(vcpu);
-	__activate_vm(vcpu);
-
-	__vgic_restore_state(vcpu);
-	__timer_enable_traps(vcpu);
-
-	/*
-	 * We must restore the 32-bit state before the sysregs, thanks
-	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
-	 */
-	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_guest_state(guest_ctxt);
-	__debug_switch_to_guest(vcpu);
-
-	/* Jump in the fire! */
-again:
-	exit_code = __guest_enter(vcpu, host_ctxt);
-	/* And we're baaack! */
-
 	/*
 	 * We're using the raw exception code in order to only process
 	 * the trap if no SError is pending. We will come back to the
 	 * same PC once the SError has been injected, and replay the
 	 * trapping instruction.
 	 */
-	if (exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
-		goto again;
+	if (*exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
+		return true;
 
 	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
-	    exit_code == ARM_EXCEPTION_TRAP) {
+	    *exit_code == ARM_EXCEPTION_TRAP) {
 		bool valid;
 
 		valid = kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW &&
@@ -327,9 +301,9 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 			if (ret == 1) {
 				if (__skip_instr(vcpu))
-					goto again;
+					return true;
 				else
-					exit_code = ARM_EXCEPTION_TRAP;
+					*exit_code = ARM_EXCEPTION_TRAP;
 			}
 
 			if (ret == -1) {
@@ -341,29 +315,64 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 				 */
 				if (!__skip_instr(vcpu))
 					*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
-				exit_code = ARM_EXCEPTION_EL1_SERROR;
+				*exit_code = ARM_EXCEPTION_EL1_SERROR;
 			}
-
-			/* 0 falls through to be handler out of EL2 */
 		}
 	}
 
 	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
-	    exit_code == ARM_EXCEPTION_TRAP &&
+	    *exit_code == ARM_EXCEPTION_TRAP &&
 	    (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 ||
 	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_CP15_32)) {
 		int ret = __vgic_v3_perform_cpuif_access(vcpu);
 
 		if (ret == 1) {
 			if (__skip_instr(vcpu))
-				goto again;
+				return true;
 			else
-				exit_code = ARM_EXCEPTION_TRAP;
+				*exit_code = ARM_EXCEPTION_TRAP;
 		}
-
-		/* 0 falls through to be handled out of EL2 */
 	}
 
+	/* Return to the host kernel and handle the exit */
+	return false;
+}
+
+int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
+	u64 exit_code;
+
+	vcpu = kern_hyp_va(vcpu);
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	host_ctxt->__hyp_running_vcpu = vcpu;
+	guest_ctxt = &vcpu->arch.ctxt;
+
+	__sysreg_save_host_state(host_ctxt);
+
+	__activate_traps(vcpu);
+	__activate_vm(vcpu);
+
+	__vgic_restore_state(vcpu);
+	__timer_enable_traps(vcpu);
+
+	/*
+	 * We must restore the 32-bit state before the sysregs, thanks
+	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
+	 */
+	__sysreg32_restore_state(vcpu);
+	__sysreg_restore_guest_state(guest_ctxt);
+	__debug_switch_to_guest(vcpu);
+
+	do {
+		/* Jump in the fire! */
+		exit_code = __guest_enter(vcpu, host_ctxt);
+
+		/* And we're baaack! */
+	} while (fixup_guest_exit(vcpu, &exit_code));
+
 	__sysreg_save_guest_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
-- 
2.14.2
