From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 13/27] KVM: arm64/sve: Context switch the SVE registers
Date: Tue, 19 Mar 2019 17:52:04 +0000
Message-ID: <1553017938-710-14-git-send-email-Dave.Martin@arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3EE54A4BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 53LdQqtQ3ypI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Mar 2019 13:53:35 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A9614A4DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:34 -0400 (EDT)
In-Reply-To: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to give each vcpu its own view of the SVE registers, this
patch adds context storage via a new sve_state pointer in struct
vcpu_arch.  An additional member sve_max_vl is also added for each
vcpu, to determine the maximum vector length visible to the guest
and thus the value to be configured in ZCR_EL2.LEN while the vcpu
is active.  This also determines the layout and size of the storage
in sve_state, which is read and written by the same backend
functions that are used for context-switching the SVE state for
host tasks.

On SVE-enabled vcpus, SVE access traps are now handled by switching
in the vcpu's SVE context and disabling the trap before returning
to the guest.  On other vcpus, the trap is not handled and an exit
back to the host occurs, where the handle_sve() fallback path
reflects an undefined instruction exception back to the guest,
consistently with the behaviour of non-SVE-capable hardware (as was
done unconditionally prior to this patch).

No SVE handling is added on non-VHE-only paths, since VHE is an
architectural and Kconfig prerequisite of SVE.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Changes since v5:

 * [Julien Thierry, Julien Grall] Commit message typo fixes

 * [Mark Rutland] Rename trap_class to hsr_ec, for consistency with
   existing code.

 * [Mark Rutland] Simplify condition for refusing to handle an
   FPSIMD/SVE trap, using multiple if () statements for clarity.  The
   previous condition was a bit tortuous, and how that the static_key
   checks have been hoisted out, it makes little difference to the
   compiler how we express the condition here.
---
 arch/arm64/include/asm/kvm_host.h |  6 ++++
 arch/arm64/kvm/fpsimd.c           |  5 +--
 arch/arm64/kvm/hyp/switch.c       | 75 +++++++++++++++++++++++++++++----------
 3 files changed, 66 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 22cf484..4fabfd2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -228,6 +228,8 @@ struct vcpu_reset_state {
 
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
+	void *sve_state;
+	unsigned int sve_max_vl;
 
 	/* HYP configuration */
 	u64 hcr_el2;
@@ -323,6 +325,10 @@ struct kvm_vcpu_arch {
 	bool sysregs_loaded_on_cpu;
 };
 
+/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
+#define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) + \
+				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
+
 /* vcpu_arch flags field values: */
 #define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
 #define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 7053bf4..6e3c9c8 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -87,10 +87,11 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
 		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs,
-					 NULL, SVE_VL_MIN);
+					 vcpu->arch.sve_state,
+					 vcpu->arch.sve_max_vl);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
-		clear_thread_flag(TIF_SVE);
+		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 9d46066..5444b9c 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -100,7 +100,10 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
 	val &= ~CPACR_EL1_ZEN;
-	if (!update_fp_enabled(vcpu)) {
+	if (update_fp_enabled(vcpu)) {
+		if (vcpu_has_sve(vcpu))
+			val |= CPACR_EL1_ZEN;
+	} else {
 		val &= ~CPACR_EL1_FPEN;
 		__activate_traps_fpsimd32(vcpu);
 	}
@@ -317,16 +320,48 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
+/* Check for an FPSIMD/SVE trap and handle as appropriate */
+static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
-	struct user_fpsimd_state *host_fpsimd = vcpu->arch.host_fpsimd_state;
+	bool vhe, sve_guest, sve_host;
+	u8 hsr_ec;
 
-	if (has_vhe())
-		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
-			     cpacr_el1);
-	else
+	if (!system_supports_fpsimd())
+		return false;
+
+	if (system_supports_sve()) {
+		sve_guest = vcpu_has_sve(vcpu);
+		sve_host = vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE;
+		vhe = true;
+	} else {
+		sve_guest = false;
+		sve_host = false;
+		vhe = has_vhe();
+	}
+
+	hsr_ec = kvm_vcpu_trap_get_class(vcpu);
+	if (hsr_ec != ESR_ELx_EC_FP_ASIMD &&
+	    hsr_ec != ESR_ELx_EC_SVE)
+		return false;
+
+	/* Don't handle SVE traps for non-SVE vcpus here: */
+	if (!sve_guest)
+		if (hsr_ec != ESR_ELx_EC_FP_ASIMD)
+			return false;
+
+	/* Valid trap.  Switch the context: */
+
+	if (vhe) {
+		u64 reg = read_sysreg(cpacr_el1) | CPACR_EL1_FPEN;
+
+		if (sve_guest)
+			reg |= CPACR_EL1_ZEN;
+
+		write_sysreg(reg, cpacr_el1);
+	} else {
 		write_sysreg(read_sysreg(cptr_el2) & ~(u64)CPTR_EL2_TFP,
 			     cptr_el2);
+	}
 
 	isb();
 
@@ -335,24 +370,28 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
 		 * In the SVE case, VHE is assumed: it is enforced by
 		 * Kconfig and kvm_arch_init().
 		 */
-		if (system_supports_sve() &&
-		    (vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE)) {
+		if (sve_host) {
 			struct thread_struct *thread = container_of(
-				host_fpsimd,
+				vcpu->arch.host_fpsimd_state,
 				struct thread_struct, uw.fpsimd_state);
 
-			sve_save_state(sve_pffr(thread), &host_fpsimd->fpsr);
+			sve_save_state(sve_pffr(thread),
+				       &vcpu->arch.host_fpsimd_state->fpsr);
 		} else {
-			__fpsimd_save_state(host_fpsimd);
+			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
 		}
 
 		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
 	}
 
-	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
-
-	if (vcpu_has_sve(vcpu))
+	if (sve_guest) {
+		sve_load_state(vcpu_sve_pffr(vcpu),
+			       &vcpu->arch.ctxt.gp_regs.fp_regs.fpsr,
+			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
 		write_sysreg_s(vcpu->arch.ctxt.sys_regs[ZCR_EL1], SYS_ZCR_EL12);
+	} else {
+		__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
+	}
 
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
@@ -388,10 +427,10 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * and restore the guest context lazily.
 	 * If FP/SIMD is not implemented, handle the trap and inject an
 	 * undefined instruction exception to the guest.
+	 * Similarly for trapped SVE accesses.
 	 */
-	if (system_supports_fpsimd() &&
-	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_FP_ASIMD)
-		return __hyp_switch_fpsimd(vcpu);
+	if (__hyp_handle_fpsimd(vcpu))
+		return true;
 
 	if (!__populate_fault_info(vcpu))
 		return true;
-- 
2.1.4
