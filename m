From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 19/40] KVM: arm64: Introduce separate VHE/non-VHE sysreg save/restore functions
Date: Thu, 15 Feb 2018 22:03:11 +0100
Message-ID: <20180215210332.8648-20-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to handle system registers quite differently between VHE
and non-VHE systems.  In preparation for that, we need to split some of
the handling functions between VHE and non-VHE functionality.

For now, we simply copy the non-VHE functions, but we do change the use
of static keys for VHE and non-VHE functionality now that we have
separate functions.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 12 ++++++++----
 arch/arm64/kvm/hyp/switch.c      | 20 ++++++++++----------
 arch/arm64/kvm/hyp/sysreg-sr.c   | 40 ++++++++++++++++++++++++++++++++--------
 3 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index aeda2a777365..23c09d9af343 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -131,10 +131,14 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
 
-void __sysreg_save_host_state(struct kvm_cpu_context *ctxt);
-void __sysreg_restore_host_state(struct kvm_cpu_context *ctxt);
-void __sysreg_save_guest_state(struct kvm_cpu_context *ctxt);
-void __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt);
+void __sysreg_save_host_state_nvhe(struct kvm_cpu_context *ctxt);
+void __sysreg_restore_host_state_nvhe(struct kvm_cpu_context *ctxt);
+void __sysreg_save_guest_state_nvhe(struct kvm_cpu_context *ctxt);
+void __sysreg_restore_guest_state_nvhe(struct kvm_cpu_context *ctxt);
+void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt);
+void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt);
+void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt);
+void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
 void __sysreg32_save_state(struct kvm_vcpu *vcpu);
 void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index f0fae320edc0..717c8f5c6be7 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -373,7 +373,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	__sysreg_save_host_state(host_ctxt);
+	sysreg_save_host_state_vhe(host_ctxt);
 
 	__activate_traps(vcpu);
 	__activate_vm(vcpu->kvm);
@@ -385,7 +385,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
 	 */
 	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_guest_state(guest_ctxt);
+	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
 	do {
@@ -397,13 +397,13 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	fp_enabled = __fpsimd_enabled();
 
-	__sysreg_save_guest_state(guest_ctxt);
+	sysreg_save_guest_state_vhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
 
-	__sysreg_restore_host_state(host_ctxt);
+	sysreg_restore_host_state_vhe(host_ctxt);
 
 	if (fp_enabled) {
 		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
@@ -433,7 +433,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	__sysreg_save_host_state(host_ctxt);
+	__sysreg_save_host_state_nvhe(host_ctxt);
 
 	__activate_traps(vcpu);
 	__activate_vm(kern_hyp_va(vcpu->kvm));
@@ -446,7 +446,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
 	 */
 	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_guest_state(guest_ctxt);
+	__sysreg_restore_guest_state_nvhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
 	do {
@@ -466,7 +466,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 
 	fp_enabled = __fpsimd_enabled();
 
-	__sysreg_save_guest_state(guest_ctxt);
+	__sysreg_save_guest_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__vgic_save_state(vcpu);
@@ -474,7 +474,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__deactivate_traps(vcpu);
 	__deactivate_vm(vcpu);
 
-	__sysreg_restore_host_state(host_ctxt);
+	__sysreg_restore_host_state_nvhe(host_ctxt);
 
 	if (fp_enabled) {
 		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
@@ -504,7 +504,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
 		__deactivate_vm(vcpu);
-		__sysreg_restore_host_state(__host_ctxt);
+		__sysreg_restore_host_state_nvhe(__host_ctxt);
 	}
 
 	/*
@@ -527,7 +527,7 @@ static void __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
 	__deactivate_traps(vcpu);
-	__sysreg_restore_host_state(host_ctxt);
+	sysreg_restore_host_state_vhe(host_ctxt);
 
 	panic(__hyp_panic_string,
 	      spsr,  elr,
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 51b557226170..18801ab56e8b 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -78,15 +78,27 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 		ctxt->sys_regs[DISR_EL1] = read_sysreg_s(SYS_VDISR_EL2);
 }
 
-void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
+void __hyp_text __sysreg_save_host_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_save_el1_state(ctxt);
+	__sysreg_save_common_state(ctxt);
+	__sysreg_save_user_state(ctxt);
+}
+
+void __hyp_text __sysreg_save_guest_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_save_el1_state(ctxt);
+	__sysreg_save_common_state(ctxt);
+	__sysreg_save_user_state(ctxt);
+}
+
+void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
 {
-	if (!has_vhe())
-		__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
 	__sysreg_save_user_state(ctxt);
 }
 
-void __hyp_text __sysreg_save_guest_state(struct kvm_cpu_context *ctxt)
+void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
@@ -142,15 +154,27 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_s(ctxt->sys_regs[DISR_EL1], SYS_VDISR_EL2);
 }
 
-void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
+void __hyp_text __sysreg_restore_host_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_el1_state(ctxt);
+	__sysreg_restore_common_state(ctxt);
+	__sysreg_restore_user_state(ctxt);
+}
+
+void __hyp_text __sysreg_restore_guest_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_el1_state(ctxt);
+	__sysreg_restore_common_state(ctxt);
+	__sysreg_restore_user_state(ctxt);
+}
+
+void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
 {
-	if (!has_vhe())
-		__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
 }
 
-void __hyp_text __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt)
+void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
-- 
2.14.2
