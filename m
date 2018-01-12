From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 09/41] KVM: arm64: Defer restoring host VFP state to vcpu_put
Date: Fri, 12 Jan 2018 13:07:15 +0100
Message-ID: <20180112120747.27999-10-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Avoid saving the guest VFP registers and restoring the host VFP
registers on every exit from the VM.  Only when we're about to run
userspace or other threads in the kernel do we really have to switch the
state back to the host state.

We still initially configure the VFP registers to trap when entering the
VM, but the difference is that we now leave the guest state in the
hardware registers as long as we're running this VCPU, even if we
occasionally trap to the host, and we only restore the host state when
we return to user space or when scheduling another thread.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kernel/asm-offsets.c   |  1 +
 arch/arm64/kvm/hyp/entry.S        |  3 +++
 arch/arm64/kvm/hyp/switch.c       | 48 ++++++++++++---------------------------
 arch/arm64/kvm/hyp/sysreg-sr.c    | 21 ++++++++++++++---
 5 files changed, 40 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0e9e7291a7e6..9e23bc968668 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -213,6 +213,9 @@ struct kvm_vcpu_arch {
 	/* Guest debug state */
 	u64 debug_flags;
 
+	/* 1 if the guest VFP state is loaded into the hardware */
+	u8 guest_vfp_loaded;
+
 	/*
 	 * We maintain more than a single set of debug registers to support
 	 * debugging the guest from the host and to maintain separate host and
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 612021dce84f..99467327c043 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -133,6 +133,7 @@ int main(void)
   DEFINE(CPU_GP_REGS,		offsetof(struct kvm_cpu_context, gp_regs));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
   DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
+  DEFINE(VCPU_GUEST_VFP_LOADED,	offsetof(struct kvm_vcpu, arch.guest_vfp_loaded));
   DEFINE(VCPU_FPEXC32_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
   DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
   DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index a360ac6e89e9..53652287a236 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -184,6 +184,9 @@ alternative_endif
 	add	x0, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
 	bl	__fpsimd_restore_state
 
+	mov	x0, #1
+	strb	w0, [x3, #VCPU_GUEST_VFP_LOADED]
+
 	// Skip restoring fpexc32 for AArch64 guests
 	mrs	x1, hcr_el2
 	tbnz	x1, #HCR_RW_SHIFT, 1f
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 12dc647a6e5f..29e44a20f5e3 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -24,43 +24,32 @@
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 
-static bool __hyp_text __fpsimd_enabled_nvhe(void)
-{
-	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
-}
-
-static bool __hyp_text __fpsimd_enabled_vhe(void)
-{
-	return !!(read_sysreg(cpacr_el1) & CPACR_EL1_FPEN);
-}
-
-static hyp_alternate_select(__fpsimd_is_enabled,
-			    __fpsimd_enabled_nvhe, __fpsimd_enabled_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
-
-bool __hyp_text __fpsimd_enabled(void)
-{
-	return __fpsimd_is_enabled()();
-}
-
-static void __hyp_text __activate_traps_vhe(void)
+static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
-	val &= ~(CPACR_EL1_FPEN | CPACR_EL1_ZEN);
+	val &= ~CPACR_EL1_ZEN;
+	if (vcpu->arch.guest_vfp_loaded)
+		val |= CPACR_EL1_FPEN;
+	else
+		val &= ~CPACR_EL1_FPEN;
 	write_sysreg(val, cpacr_el1);
 
 	write_sysreg(__kvm_hyp_vector, vbar_el1);
 }
 
-static void __hyp_text __activate_traps_nvhe(void)
+static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
 	val = CPTR_EL2_DEFAULT;
-	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
+	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
+	if (vcpu->arch.guest_vfp_loaded)
+		val &= ~CPTR_EL2_TFP;
+	else
+		val |= CPTR_EL2_TFP;
 	write_sysreg(val, cptr_el2);
 }
 
@@ -79,7 +68,8 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	 * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
 	 * it will cause an exception.
 	 */
-	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd()) {
+	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd() &&
+	    !vcpu->arch.guest_vfp_loaded) {
 		write_sysreg(1 << 30, fpexc32_el2);
 		isb();
 	}
@@ -96,7 +86,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(0, pmselr_el0);
 	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
-	__activate_traps_arch()();
+	__activate_traps_arch()(vcpu);
 }
 
 static void __hyp_text __deactivate_traps_vhe(void)
@@ -284,7 +274,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
-	bool fp_enabled;
 	u64 exit_code;
 
 	vcpu = kern_hyp_va(vcpu);
@@ -376,8 +365,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* 0 falls through to be handled out of EL2 */
 	}
 
-	fp_enabled = __fpsimd_enabled();
-
 	__sysreg_save_guest_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
@@ -388,11 +375,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_host_state(host_ctxt);
 
-	if (fp_enabled) {
-		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
-		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
-	}
-
 	__debug_save_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 883a6383cd36..848a46eb33bf 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -138,6 +138,11 @@ void __hyp_text __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt)
 	__sysreg_restore_common_state(ctxt);
 }
 
+static void __hyp_text __fpsimd32_save_state(struct kvm_cpu_context *ctxt)
+{
+	ctxt->sys_regs[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
+}
+
 void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
@@ -156,9 +161,6 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	sysreg[DACR32_EL2] = read_sysreg(dacr32_el2);
 	sysreg[IFSR32_EL2] = read_sysreg(ifsr32_el2);
 
-	if (__fpsimd_enabled())
-		sysreg[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
-
 	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
 		sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
 }
@@ -213,6 +215,19 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+
+	/* Restore host FP/SIMD state */
+	if (vcpu->arch.guest_vfp_loaded) {
+		if (vcpu_el1_is_32bit(vcpu)) {
+			kvm_call_hyp(__fpsimd32_save_state,
+				     kern_hyp_va(guest_ctxt));
+		}
+		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
+		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
+		vcpu->arch.guest_vfp_loaded = 0;
+	}
 }
 
 void __hyp_text __kvm_set_tpidr_el2(u64 tpidr_el2)
-- 
2.14.2
