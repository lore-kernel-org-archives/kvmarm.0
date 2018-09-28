From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v2 13/23] KVM: arm64/sve: Context switch the SVE registers
Date: Fri, 28 Sep 2018 14:39:17 +0100
Message-ID: <1538141967-15375-14-git-send-email-Dave.Martin@arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 340C34A1E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J3eSUag1aqpp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Sep 2018 09:40:42 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 398D24A21E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:41 -0400 (EDT)
In-Reply-To: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to give each vcpu its own view of the SVE registers, this
patch adds context storage via a new sve_state pointer in struct
vcpu_arch.  An additional member sve_max_vl is also added for each
vcpu, to determine the maximum vector length visible to the guest
and thus the value to be configured in ZCR_EL2.LEN while the is
active.  This also determines the layout and size of the storage in
sve_state, which is read and written by the same backend functions
that are used for context-switching the SVE state for host tasks.

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

Changes since RFCv1:

 * Add a if_sve () helper macro to efficiently skip or optimise out
   SVE conditional support code for the SVE-unsupported case.  This
   reduces the verbose boilerplate at the affected sites.

 * In the style of sve_pffr(), a vcpu_sve_pffr() helper is added to
   provide the FFR anchor pointer for sve_load_state() in the hyp switch
   code.   This help avoid some open-coded pointer mungeing which is not
   very readable.

 * The condition for calling __hyp_switch_fpsimd() is abstracted for
   better readability.
---
 arch/arm64/include/asm/kvm_host.h |  6 ++++
 arch/arm64/kvm/fpsimd.c           |  5 +--
 arch/arm64/kvm/hyp/switch.c       | 71 ++++++++++++++++++++++++++++++---------
 3 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 76cbb95e..8e9cd43 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -210,6 +210,8 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
 
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
+	void *sve_state;
+	unsigned int sve_max_vl;
 
 	/* HYP configuration */
 	u64 hcr_el2;
@@ -302,6 +304,10 @@ struct kvm_vcpu_arch {
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
index 29e5585..3474388 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -86,10 +86,11 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
 		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs,
-					 NULL, sve_max_vl);
+					 vcpu->arch.sve_state,
+					 vcpu->arch.sve_max_vl);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
-		clear_thread_flag(TIF_SVE);
+		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 085ed06..9941349 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -98,7 +98,10 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
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
@@ -332,16 +335,29 @@ static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
 	}
 }
 
-static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
+/*
+ * if () with a gating check for SVE support to minimise branch
+ * mispredictions in non-SVE systems.
+ * (system_supports_sve() is resolved at build time or via a static key.)
+ */
+#define if_sve(cond) if (system_supports_sve() && (cond))
+
+static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu,
+					   bool guest_has_sve)
 {
 	struct user_fpsimd_state *host_fpsimd = vcpu->arch.host_fpsimd_state;
 
-	if (has_vhe())
-		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
-			     cpacr_el1);
-	else
+	if (has_vhe()) {
+		u64 reg = read_sysreg(cpacr_el1) | CPACR_EL1_FPEN;
+
+		if_sve (guest_has_sve)
+			reg |= CPACR_EL1_ZEN;
+
+		write_sysreg(reg, cpacr_el1);
+	} else {
 		write_sysreg(read_sysreg(cptr_el2) & ~(u64)CPTR_EL2_TFP,
 			     cptr_el2);
+	}
 
 	isb();
 
@@ -350,8 +366,7 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
 		 * In the SVE case, VHE is assumed: it is enforced by
 		 * Kconfig and kvm_arch_init().
 		 */
-		if (system_supports_sve() &&
-		    (vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE)) {
+		if_sve (vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE) {
 			struct thread_struct *thread = container_of(
 				host_fpsimd,
 				struct thread_struct, uw.fpsimd_state);
@@ -364,11 +379,14 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
 		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
 	}
 
-	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
-
-	if (system_supports_sve() &&
-	    vcpu->arch.flags & KVM_ARM64_GUEST_HAS_SVE)
+	if_sve (guest_has_sve) {
+		sve_load_state(vcpu_sve_pffr(vcpu),
+			       &vcpu->arch.ctxt.gp_regs.fp_regs.fpsr,
+			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
 		write_sysreg_s(vcpu->arch.ctxt.sys_regs[ZCR_EL1], SYS_ZCR_EL12);
+	} else {
+		__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
+	}
 
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
@@ -380,6 +398,26 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static inline bool __hyp_text __hyp_trap_is_fpsimd(struct kvm_vcpu *vcpu,
+						   bool guest_has_sve)
+{
+
+	u8 trap_class;
+
+	if (!system_supports_fpsimd())
+		return false;
+
+	trap_class = kvm_vcpu_trap_get_class(vcpu);
+
+	if (trap_class == ESR_ELx_EC_FP_ASIMD)
+		return true;
+
+	if_sve (guest_has_sve && trap_class == ESR_ELx_EC_SVE)
+		return true;
+
+	return false;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -387,6 +425,8 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
  */
 static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	bool guest_has_sve;
+
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(esr);
 
@@ -404,10 +444,11 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * and restore the guest context lazily.
 	 * If FP/SIMD is not implemented, handle the trap and inject an
 	 * undefined instruction exception to the guest.
+	 * Similarly for trapped SVE accesses.
 	 */
-	if (system_supports_fpsimd() &&
-	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_FP_ASIMD)
-		return __hyp_switch_fpsimd(vcpu);
+	guest_has_sve = vcpu_has_sve(vcpu);
+	if (__hyp_trap_is_fpsimd(vcpu, guest_has_sve))
+		return __hyp_switch_fpsimd(vcpu, guest_has_sve);
 
 	if (!__populate_fault_info(vcpu))
 		return true;
-- 
2.1.4
